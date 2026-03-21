import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkCubit extends Cubit<bool> {
  NetworkCubit() : super(true) {
    _init();
  }

  late final StreamSubscription _sub;
  final _checker = InternetConnectionChecker.createInstance(); 

  Future<void> _init() async {
    final isConnected = await _checker.hasConnection;
    emit(isConnected);

    _sub = Connectivity().onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        emit(false);
      } else {
        final isConnected = await _checker.hasConnection;
        emit(isConnected);
      }
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}