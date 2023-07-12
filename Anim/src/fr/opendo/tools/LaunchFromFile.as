package fr.opendo.tools {
import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.InvokeEvent;
import flash.filesystem.File;
import flash.utils.setTimeout;

import fr.opendo.data.DataManager;
import fr.opendo.data.SessionData;
import fr.opendo.home.Home;
import fr.opendo.home.ViewManager;
import fr.opendo.modals.Modals;

/**
 * @author Matt - 2021-10-15
 */
public class LaunchFromFile extends EventDispatcher {
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    private static var _home:Home;
    private static var _current_dir:File;
    private static var _file_to_open:File;
    private static var _invoke_session_id:int = -1;
    private static var _invoke_module_id:int = -1;

    public static function init(home:Home):void {
        _home = home;
        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);

        // TESTS
//        _invoke_session_id = 24;
//        _invoke_module_id = 4;
//        setTimeout(openInvokedSession, 5000);
    }

    private static function onInvoke(invokeEvent:InvokeEvent):void {
        var now:String = new Date().toTimeString();

        if ((invokeEvent.currentDirectory != null) && (invokeEvent.arguments.length > 0)) {
            _current_dir = invokeEvent.currentDirectory;
            _file_to_open = _current_dir.resolvePath(invokeEvent.arguments[0]);
            _file_to_open.addEventListener(Event.COMPLETE, onFileImportLoad);
            _file_to_open.load();
        }
    }

    private static function onFileImportLoad(event:Event):void {
        _file_to_open.removeEventListener(Event.COMPLETE, onFileImportLoad);
        var myString:String = _file_to_open.data.toString();
        var args_array:Array = myString.split(";");
        _invoke_session_id = uint(args_array[1]);
        _invoke_module_id = uint(args_array[3]);

        setTimeout(openInvokedSession, 500);
    }

    private static function openInvokedSession():void {
        var session_data:SessionData = DataManager.getSessionDataById(_invoke_session_id);
        if (session_data == null) {
            Modals.banner.show("Session inexistante");
            _invoke_session_id = -1;
            return;
        }

        var module_data:XML = DataManager.getModuleDataById(_invoke_session_id, _invoke_module_id);
        if (module_data == null) {
            Modals.banner.show("Activité inexistante");
            _invoke_module_id = -1;
            return;
        }

        if (_invoke_session_id != -1) {
//            DataManager.currentSessionData.id = session_data.id;
            ViewManager.removeAllIModules();
            ViewManager.removeAllIViews();
            home.openInvokedSession(session_data.id);
            _invoke_session_id = -1;
        }
    }

    public static function hasEventListener(event:String):Boolean {
        return _dispatcher.hasEventListener(event);
    }

    public static function addEventListener(event:String, func:Function):void {
        _dispatcher.addEventListener(event, func);
    }

    public static function get home():Home {
        return _home;
    }

    public static function get invokedModuleId():int {
        return _invoke_module_id;
    }

    public static function set invokedModuleId(value:int):void {
        _invoke_module_id = value;
    }

    public function LaunchFromFile() {
        throw new Error("!!! LaunchFromFile est un singleton et ne peut pas être instancié !!!");
    }
}
}