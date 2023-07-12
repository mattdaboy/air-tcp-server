package fr.opendo.tools {
import flash.geom.Point;

/**
	 * @author Matthieu 2018
	 */
	public class ItemsGrid {
		public function ItemsGrid() {
		}

		public static function place(item_nb : uint, items_by_line : uint, items_xdecal : uint, items_ydecal : uint) : Point {
			var xpos : uint = item_nb % items_by_line * items_xdecal;
			var ypos : uint = Math.floor(item_nb / items_by_line) * items_ydecal;

			var o : Point = new Point();
			o.x = xpos;
			o.y = ypos;
			return o;
		}
	}
}