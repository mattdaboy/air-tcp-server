package fr.opendo.tools {
import com.greensock.TweenLite;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLLoader;

/**
	 * @author matt
	 */
	public class XMLPreloader extends MovieClip {
		private var _preloader : Sprite = new Sprite();
		private var _preloader_fond : Sprite = new Sprite();
		private var _preloader_barre : Sprite = new Sprite();

		public function XMLPreloader(u : URLLoader) {
			u.addEventListener(Event.OPEN, openHandler);
			u.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			u.addEventListener(Event.COMPLETE, completeHandler);
			u.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

			_preloader.alpha = 0;
			addChild(_preloader);

			_preloader_fond = new Sprite();
			_preloader_fond.graphics.beginFill(0xFFFFFF);
			_preloader_fond.graphics.drawRect(0, 0, 115, 5);
			_preloader_fond.graphics.endFill();
			_preloader_fond.alpha = 0.2;
			_preloader.addChild(_preloader_fond);

			_preloader_barre = new Sprite();
			_preloader_barre.graphics.beginFill(0xFFFFFF);
			_preloader_barre.graphics.drawRect(0, 0, 113, 3);
			_preloader_barre.graphics.endFill();
			_preloader_barre.alpha = 0.8;
			_preloader_barre.x = 1;
			_preloader_barre.y = 1;
			_preloader_barre.scaleX = 0.001;
			_preloader.addChild(_preloader_barre);
		}

		private function openHandler(e : Event) : void {
			TweenLite.to(_preloader, 2, {alpha:1, delay:0.25});
		}

		private function progressHandler(e : ProgressEvent) : void {
			var pourcent : Number = e.bytesLoaded / e.bytesTotal;
			_preloader_barre.scaleX = pourcent;
		}

		private function completeHandler(e : Event) : void {
			removeChild(_preloader);
		}

		private function ioErrorHandler(e : IOErrorEvent) : void {
		}
	}
}