package fr.opendo.medias {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;
import flash.utils.ByteArray;

import fr.opendo.events.ImageResizeBoxEvent;
import fr.opendo.events.MobileImagePickerEvent;
import fr.opendo.events.StoreEvent;
import fr.opendo.tools.Const;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu 2018
 */
public class ImagePickResizeStore extends Sprite {
    private var _mobile_image_picker:MobileImagePicker2;
    private var _desktop_image:File;
    private var _w_output:uint;
    private var _h_output:uint;

    public function ImagePickResizeStore(w_output:uint = 1920, h_output:uint = 1200) {
        _w_output = w_output;
        _h_output = h_output;
    }

    public function browseForOpen():void {
        _desktop_image = new File();

        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) {
            _mobile_image_picker = new MobileImagePicker2();
            _mobile_image_picker.addEventListener(MobileImagePickerEvent.IMAGE_BYTES, mobileImageBytesHandler);
            _mobile_image_picker.browseForOpen();
        } else {
            var file_filter:FileFilter = new FileFilter("Images", "*.jpg;*.jpeg;*.png;*.webp;");
            _desktop_image.addEventListener(Event.SELECT, desktopFileSelectHandler);
            _desktop_image.addEventListener(IOErrorEvent.IO_ERROR, desktopErrorHandler);
            _desktop_image.browseForOpen("Open", [file_filter]);
        }
    }

    // Mobile
    private function mobileImageBytesHandler(event:MobileImagePickerEvent):void {
        _mobile_image_picker.removeEventListener(MobileImagePickerEvent.IMAGE_BYTES, mobileImageBytesHandler);

        // Copie de l'image dans applicationStorageDirectory
        var file_name:String = Tools.addOTimestampTo("mobile_image.png");
        var destination_file:File = Tools.getFileFromFilename(file_name);
        var file_stream:FileStream = new FileStream;
        file_stream.addEventListener(Event.CLOSE, copyCompleteHandler);
        file_stream.open(destination_file, FileMode.WRITE);
        file_stream.writeBytes(event.imageBytes);
        file_stream.close();

        function copyCompleteHandler(event:Event):void {
            file_stream.removeEventListener(Event.CLOSE, copyCompleteHandler);
            resizeImage(destination_file);
        }
    }

    // Desktop
    private function desktopFileSelectHandler(event:Event):void {
        _desktop_image.removeEventListener(Event.SELECT, desktopFileSelectHandler);
        resizeImage(_desktop_image);
    }

    // Redimensionnement de l'image copiée
    private function resizeImage(file:File):void {
        var image_resize_box:ImageResizeBox = new ImageResizeBox(_w_output, _h_output);
        image_resize_box.addEventListener(ImageResizeBoxEvent.COMPLETE, ImageResizeBoxCompleteHandler);
        image_resize_box.openFile(file);

        function ImageResizeBoxCompleteHandler(event:ImageResizeBoxEvent):void {
            image_resize_box.removeEventListener(ImageResizeBoxEvent.COMPLETE, ImageResizeBoxCompleteHandler);

            // Enregistrement de l'image redimensionnée dans applicationStorageDirectory
            var by:ByteArray = event.byteArray;
            var file_name:String = file.name;
//            file_name = Tools.cleanSpecialChars(file_name);
            file_name = Tools.addOTimestampTo(file_name);
            var destination_file:File = Tools.getFileFromFilename(file_name);
            var file_stream:FileStream = new FileStream;
            file_stream.addEventListener(Event.CLOSE, closeStreamHandler);
            file_stream.openAsync(destination_file, FileMode.WRITE);
            file_stream.writeBytes(by);
            file_stream.close();

            function closeStreamHandler(event:Event):void {
                file_stream.removeEventListener(Event.CLOSE, closeStreamHandler);
                dispatchComplete(destination_file);
            }
        }
    }

    // Dispatch du COMPLETE avec le fichier dans l'event
    private function dispatchComplete(file:File):void {
        dispatchEvent(new StoreEvent(StoreEvent.COMPLETE, file));
    }

    private function desktopErrorHandler(event:IOErrorEvent):void {
    }
}
}