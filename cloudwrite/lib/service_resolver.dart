import 'package:get_it/get_it.dart';

class  ServiceResolver {
  static T get<T>() {
    return GetIt.instance.get<T>();
  }
}