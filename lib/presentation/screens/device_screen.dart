import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:test_app/logic/device_manager.dart';
import 'package:test_app/models/helpers/connection_state.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<DeviceManager>(context);
    final device = manager.device;
    return Scaffold(
      body: Center(
        child: manager.state == ConnectionStates.disconnected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                    size: 100,
                  ),
                  SizedBox(height: 20),
                  Text("Device not found", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async{
                        await Navigator.pushReplacementNamed(context, '/scan');
                    },
                    child: Text('Scan'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Connected to ${device!.advName}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),

                  if (manager.state == ConnectionStates.connecting ||
                      manager.state == ConnectionStates.disconnecting)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () async {
                        await disconnect(() => manager.disconnect());
                      },
                      child: Text("Disconnect"),
                    ),

                  const SizedBox(height: 40),

                  if (manager.state == ConnectionStates.connected)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Placeholder for chat / data screen navigation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ready for data exchange!'),
                          ),
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

  Future<void> disconnect(Function()? onPressed) async {
    // Implement disconnect logic if needed
    await onPressed?.call();
    setState(() {});
  }
}
