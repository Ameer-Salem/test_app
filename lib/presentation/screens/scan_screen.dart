import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/ble_controller.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bleController = context.watch<BleController>();

    return Scaffold(
      appBar: AppBar(title: Text('BLE Scan')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: bleController.isScanning
                ? bleController.stopScan
                : bleController.startScan,
            child: Text(bleController.isScanning ? 'Stop Scan' : 'Start Scan'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  bleController.scanResults.length +
                  (bleController.connectedDevices.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (bleController.connectedDevices.isNotEmpty) {
                  return ListTile(
                    title: Text(
                      bleController.connectedDevices[0].advName.isNotEmpty
                          ? bleController.connectedDevices[0].advName
                          : 'Unknown Device',
                    ),
                    subtitle: Text(
                      bleController.connectedDevices[0].remoteId.toString(),
                    ),
                    trailing: Text('Connected'),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/main/device",
                        arguments: bleController.connectedDevice!,
                      );
                    },
                  );
                }

                final result = bleController.scanResults[index];
                return ListTile(
                  title: Text(
                    result.device.advName.isNotEmpty
                        ? result.device.advName
                        : 'Unknown Device',
                  ),
                  subtitle: Text(result.device.remoteId.toString()),
                  onTap: () {
                    if (bleController.isConnecting || bleController.isConnected) return;
                    
                    bleController.connect(result.device);
                    Navigator.pushNamed(
                      context,
                      "/main/device",
                      arguments: result.device,
                    );
                  },
                  trailing: Text(
                    bleController.connectedDevice?.remoteId ==
                            result.device.remoteId
                        ? 'Connected'
                        : '',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
