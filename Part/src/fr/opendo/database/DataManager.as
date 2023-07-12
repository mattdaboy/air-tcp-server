package fr.opendo.database {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;

import fr.opendo.modals.Modals;
import fr.opendo.socket.SocketManagerConst;
import fr.opendo.tools.DateUtils;
import fr.opendo.tools.Debug;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu
 */
public class DataManager extends Sprite {
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    private static var _sql:Sql;
    private static var _checkList:Array;
    private static var _checkList_OK:Boolean;
    private static var _user:User;
    private static var _userNotes:Vector.<DataNote>;
    private static var _tcpserver_ip_ready:Boolean;
    private static var _sessions_modules_saved:uint;
    private static var _infosConnexion:String = "";
    private static var _parameters_data:XML;
    private static var _language:String = DataConst.DEFAULT_LANGUAGE;
    private static var _quisuisje_persistent:Boolean = true;
    private static var _quisuisje_date:String;
    private static var _animationcode_android_tmp_data:XML = <data>
        <active>0</active>
        <current_code></current_code>
    </data>;

//    private static var _anim_ids:Vector.<String>;
    private static var _anim_id:String = "";

    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function DataManager() {
    }

    public static function init():void {
        _checkList = [];
        _checkList["userInfos"] = false;
        _checkList["tcpServerIp"] = false;
        _checkList_OK = false;
        _sessions_modules_saved = 0;
//        _anim_ids = new Vector.<String>();

        _sql = new Sql();
        _tcpserver_ip_ready = false;
        _userNotes = new Vector.<DataNote>();
        Sql.getInstance().addEventListener(Event.OPEN, dbOpenHandler);
        Sql.getInstance().addEventListener(SqlCustomEvent.USER_INFOS_SAVED_TO_DB, addUserInfosHandler);
        Sql.getInstance().addEventListener(SqlCustomEvent.USER_INFOS_READ, readUserInfosHandler);
        Sql.getInstance().addEventListener(SqlCustomEvent.TCPSERVER_IP_READ, readTCPServerIpHandler);
        Sql.getInstance().addEventListener(SqlCustomEvent.USER_NOTE_SAVED_TO_DB, addUserNoteHandler);
        Sql.getInstance().addEventListener(SqlCustomEvent.USER_NOTES_READ, readUserNoteHandler);
        Sql.getInstance().addEventListener(SqlCustomEvent.USER_DELETE_NOTE_FROM_DB, deleteUserNoteHandler);
        Sql.getInstance().addEventListener(SqlCustomEvent.USER_SCREENSHOT_SAVED_TO_DB, addUserScreenshotHandler);
        Sql.getInstance().addEventListener(SqlCustomEvent.USER_SCREENSHOTS_READ, readUserScreenshotsHandler);
        Sql.getInstance().addEventListener(SqlCustomEvent.PARAMETERS_UPDATED_IN_DB, parametersUpdatedHandler);
    }

    private static function dbOpenHandler(event:Event):void {
        log("Database opened !");
        readAllInfos();
    }

    private static function readAllInfos():void {
        Sql.readUserInfos();
        Sql.readTCPServerIp();
    }

    private static function startupCheckList(item:String):void {
        _checkList[item] = true;
        var items_nb:uint = 0;
        var true_items_nb:uint = 0;
        for each (var e:Boolean in _checkList) {
            items_nb++;
            if (e) {
                true_items_nb++;
            }
        }
        if (true_items_nb == items_nb) {
            _checkList_OK = true;
            start();
        }
    }

    private static function start():void {
        // data manager est ready
        _dispatcher.dispatchEvent(new Event(Event.COMPLETE));
    }

    //
    // USER INFOS
    //
    private static function createUser(nom:String, prenom:String, email:String, langue:String, app_version:String, photo:String = ""):void {
        _user = new User(nom, prenom, email.toLowerCase(), langue, app_version, photo);
    }

    public static function updateInfosUserInDB(nom:String, prenom:String, email:String, langue:String, app_version:String, photo:String):void {
        addUserInfos(nom, prenom, email, langue, app_version, photo);
    }

    private static function addUserInfos(nom:String, prenom:String, email:String, langue:String, app_version:String, photo:String = ""):void {
        _user.nom = nom;
        _user.prenom = prenom;
        _user.email = email;
        _user.photo = photo;
        _user.langue = langue;
        _user.appVersion = app_version;
        Sql.setUserInfos(nom, prenom, email, langue, photo);
    }

    private static function addUserInfosHandler(event:SqlCustomEvent):void {
        _quisuisje_date = event.data[0];
        log("Mon profil mis à jour : " + event.data);
        _dispatcher.dispatchEvent(new SqlCustomEvent(SqlCustomEvent.USER_INFOS_SAVED_TO_DB));
    }

    private static function readUserInfosHandler(event:SqlCustomEvent):void {
        var userInfos:Array = event.data[0] as Array;
        createUser(userInfos[0].nom, userInfos[0].prenom, userInfos[0].email, userInfos[0].langue, Tools.appVersion, userInfos[0].photo);
        _quisuisje_date = userInfos[0].date;
        startupCheckList("userInfos");

        // Qui suis-je (est-ce qu'on remet les infos à zéro ou pas)
        checkQuisuisje();
    }


    private static function checkQuisuisje():void {
        // log("checkQuisuisje(), date de dernier enregistrement des infos = " + _quisuisje_date);
        if (_quisuisje_date != "") {
            var quisuisje_date:Date = DateUtils.isoToDate(_quisuisje_date);
            var same_day:Boolean = DateUtils.isSamedDay(quisuisje_date, new Date());
            // log("Même jour = " + same_day);
            if (_quisuisje_persistent == false && !same_day) {
                addUserInfos("", "", "", _language, "");
            }
        }
    }

    //
    // PARAMETERS
    //
    public static function updateParametersInDB(quisuisje_persistent:Boolean):void {
        log("updateParameters");
        Sql.updateParameters(quisuisje_persistent);
    }

    private static function parametersUpdatedHandler(event:SqlCustomEvent):void {
        log("Parameters updated");
    }

    //
    // ANIMATEUR(S)
    //
    public static function get animId():String {
        return _anim_id;
    }

    public static function set animId(anim_id:String):void {
        _anim_id = anim_id;
    }

    //
    // USER
    //
    public static function get user():User {
        return _user;
    }

    //
    // TCP SERVER IP
    //
    private static function readTCPServerIpHandler(event:SqlCustomEvent):void {
        var tcpserver_ip:Array = event.data[0] as Array;
        _infosConnexion = tcpserver_ip[0].ip;
        startupCheckList("tcpServerIp");
    }

    //
    // USER NOTE
    //
    public static function readUserNotes():void {
        Sql.readUserNotes();
    }

    private static function readUserNoteHandler(event:SqlCustomEvent):void {
        var tempTab:Array = event.data[0] as Array;
        _userNotes = new Vector.<DataNote>();
        if (tempTab != null) {
            for (var i:uint = 0; i < tempTab.length; i++) {
                var note:DataNote = new DataNote(tempTab[i].id, tempTab[i].date, tempTab[i].content, tempTab[i].img);
                _userNotes.push(note);
            }
        }
        _dispatcher.dispatchEvent(new SqlCustomEvent(SqlCustomEvent.USER_NOTES_READ));
    }

    public static function addUserNotes(txt:String, img:String):void {
        Sql.addUserNote(txt, img);
    }

    private static function addUserNoteHandler(event:SqlCustomEvent):void {
        var db_id:uint = event.data[0] as uint;
        var date:String = event.data[1] as String;

        _dispatcher.dispatchEvent(new SqlCustomEvent(SqlCustomEvent.USER_NOTE_SAVED_TO_DB, [db_id, date]));
    }

    public static function setUserNote(dataNote:DataNote):void {
        Sql.setUserNote(dataNote.db_id, dataNote.note_content, dataNote.note_img);
    }

    public static function deleteUserNote(note_id:uint):void {
        Sql.deleteUserNote(note_id);
    }

    private static function deleteUserNoteHandler(event:SqlCustomEvent):void {
        // on met à jour le tableau des notes
        readUserNotes();
    }

    public static function getDataNoteById(id:uint):DataNote {
        for each (var n:DataNote in _userNotes) {
            if (n.db_id == id) {
                return n;
            }
        }

        return null;
    }

    //
    // USER SCREENSHOTS
    //
    public static function addUserScreenshot(screenshot:String, commentaires:String):void {
        Sql.addUserScreenshot(screenshot, commentaires);
    }

    private static function addUserScreenshotHandler(event:SqlCustomEvent):void {
        _dispatcher.dispatchEvent(new SqlCustomEvent(SqlCustomEvent.USER_SCREENSHOT_SAVED_TO_DB));
    }

    public static function readUserScreenshots():void {
        Sql.readUserScreenshots();
    }

    private static function readUserScreenshotsHandler(event:SqlCustomEvent):void {
        var tempTab:Array = event.data[0] as Array;
        _dispatcher.dispatchEvent(new SqlCustomEvent(SqlCustomEvent.USER_SCREENSHOTS_READ, tempTab));
    }

    //
    // USER CONTENT
    //
    public static function get userNotes():Vector.<DataNote> {
        return _userNotes;
    }

    public static function get infosConnexion():String {
        return _infosConnexion;
    }

    public static function set infosConnexion(infos:String):void {
        _infosConnexion = infos;
    }

    //
    // Paramètres
    public static function updateParametersDatas(datas:String):void {
        _parameters_data = XML(datas);
        if (_parameters_data.http_server_port.length() > 0) {
            SocketManagerConst.HTTP_SERVER_PORT = _parameters_data.http_server_port;
        }
        Modals.waitPage.updateInterfaceParameters();
    }

    public static function get parametersData():XML {
        return _parameters_data;
    }

    public static function set parametersData(value:XML):void {
        _parameters_data = value;
    }

    // Langue
    public static function get language():String {
        return _language;
    }

    public static function set language(value:String):void {
        _language = value;
    }

    //
    // Qui suis-je : persistent
    public static function get profilePersistent():Boolean {
        return _quisuisje_persistent;
    }

    public static function set profilePersistent(value:Boolean):void {
        _quisuisje_persistent = value;
    }

    //
    // Qui suis-je : date
    public static function get profileDate():String {
        return _quisuisje_date;
    }

    public static function set profileDate(value:String):void {
        _quisuisje_date = value;
    }

    //
    // AnimationCode Android Tmp data
    public static function get androidTmpData():XML {
        return _animationcode_android_tmp_data;
    }

    public static function set androidTmpData(value:XML):void {
        _animationcode_android_tmp_data = value;
    }

    //
    // COMMON
    public static function updateLangue(langue:String):void {
        _sql.updateLangue(langue);
    }

    public static function get dispatcher():EventDispatcher {
        return _dispatcher;
    }
}
}