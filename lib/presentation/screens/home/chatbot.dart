// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';


// TODO import Dialogflow
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';

import '../shared/shared.dart';

@RoutePage()
class ChatbotScreen extends StatefulWidget {

  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  bool _isRecording = false;

  RecorderStream _recorder = RecorderStream();
  late StreamSubscription _recorderStatus;
  late StreamSubscription<List<int>> _audioStreamSubscription;
  late BehaviorSubject<List<int>> _audioStream;

  // TODO DialogflowGrpc class instance
  late DialogflowGrpcV2Beta1 dialogflow;
  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  @override
  void dispose() {
    _recorderStatus?.cancel();
    _audioStreamSubscription?.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    print('######## enter init ###########');
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted) {
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
      }
    });
    await Future.wait([
      _recorder.initialize()
    ]);
    // TODO Get a Service account
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('./assets/credentials.json'))}');
    dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
    print('######## exit init ###########');
  }

  void stopStream() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
  }

  void handleSubmitted(text) async {
    print(text);
    _textController.clear();

    //TODO Dialogflow Code
    ChatMessage message = ChatMessage(
      text: text,
      isMyMessage: true,
    );
    setState(() {
      _messages.insert(0, message);
    });

    DetectIntentResponse data = await dialogflow!.detectIntent(text, 'en-us');
    String fulfillmenText = data.queryResult.fulfillmentText;
    if (fulfillmenText.isNotEmpty)  {
      ChatMessage botMessage = ChatMessage(
        text: fulfillmenText,
        isMyMessage: false,
      );
      setState(() {
        _messages.insert(0, botMessage);
      });
    }
  }

  void handleStream() async {
    _recorder.start();

    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((data) {
      print(data);
      _audioStream.add(data);
    });


    // TODO Create SpeechContexts
    var biasList = SpeechContextV2Beta1(
        phrases: [
          'Dialogflow CX',
          'Dialogflow Essentials',
          'Action Builder',
          'HIPAA'
        ],
        boost: 20.0
    );
    // Create an audio InputConfig
    // See: https://cloud.google.com/dialogflow/es/docs/reference/rpc/google.cloud.dialogflow.v2#google.cloud.dialogflow.v2.InputAudioConfig
    var config = InputConfigV2beta1(
        encoding: 'AUDIO_ENCODING_LINEAR_16',
        languageCode: 'en-US',
        sampleRateHertz: 16000,
        singleUtterance: false,
        speechContexts: [biasList]
    );
    // TODO Make the streamingDetectIntent call, with the InputConfig and the audioStream
    final responseStream = dialogflow!.streamingDetectIntent(config, _audioStream);
    // TODO Get the transcript and detectedIntent and show on screen
    // Get the transcript and detectedIntent and show on screen
    responseStream.listen((data) {
      //print('----');
      setState(() {
        //print(data);
        String transcript = data.recognitionResult.transcript;
        String queryText = data.queryResult.queryText;
        String fulfillmentText = data.queryResult.fulfillmentText;

        if(fulfillmentText.isNotEmpty) {

          ChatMessage message = ChatMessage(
            text: queryText,
            isMyMessage: true,
          );

          ChatMessage botMessage = ChatMessage(
            text: fulfillmentText,
            isMyMessage: false,
          );

          _messages.insert(0, message);
          _textController.clear();
          _messages.insert(0, botMessage);

        }
        if(transcript.isNotEmpty) {
          _textController.text = transcript;
        }

      });
    },onError: (e){
      //print(e);
    },onDone: () {
      //print('done');
    });
  }

  // The chat interface
  //
  //------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              )),
          Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).colorScheme.secondary), // accent color changes to .colorScheme.secondary
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SharedStatefulWidget.addSizedOutlinedTextField(
                          controller: _textController,
                          labelText: 'send-message-prompt'.i18n(),
                          filled: true,
                          filledColor: Colors.green.withOpacity(0.1),
                          borderColor: Colors.lightGreen,
                          roundedBorder: true,
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.lightGreen,
                        onPressed: () => handleSubmitted(_textController.text),
                      ),
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
                        color: Colors.lightGreen,
                        onPressed: _isRecording ? stopStream : handleStream,
                      ),
                    ],
                  ),
                ),
              )
          ),
        ]));
  }
}


//------------------------------------------------------------------------------------
// The chat message balloon
//
//------------------------------------------------------------------------------------
class ChatMessage extends StatelessWidget {

  const ChatMessage({super.key, this.text="", this.isMyMessage=true});

  final String text;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context) => Column(children: [
    const SizedBox(height: 10),
    Row(
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: isMyMessage ? Colors.lightGreen : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: isMyMessage ? null : Border.all(color: Colors.lightGreen)
              ),
              width: text.length > 25 ? 330 : null,
              padding: const EdgeInsets.all(15),
              child: Text(text,
                style: TextStyle(
                  color: isMyMessage ? Colors.white : Colors.lightGreen,
                ),
              )),
        ]
    )
  ]);
}