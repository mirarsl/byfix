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
  no,
  maybe,
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
    initialColor: Color(0xFFC06437),
  );

  List<_DeviceWithAvailability> devices =
      List<_DeviceWithAvailability>.empty(growable: true);

  BluetoothConnection? connection;
  BluetoothDevice? selectedDevice;

  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  bool _isDiscovering = false;

  _RGBState();

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
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
    await FlutterBluetoothSerial.instance
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
          print(selectedDevice!.address);

          // BluetoothConnection.toAddress(selectedDevice!.address)
          //     .then((_connection) {
          //   print('Connected to the device');
          //   connection = _connection;
          // }).catchError((error) {
          //   Navigator.of(context).pop();
          // });
        });
      }
    }).toList();
  }
//TODO veri gönderme

  void sendRGB(String rgb) async {
    print(rgb);

    try {
      connection!.output.add(Uint8List.fromList(utf8.encode(rgb + "\r\n")));
      print(rgb);
      await connection!.output.allSent;
    } catch (e) {
      setState(() {});
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
            Center(
              child: CircleColorPicker(
                strokeWidth: 8,
                thumbSize: 50,
                controller: _controller,
                onChanged: (color) {
                  sendRGB("${color.red},${color.green},${color.blue}");
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
