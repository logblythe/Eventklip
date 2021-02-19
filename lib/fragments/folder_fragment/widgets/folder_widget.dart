import 'package:eventklip/models/folder_model.dart';
import 'package:eventklip/ui/widgets/upload_indicator_widget.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_widgets.dart';
import '../../../utils/constants.dart';
import '../../../utils/resources/colors.dart';
import '../../../utils/resources/size.dart';

class FolderWidget extends StatefulWidget {
  final FolderModel folderModel;

  const FolderWidget({Key key, this.folderModel}) : super(key: key);

  @override
  _FolderWidgetState createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> with AutomaticKeepAliveClientMixin{
  int _count=0;
  int _total=0;

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderState>(
      builder: (context, model, child) {
        return InkWell(
          onTap: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles();
            if (result != null) {
              String filePath = result.files.single.path;
              model.uploadFile(filePath, (count, total) {
                setState(() {
                  _count = count;
                  _total = total;
                });
              });
            } else {
              // todo User canceled the picker
            }
            // model.selectFolder(widget.folderModel);
          },
          child: UploadIndicatorWidget(
            progress: _count/_total,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RowOrColumn(
                  isRow: model.listView,
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 48,
                      color: colorPrimary,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: spacing_standard_new),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(context,
                              widget.folderModel.name ?? 'Default folder name',
                              fontSize: ts_extra_normal,
                              fontFamily: font_bold,
                              textColor: Colors.white),
                          model.listView
                              ? MoreLessText(widget.folderModel.description ??
                                  'This is a default folder description')
                              : text(
                                  context, widget.folderModel.name ?? "Default")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class RowOrColumn extends StatelessWidget {
  final isRow;
  final List<Widget> children;

  const RowOrColumn({Key key, this.isRow, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isRow
        ? Row(
            children: children,
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        : Column(
            children: children,
            crossAxisAlignment: CrossAxisAlignment.start,
          );
  }
}
