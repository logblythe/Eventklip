import 'package:eventklip/fragments/folder_fragment/widgets/folder_grid_widget.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/folder_list_widget.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/no_folder_widget.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ParentFoldersFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FolderState>(
      builder: (context, model, child) {
        List<FolderModel> folders = model.folders;
        return RefreshIndicator(
          onRefresh: () => model.getFolders(),
          child: Stack(
            children: [
              folders.isEmpty
                  ? NoFolderWidget()
                  : model.listView
                      ? FolderListWidget(folders: folders)
                      : FolderGridWidget(folders: folders),
              Loader()
                  .withSize(height: 40, width: 40)
                  .center()
                  .visible(model.loading),
            ],
          ),
        );
      },
    );
  }
}
