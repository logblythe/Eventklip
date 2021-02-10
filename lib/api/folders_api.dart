import 'package:eventklip/api/api_helper.dart';
import 'package:eventklip/api/client.dart';
import 'package:eventklip/api/endpoints.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/create_folder_model.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class IFolders {
  Future getFolders();

  Future createFolder(Map<String, dynamic> data);
}

@lazySingleton
class FoldersApi extends IFolders with ApiHelper {
  DioClient _dioClient = getIt.get<DioClient>();

  @override
  Future<List<FolderModel>> getFolders() async {
    final response = await _dioClient.get(
      ApiEndPoints.GET_FOLDERS,
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<FolderModel>(response,
        modelCreator: (json) => FolderModel.fromJson(json));
  }

  @override
  Future<CreateFolderModel> createFolder(Map<String, dynamic> data) async {
    final response = await _dioClient.post(
      ApiEndPoints.CREATE_FOLDER,
      data: data,
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<CreateFolderModel>(response,
        modelCreator: (json) => CreateFolderModel.fromJson(json));
  }
}
