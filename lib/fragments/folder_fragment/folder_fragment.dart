import 'package:eventklip/fragments/folder_fragment/parent_folders_fragment.dart';
import 'package:eventklip/fragments/folder_fragment/sub_folder_fragment.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eventklip/utils/resources/colors.dart' as colors;
import 'package:provider/provider.dart';

class FolderFragment extends StatefulWidget {
  @override
  _FolderFragmentState createState() => _FolderFragmentState();
}

class _FolderFragmentState extends State<FolderFragment> {
  final formKey = GlobalKey<FormState>();
  final controller = PageController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final titleFocus = FocusNode();
  final descriptionFocus = FocusNode();
  String _name = '';
  String _description = '';
  int _activePage = 0;
  FolderState provider;

  @override
  void didUpdateWidget(covariant FolderFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (provider != null) {
      provider.folderSelectionStream.listen(
        (folder) {
          animateControllerToPage(1);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FolderState>(
      create: (context) => FolderState(),
      child: Consumer<FolderState>(
        builder: (context, model, child) {
          provider = model;
          provider.folders.sort((a, b) {
            return b.createdDate.compareTo(a.createdDate);
          });
          return Scaffold(
            appBar: appBarLayout(
              context,
              keyString(context, "folders"),
              actions: [
                InkWell(
                  child: Icon(
                      model.listView ? Icons.grid_view : Icons.list_rounded),
                  onTap: model.toggleListView,
                ).paddingRight(12),
              ],
            ),
            body: WillPopScope(
              onWillPop: _onWillPop,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  onPageChanged: (page) => setState(() => _activePage = page),
                  itemBuilder: (context, position) {
                    switch (position) {
                      case 0:
                        return ParentFoldersFragment();
                      case 1:
                        return SubFoldersFragment();
                      default:
                        return Container();
                    }
                  },
                  itemCount: provider.selectedFolder != null ? 2 : 1,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () => handleFabPress(context),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_activePage != 0) {
      animateControllerToPage(0);
      return Future.value(false);
    }
    return Future.value(true);
  }

  void animateControllerToPage(int page) {
    controller.animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
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
}
