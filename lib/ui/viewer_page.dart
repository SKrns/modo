import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
// change: add these two lines to imports section at the top of the file
import 'dart:convert'; // access to jsonEncode()
import 'dart:io'; // access
import 'dart:async'; //// to File and Directory classes
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import 'package:modo/models/series.dart';

//TODO: User does not have permission to access

const String kTestString = 'Hello world!';

class ViewerPage extends StatefulWidget {
  ViewerPage({Key key, this.record})
      : super(key: key);

  final Series record;

  @override
  ViewerPageState createState() => ViewerPageState();
}

class ViewerPageState extends State<ViewerPage> {

  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
//    final document = _loadDocument();
//    _controller = ZefyrController(document);
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.

    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
      child: ZefyrEditor(
        padding: EdgeInsets.all(16),
        controller: _controller,
        focusNode: _focusNode,
        mode: ZefyrMode.view,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record.title),

      ),

      body: body,
    );
  }

//  /// Loads the document to be edited in Zefyr.
//  NotusDocument _loadDocument() {
//    // For simplicity we hardcode a simple document with one line of text
//    // saying "Zefyr Quick Start".
//    // (Note that delta must always end with newline.)
//    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
//    return NotusDocument.fromDelta(delta);
//  }

  Future<String> fetchJSON(http.Client client) async {
    final response = await client.get(widget.record.src);
    String decode = utf8.decode(response.bodyBytes);
    return decode;
  }

  Future<NotusDocument> _loadDocument() async {
    final net = await fetchJSON(http.Client());
    String netStr = net.toString();
    if (netStr!=null) {
      return NotusDocument.fromJson(jsonDecode(netStr));
    }
    final Delta delta = Delta()..insert("Start\n");
    return NotusDocument.fromDelta(delta);
  }

  // For this example we save our document to a temporary file.
  final file = File(Directory.systemTemp.path + "/quick_start.json");

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_controller.document);

    // And show a snack bar on success.
    file.writeAsString(contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
      _uploadFile().then((_) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Uploaded.")));
      });
    }).then((_){

    });


  }

  Future<void> _uploadFile() async {
    final String uuid = "test";
    final Directory systemTempDir = Directory.systemTemp;
//    final File file = await File('${systemTempDir.path}/foo$uuid.txt').create();
//    await file.writeAsString(kTestString);
//    assert(await file.readAsString() == kTestString);
    final StorageReference ref =
    FirebaseStorage.instance.ref().child('text').child('error.json');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
//      StorageMetadata(
//        contentLanguage: 'ko-dsfsdfkr',
//        contentType: 'utf-8',
////        customMetadata: <String, String>{'activity': 'test'},
//      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");

  }

}