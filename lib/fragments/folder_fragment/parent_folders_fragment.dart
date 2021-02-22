import 'package:eventklip/fragments/folder_fragment/sub_folder_fragment.dart';
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
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/utils/resources/colors.dart' as colors;

class ParentFoldersFragment extends StatefulWidget {
  @override
  _ParentFoldersFragmentState createState() => _ParentFoldersFragmentState();
}

class _ParentFoldersFragmentState extends State<ParentFoldersFragment> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final titleFocus = FocusNode();
  final descriptionFocus = FocusNode();
  String _name = '';
  String _description = '';
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
    var response = await showFolderCreationDialog() ?? false;
    if (response) {
      provider.createFolder(_name, _description).then((res) {
        _name = '';
        _description = '';
        provider.getFolders();
      });
    }
  }

  Future<T> showFolderCreationDialog<T>() async {
    return showDialog(
      barrierColor: Colors.white.withAlpha(5),
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Container(
            padding: EdgeInsets.all(spacing_large),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  text(context, "Folder information",
                      fontFamily: font_bold,
                      fontSize: ts_extra_normal,
                      textColor: colors.textColorPrimary),
                  formField(
                    context,
                    "hint_name",
                    maxLine: 1,
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    validator: (value) => value.isEmpty ? "Required" : null,
                    onSaved: (value) => _name = value,
                    textInputAction: TextInputAction.next,
                    focusNode: titleFocus,
                    nextFocus: descriptionFocus,
                  ).paddingBottom(spacing_standard_new),
                  formField(
                    context,
                    "hint_description",
                    maxLine: null,
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    validator: (value) => value.isEmpty ? "Required" : null,
                    onSaved: (value) => _description = value,
                    textInputAction: TextInputAction.next,
                    focusNode: descriptionFocus,
                  ).paddingBottom(spacing_standard_new),
                  Align(
                    child: button(context, 'Create', handleCreateFolder),
                    alignment: Alignment.centerRight,
                  ).paddingTop(spacing_standard_new)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void handleCreateFolder() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Navigator.pop(context, true);
    }
  }

  handleQrClick(FolderModel folderModel) {}

  handleBack() {}

  _onClickItem(
    FolderModel folderModel,
  ) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FolderEventDetailFragment(
        folder: folderModel,
      );
    }));
  }
}
