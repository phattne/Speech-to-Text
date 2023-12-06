import 'package:flutter/material.dart';
import 'package:record/record.dart';

class AudioRecordingWidget extends StatefulWidget {
  @override
  _AudioRecordingWidgetState createState() => _AudioRecordingWidgetState();
}

class _AudioRecordingWidgetState extends State<AudioRecordingWidget> {
  static const _textStyle = TextStyle(fontSize: 30, color: Colors.black);

  final _recorder = Record();
  String? _fileRecognitionResult;
  bool _recognitionStarted = false;

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
                  await _stopRecording();
                } else {
                  await _recordAudio();
                }
                setState(() => _recognitionStarted = !_recognitionStarted);
              },
              child: Text(
                _recognitionStarted ? "Stop recording" : "Record audio",
              ),
            ),
            Text(
              "Final recognition result: $_fileRecognitionResult",
              style: _textStyle,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _recordAudio() async {
    try {
      await _recorder.start(
          samplingRate: 16000, encoder: AudioEncoder.wav, numChannels: 1);
    } catch (e) {
      // Handle recording error
    }
  }

  Future<void> _stopRecording() async {
    try {
      final filePath = await _recorder.stop();
      if (filePath != null) {
        // Process the recorded audio file
      }
    } catch (e) {
      // Handle recording error
    }
  }
}
