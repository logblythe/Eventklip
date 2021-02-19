class ApiEndPoints {
  // static const BASE_URL = "https://api.boxklip.com/api/";
  static const BASE_URL = "https://devapi.boxklip.com/api/";

  ///auth and profile
  static const AUTHENTICATE = "${BASE_URL}UserControl/Token";
  static const SIGN_UP = "${BASE_URL}UserControl/RegisterClients";
  static const GET_PROFILE = "${BASE_URL}UserControl/GetProfile";
  static const FORGOT_PASSWORD = "${BASE_URL}UserControl/ForgotPassword";
  static const CHANGE_PASSWORD = "${BASE_URL}UserControl/ChangePassword";
  static const CHANGE_PASSWORD_FIRST_TIME =
      "${BASE_URL}UserControl/ChangePassword";
  static const VALIDATE_QR = "${BASE_URL}UserControl/QRValidate";

  ///movie apis
  static const GET_MOVIES = "${BASE_URL}Clients/GetVideoList";
  static const GET_RELATED_MOVIES = "${BASE_URL}Clients/GetRelatedVideos";
  static const CREATE_VIEW = "${BASE_URL}Clients/CreateView";

  ///comment apis
  static const GET_COMMENTS = "${BASE_URL}Clients/GetComments";
  static const ADD_COMMENT = "${BASE_URL}Clients/CreateComment";
  static const EDIT_COMMENT = "${BASE_URL}Clients/EditComment";
  static const DELETE_COMMENT = "${BASE_URL}Clients/DeleteComment";

  ///search apis
  static const GET_SEARCH_RESULTS = "${BASE_URL}Clients/SearchTerm";

  ///folder apis
  static const GET_FOLDERS = "${BASE_URL}Clients/GetFolders";
  static const CREATE_FOLDER = "${BASE_URL}Clients/CreateFolder";
  static const CREATE_QR = "${BASE_URL}Clients/CreateQR";

  //blob apis
  static const POST_BLOB = "${BASE_URL}blob";

  //client apis
  static const CREATE_CLIENT_VIDEOS = "${BASE_URL}Clients/CreateClientVideos";


}
