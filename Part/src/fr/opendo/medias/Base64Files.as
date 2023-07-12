package fr.opendo.medias {
import by.blooddy.crypto.Base64;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import fr.opendo.tools.Tools;

/**
 * @author Matthieu 2017
 * Cette classe ne doit être utilisée que dans le cas où le StageScaleMode final est SHOW_ALL
 */
public class Base64Files extends EventDispatcher {
    private static var _this:Base64Files;

    public function Base64Files() {
        _this = this;
    }

    public static function FileToBase64(file:File):String {
        if (file.exists && !file.isDirectory) {
            var file_stream:FileStream = new FileStream();
            file_stream.open(file, FileMode.READ);
            var bytes:ByteArray = new ByteArray();
            file_stream.readBytes(bytes);
            file_stream.close();

            var base64_encoded_file:String = Base64.encode(bytes);

            return base64_encoded_file;
        } else {
            return "";
        }
    }

    public static function Base64ToFile(base64_str:String, folder:String, file_name:String):void {
        var base64_decoded_string:ByteArray = Base64.decode(base64_str);
        var file_stream:FileStream = new FileStream();
        var targetFile:File;
        file_name = Tools.cleanStringForGoodFileName(file_name);
        targetFile = File.applicationStorageDirectory.resolvePath(folder + File.separator + file_name);

        file_stream.addEventListener(Event.CLOSE, closeHandler);

        file_stream.open(targetFile, FileMode.WRITE);
        file_stream.writeBytes(base64_decoded_string);
        file_stream.close();
    }

    private static function closeHandler(event:Event):void {
        var file_stream:FileStream = FileStream(event.currentTarget);
        file_stream.removeEventListener(Event.CLOSE, closeHandler);
        _this.dispatchEvent(new Event(Event.COMPLETE));
    }
}
}