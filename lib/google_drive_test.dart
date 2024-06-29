/*
import 'dart:io';
import 'package:Sovarvo/apis.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
*/

/*

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  final myDrive = GoogleDrive();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveFileScope,
    ],
  );

  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    final authHeaders = await user.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    _driveApi = drive.DriveApi(authenticateClient);
  }

  Future<void> _uploadFile() async {
    if (_driveApi == null) return;

    final Stream<List<int>> mediaStream = Future.value([104, 105]).asStream(); // Replace with actual file stream
    var media = drive.Media(mediaStream, 2);
    var driveFile = drive.File();
    driveFile.name = "example.txt"; // Replace with actual file name

    final result = await _driveApi!.files.create(
      driveFile,
      uploadMedia: media,
    );
    print("Uploaded file with ID: ${result.id}");
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Drive Upload"),
      ),
      body: Center(
        child: user != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Signed in as ${user.displayName}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text("Upload File"),
            ),
          ],
        )
            : ElevatedButton(
          //onPressed: _googleSignIn.signIn,
          onPressed: () async {
            var file = await FilePicker.platform.pickFiles();
            myDrive.upload(file as File);
          },
          child: Text("Sign In with Google"),
        ),
      ),
    );
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}*/
