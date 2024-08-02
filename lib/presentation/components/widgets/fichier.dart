import 'dart:io';

import 'package:cookbook_ia/core/setting.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class Fichier extends StatefulWidget {

  final String titre;
  final TextEditingController filepath;
  Fichier({
    required this.titre,
    required this.filepath
  }): super();

  @override
  FichierState createState() => FichierState(titre: titre, filepath: filepath);
}

class FichierState extends State<Fichier> {

  final String titre;
  final TextEditingController filepath;

  FichierState({
    required this.titre,
    required this.filepath
  }): super();

  String? _retrieveDataError;
  bool isVisible = false;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  List<XFile> _mediaFileList = [];
  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList.add(value!);
    filepath.text = value.path;
  }

  Future<void> _onImageButtonPressed(
      ImageSource source, {
      required BuildContext context,
      bool isMultiImage = false,
      bool isMedia = false,
    }) async {
    
    if (context.mounted) {
      if (isMedia) {
        await _displayPickImageDialog(context,
            (double? maxWidth, double? maxHeight, int? quality) async {
          try {
            final List<XFile> pickedFileList = <XFile>[];
            final XFile? media = await _picker.pickMedia(
              //maxWidth: maxWidth,
              //maxHeight: maxHeight,
              imageQuality: quality,
            );
            if (media != null) {
              pickedFileList.add(media);
              setState(() {
                _mediaFileList = pickedFileList;
              });
            }
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      } else {
        await _displayPickImageDialog(context,
            (double? maxWidth, double? maxHeight, int? quality) async {
          try {
            final XFile? pickedFile = await _picker.pickImage(
              source: source,
             // maxWidth: maxWidth,
             // maxHeight: maxHeight,
              imageQuality: quality,
            );
            setState(() {
              print("choix de photo");
              _setImageFileListFromFile(pickedFile);
              isVisible = true;
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return GestureDetector(
        onTap: () {
          _showSelectionDialog(context);
        },
        child: Column(children:[
          Center(child: Text(titre,  style: TextStyle(  color: Setting.patientColor, height: 1.5, fontWeight: FontWeight.normal,  fontSize: 15.0), ),),
          const SizedBox(height: 10,),
          (this.filepath.text.isEmpty) ? Image.file(File(_mediaFileList[0]!.path), width: 300, fit: BoxFit.fill,): Image.file(File(this.filepath.text.toString()), width: 300, fit: BoxFit.fill,),
        ])
      );
    } else if (_pickImageError != null) {
      return Center(
          child: Text(
        'Erreur : $_pickImageError',
      ));
    } else {
      return const Center(child: Text(""));
    }
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
      double? width = maxWidthController.text.isNotEmpty
          ? double.parse(maxWidthController.text)
          : 100.0;

      double? height = maxHeightController.text.isNotEmpty
          ? double.parse(maxHeightController.text)
          : 100.0;

      int? quality = qualityController.text.isNotEmpty
          ? int.parse(qualityController.text)
          : 100;

    onPick(width!, height!, quality!);
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context)!.photo1_title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(AppLocalizations.of(context)!.photo2_title),
                      onTap: () {
                        Navigator.pop(
                            context, AppLocalizations.of(context)!.cancel_title);
                        _onImageButtonPressed(ImageSource.gallery,
                            context: context);
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text(AppLocalizations.of(context)!.photo3_title),
                      onTap: () {
                        Navigator.pop(
                            context, AppLocalizations.of(context)!.cancel_title);
                        _onImageButtonPressed(ImageSource.camera,
                            context: context);
                      },
                    )
                  ],
                ),
              ));
        });
  }
  
  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                  (this.filepath.text.isEmpty)
                      ? GestureDetector( 
                          onTap:() => _showSelectionDialog(context),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 5, top: 0),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                color: Colors.grey,
                                radius: const Radius.circular(12),
                                padding: const EdgeInsets.all(1),
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    width: double.infinity,
                                    height: 160,
                                    color: Setting.white,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset("img/path.png",
                                              width: 50.0,
                                              fit: BoxFit.contain,
                                              alignment: Alignment.center),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            titre,
                                            style: TextStyle(
                                                color: Setting.patientColor,
                                                height: 1.5,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15.0),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.pic_2,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                height: 1.5,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        )
                      : Container(),
                  (!this.filepath.text.isEmpty)
                      ? Container(
                          child: _previewImage(),
                        )
                      : Container(),
                   (!this.filepath.text.isEmpty)
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = false;
                                if(_mediaFileList.length > 1) _mediaFileList.removeAt(0);
                                filepath.text = "";
                              });
                            },
                            child: Text(
                              AppLocalizations.of(context)!.pic_3,
                              style: const TextStyle(
                                  color: Colors.red,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                          ),
                        )
                      : Container(),
      ],
    );
  }

}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);