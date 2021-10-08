import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class RGB extends StatefulWidget {
  const RGB({Key? key}) : super(key: key);

  @override
  _RGBState createState() => _RGBState();
}

enum _DeviceAvailability {
  yes,
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _DeviceWithAvailability {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int? rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class _RGBState extends State<RGB> {
  final _controller = CircleColorPickerController(
    initialColor: const Color(0xFFC06437),
  );

  List<_DeviceWithAvailability> devices =
      List<_DeviceWithAvailability>.empty(growable: true);

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  bool get isConnected => connection != null && connection!.isConnected;
  BluetoothDevice? selectedDevice;

  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  bool _isDiscovering = false;
  bool _isConnected = false;

  _RGBState();

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription = bluetooth.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var _device = i.current;
          if (_device.device == r.device) {
            _device.availability = _DeviceAvailability.yes;
            _device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription?.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

//TODO bluetooth açık mı kontrol etme
  void connectBluetooth() async {
    await bluetooth.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    await enableBluetooth();

    if (!mounted) {
      return;
    }

    await bluetooth
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
                device,
                _DeviceAvailability.yes,
              ),
            )
            .toList();
      });
    });

    devices.map((_device) {
      if (_device.device.name == "HC-06" || _device.device.name == "ByFix") {
        setState(() {
          selectedDevice = _device.device;
          BluetoothConnection.toAddress(selectedDevice!.address)
              .then((_connection) {
            setState(() {
              connection = _connection;
              _isConnected = true;
            });
          }).catchError((error) {
            setState(() {
              _isConnected = false;
              Navigator.of(context).pop();
            });
          });
        });
      }
    }).toList();
  }

  void sendRGB(String rgb) async {
    try {
      connection!.output.add(Uint8List.fromList(utf8.encode(rgb + "\r\n")));
      await connection!.output.allSent;
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
  }

  @override
  void initState() {
    if (_isDiscovering) {
      _startDiscovery();
    }
    connectBluetooth();
    super.initState();
  }

  @override
  void dispose() {
    _discoveryStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BYFIX RGB'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 48),
            Text(
              _isConnected
                  ? "Bağlandı".toUpperCase()
                  : "Bağlanıyor".toUpperCase(),
              style: TextStyle(
                fontSize: 36,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Center(
              child: CircleColorPicker(
                strokeWidth: 8,
                thumbSize: 50,
                controller: _controller,
                onChanged: (color) {
                  setState(() {
                    sendRGB("${color.red},${color.green},${color.blue}");
                  });
                },
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
