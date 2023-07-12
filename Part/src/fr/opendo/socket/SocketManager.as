package fr.opendo.socket {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;

import fr.opendo.database.DataManager;
import fr.opendo.database.User;
import fr.opendo.medias.Base64Files;
import fr.opendo.modals.Modals;
import fr.opendo.tools.Const;
import fr.opendo.tools.Debug;
import fr.opendo.tools.Language;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu
 */
public class SocketManager extends Sprite {
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    private static var _opendo_socket:OpendoSocket;
    private static var _wsTab:Array = [];
    private static var _currentModule:String;
    private static var _infos_sent_to_formateur:Boolean = false;
    private static var _sendAutoPingTimeout:uint;
    private static const SEND_AUTOPING_DELAY:uint = 60000;

    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    // private const WEBSOCKET_SERVER : String = "ws://ha-ratchet4.opendo.fr"; // Ratchet v4
    public function SocketManager() {
    }

    public static function startSocketManager(mode_de_classe:String):void {
        log("SocketManager.startSocket()");

        SocketConnexionStatus.classMode = mode_de_classe;

        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL) {
            _opendo_socket = new OpendoSocket();
            _opendo_socket.addEventListener(SocketCustomEvents.OPENDO_SOCKET_CONNECTED, onOpendoSocketConnected);
            _opendo_socket.addEventListener(SocketCustomEvents.OPENDO_SOCKET_ERROR, onOpendoSocketError);

            Modals.gimikO.show(Language.getValue("gimik-connexion-formateur"));
            Modals.gimikO.setNoCancel();
        }

    }

    // ---------------------------------------------------------
    // PRESENTIEL
    // ---------------------------------------------------------
    // tcp server et socket opendo : mode de classe présentiel
    //
    private static function openOpendoSocket():void {
        log("openOpendoSocket()");

        SocketConnexionStatus.status = SocketConnexionStatus.CONNECTING;

        if (DataManager.user == null) {
            // ("Attention !<BR><BR>Vous devez remplir les informations dans le module QUI SUIS-JE ?")
            Modals.dialogbox.show(Language.getValue("dialogbox-remplir-infos"));
            return;
        }
        _opendo_socket.open();
        _opendo_socket.addEventListener(SocketCustomEvents.OPENDO_SOCKET_CONNECTED, onOpendoSocketConnected);
        _opendo_socket.addEventListener(SocketCustomEvents.OPENDO_SOCKET_ERROR, onOpendoSocketError);
    }

    private static function onOpendoSocketConnected(e:SocketCustomEvents):void {
        log("onOpendoSocketConnected()");

        SocketConnexionStatus.status = SocketConnexionStatus.CONNECTED;

        _opendo_socket.removeEventListener(SocketCustomEvents.OPENDO_SOCKET_CONNECTED, onOpendoSocketConnected);
        _opendo_socket.addEventListener(SocketCustomEvents.OPENDO_SOCKET_DISCONNECTED, onOpendoSocketDisconnected);
        _opendo_socket.addEventListener(SocketCustomEvents.OPENDO_SOCKET_DATA, onSocketEvent);

        // Dispatch sur Main
        _dispatcher.dispatchEvent(new Event(Event.COMPLETE));

        // Lorsque le client se connecte au serveur TCP, il envoie ses informations au formateur
        sendUserInfosToFormateur(DataManager.user);
    }

    private static function onOpendoSocketError(e:SocketCustomEvents):void {
        log("onOpendoSocketError()");

        SocketConnexionStatus.status = SocketConnexionStatus.NOT_CONNECTED;

        _opendo_socket.removeEventListener(SocketCustomEvents.OPENDO_SOCKET_CONNECTED, onOpendoSocketConnected);
        _opendo_socket.removeEventListener(SocketCustomEvents.OPENDO_SOCKET_ERROR, onOpendoSocketError);
    }

    private static function onOpendoSocketDisconnected(e:SocketCustomEvents):void {
        log("onOpendoSocketDisconnected()");

        SocketConnexionStatus.status = SocketConnexionStatus.NOT_CONNECTED;

        _opendo_socket.removeEventListener(SocketCustomEvents.OPENDO_SOCKET_DISCONNECTED, onOpendoSocketDisconnected);
        _opendo_socket.removeEventListener(SocketCustomEvents.OPENDO_SOCKET_DATA, onSocketEvent);

        DataManager.androidTmpData.active = 0;

        // "L'application a été déconnectée. Voulez-vous vous reconnecter ?
        Modals.dialogbox.show(Language.getValue("dialogbox-app-deconnectee"), openOpendoSocket);
        Modals.dialogbox.setCancelFunction();
        Modals.waitPage.hide();
    }

    private static function socketCancel():void {
    }

    // Réception des données
    private static function onSocketEvent(event:SocketCustomEvents):void {
        var str:String = String(event.data[0]);
        var temp:Array = str.split(SocketManagerConst.SEPARATOR1);
        var action:String = temp[0];
        var value:String = temp[1];
        doInstruction(action, value);
    }

    private static function doInstruction(action:String, value:String):void {
        // Tous les dispatchs se font vers Main
        log("Action = " + action);
        if (value) log("Value = " + value);

        if (action.indexOf("OPEN_") != -1) {
            var module_type:String = action.substring(5, 6).toUpperCase() + action.substring(6).toLowerCase();
            _currentModule = module_type;
        } else {
            switch (action) {
                case SocketManagerConst.QUESTION_GO:
                case SocketManagerConst.QUESTION_POINTS:
                case SocketManagerConst.QANDA_MESSAGE:
                case SocketManagerConst.QANDA_MESSAGE_DELETE:
                case SocketManagerConst.QANDA_UPDATE_LIKES:
                case SocketManagerConst.QANDA_PAUSE:
                case SocketManagerConst.QANDA_PLAY:
                case SocketManagerConst.QANDA_QUESTION_ALREADY_EXISTS:
                case SocketManagerConst.ANIMATION_SELECTION:
                case SocketManagerConst.SITUATION_CONTENU:
                case SocketManagerConst.PUZZLE_POS:
                case SocketManagerConst.PUZZLE_LOCK:
                case SocketManagerConst.PUZZLE_UNLOCK:
                case SocketManagerConst.PUZZLE_IMG:
                case SocketManagerConst.CARD_USER_SELECTED:
                case SocketManagerConst.CARD_NO_USER_SELECTED:
                case SocketManagerConst.CARD_RETURNED:
                case SocketManagerConst.CARD_POINTS:
                case SocketManagerConst.WHOIS_REVEAL:
                case SocketManagerConst.VIDEO_SYNCHRO_PAUSE_AT:
                case SocketManagerConst.VIDEO_SYNCHRO_PLAY_AT:
                case SocketManagerConst.NUAGE_PAUSE:
                case SocketManagerConst.NUAGE_PLAY:
                case SocketManagerConst.NUAGE_UPDATE:
                case SocketManagerConst.SONDAGE_PAUSE:
                case SocketManagerConst.SONDAGE_PLAY:
                case SocketManagerConst.TABLEAU_BLANC_MSG:
                case SocketManagerConst.TABLEAU_BLANC_MSG_POS:
                case SocketManagerConst.TABLEAU_BLANC_MSG_DELETE:
                case SocketManagerConst.TABLEAU_BLANC_UPDATE_LIKES:
                case SocketManagerConst.TABLEAU_BLANC_DEMARRER:
                case SocketManagerConst.ANIMATION_CODE_CONTENT:
                case SocketManagerConst.CARDS_CONTENT:
                case SocketManagerConst.QUESTION_PAUSE:
                case SocketManagerConst.QUESTION_RESUME:
                case SocketManagerConst.ANIMATION_RESTART:
                case SocketManagerConst.ADMINISTRATIF_DATA_RECEIVED:
//                    Main.instance.modulesContainer.instructionToModule(action, null);
                    break;
                case SocketManagerConst.CHAT_MESSAGE:
                    onRecievedChatMessage(value);
                    break;
                case SocketManagerConst.SEND_INFOS_TO_FORMATEUR:
                    sendUserInfosToFormateur(DataManager.user);
                    break;
                case SocketManagerConst.FORCE_DECONNECTION_FROM_WEB_SOCKET:
                    break;
                case SocketManagerConst.PARAMETERS_DATAS:
                    DataManager.updateParametersDatas(value);
                    break;
                case SocketManagerConst.CLOSE_MODULE:
                    break;
                case SocketManagerConst.ARE_YOU_THERE:
                    sendPongToFormateur(DataManager.user, value);
                    break;
            }
        }
    }

    // ---------------------------------------------------------
    // COMMON FUNCTIONS
    // ---------------------------------------------------------
    //
    public static function closeAllConnections():void {
        log("SocketManager.closeAllConnections()");

        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL) {
            if (_opendo_socket != null) {
                sendToFormateur(SocketManagerConst.FORCE_SOCKET_CLOSE);
                _opendo_socket.close();
                _opendo_socket = null;
            }
        }
        SocketConnexionStatus.status = SocketConnexionStatus.NOT_CONNECTED;
    }

    /**
     * Envoi à tout le monde
     * @param str de la forme : action du type ManagerConstantes+":"+données
     */
    public static function sendAll(str:String):void {
        _opendo_socket.sendAll(str);
    }

    /**
     * Envoi vers une seule ip
     * @param ip En présentiel, c'est l'ip du destinataire. En distanciel, c'est l'userId (Ratchet) du destinataire
     * @param str Action du type ManagerConstantes + ":" + données
     */
    public static function sendOTO(ip:String, str:String):void {
        _opendo_socket.sendOTO(ip, str);
    }

    public static function sendToFormateur(instruction:String, value:String = ""):void {
        var str:String;
        str = instruction + SocketManagerConst.SEPARATOR1 + value + SocketManagerConst.SEPARATOR1 + SocketManagerConst.LOCAL_ADDRESS;
        sendOTO("127.0.0.1", str);
    }

    private static function sendUserInfosToFormateur(user:User):void {
        log("SocketManager.sendUserInfosToFormateur() : " + user.email + "/" + user.id);
        var str:String;
        var photo_file:File = Tools.getFileFromFilename(user.photo);
        var photo_base64:String = Base64Files.FileToBase64(photo_file);
        str = SocketManagerConst.USER_INFO + SocketManagerConst.SEPARATOR1 + user.nom + SocketManagerConst.SEPARATOR2 + user.prenom + SocketManagerConst.SEPARATOR2 + user.email + SocketManagerConst.SEPARATOR2 + photo_base64 + SocketManagerConst.SEPARATOR2 + user.langue + SocketManagerConst.SEPARATOR2 + user.appVersion + SocketManagerConst.SEPARATOR1 + SocketManagerConst.LOCAL_ADDRESS;
        sendOTO("127.0.0.1", str);
    }

    private static function sendPongToFormateur(user:User, formateurId:String):void {
        var str:String;
        str = SocketManagerConst.IM_THERE + SocketManagerConst.SEPARATOR1 + "" + SocketManagerConst.SEPARATOR1 + SocketManagerConst.LOCAL_ADDRESS;
        sendOTO("127.0.0.1", str);
    }

    private static function onRecievedChatMessage(value:String):void {
//        Main.instance.userNav.updateChatMessage(value);
    }

    public static function sendNoteToFormateur(user:User, note_content:String, note_img:String, note_id:String):void {
        var str:String = SocketManagerConst.USER_NOTE + SocketManagerConst.SEPARATOR1 + user.nom + SocketManagerConst.SEPARATOR2 + user.prenom + SocketManagerConst.SEPARATOR2 + user.email + SocketManagerConst.SEPARATOR2 + note_content + SocketManagerConst.SEPARATOR2 + note_img + SocketManagerConst.SEPARATOR2 + note_id + SocketManagerConst.SEPARATOR1 + SocketManagerConst.LOCAL_ADDRESS;
        sendOTO("127.0.0.1", str);
    }

    public static function get connected():Boolean {
        var result:Boolean = false;
        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL && _opendo_socket.socket.connected) result = true;
        return result;
    }

    public static function get dispatcher():EventDispatcher {
        return _dispatcher;
    }
}
}