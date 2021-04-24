import 'package:eventklip/fragments/folder_fragment/sub_folder_fragment.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/event_create_fragment.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/folder_grid_widget.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/folder_list_widget.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/no_folder_widget.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:eventklip/utils/app_widgets.dart';

class ParentFoldersFragment extends StatefulWidget {
  @override
  _ParentFoldersFragmentState createState() => _ParentFoldersFragmentState();
}

class _ParentFoldersFragmentState extends State<ParentFoldersFragment> {
  FolderState provider;
  bool isListView = false;

  toggleListView() {
    setState(() {
      isListView = !isListView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderState>(
      builder: (context, model, child) {
        provider = model;
        List<FolderModel> folders = model.folders;
        return Scaffold(
          appBar: appBarLayout(
            context,
            keyString(context, "folders"),
            actions: [
              InkWell(
                child: Icon(isListView ? Icons.grid_view : Icons.list_rounded),
                onTap: toggleListView,
              ).paddingRight(12),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => model.getFolders(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  folders.isEmpty
                      ? NoFolderWidget()
                      : isListView
                          ? FolderListWidget(
                              folders: folders,
                              onClickItem: (folderModel) =>
                                  _onClickItem(folderModel))
                          : FolderGridWidget(
                              folders: folders,
                              onClickItem: (folderModel) =>
                                  _onClickItem(folderModel)),
                  Loader()
                      .withSize(height: 40, width: 40)
                      .center()
                      .visible(model.loading),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () => handleFabPress(context),
          ),
        );
      },
    );
  }

  void handleFabPress(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: provider,
            child: EventCreateFragment(),
          );
        },
      ),
    );
  }

  handleQrClick(FolderModel folderModel) {}

  handleBack() {}

  Future<dynamic> _onClickItem(FolderModel folderModel) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FolderEventDetailFragment(
            folder: folderModel,
          );
        },
      ),
    );
  }
}
