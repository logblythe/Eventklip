import 'package:eventklip/ui/widgets/header_with_subtitle.dart';
import 'package:eventklip/utils/data_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';

class TermsConditionsScreen extends StatefulWidget {
  static String tag = '/TermsConditionsSceen';

  @override
  TermsConditionsScreenState createState() => TermsConditionsScreenState();
}

class TermsConditionsScreenState extends State<TermsConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLayout(context, keyString(context, "terms_conditions")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            itemTitle(context, "eventklip - Terms & conditions")
                .paddingBottom(spacing_standard),
            ...getTerms().map((e) => Column(
              children: [
                TitleWithContentWidget(title:e.title,content: e.content),
              ],
            )).toList()
          ],
        ).paddingAll(spacing_standard_new),
      ),
    );
  }
}
