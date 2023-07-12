package fr.opendo.socket {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;

import fr.opendo.database.DataManager;
import fr.opendo.modals.Modals;
import fr.opendo.tools.Debug;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu
 */
public class OpendoSocket extends Sprite {
    private var _socket:Socket;
    private var _str_buffer:String;
    private var _data_length:uint;
    private var _str_length:uint;

    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function OpendoSocket() {
        init();
    }

    private function init():void {
        _str_buffer = "";
        _data_length = 0;
        _str_length = 0;
        _socket = new Socket();
        addListeners(_socket);
        open();
    }

    private function addListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(Event.CONNECT, socketConnectedHandler);
        dispatcher.addEventListener(Event.CLOSE, socketCloseHandler);
        dispatcher.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
    }

    public function open():void {
        _socket.connect(DataManager.infosConnexion, SocketManagerConst.TCP_SERVER_PORT);
    }

    public function close():void {
        if (_socket.connected) {
            _socket.close();
        }
    }

    private function socketConnectedHandler(e:Event):void {
        var incomingSocket:Socket = Socket(e.target);
        SocketManagerConst.LOCAL_ADDRESS = incomingSocket.localAddress;
        log("OpendoSocket, je me suis connecté avec cette IP : " + SocketManagerConst.LOCAL_ADDRESS);
        // Dispatch vers SocketManager
        dispatchEvent(new SocketCustomEvents(SocketCustomEvents.OPENDO_SOCKET_CONNECTED));
    }

    // Réception des données de la socket
    private function socketDataHandler(e:ProgressEvent):void {
        Modals.gimikIncomingDatas.showDownload();

        var str:String = _socket.readUTFBytes(_socket.bytesAvailable);
        _str_buffer += str;

        extractStrFromSocketData();

        function extractStrFromSocketData():void {
            var temp1:Array = Tools.splitString(_str_buffer, ",");
            _str_length = uint(temp1[0]);
            _data_length = String(_str_length).length + 1 + _str_length;

            if (_str_buffer.length >= _data_length) {
                var st_full:String = String(temp1[1]).substr(0, _str_length);

                dispatchEvent(new SocketCustomEvents(SocketCustomEvents.OPENDO_SOCKET_DATA, [st_full]));
                var new_str_buffer:String = _str_buffer.substr(_data_length);
                _str_buffer = new_str_buffer;
                if (_str_buffer.length > 0) {
                    extractStrFromSocketData();
                }
            }
            if (_str_buffer.length == 0) {
                _data_length = 0;
                _str_length = 0;
            }
        }
    }

    private function socketCloseHandler(e:Event):void {
        log("OpendoSocket, socket closed");
        close();
        // Dispatch vers SocketManager
        dispatchEvent(new SocketCustomEvents(SocketCustomEvents.OPENDO_SOCKET_DISCONNECTED));
    }

    private function ioErrorHandler(e:IOErrorEvent):void {
        // Dispatch vers SocketManager
        dispatchEvent(new SocketCustomEvents(SocketCustomEvents.OPENDO_SOCKET_ERROR));
    }

    private function securityErrorHandler(e:SecurityErrorEvent):void {
        Modals.gimikO.hide();
        log("OpendoSocket securityErrorHandler: " + e);
    }

    // émission des données de la socket
    private function send(s:String):void {
        if (_socket.connected) {
            Modals.gimikIncomingDatas.showUpload();
            _socket.writeUTFBytes(s.length + "," + s);
            _socket.flush();
        }
    }

    public function sendAll(s:String):void {
        send("sendAll" + SocketManagerConst.SEPARATOR1 + s);
    }

    public function sendOTO(ip:String, s:String):void {
        send("sendOTO" + SocketManagerConst.SEPARATOR1 + ip + SocketManagerConst.SEPARATOR1 + s);
    }

    public function get socket():Socket {
        return _socket;
    }
}
}