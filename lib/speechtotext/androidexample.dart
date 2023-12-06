import 'package:flutter/material.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

class SpeechRecognitionWidget extends StatefulWidget {
  @override
  _SpeechRecognitionWidgetState createState() =>
      _SpeechRecognitionWidgetState();
}

class _SpeechRecognitionWidgetState extends State<SpeechRecognitionWidget> {
  bool _recognitionStarted = false;
  SpeechService? _speechService;

  TextStyle get _textStyle => TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (_recognitionStarted) {
                  await _speechService!.stop();
                } else {
                  await _speechService!.start();
                }
                setState(() => _recognitionStarted = !_recognitionStarted);
              },
              child: Text(
                _recognitionStarted ? "Stop recognition" : "Start recognition",
              ),
            ),
            // StreamBuilder(
            //   stream: _speechService!.onPartial(),
            //   builder: (context, snapshot) => Text(
            //     "Partial result: ${snapshot.data.toString()}",
            //     style: _textStyle,
            //   ),
            // ),
            // StreamBuilder(
            //   stream: _speechService!.onResult(),
            //   builder: (context, snapshot) => Text(
            //     "Result: ${snapshot.data.toString()}",
            //     style: _textStyle,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
