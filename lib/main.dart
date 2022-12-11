import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_https_server/pages/bucket_list.dart';
import 'package:local_https_server/services/bucket_manager.dart';
import 'package:local_https_server/services/http_server.dart';

final appWebService = WebService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appWebService.init();
  await BucketManager.shared.init();
  appWebService.bucketManager = BucketManager.shared;
  await appWebService.start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Https Server',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const BucketListPage(),
    );
  }
}
