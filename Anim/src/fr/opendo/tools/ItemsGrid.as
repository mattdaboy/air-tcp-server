package fr.opendo.tools {
import flash.geom.Point;

/**
 * @author Matthieu 2018
 */
public class ItemsGrid {
    public function ItemsGrid() {
    }

    public static function place(item_index:uint, items_by_line:uint, items_xdecal:uint, items_ydecal:uint):Point {
        var o:Point = new Point();

        var xpos:uint = item_index % items_by_line * items_xdecal;
        var ypos:uint = Math.floor(item_index / items_by_line) * items_ydecal;

        o.x = xpos;
        o.y = ypos;
        return o;
    }

    public static function placeInSpace(item_width:uint, space_width:uint, pos:Point, items_ydecal:uint):Point {
        var o:Point = new Point();

        if (pos.x + item_width > space_width) {
            o.x = 0;
            o.y = pos.y + items_ydecal;
        } else {
            o.x = pos.x;
            o.y = pos.y;
        }
        return o;
    }
}
}