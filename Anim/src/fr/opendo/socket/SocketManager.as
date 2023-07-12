package fr.opendo.socket {
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.clearInterval;
import flash.utils.clearTimeout;
import flash.utils.setInterval;

import fr.opendo.data.DataManager;
import fr.opendo.events.CustomEvent;
import fr.opendo.tools.Const;
import fr.opendo.tools.Debug;
import fr.opendo.tools.Language;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu
 */
public class SocketManager extends EventDispatcher {
    private static var _this:EventDispatcher = new EventDispatcher();
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    private static var _tcp_server:TCPServer;
    private static var _file_server:FileServer;
    private static var _opendo_socket:AnimSocket;
    private static var _currentAction:String;
    private static var _network_address:String;
    private static var _intervalCheckIP:uint;
    private static var _sendAutoPingTimeout:uint;

    private static var _animVersionVSPartVersionDisplay:Boolean = false;

    private static const LOG:Boolean = true;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    // private const WEBSOCKET_SERVER : String = "ws://ha-ratchet4.opendo.fr"; // Ratchet v4 avec heartbeat
    public function SocketManager() {
        throw new Error("!!! SocketManager est un singleton et ne peut pas être instancié !!!");
    }

    public static function startSocket():void {
        log("SocketManager.startSocket()");

        SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.NOT_CONNECTED);

        if (!Users.hasEventListener(CustomEvent.USERS_CHANGED)) {
            Users.addEventListener(CustomEvent.USERS_REMOVED, usersRemovedHandler);
            Users.addEventListener(CustomEvent.USERS_CHANGED, usersChangedHandler);
        }

        InternetConnexionStatus.addEventListenerCustom(CustomEvent.INTERNET_AVAILABLE_AGAIN, restartSocket);

        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL)
            createTCPServer();

    }

    private static function restartSocket(event:CustomEvent = null):void {
        log("SocketManager.restartSocket()");
        if (!SocketConnexionStatus.connected) {
            startSocket();
        } else {
            SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.CONNECTED);
        }
    }

    private static function usersRemovedHandler(event:CustomEvent):void {
        var user:User = event.data[0];
        sendOTO(user.id, SocketManagerConst.FORCE_DECONNECTION_FROM_WEB_SOCKET);
    }

    private static function usersChangedHandler(event:CustomEvent):void {
    }

    private static function sendAutoPing():void {
        log("sendAutoPing");
        sendOTO(DataManager.websocketUserId, SocketManagerConst.PING);
    }

    public static function requestUserInfos(userId:String):void {
        log("requestUserInfos, userId = " + userId);
        sendOTO(userId, SocketManagerConst.SEND_INFOS_TO_FORMATEUR);
    }

    // ---------------------------------------------------------
    // PRESENTIEL
    // ---------------------------------------------------------
    // tcp server et socket opendo : mode de classe présentiel
    //
    private static function createTCPServer():void {
        log("SocketManager.createTCPServer()");

        SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.CONNECTING);

        if (_tcp_server == null) {
            _tcp_server = new TCPServer();
            _tcp_server.addEventListener(SocketCustomEvents.SOCKET_CONNECTED_TO_TCP_SERVER, tcpServerSocketConnected);
            _tcp_server.addEventListener(SocketCustomEvents.SOCKET_DISCONNECTED_TO_TCP_SERVER, tcpServerSocketDisconnected);
            _tcp_server.addEventListener(SocketCustomEvents.TCP_SERVER_CLOSED, tcpServerClosed);
            _tcp_server.addEventListener(Event.COMPLETE, tcpServerComplete);
            _tcp_server.create();
        }

        _tcp_server.start();
    }

    private static function tcpServerComplete(event:Event):void {
        log("SocketManager.tcpServerComplete()");

        SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.CONNECTING);

        _opendo_socket = new AnimSocket();
        _opendo_socket.addEventListener(SocketCustomEvents.OPENDO_SOCKET_CONNECTED, onOpendoSocketConnected);
    }

    private static function tcpServerClosed(event:SocketCustomEvents):void {
        log("SocketManager.tcpServerClosed()");

        SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.NOT_CONNECTED);
    }

    private static function tcpServerSocketConnected(event:SocketCustomEvents):void {
        log("SocketManager.tcpServerSocketConnected()");
    }

    private static function tcpServerSocketDisconnected(event:SocketCustomEvents):void {
        log("SocketManager.tcpServerSocketDisconnected()");

        var client_networkAddress:String = String(event.data[0]);

        // Le formateur se déconnecte
        if (client_networkAddress == "127.0.0.1") SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.NOT_CONNECTED);

        // Un participant se déconnecte
        if (client_networkAddress != "127.0.0.1") Users.removeUser(Users.getUserById(client_networkAddress));
    }

    private static function onOpendoSocketConnected(event:SocketCustomEvents):void {
        log("SocketManager.onOpendoSocketConnected()");

        SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.CONNECTING);

        _opendo_socket.removeEventListener(SocketCustomEvents.OPENDO_SOCKET_CONNECTED, onOpendoSocketConnected);
        _opendo_socket.addEventListener(SocketCustomEvents.OPENDO_SOCKET_DATA, onSocketEvent);

        checkIP();

        // Création du FileServer pour le module Animation Code
        // (service des fichiers depuis l'app Formateur)
        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL) createFileServer();
    }


    private static function checkIP():void {
        log("SocketManager.checkIP()");

        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) {
            var hostsMobile:LocalIPcheckMobile = new LocalIPcheckMobile();
            hostsMobile.addEventListener(CustomEvent.HOSTS_CHECKED, hostsCheckedHandler);
            hostsMobile.check();
        } else {
            var hostsDesktop:LocalIPcheck = new LocalIPcheck();
            hostsDesktop.addEventListener(CustomEvent.HOSTS_CHECKED, hostsCheckedHandler);
            hostsDesktop.check();
        }

        clearInterval(_intervalCheckIP);
        _intervalCheckIP = setInterval(autoCheckIP, 15000);
    }

    private static function hostsCheckedHandler(e:CustomEvent):void {
        hostsAnalyze(e.data[0]);

        // En présentiel, on a terminé tout le processus de connexion, donc on dispatch sur Main
        _dispatcher.dispatchEvent(new Event(Event.COMPLETE));
    }

    private static function autoCheckIP():void {
        log("SocketManager.autoCheckIP()");

        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) {
            var hostsMobile:LocalIPcheckMobile = new LocalIPcheckMobile();
            hostsMobile.addEventListener(CustomEvent.HOSTS_CHECKED, hostsAutoCheckedHandler);
            hostsMobile.check();
        } else {
            var hostsDesktop:LocalIPcheck = new LocalIPcheck();
            hostsDesktop.addEventListener(CustomEvent.HOSTS_CHECKED, hostsAutoCheckedHandler);
            hostsDesktop.check();
        }
    }

    private static function hostsAutoCheckedHandler(e:CustomEvent):void {
        hostsAnalyze(e.data[0]);
    }

    private static function hostsAnalyze(data:Array):void {
        log("SocketManager.hostsAnalyze()");

        if (data.length == 0) {
            _network_address = Language.getValue("connexion-no");
            SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.NOT_CONNECTED);
        } else {
            _network_address = String(data[0]);
            SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.CONNECTED);
        }
    }

    // file server (mode de classe présentiel uniquement) pour servir des fichiers (pdf, mp4, ...)
    private static function createFileServer():void {
        log("Création du serveur HTTP.");
        _file_server = new FileServer();
        _file_server.addEventListener(ErrorEvent.ERROR, fileServerError);
        _file_server.addEventListener(Event.CONNECT, fileServerConnect);
        _file_server.addEventListener(CustomEvent.FILE_SERVER_COMPLETE, fileServerComplete);
        _file_server.start();
    }

    private static function fileServerError(event:ErrorEvent):void {
        // Le port réservé au FileServer est déjà utilisé par un autre service.\n\nVous ne pourrez pas utiliser le module Animation Code.
    }

    private static function fileServerConnect(event:Event):void {
        log("Le serveur HTTP est connecté.");
    }

    private static function fileServerComplete(event:Event):void {
        log("Le serveur HTTP est prêt.");
        Const.FILE_SERVER_PORT_AVAILABLE = true;
    }

    // Réception et gestion des données
    private static function onSocketEvent(event:SocketCustomEvents):void {
        var str:String = String(event.data[0]);
        var temp:Array = str.split(Const.SEPARATOR1);
        var action:String = temp[0];
        var value:String = temp[1];
        var ip_exp:String = temp[2];
        var email_exp:String = temp[3];
        doInstruction(action, value, ip_exp, email_exp);
    }

    // Instruction que l'animateur reçoit des ses participants pour les activités (entre autres)
    private static function doInstruction(action:String, value:String = "", id_exp:String = "", email_exp:String = ""):void {
//        log("SocketManager.doInstruction : action = " + action);

        var ids:String = "";
        for (var i:uint = 0; i < Users.users.length; i++) {
            ids += Users.users[i].id + " ";
        }

        // Quand un user envoie des datas à l'animateur, on remet le ping pong (ARE_YOU_THERE -> IM_THERE) à zéro
        var user:User;
        (email_exp == null) ? user = Users.getUserById(id_exp) : user = Users.getUserByEmail(email_exp);
        if (user != null) user.initPing();
        // open module
        if (action.indexOf("OPEN_") != -1) {
            // le openModule se fait directement par le formateur sans passer par le message sendToAll
            // on construit le nom du module Animation, TableauBlanc
            // var m : String = action.substring(5, 6).toUpperCase() + action.substring(6).toLowerCase();
            // dispatchEvent(new SocketCustomEvents(SocketCustomEvents.OPEN_MODULE, [m, value]));
        } else {
            var infos:Array;
            var nom:String;
            var prenom:String;
            var email:String;

            switch (action) {
                case SocketManagerConst.USER_INFO:
                    createUser(value, id_exp);
                    break;
                case SocketManagerConst.BD_IMG:
                case SocketManagerConst.DESSIN_IMG:
                case SocketManagerConst.DEBRIEFING_NOTE:
                case SocketManagerConst.ID_IMG:
                case SocketManagerConst.QUESTION_BUZZ:
                case SocketManagerConst.QUIZ_REPONSES:
                case SocketManagerConst.MATHS_REPONSES:
                case SocketManagerConst.SONDAGE_REPONSES:
                case SocketManagerConst.TABLEAU_BLANC_MSG:
                case SocketManagerConst.TABLEAU_BLANC_MSG_POS:
                case SocketManagerConst.TABLEAU_BLANC_MSG_DELETE:
                case SocketManagerConst.TABLEAU_BLANC_MSG_LIKE:
                case SocketManagerConst.TABLEAU_BLANC_MSG_DISLIKE:
                case SocketManagerConst.QANDA_MESSAGE:
                case SocketManagerConst.QANDA_MESSAGE_DISLIKE:
                case SocketManagerConst.QANDA_MESSAGE_LIKE:
                case SocketManagerConst.QANDA_QUESTION_ALREADY_EXISTS:
                case SocketManagerConst.HUMEUR:
                case SocketManagerConst.APPRECIATION:
                case SocketManagerConst.MESSAGE:
                case SocketManagerConst.QUIZ_ANIMATION_CODE_REPONSES:
                case SocketManagerConst.ADMINISTRATIF_REPONSES:
                case SocketManagerConst.PRESENCE_REPONSES:
                case SocketManagerConst.PAIR_REPONSES:
                case SocketManagerConst.FORM_ANSWERS:
                case SocketManagerConst.CARD_RETURNED:
                case SocketManagerConst.WHOIS_REPONSES:
                case SocketManagerConst.VIDEO_SYNCHRO_USER_READY:
                case SocketManagerConst.VIDEO_SYNCHRO_NEED_DATA:
                case SocketManagerConst.NUAGE_MSG:
                case SocketManagerConst.PUZZLE_POS:
                    log(action);
                    break;
                case SocketManagerConst.CLOSE_MODULE:
                    _currentAction = null;
                    break;
                case SocketManagerConst.IM_THERE:
                    if (user != null) user.recievePong();
                    break;
                case SocketManagerConst.FORCE_SOCKET_CLOSE:
                    forceCloseClientSockets(id_exp);
                    break;
            }
        }
    }

    private static function createUser(value:String = "", id_exp:String = "", anonymous:Boolean = false):void {
        var infos:Array;
        var nom:String;
        var prenom:String;
        var email:String;
        var photo_base64:String;
        var langue:String
        var app_version:String;
        var id:String;

        if (!anonymous) {
            if (value.indexOf(Const.SEPARATOR2) == -1) {
                infos = value.split(",");
            } else {
                infos = value.split(Const.SEPARATOR2);
            }
            nom = infos[0];
            prenom = infos[1];
            email = infos[2];
            photo_base64 = infos[3];
            langue = infos[4];
            app_version = infos[5];
            if (app_version == null) app_version = "1.0";
            if (app_version == langue) app_version = "1.0"; // Bug bizarre, corrigé dans la v12
            id = id_exp;
        } else {
            if (value.indexOf(Const.SEPARATOR2) == -1) {
                infos = value.split(",");
            } else {
                infos = value.split(Const.SEPARATOR2);
            }
            nom = "Dupont";
            prenom = "Michel" + Math.floor(Math.random() * 99);
            email = Math.floor(Math.random() * 999999999) + "@opendo.fr";
            id = "" + Math.floor(Math.random() * 999999999);
            photo_base64 = infos[3];
            langue = infos[4];
            app_version = infos[5];
        }

        var user:User = new User(nom, prenom, email, id, photo_base64, langue, app_version);
        DataManager.addUserInfosInDB(user);
        Users.add(user);

        log("SocketManager.createUser() : prenom, email, id = " + prenom + ", " + email + ", " + id + ", _users.length = " + Users.length);

        // On envoie la mise à jour de l'interface (logo et fond à l'apprenant)
        // On enlève l'image de la home qui ne concerne que le Formateur
        var xml:XML = new XML(DataManager.parametersData.ihm);
        xml.appendChild(<http_server_port>{SocketManagerConst.HTTP_SERVER_PORT}</http_server_port>);
        xml.appendChild(<app_version>{Main.instance.version}</app_version>);
        delete (xml.home);

        if (Tools.versionToNumber(user.appVersion, 1) < 12) xml = Tools.convertParametersDataV12ToOldParametersData(xml);

        sendParametersDatasToApprenant(user.id, SocketManagerConst.PARAMETERS_DATAS + Const.SEPARATOR1 + String(xml));

        // si cet apprenant rejoint la formation avec un module en cours on ouvre ce module coté apprenant
        if (_currentAction != null) {
            var tmp:Array;
            var module_xml:XML;
            var contenus:XML;

            sendOTO(user.id, _currentAction);
        }
    }

    private static function forceCloseClientSockets(id_exp:String):void {
        if (Tools.OS.type == Const.ANDROID) {
            _tcp_server.closeStoredSocketById(id_exp);
            Users.removeUser(Users.getUserByEmail(id_exp));
        }
    }

    /*
     * envoie des données de l'interface (img logo et couleur des btns) à un apprenant qui vient de se connecter
     * @param id l'id de apprenant
     * @param str le message à envoyer
     */
    private static function sendParametersDatasToApprenant(id:String, str:String):void {
        sendOTO(id, str);
    }

    /*
     * envoie d'un message à tout le monde (y compris le formateur)
     * @param str le message à envoyer
     */
    public static function sendAll(str:String):void {
        if (_opendo_socket) _opendo_socket.sendAll(str);
    }

    /*
     * envoie d'un message du formateur à un apprenant spécifique (One To One)
     * @param ip en mode presentiel l'ip de l'apprenant, en mode distanciel le web_socket_id de l'apprenant
     * @param str le message à envoyer
     */
    public static function sendOTO(id:String, str:String):void {
        if (_opendo_socket) _opendo_socket.sendOTO(id, str);
    }

    /*
     * envoie d'un message du formateur à tous les apprenants
     * @param str le message à envoyer
     * @param parts_elligible un tableau des ids des participants
     */
    public static function sendToApprenants(str:String, parts_eligible:Array = null):void {
        if (_opendo_socket) _opendo_socket.sendToApprenants(SocketManagerConst.LOCAL_ADDRESS, str);
    }

    // changement de classe via les parametres
    public static function setModeDeClasse(mode_de_classe:String):void {
        closeAnimConnections();
        DataManager.parametersData.mode_de_classe = mode_de_classe;
        SocketConnexionStatus.classMode = mode_de_classe;
        // Save to DB
        DataManager.setParameters();

        // Start du SocketManager
        startSocket();
    }

    //
    // Tools
    //
    public static function closeAnimConnections():void {
        log("SocketManager.closeAnimConnections()");

        // on clean les timeout des users encore en ping pong
        if (Users) Users.reset();

        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL) {
            if (_tcp_server) {
                _tcp_server.kill();
                _tcp_server = null;
            }
            if (_opendo_socket) {
                _opendo_socket.close();
                _opendo_socket = null;
            }
        }

        clearInterval(_intervalCheckIP);
        clearTimeout(_sendAutoPingTimeout);

        SocketConnexionStatus.setStatusAndDisplay(SocketConnexionStatus.NOT_CONNECTED);
    }

    public static function closeAllPartConnections():void {
        log("SocketManager.closeAnimConnections()");
        SocketManager.sendToApprenants(SocketManagerConst.FORCE_DECONNECTION_FROM_WEB_SOCKET);
    }

    public static function get networkAddress():String {
        return _network_address;
    }

    public static function get currentAction():String {
        return _currentAction;
    }

    public static function get dispatcher():EventDispatcher {
        return _dispatcher;
    }

    public static function set currentAction(value:String):void {
        _currentAction = value;
    }
}
}
