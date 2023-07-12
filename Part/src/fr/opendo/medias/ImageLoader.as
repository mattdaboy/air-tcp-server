package fr.opendo.medias {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import events.CustomEvent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.utils.setTimeout;

import fr.opendo.tools.Const;
import fr.opendo.tools.CustomMask;
import fr.opendo.tools.PreloaderCircle;
import fr.opendo.tools.Tools;

/**
 * @author Matt
 * version : 3.0 - 2023-03-28
 */
public class ImageLoader extends MovieClip {
    private var _preloader_circle:PreloaderCircle;
    private var _loader:Loader;
    private var _image_loader_added:Boolean;
    private var _zoom:String;
    private var _w:uint;
    private var _h:uint;
    private var _r:uint;
    private var _animation:Boolean;
    private var _bitmap:Bitmap;
    private var _bitmap_bis:Bitmap;
    private var _bmpd:BitmapData;
    private var _imgloader_w:uint;
    private var _imgloader_h:uint;
    private var _container:MovieClip;
    private var _loaded:Boolean = false;
    // _zoom peut prendre 3 valeurs :
    // - NONE (pas de resize de _image_loader)
    // - FIT (_image_loader tient dans le cadre défini par _w et _h en gardant les proportions de l'image)
    // - FILL (_image_loader prend tout l'espace défini par _w et _h en gardant les proportions de l'image)
    public static const NONE:String = "NONE";
    public static const FIT:String = "FIT";
    public static const FILL:String = "FILL";

    public function ImageLoader(zoom:String = NONE, w:uint = 0, h:uint = 0, r:uint = 0, animation:Boolean = true) {
        _zoom = zoom;
        _w = w;
        _h = h;
        _r = r;
        _animation = animation;
        _loader = new Loader();
        _bitmap_bis = new Bitmap();

        configureListeners(_loader.contentLoaderInfo);

        _preloader_circle = new PreloaderCircle();
        _preloader_circle.x = _w / 2;
        _preloader_circle.y = _h / 2;
        _preloader_circle.scaleX = .1;
        _preloader_circle.scaleY = .1;

        _image_loader_added = false;
    }

    private function configureListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(Event.COMPLETE, completeHandler);
        dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        dispatcher.addEventListener(Event.INIT, initHandler);
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
    }

    private function initHandler(e:Event):void {
    }

    private function ioErrorHandler(e:IOErrorEvent):void {
//        dispatchEvent(new CustomEvent(CustomEvent.IO_ERROR));
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function httpStatusHandler(e:HTTPStatusEvent):void {
    }

    public function loadByData(data:XML):void {
        _loader.alpha = 0;
        _loader.x = 0;
        _loader.y = 0;
        _loader.scaleX = 1;
        _loader.scaleY = 1;

        var store_manager_file:StoreManagerFile = new StoreManagerFile();
        store_manager_file.addEventListener(CustomEvent.COMPLETED, storeManageFileOnComplete);
        store_manager_file.manageFile(data.file_name.toString(), data.served_url.toString());

        function storeManageFileOnComplete(event:CustomEvent):void {
            store_manager_file.removeEventListener(CustomEvent.COMPLETED, storeManageFileOnComplete);
            var photo_file:File = event.data[0];
            var context:LoaderContext = new LoaderContext();
            context.checkPolicyFile = true;
            _loader.load(new URLRequest(photo_file.url), context);
        }

        _preloader_circle.alpha = 0;
        addChild(_preloader_circle);
        TweenLite.to(_preloader_circle, Const.ANIM_DURATION, {alpha: 1, delay: .5, ease: Power2.easeOut});
    }

    public function load(url:String):void {
        _loader.alpha = 0;
        _loader.x = 0;
        _loader.y = 0;
        _loader.scaleX = 1;
        _loader.scaleY = 1;

        var context:LoaderContext = new LoaderContext();
        context.checkPolicyFile = true;
        _loader.load(new URLRequest(url), context);

        _preloader_circle.alpha = 0;
        addChild(_preloader_circle);
        TweenLite.to(_preloader_circle, Const.ANIM_DURATION, {alpha: 1, delay: .5, ease: Power2.easeOut});
    }

    public function unload():void {
        if (_image_loader_added) {
            Tools.safeRemoveChild(_container, _loader);
            _image_loader_added = false;
        }
        _preloader_circle.update(0, 100);
        _bmpd = null;
        _bitmap = null;
        _loaded = false;
    }

    private function progressHandler(e:ProgressEvent):void {
        _preloader_circle.update(e.bytesLoaded, e.bytesTotal);
    }

    private function completeHandler(e:Event):void {
        _imgloader_w = _loader.width;
        _imgloader_h = _loader.height;

        _loader.x = Math.round((_w - _loader.width) / 2);
        _loader.y = Math.round((_h - _loader.height) / 2);

        _bitmap = Bitmap(_loader.content);
        _bmpd = new BitmapData(_bitmap.width, _bitmap.height);
        _bmpd.draw(_bitmap);
        _bitmap.smoothing = true;

        _bitmap_bis = new Bitmap(_bmpd);
        _bitmap_bis.smoothing = true;
        _bitmap_bis.alpha = 0;
        _bitmap_bis.x = _loader.x;
        _bitmap_bis.y = _loader.y;
        _bitmap_bis.width = _loader.width;
        _bitmap_bis.height = _loader.height;

        _loaded = true;

        setTimeout(loadEnd, 100);
    }

    private function loadEnd():void {
        imageLoaderScale(_zoom);
        addChild(_loader);

        // mask
        _container = new MovieClip();
        addChild(_container);
        _container.addChild(_loader);
        CustomMask.setMask(_container, 0, 0, _w, _h, _r);
        TweenLite.killTweensOf(_preloader_circle);
        TweenLite.to(_preloader_circle, Const.ANIM_DURATION / 2, {
            alpha: 0, ease: Power2.easeIn, onComplete: function ():void {
                removeChild(_preloader_circle);
            }
        });

        dispatchEvent(new Event(Event.COMPLETE));
        _image_loader_added = true;
    }

    public function imageLoaderScale(zoom:String):void {
        _zoom = zoom;

        var imgloader_finalw:uint = _imgloader_w;
        var imgloader_finalh:uint = _imgloader_h;
        var imgloader_finalscalex:Number = 1;
        var imgloader_finalscaley:Number = 1;
        var imgloader_finalx:int;
        var imgloader_finaly:int;
        var ratio:String = "portrait";

        if (zoom != NONE) {
            var fichier_ratio:Number = _imgloader_w / _imgloader_h;
            var loader_ratio:Number = _w / _h;

            switch (zoom) {
                case FIT :
                    if (fichier_ratio <= loader_ratio) {
                        imgloader_finalh = _h;
                        imgloader_finalscalex = imgloader_finalscaley = _h / _imgloader_h;
                        imgloader_finalw = _imgloader_w * imgloader_finalscalex;
                    } else {
                        imgloader_finalw = _w;
                        imgloader_finalscalex = imgloader_finalscaley = _w / _imgloader_w;
                        imgloader_finalh = _imgloader_h * imgloader_finalscaley;
                    }
                    break;
                case FILL :
                    if (fichier_ratio <= loader_ratio) {
                        ratio = "portrait";
                        imgloader_finalw = _w;
                        imgloader_finalscalex = imgloader_finalscaley = _w / _imgloader_w;
                        imgloader_finalh = _imgloader_h * imgloader_finalscaley;
                    } else {
                        ratio = "landscape";
                        imgloader_finalh = _h;
                        imgloader_finalscalex = imgloader_finalscaley = _h / _imgloader_h;
                        imgloader_finalw = _imgloader_w * imgloader_finalscalex;
                    }
                    break;
            }
            imgloader_finalx = Math.round((_w - imgloader_finalw) / 2);
            imgloader_finaly = Math.round((_h - imgloader_finalh) / 2);

            _loader.x = imgloader_finalx;
            _loader.y = imgloader_finaly;
            _loader.scaleX = imgloader_finalscalex;
            _loader.scaleY = imgloader_finalscaley;
            _bitmap_bis.x = imgloader_finalx;
            _bitmap_bis.y = imgloader_finaly;
            _bitmap_bis.scaleX = imgloader_finalscalex;
            _bitmap_bis.scaleY = imgloader_finalscaley;

            if (_animation) {
                TweenLite.to(_loader, Const.ANIM_DURATION, {alpha: 1, ease: Power2.easeOut});
                TweenLite.to(_bitmap_bis, Const.ANIM_DURATION, {alpha: .1, ease: Power2.easeOut});
            } else {
                _loader.alpha = 1;
                _bitmap_bis.alpha = .1;
            }
        }
    }

    public function get bitmapData():BitmapData {
        return _bmpd;
    }

    public function get bitmapCopy():Bitmap {
        if (!_bmpd) return null;

        var bmp:Bitmap = new Bitmap(_bmpd);
        bmp.smoothing = true;
        return bmp;
    }

    public function get loaded():Boolean {
        return _loaded;
    }
}
}