package fr.opendo.tools {
import flash.display.DisplayObjectContainer;

/**
 * @author Matthieu 2017
 */
public class FitRectangle {
    public function FitRectangle() {
    }

    public static function McFillIn(mc:DisplayObjectContainer, x:int, y:int, w:int, h:int):void {
        var mc_ratio:Number = mc.width / mc.height;
        var zone_ratio:Number = w / h;

        if (mc_ratio <= zone_ratio) {
            mc.width = w;
            mc.scaleY = mc.scaleX;
        } else {
            mc.height = h;
            mc.scaleX = mc.scaleY;
        }
        mc.x = x + (w - mc.width) / 2;
        mc.y = y + (h - mc.height) / 2;
    }

    public static function McFitIn(mc:DisplayObjectContainer, x:int, y:int, w:int, h:int):void {
        var mc_ratio:Number = mc.width / mc.height;
        var zone_ratio:Number = w / h;

        if (mc_ratio <= zone_ratio) {
            mc.height = h;
            mc.scaleX = mc.scaleY;
        } else {
            mc.width = w;
            mc.scaleY = mc.scaleX;
        }
        mc.x = x + Math.round((w - mc.width) / 2);
        mc.y = y + Math.round((h - mc.height) / 2);
    }

    public static function McFitInNoScale(mc:DisplayObjectContainer, x:int, y:int, w:int, h:int):void {
        var mc_ratio:Number = mc.width / mc.height;
        var zone_ratio:Number = w / h;

        if (mc_ratio <= zone_ratio) {
            if (mc.height > h) mc.height = h;
            mc.scaleX = mc.scaleY;
        } else {
            if (mc.width > w) mc.width = w;
            mc.scaleY = mc.scaleX;
        }
        mc.x = x + Math.round((w - mc.width) / 2);
        mc.y = y + Math.round((h - mc.height) / 2);
    }
}
}