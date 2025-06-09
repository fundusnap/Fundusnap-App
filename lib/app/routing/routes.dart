class Routes {
  static const String home = "/home"; //? scree to provide general info
  static const String scan = "/scan"; //? screen to provide scan  methods
  static const String cases = "/cases"; // ? screen to provide list of results
  static const String fundusAi =
      "/fundus-ai"; // ? screen to provide list of results
  static const String profile = "/profile"; //? screen to provide user info

  static const String camera = "camera";
  static const String displayPicture = "display-picture";

  static const String upload = "upload";

  // Make result routes unique
  static const String cameraResult =
      "camera-result"; // ? result via camera flow
  static const String uploadResult =
      "upload-result"; // ?  result via upload flow
  static const String casesResult =
      "cases-result"; // ?  result via clicking from cases  flow

  static const String chat = "chat";

  static const String caseDetail = "case-detail";

  static const String signInScreen = "/sign-in";
  static const String signUpScreen = "/sign-up";
}
