package fr.opendo.tools {
import com.greensock.TweenLite;

import flash.display.Sprite;
import flash.geom.ColorTransform;

/**
 * @author matthieu
 */
public class Star extends Sprite {

    public function Star() {
        var shape:HeartView = new HeartView();
        addChild(shape);

        var ct:ColorTransform = new ColorTransform();
        ct.color = Const.PICTO_COLORS[Math.floor(Math.random() * (Const.PICTO_COLORS.length - 1))];
        shape.transform.colorTransform = ct;

        shape.alpha = 1;
        shape.scaleX = shape.scaleY = ((Math.round(Math.random() * 100)) + 50) / 100;

        var animation_time:Number = ((Math.random() * 300) / 100) + 5;
        var angle:Number = Math.round(Math.random() * 90) + 45;
        var velocity:Number = Math.round(Math.random() * 500) + 100;
        var loops:int = (Math.random() * 360) + 360;
        var rotatex:Number = loops;
        var rotatey:Number = loops;
        var rotatez:Number = loops;

        addChild(shape);

        TweenLite.to(shape, animation_time, {physics2D: {velocity: velocity, angle: angle, gravity: -300}});
        TweenLite.to(shape, animation_time, {rotationX: rotatex, rotationZ: rotatez});
        TweenLite.to(shape, 1, {alpha: 0, delay: animation_time - 1, onComplete: removeMe});

        function removeMe():void {
            removeChild(shape);
        }
    }
}
}