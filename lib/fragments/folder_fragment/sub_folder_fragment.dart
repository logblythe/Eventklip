import 'package:eventklip/fragments/folder_fragment/widgets/folder_widget.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/no_folder_widget.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubFoldersFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FolderState>(builder: (context, model, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FolderWidget(folderModel: model.selectedFolder),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoFolderWidget(
                  title: 'No records found for ${model.selectedFolder.name}',
                  subtitle:
                  'Images and videos will be available once users upload to this event.',
                )
              ],
            ),
          ),
        ],
      );
    });

  }
}
