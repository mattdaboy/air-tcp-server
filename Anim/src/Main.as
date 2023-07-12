package {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;

import fr.opendo.home.Logo;
import fr.opendo.socket.SocketConnexionStatus;
import fr.opendo.socket.SocketManager;
import fr.opendo.tools.Const;
import fr.opendo.tools.Debug;

[SWF(backgroundColor='#5ca4ab', frameRate='60')]
public class Main extends Sprite {
    private static var _main:Main;
    private static var _debug:Debug = new Debug();
    private var _logo:Logo;
    public const APP:String = "anim";
    public const VER:String = "0.23.6.12";

    private const ACTIVATE_DEBUG:Boolean = true;
    private const LOG:Boolean = true;

    private function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function Main() {
        init();
    }

    private function init():void {
        log("1. Main.init()");

        _main = this;

        // Homemade Debug
        Debug.init();
        if (ACTIVATE_DEBUG) Debug.activate();

        startApplication();
    }

    private function startApplication():void {
        log("2. Main.startApplication()");
        startSocketManager();
    }

    private function startSocketManager():void {
        log("3.1. Main.startSocketManager()");
        SocketConnexionStatus.classMode = Const.CLASSE_PRESENTIEL;
        SocketManager.dispatcher.addEventListener(Event.COMPLETE, socketManagerOnCompleteHandler);
        SocketManager.startSocket();
    }

    private function socketManagerOnCompleteHandler(event:Event):void {
        log("3.2. Main.socketManagerOnCompleteHandler()");
    }

    public static function get instance():Main {
        return _main;
    }

    public function get getStage():Stage {
        return stage;
    }

    public function get logo():Logo {
        return _logo;
    }

    public function get version():String {
        return VER;
    }
}
}