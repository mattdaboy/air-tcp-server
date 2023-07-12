package fr.opendo.socket {
import flash.events.EventDispatcher;

/**
 * @author Matt - 2021-11-16
 */
public class SocketConnexionStatus extends EventDispatcher {
    // Status de connexion websocket (distanciel) ou opendosocket (présentiel)
    public static const NOT_CONNECTED:String = "NOT_CONNECTED";
    public static const CONNECTING:String = "CONNECTING";
    public static const CONNECTED:String = "CONNECTED";
    private static var _connexion_status:String = NOT_CONNECTED;
    private static var _class_mode:String;

    public function SocketConnexionStatus() {
    }

    public static function get status():String {
        return _connexion_status;
    }

    public static function set status(value:String):void {
        _connexion_status = value;
    }

    public static function get classMode():String {
        return _class_mode;
    }

    public static function set classMode(value:String):void {
        _class_mode = value;
    }

    public static function get connected():Boolean {
        var value:Boolean = false;
        if (_connexion_status == CONNECTED) value = true;
        return value;
    }
}
}
