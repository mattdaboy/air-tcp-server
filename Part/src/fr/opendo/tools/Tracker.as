package fr.opendo.tools {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import fr.opendo.socket.SocketConnexionStatus;

/**
 * @author Matt
 */
public class Tracker {
    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }
    public function Tracker() {
    }

    public static function track(str:String):void {
        sendTracking(str);
    }

    private static function sendTracking(str:String):void {
        log("sendTracking -> " + str);
        var vars:String = "";

        var date:Date = new Date();
        var date_formated:String = DateUtils.dateToIso(date);
        vars += date_formated + ";";

        vars += Main.instance.APP + ";";

        vars += Main.instance.version + ";";

        vars += Tools.OS.type + ";";

        vars += ";"; // email (pas capté côté Part)

        vars += ";"; // abonnement (pas dispo côté Part)

        var mode_de_classe:String = "";
        switch (SocketConnexionStatus.classMode == "") {
            case "":
                break;
            case Const.CLASSE_DISTANCIEL:
                mode_de_classe = "Distanciel";
                break;
            case Const.CLASSE_PRESENTIEL:
                mode_de_classe = "Présentiel";
                break;
        }
        vars += mode_de_classe + ";";

        vars += str + ";";

        vars += ""; // nombre participants (pas dispo côté Part)

        var url_vars:URLVariables = new URLVariables();
        url_vars["str"] = vars;

        var url_request:URLRequest = new URLRequest("https://www.opendo.fr/stats/stats.php");
        url_request.method = URLRequestMethod.POST;
        url_request.data = url_vars;

        var url_loader:URLLoader = new URLLoader();
        url_loader.addEventListener(Event.COMPLETE, complete);
        url_loader.addEventListener(IOErrorEvent.IO_ERROR, error);
        url_loader.load(url_request);

        function complete(event:Event):void {
            var result:String = url_loader.data;
            log("Tracker.sendTracking() -> result : " + result);
        }

        function error(event:IOErrorEvent):void {
            log("Tracker.sendTracking() a échoué");
        }
    }
}
}