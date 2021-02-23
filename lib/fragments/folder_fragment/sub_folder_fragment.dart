import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventklip/api/folders_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/fragments/folder_fragment/qr_fragment.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/no_folder_widget.dart';
import 'package:eventklip/fragments/video_images_list_fragment/video_images_list_fragment.dart';
import 'package:eventklip/models/client_media.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:eventklip/screens/eventklip_admin_video_view.dart';
import 'package:eventklip/screens/eventklip_movie_detail_screen.dart';
import 'package:eventklip/screens/question_answer_setup_screen.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eventklip/utils/resources/colors.dart' as colors;

class FolderEventDetailFragment extends StatefulWidget {
  final FolderModel folder;

  const FolderEventDetailFragment({Key key, this.folder}) : super(key: key);

  @override
  _FolderEventDetailFragmentState createState() =>
      _FolderEventDetailFragmentState();
}

class _FolderEventDetailFragmentState extends State<FolderEventDetailFragment> {
  var clientMedias = <ClientMedia>[];
  var loading = false;

  @override
  void initState() {
    getAllVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarLayout(
          context,
          widget.folder.name ?? "-",
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            InkWell(
                child: Icon(Icons.qr_code),
                onTap: () {
                  if (widget.folder.qrLocation == null) {}
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => QrFragment(
                            folder: widget.folder,
                          )));
                }).paddingRight(12),
            InkWell(
                child: Icon(Icons.question_answer),
                onTap: () {
                  if (widget.folder.qrLocation == null) {}
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => QuestionAnswerSetupScreen(
                            folder: widget.folder,
                          )));
                }).paddingRight(12),
          ],
        ),
        body: loading
            ? Loader()
            : RefreshIndicator(
                onRefresh: getAllVideos,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    clientMedias.isEmpty
                        ? emptyVideos()
                        : Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, position) {
                                return ClientMediaItem(clientMedias[position]);
                              },
                              itemCount: clientMedias.length,
                            ),
                          )
                  ],
                ),
              ));
  }

  Widget emptyVideos() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NoFolderWidget(
          title: 'No records found for ${widget.folder.name}',
          subtitle:
              'Images and videos will be available once users upload to this event.',
        )
      ],
    );
  }

  Future getAllVideos() async {
    print("Getting");
    FoldersApi _foldersApi = getIt.get<FoldersApi>();
    try {
      setState(() {
        loading = true;
      });
      final videos = await _foldersApi.getAdminVideos(widget.folder.id);
      videos.sort((a, b) {
        return b.createdDate.compareTo(a.createdDate);
      });
      setState(() {
        clientMedias = videos;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      toast("Something went wrong");
    }
    return true;
  }
}

class ClientMediaItem extends StatelessWidget {
  final ClientMedia clientMedia;

  ClientMediaItem(this.clientMedia);

  @override
  Widget build(BuildContext context) {
    print(clientMedia.fileLocation);
    return GestureDetector(
      onTap: () {
        if (clientMedia.duration != "0")
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VideoViewScreen(
                videoUrl: clientMedia.fileLocation,
              )));
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                  // If this is an image, navigate to ImageScreen
                  return ImageScreen(imageUrl: clientMedia.fileLocation);
                }
            ),
          );

        }
      },
      child: Container(
        padding: EdgeInsets.all(spacing_standard),
        width: MediaQuery.of(context).size.width - 16,
        height: (MediaQuery.of(context).size.width - 16) * 9 / 16,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            CachedNetworkImage(
              imageUrl: clientMedia.fileLocation,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(spacing_standard),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.clamp,
                    colors: <Color>[
                      Color(0x00000000),
                      Color(0xDD000000),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: text(context, clientMedia.title),
            )
          ],
        ),
      ),
    );
  }
}
