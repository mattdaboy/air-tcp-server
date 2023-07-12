package fr.opendo.medias {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;

import fr.opendo.events.MobileImagePickerEvent;
import fr.opendo.events.StoreEvent;
import fr.opendo.tools.Const;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu 2018
 */
public class ImageStore extends Sprite {
    private var _folder_name:String;
    private var _image_picker:MobileImagePicker;
    private var _source_file:File;
    private var _destination_file:File;
    private var _file_filter:FileFilter;
    private var _file_stream:FileStream;

    public function ImageStore(folder:String = "htdocs/") {
        _folder_name = folder;
        pick();
    }

    private function pick():void {
        _source_file = new File();
        _destination_file = new File();

        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) {
            _image_picker = new MobileImagePicker();
            _image_picker.addEventListener(MobileImagePickerEvent.IMAGE_BYTES, mobileImageBytesHandler);
            _image_picker.addEventListener(MobileImagePickerEvent.BROWSE_CANCEL, mobileBrowseCancelHandler);
        } else {
            _file_filter = new FileFilter("Images", "*.jpg;*.jpeg;*.png;*.webp;");
            _source_file.browseForOpen("Open", [_file_filter]);
            _source_file.addEventListener(Event.SELECT, desktopFileSelectHandler);
            _source_file.addEventListener(Event.CANCEL, desktopBrowseCancelHandler);
            _source_file.addEventListener(IOErrorEvent.IO_ERROR, desktopErrorHandler);
        }
    }

    private function mobileImageBytesHandler(event:MobileImagePickerEvent):void {
        var file_name:String = "mobileimage" + Const.FILENAME_SUFFIXE_SEPARATOR + new Date().time + ".jpg";
        _destination_file = File.applicationStorageDirectory.resolvePath(_folder_name + file_name);

        _file_stream = new FileStream;
        _file_stream.addEventListener(Event.CLOSE, copyCompleteHandler);
        _file_stream.openAsync(_destination_file, FileMode.WRITE);
        _file_stream.writeBytes(event.imageBytes);
        _file_stream.close();

        function copyCompleteHandler(event:Event):void {
            _file_stream.removeEventListener(Event.CLOSE, copyCompleteHandler);
            dispatchFileDatas(_destination_file);
        }
    }

    private function desktopFileSelectHandler(evt:Event):void {
        // Copie de l'image dans applicationStorageDirectory
        var file_name:String = _source_file.name;
//			file_name = Tools.cleanSpecialChars(file_name);
        file_name = Tools.addOTimestampTo(file_name);
        _destination_file = File.applicationStorageDirectory.resolvePath(_folder_name + file_name);
        _source_file.copyToAsync(_destination_file, true);
        _source_file.addEventListener(Event.COMPLETE, copyCompleteHandler);

        function copyCompleteHandler(event:Event):void {
            _source_file.removeEventListener(Event.COMPLETE, copyCompleteHandler);
            dispatchFileDatas(_destination_file);
        }
    }

    private function dispatchFileDatas(file:File):void {
        // Dispatch du nom du fichier et du path complet du fichier (en fait, le fichier lui-même)
        dispatchEvent(new StoreEvent(StoreEvent.COMPLETE, file));
    }

    private function mobileBrowseCancelHandler(event:MobileImagePickerEvent):void {
    }

    private function desktopErrorHandler(event:IOErrorEvent):void {
    }

    private function desktopBrowseCancelHandler(event:Event):void {
    }
}
}