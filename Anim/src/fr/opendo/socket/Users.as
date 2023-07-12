package fr.opendo.socket {
import flash.events.EventDispatcher;

import fr.opendo.events.CustomEvent;
import fr.opendo.tools.Debug;

/**
 * @author Matt
 */
public class Users extends EventDispatcher {
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    private static var _users:Vector.<User> = new Vector.<User>();

    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public static function get users():Vector.<User> {
        return _users;
    }

    // Combien d'utilisateurs sont vraiment connectés (ceux qui n'ont pas timeout lors du PING)
    public static function get usersConnected():uint {
        var users_connected:uint = 0;
        for each (var user_in_vector:User in _users) {
            if (user_in_vector.connectionStatus != SocketManagerConst.USER_TIMEOUT) users_connected++;
        }
        return users_connected;
    }

    public static function get usersConnectedIds():Array {
        var ids:Array = [];
        for each (var user_in_vector:User in _users) {
            if (user_in_vector.connectionStatus != SocketManagerConst.USER_TIMEOUT) ids.push(user_in_vector.id);
        }
        return ids;
    }

    // Combien d'utilisateurs ont timeout lors du PING
    public static function get usersTimeout():uint {
        var users_timeout:uint = 0;
        for each (var user_in_vector:User in _users) {
            if (user_in_vector.connectionStatus == SocketManagerConst.USER_TIMEOUT) users_timeout++;
        }
        return users_timeout;
    }

    public static function get length():uint {
        return _users.length;
    }

    public static function add(user:User):void {
        checkDoublons(user);
        _users.push(user);
        user.addEventListener(CustomEvent.USER_NOT_RESPONDING, userRespondingChanged);
        user.addEventListener(CustomEvent.USER_RESPONDING_AGAIN, userRespondingChanged);

        // Dispatch surt SocketManager
        _dispatcher.dispatchEvent(new CustomEvent(CustomEvent.USERS_CHANGED, [user]));
    }

    private static function userRespondingChanged(event:CustomEvent):void {
        var user:User = event.currentTarget as User;
        // Dispatch surt SocketManager
        _dispatcher.dispatchEvent(new CustomEvent(CustomEvent.USERS_CHANGED, [user]));
    }

    private static function checkDoublons(user:User):void {
        log("checkDoublons " + user.email);

        for each (var user_in_vector:User in _users) {
            if (user_in_vector.email == user.email) {
                removeUser(user_in_vector);
                break;
            }
        }
    }

    public static function removeUser(user:User):void {
        if (user.hasEventListener(CustomEvent.USER_NOT_RESPONDING)) user.removeEventListener(CustomEvent.USER_NOT_RESPONDING, userRespondingChanged);
        if (user.hasEventListener(CustomEvent.USER_RESPONDING_AGAIN)) user.removeEventListener(CustomEvent.USER_RESPONDING_AGAIN, userRespondingChanged);

        for (var i:uint = 0; i < _users.length; i++) {
            var user_in_vector:User = _users[i];
            if (user_in_vector.id == user.id) {
                user_in_vector.cleanTimeout();
                user_in_vector.clean();
                _users.splice(i, 1);

                // Dispatch surt SocketManager
                _dispatcher.dispatchEvent(new CustomEvent(CustomEvent.USERS_REMOVED, [user]));
                break;
            }
        }
    }

    public static function reset():void {
        cleanPingTimeouts();
        _users = new Vector.<User>;

        // Dispatch surt SocketManager
        _dispatcher.dispatchEvent(new CustomEvent(CustomEvent.USERS_CHANGED));
    }

    public static function onGetAllUsers(params:Object):void {
        log("users.onGetAllUsers()");
        var usersInRoom:Array = [];

        for (var s:String in params) {
            for (var r:String in params[s]["rooms"]) {
                if (r == SocketManager.currentRoom.id) usersInRoom.push({id: s, name: params[s]["name"]});
            }
        }

        for (var o:String in usersInRoom) {
            log("Users.onGetAllUsers, userId = " + usersInRoom[o].id + ", name = " + usersInRoom[o].name);
        }
    }

    public static function isFormateurAlreadyInRoom(params:Object):Boolean {
        var result:Boolean = false;
        var usersInRoom:Array = [];

        for (var s:String in params) {
            log("SocketManager.handleWebSocketMessage, userId = " + s);
            log("SocketManager.handleWebSocketMessage, params.name = " + params[s]["name"]);
            log("SocketManager.handleWebSocketMessage, params.ip = " + params[s]["ip"]);
            for (var r:String in params[s]["rooms"]) {
                log("SocketManager.handleWebSocketMessage, params.room = " + r);
                if (r == SocketManager.currentRoom.id) usersInRoom.push({id: s, name: params[s]["name"]});
            }
        }
        for (var o:String in usersInRoom) {
            if (usersInRoom[o].name == "formateur") result = true;
        }

        return result;
    }

    public static function update(users_in_room:Array):void {
        var i:uint = 0;

        // Constitution de la liste des Participants à supprimer du vector _users
        var users_to_delete:Vector.<User> = checkUsersToDelete();

        for (i = 0; i < users_to_delete.length; i++) {
            removeUser(users_to_delete[i]);
        }

        // Constitution de la liste des Participants à rajouter au vector _users
        var new_users:Vector.<User> = checkNewUsersToAdd();

        for (i = 0; i < new_users.length; i++) {
            var user:User = new_users[i];
            _users.push(user);
            if (user.email == "") SocketManager.requestUserInfos(user.id);
        }

        // Dispatch surt SocketManager
        _dispatcher.dispatchEvent(new CustomEvent(CustomEvent.USERS_CHANGED));
    }

    private static function checkUsersToDelete():Vector.<User> {
        var users:Vector.<User> = new Vector.<User>();
        for (var i:int = _users.length - 1; i >= 0; i--) {
            var user:User = _users[i];
            if (!isUserAdded(user.id)) users.push(user);
        }
        return users;
    }

    private static function checkNewUsersToAdd():Vector.<User> {
        var users:Vector.<User> = new Vector.<User>();
        for (var i:int = 0; i < _users.length; i++) {
            if (!isUserAdded(Users.getUserByIndex(i).id)) users.push(Users.getUserByIndex(i));
        }
        return users;
    }

    public static function isUserAdded(user_id:String):Boolean {
        var added:Boolean = false;
        for (var i:int = 0; i < _users.length; i++) {
            if (_users[i].id == user_id) {
                added = true;
                break;
            }
        }
        return added;
    }


    public static function cleanPingTimeouts():void {
        for each (var user_in_vector:User in _users) {
            user_in_vector.cleanTimeout();
        }
    }

    public static function getUserById(id:String):User {
        var user_searched:User = null;
        for each (var user_in_vector:User in _users) {
            if (user_in_vector.id == id) {
                user_searched = user_in_vector;
                break;
            }
        }
        return user_searched;
    }

    public static function getUserByEmail(email:String):User {
        var user_searched:User = null;
        for each (var user_in_vector:User in _users) {
            if (user_in_vector.email == email) {
                user_searched = user_in_vector;
                break;
            }
        }
        return user_searched;
    }

    public static function getUserByIndex(index:uint):User {
        return _users[index];
    }

    public static function getUserIdByEmail(email:String):String {
        var id_search:String = "";
        for each (var user_in_vector:User in _users) {
            if (user_in_vector.email == email) {
                id_search = user_in_vector.id;
                break;
            }
        }
        return id_search;
    }

    public static function debugUsers():void {
        log("Users.length = " + _users.length);
        for (var i:uint = 0; i < _users.length; i++) {
            log("User : " + getUserByIndex(i).prenom + " / " + getUserByIndex(i).email);
        }
    }

    public static function hasEventListener(event:String):Boolean {
        return _dispatcher.hasEventListener(event);
    }

    public static function addEventListener(event:String, func:Function):void {
        _dispatcher.addEventListener(event, func);
    }

    public static function removeEventListener(event:String, func:Function):void {
        _dispatcher.removeEventListener(event, func);
    }

    public function Users() {
        throw new Error("!!! Users est un singleton et ne peut pas être instancié !!!");
    }
}
}