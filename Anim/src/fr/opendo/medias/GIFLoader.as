package fr.opendo.medias {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.utils.setTimeout;

import fr.opendo.tools.Const;
import fr.opendo.tools.Tools;

import org.bytearray.gif.player.GIFPlayer;

/**
 * @author Matt - 2022-03-09
 */
public class GIFLoader extends MovieClip {
    private var _url_image:URLRequest;
    private var _preloader:Sprite;
    private var _preloader_barre:Sprite;
    private var _gif_player:GIFPlayer;
    private var _gif_player_added:Boolean;
    private var _zoom:String;
    private var _w:uint;
    private var _h:uint;
    private var _fichier:String;
    private var _gifloader_w:uint;
    private var _gifloader_h:uint;
    private var _container:MovieClip;
    // _zoom peut prendre 3 valeurs :
    // - NONE (pas de resize de _gif_player)
    // - FIT (_gif_player tient dans le cadre défini par _w et _h en gardant les proportions de l'image)
    // - FILL (_gif_player prend tout l'espace défini par _w et _h en gardant les proportions de l'image)
    public static const NONE:String = "NONE";
    public static const FIT:String = "FIT";
    public static const FILL:String = "FILL";

    public function GIFLoader(zoom:String = NONE, w:uint = 0, h:uint = 0) {
        _zoom = zoom;
        _w = w;
        _h = h;
        _gif_player = new GIFPlayer();

        configureListeners(_gif_player);

        _preloader = new Sprite();
        _preloader.alpha = 0;

        _preloader_barre = new Sprite();
        _preloader_barre.graphics.beginFill(0xED316B, .9);
        _preloader_barre.graphics.drawRect(0, 0, _w, _h);
        _preloader_barre.graphics.endFill();
        _preloader_barre.width = 0;
        _preloader.addChild(_preloader_barre);

        _gif_player_added = false;
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

    private function ioErrorHandler(e:ErrorEvent):void {
    }

    private function httpStatusHandler(e:HTTPStatusEvent):void {
    }

    public function load(url:String):void {
        _gif_player.x = 0;
        _gif_player.y = 0;
        _gif_player.scaleX = 1;
        _gif_player.scaleY = 1;

        _fichier = url;
        _url_image = new URLRequest(url);
        _gif_player.load(_url_image);

        _preloader.alpha = 0;
        _preloader_barre.width = 0;
        addChild(_preloader);
        TweenLite.to(_preloader, Const.ANIM_DURATION, {alpha: 1, ease: Power2.easeOut});
    }

    public function unload():void {
        if (_gif_player_added) {
            Tools.safeRemoveChild(_container, _gif_player);
            _gif_player_added = false;
        }
    }

    private function progressHandler(e:ProgressEvent):void {
        var pourcent_charge:Number = Math.round(((e.bytesLoaded) * 100) / e.bytesTotal);
        var scalex:Number = pourcent_charge / 100;
        TweenLite.to(_preloader_barre, Const.ANIM_DURATION, {scaleX: scalex, ease: Power2.easeOut});
    }

    private function completeHandler(e:Event):void {
        var gif_frame_size:Rectangle = _gif_player.getFrameSize;
        _gifloader_w = gif_frame_size.width;
        _gifloader_h = gif_frame_size.height;

//        _gif_player.x = Math.round((_w - _gifloader_w) / 2);
//        _gif_player.y = Math.round((_h - _gifloader_h) / 2);

        setTimeout(loadEnd, 250);
    }

    private function loadEnd():void {
        imageLoaderScale(_zoom);
        addChild(_gif_player);

        TweenLite.to(_preloader, Const.ANIM_DURATION / 2, {alpha: 0, ease: Power2.easeIn});

        dispatchEvent(new Event(Event.COMPLETE));
        _gif_player_added = true;
    }

    public function imageLoaderScale(zoom:String):void {
        _zoom = zoom;

        var imgloader_finalw:uint = _gifloader_w;
        var imgloader_finalh:uint = _gifloader_h;
        var imgloader_finalscalex:Number = 1;
        var imgloader_finalscaley:Number = 1;
        var imgloader_finalx:int;
        var imgloader_finaly:int;
        var ratio:String = "portrait";

        if (zoom != NONE) {
            var fichier_ratio:Number = _gifloader_w / _gifloader_h;
            var loader_ratio:Number = _w / _h;

            switch (zoom) {
                case FIT :
                    if (fichier_ratio <= loader_ratio) {
                        imgloader_finalh = _h;
                        imgloader_finalscalex = imgloader_finalscaley = _h / _gifloader_h;
                        imgloader_finalw = _gifloader_w * imgloader_finalscalex;
                    } else {
                        imgloader_finalw = _w;
                        imgloader_finalscalex = imgloader_finalscaley = _w / _gifloader_w;
                        imgloader_finalh = _gifloader_h * imgloader_finalscaley;
                    }
                    break;
                case FILL :
                    if (fichier_ratio <= loader_ratio) {
                        ratio = "portrait";
                        imgloader_finalw = _w;
                        imgloader_finalscalex = imgloader_finalscaley = _w / _gifloader_w;
                        imgloader_finalh = _gifloader_h * imgloader_finalscaley;
                    } else {
                        ratio = "landscape";
                        imgloader_finalh = _h;
                        imgloader_finalscalex = imgloader_finalscaley = _h / _gifloader_h;
                        imgloader_finalw = _gifloader_w * imgloader_finalscalex;
                    }
                    break;
            }
            imgloader_finalx = Math.round((_w - imgloader_finalw) / 2);
            imgloader_finaly = Math.round((_h - imgloader_finalh) / 2);
        }
    }

    public function get fichier():String {
        return _fichier;
    }

    public function dispose():void {
        _gif_player.dispose();
    }
}
}