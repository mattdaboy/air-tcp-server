package fr.opendo.medias {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;

import fr.opendo.events.StoreEvent;

/**
 * @author matthieu
 */
public class CardImageHandler extends Sprite {
    private var _w_thumb:uint;
    private var _h_thumb:uint;
    private var _w_output:uint;
    private var _h_output:uint;
    private var _file:File;
    private var _img_loader:ImageLoader;
    private var _clickable:Boolean;

    public function CardImageHandler(w_thumb:uint = 320, h_thumb:uint = 200, w_output:uint = 1920, h_output:uint = 1200, clickable:Boolean = true) {
        _w_thumb = w_thumb;
        _h_thumb = h_thumb;
        _w_output = w_output;
        _h_output = h_output;
        _clickable = clickable;
        init();
    }

    private function init():void {
        // Fond
        var background:Sprite = new Sprite();
        background.graphics.beginFill(0xFFFFFF);
        background.graphics.drawRoundRect(0, 0, _w_thumb, _h_thumb, 40);
        background.graphics.endFill();
        addChild(background);

        // Picto photo
        var picto_photo:BtPhotoView = new BtPhotoView();
        picto_photo.x = _w_thumb / 2 - picto_photo.width / 2;
        picto_photo.y = _h_thumb / 2 - picto_photo.height / 2;
        addChild(picto_photo);

        // Image Loader
        _img_loader = new ImageLoader(ImageLoader.FILL, _w_thumb, _h_thumb, 40);
        _img_loader.addEventListener(Event.COMPLETE, imageLoadCompleteHandler);
        addChild(_img_loader);

        // clickable
        if (_clickable) {
            var bt_new_image:Sprite = new Sprite();
            bt_new_image.graphics.beginFill(0xFFFFFF, 0);
            bt_new_image.graphics.drawRoundRect(0, 0, _w_thumb, _h_thumb, 40);
            bt_new_image.graphics.endFill();
            addChild(bt_new_image);

            bt_new_image.buttonMode = true;
            bt_new_image.addEventListener(MouseEvent.CLICK, onBtnImgClick);
        }
    }

    private function onBtnImgClick(event:MouseEvent):void {
        var image_picker:ImagePickResizeStore = new ImagePickResizeStore(_w_output, _h_output);
        image_picker.addEventListener(StoreEvent.COMPLETE, imagePickerCompleteHandler);
        image_picker.browseForOpen();
    }

    private function imagePickerCompleteHandler(event:StoreEvent):void {
        var image_picker:ImagePickResizeStore = event.currentTarget as ImagePickResizeStore;
        image_picker.removeEventListener(StoreEvent.COMPLETE, imagePickerCompleteHandler);
        _file = event.file;
        showImage(_file);
        dispatchEvent(new StoreEvent(StoreEvent.COMPLETE, _file));
    }

    public function showImage(file:File):void {
        _file = file;
        _img_loader.unload();
        _img_loader.load(_file.url);
    }

    public function resetImage():void {
        _img_loader.unload();
    }

    public function get file():File {
        return _file;
    }

    private function imageLoadCompleteHandler(event:Event):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}