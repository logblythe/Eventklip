import 'package:eventklip/ui/parts/movie_grid_list.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/images.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/view_models/search_state.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/utils/widget_extensions.dart';
import 'package:provider/provider.dart';

class SearchFragment extends StatefulWidget {
  static String tag = '/SearchFragment';

  @override
  SearchFragmentState createState() => SearchFragmentState();
}

class SearchFragmentState extends State<SearchFragment> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchState>(
      create: (context) => SearchState(),
      builder: (context, child) {
        return Consumer<SearchState>(builder: (context, provider, child) {
          return Scaffold(
            appBar: appBarWidget('Search',
                showBack: false,
                color: navigationBackground,
                textColor: Colors.white),
            body: Stack(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          color: search_edittext_color,
                          padding: EdgeInsets.only(
                              left: spacing_standard_new,
                              right: spacing_standard),
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      controller: searchController,
                                      textInputAction: TextInputAction.search,
                                      style: TextStyle(
                                          fontFamily: font_regular,
                                          fontSize: ts_normal,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color),
                                      decoration: InputDecoration(
                                        hintText: 'Search movies, tv shows',
                                        hintStyle: TextStyle(
                                            fontFamily: font_regular,
                                            color: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .color),
                                        border: InputBorder.none,
                                        filled: false,
                                      ),
                                      onFieldSubmitted: (s) {
                                        Provider.of<SearchState>(context,
                                                listen: false)
                                            .searchMovies(searchController.text,
                                                page: 0);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      searchController.clear();
                                      hideKeyboard(context);
                                    },
                                    icon: Icon(Icons.cancel,
                                        color: colorPrimary, size: 20),
                                  ).visible(provider.queryText.isNotEmpty),
                                  IconButton(
                                    onPressed: () {
                                      hideKeyboard(context);
                                      Provider.of<SearchState>(context,
                                              listen: false)
                                          .searchMovies(searchController.text,
                                              page: 0);
                                    },
                                    icon: Image.asset(ic_search,
                                        color: colorPrimary,
                                        width: 20,
                                        height: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        headingText(context,
                                'Result For' + " \'" + provider.queryText + "\'")
                            .paddingOnly(
                                left: 16, right: 16, top: 16, bottom: 12)
                            .visible(provider.queryText.isNotEmpty),
                        MovieGridList(provider.movies),
                      ],
                    ),
                  ),
                ),
                Loader()
                    .withSize(height: 40, width: 40)
                    .center()
                    .visible(provider.isLoading),
                noDataWidget().center().visible(!(provider.isLoading) &&
                    provider.movies.isEmpty &&
                    !(provider.hasError)),
              ],
            ),
          );
        });
      },
    );
  }
}
