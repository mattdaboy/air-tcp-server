package fr.opendo.socket {
import flash.events.Event;

/**
	 * @author Noel
	 */
	public class SocketCustomEvents extends Event {
		public static const OPENDO_SOCKET_CONNECTED : String = "OPENDO_SOCKET_CONNECTED";
		public static const OPENDO_SOCKET_DISCONNECTED : String = "OPENDO_SOCKET_DISCONNECTED";
		public static const OPENDO_SOCKET_DATA : String = "OPENDO_SOCKET_DATA";
		public static const OPENDO_SOCKET_ERROR : String = "OPENDO_SOCKET_ERROR";
		public static const TCP_SERVER_CREATED : String = "TCP_SERVER_CREATED";
		public static const TCP_SERVER_CLOSED : String = "TCP_SERVER_CLOSED";
		public static const OPEN_MODULE : String = "OPEN_MODULE";
		public static const INSTRUCTION_TO_MODULE : String = "INSTRUCTION_TO_MODULE";
		public static const CLOSE_MODULE : String = "CLOSE_MODULE";
		public static const UPDATE_PARAMETERS_DATAS : String = "UPDATE_PARAMETERS_DATAS";
		public var data : Array = null;

		public function SocketCustomEvents(type : String, data : Array = null, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}