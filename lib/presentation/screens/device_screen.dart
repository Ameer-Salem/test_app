import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/ble_controller.dart';

class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;
  const DeviceScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final bleController = context.watch<BleController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            bleController.startScan();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          device.advName.isNotEmpty ? device.advName : "Unnamed Device",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => bleController.disconnect(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              bleController.isConnected
                  ? "Connected to ${device.advName}"
                  : "Not connected",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            if (bleController.isConnecting)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: bleController.isConnected
                    ? bleController.disconnect
                    : () => bleController.connect(device),
                child: Text(
                  bleController.isConnected ? "Disconnect" : "Connect",
                ),
              ),

            const SizedBox(height: 40),

            if (bleController.isConnected)
              ElevatedButton.icon(
                onPressed: () {
                  // Placeholder for chat / data screen navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ready for data exchange!')),
                  );
                },
                icon: const Icon(Icons.chat),
                label: const Text("Open Chat / Data"),
              ),
          ],
        ),
      ),
    );
  }
}
