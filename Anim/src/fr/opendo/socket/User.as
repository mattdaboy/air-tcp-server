package fr.opendo.socket {
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.utils.clearTimeout;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import fr.opendo.data.DataManager;
import fr.opendo.events.CustomEvent;
import fr.opendo.medias.ImageLoader;
import fr.opendo.tools.Const;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu
 */
public class User extends EventDispatcher {
    private var _nom:String = "";
    private var _prenom:String = "";
    private var _email:String = "";
    private var _photo_filename:String = "";
    private var _photo_base64:String = "";
    private var _color:uint;
    private var _image_loader:ImageLoader;
    private var _id:String = "";
    private var _t_opened:uint;
    private var _langue:String;
    private var _appVersion:String;

    // PING PONG
    private const CONNECTION_TIMEOUT:uint = 30000;
    private var SEND_FIRST_PING_DELAY:uint = 1000 + Math.random() * 5000;
    private var SEND_PING_DELAY:uint = 15000 + Math.random() * 15000;
    private var _connectionStatus:String;
    private var _previous_connectionStatus:String;
    private const CONNECTION_SPEED_MEDIUM:uint = 5000;
    private const CONNECTION_SPEED_HIGH:uint = 500;
    private var _latency_start:uint;
    private var _latency_end:uint;
    private var _sendPingTimeout:uint;
    private var _timeout:uint;

    public function User(nom:String, prenom:String, email:String, id:String, photo:String = "", langue:String = "FR", app_version:String = "") {
        _nom = (nom != null) ? nom : "";
        _prenom = prenom;
        _email = email;
        _id = id;
        _photo_base64 = photo;
        _photo_filename = "";
        _langue = langue;
        _appVersion = app_version;

        _previous_connectionStatus = SocketManagerConst.INIT_CONNECTION;
        setConnectionStatus(SocketManagerConst.INIT_CONNECTION);

        _image_loader = new ImageLoader(ImageLoader.FILL, 480, 480, 80);
        _image_loader.addEventListener(Event.COMPLETE, photoCompleteHandler);

        // Couleur
        _color = Const.PICTO_COLORS[Math.floor(Math.random() * (Const.PICTO_COLORS.length - 1))];

        // Ping Pong
        _sendPingTimeout = setTimeout(sendPing, SEND_FIRST_PING_DELAY);

        _t_opened = getTimer();
    }

    public function createPhoto(photo_filename:String):void {
        _photo_filename = photo_filename;

        // Préparation de la photo
        if (Tools.isPhotoLocalImage(_photo_filename)) {
            var photo_file:File = File.applicationStorageDirectory.resolvePath(Const.HTDOCS_DIR + File.separator + _photo_filename);
            var photo_url:String = photo_file.url;
            _image_loader.load(photo_url);
        } else {
            _image_loader.load(_photo_filename);
        }
    }

    private function photoCompleteHandler(event:Event):void {
        _image_loader.removeEventListener(Event.COMPLETE, photoCompleteHandler);
        dispatchEvent(new CustomEvent(CustomEvent.USER_PHOTO_LOADED));
    }

    public function get nom():String {
        return _nom;
    }

    public function get prenom():String {
        return _prenom;
    }

    public function get email():String {
        return _email;
    }

    public function get photo_filename():String {
        return _photo_filename;
    }

    public function get photo_base64():String {
        return _photo_base64;
    }

    public function get photo_loaded():Boolean {
        return _image_loader.loaded;
    }

    public function get photo_bitmap():Bitmap {
        if (!photo_loaded) return null;
        return _image_loader.bitmapCopy;
    }

    public function get color():uint {
        return _color;
    }

    /*
     * id de l'user
     * en mode de classe présentiel il s'agit de l'IP
     * en mode de classe distanciel il s'agit du userId généré par le websocket
     */
    public function get id():String {
        return _id;
    }

    public function clean():void {
        var duration:uint = Math.round((getTimer() - _t_opened) / 1000);
    }

    //
    // Ping Pong
    //
    public function initPing():void {
        cleanTimeout();
        _sendPingTimeout = setTimeout(sendPing, SEND_PING_DELAY);
    }

    private function sendPing():void {
        cleanTimeout();
        _timeout = setTimeout(onTimeout, CONNECTION_TIMEOUT);
        _latency_start = getTimer();
        SocketManager.sendOTO(_id, SocketManagerConst.ARE_YOU_THERE + Const.SEPARATOR1 + DataManager.websocketUserId);
    }

    private function onTimeout():void {
        cleanTimeout();
        setConnectionStatus(SocketManagerConst.USER_TIMEOUT);
        _sendPingTimeout = setTimeout(sendPing, SEND_PING_DELAY);
    }

    public function recievePong():void {
        _latency_end = getTimer();
        var timeToRespond:Number = _latency_end - _latency_start;
        if (timeToRespond < CONNECTION_SPEED_HIGH) {
            setConnectionStatus(SocketManagerConst.HIGH_CONNECTION);
        }
        if (timeToRespond >= CONNECTION_SPEED_HIGH && timeToRespond < CONNECTION_SPEED_MEDIUM) {
            setConnectionStatus(SocketManagerConst.MEDIUM_CONNECTION);
        }
        if (timeToRespond >= CONNECTION_SPEED_MEDIUM && timeToRespond < CONNECTION_TIMEOUT) {
            setConnectionStatus(SocketManagerConst.SLOW_CONNECTION);
        }
        if (timeToRespond >= CONNECTION_TIMEOUT) {
            setConnectionStatus(SocketManagerConst.USER_TIMEOUT);
        }
    }

    private function setConnectionStatus(status:String):void {
        _connectionStatus = status;
        if (_connectionStatus != _previous_connectionStatus) {

            // dispatch sur UserDisplay
            dispatchEvent(new CustomEvent(CustomEvent.CONNECTION_STATUS_CHANGED, [_connectionStatus]));

            // dispatch sur Users
            if (_connectionStatus == SocketManagerConst.USER_TIMEOUT) dispatchEvent(new CustomEvent(CustomEvent.USER_NOT_RESPONDING));
            if (_previous_connectionStatus == SocketManagerConst.USER_TIMEOUT && _connectionStatus != SocketManagerConst.USER_TIMEOUT) dispatchEvent(new CustomEvent(CustomEvent.USER_RESPONDING_AGAIN));

            _previous_connectionStatus = _connectionStatus;
        }
    }

    public function get appVersion():String {
        return _appVersion;
    }

    public function cleanTimeout():void {
        clearTimeout(_timeout);
        clearTimeout(_sendPingTimeout);
    }

    public function get connectionStatus():String {
        return _connectionStatus;
    }
}
}