import 'dart:async';
import 'dart:convert';

import 'package:cloudwrite/api/client.dart';
import 'package:cloudwrite/api/entities/user_entity.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthService {
  var apiClient = ServiceResolver.get<GraphQLService>();

  // final authStream = PublishSubject<AuthenticationStatus>();

  FlutterSecureStorage _storage;

  AuthService(FlutterSecureStorage storage) {
    _storage = storage;
  }

  static const userKey = "user_entity";

  // get token =>
  //     Future.value(_storage.read(key: userKey))
  //         .then((value) =>
  //     UserEntity
  //         .fromJson(jsonDecode(value))
  //         .token);
  //
  // Stream<AuthenticationStatus> get authStatus async* {
  //   if (JwtDecoder.isExpired(await token)) {
  //     authStream.sink.add(AuthenticationStatus.unauthenticated);
  //   } else {
  //     authStream.sink.add(AuthenticationStatus.authenticated);
  //   }
  // }

  Future<MapEntry<QueryResult, dynamic>> signIn(String username,
      String password) {
    return apiClient.signIn(username, password).then((result) {
      var user;
      if (!result.hasException) {
        user = UserEntity.fromJson(result.data["signIn"]);
      }
      return MapEntry(result, user);
    }).then((result) {
      if (result.value != null) {
        _storage.write(key: userKey, value: json.encode(result.value.toJson()));
      }
      return result;
    });
  }

  Future<void> signOut() {
    return _storage.write(key: userKey, value: null);
  }

  Future<UserEntity> getCurrentUser() {
    return _storage
        .read(key: userKey)
        .then((value) {
      if (value != null) {
        return UserEntity.fromJson(jsonDecode(value));
      } else {
        return null;
      }
    });
  }
}

