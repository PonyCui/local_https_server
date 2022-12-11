import 'package:flutter/material.dart';
import 'package:local_https_server/services/bucket.dart';
import 'package:local_https_server/services/bucket_manager.dart';

class BucketListPage extends StatefulWidget {
  const BucketListPage({super.key});

  @override
  State<BucketListPage> createState() => _BucketListPageState();
}

class _BucketListPageState extends State<BucketListPage> {
  final bucketManager = BucketManager.shared;

  @override
  void dispose() {
    bucketManager.removeListener(onBucketManagerUpdate);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bucketManager.addListener(onBucketManagerUpdate);
  }

  void onBucketManagerUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bucket List'),
        actions: [
          MaterialButton(
            child: const Icon(
              Icons.add,
              size: 24,
              color: Colors.white,
            ),
            onPressed: () {
              _onAddBucketButtonPressed();
            },
          ),
        ],
      ),
      body: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          childAspectRatio: 2.0,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: ((context, index) {
          final bucket = bucketManager
              .buckets[bucketManager.buckets.keys.elementAt(index)]!;
          return _renderBucketItem(bucket);
        }),
        itemCount: bucketManager.buckets.keys.length,
      ),
    );
  }

  void _onAddBucketButtonPressed() {
    final bucketKeyController = TextEditingController();
    final bucketPathController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Bucket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Bucket Key'),
                controller: bucketKeyController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Bucket Path'),
                controller: bucketPathController,
              ),
            ],
          ),
          actions: [
            MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                if (bucketKeyController.text.isEmpty ||
                    bucketPathController.text.isEmpty) {
                  return;
                }
                bucketManager.addBucket(Bucket(
                    bucketKey: bucketKeyController.text,
                    bucketPath: bucketPathController.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Card _renderBucketItem(Bucket bucket) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  bucket.bucketKey,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: 0,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 18,
                  ),
                  onPressed: () {
                    bucketManager.removeBucket(bucket);
                  },
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              bucket.bucketPath,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
