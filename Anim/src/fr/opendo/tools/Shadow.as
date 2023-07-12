package fr.opendo.tools {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.filters.BitmapFilterQuality;
import flash.filters.DropShadowFilter;

/**
 * @author noel
 */
public class Shadow extends Sprite {
    public function Shadow() {
    }

    public static function shadow(mc:DisplayObjectContainer, dist:Number = 30, blur:Number = 60):void {
        var shadow_filter:DropShadowFilter = new DropShadowFilter();
        shadow_filter.quality = BitmapFilterQuality.HIGH;
        shadow_filter.color = 0x000000;
        shadow_filter.alpha = .16;
        shadow_filter.angle = 90;
        shadow_filter.distance = dist;
        shadow_filter.blurX = blur;
        shadow_filter.blurY = blur;
        mc.filters = [shadow_filter];
    }
}
}