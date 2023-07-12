package fr.opendo.socket {
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.OutputProgressEvent;
import flash.events.ProgressEvent;
import flash.events.ServerSocketConnectEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.ServerSocket;
import flash.net.Socket;
import flash.utils.ByteArray;

import fr.opendo.events.CustomEvent;
import fr.opendo.tools.Const;
import fr.opendo.tools.Debug;

/**
 * @author matthieu
 */
public class FileServer extends EventDispatcher {
    private var _server_socket:ServerSocket;
    private var _port:uint;
    private var _mimeTypes:Object;

    private const LOG:Boolean = false;

    private function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function FileServer():void {
        log("FileServer");
        _port = SocketManagerConst.HTTP_SERVER_PORT;
        // The mime types supported by this mini web server
        _mimeTypes = {};
        _mimeTypes[".jpg"] = "image/jpeg";
        _mimeTypes[".jpeg"] = "image/jpeg";
        _mimeTypes[".png"] = "image/png";
        _mimeTypes[".pdf"] = "application/pdf";
        _mimeTypes[".ppt"] = "application/vnd.ms-powerpoint";
        _mimeTypes[".pptx"] = "application/vnd.ms-powerpoint";
        _mimeTypes[".xls"] = "application/vnd.ms-excel";
        _mimeTypes[".xlsx"] = "application/vnd.ms-excel";
        _mimeTypes[".doc"] = "application/msword";
        _mimeTypes[".docx"] = "application/msword";
        _mimeTypes[".zip"] = "application/zip";
        _mimeTypes[".mp4"] = "video/mp4";
    }

    public function start():void {
        listen();
    }

    private function listen():void {
        try {
            _server_socket = new ServerSocket();
            _server_socket.addEventListener(Event.CONNECT, socketConnectHandler);
            _server_socket.bind(_port);
            _server_socket.listen();
            dispatchComplete();
            log("Le serveur HTTP écoute sur le port : " + _port);
        } catch (error:Error) {
            dispatchError();
            log("Le port " + _port + " du serveur HTTP est utilisé.");
        }
    }

    private function dispatchError():void {
        // on dispatch sur SocketManager
        dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
    }

    private function dispatchComplete():void {
        // on dispatch sur SocketManager
        dispatchEvent(new CustomEvent(CustomEvent.FILE_SERVER_COMPLETE));
    }

    private function socketConnectHandler(event:ServerSocketConnectEvent):void {
        var socket:Socket = event.socket;
        socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
        socket.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, OutputProgressHandler);
        // on dispatch sur Manager
        dispatchEvent(new Event(Event.CONNECT));
    }

    private function OutputProgressHandler(event:OutputProgressEvent):void {
        var socket:Socket = event.target as Socket;
        if (socket.bytesPending == 0) {
            socket.flush();
            socket.close();
        }
    }

    private function socketDataHandler(event:ProgressEvent):void {
        try {
            var socket:Socket = event.target as Socket;
            var bytes:ByteArray = new ByteArray();
            socket.readBytes(bytes);
            var request:String = "" + bytes;
            var filePath:String = unescape(request.substring(4, request.indexOf("HTTP/") - 1));
            var file:File = File.applicationStorageDirectory.resolvePath(Const.HTDOCS_DIR + filePath);
            if (file.exists && !file.isDirectory) {
                var stream:FileStream = new FileStream();
                stream.open(file, FileMode.READ);
                var content:ByteArray = new ByteArray();
                stream.readBytes(content);
                stream.close();
                socket.writeUTFBytes("HTTP/1.1 200 OK\n");
                socket.writeUTFBytes("Content-Type: " + getMimeType(filePath) + "\n\n");
                socket.writeBytes(content);
            } else {
                socket.writeUTFBytes("HTTP/1.1 404 Not Found\n");
                socket.writeUTFBytes("Content-Type: text/html\n\n");
                socket.writeUTFBytes("<html><body><h2>Opendo - File Not Found</h2></body></html>");
            }
            socket.flush();
        } catch (error:Error) {
            log("Error : " + error.message);
        }
    }

    private function getMimeType(path:String):String {
        var mimeType:String;
        var index:int = path.lastIndexOf(".");
        if (index > -1) {
            mimeType = _mimeTypes[path.substring(index)];
        }
        return mimeType == null ? "text/html" : mimeType;
    }

    public function kill():void {
        if (_server_socket) {
            _server_socket.close();
            _server_socket = null;
        }
    }
}
}