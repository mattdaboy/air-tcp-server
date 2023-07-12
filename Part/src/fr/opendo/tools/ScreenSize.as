package fr.opendo.tools {
import flash.display.Stage;
import flash.display.StageScaleMode;
import flash.events.EventDispatcher;
import flash.utils.setTimeout;

/**
 * @author Matthieu 2017
 * Cette classe ne doit être utilisée que dans le cas où le StageScaleMode final est SHOW_ALL
 */
public class ScreenSize extends EventDispatcher {
    private static var _stage:Stage;
    private static var _appwidth:uint;
    private static var _appheight:uint;
    private static var _screenwidth:uint;
    private static var _screenheight:uint;
    private static var _appscale:Number;
    private static var _relativewidth:uint;
    private static var _relativeheight:uint;
    private static var _top:int;
    private static var _right:int;
    private static var _bottom:int;
    private static var _left:int;

    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function ScreenSize(s:Stage) {
    }

    public static function setStage(s:Stage):void {
        _stage = s;
        getScreenSize();
    }

    private static function getScreenSize():void {
        _appwidth = _stage.stageWidth;
        _appheight = _stage.stageHeight;
        _stage.scaleMode = StageScaleMode.NO_SCALE;
        setTimeout(showall, 1);
    }

    private static function showall():void {
        _screenwidth = _stage.stageWidth;
        _screenheight = _stage.stageHeight;
        _stage.scaleMode = StageScaleMode.SHOW_ALL;

        var ratio_app:Number = _appwidth / _appheight;
        var ratio_screen:Number = _screenwidth / _screenheight;

        if (ratio_app > ratio_screen) {
            // Ecran plus carré (iPad, par exemple)
            _appscale = ratio_app / ratio_screen;
            _left = 0;
            _right = _appwidth;
            _top = Math.floor(_appheight * (1 - _appscale) / 2);
            _bottom = Math.ceil(_top + _appheight * _appscale);
            _relativewidth = _appwidth;
            _relativeheight = Math.ceil(_appheight * _appscale);
        } else {
            // Ecran plus allongé (iPhone, par exemple)
            _appscale = ratio_screen / ratio_app;
            _top = 0;
            _bottom = _appheight;
            _left = Math.floor(_appwidth * (1 - _appscale) / 2);
            _right = Math.ceil(_left + _appwidth * _appscale);
            _relativewidth = Math.ceil(_appwidth * _appscale);
            _relativeheight = _appheight;
        }
        log("_appwidth, _appheight : " + _appwidth + " " + _appheight);
        log("_screenwidth, _screenheight : " + _screenwidth + " " + _screenheight);
        log("_appscale : " + _appscale);
        log("_relativewidth, _relativeheight : " + _relativewidth + " " + _relativeheight);
        log("_left, _top, _right, _bottom : " + _left + " " + _top + " " + _right + " " + _bottom);
    }

    // Largeur de l'écran
    public static function get screenWidth():uint {
        return _screenwidth;
    }

    // Hauteur de l'écran
    public static function get screenHeight():uint {
        return _screenheight;
    }

    // Largeur relative après redimensionnement
    public static function get width():uint {
        return _relativewidth;
    }

    // Hauteur relative après redimensionnement
    public static function get height():uint {
        return _relativeheight;
    }

    // Bord haut de l'écran
    public static function get top():int {
        return _top;
    }

    // Bord droit de l'écran
    public static function get right():int {
        return _right;
    }

    // Bord bas de l'écran
    public static function get bottom():int {
        return _bottom;
    }

    // Bord gauche de l'écran
    public static function get left():int {
        return _left;
    }
}
}


