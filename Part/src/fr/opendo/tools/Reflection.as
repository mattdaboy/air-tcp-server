package fr.opendo.tools {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.MovieClip;
import flash.display.SpreadMethod;
import flash.geom.Matrix;
import flash.system.System;

/**
	 * @author matt
	 */
	public class Reflection extends MovieClip {
		public function Reflection() {
			// Reflection is a static class and should not be instantiated
		}

		public static function setReflection(mc : MovieClip, img_loader : DisplayObject, w : uint, h : uint, alpha : Number, gradient_end : uint) : void {
			var mcBMP : BitmapData = new BitmapData(w, h, true, 0x00FFFFFF);
			mcBMP.draw(mc);
			var reflectionBMP : Bitmap = new Bitmap(mcBMP);
			reflectionBMP.y = h * 2 + 1;
			reflectionBMP.scaleY = -1;
			mc.addChild(reflectionBMP);

			var mcSnapshot : Bitmap = new Bitmap(mcBMP);
			mcSnapshot.smoothing = true;
			mc.addChild(mcSnapshot);

			var fillType : String = GradientType.LINEAR;
			var colors : Array = [0x000000, 0x000000];
			var alphas : Array = [1, 0];
			var ratios : Array = [0, gradient_end];
			// gradient_end : 0 à 255
			var matr : Matrix = new Matrix();
			matr.createGradientBox(w, h, 90 / 180 * Math.PI, 0, 0);
			var spreadMethod : String = SpreadMethod.PAD;
			var gradientMask_mc : MovieClip = new MovieClip();
			gradientMask_mc.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			gradientMask_mc.graphics.drawRect(0, 0, w, h);
			gradientMask_mc.y = reflectionBMP.y - h;
			gradientMask_mc.alpha = alpha;
			mc.addChild(gradientMask_mc);

			reflectionBMP.cacheAsBitmap = true;
			gradientMask_mc.cacheAsBitmap = true;
			reflectionBMP.mask = gradientMask_mc;

			mc.removeChild(img_loader);
			System.gc();
		}
	}
}