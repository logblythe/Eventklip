import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:eventklip/fragments/comment_fragment.dart';
import 'package:eventklip/fragments/video_images_list_fragment/components/context_menu.dart';
import 'package:eventklip/models/model.dart';
import 'package:eventklip/screens/capture_screen.dart';
import 'package:eventklip/screens/shared_preferences.dart';
import 'package:eventklip/ui/widgets/context_menu.dart';
import 'package:eventklip/ui/widgets/upload_indicator_widget.dart';
import 'package:eventklip/utils/utility.dart';
import 'package:eventklip/view_models/home_app_state.dart';
import 'package:eventklip/view_models/qr_user_state.dart';
import 'package:eventklip/view_models/qr_user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class GalleryFragment extends StatefulWidget {
  @override
  _GalleryFragmentState createState() => _GalleryFragmentState();
}

class _GalleryFragmentState extends State<GalleryFragment> {
  // This will hold all the assets we fetched
  List<Media> medias = [];
  Map<int, double> _mediaProgress = {};
  QrUserState _provider;

  @override
  void initState() {
    print("Init state");
    _fetchAssets();
    super.initState();
  }

  _fetchAssets() async {
    final user = await SharedPreferenceHelper.getUser();
    final medias = await Media().select().eventId.equals(user.eventId).toList();
    medias.sort((a, b) {
      return b.createdAt.millisecondsSinceEpoch -
          a.createdAt.millisecondsSinceEpoch;
    });
    setState(() {
      this.medias = medias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrUserState>(
      builder: (context, model, child) {
        _provider = model;
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: "captureImageVideo",
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return CaptureScreen(
                  onImageCaptured: (file) async {
                    saveFile(file, MediaTypeImage);
                  },
                  onVideoCaptured: (file) async {
                    saveFile(file, MediaTypeVideo);
                  },
                );
              }));
              _fetchAssets();
            },
            child: Icon(Icons.camera),
          ),
          appBar: AppBar(
            title: Text('Gallery'),
            actions: [
              ContextMenu<MenuItemAssetList>(
                  onSelected: (item) {
                    if (item == MenuItemAssetList.SortByDate) {
                      setState(() {
                        medias.sort((a, b) {
                          return b.createdAt.millisecondsSinceEpoch -
                              a.createdAt.millisecondsSinceEpoch;
                        });
                      });
                    } else {
                      setState(() {
                        medias.sort((a, b) {
                          return b.mediaType - a.mediaType;
                        });
                      });
                    }
                  },
                  onCanceled: () {},
                  itemBuilder: (BuildContext context) {
                    return List<PopupMenuEntry<MenuItemAssetList>>.generate(
                        MenuItemAssetList.values.length * 2 - 1, (int index) {
                      if (index.isEven) {
                        final item = MenuItemAssetList.values[index ~/ 2];
                        return ContextMenuItem<MenuItemAssetList>(
                            value: item, text: item.text);
                      } else {
                        return ContextDivider();
                      }
                    });
                  },
                  child: Container())
            ],
          ),
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // A grid view with 3 items per row
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 3,
            ),
            itemCount: medias.length,
            itemBuilder: (_, index) {
              return UploadIndicatorWidget(
                  progress: _mediaProgress[medias[index].id] ?? 0,
                  uploaded: medias[index].isUploaded,
                  child: AssetThumbnail(asset: medias[index]));
            },
          ),
        );
      },
    );
  }

  Future<void> saveFile(XFile file, int type) async {
    final user = await SharedPreferenceHelper.getUser();
    if (file != null) {
      Media _media = Media(
          mediaType: type,
          filename: file.name,
          createdAt: DateTime.now().toUtc(),
          isDeleted: false,
          adminId: user.adminId,
          eventId: user.eventId,
          isUploaded: false,
          path: file.path);
      int mediaId = await _media.save();
      final res = await _provider.saveFile(file.path, (count, total) {
        setState(() {
          double progress = count / total;
          if (_mediaProgress.containsKey(mediaId)) {
            _mediaProgress[mediaId] = progress;
          } else {
            _mediaProgress.addAll({mediaId: progress});
          }
        });
      });
      if (res.success) {
        _media.id = mediaId;
        _media.isUploaded = true;
        _media.save();
      }
    }
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key key,
    @required this.asset,
  }) : super(key: key);

  final Media asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              if (asset.mediaType == MediaTypeImage) {
                // If this is an image, navigate to ImageScreen
                return ImageScreen(imageFile: File(asset.path));
              } else {
                // if it's not, navigate to VideoScreen
                return VideoScreen(videoFile: File(asset.path));
              }
            },
          ),
        );
      },
      child: Stack(
        children: [
          // Wrap the image in a Positioned.fill to fill the space
          Positioned.fill(
              child: asset.mediaType == MediaTypeImage
                  ? Image.file(
                      File(asset.path),
                      fit: BoxFit.fitWidth,
                    )
                  : FutureBuilder(
                      future: getThumbData(File(asset.path)),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                          return Image.memory(
                            snapshot.data,
                            fit: BoxFit.fitWidth,
                          );
                        return Container();
                      },
                    )),
          // Display a Play icon if the asset is a video
          if (asset.mediaType == MediaTypeVideo)
            Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 42,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    Key key,
    this.imageFile,
    this.imageUrl,
  }) : super(key: key);

  final File imageFile;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: imageFile!=null ? Image.file(
          imageFile,
          fit: BoxFit.fitWidth,
        ) : CachedNetworkImage(imageUrl: imageUrl),
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key key,
    @required this.videoFile,
  }) : super(key: key);

  final File videoFile;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController _controller;
  bool initialized = false;

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _initVideo() async {
    final video = widget.videoFile;
    _controller = VideoPlayerController.file(video)
      ..setLooping(true)
      ..initialize().then((_) => setState(() => initialized = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialized
          // If the video is initialized, display it
          ? Scaffold(
              body: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Wrap the play or pause in a call to `setState`. This ensures the
                  // correct icon is shown.
                  setState(() {
                    // If the video is playing, pause it.
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      // If the video is paused, play it.
                      _controller.play();
                    }
                  });
                },
                // Display the correct icon depending on the state of the player.
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            )
          // If the video is not yet initialized, display a spinner
          : Center(child: CircularProgressIndicator()),
    );
  }
}
