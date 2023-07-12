package fr.opendo.socket {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.events.ServerSocketConnectEvent;
import flash.net.ServerSocket;
import flash.net.Socket;
import flash.utils.setTimeout;

import fr.opendo.modals.Modals;
import fr.opendo.tools.Const;
import fr.opendo.tools.Debug;
import fr.opendo.tools.Language;
import fr.opendo.tools.Tools;

/**
 * @author Matt
 */
public class TCPServer extends EventDispatcher {
    private var _server_socket:ServerSocket;
    private var _clients_stored_sockets:Array = [];

    private const LOG:Boolean = false;

    private function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function TCPServer() {
    }

    public function create():void {
        log("Création du serveur TCP.");
        _server_socket = new ServerSocket();
        _server_socket.addEventListener(ServerSocketConnectEvent.CONNECT, clientConnectedHandler);
        _server_socket.addEventListener(Event.CLOSE, closeHandler);
    }

    public function start():void {
        log("Démarrage du serveur TCP.");
        try {
            _server_socket.bind(SocketManagerConst.TCP_SERVER_PORT);
            _server_socket.listen();
        } catch (e:SecurityError) {
        } finally {
            if (_server_socket.listening) {
                // Dispatch sur SocketManager
                dispatchEvent(new Event(Event.COMPLETE));
            } else {
                // "Préparation.\nVeuillez patienter..."
                Modals.gimikO.show(Language.getValue("gimiko-preparation"));
                Modals.gimikO.setNoCancel();
                setTimeout(start, 10000);
            }
        }
    }

    private function clientConnectedHandler(event:ServerSocketConnectEvent):void {
        log("TCPServer clientConnectedHandler())");

        var client_socket:Socket = Socket(event.socket);
        addStoredSocket(client_socket);
//        traceSocket(client_socket);

        var _str_buffer:String;
        var _data_length:uint;
        var _str_length:uint;


        client_socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
        client_socket.addEventListener(Event.CLOSE, clientDisconnectedHandler);

        // Dispatch sur SocketManager
        dispatchEvent(new SocketCustomEvents(SocketCustomEvents.SOCKET_CONNECTED_TO_TCP_SERVER, [client_socket]));

        function socketDataHandler(event:ProgressEvent):void {
            var clientSocket:Socket = Socket(event.target);
            var ba:uint = clientSocket.bytesAvailable;
            var str:String = clientSocket.readUTFBytes(ba);

            _str_buffer += str;
            extractStrFromSocketData();

            function extractStrFromSocketData():void {
                var temp1:Array = Tools.splitString(_str_buffer, ",");
                _str_length = uint(temp1[0]);
                _data_length = String(_str_length).length + 1 + _str_length;

                if (_str_buffer.length >= _data_length) {
                    var st_full:String = String(temp1[1]).substr(0, _str_length);

                    var temp2:Array = Tools.splitString(st_full, Const.SEPARATOR1);
                    var temp3:Array = Tools.splitString(temp2[1], Const.SEPARATOR1);

                    switch (temp2[0]) {
                        case "sendAll" :
                            sendAll(temp2[1]);
                            break;
                        case "sendOTO" :
                            sendOTO(temp3[0], temp3[1]);
                            break;
                        case "sendToApprenants" :
                            sendToApprenants(temp3[0], temp3[1]);
                            break;
                    }

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

        function clientDisconnectedHandler(event:Event):void {
            var client_socket:Socket = Socket(event.target);

            log("TCPServer clientDisconnectedHandler())");

            // Dispatch sur SocketManager
            var client_networkAddress:String = getStoredSocketNetworkaddress(client_socket);
            dispatchEvent(new SocketCustomEvents(SocketCustomEvents.SOCKET_DISCONNECTED_TO_TCP_SERVER, [client_networkAddress]));

            removeStoredSocket(client_socket);
        }
    }

    private function addStoredSocket(client_socket:Socket):void {
        if (!isSocketAdded(client_socket)) _clients_stored_sockets.push({"socket": client_socket, "remoteAdrress": "" + client_socket.remoteAddress})
    }

    private function isSocketAdded(client_socket:Socket):Boolean {
        var result:Boolean = false;
        for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
            if (_clients_stored_sockets[i]["socket"] == client_socket) result = true;
        }
        return result;
    }

    private function removeStoredSocket(client_socket:Socket):void {
        for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
            if (_clients_stored_sockets[i]["socket"] == client_socket) {
                _clients_stored_sockets.splice(i, 1);
                return;
            }
        }
    }

    private function getStoredSocketNetworkaddress(client_socket:Socket):String {
        var result:String = "";
        for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
            if (_clients_stored_sockets[i]["socket"] == client_socket) {
                result = _clients_stored_sockets[i]["remoteAdrress"];
                break;
            }
        }
        return result;
    }

    private function closeStoredSocket(client_socket:Socket):void {
        for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
            if (_clients_stored_sockets[i]["socket"] == client_socket) {
                // Modified by Matt 2022-12-05. Previous : _clients_stored_sockets[i].close();
                var socket:Socket = _clients_stored_sockets[i]["socket"];
                socket.close();
                removeStoredSocket(client_socket);
                return;
            }
        }
    }

    public function closeStoredSocketById(id:String):void {
        for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
            if (_clients_stored_sockets[i]["networkAddress"] == id) {
                var socket:Socket = _clients_stored_sockets[i]["socket"];
                socket.close();
                return;
            }
        }
    }

    public function send(str:String):void {
        for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
            var socket:Socket = _clients_stored_sockets[i]["socket"];
            socket.writeUTFBytes(str.length + "," + str);
            socket.flush();
        }
    }

    public function sendAll(str:String):void {
        for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
            var socket:Socket = _clients_stored_sockets[i]["socket"];
            socket.writeUTFBytes(str.length + "," + str);
            socket.flush();
        }
    }

    public function sendOTO(ip:String, str:String):void {
        for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
            var socket:Socket = _clients_stored_sockets[i]["socket"];
            if (socket.remoteAddress == ip) {
                socket.writeUTFBytes(str.length + "," + str);
                socket.flush();
            }
        }
    }

    public function sendToApprenants(ip:String, str:String):void {
        for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
            var socket:Socket = _clients_stored_sockets[i]["socket"];
            if (socket.remoteAddress != ip) {
                socket.writeUTFBytes(str.length + "," + str);
                socket.flush();
            }
        }
    }

    private function closeHandler(event:Event):void {
        // Dispatch sur SocketManager
        dispatchEvent(new SocketCustomEvents(SocketCustomEvents.TCP_SERVER_CLOSED));
    }

    private function traceSocket(socket:Socket):void {
        log("bytesAvailable = " + socket.bytesAvailable);
        log("bytesPending = " + socket.bytesPending);
        log("connected = " + socket.connected);
        log("endian = " + socket.endian);
        log("localAddress = " + socket.localAddress);
        log("localPort = " + socket.localPort);
        log("objectEncoding = " + socket.objectEncoding);
        log("remoteAddress = " + getStoredSocketNetworkaddress(socket));
        log("remotePort = " + socket.remotePort);
        log("timeout = " + socket.timeout);
    }

    public function kill():void {
        if (_server_socket) {
            _server_socket.close();
            _server_socket = null;
            for (var i:uint = 0; i < _clients_stored_sockets.length; i++) {
                var socket:Socket = _clients_stored_sockets[i]["socket"];
                closeStoredSocket(socket);
            }
        }
    }
}
}