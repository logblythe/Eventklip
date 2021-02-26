import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:eventklip/fragments/video_images_list_fragment/video_images_list_fragment.dart';
import 'package:eventklip/models/file_upload_model.dart';
import 'package:eventklip/models/model.dart';
import 'package:eventklip/ui/widgets/upload_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:eventklip/api/folders_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/screens/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class AssetThumbnail extends StatefulWidget {
  final Media asset;
  final Uint8List thumb;

  const AssetThumbnail({
    Key key,
    @required this.asset,
    this.thumb,
  }) : super(key: key);

  @override
  _AssetThumbnailState createState() => _AssetThumbnailState(asset);
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  final Media asset;

  _AssetThumbnailState(this.asset);

  double progress = 0;

  @override
  void initState() {
    if (!asset.isUploaded) {
      uploadFile();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              if (widget.asset.mediaType == MediaTypeImage) {
                // If this is an image, navigate to ImageScreen
                return ImageScreen(imageFile: File(widget.asset.path));
              } else {
                // if it's not, navigate to VideoScreen
                return VideoScreen(videoFile: File(widget.asset.path));
              }
            },
          ),
        );
      },
      child: UploadIndicatorWidget(
        progress: progress,
        uploaded: asset.isUploaded,
        child: Stack(
          children: [
            // Wrap the image in a Positioned.fill to fill the space
            Positioned.fill(
              child: widget.asset.mediaType == MediaTypeImage
                  ? Image.file(File(widget.asset.path), fit: BoxFit.fitWidth)
                  : Image.memory(widget.thumb, fit: BoxFit.fitWidth),
            ),
            // Display a Play icon if the asset is a video
            if (widget.asset.mediaType == MediaTypeVideo)
              Center(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 42,
                  color: Colors.white
                ),
              ),
          ],
        ),
      ),
    );
  }

  void uploadFile() async {
    final res = await saveFile(asset.path, (count, total) {
      setState(() {
        progress = count / total;
      });
    });
    if (res.success) {
      asset.isUploaded = true;
      asset.save();
    }
  }
}

Future<FileUploadModel> saveFile(
    String filePath, ProgressCallback onSendProgress) async {
  FoldersApi _foldersApi = getIt.get<FoldersApi>();
  String fileName = basename(filePath);
  File file = File(filePath);
  int fileSize = await file.length();
  List<String> mimeDetails = lookupMimeType(filePath).split("/");
  String fileType = mimeDetails.first;
  String fileExtension = mimeDetails.last;
  String videoDuration = "0";
  if (fileType == "video") {
    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    videoDuration = controller.value.duration.inSeconds.toString();
  }
  FileUploadModel uploadRes = await uploadFile(filePath, onSendProgress);
  FileUploadModel createRes;
  if (uploadRes.success) {
    final user = await SharedPreferenceHelper.getUser();
    final payload = {
      "id": uploadRes.fileId,
      "title": fileName,
      "eventId": user.eventId,
      "fileLocation": uploadRes.fileUrl,
      "videoFormat": fileExtension,
      "videoSize": fileSize,
      "duration": videoDuration
    };
    createRes = await _foldersApi.createClientVideo(payload);
  }
  return createRes;
}

Future<FileUploadModel> uploadFile(
    String filePath, ProgressCallback onSendProgress) async {
  FoldersApi _foldersApi = getIt.get<FoldersApi>();
  File file = File(filePath);
  List<String> mimeDetails = lookupMimeType(filePath).split("/");
  String fileType = mimeDetails.first;
  FileUploadModel uploadRes;
  try {
    uploadRes = await _foldersApi.uploadFile(
      file,
      fileType,
      onSendProgress: onSendProgress,
    );
  } catch (e) {
    print('error $e');
  }
  return uploadRes;
}
