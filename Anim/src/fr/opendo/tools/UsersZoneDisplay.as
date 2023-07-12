package fr.opendo.tools {
import flash.display.Sprite;

/**
 * @author Matt - 2022-10-06
 */
public class UsersZoneDisplay extends Sprite {

    public function UsersZoneDisplay() {
    }

    public static function compute(cont_num:uint, no_scale:Boolean = true, h:uint = 880):Object {
        // Règles de disposition des items dans le container
        var ratio:Number = 1.9;
        var H:Number = Math.sqrt(cont_num / ratio);
        var L:Number = H * ratio;
        var items_by_line:uint = Math.round(L);

        // Dimensions du container
        var container_width:Number = Math.min(cont_num, items_by_line) * 336 + (Math.min(cont_num, items_by_line) - 1) * (360 - 336);
        var container_height:Number = Math.ceil(cont_num / items_by_line) * 400;

        // Création d'un dummy aux dimensions du container
        var dummy:Sprite = new Sprite();
        dummy.graphics.beginFill(0x38D7E7);
        dummy.graphics.drawRect(0, 0, container_width, container_height);
        dummy.graphics.endFill();

        // Redimensionnement du dummy dans l'espace imparti
        var x:uint = 80;
        var y:uint = 240;
        var w:uint = 1760;
        if (no_scale) FitRectangle.McFitInNoScale(dummy, x, y, w, h);
        if (!no_scale) FitRectangle.McFitIn(dummy, x, y, w, h);

        var obj:Object = {items_by_line: items_by_line, dummy: dummy};

        return obj;
    }
}
}