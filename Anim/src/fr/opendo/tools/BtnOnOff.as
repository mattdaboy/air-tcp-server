package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

/**
 * @author noel
 */
public class BtnOnOff extends BtnOnOffView {
    private var _checked:Boolean;

    public function BtnOnOff(is_checked:Boolean = false, w:Number = 100) {
        width = w;
        height = width / 2;
        buttonMode = true;
        mouseChildren = false;
        checked = is_checked;
    }

    public function check():void {
        _checked = true;
        TweenLite.to($check, Const.ANIM_DURATION, {x: 54, ease: Power2.easeOut});
        TweenLite.to($fondVert, Const.ANIM_DURATION, {alpha: 1, ease: Power2.easeOut});
        SoundManager.playSound(SoundManager.BTN_ON_OFF);
    }

    public function unCheck():void {
        _checked = false;
        TweenLite.to($check, Const.ANIM_DURATION, {x: 6, ease: Power2.easeOut});
        TweenLite.to($fondVert, Const.ANIM_DURATION, {alpha: 0, ease: Power2.easeOut});
        SoundManager.playSound(SoundManager.BTN_ON_OFF);
    }

    public function init(check:Boolean):void {
        _checked = check;
        if (_checked) {
            $check.x = 54;
            $fondVert.alpha = 1;
        } else {
            $check.x = 6;
            $fondVert.alpha = 0;
        }
    }

    public function get checked():Boolean {
        return _checked;
    }

    public function set checked(value:Boolean):void {
        _checked = value;
        if (value) {
            $check.x = 54;
            $fondVert.alpha = 1;
        } else {
            $check.x = 6;
            $fondVert.alpha = 0;
        }
    }
}
}