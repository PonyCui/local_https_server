import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_https_server/services/bucket_manager.dart';

class WebServerConfig {
  static String chainFile = 'assets/server.pem';
  static String privateKeyFile = 'assets/serverkey.pem';
  static int servePort = 8080;
}

class WebService {
  late HttpServer _httpServer;
  late BucketManager bucketManager;

  init() async {
    final context = SecurityContext();
    context.useCertificateChainBytes(
      (await rootBundle.loadString(WebServerConfig.chainFile)).codeUnits,
    );
    context.usePrivateKeyBytes(
      (await rootBundle.loadString(WebServerConfig.privateKeyFile)).codeUnits,
    );
    _httpServer = await HttpServer.bindSecure(
      '0.0.0.0',
      WebServerConfig.servePort,
      context,
    );
  }

  start() {
    _httpServer.listen((event) {
      event.response.headers
          .set('Access-Control-Allow-Methods', 'GET, POST, PUT');
      event.response.headers.set('Access-Control-Allow-Origin', '*');
      if (event.method == 'GET') {
        try {
          onGet(event);
        } catch (e) {
          print(e);
          event.response.statusCode = 500;
          event.response.close();
        }
        return;
      } else if (event.method == 'PUT') {
        try {
          onPut(event);
        } catch (e) {
          print(e);
          event.response.statusCode = 500;
          event.response.close();
        }
        return;
      } else {
        event.response.write('');
        event.response.close();
      }
    });
  }

  onGet(HttpRequest request) {
    final targetBucketKey = request.uri.pathSegments.first;
    if (bucketManager.buckets.containsKey(targetBucketKey)) {
      final bucketPath = bucketManager.buckets[targetBucketKey]!.bucketPath;
      var pathSegments = <String>[...request.uri.pathSegments];
      pathSegments.removeAt(0);
      final filePath = '$bucketPath/${pathSegments.join('/')}';
      final file = File(filePath);
      if (file.existsSync()) {
        request.response.add(file.readAsBytesSync());
        request.response.close();
      } else {
        request.response.statusCode = 404;
        request.response.close();
      }
    } else {
      request.response.statusCode = 404;
      request.response.close();
    }
  }

  onPut(HttpRequest request) async {
    final targetBucketKey = request.uri.pathSegments.first;
    if (bucketManager.buckets.containsKey(targetBucketKey)) {
      final bucketPath = bucketManager.buckets[targetBucketKey]!.bucketPath;
      var pathSegments = <String>[...request.uri.pathSegments];
      pathSegments.removeAt(0);
      final filePath = '$bucketPath/${pathSegments.join('/')}';
      final file = File(filePath);
      file.writeAsStringSync('');
      await request.forEach((element) {
        file.writeAsBytesSync(element, mode: FileMode.append);
      });
      request.response.write("OK");
      request.response.close();
    } else {
      request.response.statusCode = 404;
      request.response.close();
    }
  }
}
