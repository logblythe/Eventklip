import 'package:eventklip/fragments/folder_fragment/widgets/no_folder_widget.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eventklip/utils/resources/colors.dart' as colors;

class SubFoldersFragment extends StatelessWidget {
  final Function onQrClick;
  final Function onBack;

  const SubFoldersFragment({Key key, this.onQrClick, this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderState>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: appBarLayout(
            context,
            model.selectedFolder.name ?? "-",
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colors.white),
              onPressed: onBack,
            ),
            actions: [
              InkWell(
                child: Icon(Icons.qr_code),
                onTap: onQrClick,
              ).paddingRight(12),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NoFolderWidget(
                      title:
                          'No records found for ${model.selectedFolder.name}',
                      subtitle:
                          'Images and videos will be available once users upload to this event.',
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
