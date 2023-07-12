package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;

/**
 * @author Matt - 2021-10-21
 */
public class Animate {
    private static var _func:Function;
    private static var _args:*;
    public static const DECAL:uint = 100;

    /**
     * Note : pour utiliser cette classe, il suffit de l'instancier dans Modals, puis de l'appeler via la fonction show
     * Exemple : Animate.modalIn(ma_view);
     */
    public function Animate() {
    }

    public static function modalIn(view:DisplayObjectContainer):void {
        var view_converted:MovieClip = MovieClip(view);

        var _xstart:Number = -((1920 * Const.POPUP_SCALE) - 1920) / 2;
        var _ystart:Number = -((1200 * Const.POPUP_SCALE) - 1200) / 2;

        view_converted.alpha = 0;
        view_converted.x = _xstart;
        view_converted.y = _ystart;
        view_converted.scaleX = Const.POPUP_SCALE;
        view_converted.scaleY = Const.POPUP_SCALE;

        TweenLite.to(view_converted, Const.ANIM_DURATION, {
            alpha: 1,
            x: 0,
            y: 0,
            scaleX: 1,
            scaleY: 1,
            ease: Power2.easeOut
        });
    }

    public static function modalOut(view:DisplayObjectContainer, func:Function = null, ...args):void {
        var view_converted:MovieClip = MovieClip(view);
        _func = func;
        _args = args;

        var _xstart:Number = -((1920 * Const.POPUP_SCALE) - 1920) / 2;
        var _ystart:Number = -((1200 * Const.POPUP_SCALE) - 1200) / 2;

        TweenLite.to(view_converted, Const.ANIM_DURATION, {
            alpha: 0,
            x: _xstart,
            y: _ystart,
            scaleX: Const.POPUP_SCALE,
            scaleY: Const.POPUP_SCALE,
            ease: Power2.easeIn,
            onComplete: complete
        });
    }

    public static function editorIn(view:DisplayObjectContainer):void {
        var view_converted:MovieClip = MovieClip(view);
        view_converted.alpha = 0;
        view_converted.x = DECAL;

        TweenLite.to(view_converted, Const.ANIM_DURATION, {
            alpha: 1,
            x: 0,
            ease: Power2.easeOut
        });
    }

    public static function editorOut(view:DisplayObjectContainer, func:Function = null, ...args):void {
        var view_converted:MovieClip = MovieClip(view);
        _func = func;
        _args = args;

        TweenLite.to(view_converted, Const.ANIM_DURATION, {
            alpha: 0,
            x: DECAL,
            ease: Power2.easeIn,
            onComplete: complete
        });
    }

    private static function complete():void {
        if (_func != null) _func.apply(null, _args);
    }
}
}