import 'package:eventklip/fragments/folder_fragment/widgets/folder_widget.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:flutter/material.dart';

class FolderListWidget extends StatelessWidget {
  final List<FolderModel> folders;
  final Function(FolderModel) onClickItem;

  const FolderListWidget({Key key, this.folders, this.onClickItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        return FolderWidget(
          folderModel: folders[index],
          isListView: true,
          onClickItem: onClickItem,
        );
      },
    );
  }
}
