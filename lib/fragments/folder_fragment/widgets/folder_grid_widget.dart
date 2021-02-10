import 'package:eventklip/fragments/folder_fragment/widgets/folder_widget.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FolderGridWidget extends StatelessWidget {
  final List<FolderModel> folders;

  const FolderGridWidget({Key key, this.folders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.2),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        return FolderWidget(folderModel: folders[index]);
      },
    );
  }
}
