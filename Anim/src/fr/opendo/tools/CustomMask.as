package fr.opendo.tools {
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;

/**
 * @author matthieu
 */
public class CustomMask extends Sprite {
    private static var _target:DisplayObject;
    private static var _rect:Shape;

    public function CustomMask() {
    }

    public static function setMask(target:*, x:uint, y:uint, w:uint, h:uint, r:uint = 0):void {
        _target = DisplayObject(target);
        _rect = new Shape();
        _rect.graphics.beginFill(0x367ACC, 0);
        _rect.graphics.drawRoundRect(x, y, w, h, r);
        _rect.graphics.endFill();
        _target.parent.addChild(_rect);
        _target.mask = _rect;
    }
}
}