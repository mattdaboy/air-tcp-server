package fr.opendo.tools {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

/**
 * @author Matthieu 2018
 */
public class OriginTo extends Sprite {
    private static var CenteredObj:Array = [];

    public function OriginTo() {
    }

    public static function center(target:DisplayObjectContainer):void {
        if (!isCentered(target)) {
            var xdecal:Number = -target.width / 2;
            var ydecal:Number = -target.height / 2;

            for (var i:uint = 0; i < target.numChildren; i++) {
                target.getChildAt(i).x += xdecal;
                target.getChildAt(i).y += ydecal;
            }

            target.x -= xdecal;
            target.y -= ydecal;

            CenteredObj.push(target);
        }
    }

    private static function isCentered(target:DisplayObjectContainer):Boolean {
        var centered:Boolean = false;

        for (var i:uint = 0; i < CenteredObj.length; i++) {
            if (target == CenteredObj[i]) {
                centered = true;
                break;
            }
        }

        return centered;
    }
}
}