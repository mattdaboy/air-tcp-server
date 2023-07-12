package fr.opendo.tools {
	/**
	 * @author Matthieu 2017
	 */
	public class FitRectangle {
		public function FitRectangle() {
		}

		public static function Fill(mc : *, x : int, y : int, w : int, h : int) : void {
			var mc_ratio : Number = mc.width / mc.height;
			var rectangle_ratio : Number = w / h;

			if (mc_ratio <= rectangle_ratio) {
				mc.width = w;
				mc.scaleY = mc.scaleX;
			} else {
				mc.height = h;
				mc.scaleX = mc.scaleY;
			}
			mc.x = x + (w - mc.width) / 2;
			mc.y = y + (h - mc.height) / 2;
		}

		public static function FitIn(mc : *, x : int, y : int, w : int, h : int) : void {
			var mc_ratio : Number = mc.width / mc.height;
			var rectangle_ratio : Number = w / h;

			if (mc_ratio <= rectangle_ratio) {
				mc.height = h;
				mc.scaleX = mc.scaleY;
			} else {
				mc.width = w;
				mc.scaleY = mc.scaleX;
			}
			mc.x = x + Math.round((w - mc.width) / 2);
			mc.y = y + Math.round((h - mc.height) / 2);
		}
	}
}