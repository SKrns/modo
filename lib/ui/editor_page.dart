import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
// change: add these two lines to imports section at the top of the file
import 'dart:convert'; // access to jsonEncode()
import 'dart:io'; // access
import 'dart:async'; //// to File and Directory classes
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

//TODO: User does not have permission to access

const String kTestString = 'Hello world!';

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {

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
      ),
    );
    return Scaffold(
      appBar: AppBar(
          title: Text("Editor page"),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.save),
                onPressed: () => _saveDocument(context),
              ),
            )
          ],
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

  Future<NotusDocument> _loadDocument() async {
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    if (await file.exists()) {
      final contents = await file.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_controller.document);
    // For this example we save our document to a temporary file.
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    // And show a snack bar on success.
    file.writeAsString(contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
    });

    _uploadFile().then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Uploaded.")));
    });
  }

  Future<void> _uploadFile() async {
    final String uuid = "test";
    final Directory systemTempDir = Directory.systemTemp;
    final File file = await File('${systemTempDir.path}/foo$uuid.txt').create();
    await file.writeAsString(kTestString);
    assert(await file.readAsString() == kTestString);
    final StorageReference ref =
    FirebaseStorage.instance.ref().child('text').child('foo$uuid.txt');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");

  }

}