package fr.opendo.medias {

import by.blooddy.crypto.Base64;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.utils.ByteArray;

/**
 * @author matt
 * version : 2.0
 */
public class Base64BitmapLoader extends MovieClip {
    private var _image_loader:Loader;
    private var _bmpd:BitmapData;
    private var _captured_bmpd:BitmapData;
    private var _zoom:String;
    private var _center:Boolean;
    private var _loaded:Boolean = false;
    private var _w:uint;
    private var _h:uint;
    public var _width:uint;
    public var _height:uint;
    public var _round:uint;
    // _zoom peut prendre 3 valeurs :
    // - NONE (pas de resize de _image_loader)
    // - FIT (_image_loader tient dans le cadre défini par _w et _h en gardant les proportions de l'image)
    // - FILL (_image_loader prend tout l'espace défini par _w et _h en gardant les proportions de l'image)
    public static const NONE:String = "NONE";
    public static const FIT:String = "FIT";
    public static const FILL:String = "FILL";

    public function Base64BitmapLoader(zoom:String = "NONE", w:uint = 0, h:uint = 0, r:uint = 0, center:Boolean = true) {
        _zoom = zoom;
        _center = center;
        _w = w;
        _h = h;
        _round = r;

        unload();
    }

    public function load(imgString:String):void {
        try {
            var ba:ByteArray = Base64.decode(imgString) as ByteArray;

            _image_loader = new Loader;
            _image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            _image_loader.loadBytes(ba);
        } catch (error:Error) {
        }
    }

    public function unload():void {
        if (_image_loader) {
            removeChild(_image_loader);
            _image_loader = null;
        }
        _bmpd = null;
    }

    private function completeHandler(e:Event):void {
        try {
            _bmpd = new BitmapData(_image_loader.width, _image_loader.height);
            _bmpd.draw(_image_loader, null, null, null, null, true);
        } catch (error:Error) {
        }

        _width = _image_loader.width;
        _height = _image_loader.height;

        if (_zoom != NONE) {
            var fichier_ratio:Number = _image_loader.width / _image_loader.height;
            var loader_ratio:Number = _w / _h;
        }

        switch (_zoom) {
            case NONE :
                break;
            case FIT :
                if (fichier_ratio <= loader_ratio) {
                    _image_loader.height = _h;
                    _image_loader.scaleX = _image_loader.scaleY;
                } else {
                    _image_loader.width = _w;
                    _image_loader.scaleY = _image_loader.scaleX;
                }
                if (_center) {
                    _image_loader.x = Math.round((_w - _image_loader.width) / 2);
                    _image_loader.y = Math.round((_h - _image_loader.height) / 2);
                }
                break;
            case FILL :
                if (fichier_ratio <= loader_ratio) {
                    _image_loader.width = _w;
                    _image_loader.scaleY = _image_loader.scaleX;
                } else {
                    _image_loader.height = _h;
                    _image_loader.scaleX = _image_loader.scaleY;
                }
                if (_center) {
                    _image_loader.x = (_w - _image_loader.width) / 2;
                    _image_loader.y = (_h - _image_loader.height) / 2;
                }
                break;
        }
        addChild(_image_loader);

        // masque
        var masque:Sprite = new Sprite();
        masque.alpha = 0;
        masque.graphics.beginFill(0xFFFFFF);
        masque.graphics.drawRoundRect(0, 0, _w, _h, _round);
        _image_loader.mask = masque;
        addChild(masque);
        _loaded = true;

        var captured_matrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
        _captured_bmpd = new BitmapData(_w, _h);
        _captured_bmpd.draw(this, captured_matrix);

        dispatchEvent(new Event(Event.COMPLETE));
    }

    public function get bmpd():BitmapData {
        return _bmpd;
    }

    public function get captured_bmpd():BitmapData {
        return _captured_bmpd;
    }

    public function get loaded():Boolean {
        return _loaded;
    }
}
}