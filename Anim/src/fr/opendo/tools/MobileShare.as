package fr.opendo.tools {
import by.blooddy.crypto.image.JPEGEncoder;

import com.distriqt.extension.image.Image;
import com.distriqt.extension.image.ImageFormat;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

/**
 * @author matthieu
 */
public class MobileShare extends EventDispatcher {
    private static var _instance:MobileShare;
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    public static const CSV:String = "CSV";
    public static const BYTE_ARRAY:String = "BYTE_ARRAY";
    public static const BITMAP_DATA:String = "BITMAP_DATA";

    public function MobileShare() {
        super();
    }

    public static function share(content:*, content_type:String = MobileShare.CSV, fileName:String = ""):void {
        var encodedData:ByteArray = new ByteArray();
        switch (content_type) {
            case MobileShare.CSV:
                encodedData = Tools.convertStringToUTF8(content);
                if (fileName == "") fileName = Math.floor(Math.random() * 9999999) + ".csv";
                break;
            case MobileShare.BYTE_ARRAY:
                encodedData = content;
                if (fileName == "") fileName = Math.floor(Math.random() * 9999999) + ".jpg";
                break;
            case MobileShare.BITMAP_DATA:
                var bmpd:BitmapData = content as BitmapData;
                if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) Image.service.encode(bmpd, encodedData, ImageFormat.JPG, Const.MOBILE_JPEG_QUALITY);
                if (Tools.OS.type == Const.MACOS || Tools.OS.type == Const.WIN) encodedData = JPEGEncoder.encode(bmpd, Const.DESKTOP_JPEG_QUALITY);
                if (fileName == "") fileName = Math.floor(Math.random() * 9999999) + ".jpg";
                break;
        }
        var file:File = File.applicationStorageDirectory.resolvePath(Const.ASSETS_DIR + File.separator + fileName);
        var fileStream:FileStream = new FileStream;
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeBytes(encodedData);
        fileStream.close();

        DataShare.init();
        DataShare.dispatcher.addEventListener(Event.COMPLETE, completeHandler);

        switch (content_type) {
            case MobileShare.CSV:
                DataShare.fileShareByName(fileName, "text/csv");
                break;
            case MobileShare.BYTE_ARRAY:
            case MobileShare.BITMAP_DATA:
                DataShare.fileShareByName(fileName, "image/jpg");
                break;
        }

        function completeHandler(event:Event):void {
            _dispatcher.dispatchEvent(new Event(Event.COMPLETE));
        }
    }

    public static function get instance():MobileShare {
        if (_instance == null) {
            _instance = new MobileShare();
        }
        return _instance;
    }


    public static function get dispatcher():EventDispatcher {
        return _dispatcher;
    }
}
}