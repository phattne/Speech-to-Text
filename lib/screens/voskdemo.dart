import 'dart:io';
import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

class VoskFlutterDemo extends StatefulWidget {
  const VoskFlutterDemo({Key? key}) : super(key: key);

  @override
  State<VoskFlutterDemo> createState() => _VoskFlutterDemoState();
}

class _VoskFlutterDemoState extends State<VoskFlutterDemo> {
  static const _textStyle = TextStyle(fontSize: 30, color: Colors.black);
  static const _modelName = 'vosk-model-small-en-us-0.15';
  static const _sampleRate = 16000;

  final _vosk = VoskFlutterPlugin.instance();
  final _modelLoader = ModelLoader();
  final _recorder = Record();

  String? _fileRecognitionResult;
  String? _error;
  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;

  bool _recognitionStarted = false;

  @override
  void initState() {
    super.initState();

    _modelLoader
        .loadModelsList()
        .then((modelsList) =>
            modelsList.firstWhere((model) => model.name == _modelName))
        .then((modelDescription) =>
            _modelLoader.loadFromNetwork(modelDescription.url)) // load model
        .then(
            (modelPath) => _vosk.createModel(modelPath)) // create model object
        .then((model) => setState(() => _model = model))
        .then((_) => _vosk.createRecognizer(
            model: _model!, sampleRate: _sampleRate)) // create recognizer
        .then((value) => _recognizer = value)
        .then((recognizer) {
      if (Platform.isAndroid) {
        _vosk
            .initSpeechService(_recognizer!) // init speech service
            .then((speechService) =>
                setState(() => _speechService = speechService))
            .catchError((e) => setState(() => _error = e.toString()));
      }
    }).catchError((e) {
      setState(() => _error = e.toString());
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
          body: Center(child: Text("Error: $_error", style: _textStyle)));
    } else if (_model == null) {
      return const Scaffold(
          body: Center(
              child:
                  Center(child: Text("Loading model...", style: _textStyle))));
    } else if (Platform.isAndroid && _speechService == null) {
      return const Scaffold(
        body: Center(
          child: Center(
              child: Text("Initializing speech service...", style: _textStyle)),
        ),
      );
    } else {
      return Platform.isAndroid ? _androidExample() : _commonExample();
    }
  }

  Widget _androidExample() {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
          child: Text(
            "Speech to text ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Container(
                height: 100,
                width: 50,
                child: Center(child: Text('Import Video')),
              ),
            ),
            StreamBuilder(
                stream: _speechService!.onPartial(),
                builder: (context, snapshot) => Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          border: Border.all(width: 2.0, color: Colors.amber),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text("${snapshot.data.toString()}",
                          style: _textStyle),
                    )),
            StreamBuilder(
                stream: _speechService!.onResult(),
                builder: (context, snapshot) => Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          border: Border.all(width: 2.0, color: Colors.amber),
                          borderRadius: BorderRadius.circular(50)),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: snapshot.data.toString()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Text Copied')),
                              );
                            },
                            child: Icon(Icons.copy_sharp),
                          ),
                          Center(
                            child: Text("${snapshot.data.toString()}",
                                style: _textStyle),
                          ),
                        ],
                      ),
                    )),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(180),
                            side: BorderSide(color: Colors.white)))),
                onPressed: () async {
                  if (_recognitionStarted) {
                    await _speechService!.stop();
                  } else {
                    await _speechService!.start();
                  }
                  setState(() => _recognitionStarted = !_recognitionStarted);
                },
                child: Icon(
                  _recognitionStarted ? Icons.mic : Icons.mic_none,
                  size: 100,
                )),
          ],
        ),
      ),
    );
  }

  Widget _commonExample() {
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
                child: Icon(_recognitionStarted ? Icons.mic : Icons.mic_none)),
            Text("Final recognition result: $_fileRecognitionResult",
                style: _textStyle),
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
      _error = e.toString() +
          '\n\n Make sure fmedia(https://stsaz.github.io/fmedia/)'
              ' is installed on Linux';
    }
  }

  Future<void> _stopRecording() async {
    try {
      final filePath = await _recorder.stop();
      if (filePath != null) {
        final bytes = File(filePath).readAsBytesSync();
        _recognizer!.acceptWaveformBytes(bytes);
        _fileRecognitionResult = await _recognizer!.getFinalResult();
      }
    } catch (e) {
      _error = e.toString() +
          '\n\n Make sure fmedia(https://stsaz.github.io/fmedia/)'
              ' is installed on Linux';
    }
  }
}
