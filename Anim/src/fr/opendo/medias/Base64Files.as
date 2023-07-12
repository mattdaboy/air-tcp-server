package fr.opendo.medias {
import by.blooddy.crypto.Base64;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import fr.opendo.tools.Tools;

/**
 * @author Matt - update 2022-04-08
 */
public class Base64Files extends Object {

    public function Base64Files() {
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

    public static function FilePathToByteArray(path:String):ByteArray {
        var file:File;
        file = File.applicationStorageDirectory.resolvePath(path);

        if (file.exists && !file.isDirectory) {
            var file_stream:FileStream = new FileStream();
            file_stream.open(file, FileMode.READ);
            var bytes:ByteArray = new ByteArray();
            file_stream.readBytes(bytes);
            file_stream.close();
            return bytes;
        } else {
            return null;
        }
    }

    public static function FileToByteArray(file:File):ByteArray {
        var file_stream:FileStream = new FileStream();
        file_stream.open(file, FileMode.READ);
        var bytes:ByteArray = new ByteArray();
        file_stream.readBytes(bytes);
        file_stream.close();
        return bytes;
    }

    public static function FileSize(path:String):uint {
        var file:File;
        file = File.applicationStorageDirectory.resolvePath(path);

        if (file.exists && !file.isDirectory) {
            var file_stream:FileStream = new FileStream();
            file_stream.open(file, FileMode.READ);
            var bytes:ByteArray = new ByteArray();
            file_stream.readBytes(bytes);
            file_stream.close();
            return bytes.length;
        } else {
            return 0;
        }
    }

    public static function Base64ToFile(str:String, file_name:String):void {
        str = Tools.replaceString(str, "data:image/jpeg;base64,", "");
        str = Tools.replaceString(str, "data:image/png;base64,", "");
        var base64_decoded_string:ByteArray = Base64.decode(str);
        var destination_file:File = File.applicationStorageDirectory.resolvePath(file_name);
        var file_stream:FileStream = new FileStream();
        file_stream.open(destination_file, FileMode.WRITE);
        file_stream.writeBytes(base64_decoded_string);
        file_stream.close();
    }

    public static function transformFilesToBase64(xml:XML):XML {
        var list:XMLList;
        var node:XML;
        var str:String;

        list = Tools.getNodeListByName(xml, "file_name");
        for each (node in list) {
            if (node.toString().length > 0 && !Tools.isNodeExists(node.parent(), "served_url")) {
                var file:File = Tools.getFileFromFilename(node.toString());
                str = Base64Files.FileToBase64(file);
                node.parent().appendChild(<base64>{str}</base64>);
            }
        }

        return xml;
    }
}
}