import 'package:gp_1/controller/localization_service.dart';

enum TKeys{
  loginTitle,
  loginHintEmail,
  loginHintPass,
  loginButton,
  loginDontHaveAccount,
  loginSignupButton,
  loginWrongEmailTitle,
  loginWrongEmailContent,
  loginWrongPassContent,
  loginWrongEmailOkButton,

  signupUserName,
  signupUserEmail,
  signupUserPass,
  signupUserConPass,
  signupUserPhone,
  signupUserAddImage,
  signupChooseWorker,
  signupChooseOr,
  signupChooseUser,

  WmyProfileTitle,
  WsearchButton,
  WactivButton,
  WdeactivButton,
  WuploadPostsButton,
  WuploadedWorkTitle,
  WdeletePostButton,
  WnavbarProfileButton,
  WuploadPhotos,
  WphotoFromGal,
  WphotoFromCam,
  WdeletePostMessageTitle,
  WdeletePostMessageContent,
  WdeletePostMessageAgree,
  WdeletePostMessageCancel,
  WactivButtonTitle,
  WactivButtonOk,
  WactivButtonContent,

  WchangeLangTitle,
  WnavbarEditButton,
  WsettingNameField,
  WsettingPhoneFiled,
  WsettingCategoryButton,
  WsettingEditImageButoon,
  WsettingLanguageButton,
  WsettingDoneButton,
  WeditInfoTitle,


  WnavbarNotificationButton,
  WnotificationTitle,
  WnotiIncomingReq,
  WnotiOngoingReq,
  WnotiSendingReq,
  WnotiMoreInfoTitle,
  WnotiMoreInfoOkButton,
  WnotiMoreInfoButton,
  WnotiAcceptReq,
  WnotiRefuseReq,
  WnotiReplyForComplain,
  WnotiInReplyComplainAbout,
  WnotiInReplyCompalinContent,
  WnotiInReplyContent,
  WnotiInReplyOkButton,

  WongoingTitle,
  WongoingInEndJobButton,
  WongoingInEndCancelButton,
  WongoingInEndDoneButton,
  WongoingInEndMessageTitle,
  WongoingInEndMessageContent,
  WongoingInReviewTitle,
  WongoingInReviewDoneButton,
  WongoingInComplainButton,
  WongoingInCancelJobButton,
  WongoingInCancelMessageTitle,
  WongoingInCancelMessageContent,
  WongoingInCancelMessageOkButton,
  WongoingInCancelMessageNoButton,

  WcomplainTitle,
  WcomplainDetails,
  WcomplainContent,
  WcomplainTextField,
  WcomplainSubmitButton,

  WcategoriesTitle,

  WworkerInWorkerTitle,
  WworkerInWorkerSendReq,
  WworkerInWorkerCancelReq,
  WworkerInWorkerYouOnReq,
  WworkerInWorkerYouSendReq,
  WworkerInWorkerWork,

  CnotiMessageTitle,
  CnotiMessageContent,
  CnotiMessageOkButton,
  CnotiReplyForComplain,
  CnotiInReplyComplainAbout,
  CnotiInReplyCompalinContent,
  CnotiInReplyContent,
  CnotiInReplyOkButton,

  CongoingInReviewTitle
}

extension TKeysExtention on TKeys{
  String get _string => toString().split('.')[1];

  String translate(context){
    return LocalizationService.of(context).translate(_string)??'';
  }

}