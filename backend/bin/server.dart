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
    //kiem tra neu name hop le
    if (name != null && name.isNotEmpty) {
      //phan hoi chao mung
      final response = {"message": 'Chao mung ${name}'};
      return Response.ok(json.encode(response), headers: _headers);
    } else {
      final response = {"message": 'Hay nhap ten cua ban'};
      return Response.badRequest(
          body: json.encode(response), headers: _headers);
    }
  } catch (e) {
    final response = {"message": '${e.toString()}'};
    return Response.badRequest(body: json.encode(response), headers: _headers);
  }
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
