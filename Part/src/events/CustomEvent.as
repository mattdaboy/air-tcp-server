package events {
import flash.events.Event;

/**
 * @author Noel
 */
public class CustomEvent extends Event {
    public static const INFORMATION_CONNEXION_FILLED:String = "TCPSERVER_IP_FILLED";
    public static const DESSIN_MERGE:String = "DESSIN_MERGE";
    public static const SAVE_DESSIN_IMAGE:String = "SAVE_DESSIN_IMAGE";
    public static const SAVE_BD_IMAGE:String = "SAVE_BD_IMAGE";
    public static const SHOW_BD:String = "SHOW_BD";
    public static const SELECT_VIGNETTE:String = "SELECT_VIGNETTE";
    public static const EDIT_DRAWING_VIGNETTE:String = "EDIT_DRAWING_VIGNETTE";
    public static const OPEN_DRAWING_CAMERA:String = "OPEN_DRAWING_CAMERA";
    public static const VALIDER_VIDEO_CAPTURE:String = "validerVideoCapture";
    public static const CLOSE_VIDEO_CAPTURE:String = "closeVideoCapture";
    public static const UPDATE_USER_INFOS_DB_COMPLETE:String = "updateUserInfosDbComplete";
    public static const CAMERA_DENIED:String = "CAMERA_DENIED";
    public static const NEW_DRAWING_ACTION:String = "NEW_DRAWING_ACTION";
    public static var END_OF_GAME:String = "END_OF_GAME";
    public static var PIECE_ON_PRESS:String = "PIECE_ON_PRESS";
    public static var SOCKET_EVENT:String = "SOCKET_EVENT";
    public static var SOCKET_CONNECTED:String = "SOCKET_CONNECTED";
    public static var BUTTON_CLICK:String = "button_click";
    public static var OPENED:String = "opened";
    public static var CLOSED:String = "closed";
    public static var CONTENT_COMPLETED:String = "content_completed";
    public static var CHANGED:String = "changed";
    public static var COMPLETED:String = "completed";
    public static const SAVE_BD_CLICK:String = "saveBdClick";
    public static const SHOW_ANIMATION_CODE_MEDIA:String = "SHOW_ANIMATION_CODE_MEDIA";
    public static const LAUNCH_SINGLE_SCAN:String = "launchScan";
    public static const ANIMATION_CODE_QUIZ_COMPLETE:String = "animationCodeQuizComplete";
    public static const COLOR_PICKER_UINT:String = "colorPickerHexa";
    public static const DELETE:String = "DELETE";
    public static const BTN_CLICK:String = "BTN_CLICK";
    public static const HOSTS_CHECKED:String = "HOSTS_CHECKED";
    public static const KILL_CHRONO:String = "HOLD_ON_CHRONO";
    public static const QUESTION_SUIVANTE:String = "QUESTION_SUIVANTE";
    public static const VALIDER_REPONSE:String = "VALIDER_REPONSE";
    public static const CARDPICKER_CARD_PICKED:String = "CARDPICKER_CARD_PICKED";
    public static const CARDPICKER_NO_CARD_PICKED:String = "CARDPICKER_NO_CARD_PICKED";
    public static const CARDPICKER_CARD_RETURNED:String = "CARDPICKER_CARD_RETURNED";
    public static const LEVEL_DOWN:String = "LEVEL_DOWN";
    public static const VIDEO_READY:String = "VIDEO_READY";
    public static const VIDEOPLAYER_READY:String = "VIDEOPLAYER_READY";
    public static const CHECKED:String = "CHECKED";
    public static const UNCHECKED:String = "UNCHECKED";
    public static const MOUSE_UP:String = "MOUSE_UP";
    public var data:Array = null;

    public function CustomEvent(type:String, data:Array = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
    }
}
}