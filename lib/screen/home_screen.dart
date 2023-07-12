import 'package:flutter/material.dart';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_editor/model/sticker_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_editor/component/emoticon_sticker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image;
  Set<StickerModel> stickers = {};
  String? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        renderBody(),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: MainAppBar(
            onPickImage: onPickImage,
            onSaveImage: onSaveImage,
            onDeleteItem: onDeleteItem,
          ),
        ),
        if (image != null)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Footer(onEmoticonTap: onEmoticonTap)),
      ]),
    );
  }

  void onPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
    });
  }

  void onSaveImage() {}

  void onDeleteItem()async{
    setState((){
      
    });
  }
  Widget renderBody() {
    if (image != null) {
      return Positioned.fill(
          child: InteractiveViewer(
              child: Stack(fit: StackFit.expand, children: [
        Image.file(File(image!.path), fit: BoxFit.cover),
        ...stickers.map((sticker) => Center(
              child: EmoticonSticker(
                key: ObjectKey(sticker.id),
                onTransform: () {onTransform(sticker.id)},
                imgPath: sticker.imgPath,
                isSelected: selectedId == sticker.id,
              ),
            )),
      ])));
    } else {
      return Center(
          child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
        ),
        onPressed: onPickImage,
        child: const Text('이미지 선택하기'),
      ));
    }
  }

  void onEmoticonTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(id:const Uuid().v4(), imgPath:'images/emoticon_$index.png',)
      };
    });
  }

  void onTransform(String id) {
    setState((){
      selectedId = id;
    });
  }
}
