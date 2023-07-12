package fr.opendo.socket {
/**
 * @author noel
 */
public class WebSocketRoom {
    private static var _id:String = "";
    private static var _nom:String = "";

    public static function get id():String {
        return _id;
    }

    public static function set id(value:String):void {
        _id = value;
    }

    public static function get nom():String {
        return _nom;
    }

    public static function set nom(value:String):void {
        _nom = value;
    }

    public static function clear():void {
        _id = "";
        _nom = "";
    }
}
}