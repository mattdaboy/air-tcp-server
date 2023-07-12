package fr.opendo.medias {
import by.blooddy.crypto.image.JPEGEncoder;

import com.distriqt.extension.image.Image;
import com.distriqt.extension.image.ImageFormat;
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.ByteArray;
import flash.utils.setTimeout;

import fr.opendo.events.ImageResizeBoxEvent;
import fr.opendo.tools.ButtonEffect;
import fr.opendo.tools.Const;
import fr.opendo.tools.FitRectangle;
import fr.opendo.tools.Language;
import fr.opendo.tools.ScreenSize;
import fr.opendo.tools.SoundManager;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu 2018
 */
public class ImageResizeBox extends ImageResizeBoxView {
    private var _stage:Stage;
    private var _this:ImageResizeBox;
    private var _file:File;
    private var _image_loader:ImageLoader;
    private var _captured_bmpd:BitmapData;
    private var _image_container_background:Shape;
    private var _image_container:Sprite;
    private var _xstart:Number;
    private var _ystart:Number;
    private var _w_output:uint;
    private var _h_output:uint;
    private const SCALE_ANIM:Number = 1.1;
    private const WORK_AREA_W:uint = 1280;
    private const WORK_AREA_H:uint = 800;
    private const WORK_AREA_X:uint = 320;
    private const WORK_AREA_Y:uint = 200;

    public function ImageResizeBox(w_output:uint = 1920, h_output:uint = 1200, current_index:Number = 0, total_index:Number = 0) {
        _w_output = w_output;
        _h_output = h_output;

        _stage = Main.instance.getStage;
        _this = this;

        _this.alpha = 0;
        _this.y = -3000;

        $bt_ok.$label.text = Language.getValue("btn-enregistrer");
        $bt_ok.buttonMode = true;
        $bt_ok.mouseChildren = false;
        $bt_ok.addEventListener(MouseEvent.CLICK, save);

        $bt_cancel.$label.text = Language.getValue("annuler");
        $bt_cancel.buttonMode = true;
        $bt_cancel.mouseChildren = false;
        $bt_cancel.addEventListener(MouseEvent.CLICK, cancel);

        $btnClose.buttonMode = true;
        $btnClose.mouseChildren = false;
        $btnClose.addEventListener(MouseEvent.CLICK, cancel);

        $btnFitin.buttonMode = true;
        $btnFitin.mouseChildren = false;
        $btnFitin.addEventListener(MouseEvent.CLICK, fitin);

        $btnFill.buttonMode = true;
        $btnFill.mouseChildren = false;
        $btnFill.addEventListener(MouseEvent.CLICK, fill);

        _xstart = -((1920 * SCALE_ANIM) - 1920) / 2;
        _ystart = -((1200 * SCALE_ANIM) - 1200) / 2;


        $background.mouseChildren = false;
        _image_container = new Sprite();
        _this.addChild(_image_container);

        _this.addChild($titre);
        _this.addChild($bt_ok);
        _this.addChild($bt_cancel);
        _this.addChild($btnClose);
        _this.addChild($btnFitin);
        _this.addChild($btnFill);

        var image_container_finalw:uint;
        var image_container_finalh:uint;
        var image_container_finalscale:Number = 1;
        var image_container_finalx:uint;
        var image_container_finaly:uint;
        var image_container_ratio:Number = _w_output / _h_output;
        var work_area_ratio:Number = WORK_AREA_W / WORK_AREA_H;

        if (image_container_ratio <= work_area_ratio) {
            image_container_finalh = WORK_AREA_H;
            image_container_finalscale = WORK_AREA_H / _h_output;
            image_container_finalw = _w_output * image_container_finalscale;
        } else {
            image_container_finalw = WORK_AREA_W;
            image_container_finalscale = WORK_AREA_W / _w_output;
            image_container_finalh = _h_output * image_container_finalscale;
        }
        image_container_finalx = Math.round((WORK_AREA_W - image_container_finalw) / 2);
        image_container_finaly = Math.round((WORK_AREA_H - image_container_finalh) / 2);

        _image_container.x = WORK_AREA_X + image_container_finalx;
        _image_container.y = WORK_AREA_Y + image_container_finaly;
        _image_container.scaleX = _image_container.scaleY = image_container_finalscale;

        _image_container_background = new Shape();
        _image_container_background.graphics.beginFill(0xFFFFFF, 1);
        _image_container_background.graphics.drawRect(0, 0, _w_output, _h_output);
        _image_container_background.graphics.endFill();
        _image_container.addChild(_image_container_background);

        _image_loader = new ImageLoader(ImageLoader.FIT, _w_output, _h_output);
        _image_loader.setDragable(false);
        _image_container.addChild(_image_loader);

        if (total_index > 0) {
            var myFormat:TextFormat = new TextFormat();
            myFormat.size = 40;
            myFormat.font = "RobotoBold";
            myFormat.color = 0xFFFFFF;
            var txt:TextField = new TextField();
            txt.defaultTextFormat = myFormat;
            txt.text = String(current_index + 1) + "/" + total_index;
            txt.x = (1920 - txt.width) / 2;
            txt.y = ScreenSize.top + Const.TITRE_Y + 120;
            addChild(txt);
        }

        // Placement des éléments
        FitRectangle.McFillIn($background, ScreenSize.left, ScreenSize.top, ScreenSize.width, ScreenSize.height);
        $btnClose.x = ScreenSize.right + Const.RIGHT_BTN_X;
        $btnClose.y = ScreenSize.top + Const.RIGHT_BTN_Y;
        $titre.y = ScreenSize.top + Const.TITRE_Y;
        $picto.x = ScreenSize.left + Const.PICTO_X;
        $picto.y = ScreenSize.top + Const.PICTO_Y;
    }

    private function fitin(event:MouseEvent):void {
        ButtonEffect.bump(MovieClip(event.currentTarget));
        _image_loader.imageLoaderScale(ImageLoader.FIT);
        _image_loader.setDragable(false);
    }

    private function fill(event:MouseEvent):void {
        ButtonEffect.bump(MovieClip(event.currentTarget));
        _image_loader.imageLoaderScale(ImageLoader.FILL);
        _image_loader.setDragable(true);
    }

    public function openFile(file:File):void {
        SoundManager.playSound(SoundManager.MOVEMENT);

        $bt_ok.mouseEnabled = false;
        $bt_ok.alpha = .25;

        _file = file;

        _this.x = _xstart;
        _this.y = _ystart;
        _this.scaleX = _this.scaleY = SCALE_ANIM;

        TweenLite.to(_this, Const.ANIM_DURATION, {alpha: 1, x: 0, y: 0, scaleX: 1, scaleY: 1, ease: Power2.easeOut, onComplete: fileLoad});

        _stage.addChild(_this);
    }

    private function fileLoad():void {
        _image_loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
        _image_loader.load(_file.url);
    }

    private function loadCompleteHandler(event:Event):void {
        _image_loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
        $bt_ok.mouseEnabled = true;
        $bt_ok.alpha = 1;
    }

    private function save(event:MouseEvent):void {
        SoundManager.playSound(SoundManager.BTN_OK);

        $bt_ok.mouseEnabled = false;
        $bt_ok.alpha = .25;

        var matrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
        _captured_bmpd = new BitmapData(_w_output, _h_output);
        _captured_bmpd.draw(_image_container, matrix);

        var captured_bmp:Bitmap = new Bitmap(_captured_bmpd);

        var temp:Sprite = new Sprite();
        temp.addChild(captured_bmp);

        var resized_bmpd:BitmapData = new BitmapData(captured_bmp.width, captured_bmp.height);
        resized_bmpd.draw(temp, matrix);

        var encodedData:ByteArray = new ByteArray();
        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) Image.service.encode(resized_bmpd, encodedData, ImageFormat.JPG, Const.MOBILE_JPEG_QUALITY);
        if (Tools.OS.type == Const.MACOS || Tools.OS.type == Const.WIN) encodedData = JPEGEncoder.encode(resized_bmpd, Const.DESKTOP_JPEG_QUALITY);

        dispatchEvent(new ImageResizeBoxEvent(ImageResizeBoxEvent.COMPLETE, encodedData));

        setTimeout(hide, 250);
    }

    private function cancel(event:MouseEvent):void {
        SoundManager.playSound(SoundManager.BTN_CANCEL);
        hide();
    }

    private function hide():void {
        var posx:Number = -((1920 * SCALE_ANIM) - 1920) / 2;
        var posy:Number = -((1200 * SCALE_ANIM) - 1200) / 2;
        TweenLite.to(this, Const.ANIM_DURATION, {
            scaleX: SCALE_ANIM,
            scaleY: SCALE_ANIM,
            alpha: 0,
            x: posx,
            y: posy,
            ease: Power2.easeOut,
            onComplete: remove
        });
    }

    private function remove():void {
        Tools.safeRemoveChild(_stage, _this);
        _image_loader.unload();
    }
}
}