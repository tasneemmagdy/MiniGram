import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mini_gram/cubit/network_cubit/cubit.dart';
import 'package:mini_gram/generated/l10n.dart'; 

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context); 

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 90, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              s.noInternet, 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              s.checkConnection, 
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () async {
                final isConnected = await InternetConnectionChecker
                    .createInstance()
                    .hasConnection;
                // ignore: use_build_context_synchronously
                context.read<NetworkCubit>().emit(isConnected);
              },
              icon: const Icon(Icons.refresh),
              label: Text(s.tryAgain), 
            ),
          ],
        ),
      ),
    );
  }
}