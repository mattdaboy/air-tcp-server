package fr.opendo.tools {
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Rectangle;
import flash.media.StageWebView;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import fr.opendo.data.DataManager;
import fr.opendo.socket.SocketConnexionStatus;
import fr.opendo.socket.Users;

/**
 * @author Matt
 */
public class OpendoTracker {
    private static var _webView:StageWebView = new StageWebView(true, false);

    public function OpendoTracker() {
    }

    public static function track(str:String):void {
        if (!DataManager) return;
        if (!DataManager.parametersData) return;
        if (Tools.isExcludedDomain(DataManager.parametersData.license_email)) return;

        sendOpendoTracking(str);
        if (isNaN(Number(str))) sendGATracking(str);
    }

    private static function sendOpendoTracking(str:String):void {
        var vars:String = "";

        var date:Date = new Date();
        var date_formated:String = DateUtils.dateToIso(date);
        vars += date_formated + ";";

        vars += Main.instance.APP + ";";

        vars += Main.instance.version + ";";

        vars += Tools.OS.type + ";";

        var email:String;
        if (DataManager.parametersData) email = DataManager.parametersData.license_email;
        if (!DataManager.parametersData) email = "";
        vars += email + ";";

        var abonnement:String;
        if (DataManager.parametersData) (DataManager.parametersData.enabled == 1) ? abonnement = "Oui" : abonnement = "Non";
        if (!DataManager.parametersData) abonnement = "";
        vars += abonnement + ";";

        var mode_de_classe:String;
        if (SocketConnexionStatus.classMode == Const.CLASSE_DISTANCIEL) mode_de_classe = "Distanciel";
        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL) mode_de_classe = "Présentiel";
        if (SocketConnexionStatus.classMode == "") mode_de_classe = "Pas de mode défini";
        if (!SocketConnexionStatus.classMode) mode_de_classe = "";
        vars += mode_de_classe + ";";

        vars += str + ";";

        var nb_participants:String;
        if (Users.length > 0) nb_participants = String(Users.length);
        if (Users.length == 0) nb_participants = "";
        vars += nb_participants;

        var url_vars:URLVariables = new URLVariables();
        url_vars["str"] = vars;

        var url_request:URLRequest = new URLRequest("https://www.opendo.fr/stats/stats.php");
        url_request.method = URLRequestMethod.POST;
        url_request.data = url_vars;

        var url_loader:URLLoader = new URLLoader();
        url_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        url_loader.addEventListener(Event.COMPLETE, completeHandler);
        url_loader.load(url_request);

        function ioErrorHandler(event:IOErrorEvent):void {
            removeListeners();
        }

        function completeHandler(event:Event):void {
            removeListeners();
            var result:String = url_loader.data;
        }

        function removeListeners():void {
            url_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            url_loader.removeEventListener(Event.COMPLETE, completeHandler);
        }
    }

    public static function initGATracking():void {
        _webView.stage = Main.instance.getStage;
        _webView.viewPort = new Rectangle(-2000, 20, 480, 45);
    }

    public static function sendGATracking(str:String):void {
        if (_webView.hasEventListener(ErrorEvent.ERROR)) _webView.removeEventListener(IOErrorEvent.IO_ERROR, GATrackingErrorHandler);
        if (_webView.hasEventListener(Event.COMPLETE)) _webView.removeEventListener(Event.COMPLETE, GATrackingLoadingCompleteHandler);

        _webView.addEventListener(ErrorEvent.ERROR, GATrackingErrorHandler);
        _webView.addEventListener(Event.COMPLETE, GATrackingLoadingCompleteHandler);
        _webView.loadURL("https://www.opendo.fr/stats/opendoGAtracker.html");

        function GATrackingErrorHandler(event:ErrorEvent):void {
            removeListeners();
        }

        function GATrackingLoadingCompleteHandler(event:Event):void {
            removeListeners();

            var page_title:String = str;
            var app:String = Main.instance.APP;
            var version:String = Main.instance.version;
            var os:String = Tools.OS.type;

            var email:String;
            if (DataManager.parametersData) email = DataManager.parametersData.license_email;
            if (!DataManager.parametersData) email = "";

            var abonnement:String;
            if (DataManager.parametersData) (DataManager.parametersData.enabled == 1) ? abonnement = "Oui" : abonnement = "Non";
            if (!DataManager.parametersData) abonnement = "";

            var mode_de_classe:String;
            if (SocketConnexionStatus.classMode == Const.CLASSE_DISTANCIEL) mode_de_classe = "Distanciel";
            if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL) mode_de_classe = "Présentiel";
            if (SocketConnexionStatus.classMode == "") mode_de_classe = "Pas de mode défini";
            if (!SocketConnexionStatus.classMode) mode_de_classe = "";

            var nb_participants:String;
            if (Users.length > 0) nb_participants = String(Users.length);
            if (Users.length == 0) nb_participants = "";

            _webView.loadURL("javascript:GATrack('" + page_title + "', '" + app + "', '" + version + "', '" + os + "', '" + email + "', '" + abonnement + "', '" + mode_de_classe + "', '" + nb_participants + "');");
        }

        function removeListeners():void {
            _webView.removeEventListener(ErrorEvent.ERROR, GATrackingErrorHandler);
            _webView.removeEventListener(Event.COMPLETE, GATrackingLoadingCompleteHandler);
        }
    }
}
}