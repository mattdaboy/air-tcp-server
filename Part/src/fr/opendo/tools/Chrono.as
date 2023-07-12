package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.greensock.easing.Power2;

import flash.events.Event;

/**
	 * @author noel
	 */
	public class Chrono extends ChronoView {
		private var _isComplete : Boolean;
		private var _totalTime : Number;
		public var targetTime : Number;
		private var _isAnimated : Boolean;
		private var _cAnimated : Number;
		private const START_FRICTION_TIME : Number = 5;

		public function Chrono() {
		}

		public function start(time : Number) : void {
			_totalTime = time;
			targetTime = time;
			_isComplete = false;
			$label.text = String(targetTime);
			_isAnimated = false;
			_cAnimated = -1;
			anim();
		}

		private function anim() : void {
			TweenMax.to(this, _totalTime, {targetTime:0, onUpdate:updateNumber, ease:Linear.easeNone, onComplete:endAnim});
		}

		private function updateNumber() : void {
			$label.text = String(Math.round(targetTime));
			var ctime : uint = targetTime;
			if (_cAnimated != ctime && ctime <= START_FRICTION_TIME) {
				_cAnimated = ctime;
				TweenLite.to(this, Const.ANIM_DURATION, {delay:0.5, scaleX:1.5, scaleY:1.5, ease:Power2.easeOut});
				TweenLite.to(this, 0.5, {delay:0.75, scaleX:1, scaleY:1, ease:Power2.easeIn});
			}
		}

		public function get currentTime() : int {
			return targetTime;
		}

		private function endAnim() : void {
			_isComplete = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function kill() : void {
			TweenMax.killTweensOf(this);
			TweenMax.to(this, 0.3, {scaleX:0, scaleY:0, alpha:0, onComplete:removeMe});
		}

		private function removeMe() : void {
			try {
				parent.removeChild(this);
			} catch (e : Error) {
			}
		}

		public function get isComplete() : Boolean {
			return _isComplete;
		}
	}
}