package {
import com.greensock.plugins.AutoAlphaPlugin;
import com.greensock.plugins.Physics2DPlugin;
import com.greensock.plugins.ThrowPropsPlugin;
import com.greensock.plugins.TweenPlugin;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.display.StageDisplayState;
import flash.events.Event;

import fr.opendo.socket.InternetConnexionStatus;
import fr.opendo.socket.SocketConnexionStatus;
import fr.opendo.socket.SocketManager;
import fr.opendo.tools.Const;
import fr.opendo.tools.Debug;
import fr.opendo.tools.ScreenSize;
import fr.opendo.tools.Tools;

[SWF(backgroundColor='#5ca4ab', frameRate='60')]
public class Main extends MovieClip {
    private static var MAIN:Main;
    private static var _debug:Debug = new Debug();
    private var _version:String;
    public const APP:String = "part";

    public static var LOGO_EN_BAS_A_GAUCHE:LogoOpendoMcView;

    private const ACTIVATE_DEBUG:Boolean = false;
    private const LOG:Boolean = false;

    private function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function Main() {
        MAIN = this;
        stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

        // Homemade Debug
        Debug.init();
        if (ACTIVATE_DEBUG) Debug.activate();
        log("1. Main()");

        // Activation TweenPlugin (activation is permanent, so this line only needs to be run once)à
        TweenPlugin.activate([AutoAlphaPlugin]);
        TweenPlugin.activate([Physics2DPlugin]);
        TweenPlugin.activate([ThrowPropsPlugin]);

        // Version de l'app
        _version = Tools.appVersion;

        // Keep awake O_O pour les mobiles
        NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;

        launch();
    }

    private function launch():void {
        log("2. Main.launch()");
        startApplication();
    }

    private function startApplication():void {
        log("3. Main.startApplication()");

        // Internet disponible ?
        InternetConnexionStatus.init();

        LOGO_EN_BAS_A_GAUCHE = new LogoOpendoMcView();
        LOGO_EN_BAS_A_GAUCHE.width = 180;
        LOGO_EN_BAS_A_GAUCHE.height = 40;
        LOGO_EN_BAS_A_GAUCHE.x = ScreenSize.left + 40;
        LOGO_EN_BAS_A_GAUCHE.y = ScreenSize.bottom - 80;
        LOGO_EN_BAS_A_GAUCHE.alpha = .3;
        LOGO_EN_BAS_A_GAUCHE.visible = false;
        addChild(LOGO_EN_BAS_A_GAUCHE);

    }

    private function startSocketManager():void {
        log("3.1. Main.startSocketManager()");
        SocketConnexionStatus.classMode = Const.CLASSE_PRESENTIEL;
        SocketManager.dispatcher.addEventListener(Event.COMPLETE, socketManagerOnCompleteHandler);
        SocketManager.startSocketManager(Const.CLASSE_PRESENTIEL);
    }

    private function socketManagerOnCompleteHandler(event:Event):void {
        log("3.2. Main.socketManagerOnCompleteHandler()");
    }

    public static function get instance():Main {
        return MAIN;
    }

    public function get version():String {
        return _version;
    }

    public function get getStage():Stage {
        return stage;
    }
}
}