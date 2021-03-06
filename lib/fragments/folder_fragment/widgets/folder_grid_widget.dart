import 'package:eventklip/fragments/folder_fragment/widgets/folder_widget.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:flutter/material.dart';

class FolderGridWidget extends StatelessWidget {
  final List<FolderModel> folders;
  final Function(FolderModel) onClickItem;
  const FolderGridWidget({Key key, this.folders,this.onClickItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.2),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        return FolderWidget(
          folderModel: folders[index],
          isListView: false,
          onClickItem: onClickItem,
        );
      },
    );
  }
}
