package fr.opendo.socket {
import flash.events.Event;

/**
 * @author Noel
 */
public class SocketCustomEvents extends Event {
    public static const TCP_SERVER_CREATED:String = "TCP_SERVER_CREATED";
    public static const TCP_SERVER_CLOSED:String = "TCP_SERVER_CLOSED";
    public static const SOCKET_CONNECTED_TO_TCP_SERVER:String = "SOCKET_CONNECTED_TO_TCP_SERVER";
    public static const SOCKET_DISCONNECTED_TO_TCP_SERVER:String = "SOCKET_DISCONNECTED_TO_TCP_SERVER";
    public static const SOCKET_STILL_CONNECTED:String = "SOCKET_STILL_CONNECTED";
    public static const SOCKET_FORCE_CLOSING:String = "SOCKET_FORCE_CLOSING";
    //
    public static const OPENDO_SOCKET_CONNECTED:String = "OPENDO_SOCKET_CONNECTED";
    public static const OPENDO_SOCKET_DATA:String = "OPENDO_SOCKET_DATA";
    //
    public static const OPEN_MODULE:String = "OPEN_MODULE";
    public static const INSTRUCTION_TO_MODULE:String = "INSTRUCTION";
    public static const CLOSE_MODULE:String = "CLOSE_MODULE";
    public static const QUESTION_BUZZ:String = "QUESTION_BUZZ";
    public var data:Array = null;

    public function SocketCustomEvents(type:String, data:Array = null, bubbles:Boolean = true, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
    }
}
}