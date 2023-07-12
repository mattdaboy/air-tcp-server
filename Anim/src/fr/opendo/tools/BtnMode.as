package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.events.MouseEvent;

import fr.opendo.events.CustomEvent;

/**
 * @author noel
 */
public class BtnMode extends BtnModeView {
    private var _mode1_name:String;
    private var _mode2_name:String;
    private var _mode_chosen:String;
    public static const MODE1:String = "mode1";
    public static const MODE2:String = "mode2";

    public function BtnMode(mode1_name:String, mode2_name:String, mode_chosen:String = MODE1) {
        _mode1_name = mode1_name;
        _mode2_name = mode2_name;
        _mode_chosen = mode_chosen;

        $content.$mode1.text = _mode1_name;
        $content.$mode2.text = _mode2_name;

        mode = _mode_chosen;

        buttonMode = true;
        mouseChildren = false;
        addEventListener(MouseEvent.CLICK, clickHandler);
    }

    private function clickHandler(event:MouseEvent):void {
        if (_mode_chosen == MODE1) {
            _mode_chosen = MODE2;
        } else {
            _mode_chosen = MODE1;
        }
        mode = _mode_chosen;

        dispatchEvent(new CustomEvent(CustomEvent.MODE));
    }

    public function get mode():String {
        return _mode_chosen;
    }

    public function get modeName():String {
        if (_mode_chosen == MODE1) {
            return _mode1_name;
        } else {
            return _mode2_name;
        }
    }

    public function get mode2Name():String {
        return _mode2_name;
    }

    public function set mode(m:String):void {
        _mode_chosen = m;

        if (_mode_chosen == MODE1) {
            TweenLite.to($content, Const.ANIM_DURATION, {x: 0, ease: Power2.easeOut});
            TweenLite.to($check, Const.ANIM_DURATION, {x: 157, ease: Power2.easeOut});
        } else {
            TweenLite.to($content, Const.ANIM_DURATION, {x: -152, ease: Power2.easeOut});
            TweenLite.to($check, Const.ANIM_DURATION, {x: 3, ease: Power2.easeOut});
        }
    }
}
}