package fr.opendo.tools {
import com.greensock.TweenLite;

/**
 * @author noel
 */
public class Chrono extends ChronoView {
    private var _currentTime:Number;

    public function Chrono() {
    }

    public function start(time:Number):void {
        if (time >= 1) {
            _currentTime = time;
            TweenLite.killTweensOf($aiguille);
            $aiguille.rotation = 0;
            anim();
        } else {
            stop();
        }
    }

    private function anim():void {
        TweenLite.to($aiguille, _currentTime, {rotation: 360});
    }

    override public function stop():void {
        TweenLite.killTweensOf($aiguille);
        $aiguille.rotation = 0;
    }

    public function pause():void {
        TweenLite.killTweensOf($aiguille);
    }
}
}