import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

/// @module api

class HttpHandler extends HttpHandlerCore {

  /// Return a http get request as Map<dynamic, dynamic>
  /// @param [url] target url
  /// @param [params] extra query params
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = api.GET(API_URL + "/player", params: {"name": "cristiano"})
  /// which will request like http://localhost:8008/player?name=cristiano
  Future<dynamic> GET(String url, {dynamic params, bool? useCache}) async {

    dynamic responseJson;

    try{
      var response = await get(formatURL(url).replace(queryParameters: params), headers: await getHeaders())
          .timeout(const Duration(minutes: 2));
      responseJson = manageResponse(response);
    }
    on SocketException {
      return Result(data: null, status: StatusResponse.NETWORK_ERROR);
    }

    return responseJson;

  }

  /// Return a http post request as Map<dynamic, dynamic>
  /// @param [url] target url
  /// @param [body] body request
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = api.GET(API_URL + "/players", body: {"name": "cristiano"})
  Future<dynamic> POST(String url, Map<String, dynamic> body, {bool? useCache}) async {

    dynamic responseJson;

    try{
      var response = await post(formatURL(url), body: jsonEncode(body), headers: {"Content-Type": "application/json"})
        .timeout(const Duration(minutes: 2));
      responseJson = manageResponse(response);
    }
    on SocketException {
      return Result(data: null, status: StatusResponse.NETWORK_ERROR);
    }

    return responseJson;

  }

  /// Return a http put request as Map<dynamic, dynamic>
  /// @param [url] target url
  /// @param [body] body request
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = api.GET(API_URL + "/players", body: {"id": 1, "name": "cristiano"})
  Future<dynamic> PUT(String url, Map<String, dynamic> body, {bool? useCache}) async {

    dynamic responseJson;

    try{
      var response = await put(formatURL(url), body: jsonEncode(body), headers: await getHeaders())
          .timeout(const Duration(minutes: 2));
      responseJson =  manageResponse(response);
    }
    on SocketException {
      return Result(data: null, status: StatusResponse.NETWORK_ERROR);
    }

    return responseJson;

  }

  /// Return a http delete request as Map<dynamic, dynamic>
  /// @param [url] target url
  /// @param [body] body request
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = api.GET(API_URL + "/players", body: {"id": 1})
  Future<dynamic> DELETE(String url, Map<String, dynamic> body, {bool? useCache}) async {

    dynamic responseJson;

    try{
      var response = await delete(formatURL(url), body: jsonEncode(body), headers: await getHeaders())
          .timeout(const Duration(minutes: 2));
      responseJson =  manageResponse(response);
    }
    on SocketException {
      return Result(data: null, status: StatusResponse.NETWORK_ERROR);
    }

    return responseJson;

  }

  /// Return a http response as Map<dynamic, dynamic> after upload a file
  /// @param [url] target url
  /// @param [body] body request
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = api.GET(API_URL + "/players", body: {"id": 1})
  Future<dynamic> UPLOAD_FILE(String url, {String? path, ByteData? bytes, bool? useCache}) async {

    dynamic responseJson;

    try {
      var request = MultipartRequest("POST", formatURL(url));

      if(path != null)
        request.files.add(await MultipartFile.fromPath("file", path, contentType: MediaType("multipart", "form-datasources")));
      else
        request.files.add(MultipartFile.fromBytes("file", bytes!.buffer.asInt8List()));

      var response = await request.send()
          .timeout(const Duration(minutes: 2));
      var responseStr = await Response.fromStream(response);
      responseJson = manageResponse(responseStr);
    }
    on SocketException {
      return Result(data: null, status: StatusResponse.NETWORK_ERROR);
    }

    return responseJson;

  }

}

class HttpHandlerCore {

  // Retrieve http headers
  dynamic getHeaders() async {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }

  // Caches url and transform it for api
  Uri formatURL(String url) {
    String finalUrl = url;
    if(!url.endsWith("/")) finalUrl = url + "/";
    return Uri.parse(finalUrl);
  }

  // Return the correct response
  dynamic manageResponse(var response) {
    dynamic data;
    try{ data = jsonDecode(response.body); }
    catch(e){ data = response.body; }
    switch (response.statusCode) {
      case 200:
      case 201:
        return Result(data: data, status: StatusResponse.OK);
      case 400:
        return Result(data: data, status: StatusResponse.BAD_REQUEST);
      case 401:
      case 403:
        return Result(data: data, status: StatusResponse.UNAUTHORIZED);
      case 404:
        return Result(data: data, status: StatusResponse.NOT_FOUND);
      case 408:
        return Result(data: data, status: StatusResponse.TIME_OUT);
      case 500:
      default:
        return Result(data: data, status: StatusResponse.SERVER_ERROR);
    }
  }

}

class Result {

  final dynamic data;
  final StatusResponse status;

  Result({required this.data, required this.status});

  get getData => data;
  get getStatus => status;

}

enum StatusResponse { OK, INVALID_REQUEST, BAD_REQUEST, UNAUTHORIZED, NETWORK_ERROR, SERVER_ERROR, NOT_FOUND, TIME_OUT, UNKNOWN_ERROR }