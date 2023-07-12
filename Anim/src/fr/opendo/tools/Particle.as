package fr.opendo.tools {
import com.greensock.TweenLite;

import flash.display.MovieClip;
import flash.geom.ColorTransform;

/**
 * @author matthieu
 */
public class Particle extends MovieClip {
    private static var PARTICLES_VIEW_NB:uint = 3;

    public function Particle() {
        var n:int = Math.floor(Math.random() * PARTICLES_VIEW_NB);
        var view:MovieClip;
        switch (n) {
            case 0:
                view = new Particle0View();
                break;
            case 1:
                view = new Particle1View();
                break;
            case 2:
                view = new Particle2View();
                break;
        }
        var tabColor:Array = [0xBADF44, 0x38D7E7, 0xFFA52E, 0xEE316B];
        var ct:ColorTransform = new ColorTransform();
        ct.color = tabColor[Math.floor(Math.random() * tabColor.length)];
        view.transform.colorTransform = ct;

        view.alpha = 1;
        view.scaleX = view.scaleY = ((Math.round(Math.random() * 200)) + 50) / 100;

        var animation_time:Number = ((Math.random() * 300) / 100) + 1;
        var angle:Number = Math.round(Math.random() * 360);
        var velocity:Number = Math.round(Math.random() * 600) + 200;

        addChild(view);

        TweenLite.to(view, animation_time, {physics2D: {velocity: velocity, angle: angle, gravity: 600}});
        TweenLite.to(view, 1, {alpha: 0, delay: animation_time - 1, onComplete: removeMe});

        function removeMe():void {
            removeChild(view);
        }
    }
}
}