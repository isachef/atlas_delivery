import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/connectivity_service.dart';

class ConnectionStatus extends StatelessWidget {
  final Widget child;

  const ConnectionStatus({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, _) {
        if (!connectivityService.isConnected) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Нет подключения к интернету',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Пожалуйста, проверьте ваше подключение',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        connectivityService.checkConnection();
                      },
                      child: const Text('Проверить снова'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}
