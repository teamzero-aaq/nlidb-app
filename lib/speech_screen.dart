import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nlidb/constants.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'components/rounded_button.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String text = 'Press the button and start speaking';
  String _text = "", query = "", statement = "";
  List tables = [], columns = [], data = [];
  TextEditingController _textEditingController;
  double _confidence = 1.0;
  bool loading = false;
  bool visible = false;
  bool is_aggregate = false;
  List<List<DataCell>> rows = [];

  submit() {
    rows = [];
    if (_textEditingController.value.text == "") {
      setState(() {
        loading = false;
        _isListening = false;
      });
      return;
    }
    getResponse(_textEditingController.value.text);
  }

  getResponse(String text) async {
    await http
        .get("http://192.168.29.87:8000/get-data?query=" +
            Uri.encodeFull(_textEditingController.value.text))
        .then((response) {
      var result = json.decode(response.body.toString());
      var body = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        if (body.containsKey("error")) {
          Toast.show(result["error"], context,
              duration: 5, gravity: Toast.BOTTOM);
        } else {
          setState(() {
            query = body["query"];
            statement = body["statement"];
            tables = body["tables"];
            columns = body["columns"];
            data = body["data"];
            is_aggregate = body["is_aggregate"];

            print(query);
            print(statement);
            print(columns);
            print(tables);
            print(data);

            for (int i = 0; i < data.length; i++) {
              List<DataCell> temp = [];
              for (int j = 0; j < data[i].length; j++) {
                temp.add(DataCell(Text(data[i][j].toString())));
              }
              rows.add(temp);
            }

            visible = true;
          });
        }
      } else {}
      setState(() {
        loading = false;
      });
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          localeId: "hi-IN",
          onResult: (val) => setState(() {
            _textEditingController.text = val.recognizedWords;
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
        loading = true;
      });
      submit();
      _speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !visible
        ? Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text(
                      'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
                  // title: Text('NLIDB'),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: AvatarGlow(
                  animate: _isListening,
                  glowColor: Theme.of(context).primaryColor,
                  endRadius: 75.0,
                  duration: const Duration(milliseconds: 2000),
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  repeat: true,
                  child: FloatingActionButton(
                    onPressed: _listen,
                    child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  ),
                ),
                body: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                      child: Column(
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: 32.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 200,
                          ),
                          TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Eg: सभी छात्रों का नाम क्या है?'),
                            onSubmitted: (val) {
                              setState(() {
                                loading = true;
                                _isListening = false;
                                _speech.stop();
                              });
                              submit();
                            },
                          ),
                        ],
                      )),
                ),
              ),
              loading
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: SizedBox(
                          child: SpinKitThreeBounce(
                            color: Colors.white,
                            size: 30.0,
                          ),
                          height: 200.0,
                          width: 200.0,
                        ),
                      ),
                    )
                  : Container()
            ],
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Result'),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: RoundedButton(
                      text: "New Input",
                      press: () {
                        setState(() {
                          visible = false;
                          query = "";
                          data = [];
                          rows = [];
                          columns = [];
                          tables = [];
                          is_aggregate = false;
                          statement = "";
                          loading = false;
                          _isListening = false;
                          _textEditingController.text = "";
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      "Query".toUpperCase(),
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      query,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      "Statement".toUpperCase(),
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      statement,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: is_aggregate == true
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                "${data[0][0].toString()}",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.redAccent),
                              ),
                            ),
                          )
                        : DataTable(
                            columns: columns
                                .map((name) => DataColumn(
                                    label: Text(name
                                        .toString()
                                        .toUpperCase()
                                        .replaceAll("_", " "))))
                                .toList(),
                            rows:
                                rows.map((row) => DataRow(cells: row)).toList(),
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}
