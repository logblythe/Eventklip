import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventklip/api/folders_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/create_qr_payload.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:eventklip/view_models/folder_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/utils/resources/colors.dart' as colors;
import 'package:provider/provider.dart';

class QrFragment extends StatefulWidget {
  final FolderModel folder;

  const QrFragment({Key key, @required this.folder}) : super(key: key);

  @override
  _QrFragmentState createState() => _QrFragmentState();
}

class _QrFragmentState extends State<QrFragment> {
  final formKey = GlobalKey<FormState>();
  final scansController = TextEditingController();
  final durationController = TextEditingController();
  final dateController = TextEditingController();
  final scansFocus = FocusNode();
  final dateFocus = FocusNode();
  final durationFocus = FocusNode();
  String _expiryDate = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLayout(
        context,
        "",
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              widget.folder.qrLocation != null
                  ? buildQr()
                  : buildColumn(context),
              loading
                  ? Loader()
                      .withSize(height: 40, width: 40)
                      .center()
                      .visible(true)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  buildColumn(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          text(
            context,
            "Please fill up these information required to generate Qr Code.",
            fontFamily: font_bold,
            fontSize: ts_extra_normal,
            textColor: colors.textColorPrimary,
            isLongText: true,
          ).paddingBottom(spacing_large),
          formField(
            context,
            "hint_no_of_scans",
            maxLine: 1,
            controller: scansController,
            keyboardType: TextInputType.number,
            validator: (value) => value.isEmpty ? "Required" : null,
            textInputAction: TextInputAction.next,
            focusNode: scansFocus,
            nextFocus: dateFocus,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "hint_event_expiry",
            readOnly: true,
            showCursor: false,
            onTap: () => handleDateSelection(context),
            maxLine: 1,
            controller: dateController,
            keyboardType: TextInputType.number,
            validator: (value) => value.isEmpty ? "Required" : null,
            textInputAction: TextInputAction.next,
            focusNode: dateFocus,
            nextFocus: durationFocus,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "hint_video_duration",
            maxLine: 1,
            controller: durationController,
            keyboardType: TextInputType.number,
            validator: (value) => value.isEmpty ? "Required" : null,
            textInputAction: TextInputAction.next,
            focusNode: durationFocus,
          ).paddingBottom(spacing_standard_new),
          Align(
            child: button(context, 'Create', handleCreateQr),
            alignment: Alignment.centerRight,
          ).paddingTop(spacing_standard_new)
        ],
      ),
    );
  }

  Widget buildQr() {
    return Center(
      child: CachedNetworkImage(imageUrl: widget.folder.qrLocation),
    );
  }

  void handleDateSelection(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(backgroundColor: Colors.grey),
      onConfirm: (date, _) {
        _expiryDate =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date.toUtc());
        dateController.text = date.toLocal().toString().substring(0, 10);
      },
    );
  }

  Future<void> handleCreateQr() async {
    if (formKey.currentState.validate()) {
      FoldersApi _foldersApi = getIt.get<FoldersApi>();
      try {
        setState(() {
          loading=true;
        });
        final response = await _foldersApi.createQr(CreateQRPayload(
          eventId: widget.folder.id,
          noOfScans: int.parse(scansController.text),
          expiryDate: _expiryDate,
          noOfImgLimit: 20,
          noOfVideoLimit: 20,
          duration: int.parse(durationController.text),
        ).toJson());
        if(response.success){

        }
      } catch (e) {
        setState(() {
          loading=false;
        });
      }
    }
  }
}
