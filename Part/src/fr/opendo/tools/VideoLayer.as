package fr.opendo.tools {
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.PermissionEvent;
import flash.media.Camera;
import flash.media.Video;
import flash.permissions.PermissionManager;
import flash.permissions.PermissionStatus;

import fr.opendo.modals.Modals;

/**
 * @author Noel
 */
public class VideoLayer extends Sprite {
    private var _camera:Camera;
    private var _video:Video;
    private var _mask:Sprite;
    private var _w:uint;
    private var _h:uint;
    private var _bt:MovieClip;
    public static const MOBILE_FRONT:String = "1";
    public static const MOBILE_BACK:String = "0";

    public function VideoLayer(w:uint = 480, h:uint = 480, bt:MovieClip = null) {
        _w = w;
        _h = h;
        _bt = bt;

        _mask = new Sprite();
        _mask.graphics.beginFill(0);
        _mask.graphics.drawRoundRect(0, 0, _w, _h, 80);
        _mask.graphics.endFill();
    }

    public function startCamera(mobile_side:String = MOBILE_FRONT):void {
        switch (Tools.OS.type) {
            case Const.MAC:
                requestMacOSCamera();
                break;
            case Const.WIN:
                _camera = Camera.getCamera("0");
                launchCamera();
                break;
            case Const.IOS:
            case Const.ANDROID:
                _camera = Camera.getCamera(mobile_side);
                requestCamera();
                break;
        }
    }

    private function requestCamera():void {
        if (Camera.permissionStatus != PermissionStatus.GRANTED) {
            _camera.addEventListener(PermissionEvent.PERMISSION_STATUS, camPermissionHandler);

            try {
                _camera.requestPermission();
            } catch (e:Error) {
                // another request is in progress
            }
        } else {
            launchCamera();
        }

        function camPermissionHandler(event:PermissionEvent):void {
            _camera.removeEventListener(PermissionEvent.PERMISSION_STATUS, camPermissionHandler);

            if (event.status == PermissionStatus.GRANTED) {
                launchCamera();
            } else {
                Modals.dialogbox.show(Language.getValue("dialogbox-autorise-acces-camera"));
                Modals.dialogbox.setNoCancel();
            }
        }
    }

    private function requestMacOSCamera():void {
        var cam_permission_manager:PermissionManager = Camera.permissionManager;
        cam_permission_manager.addEventListener(PermissionEvent.PERMISSION_STATUS, camPermissionHandler);
        cam_permission_manager.requestPermission();

        function camPermissionHandler(event:PermissionEvent):void {
            cam_permission_manager.removeEventListener(PermissionEvent.PERMISSION_STATUS, camPermissionHandler);

            if (event.status == PermissionStatus.GRANTED) {
                _camera = Camera.getCamera();
                launchCamera();
            } else {
                Modals.dialogbox.show(Language.getValue("dialogbox-autorise-acces-camera"));
                Modals.dialogbox.setNoCancel();
            }
        }
    }

    private function launchCamera():void {
        if (_camera == null) {
            Modals.banner.show(Language.getValue("dialogbox-camera-non-detectee"));
            if (_bt != null) _bt.visible = false;
        } else {
            _camera.setMode(_w, _h, 30);
            _video = new Video(_w, _h);
            _video.attachCamera(_camera);
            _video.smoothing = true;

            if (Tools.OS.type != Const.IOS) {
                _video.scaleX = -1;
                _video.x = _w;
            }

            addChild(_video);
            addChild(_mask);
            _video.mask = _mask;
        }
    }

//		public function get video() : Video {
//			return _video;
//		}

    public function get bmpd():BitmapData {
        var bmpd:BitmapData = new BitmapData(_w, _h);
        _video.mask = null;
        bmpd.draw(_video);
        _video.mask = _mask;
        return bmpd;
    }

    public function stopCamera():void {
        if (_video != null) {
            _video.attachCamera(null);
            _camera = null;
        }
    }
}
}