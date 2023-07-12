package fr.opendo.socket {
import air.net.URLMonitor;

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.net.URLRequest;

import fr.opendo.home.ViewManager;
import fr.opendo.modals.Modals;
import fr.opendo.tools.Const;
import fr.opendo.tools.Debug;
import fr.opendo.tools.Language;

/**
 * @author Matt - 2021-11-16
 */
public class InternetConnexionStatus extends EventDispatcher {
    // Connexion internet
    public static const INTERNET_AVAILABLE:String = "INTERNET_AVAILABLE";
    public static const INTERNET_UNAVAILABLE:String = "INTERNET_UNAVAILABLE";
    private static var _internet_status:String = INTERNET_UNAVAILABLE;
    private static var _web_monitor:URLMonitor;

    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function InternetConnexionStatus() {
    }

    public static function init():void {
        _web_monitor = new URLMonitor(new URLRequest('https://apple.com'));
        firstCheck();
    }

    private static function firstCheck():void {
        _web_monitor.addEventListener(StatusEvent.STATUS, firstCheckNetConnectivity);
        _web_monitor.start();
    }

    private static function firstCheckNetConnectivity(e:StatusEvent):void {
        _web_monitor.removeEventListener(StatusEvent.STATUS, firstCheckNetConnectivity);
        if (_web_monitor.available) {
            log("First Check Internet Status : AVAILABLE");

            _internet_status = INTERNET_AVAILABLE;
        } else {
            log("First Check Internet Status : UNAVAILABLE");

            _internet_status = INTERNET_UNAVAILABLE;
        }
        _web_monitor.stop();

        _web_monitor.addEventListener(StatusEvent.STATUS, netConnectivity);
        NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);
    }

    private static function onNetworkChange(e:Event):void {
        _web_monitor.start();
    }

    private static function netConnectivity(e:StatusEvent):void {
        log("SocketConnexionStatus.classMode = " + SocketConnexionStatus.classMode);
        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL) return;
        if (SocketConnexionStatus.classMode == null) return;


        if (_web_monitor.available) {
            log("Internet Status : AVAILABLE AGAIN");

            _internet_status = INTERNET_AVAILABLE;
            Modals.noInternetBanner.hide();
            Modals.waitPage.updateMessage(Language.getValue("bienvenue"));
            if (!ViewManager.isOneIModuleAdded() && ViewManager.isIViewAdded(Main.instance.home) && !ViewManager.isIViewAdded(Modals.waitPage)) {
                SocketManager.startSocketManager(SocketConnexionStatus.classMode);
            }
        } else {
            log("Internet Status : LOST");

            _internet_status = INTERNET_UNAVAILABLE;
            Modals.noInternetBanner.show();
        }
        _web_monitor.stop();
    }

    public static function get status():String {
        return _internet_status;
    }

    public static function set status(value:String):void {
        _internet_status = value;
    }

    public static function get connected():Boolean {
        var value:Boolean = false;
        if (_internet_status == INTERNET_AVAILABLE) value = true;
        return value;
    }
}
}
