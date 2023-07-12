package fr.opendo.medias {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filesystem.File;

import fr.opendo.data.DataManager;
import fr.opendo.events.CustomEvent;
import fr.opendo.events.StoreEvent;
import fr.opendo.data.StoreLocalFilesToCLoud;
import fr.opendo.tools.Tools;

/**
 * @author Matt - update 2022-05-05
 */

public class ImageHandlerSimple extends Sprite {
    private var _image_node:XML;
    private var _container:Sprite;
    private var _img_loader:ImageLoader;
    private var _bt_delete:BtnDeleteMiniView;

    public function ImageHandlerSimple(image_node:XML) {
        _image_node = image_node;

        _container = new Sprite();
        _container.buttonMode = true;
        _container.mouseChildren = false;
        _container.addEventListener(MouseEvent.CLICK, pickImageHandler);
        addChild(_container);

        var background:Sprite = new Sprite();
        background.graphics.beginFill(0xFFFFFF);
        background.graphics.drawRoundRect(0, 0, 240, 150, 20);
        background.graphics.endFill();
        _container.addChild(background);

        var picto_image:BtnImageView = new BtnImageView();
        picto_image.x = (240 - picto_image.width) / 2;
        picto_image.y = (150 - picto_image.height) / 2;
        _container.addChild(picto_image);

        _bt_delete = new BtnDeleteMiniView();
        _bt_delete.width = 40;
        _bt_delete.height = 40;
        _bt_delete.x = 240 - _bt_delete.width;
        _bt_delete.y = 150 - _bt_delete.height;
        _bt_delete.visible = false;
        _bt_delete.buttonMode = true;
        _bt_delete.mouseChildren = false;
        _bt_delete.addEventListener(MouseEvent.CLICK, onDelete);

        _img_loader = new ImageLoader(ImageLoader.FILL, 240, 150, 20);
        _container.addChild(_img_loader);
        if (_image_node.toString() != "") {
            var file:File = Tools.getFileFromFilename(_image_node);
            if (file.exists) showImage(file);
        }

        addChild(_bt_delete);
    }

    private function pickImageHandler(event:MouseEvent):void {
        var image_picker:ImagePickResizeStore = new ImagePickResizeStore(960, 600);
        image_picker.addEventListener(StoreEvent.COMPLETE, imagePickerCompleteHandler);
        image_picker.browseForOpen();
    }

    private function imagePickerCompleteHandler(event:StoreEvent):void {
        var image_picker:ImagePickResizeStore = event.currentTarget as ImagePickResizeStore;
        image_picker.removeEventListener(StoreEvent.COMPLETE, imagePickerCompleteHandler);
        var file:File = event.file;
        showImage(file);
        saveImageInXML(file);
    }

    public function showImage(file:File):void {
        _img_loader.unload();
        _img_loader.load(file.url);
        _bt_delete.visible = true;
        addChild(_bt_delete);
    }

    private function saveImageInXML(file:File):void {
        _image_node.setChildren(file.name);
        DataManager.setSessionModules();

        StoreLocalFilesToCLoud.dispatcher.addEventListener(CustomEvent.FILE_UPLOADED, fileUploadedHandler);
        StoreLocalFilesToCLoud.uploadFile(file, _image_node);

        function fileUploadedHandler(event:CustomEvent):void {
            StoreLocalFilesToCLoud.dispatcher.removeEventListener(CustomEvent.FILE_UPLOADED, fileUploadedHandler);
            DataManager.setSessionModules();
        }
    }

    private function onDelete(event:MouseEvent):void {
        _bt_delete.visible = false;
        _img_loader.unload();
        _image_node.setChildren("");
        if (Tools.isNodeExists(_image_node.parent(), "served_url")) _image_node.parent().served_url.setChildren("");
        DataManager.setSessionModules();
    }
}
}