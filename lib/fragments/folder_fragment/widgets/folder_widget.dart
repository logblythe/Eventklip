import 'package:eventklip/models/folder_model.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_widgets.dart';
import '../../../utils/constants.dart';
import '../../../utils/resources/colors.dart';
import '../../../utils/resources/size.dart';

class FolderWidget extends StatelessWidget {
  final FolderModel folderModel;
  final bool isListView;
  final Function(FolderModel folderModel) onClickItem;

  FolderWidget({Key key, this.folderModel, this.isListView, this.onClickItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClickItem(folderModel),

      // model.selectFolder(folderModel);
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RowOrColumn(
            isRow: isListView,
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
                    text(context, folderModel.name ?? 'Default folder name',
                        fontSize: ts_extra_normal,
                        fontFamily: font_bold,
                        textColor: Colors.white),
                    MoreLessText(folderModel.description ??
                            'This is a default folder description')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
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
