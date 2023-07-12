package fr.opendo.tools {
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;

/**
 * @author Matt - 2022-05-03
 */
public class PreloaderCircle extends MovieClip {
    private var _circle_mask:Sprite;

    public function PreloaderCircle() {
        var _circle:Shape = new Shape();
        _circle.graphics.lineStyle(256, 0xEE316B);
        _circle.graphics.drawCircle(0, 0, 300);
        _circle.graphics.endFill();
        addChild(_circle);

        _circle_mask = new Sprite();
        _circle_mask.alpha = .5;
        _circle_mask.x = _circle.x;
        _circle_mask.y = _circle.y;
        addChild(_circle_mask);
        _circle.mask = _circle_mask;

        drawMask(0);
    }

    public function update(part:uint, total:uint):void {
        drawMask(part / total);
    }

    private function drawMask(percent:Number):void {
        graphics.clear();
        _circle_mask.graphics.clear();
        _circle_mask.graphics.beginFill(0);
        Tools.drawPieMask(_circle_mask.graphics, percent, 500, 0, 0, (-(Math.PI) / 2));
        _circle_mask.graphics.endFill();
    }

    public function clear():void {
    }
}
}