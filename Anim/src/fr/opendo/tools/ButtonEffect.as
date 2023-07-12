package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

/**
 * @author Matthieu 2018
 */
public class ButtonEffect extends Sprite {
    private static const IN_DURATION:Number = .1;
    private static const OUT_DURATION:Number = .1;
    private static const ANIM_SCALE:Number = 1.1;
    private static var START_SCALEX:Number;
    private static var START_SCALEY:Number;

    public function ButtonEffect() {
    }

    public static function bump(target:DisplayObjectContainer):void {
        START_SCALEX = target.scaleX;
        START_SCALEY = target.scaleY;

        var anim_scalex:Number = START_SCALEX * ANIM_SCALE;
        var anim_scaley:Number = START_SCALEY * ANIM_SCALE;

        TweenLite.to(target, IN_DURATION, {scaleX: anim_scalex, scaleY: anim_scaley, ease: Power2.easeOut});
        TweenLite.to(target, OUT_DURATION, {scaleX: START_SCALEX, scaleY: START_SCALEY, delay: IN_DURATION, ease: Power2.easeInOut});
    }
}
}