import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';


part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {required String baseUrl}) = _RestClient;

  @GET('users/{username}')
  Future<dynamic> getUsersByUsername(@Path("username") String username);

  @GET('users/{username}/repos')
  Future<dynamic> getUsersRepositories(@Path("username") String username);
}
