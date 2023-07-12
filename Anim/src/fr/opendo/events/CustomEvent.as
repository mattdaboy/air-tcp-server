package fr.opendo.events {
import flash.events.Event;

/**
 * @author Noel
 */
public class CustomEvent extends Event {
    // TCP Server
    public static const HOSTS_CHECKED:String = "HOSTS_CHECKED";
    public static const TCP_SERVER_CLOSED:String = "TCP_SERVER_CLOSED";
    //
    // CMS
    public static const CLOSE:String = "CLOSE";
    public static const SESSION_DELETE_CLICK:String = "SESSION_DELETE_CLICK";
    public static const ID_SNAPSHOT_DELETE_CLICK:String = "SESSION_DELETE_CLICK";
    public static const START_APPLICATION:String = "START_APPLICATION";
    //
    public static const XML_LOADED:String = "xmlLoaded";
    public static const SEND_QUESTION_POINTS:String = "sendQuestionPoints";
    public static const QUESTION_END_GAME:String = "QUESTION_END_GAME";
    public static const QUESTION_SHOW_INDICE:String = "questionShowIndice";
    public static const ROOM_ALREADY_EXISTING:String = "ROOM_ALREADY_EXISTING";
    public static const ROOM_CREATED:String = "ROOM_CREATED";
    public static const ROOM_JOINED:String = "ROOM_JOINED";
    public static const WEB_SOCKET_CONNECTED:String = "WEB_SOCKET_CONNECTED";
    public static const WEB_SOCKET_DISCONNECTED:String = "webSocketDisconnected";
    public static const IP_CHECKED_COMPLETED:String = "ipCheckedCompleted";
    public static const DELETE:String = "DELETE";
    public static const FILE_SERVER_COMPLETE:String = "fileServerComplete";
    public static const READ_PUBLICATIONS:String = "readPublications";
    public static const APPLY_FILTERS:String = "applyFilters";
    public static const HIDE_LOGO:String = "hideLogo";
    public static const CLOSE_AND_RESET_FILTERS:String = "resetFilersAndClose";
    public static const DESKTOP_IMAGE_PICK_COMPLETE:String = "desktopImagePickComplete";
    public static const MOBILE_IMAGE_PICK_COMPLETE:String = "mobileImagePickComplete";
    public static const MODE:String = "mode";
    public static const COMPLETE:String = "COMPLETE";
    public static const CANCEL:String = "CANCEL";
    public static const IO_ERROR:String = "IO_ERROR";
    public static const DELETE_QUIZ:String = "deleteQuiz";
    public static const READ_NOTES:String = "READ_NOTES";
    public static const BTN_NEW_MODULE:String = "newBtnModule";
    public static const CREATE_NEW_QANDA_MESSAGE:String = "CREATE_NEW_QANDA_MESSAGE";
    public static const VALIDATE_STEP:String = "VALIDATE_STEP";
    public static const OPEN_POPUP:String = "OPEN_POPUP";
    public static const PPT_CONVERTER_COMPLETE:String = "PPT_CONVERTER_COMPLETE";
    public static const MODE_SELECTION_ON_OFF:String = "MODE_SELECTION_ON_OFF";
    public static const SELECT_UNSELECT_ALL:String = "SELECT_UNSELECT_ALL";
    public static const ADD_NEW_ELEM:String = "ADD_NEW_ELEM";
    public static const START_APP_DECOUVERTE:String = "START_APP_DECOUVERTE";
    public static const CODE_GENERATED:String = "CODE_GENERATED";
    public static const CODE_OK:String = "CODE_OK";
    public static const CHANGE_LANGUAGE:String = "CHANGE_LANGUAGE";
    //
    // Divers
    public static const BUTTON_CLICK:String = "BUTTON_CLICK";
    public static const CONNECTION_STATUS_CHANGED:String = "CONNECTION_STATUS_CHANGED";
    public static const SHOW_REPONSES:String = "SHOW_REPONSES";
    public static const RESET:String = "RESET";
    public static const FILE_UPLOADED:String = "FILE_UPLOADED";
    public static const FILE_DOWNLOADED:String = "FILE_DOWNLOADED";
    public static const NO_FILE_DOWNLOADED:String = "NO_FILE_DOWNLOADED";
    public static const DB_RESTORED:String = "DB_RESTORED";
    //
    // Users
    public static const USER_NOT_RESPONDING:String = "USER_NOT_RESPONDING";
    public static const USER_RESPONDING_AGAIN:String = "USER_RESPONDING_AGAIN";
    public static const USERS_ADDED:String = "USERS_ADDED";
    public static const USERS_REMOVED:String = "USERS_REMOVED";
    public static const USERS_RESET:String = "USERS_RESET";
    public static const USERS_UPDATED:String = "USERS_UPDATED";
    public static const USERS_CHANGED:String = "USERS_CHANGED";
    public static const USER_PHOTO_LOADED:String = "USER_PHOTO_LOADED";

    public static const VIDEO_SYNCHRO_PAUSE_AT:String = "VIDEO_SYNCHRO_PAUSE_AT";
    public static const VIDEO_SYNCHRO_PLAY_AT:String = "VIDEO_SYNCHRO_PLAY_AT";
    //
    public var data:Array = null;
    public static const START_SCANNER:String = "START_SCANNER";
    public static const CLOSE_SCANNER:String = "CLOSE_SCANNER";

    // New Session
    public static const NEW_SESSION_THEMES:String = "NEW_SESSION_THEMES";
    public static const NEW_SESSION_CONTENT:String = "NEW_SESSION_CONTENT";
    public static const NEW_SESSION_EMPTY:String = "NEW_SESSION_EMPTY";
    public static const SESSION_DEMO:String = "SESSION_DEMO";
    public static const SESSION_CREATE:String = "SESSION_CREATE";
    public static const NEW_BUILD_ONLINE:String = "NEW_BUILD_ONLINE";
    public static const UPDATE_WITH_BUILD_ONLINE:String = "UPDATE_WITH_BUILD_ONLINE";

    // tableau blanc
    public static const DEMARRER:String = "DEMARRER_SEANCE";
    public static const CACHER_TABLEAUX:String = "CACHER_TABLEAUX";
    public static const SELECT_TABLEAU:String = "SELECT_TABLEAU";
    public static const SHOW_POPUP_LIST:String = "SHOW_POPUP_LIST";
    public static const DELETE_BULLE:String = "DELETE_BULLE";
    public static const CREER_CAPTURES:String = "CREER_CAPTURES";

    // quiz sondage
    public static const NEXT_QUESTION:String = "NEXT_QUESTION";
    public static const REVOIR_TOUS_RESULTATS:String = "REVOIR_TOUS_RESULTATS";

    // Internet Status
    public static const INTERNET_CHECKING:String = "INTERNET_CHECKING";
    public static const INTERNET_AVAILABLE:String = "INTERNET_AVAILABLE";
    public static const INTERNET_UNAVAILABLE:String = "INTERNET_UNAVAILABLE";
    public static const INTERNET_LOST:String = "INTERNET_LOST";
    public static const INTERNET_AVAILABLE_AGAIN:String = "INTERNET_AVAILABLE_AGAIN";

    public static const SENT_TO_SLACK:String = "SENT_TO_SLACK";
    public static const SEND_ERROR:String = "SEND_ERROR";
    public static const MOUSE_UP:String = "MOUSE_UP";

    // Synchro with Opendo Cloud
    public static const NO_CLOUD_SYNCHRO:String = "NO_CLOUD_SYNCHRO";
    public static const CLOUD_SYNCHRO_ERROR:String = "CLOUD_SYNCHRO_ERROR";
    public static const CLOUD_SYNCHRO_SUCCESS:String = "CLOUD_SYNCHRO_SUCCESS";

    public function CustomEvent(type:String, data:Array = null, bubbles:Boolean = true, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
    }
}
}