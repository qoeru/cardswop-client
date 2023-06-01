import 'package:context_menus/context_menus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader_web/image_downloader_web.dart';

class TextContextMenu extends StatelessWidget {
  const TextContextMenu({super.key, required this.selectedText});

  final String? selectedText;

  @override
  Widget build(BuildContext context) {
    return GenericContextMenu(
      buttonConfigs: [
        ContextMenuButtonConfig('Копировать текст', onPressed: () {
          if (selectedText != null) {
            Clipboard.setData(ClipboardData(text: selectedText!));
          }
          context.contextMenuOverlay.hide();
        }),
      ],
    );
  }
}

class ImageContextMenu extends StatelessWidget {
  const ImageContextMenu(
      {super.key, required this.image, this.isAsset = false});

  /// Может быть как и Uint8List, так и String, поэтому пока будет просто без explicit type annotation
  final image;

  /// Определяет является ли переданная строка путем к ассету или url
  final bool isAsset;

  @override
  Widget build(BuildContext context) {
    return GenericContextMenu(buttonConfigs: [
      ContextMenuButtonConfig('Сохранить изображение', onPressed: () async {
        if (kIsWeb) {
          if (image is String && !isAsset) {
            final ByteData bytes = await rootBundle.load(image);
            final Uint8List list = bytes.buffer.asUint8List();
            await WebImageDownloader.downloadImageFromUInt8List(
                uInt8List: list);
          }

          if (image is Uint8List) {
            await WebImageDownloader.downloadImageFromUInt8List(
                uInt8List: image);
          }
          if (image is String && isAsset) {
            await WebImageDownloader.downloadImageFromWeb(image);
          }
        }
      })
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('image', image));
    properties.add(DiagnosticsProperty('image', image));
  }
}

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS, PUT',
  'Access-Control-Allow-Headers': '*',
  "Content-Type": "application/json",
};
