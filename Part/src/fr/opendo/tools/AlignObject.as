package fr.opendo.tools {
import flash.display.DisplayObject;

/**
	 * @author noel
	 */
	public class AlignObject {
		/**
		 * alignObjectInPlaceHolder
		 *
		 * @param placeHolder la zone dans lequel l'object va se centrer et se redimensionner
		 * @param object l'objet qui va se redimensionner (en respectant son ratio) et se placer au centre du placeHolder
		 * @param resizeObject détermine si l'objet est redimensionné
		 * @param width la largeur du placeHolder si jamais celui-là est vide et qu'on veut en forcer une
		 * @param height la hauteur du placeHolder si jamais celui-là est vide et qu'on veut en forcer une

		 */
		public static function alignObjectInPlaceHolder(object : DisplayObject, placeHolder : DisplayObject, resizeObject : Boolean = true, width : Number = 0, height : Number = 0) : void {
			var w : Number;
			var h : Number;
			if (width != 0) {
				w = width;
			} else {
				w = placeHolder.width;
			}
			if (height != 0) {
				h = height;
			} else {
				h = placeHolder.height;
			}
			if (resizeObject) {
				var placeholder_ratio : Number = w / h;
				var object_ratio : Number = object.width / object.height;
				if (object_ratio <= placeholder_ratio) {
					object.height = h;
					object.scaleX = object.scaleY;
				} else {
					object.width = w;
					object.scaleY = object.scaleX;
				}
			}
			object.x = Math.round((w - object.width) / 2);
			object.y = Math.round((h - object.height) / 2);
		}
	}
}