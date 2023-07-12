package fr.opendo.data {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getTimer;

import fr.opendo.activites.IModule;
import fr.opendo.events.CustomEvent;
import fr.opendo.socket.SocketConnexionStatus;
import fr.opendo.socket.User;
import fr.opendo.tools.DateUtils;
import fr.opendo.tools.Debug;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu
 */
public class DataManager extends EventDispatcher {
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    private static var _current_session_data:SessionData;
    private static var _sessions_data:Vector.<SessionData>;
    private static var _users_data:Vector.<UserData>;
    private static var _currentModule:IModule = null;
    private static var _current_module_data:XML;
    private static var _parameters_data:XML;
    private static var _lic_team:Boolean;

    // distanciel
    private static var _websocket_user_id:String;

    // Timing
    private static var _t1:uint;
    private static var _t2:uint;

    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function DataManager() {
        throw new Error("!!! DataManager est un singleton et ne peut pas être instancié !!!");
    }

    public static function init():void {
        _websocket_user_id = "";
        _current_session_data = new SessionData();
        _current_module_data = new XML();
        clearCurrentSessionData();
        clearModuleData();

        Sql.addEventListener(Event.OPEN, dbOpenHandler);
        Sql.addEventListener(SqlCustomEvent.USER_CONTENT_SAVED_TO_DB, addUserContentToDBHandler);
        Sql.addEventListener(SqlCustomEvent.USER_PRESENCE_SAVED_TO_DB, addUserPresenceToDBHandler);
        Sql.addEventListener(SqlCustomEvent.USERS_PRESENCE_READ, readUsersPresenceFromDBHandler);
        Sql.addEventListener(SqlCustomEvent.USER_CONTENT_READ, readUserContentFromDBHandler);
        Sql.addEventListener(SqlCustomEvent.SESSION_ADDED_TO_DB, sessionAddedToDB);
        Sql.addEventListener(SqlCustomEvent.SESSION_UPDATED_IN_DB, sessionUpdatedInDBHandler);

        _t1 = getTimer();

        Sql.init();
    }

    private static function dbOpenHandler(e:Event):void {
        Sql.removeEventListener(Event.OPEN, dbOpenHandler);

        _t2 = getTimer();
        var timing:uint = _t2 - _t1;
//        Modals.banner.show("DB opened & optimized in " + timing + "ms");

        Sql.addEventListener(SqlCustomEvent.SESSIONS_READ, readSessionsFromDBHandler);
        Sql.readSessions();
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // Users Content
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    private static function addUserContentToDBHandler(event:SqlCustomEvent):void {
        var id:uint = event.data[0];
        _dispatcher.dispatchEvent(new SqlCustomEvent(SqlCustomEvent.USER_CONTENT_SAVED_TO_DB, [id]));
    }

    private static function addUserPresenceToDBHandler(event:SqlCustomEvent):void {
    }

    private static function readUserContentFromDBHandler(event:SqlCustomEvent):void {
        var user_contents:Array = event.data[0] as Array;
    }

    private static function readUsersPresenceFromDBHandler(event:SqlCustomEvent):void {
        var users_presences:Array = event.data[0] as Array;
    }

    //
    // add user content
    //
    public static function addUserContent(user:User, module_type:String, module_title:String, content:String):void {
//        Clipboard.generalClipboard.clear();
//        Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, content);
//        Modals.banner.show("Données copiées");

        content = Tools.parseUserContents(content);
        Sql.addUserContent(user.email, user.prenom + " " + user.nom, module_type, module_title, content, _current_session_data.title);
    }

    //
    // add user content for sequenced sondage (et d'autres par la suite...)
    //
    public static function addSequencedUserContent(user_email:String, user_prenom:String,user_nom:String,module_type:String, module_title:String, content:String):void {
//        Clipboard.generalClipboard.clear();
//        Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, content);
//        Modals.banner.show("Données copiées");

        content = Tools.parseUserContents(content);
        Sql.addUserContent(user_email, user_prenom + " " + user_nom, module_type, module_title, content, _current_session_data.title);
    }

    //
    // add user content for traces
    //
    public static function addUserTracesContent(prenom:String, nom:String, email:String, module_type:String, module_title:String, content:String):void {
        var session_title:String = getSessionTitleBySessionId(_current_session_data.id);
        var nom_complet:String = prenom + " " + nom;
        content = Tools.parseUserContents(content);
        Sql.addUserContent(email, nom_complet, module_type, module_title, content, session_title);
    }

    public static function updateUserScore(db_user_id:uint, content:String):void {
        Sql.updateUserScore(db_user_id, content);
    }

    //
    // Ajout de la présence d'un participant
    //
    public static function addUserPresence(user:User, module_title:String, content:String):void {
        var session_id:String = String(_current_session_data.id);
        var session_title:String = getSessionTitleBySessionId(_current_session_data.id);
        content = Tools.parseUserPresences(content);
        Sql.addUserPresence(user.prenom, user.nom, user.email, content, module_title, session_id, session_title);
    }

    // Compactage de la DB
    public static function dbCompact():void {
        Sql.addEventListener(SqlCustomEvent.DB_COMPACTED, dbCompactHandler);
        Sql.addEventListener(SqlCustomEvent.DB_COMPACT_ERROR, dbCompactErrorHandler);
        Sql.dbCompact();

        function dbCompactHandler(e:SqlCustomEvent):void {
            Sql.removeEventListener(SqlCustomEvent.DB_COMPACTED, dbCompactHandler);
            Sql.removeEventListener(SqlCustomEvent.DB_COMPACT_ERROR, dbCompactErrorHandler);
            _dispatcher.dispatchEvent(new SqlCustomEvent(SqlCustomEvent.DB_COMPACTED, [null]));
        }

        function dbCompactErrorHandler(e:SqlCustomEvent):void {
            Sql.removeEventListener(SqlCustomEvent.DB_COMPACTED, dbCompactHandler);
            Sql.removeEventListener(SqlCustomEvent.DB_COMPACT_ERROR, dbCompactErrorHandler);
            _dispatcher.dispatchEvent(new SqlCustomEvent(SqlCustomEvent.DB_COMPACT_ERROR, [null]));
        }
    }

    //
    // Publications des utilisateurs
    //
    public static function deleteAllIdSnapshots():void {
        Sql.deleteAllIdSnapshots();
    }

    public static function deleteAllUserContents():void {
        Sql.deleteAllUserContents();
        Sql.deleteAllIdSnapshots();
        Sql.deleteAllPresence();
    }

    public static function deleteSpecificUserContents(specific_id:String):void {
        Sql.deleteSpecificUserContents(specific_id);
    }

    public static function deleteSpecificPresence(specific_id:String):void {
        Sql.deleteSpecificPresence(specific_id);
    }

    public static function deleteAllPresence():void {
        Sql.deleteAllPresence();
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // Sessions
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    private static function readSessionsFromDBHandler(e:SqlCustomEvent):void {
        Sql.removeEventListener(SqlCustomEvent.SESSIONS_READ, readSessionsFromDBHandler);
        _sessions_data = new Vector.<SessionData>();
        // on remplit le tableau sessions_datas avec les données de la DB
        var tmp:Array = e.data as Array;
        if (tmp != null) {
            for (var i:uint = 0; i < tmp.length; i++) {
                var sessionData:SessionData = new SessionData(tmp[i]["id"], tmp[i]["author_session_id"], tmp[i]["exp_email"], tmp[i]["title"], tmp[i]["date"], tmp[i]["modules"]);
                _sessions_data.push(sessionData);
            }
        }

        SocketConnexionStatus.classMode = _parameters_data.mode_de_classe;

        getAllUserInfos();
    }

    public static function addEmptySessionInDB():void {
        var date_jjmm:String = DateUtils.dateToDayMonthIso(new Date());
        var title:String = "SESSION " + date_jjmm;
        var date:String = DateUtils.dateToIso(new Date());
        var exp_email:String = DataManager.parametersData.license_email;
        var modules:XML = new XML(DefaultModulesXML.CONTENT_EMPTY);
        var cleaned_session_modules_xml:XML = Tools.parseSessionXML(modules);
        var author_session_id:int = int(Tools.randomStringNumber(6));
        addSessionInDB(
                title,
                date,
                exp_email,
                author_session_id,
                cleaned_session_modules_xml);
        OnlineChecksManager.resetCheckSessions();
    }

    public static function addSessionInDB(title:String, date:String, exp_email:String, author_session_id:int, modules:XML):void {
        log("addSessionInDB");
//        log(date);
//        log(modules);
        modules.synchro_date.setChildren(date);
        Sql.addSessionInDB(
                title,
                date,
                exp_email,
                author_session_id,
                modules);
        OnlineChecksManager.resetCheckSessions();
    }

    private static function sessionAddedToDB(event:SqlCustomEvent):void {
        log("sessionAddedToDB");
        var temp_session_data:SessionData = event.data[0];
        _sessions_data.push(temp_session_data);
        StoreLocalFilesToCLoud.store(true);
        StoreCloudFilesToLocal.store();

        var webservices_cloud:WebServicesSynchroWithCloud = new WebServicesSynchroWithCloud();
        webservices_cloud.synchroSessionToCLoud(temp_session_data.author_session_id);

        // dispatch sur session list (pour le display)
        _dispatcher.dispatchEvent(new SqlCustomEvent(SqlCustomEvent.SESSION_ADDED_TO_DB, [temp_session_data]));
    }

    public static function updateSessionInDB(title:String, date:String, exp_email:String, author_session_id:int, modules_xml:XML):void {
        var session_id:uint = getSessionDataByAuthorId(author_session_id).id;
        Sql.updateSessionInDB(
                session_id,
                title,
                date,
                exp_email,
                author_session_id,
                modules_xml);
        OnlineChecksManager.resetCheckSessions();
    }

    private static function sessionUpdatedInDBHandler(event:SqlCustomEvent):void {
        var session_id:uint = uint(event.data[0]);
        log("sessionUpdatedInDBHandler : " + session_id);
    }

    public static function setSessionModules(session_id:int = -1, session_modules_xml:XML = null):void {
        if (session_id == -1) session_id = _current_session_data.id;
        if (session_modules_xml == null) session_modules_xml = _current_session_data.modules_xml;
        Sql.setSessionModules(session_id, session_modules_xml);
        OnlineChecksManager.resetCheckSessions();
    }

    public static function synchroSessionWithCloud(author_session_id:uint, session_deleted:uint = 0):void {
        log("DataManager.synchroSessionWithCloud() author_session_id = " + author_session_id + ", session_deleted = " + session_deleted);

        var webservices_cloud:WebServicesSynchroWithCloud = new WebServicesSynchroWithCloud();
        webservices_cloud.synchroSessionToCLoud(author_session_id, session_deleted);
    }

    // public
    public static function get sessionsData():Vector.<SessionData> {
        return _sessions_data;
    }

    public static function get currentModule():IModule {
        return _currentModule;
    }

    public static function set currentModule(currentModule:IModule):void {
        _currentModule = currentModule;
    }

    public static function updateInfosForSharedSession(email:String, session_id:uint):void {
        Sql.addSharedInfosToSession(email, session_id);
    }

    // sessions in DB
    public static function isSharedSessionExistInDB(author_session_id:int, exp_email:String):Number {
        var rid:Number = -1;
        for each (var session:SessionData in _sessions_data) {
            if (session.author_session_id == author_session_id && session.exp_email == exp_email) {
                rid = session.id;
                break;
            }
        }
        return rid;
    }

    public static function setParameters():void {
        Sql.setParameters(_parameters_data);
    }

    public static function addStartup():void {
        var nb:uint = uint(_parameters_data.startups.nb);
        nb++;
        _parameters_data.startups.nb = nb;
        _parameters_data.startups.date = DateUtils.dateToIso(new Date());
        setParameters();
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // WebSocket
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    public static function set websocketUserId(user_id:String):void {
        _websocket_user_id = user_id;
    }

    public static function get websocketUserId():String {
        return _websocket_user_id;
    }

    // on lit toutes les publications de la DB
    // les tables concernées sont :
    // user_contents
    // id_snapshots
    // user_presence
    public static function getPublicationsUtilisateurs():void {
        Sql.addEventListener(SqlCustomEvent.USERS_CONTENT_READ, readUsersContentFromDBHandler);
        Sql.readUsersContent();

        function readUsersContentFromDBHandler(event:SqlCustomEvent):void {
            var usersContent:Array = event.data[0];
            Sql.removeEventListener(SqlCustomEvent.USERS_CONTENT_READ, readUsersContentFromDBHandler);
            Sql.addEventListener(SqlCustomEvent.SNAPSHOTS_READ, readSnapshotsFromDB);
            Sql.readSnapshots();

            function readSnapshotsFromDB(event:SqlCustomEvent):void {
                var snapshots:Array = event.data[0];
                Sql.removeEventListener(SqlCustomEvent.SNAPSHOTS_READ, readSnapshotsFromDB);
                Sql.addEventListener(SqlCustomEvent.PRESENCE_READ, readPresenceFromDB);
                Sql.readPresence();


                function readPresenceFromDB(event:SqlCustomEvent):void {
                    var presence:Array = event.data[0];
                    Sql.removeEventListener(SqlCustomEvent.PRESENCE_READ, readPresenceFromDB);

                    // dispatch vers la page publications
                    // avec un tableau contenant 4 tableaux : 1 tableau users content, 1 tableau captures du formateur ET 1 tableau presence
                    //
                    _dispatcher.dispatchEvent(new CustomEvent(CustomEvent.READ_PUBLICATIONS, [usersContent, snapshots, presence]));
                }
            }
        }
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // Users infos
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    /*
     * Ajoute ou met à jour les données d'un participant dans la table user_infos
     * @param user : l'objet User d'un participant connecté
     */
    public static function addUserInfosInDB(user:User):void {
        var photo_filename:String = Tools.parseUserPhoto(user.email, user.photo_base64);
        user.createPhoto(photo_filename);

        // Création de UserData pour chaque utilisateur connecté pour pouvoir accéder à ses données
        // en temps réel avec la fonction getUserDataByEmail (sans questionner la DB)
        var user_data:UserData = getUserDataByEmail(user.email);
        (user_data) ?
                user_data.updateDatas(DateUtils.dateToIso(new Date()), user.prenom, user.nom, user.photo_filename)
                : _users_data.push(new UserData(DateUtils.dateToIso(new Date()), user.prenom, user.nom, user.email, user.photo_filename));

        // Enregistrement des infos de l'utilisateur dans la DB
        Sql.addUserInfos(user.prenom, user.nom, user.email, user.photo_filename);
    }

    /**
     * Retourne les datas d'un participant (connu dans la DB ou connecté)
     * @param email : l'email du participant
     */
    public static function getUserDataByEmail(email:String):UserData {
        var result:UserData;
        for each(var user_data:UserData in _users_data) {
            if (user_data.email == email) result = user_data;
        }
        return result;
    }

    private static function getAllUserInfos():void {
        _users_data = new Vector.<UserData>();
        Sql.addEventListener(SqlCustomEvent.USER_INFOS, onRead);
        Sql.getAllUserInfos();

        function onRead(event:SqlCustomEvent):void {
            Sql.removeEventListener(SqlCustomEvent.USER_INFOS, onRead);
            var data:Array = event.data[0];
            if (data) {
                // Création du vecteur _users_data pour pouvoir accéder aux données de tous les utilisateurs connus
                // en temps réel avec la fonction getUserDataByEmail (sans questionner la DB)
                for (var i:uint = 0; i < data.length; i++) {
                    var user_data:UserData = new UserData(data[i]["date"], data[i]["prenom"], data[i]["nom"], data[i]["email"], data[i]["photo"]);
                    _users_data.push(user_data);
                }
            }

            // On a stocké les sessions dans _sessions_data
            // On a stocké les user_inofs dans _users_data
            // Dispatch vers Main
            _dispatcher.dispatchEvent(new Event(Event.COMPLETE));
        }
    }

    // qanda
    public static function updateUserQandaContent(db_id:uint, content:String):void {
        content = Tools.parseUserContents(content);
        Sql.updateUserQandaContent(db_id, content);
    }

    //
    // sessions
    public static function get currentSessionData():SessionData {
        return _current_session_data;
    }

    public static function set currentSessionData(value:SessionData):void {
        _current_session_data = value;
    }

    public static function clearCurrentSessionData():void {
        _current_session_data = new SessionData(-1, -1, "", "-", "", null);
    }

    // paramètres additionnels de session (pdfs + notes pré-formattées)
    public static function get sessionParameters():XML {
        return _current_session_data.parameters_xml;
    }

    //
    // module
    public static function get currentModuleData():XML {
        return _current_module_data;
    }

    public static function clearModuleData():void {
        _current_module_data = null;
    }

    //
    // Paramètres
    public static function get parametersData():XML {
        return _parameters_data;
    }

    public static function set parametersData(value:XML):void {
        _parameters_data = value;
    }

    public static function set currentModuleData(value:XML):void {
        _current_module_data = value;
    }

    public static function getSessionDataById(session_id:uint):SessionData {
        var session_data:SessionData;
        for each (var session:SessionData in _sessions_data) {
            if (session_id == session.id) {
                session_data = session;
                break;
            }
        }
        return session_data;
    }

    public static function getSessionDataByAuthorId(author_session_id:uint):SessionData {
        var session_data:SessionData;
        for each (var session:SessionData in _sessions_data) {
            if (author_session_id == session.author_session_id) {
                session_data = session;
                break;
            }
        }
        return session_data;
    }

    public static function deleteSessionDataByAuthorId(author_session_id:uint):SessionData {
        var index_to_delete:uint;
        for (var i:uint = 0; i < _sessions_data.length; i++) {
            if (author_session_id == _sessions_data[i].author_session_id) {
                index_to_delete = i;
                break;
            }
        }
        var session_data:SessionData = _sessions_data[i];
        _sessions_data.splice(i, 1);
        return session_data;
    }

    private static function getSessionTitleBySessionId(session_id:uint):String {
        var title:String = "";
        for each (var session:SessionData in _sessions_data) {
            if (session_id == session.id) {
                title = session.title;
                break;
            }
        }
        return title;
    }

    public static function getModuleDataById(session_id:uint, module_id:uint):XML {
        var module_xml:XML;
        var session_data:SessionData = getSessionDataById(session_id);
        var modules_list:XMLList = Tools.getNodeListByName(session_data.modules_xml, "module");
        for each (var node:XML in modules_list) {
            if (node.id == module_id) {
                module_xml = node;
                break;
            }
        }
        return module_xml;
    }

    public static function getFirstName():String {
        var re:String;
        _parameters_data.enabled == "1" ? re = _parameters_data.firstname : re = _parameters_data.discover.firstname;
        return re;
    }

    public static function getLastName():String {
        var re:String;
        _parameters_data.enabled == "1" ? re = _parameters_data.lastname : re = _parameters_data.discover.lastname;
        return re;
    }

    public static function getCompany():String {
        var re:String;
        _parameters_data.enabled == "1" ? re = _parameters_data.company : re = _parameters_data.discover.company;
        return re;
    }

    public static function getEmail():String {
        var re:String;
        _parameters_data.enabled == "1" ? re = _parameters_data.license_email : re = _parameters_data.discover.email;
        return re;
    }

    public static function getPhone():String {
        var re:String;
        DataManager.parametersData.discover.phone.toString() != "" ? re = DataManager.parametersData.discover.phone.toString() : re = "";
        return re;
    }

    public static function get licTeam():Boolean {
        return _lic_team;
    }

    public static function set licTeam(value:Boolean):void {
        _lic_team = value;
    }

    public static function get dispatcher():EventDispatcher {
        return _dispatcher;
    }
}
}