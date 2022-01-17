import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

bool globalPermissionFilesWrite = false;
const globalFileNameTiffSinglePage = "test-fax-format.tiff";
const String globalFileNameTiffMultiPages = "test-fax-format-multipages.tiff";

const String globalFileOutputDirLocal = "/";
const String globalFileOutputDirPhone = "/storage/emulated/0/Download/"; // TO TEST WITH FILES DIRECTLY IN THE PHONE (Download directory)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test TIFF Fax format',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TiffFaxDisplay(title: 'TIFF Fax format'),
    );
  }
}

class TiffFaxDisplay extends StatefulWidget {
  const TiffFaxDisplay({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TiffFaxDisplay> createState() => _TiffFaxDisplayState();
}

class _TiffFaxDisplayState extends State<TiffFaxDisplay> {
  Widget? widgetToPrint;
  Widget? widget2ToPrint;

  @override
  void initState() {
    super.initState();

    widgetToPrint = Container();
    widget2ToPrint = Container();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      checkPermissionFiles().then((value) async {
        log("Call 'checkPermissionFiles': SUCCESS: value='$value'");
        globalPermissionFilesWrite = value;
        if (globalPermissionFilesWrite) {
          Directory directory = await getApplicationDocumentsDirectory();
          String directoryPath = directory.path;
          if (directoryPath != "") {
            log("Call 'checkPermissionFiles': INFO: directoryPath='$directoryPath'");
            log("Call 'listFilesFromAssets': INFO: check the list of assets files");
            await listFilesFromAssets();
          } else {
            log("Call 'checkPermissionFiles': ERROR: directoryPath='$directoryPath'");
          }
        }
      }).catchError((onError) {
        log("Call 'checkPermissionFiles': ERROR: onError='$onError'");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Click on the buttons to display TIFF file:'),
                const SizedBox(height: 20.0),
                const Text('TIFF fax format single page:'),
                ElevatedButton(
                  child: const Text("File local in the app)"),
                  onPressed: () async {
                    log("START: single page (local): widgetToPrint='$widgetToPrint'");
                    String _fileToPrint = globalFileOutputDirLocal + globalFileNameTiffSinglePage;
                    log("START: single page (local): file to print: '$_fileToPrint'");
                    UtilsLocalFile.localFileTiffLoad(directoryPath: globalFileOutputDirLocal, fileName: globalFileNameTiffSinglePage, isFromAssets: true)
                        .then((value) {
                      setState(() {
                        widgetToPrint = Image(image: value);
                        // log("INFO: single page (local): onPressed: widgetToPrint '$widgetToPrint'");
                        log("INFO: single page (local): onPressed: widgetToPrint modified!");
                      });
                    }).catchError((e) {
                      log("ERROR: single page (local): onPressed: e='$e'");
                    });

                    log("END: single page (local): onPressed");
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  child: const Text("Existing file in the phone"),
                  onPressed: () async {
                    log("START: single page (phone): widgetToPrint='$widgetToPrint'");
                    String _fileToPrint = globalFileOutputDirPhone + globalFileNameTiffSinglePage;
                    log("START: single page (phone): file to print: '$_fileToPrint'");
                    UtilsLocalFile.localFileTiffLoad(directoryPath: globalFileOutputDirPhone, fileName: globalFileNameTiffSinglePage, isFromAssets: false)
                        .then((value) {
                      setState(() {
                        widgetToPrint = Image(image: value);
                        // log("INFO: single page (local): onPressed: widgetToPrint '$widgetToPrint'");
                        log("INFO: single page (phone): onPressed: widgetToPrint modified!");
                      });
                    }).catchError((e) {
                      log("ERROR: single page (phone): onPressed: e='$e'");
                    });

                    log("END: single page (phone): onPressed");
                  },
                ),
                widgetToPrint!,
                const SizedBox(height: 40.0),
                const Text('TIFF fax format multi pages:'),
                ElevatedButton(
                  child: const Text("File local in the app)"),
                  onPressed: () async {
                    log("START: single page (local): widget2ToPrint='$widget2ToPrint'");
                    String _fileToPrint = globalFileOutputDirLocal + globalFileNameTiffMultiPages;
                    log("START: single page (local): file to print: '$_fileToPrint'");
                    UtilsLocalFile.localFileTiffLoad(directoryPath: globalFileOutputDirLocal, fileName: globalFileNameTiffMultiPages, isFromAssets: true)
                        .then((value) {
                      setState(() {
                        widget2ToPrint = Image(image: value);
                        // log("INFO: single page (local): onPressed: widget2ToPrint '$widget2ToPrint'");
                        log("INFO: single page (local): onPressed: widget2ToPrint modified!");
                      });
                    }).catchError((e) {
                      log("ERROR: single page (local): onPressed: e='$e'");
                    });

                    log("END: single page (local): onPressed");
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  child: const Text("Existing file in the phone"),
                  onPressed: () async {
                    log("START: single page (phone): widget2ToPrint='$widget2ToPrint'");
                    String _fileToPrint = globalFileOutputDirPhone + globalFileNameTiffMultiPages;
                    log("START: single page (phone): file to print: '$_fileToPrint'");
                    UtilsLocalFile.localFileTiffLoad(directoryPath: globalFileOutputDirPhone, fileName: globalFileNameTiffMultiPages, isFromAssets: false)
                        .then((value) {
                      setState(() {
                        widget2ToPrint = Image(image: value);
                        // log("INFO: single page (local): onPressed: widget2ToPrint '$widget2ToPrint'");
                        log("INFO: single page (phone): onPressed: widget2ToPrint modified!");
                      });
                    }).catchError((e) {
                      log("ERROR: single page (phone): onPressed: e='$e'");
                    });

                    log("END: single page (phone): onPressed");
                  },
                ),
                widget2ToPrint!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> checkPermissionFiles() async {
  log("checkPermissionFiles: call");
  if (await Permission.storage.request().isGranted ||
      await Permission.manageExternalStorage.request().isGranted ||
      await Permission.storage.isGranted ||
      await Permission.manageExternalStorage.isGranted) {
    log("checkPermissionFiles: access to storage granted");
    return true;
  }
  log("checkPermissionFiles: access to storage denied");
  return false;
}

Future<ByteData> loadFileTiffFromAsset({required String fullPathFile}) async {
  return await rootBundle.load(fullPathFile);
}

Future<dynamic> listFilesFromAssets() async {
  final String manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  log("listFilesFromAssets: manifestMap='$manifestMap'");
  return manifestMap;
}

Future<File> writeByteDataToTempFile({required ByteData byteData, required String destinationFileName}) async {
  ByteBuffer _buffer = byteData.buffer;
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  String filePath = tempPath + destinationFileName;
  return File(filePath).writeAsBytes(_buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
}

class UtilsLocalFile {
  // static Future<ImageProvider> localFileTiffLoad({ByteData? fileBytes, String? directoryPath, String? fileName}) async {
  static Future<ImageProvider> localFileTiffLoad({required String directoryPath, required String fileName, required bool isFromAssets}) async {
    ImageProvider imgFinalToReturn = const AssetImage('assets/images/image-broken.png');
    File? _file;
    String fileFromFullPath = "";
    bool isFileExist = false;
    ByteData? byteData;
    fileFromFullPath = directoryPath + fileName;

    if (isFromAssets) {
      log("INFO: load file from assets path");

      String fileToHandle = "assets/images" + fileFromFullPath;
      log("INFO: fileToHandle='$fileToHandle'");
      byteData = await rootBundle.load(fileToHandle);
      log("INFO: byteData='${byteData.lengthInBytes}'");

      _file = await writeByteDataToTempFile(byteData: byteData, destinationFileName: fileFromFullPath);
    } else if (directoryPath != null && directoryPath != "" && fileName != null && fileName != "") {
      log("INFO: load file from full path");
      _file = File(fileFromFullPath);
    }
    isFileExist = await _file!.exists();

    if (isFileExist) {
      List<img.Image> listImgToReturn = [];
      img.Image? imgToReturn;
      List<int>? bytes;
      try {
        log("INFO: read bytes from file");
        bytes = _file.readAsBytesSync();
        // log("bytes='$bytes'");
        log("INFO: bytes OK (NOT NULL)");
      } catch (e) {
        log("ERROR: during getting bytes: e='$e'");
      }

      if (bytes != null) {
        try {
          var decoder = img.TiffDecoder();
          var info = decoder.startDecode(bytes);
          int numberFrames = decoder.numFrames();
          if (numberFrames == 0) {
            imgToReturn = decoder.decodeFrame(0);
          } else {
            for (int i = 0; i < numberFrames; i++) {
              if (i == 0) {
                imgToReturn = decoder.decodeFrame(i)!;
                listImgToReturn[i] = imgToReturn;
              } else {
                listImgToReturn[i] = decoder.decodeFrame(i)!;
              }
            }
          }
          log("INFO: STEP-DECODE: imgToReturn='$imgToReturn'");
        } catch (e) {
          log("ERROR: STEP-DECODE: during decoding: e='$e'");
        }

        if (imgToReturn != null) {
          try {
            Uint8List bytesForMemoryImg = img.encodePng(imgToReturn) as Uint8List;
            imgFinalToReturn = MemoryImage(bytesForMemoryImg);
            log("INFO: STEP-FINAL: imgFinalToReturn='$imgFinalToReturn'");
          } catch (e) {
            log("ERROR: STEP-FINAL: creation process: e='$e'");
          }
        } else {
          log("ERROR: STEP-FINAL: creation process: imgToReturn IS NULL");
        }
      }
    } else {
      log("ERROR: File does not exist");
    }

    return imgFinalToReturn;
  }
}
