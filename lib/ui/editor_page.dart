import 'package:flutter/material.dart';
import 'package:modo/ui/subscribe_page.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
// change: add these two lines to imports section at the top of the file
import 'dart:convert'; // access to jsonEncode()
import 'dart:io'; // access
import 'dart:async'; //// to File and Directory classes
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:modo/models/works.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TODO: User does not have permission to access

const String kTestString = 'Hello world!';


class EditorPage extends StatefulWidget {
  EditorPage({Key key, this.documentId, this.userId, this.record, this.src,this.documentdocumentID })
      : super(key: key);

  final String documentId;
  final String userId;
  final Works record;
  final String src;
  final String documentdocumentID;

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  bool editMode = false;
  final _formKey = new GlobalKey<FormState>();
  String _title;

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

    Widget titleField() {
      if(editMode) {
        _title="this is edit mode";
        return Container();
      }
      return new Form(
        key: _formKey,
        child: TextFormField(
          decoration: new InputDecoration(
            hintText: '제목',
            icon: new Icon(
              Icons.book,
              color: Colors.grey,
            ),
          ),
          validator: (value) => value.isEmpty ? '제목이 비어 있습니다.' : null,
          onChanged: (value) => _title = value.trim(),
        ),
      );
    }

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
      body: Column(
        children: <Widget>[
          titleField(),
          Expanded(child: body),
        ],
      ),
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
    editMode = true;
    final response = await client.get(widget.src);
    String decode = utf8.decode(response.bodyBytes);
    return decode;
  }

  Future<NotusDocument> _loadDocument() async {

    if(widget.src=="" || widget.src == null) {
      final Delta delta = Delta()..insert("여기에 입력해주세요.\n");
      return NotusDocument.fromDelta(delta);
    }
    final net = await fetchJSON(http.Client());
    String netStr = net.toString();
    if (netStr!=null) {
      return NotusDocument.fromJson(jsonDecode(netStr));
    }

  }

  // For this example we save our document to a temporary file.
  final file = File(Directory.systemTemp.path + "/auto_save.json");

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final form = _formKey.currentState;

    if(editMode || form.validate()) {
      final contents = jsonEncode(_controller.document);

      // And show a snack bar on success.
      file.writeAsString(contents).then((_) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
        _uploadFile().then((_) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Uploaded.")));
        });
      });
    }



  }

  Future<void> _uploadFile() async {

    final String uuid = "test";
    final Directory systemTempDir = Directory.systemTemp;
//    final File file = await File('${systemTempDir.path}/foo$uuid.txt').create();
//    await file.writeAsString(kTestString);
//    assert(await file.readAsString() == kTestString);
    final StorageReference ref =
    FirebaseStorage.instance.ref().child('text').child(widget.documentId+'_'+_title+'.json');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    sendAddSeriesData(widget.userId, url);
    print("URL is $url");

  }

  void sendAddSeriesData(String userId, String src) async {
    try {
      if(editMode == true){
        final collRef = Firestore.instance.collection('works').document(widget.documentId).collection('series');
        DocumentReference docRef = collRef.document(widget.documentdocumentID);

        docRef.updateData(
            { 'src': src,
            }
        );
      } else {
        final collRef = Firestore.instance.collection('works').document(widget.documentId).collection('series');
        DocumentReference docRef = collRef.document();

        docRef.setData(
            { 'src': src,
              'title': _title,
              'date':DateTime.now(),
            }
        ).then((_){
          Navigator.pop(context);
        });



      }

    } catch(e) {
      print('Error sendAddSeriesData $e');
    }
  }




}