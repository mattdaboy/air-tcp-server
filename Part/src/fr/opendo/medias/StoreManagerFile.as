package fr.opendo.medias {
import events.CustomEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import fr.opendo.database.DataManager;
import fr.opendo.socket.SocketConnexionStatus;
import fr.opendo.socket.SocketManagerConst;
import fr.opendo.tools.Const;
import fr.opendo.tools.Tools;

/**
 * @author Matt 2017 - Last modified 2022-12-06
 */
public class StoreManagerFile extends EventDispatcher {

    public function StoreManagerFile() {
    }

    public function manageFile(file_name:String, served_url:String = ""):void {
        var file_url:String;
        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL) {
            file_url = "http://" + DataManager.infosConnexion + ":" + SocketManagerConst.HTTP_SERVER_PORT + "/" + unescape(file_name);
        } else {
            file_url = served_url;
        }

        if (!isFileAlreadyExist(file_name)) {
            downloadAndSaveFile(file_url);
        } else {
            var file:File = File.applicationStorageDirectory.resolvePath(Const.HTDOCS_DIR + File.separator + file_name);
            dispatchComplete(file);
        }
    }

    private function isFileAlreadyExist(file_url:String):Boolean {
        var file_name:String = Tools.getFilenameFromUrl(file_url);
        var exist:Boolean = false;
        var file:File = File.applicationStorageDirectory.resolvePath(Const.HTDOCS_DIR + File.separator + file_name);
        if (file.exists) exist = true;
        return exist;
    }

    private function downloadAndSaveFile(url:String):void {
        var urlLoader:URLLoader = new URLLoader();
        urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        urlLoader.addEventListener(Event.COMPLETE, onCompleteHandler);
        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
        urlLoader.load(new URLRequest(url));

        function ioErrorHandler(event:IOErrorEvent):void {
            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        function progressHandler(event:ProgressEvent):void {
            var pourcent:Number = event.bytesLoaded / event.bytesTotal;
        }

        function onCompleteHandler(e:Event):void {
            urlLoader.removeEventListener(Event.COMPLETE, onCompleteHandler);
            urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            var data:ByteArray = e.target.data;
            var fileStream:FileStream = new FileStream();
            fileStream.addEventListener(Event.CLOSE, onCompleteSave);
            var file_name:String = Tools.getFilenameFromUrl(url);
            var file:File = File.applicationStorageDirectory.resolvePath(Const.HTDOCS_DIR + File.separator + file_name);
            fileStream.openAsync(file, FileMode.WRITE);
            fileStream.writeBytes(data);
            fileStream.close();

            function onCompleteSave(event:Event):void {
                fileStream.removeEventListener(Event.CLOSE, onCompleteSave);
                dispatchComplete(file);
            }
        }
    }

    private function dispatchComplete(file:File):void {
        dispatchEvent(new CustomEvent(CustomEvent.COMPLETED, [file]));
    }
}
}