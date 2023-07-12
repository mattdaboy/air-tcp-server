package fr.opendo.socket {
import flash.events.EventDispatcher;

import fr.opendo.data.DataManager;
import fr.opendo.modals.Modals;
import fr.opendo.tools.Const;
import fr.opendo.tools.Language;

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
        throw new Error("!!! SocketConnexionStatus est un singleton et ne peut pas être instancié !!!");
    }

    public static function setStatusAndDisplay(status:String):void {
        _connexion_status = status;
        updateCodeAccess();
    }

    public static function updateCodeAccess():void {
        var label:String = "";
        var value:String = "";

        if (_class_mode == Const.CLASSE_DISTANCIEL) {
            switch (_connexion_status) {
                case NOT_CONNECTED:
                    label = Language.getValue("no-ratchet");
                    break;
                case CONNECTING:
                    label = Language.getValue("connecting");
                    break;
                case CONNECTED:
                    label = Language.getValue("code-acces") + " : ";
                    value = SocketManager.currentRoom.name;
                    if (DataManager.parametersData.ihm.speedy_boarding == "1") {
                        Modals.usersListPopup.setCode("https://app.opendo.fr/speedyjoin/" + SocketManager.currentRoom.name);
                    } else {
                        Modals.usersListPopup.setCode("https://app.opendo.fr/join/" + SocketManager.currentRoom.name);
                    }
                    break;
            }
        }

        if (_class_mode == Const.CLASSE_PRESENTIEL) {
            switch (_connexion_status) {
                case NOT_CONNECTED:
                    label = Language.getValue("no-ratchet");
                    break;
                case CONNECTING:
                    label = Language.getValue("connecting");
                    break;
                case CONNECTED:
                    label = Language.getValue("code-acces") + " : ";
                    value = SocketManager.networkAddress;
                    break;
            }
        }
        Modals.accessCode.update(label, value);
    }

    public static function get status():String {
        return _connexion_status;
    }

    public static function set status(value:String):void {
        _connexion_status = value;
        updateCodeAccess();
    }

    public static function get classMode():String {
        return _class_mode;
    }

    public static function set classMode(value:String):void {
        _class_mode = value;
    }

    public static function get connected():Boolean {
        return _connexion_status == CONNECTED;
    }
}
}
