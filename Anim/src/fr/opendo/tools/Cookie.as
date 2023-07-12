package fr.opendo.tools {
import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

/**
 * @author matthieu
 */
public class Cookie extends Sprite {
    private static var COOKIE_DIR:String = "assets";
    private static var COOKIE_NAME:String = "cookie.xml";
    private var _xml:XML;

    public function Cookie(ver:String) {
        if (!cookieExists) {
            writeVersion(ver);
        } else {
            read();
        }
    }

    private function read():void {
        var file:File = File.applicationStorageDirectory.resolvePath(COOKIE_DIR + File.separator + COOKIE_NAME);
        file.addEventListener(Event.COMPLETE, loaded);
        file.load();

        function loaded(event:Event):void {
            var bytes:ByteArray = file.data;
            _xml = XML(bytes.readUTFBytes(bytes.length));
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }

    private function writeVersion(version:String = "", date:String = ""):void {
        if (version == "") version = "0.0";
        if (date == "") date = String(new Date());
        _xml = <content>
            <version>{version}</version>
            <date>{date}</date>
        </content>;

        var ba:ByteArray = new ByteArray();
        ba.writeMultiByte(_xml, "iso-8859-1");

        var destination_file:File = File.applicationStorageDirectory.resolvePath(COOKIE_DIR + File.separator + COOKIE_NAME);
        var file_stream:FileStream = new FileStream;
        file_stream.addEventListener(Event.CLOSE, closeStreamHandler);
        file_stream.openAsync(destination_file, FileMode.WRITE);
        file_stream.writeBytes(ba);
        file_stream.close();

        function closeStreamHandler(event:Event):void {
            file_stream.removeEventListener(Event.CLOSE, closeStreamHandler);
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }

    private function get cookieExists():Boolean {
        var file:File = File.applicationStorageDirectory.resolvePath(COOKIE_DIR + File.separator + COOKIE_NAME);
        return file.exists;
    }

    public function get version():String {
        var ver:String = _xml.version;
        return ver;
    }

    public function get date():String {
        var date:String = _xml.date;
        return date;
    }

    public function set version(ver:String):void {
        var date:String = String(new Date());
        writeVersion(ver, date);
    }

//		public function addBackup() : void {
//			var date : String = String(new Date());
//			writeVersion(ver, date);
//		}
}
}