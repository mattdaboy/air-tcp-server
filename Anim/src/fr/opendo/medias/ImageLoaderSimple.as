package fr.opendo.medias {
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.net.URLRequest;
import flash.system.LoaderContext;

import fr.opendo.tools.Tools;

/**
 * @author matt
 * version : 2.0
 */
public class ImageLoaderSimple extends MovieClip {
    private var _url_image:URLRequest;
    private var _preloader:Sprite;
    private var _preloader_fond:Sprite;
    private var _preloader_barre:Sprite;
    private var _image_loader:Loader;
    private var _image_loader_added:Boolean;

    public function ImageHandlerSimple() {
        _image_loader = new Loader;
        configureListeners(_image_loader.contentLoaderInfo);

        _preloader = new Sprite();
        _preloader.alpha = 0;

        _preloader_fond = new Sprite();
        _preloader_fond.graphics.beginFill(0x8F93B5);
        _preloader_fond.graphics.drawRect(0, 0, 20, 8);
        _preloader_fond.graphics.endFill();
        _preloader_fond.alpha = .7;
        _preloader.addChild(_preloader_fond);

        _preloader_barre = new Sprite();
        _preloader_barre.graphics.beginFill(0xFFFFFF);
        _preloader_barre.graphics.drawRect(0, 0, 16, 4);
        _preloader_barre.graphics.endFill();
        _preloader_barre.x = 2;
        _preloader_barre.y = 2;
        _preloader_barre.width = 0;

        _preloader.x = 5;
        _preloader.y = 5;

        _preloader.addChild(_preloader_barre);

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

    private function ioErrorHandler(e:ErrorEvent):void {
        if (e is IOErrorEvent) {
            var no_file:File = Tools.getFileFromFilename("play-card.png");
            this.load(no_file.url);
        }
    }

    private function httpStatusHandler(e:HTTPStatusEvent):void {
    }

    public function load(url:String):void {
        _url_image = new URLRequest(url);

        var context:LoaderContext = new LoaderContext();
        context.checkPolicyFile = true;

        _image_loader.load(_url_image, context);

        addChild(_preloader);
    }

    private function completeHandler(e:Event):void {
        removeChild(_preloader);
        addChild(_image_loader);

        dispatchEvent(new Event(Event.COMPLETE));
        _image_loader_added = true;
    }

    private function progressHandler(e:ProgressEvent):void {
        var pourcent_charge:Number = Math.round(((e.bytesLoaded) * 100) / e.bytesTotal);
        _preloader_barre.scaleX = pourcent_charge / 100;
    }
}
}