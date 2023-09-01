import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

class PreviewPhoto extends StatefulWidget {
  final File file;

  const PreviewPhoto({super.key, required this.file});

  @override
  State<PreviewPhoto> createState() => _PreviewPhotoState();
}

class _PreviewPhotoState extends State<PreviewPhoto> {
  late TextureSource texture;
  late BrightnessShaderConfiguration configuration;
  bool textureLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    configuration = BrightnessShaderConfiguration();
    configuration.brightness = 0.5;

    TextureSource.fromFile(widget.file)
        .then((value){
      print("dataz : " + value.toString());
      texture = value;
    })
        .whenComplete(
          () => setState(() {
        textureLoaded = true;
      }),
    );
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Image.file(
              widget.file,
              height: 400,
              width: 400,
            ),
          ),
          const SizedBox(
            height: 10
          ),
          SizedBox(
            height: 200,
            child:   textureLoaded
                ? ImageShaderPreview(
              texture: texture,
              configuration: configuration,
            )
                : const Offstage(),
          )
        ],
      ),
    );
  }
}
