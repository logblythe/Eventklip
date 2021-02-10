import 'package:eventklip/models/folder_model.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderWidget extends StatelessWidget {
  final FolderModel folderModel;

  const FolderWidget({Key key, this.folderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderState>(
      builder: (context, model, child) {
        return InkWell(
          onTap: () {
            model.selectFolder(folderModel);
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.folder_shared, size: 48),
                text(
                  context,
                  folderModel.name ?? 'Default folder name',
                  fontSize: ts_extra_normal,
                ),
                text(
                  context,
                  folderModel.description ??
                      'This is a default folder description',
                  isLongText: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
