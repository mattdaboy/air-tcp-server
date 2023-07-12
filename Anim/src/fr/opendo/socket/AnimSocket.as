package fr.opendo.socket {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;

import fr.opendo.modals.Modals;
import fr.opendo.tools.Const;
import fr.opendo.tools.Debug;
import fr.opendo.tools.Language;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu
 */
public class AnimSocket extends Sprite {
    private var _socket:Socket;
    private var _str_buffer:String;
    private var _data_length:uint;
    private var _str_length:uint;

    private const LOG:Boolean = false;

    private function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function AnimSocket() {
        init();
    }

    private function init():void {
        _str_buffer = "";
        _data_length = 0;
        _str_length = 0;
        _socket = new Socket();
        configureListeners(_socket);
        connect();
    }

    private function configureListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(Event.CONNECT, socketConnectedHandler);
        dispatcher.addEventListener(Event.CLOSE, socketCloseHandler);
        dispatcher.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
    }

    public function connect():void {
        _socket.connect(SocketManagerConst.TCP_SERVER_ADDRESS, SocketManagerConst.TCP_SERVER_PORT);
    }

    public function close():void {
        if (_socket.connected) {
            _socket.close();
        }
    }

    private function socketCloseHandler(event:Event):void {
        log("La socket du formateur est fermée.");
    }

    private function socketConnectedHandler(e:Event):void {
        log("La socket du formateur est ouverte.");

        var incomingSocket:Socket = Socket(e.target);
        SocketManagerConst.LOCAL_ADDRESS = incomingSocket.localAddress;
        dispatchEvent(new SocketCustomEvents(SocketCustomEvents.OPENDO_SOCKET_CONNECTED));
    }

    // réception des données de la socket
    private function socketDataHandler(e:ProgressEvent):void {
        var ip:String = _socket.remoteAddress;
        var str:String = _socket.readUTFBytes(_socket.bytesAvailable);

        _str_buffer += str;

        extractStrFromSocketData();

        function extractStrFromSocketData():void {
            var temp1:Array = Tools.splitString(_str_buffer, ",");
            _str_length = uint(temp1[0]);
            _data_length = String(_str_length).length + 1 + _str_length;

            if (_str_buffer.length >= _data_length) {
                var st_full:String = String(temp1[1]).substr(0, _str_length);

                dispatchEvent(new SocketCustomEvents(SocketCustomEvents.OPENDO_SOCKET_DATA, [st_full, ip]));
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

    private function ioErrorHandler(e:IOErrorEvent):void {
        log("Erreur IO sur la socket du formateur.");
        // "L'application n'a pas pu se connecter. Voulez-vous réessayer ?"
        Modals.dialogbox.show(Language.getValue("dialogbox-app-ioerror"));
        Modals.dialogbox.setCancelFunction();
    }

    private function securityErrorHandler(e:SecurityErrorEvent):void {
        log("OpendoSocket securityErrorHandler: " + e);
    }

    // émission données de la socket
    public function sendAll(s:String):void {
        send("sendAll" + Const.SEPARATOR1 + s);
    }

    public function sendOTO(ip:String, s:String):void {
        send("sendOTO" + Const.SEPARATOR1 + ip + Const.SEPARATOR1 + s);
    }

    public function sendToApprenants(ip:String, s:String):void {
        send("sendToApprenants" + Const.SEPARATOR1 + ip + Const.SEPARATOR1 + s);
    }

    private function send(s:String):void {
        _socket.writeUTFBytes(s.length + "," + s);
        _socket.flush();
    }
}
}