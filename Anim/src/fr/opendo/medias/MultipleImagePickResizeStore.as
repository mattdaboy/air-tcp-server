package fr.opendo.medias {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.utils.ByteArray;

import fr.opendo.events.ImageResizeBoxEvent;
import fr.opendo.events.MobileImagePickerEvent;
import fr.opendo.events.MultipleStoreEvent;
import fr.opendo.tools.Const;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu 2018
 */
public class MultipleImagePickResizeStore extends Sprite {
    private var _mobile_image_picker:MobileImagePicker2;
    private var _filereference_list:FileReferenceList;
    private var _tab_files:Vector.<File>;
    private var _w_output:uint;
    private var _h_output:uint;

    public function MultipleImagePickResizeStore(w_output:uint = 1920, h_output:uint = 1200) {
        _w_output = w_output;
        _h_output = h_output;
    }

    public function browseForOpen():void {
        _tab_files = new Vector.<File>();
        _filereference_list = new FileReferenceList();
        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) {
            _mobile_image_picker = new MobileImagePicker2();
            _mobile_image_picker.addEventListener(MobileImagePickerEvent.IMAGE_BYTES, mobileImageBytesHandler);
            _mobile_image_picker.browseForOpen();
        } else {
            var file_filter:FileFilter = new FileFilter("Images", "*.jpg;*.jpeg;*.png;*.webp;");
            _filereference_list.addEventListener(Event.SELECT, desktopFileSelectHandler);
            _filereference_list.addEventListener(IOErrorEvent.IO_ERROR, desktopErrorHandler);
            _filereference_list.browse([file_filter]);
        }
    }

    // Mobile
    private function mobileImageBytesHandler(event:MobileImagePickerEvent):void {
        _mobile_image_picker.removeEventListener(MobileImagePickerEvent.IMAGE_BYTES, mobileImageBytesHandler);

        // Copie de l'image dans applicationStorageDirectory
        var file_name:String = "mobile_image_" + Tools.randomStringNumber(12) + ".png";
        var destination_file:File = Tools.getFileFromFilename(file_name);
        var file_stream:FileStream = new FileStream;
        file_stream.addEventListener(Event.CLOSE, copyCompleteHandler);
        file_stream.open(destination_file, FileMode.WRITE);
        file_stream.writeBytes(event.imageBytes);
        file_stream.close();

        function copyCompleteHandler(event:Event):void {
            file_stream.removeEventListener(Event.CLOSE, copyCompleteHandler);
            resizeImage(destination_file, 0);
        }
    }

    // Desktop
    private function desktopFileSelectHandler(event:Event):void {
        _filereference_list.removeEventListener(Event.SELECT, desktopFileSelectHandler);
        writeFile(0);
    }

    private function writeFile(index:Number):void {
        var fileRef:FileReference = _filereference_list.fileList[index];
        fileRef.addEventListener(Event.COMPLETE, onLoadComplete);
        fileRef.load();

        function onLoadComplete(e:Event):void {
            fileRef.removeEventListener(Event.COMPLETE, onLoadComplete);
            var by:ByteArray = fileRef.data;
            var destination_file:File = Tools.getFileFromFilename(fileRef.name);

            var file_stream:FileStream = new FileStream;
            file_stream.addEventListener(Event.CLOSE, copyCompleteHandler);
            file_stream.openAsync(destination_file, FileMode.WRITE);
            file_stream.writeBytes(by);
            file_stream.close();

            function copyCompleteHandler(event:Event):void {
                file_stream.removeEventListener(Event.CLOSE, copyCompleteHandler);
                resizeImage(destination_file, index);
            }
        }
    }

    // Redimensionnement de l'image copiée
    private function resizeImage(file:File, index:Number):void {
        var image_resize_box:ImageResizeBox = new ImageResizeBox(_w_output, _h_output, index, _filereference_list.fileList.length);
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
            _tab_files.push(destination_file);

            var file_stream:FileStream = new FileStream;
            file_stream.addEventListener(Event.CLOSE, closeStreamHandler);
            file_stream.openAsync(destination_file, FileMode.WRITE);
            file_stream.writeBytes(by);
            file_stream.close();

            function closeStreamHandler(event:Event):void {
                file_stream.removeEventListener(Event.CLOSE, closeStreamHandler);
                var i:Number = index + 1;
                if (i < _filereference_list.fileList.length) {
                    writeFile(i);
                } else {
                    dispatchComplete();
                }
            }
        }
    }

    // Dispatch du COMPLETE avec les fichiers dans l'event
    private function dispatchComplete():void {
        dispatchEvent(new MultipleStoreEvent(MultipleStoreEvent.COMPLETE, _tab_files));
    }

    private function desktopErrorHandler(event:IOErrorEvent):void {
    }
}
}