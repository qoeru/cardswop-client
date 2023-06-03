import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'localenv.dart';

class Globals {
  static const Map<String, String> corsHeaders = {};

  List<ListTile> imageContextMenu(BuildContext context, String? imgUrl) => [
        ListTile(
          title: const Text('Копировать изображение'),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Скачать изображение'),
          onTap: imgUrl == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  WebImageDownloader.downloadImageFromWeb(imgUrl);
                },
        ),
      ];

  List<ListTile> textContextMenuButtons(
          TextEditingController controller, BuildContext context) =>
      [
        ListTile(
          title: const Text('Копировать'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        ListTile(
            title: const Text('Вырезать'),
            onTap: () {
              Navigator.of(context).pop();
              int start = controller.selection.start;
              int end = controller.selection.end;
              //Copy content
              String content = controller.text.substring(start, end);
              Clipboard.setData(ClipboardData(text: content));
              //Cut content
              String p1 = controller.text.substring(0, start);
              String p2 = controller.text.substring(end);
              controller.text = p1 + p2;
              controller.selection =
                  TextSelection.fromPosition(TextPosition(offset: start));
            }),
        ListTile(
          title: const Text('Вставить'),
          onTap: () async {
            Navigator.of(context).pop();
            int start = controller.selection.start;
            int end = controller.selection.end;

            String p1 = controller.text.substring(0, start);
            String p2 = controller.text.substring(end);
            controller.text = p1 + p2;
            controller.selection =
                TextSelection.fromPosition(TextPosition(offset: start));
            String? value = (await Clipboard.getData("text/plain"))?.text;
            if (value != null) {
              String p1 = controller.text.substring(0, start);
              String p2 = controller.text.substring(start);
              controller.text = p1 + value + p2;
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: start + value.length));
              // Move cursor to end on paste, as one does on desktop :)
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: start + value.length));
            }
          },
        ),
        ListTile(
          title: const Text('Выбрать все'),
          onTap: () {
            Navigator.of(context).pop();

            controller.selection = TextSelection(
                baseOffset: 0, extentOffset: controller.text.length);
          },
        ),
        ListTile(
          title: const Text('Удалить'),
          onTap: () {
            Navigator.of(context).pop();

            controller.clear();
          },
        ),
      ];
}
