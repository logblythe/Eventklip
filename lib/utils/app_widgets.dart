import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/screens/eventklip_movie_detail_screen.dart';
import 'package:eventklip/ui/widgets/movie_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:eventklip/screens/movie_detail_screen.dart';
import 'package:eventklip/utils/percent_indicator.dart';
import 'package:eventklip/utils/resources/colors.dart' as colors;
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/utils/slider_widget.dart';
import 'package:flutter/services.dart';
import 'app_localizations.dart';
import 'constants.dart';
import 'dots_indicator/dots_decorator.dart';
import 'package:nb_utils/nb_utils.dart';

Widget text(context, var text,
    {var fontSize = ts_medium,
    textColor = colors.textColorSecondary,
    var fontFamily = font_regular,
    var isCentered = false,
    var maxLine = 1,
    var fontStyle,
    var height = 1.5,
    var latterSpacing = 0.1,
    var isLongText = false,
    var isJustify = false,
    var aDecoration}) {
  return Text(
    text,
    textAlign: isCentered
        ? TextAlign.center
        : isJustify
            ? TextAlign.justify
            : TextAlign.start,
    maxLines: isLongText ? 99 : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: aDecoration != null ? aDecoration : null,
        fontSize: double.parse(fontSize.toString()).toDouble(),
        height: height,
        color: textColor == colors.textColorSecondary
            ? Theme.of(context).textTheme.subtitle2.color
            : textColor.toString().isNotEmpty
                ? textColor
                : null,
        letterSpacing: latterSpacing),
  );
}

Widget toolBarTitle(BuildContext context, String title) {
  return text(context, title,
      fontSize: ts_large,
      textColor: Theme.of(context).textTheme.headline6.color,
      fontFamily: font_bold);
}

Widget screenTitle(BuildContext context, var aHeadingText) {
  return text(context, aHeadingText,
      fontSize: ts_xlarge,
      fontFamily: font_bold,
      textColor: Theme.of(context).textTheme.headline6.color);
}

Widget itemTitle(BuildContext context, var titleText,
    {var fontfamily = font_medium, fontSize = ts_normal}) {
  return text(context, titleText,
      fontSize: fontSize,
      fontFamily: fontfamily,
      textColor: Theme.of(context).textTheme.headline6.color);
}

Widget itemSubTitle(BuildContext context, var titleText,
    {var fontFamily = font_regular,
    var fontsize = ts_normal,
    var maxLines,
    var colorThird = false,
    isLongText = true}) {
  return text(context, titleText,
      fontSize: fontsize,
      fontFamily: fontFamily,
      isLongText: isLongText,
      maxLine: maxLines,
      textColor: colorThird
          ? Theme.of(context).textTheme.caption.color
          : Theme.of(context).textTheme.subtitle2.color);
}

// ignore: must_be_immutable
class MoreLessText extends StatefulWidget {
  var titleText;
  var fontFamily = font_regular;
  var fontsize = ts_normal;
  var colorThird = false;

  MoreLessText(this.titleText,
      {this.fontFamily = font_regular,
      this.fontsize = ts_normal,
      this.colorThird = false});

  @override
  MoreLessTextState createState() => MoreLessTextState();
}

class MoreLessTextState extends State<MoreLessText> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(
          text: widget.titleText,
          style: TextStyle(
              fontSize: widget.fontsize, fontFamily: widget.fontFamily));
      final tp = TextPainter(
          text: span, maxLines: 2, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: size.maxWidth);

      if (tp.didExceedMaxLines) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text(context, widget.titleText,
                fontSize: widget.fontsize,
                fontFamily: widget.fontFamily,
                isLongText: isExpanded,
                maxLine: 2,
                textColor: widget.colorThird
                    ? Theme.of(context).textTheme.caption.color
                    : Theme.of(context).textTheme.subtitle2.color),
            text(
              context,
              isExpanded ? "Read less" : "Read more",
              textColor: colors.colorPrimary,
              fontSize: widget.fontsize,
            ).onTap(() {
              setState(() {
                isExpanded = !isExpanded;
              });
            })
          ],
        );
      } else {
        return text(context, widget.titleText,
            fontSize: widget.fontsize,
            fontFamily: widget.fontFamily,
            isLongText: isExpanded,
            maxLine: 2,
            textColor: widget.colorThird
                ? Theme.of(context).textTheme.caption.color
                : Theme.of(context).textTheme.subtitle2.color);
      }
    });
  }
}

Widget headingText(BuildContext context, var titleText) {
  return text(context, titleText,
      fontSize: ts_extra_normal,
      fontFamily: font_bold,
      textColor: Theme.of(context).textTheme.headline6.color);
}

Widget headingWidViewAll(BuildContext context, var titleText, callback,
    {bool showViewAll}) {
  return Row(
    children: <Widget>[
      Expanded(
        child: headingText(context, titleText),
      ),
      showViewAll
          ? InkWell(
              onTap: callback,
              child: itemSubTitle(context, keyString(context, "view_more"),
                      fontsize: ts_medium,
                      fontFamily: font_medium,
                      colorThird: true)
                  .paddingAll(spacing_control_half))
          : Container()
    ],
  );
}

Widget appBarLayout(context, text, {darkBackground = true, leading, actions}) {
  return AppBar(
    elevation: 0,
    centerTitle: false,
    title: toolBarTitle(context, text),
    backgroundColor: darkBackground
        ? Theme.of(context).scaffoldBackgroundColor
        : Colors.transparent,
    actions: actions,
    leading: leading,
  );
}

BoxDecoration boxDecoration(BuildContext context,
    {double radius = 2,
    Color color = Colors.transparent,
    Color bgColor = white,
    var showShadow = false}) {
  return BoxDecoration(
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      color: bgColor == white ? Theme.of(context).cardTheme.color : bgColor,
      boxShadow: showShadow
          ? [
              BoxShadow(
                  color: Theme.of(context).hoverColor.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 3,
                  offset: Offset(1, 3))
            ]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

Widget assetImage(String image,
    {String aPlaceholder = "",
    double aWidth,
    double aHeight,
    var fit = BoxFit.fill}) {
  return Image.asset(
    image,
    width: aWidth,
    height: aHeight,
    fit: fit,
  );
}

Widget networkImage(String image,
    {String aPlaceholder = "assets/images/logo_round_2.png",
    double aWidth,
    double aHeight,
    var fit = BoxFit.cover}) {
  return image != null && image.isNotEmpty
      ? FadeInImage(
          placeholder: AssetImage(
            aPlaceholder,
          ),
          image: CachedNetworkImageProvider("$assetUrl$image"),
          width: aWidth != null ? aWidth : null,
          height: aHeight != null ? aHeight : null,
          fit: fit,
        )
      : Image.asset(
          aPlaceholder,
          width: aWidth,
          height: aHeight,
          fit: BoxFit.fill,
        );
}

Widget button(BuildContext context, buttonText, VoidCallback callback) {
  return MaterialButton(
    textColor: Theme.of(context).primaryColor,
    color: Theme.of(context).primaryColor,
    splashColor: Colors.grey.withOpacity(0.2),
    disabledColor: Theme.of(context).primaryColor.withOpacity(0.3),
    padding: EdgeInsets.only(top: 12, bottom: 12),
    child: text(context, buttonText,
        fontSize: ts_normal,
        fontFamily: font_medium,
        textColor: Theme.of(context).textTheme.button.color),
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(spacing_control),
      side: BorderSide(color: Theme.of(context).primaryColor),
    ),
    onPressed: callback,
  );
}

Widget iconButton(context, buttonText, icon, callBack,
    {backgroundColor,
    borderColor,
    buttonTextColor,
    iconColor,
    padding = 12.0}) {
  return MaterialButton(
    color: backgroundColor == null
        ? Theme.of(context).primaryColor
        : backgroundColor,
    splashColor: Colors.grey.withOpacity(0.2),
    padding: EdgeInsets.only(top: padding, bottom: padding),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        iconColor == null
            ? Image.asset(
                icon,
                width: 16,
                height: 16,
                color: Colors.white,
              )
            : Image.asset(
                icon,
                width: 16,
                height: 16,
                color: iconColor,
              ),
        text(context, buttonText,
                fontSize: ts_normal,
                fontFamily: font_medium,
                textColor: buttonTextColor == null
                    ? Theme.of(context).textTheme.button.color
                    : buttonTextColor)
            .paddingLeft(spacing_standard),
      ],
    ),
    shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(spacing_control),
        side: BorderSide(
            width: 0.8,
            color: borderColor == null
                ? Theme.of(context).primaryColor
                : borderColor)),
    onPressed: callBack,
  );
}

DotsDecorator dotsDecorator(context) {
  return DotsDecorator(
      color: Colors.grey.withOpacity(0.5),
      activeColor: Theme.of(context).primaryColor,
      activeSize: Size.square(8.0),
      size: Size.square(6.0),
      spacing: EdgeInsets.all(spacing_control_half));
}

Widget muviTitle(context) {
  return Image.asset("assets/images/eventklipround.png", height: 32);
}

Widget loadingWidgetMaker() {
  return Container(
    alignment: Alignment.center,
    child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: spacing_control,
        margin: EdgeInsets.all(4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        )),
  );
}

Widget notificationIcon(context, cartCount) {
  return InkWell(
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.only(right: 12),
          child: Icon(
            Icons.notifications_none,
            color: Theme.of(context).iconTheme.color,
            size: 24,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(top: spacing_standard),
            padding: EdgeInsets.all(4),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: text(context, cartCount.toString(),
                fontSize: 12, textColor: white),
          ).visible(cartCount != 0),
        )
      ],
    ),
    onTap: () {},
  );
}

Widget placeholderWidget() =>
    Image.asset('assets/images/logo_round_2.png', fit: BoxFit.cover);

Function(BuildContext, String) placeholderWidgetFn() =>
    (_, s) => placeholderWidget();

Widget commonCacheImageWidget(String url,
    {double width, BoxFit fit, double height}) {
  return CachedNetworkImage(
    placeholder: placeholderWidgetFn(),
    imageUrl: "$assetUrl$url",
    height: height,
    width: width,
    fit: fit,
  );
}

// ignore: must_be_immutable
class HomeSliderWidget extends StatelessWidget {
  List<VideoDetails> videos;
  bool isMovie = false;

  HomeSliderWidget(this.videos, {this.isMovie});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - 36;
    final Size cardSize = Size(width, width / 1.6);
    return SliderWidget(
      viewportFraction: 0.92,
      height: cardSize.height,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
      items: videos.map((video) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: cardSize.height,
              margin: EdgeInsets.symmetric(horizontal: spacing_control),
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing_control),
                ),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    assetImage(video.thumbnailLocation,
                        aWidth: cardSize.width,
                        aHeight: cardSize.height,
                        fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                            Colors.transparent,
                            Theme.of(context).scaffoldBackgroundColor,
                          ],
                              stops: [
                            0.0,
                            1.0
                          ],
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              tileMode: TileMode.repeated)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          itemTitle(context, video.title, fontSize: ts_large),
                          Row(
                            children: <Widget>[
                              viewCountWidget(context, video.views)
                                  .paddingRight(spacing_standard)
                                  .visible(video.isHD),
                              itemSubTitle(context, "2018"),
                              itemSubTitle(context, "17+")
                                  .paddingLeft(spacing_standard)
                            ],
                          ).paddingTop(spacing_control_half)
                        ],
                      ).paddingOnly(
                          left: spacing_standard,
                          bottom: spacing_standard,
                          top: 40),
                    )
                  ],
                ),
              ).paddingBottom(spacing_control),
            ).onTap(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventklipVideoDetailScreen(
                            movie: video,
                          )));
            });
          },
        );
      }).toList(),
    );
  }
}

// ignore: must_be_immutable
class ItemHorizontalList extends StatelessWidget {
  final list;
  final isMovie;

  final Function(VideoDetails) onVideoTap;

  ItemHorizontalList(this.list, {this.isMovie = false, this.onVideoTap});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: ((width / 1.7) - 36) * (2.5 / 4) + 19,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          padding: EdgeInsets.only(
              left: spacing_standard, right: spacing_standard_new),
          itemBuilder: (context, index) {
            return MovieTile(list[index], onVideoTap: onVideoTap);
          }),
    );
  }
}

// ignore: must_be_immutable
class ItemProgressHorizontalList extends StatelessWidget {
  var list = List<VideoDetails>();

  ItemProgressHorizontalList(this.list);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: (((width / 1.7) - 36) * (2.5 / 4) + 20),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          padding: EdgeInsets.only(
              left: spacing_standard, right: spacing_standard_new),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: spacing_standard),
              width: (width / 1.7) - 36,
              child: InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 4 / 2.5,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: spacing_control_half,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing_control),
                        ),
                        child: assetImage(list[index].thumbnailLocation,
                            aWidth: double.infinity, aHeight: double.infinity),
                      ),
                    ).paddingBottom(spacing_control),
                    Expanded(
                      child: LinearPercentIndicator(
                        width: (width / 2) - 40,
                        lineHeight: 1.5,
                        percent: 0.4 /*list[index].percent*/,
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.only(left: 2),
                        progressColor: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                                title: "Action",
                                movie: list[index],
                              )));
                },
                radius: spacing_control,
              ),
            );
          }),
    );
  }
}

// ignore: must_be_immutable

Widget subType(context, key, VoidCallback callback, icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      icon != null
          ? Image.asset(
              icon,
              width: 20,
              height: 20,
              color: Theme.of(context).textTheme.headline6.color,
            ).paddingRight(spacing_standard)
          : SizedBox(),
      Expanded(child: itemTitle(context, keyString(context, key))),
      Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).textTheme.caption.color,
      )
    ],
  )
      .paddingOnly(
          left: spacing_standard_new,
          right: 12,
          top: spacing_standard_new,
          bottom: spacing_standard_new)
      .onTap(callback);
}

Widget viewCountWidget(context, int viewCount) {
  return Container(
    decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(spacing_control_half))),
    padding: EdgeInsets.only(
        top: 0, bottom: 0, left: spacing_control, right: spacing_control),
    child: text(context, "$viewCount Views",
        textColor: Theme.of(context).textTheme.button.color,
        fontSize: ts_medium,
        fontFamily: font_bold),
  );
}

Widget formField(context, label,
    {isEnabled = true,
    isDummy = false,
    controller,
    isPasswordVisible = false,
    isPassword = false,
    readOnly = false,
    showCursor = true,
    keyboardType = TextInputType.text,
    FormFieldValidator<String> validator,
    onSaved,
    List<TextInputFormatter> inputFormatters,
    textInputAction = TextInputAction.next,
    FocusNode focusNode,
    FocusNode nextFocus,
    IconData suffixIcon,
    String initialValue,
    maxLine = 1,
    suffixIconSelector,
    maxLength,
    hint,
    isRequired = false,
    onTap}) {
  return Stack(
    children: [
      TextFormField(
        maxLength: maxLength,
        onTap: onTap,
        inputFormatters: inputFormatters,
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        readOnly: readOnly,
        showCursor: showCursor,
        cursorColor: Theme.of(context).primaryColor,
        maxLines: maxLine,
        keyboardType: keyboardType,
        validator: validator,
        enabled: isEnabled,
        onSaved: onSaved,
        initialValue: initialValue,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onFieldSubmitted: (arg) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          labelText: keyString(context, label),
          labelStyle: TextStyle(fontSize: ts_medium_small, color: Colors.grey),
          hintText: hint,
          hintStyle: TextStyle(fontSize: ts_medium_small, color: Colors.grey),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: suffixIconSelector,
                  child: new Icon(
                    suffixIcon,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                )
              : Icon(
                  suffixIcon,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
          contentPadding: new EdgeInsets.only(bottom: 2.0),
        ),
        style: TextStyle(
          fontSize: ts_normal,
          color: isDummy
              ? Colors.transparent
              : Theme.of(context).textTheme.headline6.color,
        ),
        buildCounter: (BuildContext context,
                {currentLength, maxLength, isFocused}) =>
            null,
      ),
      Positioned(
        right: 0,
        child: isRequired
            ? Text('*',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Colors.red))
            : Container(),
      ),
    ],
  );
}
