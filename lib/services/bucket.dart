class Bucket {
  String bucketKey;
  String bucketPath;

  Bucket({required this.bucketKey, required this.bucketPath});

  static Bucket? fromJson(Map value) {
    final bucketKey = value['bucketKey'];
    final bucketPath = value['bucketPath'];
    if (bucketKey is String && bucketPath is String) {
      return Bucket(bucketKey: bucketKey, bucketPath: bucketPath);
    }
    return null;
  }

  toJson() {
    return {'bucketKey': bucketKey, 'bucketPath': bucketPath};
  }
}
