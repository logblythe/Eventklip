import 'dart:io';

import 'package:eventklip/models/user_profile.dart';
import 'package:eventklip/ui/widgets/user_avatar_widget.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/images.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eventklip/utils/widget_extensions.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool passwordVisible = false;
  bool isRemember = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController dummycontroller = new TextEditingController();
  TextEditingController _contactController = new TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _contactFocusNode = FocusNode();
  FocusNode _workTitleFocusNode = FocusNode();
  var contact;
  var name;
  var userName;
  var userEmail;
  var userId;
  File imageFile;
  bool isLoading = false;
  bool loadFromFile = false;
  var workTitle;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    setState(() {
      userName = "Vicotria Becks";
      userEmail = "vicotriabecks@gmail.com";
      contact = "";

      _nameController.text = userName;
      dummycontroller.text = "userName";
      _contactController.text = contact;
    });
  }

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    if (image != null) {
      setState(() {
        imageFile = image;
        loadFromFile = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventklipAppState>(builder: (context, provider, child) {
      return Scaffold(
        appBar: appBarLayout(context, keyString(context, "edit_profile")),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getProfilePhoto(provider.userProfile),
                  getForm(provider.userProfile),
                  SizedBox(
                    width: double.infinity,
                    child: button(
                      context,
                      keyString(context, "back"),
                      () {
                        Navigator.of(context).pop();
                        if (isLoading) {
                          return;
                        }
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          // provider.updateProfile()
                        }
                      },
                    ).paddingOnly(top: 30, left: 18, right: 18, bottom: 30),
                  )
                ],
              ),
            ),
            loadingWidgetMaker().visible(isLoading)
          ],
        ),
      );
    });
  }

  Widget getForm(UserProfile userProfile) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          formField(
            context,
            "hint_email",
            initialValue: userProfile.email,
            isEnabled: false,
            focusNode: _emailFocusNode,
            nextFocus: _nameFocusNode,
            validator: (value) {
              return value.validateEMail(context);
            },
            onSaved: (String value) {
              userEmail = value;
            },
            suffixIcon: Icons.mail_outline,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "name",
            isEnabled: false,
            initialValue: userProfile.fullname,
            focusNode: _nameFocusNode,
            nextFocus: _contactFocusNode,
            validator: (value) {
              return value.isEmpty
                  ? keyString(context, "error_name_required")
                  : null;
            },
            onSaved: (String value) {
              name = value;
            },
            suffixIcon: Icons.person_outline,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "phone_no",
            isEnabled: false,
            initialValue: userProfile.phoneNumber  ?? "Not updated",
            focusNode: _contactFocusNode,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validator: (value) {
              return value.isEmpty
                  ? keyString(context, "error_phone_requires")
                  : null;
            },
            onSaved: (String value) {
              contact = value;
            },
            suffixIcon: Icons.phone,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "work_title",
            isEnabled: false,
            initialValue: userProfile.phoneNumber ?? "Not updated",
            focusNode: _workTitleFocusNode,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            onSaved: (String value) {
              workTitle = value;
            },
            suffixIcon: Icons.work,
          ).paddingBottom(spacing_standard_new),
        ],
      ),
    ).paddingOnly(
        left: spacing_standard_new, right: spacing_standard_new, top: 36);
  }

  Widget getProfilePhoto(UserProfile userProfile) {
    return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Colors.transparent,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: spacing_standard_new,
              margin: EdgeInsets.all(0),
              child: loadFromFile
                  ? Image.file(
                      imageFile,
                      height: 95,
                      width: 95,
                      fit: BoxFit.cover,
                    )
                  : userProfile != null
                      ? UserAvatarWithInitials(userProfile.fullname)
                      : Image.asset(ic_profile, width: 95, height: 95),
            ).onTap(() {
              // getImage(ImgSource.Both);
            }),
          ],
        ).paddingOnly(top: 16));
  }
}
