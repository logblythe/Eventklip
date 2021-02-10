import 'package:eventklip/fragments/folder_fragment/widgets/folder_widget.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class FolderListWidget extends StatelessWidget {
  final List<FolderModel> folders;

  const FolderListWidget({Key key, this.folders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        return FolderWidget(folderModel: folders[index])
            .paddingBottom(16)
            .paddingRight(8)
            .paddingLeft(8);
      },
    );
  }
}
