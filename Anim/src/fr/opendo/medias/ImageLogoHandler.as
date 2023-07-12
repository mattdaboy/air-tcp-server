package fr.opendo.medias {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import fr.opendo.data.DataManager;
import fr.opendo.events.CustomEvent;
import fr.opendo.tools.CustomMask;
import fr.opendo.data.StoreLocalFilesToCLoud;
import fr.opendo.tools.Tools;

/**
 * @author matthieu
 */
public class ImageLogoHandler extends ImageHandlerView {
    private var _image_node:XML;
    private var _save_function:Function;
    private var _bt_default_visible:Boolean = true;
    private var _image_picker:ImagePicker;
    private var _image:ImageLoader;
    private var _img_bytes:ByteArray;

    public function ImageLogoHandler() {
        init();
    }

    private function init():void {
        $btnInsererImage.buttonMode = $btImage.buttonMode = true;
        $btnInsererImage.mouseChildren = $btImage.mouseChildren = false;
        $btImage.addEventListener(MouseEvent.CLICK, btNewImageHandler);
        CustomMask.setMask($btImage, $btImage.x, $btImage.y, $btImage.width, $btImage.height, 20);

        $btDefaultImage.buttonMode = true;
        $btDefaultImage.mouseChildren = false;
        $btDefaultImage.addEventListener(MouseEvent.CLICK, btDefaultImageHandler);
        $btDefaultImage.visible = _bt_default_visible;
    }

    public function setContent(image_node:XML, save_function:Function, bt_default_visible:Boolean = true):void {
        _image_node = image_node;
        _save_function = save_function;
        _bt_default_visible = bt_default_visible;

        if (_image == null) {
            _image = new ImageLoader(ImageLoader.FIT, $btImage.width, $btImage.height, 20);
            addChild(_image);
        }

        var file_name:String = _image_node.toString();
        var file:File = Tools.getFileFromFilename(file_name);
        if (file_name != "" && file.exists) showImage(file);
    }

    private function btNewImageHandler(event:Event):void {
        _image_picker = new ImagePicker();
        _image_picker.addEventListener(CustomEvent.DESKTOP_IMAGE_PICK_COMPLETE, desktopImagePickerCompleteHandler);
        _image_picker.addEventListener(CustomEvent.MOBILE_IMAGE_PICK_COMPLETE, mobileImagePickerCompleteHandler);
        _image_picker.browseForOpen();
    }

    private function desktopImagePickerCompleteHandler(event:CustomEvent):void {
        _image_picker.removeEventListener(CustomEvent.DESKTOP_IMAGE_PICK_COMPLETE, desktopImagePickerCompleteHandler);

        // Copie de l'image dans applicationStorageDirectory
        var file:File = event.data[2];
        var file_name:String = event.data[0];
//        file_name = Tools.cleanSpecialChars(file_name);
        file_name = Tools.addOTimestampTo(file_name);
        var destination_file:File = Tools.getFileFromFilename(file_name);

        file.addEventListener(Event.COMPLETE, copyCompleteHandler);
        file.copyToAsync(destination_file, true);

        function copyCompleteHandler(event:Event):void {
            file.removeEventListener(Event.COMPLETE, copyCompleteHandler);
            _image_node.setChildren(file_name);
            saveImg(file);
        }
    }

    private function mobileImagePickerCompleteHandler(event:CustomEvent):void {
        _image_picker.removeEventListener(CustomEvent.MOBILE_IMAGE_PICK_COMPLETE, mobileImagePickerCompleteHandler);

        // Copie de l'image dans applicationStorageDirectory
        var file_name:String = "mobile_image_" + Tools.randomStringNumber(12) + ".png";
        var destination_file:File = Tools.getFileFromFilename(file_name);
        var file_stream:FileStream = new FileStream;
        file_stream.addEventListener(Event.CLOSE, copyCompleteHandler);
        file_stream.open(destination_file, FileMode.WRITE);
        file_stream.writeBytes(event.data[0]);
        file_stream.close();

        function copyCompleteHandler(event:Event):void {
            file_stream.removeEventListener(Event.CLOSE, copyCompleteHandler);
            saveImg(destination_file);
            _image_node.file_name = file_name;
        }
    }

    private function saveImg(file:File):void {
        cleanImg();
        showImage(file);
        StoreLocalFilesToCLoud.dispatcher.addEventListener(CustomEvent.FILE_UPLOADED, fileUploadedHandler);
        StoreLocalFilesToCLoud.uploadFile(file, _image_node);

        function fileUploadedHandler(event:CustomEvent):void {
            StoreLocalFilesToCLoud.dispatcher.removeEventListener(CustomEvent.FILE_UPLOADED, fileUploadedHandler);
            DataManager.setParameters();
            _save_function.apply();
        }
    }

    private function showImage(file:File):void {
        _image.unload();
        _image.x = $btImage.x;
        _image.y = $btImage.y;
        _image.addEventListener(Event.COMPLETE, completeHandler);
        _image.load(file.url);

        function completeHandler(event:Event):void {
            _image.removeEventListener(Event.COMPLETE, completeHandler);
            $btImage.alpha = 0;
            addChild($btImage);
            addChild($btDefaultImage);
        }
    }

    private function btDefaultImageHandler(event:MouseEvent):void {
        _image_node.setChildren("");
        if (Tools.isNodeExists(_image_node.parent(), "served_url")) _image_node.parent().served_url.setChildren("");
        DataManager.setParameters();
        _save_function.apply();
        cleanImg();
    }

    private function cleanImg():void {
        if (_image.stage) {
            _image.unload();
            $btImage.alpha = 1;
        }
    }

    public function get img_bytes():ByteArray {
        return _img_bytes;
    }
}
}