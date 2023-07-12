package fr.opendo.socket {
import air.net.URLMonitor;

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.net.URLRequest;
import flash.utils.getTimer;

import fr.opendo.events.CustomEvent;
import fr.opendo.modals.Modals;
import fr.opendo.tools.Const;
import fr.opendo.tools.Debug;
import fr.opendo.tools.Language;

/**
 * @author Matt - 2021-11-16
 */
public class InternetConnexionStatus extends EventDispatcher {
    private static var _dispatchers:Array = [];
    private static var _internet_status:String = CustomEvent.INTERNET_CHECKING;
    private static var _web_monitor:URLMonitor;
    private static var _t:uint;

    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function InternetConnexionStatus() {
        throw new Error("!!! InternetConnexionStatus est un singleton et ne peut pas être instancié !!!");
    }

    public static function init():void {
        log("Internet Status : " + _internet_status);
        _web_monitor = new URLMonitor(new URLRequest('https://apple.com'));
        firstCheck();
    }

    private static function firstCheck():void {
        _t = getTimer();
        _web_monitor.addEventListener(StatusEvent.STATUS, firstCheckNetConnectivity);
        _web_monitor.start();
    }

    private static function firstCheckNetConnectivity(e:StatusEvent):void {
        log("firstCheckNetConnectivity");
        _web_monitor.removeEventListener(StatusEvent.STATUS, firstCheckNetConnectivity);
        if (_web_monitor.available) {
            _internet_status = CustomEvent.INTERNET_AVAILABLE;
            log("First Check Internet Status : " + _internet_status + " in " + (getTimer() - _t) + "ms");
            dispatchEventCustom(CustomEvent.INTERNET_AVAILABLE);
        } else {
            _internet_status = CustomEvent.INTERNET_UNAVAILABLE;
            log("First Check Internet Status : " + _internet_status + " in " + (getTimer() - _t) + "ms");
            dispatchEventCustom(CustomEvent.INTERNET_UNAVAILABLE);
            Modals.accessCode.firstInternetCheckUnavailable("Pas de connexion internet"); // Modals.accessCode.update("Vous n'êtes plus connecté à internet");
        }
        _web_monitor.stop();

        _web_monitor.addEventListener(StatusEvent.STATUS, netConnectivity);
        NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);
    }

    private static function onNetworkChange(e:Event):void {
        _web_monitor.start();
    }

    private static function netConnectivity(event:StatusEvent):void {
        if (SocketConnexionStatus.classMode == Const.CLASSE_PRESENTIEL) return;
        if (SocketConnexionStatus.classMode == null) return;

        if (_web_monitor.available) {
            _internet_status = CustomEvent.INTERNET_AVAILABLE;
            log("Internet Status : " + _internet_status);
            Modals.noInternetBanner.hide();
            dispatchEventCustom(CustomEvent.INTERNET_AVAILABLE_AGAIN);
        } else {
            _internet_status = CustomEvent.INTERNET_UNAVAILABLE;
            log("Internet Status : " + _internet_status);
            Modals.noInternetBanner.show();
            Modals.accessCode.update(Language.getValue("no-internet")); // Modals.accessCode.update("Vous n'êtes plus connecté à internet");
            dispatchEventCustom(CustomEvent.INTERNET_LOST);
        }
        _web_monitor.stop();
    }

    private static function dispatchEventCustom(event:String):void {
        for (var i:uint = 0; i < _dispatchers.length; i++) {
            if (_dispatchers[i].event == event) _dispatchers[i].func.apply();
        }
    }

    public static function addEventListenerCustom(event:String, func:Function):void {
        if (!eventExists(event, func)) _dispatchers.push({event: event, func: func});
    }

    private static function eventExists(event:String, func:Function):Boolean {
        for (var i:uint = 0; i < _dispatchers.length; i++) {
            if (_dispatchers[i].event == event && _dispatchers[i].func == func) return true;
        }
        return false;
    }

    public static function get status():String {
        return _internet_status;
    }

    public static function set status(value:String):void {
        _internet_status = value;
    }

    public static function get connected():Boolean {
        return _internet_status == CustomEvent.INTERNET_AVAILABLE;
    }

    public static function get checking():Boolean {
        return _internet_status == CustomEvent.INTERNET_CHECKING;
    }
}
}
