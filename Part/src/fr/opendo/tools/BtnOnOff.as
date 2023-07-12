package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import events.CustomEvent;

import flash.events.MouseEvent;

/**
	 * @author noel
	 */
	public class BtnOnOff extends BtnOnOffView {
		private var _checked : Boolean;

		public function BtnOnOff(checked : Boolean = false, w : Number = 100) {
			width = w;
			height = width / 2;
			buttonMode = true;
			_checked = checked;
			if (_checked) {
				check();
			} else {
				unCheck();
			}
			addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event : MouseEvent) : void {
			if (!_checked) {
				check();
			} else {
				unCheck();
			}
			dispatchEvent(new CustomEvent(CustomEvent.BTN_CLICK, [_checked]));
		}

		public function check() : void {
			_checked = true;
			TweenLite.to($check, Const.ANIM_DURATION, {x:54, ease:Power2.easeOut});
			TweenLite.to($fondVert, Const.ANIM_DURATION, {alpha:1, ease:Power2.easeOut});
		}

		public function unCheck() : void {
			_checked = false;
			TweenLite.to($check, Const.ANIM_DURATION, {x:6, ease:Power2.easeOut});
			TweenLite.to($fondVert, Const.ANIM_DURATION, {alpha:0, ease:Power2.easeOut});
		}

		public function get checked() : Boolean {
			return _checked;
		}
	}
}