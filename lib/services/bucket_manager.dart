import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_https_server/services/bucket.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bucketsPreferenceKey = "BucketManager.buckets";

class BucketManager extends ChangeNotifier {
  static final shared = BucketManager();

  final buckets = <String, Bucket>{};
  SharedPreferences? _sp;

  Future init() async {
    _sp = await SharedPreferences.getInstance();
    await read();
  }

  Future addBucket(Bucket bucket) async {
    buckets[bucket.bucketKey] = bucket;
    await save();
    notifyListeners();
  }

  Future removeBucket(Bucket bucket) async {
    buckets.remove(bucket.bucketKey);
    await save();
    notifyListeners();
  }

  Future read() async {
    if (_sp != null) {
      final data = _sp!.getString(bucketsPreferenceKey);
      if (data != null) {
        final arrData = json.decode(data);
        if (arrData is List) {
          for (var element in arrData) {
            final obj = Bucket.fromJson(element);
            if (obj != null) {
              buckets[obj.bucketKey] = obj;
            }
          }
        }
      }
    }
    notifyListeners();
  }

  Future save() async {
    final data = json.encode(buckets.values.map((e) => e.toJson()).toList());
    _sp?.setString(bucketsPreferenceKey, data);
  }
}
