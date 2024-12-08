import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Cau hinh cac routers.
final _router = Router(notFoundHandler: _notFoundHandler)
  ..get('/', _rootHandler)
  ..get('/api/v1/check', _checkHandler)
  ..post('/api/v1/submit', _submitHandler)
  ..get('/api/v1/echo/<message>', _echoHandler);
//header mac dinh cho du lieu tra ve duoi dang json
final _headers = {'Content-Type': "application/json"};
//xu li cac duong dan ko tim thay tren server
Response _notFoundHandler(Request req) {
  return Response.notFound(
      json.encode({"message": "Khong tim thay duong dan yeu cau "}),
      headers: _headers);
}

Response _rootHandler(Request req) {
  return Response.ok(json.encode({"message": "Hello world!"}),
      headers: _headers);
}

Response _checkHandler(Request req) {
  return Response.ok(
      json.encode({"message": "Chao mung ban den voi ung dung web dong"}),
      headers: _headers);
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _submitHandler(Request request) async {
  try {
    //doc payload tu request
    final payload = await request.readAsString();
    // print(await request.readAsString());
    print(payload);
    //giai ma json
    final data = json.decode(payload); //tra ve 1 map
    //lay gia tri name tu data, ep ve string neu co the
    final name = data['name'] as String?;
    final num = int.parse(data['num']);

    //kiem tra neu name hop le
    if (name != null &&
        name.isNotEmpty &&
        0 <= num &&
        num <= 10 &&
        num != null) {
      //phan hoi chao mung
      final response = {"message": 'Chao mung ${name} ${num}'};
      return Response.ok(json.encode(response), headers: _headers);
    } else {
      final response = {"message": 'Hay nhap ten va diem (0->10) cua ban '};
      return Response.badRequest(
          body: json.encode(response), headers: _headers);
    }
  } catch (e) {
    final response = {"message": '${e.toString()}'};
    return Response.badRequest(body: json.encode(response), headers: _headers);
  }
}

void main(List<String> args) async {
  // lắng nghe trên tất cả các địa chỉ IPv4
  final ip = InternetAddress.anyIPv4;

  final corsHeader = createMiddleware(requestHandler: (req) {
    if (req.method == 'OPTIONS') {
      return Response.ok("", headers: {
        // cho phep moi nguon truy cap trong moi truong dev
        'Access-Control-Allow-Origin': "*",
        'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,PATCH,HEAD',
        'Access-Control-Allow-Headers': "Content-Type,Authorization",
      });
    }
    return null;
  }, responseHandler: (res) {
    return res.change(headers: {
      'Access-Control-Allow-Origin': "*",
      'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,PATCH,HEAD',
      'Access-Control-Allow-Headers': "Content-Type,Authorization",
    });
  });
  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(corsHeader)
      .addMiddleware(logRequests())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
