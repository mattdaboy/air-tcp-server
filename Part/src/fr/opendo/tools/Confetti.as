package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;

/**
 * @author Matt v2 - 2022-10-07
 */
public class Confetti extends Sprite {

    public function Confetti() {
    }

    public static function fallingConfetti(container:DisplayObjectContainer):void {
        var confetti:Sprite = new Sprite();
        confetti.graphics.beginFill(0x38D7E7);
        confetti.graphics.drawRect(0, 0, 20, 20);
        confetti.graphics.endFill();
        confetti.mouseEnabled = false;
        confetti.mouseChildren = false;
        confetti.x = ScreenSize.left + (Math.random() * ScreenSize.width);
        confetti.y = ScreenSize.top - 50;
        confetti.z = (Math.random() * 3000) - 1500;
        confetti.scaleX = confetti.scaleY = ((Math.round(Math.random() * 100)) + 50) / 100;

        var tabColor:Array = [0xBADF44, 0x38D7E7, 0xFFA52E, 0xEE316B];
        var ct:ColorTransform = new ColorTransform();
        ct.color = tabColor[Math.floor(Math.random() * tabColor.length)];
        confetti.transform.colorTransform = ct;

        var animation_time:Number = ((Math.random() * 300) / 100) + 5;
        var angle:Number = 45 + Math.round(Math.random() * 90);
        var velocity:Number = Math.round(Math.random() * 500) + 100;
        var loops:int = (Math.random() * 1440) + 1440;
        var rotatex:Number = loops;
        var rotatez:Number = loops;

        container.addChild(confetti);

        TweenLite.to(confetti, animation_time, {physics2D: {velocity: velocity, angle: angle, gravity: 600}});
        TweenLite.to(confetti, animation_time, {rotationX: rotatex, rotationZ: rotatez});
        TweenLite.to(confetti, 1, {
            alpha: 0, delay: animation_time - 1, onComplete: function ():void {
                container.removeChild(confetti);
            }
        });
    }

    public static function explodingConfetti(container:DisplayObjectContainer, center:Point, direction:String = Const.ALL):void {
        var confetti:Sprite = new Sprite();
        confetti.graphics.beginFill(0x38D7E7);
        confetti.graphics.drawRect(0, 0, 20, 20);
        confetti.graphics.endFill();
        confetti.mouseEnabled = false;
        confetti.mouseChildren = false;
        confetti.x = center.x;
        confetti.y = center.y;
        confetti.scaleX = confetti.scaleY = ((Math.round(Math.random() * 100)) + 50) / 100;

        var tabColor:Array = [0xBADF44, 0x38D7E7, 0xFFA52E, 0xEE316B];
        var ct:ColorTransform = new ColorTransform();
        ct.color = tabColor[Math.floor(Math.random() * tabColor.length)];
        confetti.transform.colorTransform = ct;

        var animation_time:Number = ((Math.random() * 300) / 100) + 5;
        var loops:int = (Math.random() * 1440) + 1440;
        var rotatex:Number = loops;
        var rotatez:Number = loops;

        var angle:Number; // L'angle 0 est à droite (axe des absysses)
        var posZ:Number; // L'angle 0 est à droite (axe des absysses)
        var velocity:Number;
        var gravity:Number;
        switch (direction) {
            case Const.ALL:
                angle = Math.random() * 360;
                posZ = -3000 + Math.random() * 6000;
                velocity = Math.round(Math.random() * 800) + 200;
                gravity = 1000;
                break;
            case Const.UP_LEFT:
                angle = -135 + Math.random() * 30;
                posZ = -3000 + Math.random() * 6000;
                velocity = Math.round(Math.random() * 1000) + 1000;
                gravity = 2000;
                break;
            case Const.UP_RIGHT:
                angle = -75 + Math.random() * 30;
                posZ = -3000 + Math.random() * 6000;
                velocity = Math.round(Math.random() * 1000) + 1000;
                gravity = 2000;
                break;
        }

        container.addChild(confetti);

        TweenLite.to(confetti, animation_time, {physics2D: {velocity: velocity, angle: angle, gravity: gravity}});
        TweenLite.to(confetti, animation_time, {rotationX: rotatex, rotationZ: rotatez});
        TweenLite.to(confetti, animation_time, {z: posZ, ease: Power2.easeOut});
        TweenLite.to(confetti, 1, {
            alpha: 0, delay: animation_time - 1, onComplete: function ():void {
                container.removeChild(confetti);
            }
        });
    }
}
}