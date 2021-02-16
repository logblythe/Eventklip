import 'dart:io';
import 'package:eventklip/fragments/comment_fragment.dart';
import 'package:eventklip/fragments/video_images_list_fragment/components/context_menu.dart';
import 'package:eventklip/models/model.dart';
import 'package:eventklip/screens/capture_screen.dart';
import 'package:eventklip/ui/widgets/context_menu.dart';
import 'package:eventklip/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GalleryFragment extends StatefulWidget {
  @override
  _GalleryFragmentState createState() => _GalleryFragmentState();
}

class _GalleryFragmentState extends State<GalleryFragment> {
  // This will hold all the assets we fetched
  List<Media> medias = [];

  @override
  void initState() {
    print("Init state");
    _fetchAssets();
    super.initState();
  }

  _fetchAssets() async {
    final medias = await Media().select().toList();
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "captureImageVideo",
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return CaptureScreen();
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
                      return b.mediaType -
                          a.mediaType;
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
          crossAxisCount: 3,
        ),
        itemCount: medias.length,
        itemBuilder: (_, index) {
          return AssetThumbnail(asset: medias[index]);
        },
      ),
    );
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
              if (asset.mediaType == MediaTypeAudio) {
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
              child: asset.mediaType == MediaTypeAudio
                  ? Image.asset(
                      asset.path,
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
    @required this.imageFile,
  }) : super(key: key);

  final File imageFile;

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
        child: Image.file(
          imageFile,
          fit: BoxFit.fitWidth,
        ),
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
