import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController _controller;
  bool showWebView = false;
  List<String> list = [
    'Select',
    'mailbody1.html',
    'mailbody2.html',
    'mailbody3.html'
  ];

  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
  }

  void loadFile(String value) {
    _controller.loadFlutterAsset('assets/$value');
  }

  @override
  Widget build(BuildContext context) {
    dropdownValue = list.first;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          showWebView ? IconButton(
            onPressed: () {
              setState(() {
                showWebView = false;
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ) : const SizedBox(),
        ],
      ),
      body: showWebView
          ? WebViewWidget(
        controller: _controller,
        gestureRecognizers: Set()
          ..add(
            Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer(),
            ),
          ),
       ): DropButton()
    );
  }

  Widget DropButton() {
    return Center(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value) {
          print(value);
          // This is called when the user selects an item.
          setState(() {
            if (value == 'Select') {
              showWebView = false;
            } else {
              loadFile(value!);
              showWebView = true;
            }
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
