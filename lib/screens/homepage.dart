// import 'dart:io';

// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:tetsapp/speechtotext/androidexample.dart';
// import 'package:vosk_flutter/vosk_flutter.dart';

// class Homepage extends StatefulWidget {
//   static const _textStyle = TextStyle(fontSize: 30, color: Colors.white);
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   static const _textStyle = TextStyle(fontSize: 30, color: Colors.black);
//   static const _modelName = 'vosk-model-small-en-us-0.15';
//   static const _sampleRate = 16000;

//   final _vosk = VoskFlutterPlugin.instance();
//   final _modelLoader = ModelLoader();
//   final _recorder = Record();

//   String? _fileRecognitionResult;
//   String? _error;
//   Model? _model;
//   Recognizer? _recognizer;
//   SpeechService? _speechService;

//   bool _recognitionStarted = false;

//   @override
//   void initState() {
//     super.initState();

//     _modelLoader
//         .loadModelsList()
//         .then((modelsList) =>
//             modelsList.firstWhere((model) => model.name == _modelName))
//         .then((modelDescription) =>
//             _modelLoader.loadFromNetwork(modelDescription.url)) // load model
//         .then(
//             (modelPath) => _vosk.createModel(modelPath)) // create model object
//         .then((model) => setState(() => _model = model))
//         .then((_) => _vosk.createRecognizer(
//             model: _model!, sampleRate: _sampleRate)) // create recognizer
//         .then((value) => _recognizer = value)
//         .then((recognizer) {
//       if (Platform.isAndroid) {
//         _vosk
//             .initSpeechService(_recognizer!) // init speech service
//             .then((speechService) =>
//                 setState(() => _speechService = speechService))
//             .catchError((e) => setState(() => _error = e.toString()));
//       }
//     }).catchError((e) {
//       setState(() => _error = e.toString());
//       return null;
//     });
//   }

  
//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: AvatarGlow(
//         animate: _islistening,
//         glowColor: Theme.of(context).primaryColor,
//         endRadius: 75.0,
//         duration: Duration(microseconds: 2000),
//         repeatPauseDuration: Duration(microseconds: 100),
//         repeat: true,
//         child: FloatingActionButton(
//           onPressed: () {},
//           child: Icon(_islistening ? Icons.mic : Icons.mic_none),
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Center(
//           child: Text(
//             'Speech to text ',
//             style: Homepage._textStyle,
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 30,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 30),
//               child: Text(
//                 'Partial result',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     fontSize: 20),
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.3,
//               width: MediaQuery.of(context).size.width,
//               child: Container(
//                 margin: EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                     color: Colors.amber[100],
//                     border: Border.all(width: 2.0, color: Colors.amber),
//                     borderRadius: BorderRadius.circular(50)),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 30),
//               child: Text(
//                 ' Result',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     fontSize: 20),
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.3,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                     color: Colors.purpleAccent,
//                     border: Border.all(width: 2.0, color: Colors.amber),
//                     borderRadius: BorderRadius.circular(50)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Align(
//                       alignment: Alignment.topRight,
//                       child: IconButton(
//                         onPressed: () {},
//                         icon: Icon(Icons.copy_sharp),
//                         iconSize: 40,
//                       )),
//                 ),
//               ),
//             ),
//             //SpeechRecognitionWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }
