package fr.opendo.tools {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

import fr.opendo.events.CustomEvent;
import fr.opendo.socket.SocketManagerConst;
import fr.opendo.socket.User;

/**
 * @author Matthieu
 */
public class UserDisplay extends Sprite {
    private var _with_photo:Boolean;
    private var _user:User;
    private var _id:String;
    private var _photo:Bitmap = new Bitmap();
    private var _photo_container:Sprite;
    private var _bubble_firstname:UserBubbleFirstnameView;
    private var _scale:Number = 1;

    public function UserDisplay(user:User, with_photo:Boolean = true) {
        _user = user;
        _with_photo = with_photo;

        init();
    }

    private function init():void {
        _id = _user.id;

        _photo_container = new Sprite();
        _photo_container.x = -168;
        _photo_container.y = -168;
        addChild(_photo_container);

        // Bulle prénom
        _bubble_firstname = new UserBubbleFirstnameView();
        _bubble_firstname.x = -137;
        _bubble_firstname.y = 97;
        _bubble_firstname.$gimick.gotoAndStop(1);

        // Version de l'app Part
        var myFormat:TextFormat = new TextFormat();
        myFormat.size = 8;
        myFormat.font = "Roboto Regular";
        myFormat.color = 0x4D4D4D;

        var version_text:TextField = new TextField();
        version_text.defaultTextFormat = myFormat;
        version_text.x = 243;
        version_text.y = 42;
        version_text.alpha = .4;
        version_text.text = _user.appVersion;
        _bubble_firstname.addChild(version_text);

        // Gimick de qualité de connexion dans la bulle prénom
        _bubble_firstname.$firstname.text = _user.prenom;

        // Ecouteurs pour la mise à jour de la qualité du PING
        _user.addEventListener(CustomEvent.CONNECTION_STATUS_CHANGED, connectionStatusHandler);
        _user.addEventListener(CustomEvent.USER_PHOTO_LOADED, photoCompleteHandler);

        display();
    }

    private function photoCompleteHandler(event:Event):void {
        setDimensions();
        _photo = _user.photo_bitmap;
        display();
    }

    private function setDimensions():void {
        scaleX = scaleY = _scale;
    }

    private function display():void {
        (_user.photo_loaded && _with_photo) ? displayWithPhoto() : displayWithoutPhoto();
    }

    private function displayWithPhoto():void {
        addChild(_photo_container);
        Tools.displayUserPhoto(_photo_container, _photo, 336, 336, 40);
        _bubble_firstname.y = 97;
        addChild(_bubble_firstname);
    }

    private function displayWithoutPhoto():void {
        Tools.safeRemoveChild(this, _photo_container);
        _bubble_firstname.y = 0;
        addChild(_bubble_firstname);
    }

    private function connectionStatusHandler(event:CustomEvent):void {
        var status:String = String(event.data[0]);
        updateConnectionStatus(status);
    }

    private function updateConnectionStatus(status:String):void {
        var ustop:uint = 1;

        switch (status) {
            case SocketManagerConst.INIT_CONNECTION:
                ustop = 1;
                break;
            case SocketManagerConst.SLOW_CONNECTION:
                ustop = 2;
                break;
            case SocketManagerConst.MEDIUM_CONNECTION:
                ustop = 3;
                break;
            case SocketManagerConst.HIGH_CONNECTION:
                ustop = 4;
                break;
            case SocketManagerConst.USER_TIMEOUT:
                ustop = 5;
                break;
        }

        _bubble_firstname.$gimick.gotoAndStop(ustop);

        if (status != SocketManagerConst.USER_TIMEOUT) {
            _photo.alpha = 1;
            _bubble_firstname.alpha = 1;
        } else {
            _photo.alpha = .2;
            _bubble_firstname.alpha = .5;
        }
    }

    public function get id():String {
        return _id;
    }

    public function get withPhoto():Boolean {
        return _with_photo;
    }

    public function set withPhoto(with_photo:Boolean):void {
        if (with_photo != _with_photo) {
            _with_photo = with_photo;
            display();
        }
    }

    public function set setScale(sc:Number):void {
        _scale = sc;
        setDimensions();
    }
}
}