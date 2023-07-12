package fr.opendo.tools {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.getTimer;
import flash.utils.setInterval;

public class FpsGauge extends MovieClip {
		private const INTERVAL_DURATION : uint = 100;
		private const FPS_TAB_NB : uint = 10;
		private var _timer : uint;
		private var _fps : Number;
		private var _fps_tab : Array;
		private var _fps_total : Number;
		private var _interval : uint;
		private var _txt : TextField;

		public function FpsGauge() {
			init();
		}

		private function init() : void {
			_fps_tab = [];

			var background : Sprite = new Sprite();
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.drawRect(0, 0, 45, 45);
			background.graphics.endFill();
			addChild(background);

			_txt = new TextField();
			_txt.width = 45;
			_txt.height = 45;
			var myFormat : TextFormat = new TextFormat();
			myFormat.size = 24;
			myFormat.font = "Arial";
			myFormat.color = 0x000000;
			_txt.defaultTextFormat = myFormat;
			_txt.text = "---";
			addChild(_txt);

			_timer = getTimer();
			addEventListener(Event.ENTER_FRAME, loop);

			_interval = setInterval(fpsDisplay, INTERVAL_DURATION);
		}

		private function loop(e : Event) : void {
			var delta : uint = getTimer() - _timer;
			_fps = 1000 / delta;
			_timer = getTimer();

			if (delta != 0) {
				if (_fps_tab.length < FPS_TAB_NB) {
					_fps_tab.push(_fps);
				} else {
					_fps_tab.shift();
					_fps_tab.push(_fps);
				}
				calculateFps();
			}
		}

		private function calculateFps() : void {
			_fps_total = 0;
			for (var i : uint = 0; i < _fps_tab.length; i++) {
				_fps_total += _fps_tab[i];
			}
			_fps = _fps_total / _fps_tab.length;
		}

		private function fpsDisplay() : void {
			if (_fps > 0) _txt.text = "" + Math.round(_fps);
		}
	}
}