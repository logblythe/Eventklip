import 'package:eventklip/fragments/folder_fragment/parent_folders_fragment.dart';
import 'package:eventklip/fragments/folder_fragment/qr_fragment.dart';
import 'package:eventklip/fragments/folder_fragment/sub_folder_fragment.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderFragment extends StatefulWidget {
  @override
  _FolderFragmentState createState() => _FolderFragmentState();
}

class _FolderFragmentState extends State<FolderFragment> {
  final controller = PageController();
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
            body: WillPopScope(
              onWillPop: _onWillPop,
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: controller,
                onPageChanged: (page) => setState(() => _activePage = page),
                itemBuilder: (context, position) {
                  switch (position) {
                    case 0:
                      return ParentFoldersFragment();
                    case 1:
                      return SubFoldersFragment(
                        onQrClick: handleQrClick,
                        onBack: handleBack,
                      );
                    case 2:
                      return QrFragment(onBack: handleBack);
                    default:
                      return Container();
                  }
                },
                itemCount: 3,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_activePage != 0) {
      _activePage = _activePage - 1;
      animateControllerToPage(_activePage);
      return Future.value(false);
    }
    return Future.value(true);
  }

  void animateControllerToPage(int page) {
    controller.jumpToPage(page);
    /*  controller.animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );*/
  }

  handleQrClick() => animateControllerToPage(2);

  handleBack() {
    _activePage = _activePage - 1;
    animateControllerToPage(_activePage);
  }
}
