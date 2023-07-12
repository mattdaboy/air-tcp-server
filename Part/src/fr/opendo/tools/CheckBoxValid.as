package fr.opendo.tools {
import com.greensock.TweenLite;

import events.CustomEvent;

import flash.events.MouseEvent;

/**
 * @author matt 2021.08.31
 */
public class CheckBoxValid extends checkBoxValidView {
    public function CheckBoxValid() {
        _checked = false;
        $check.alpha = 0;

        buttonMode = true;
        mouseChildren = false;
        addEventListener(MouseEvent.CLICK, btClickHandler);
    }

    private var _checked:Boolean;

    private function btClickHandler(event:MouseEvent):void {
        _checked = !_checked;

        TweenLite.killTweensOf($check);
        if (_checked) {
            TweenLite.to($check, Const.ANIM_DURATION, {alpha: 1});
            dispatchEvent(new CustomEvent(CustomEvent.CHECKED));
        } else {
            TweenLite.to($check, Const.ANIM_DURATION, {alpha: 0});
            dispatchEvent(new CustomEvent(CustomEvent.UNCHECKED));
        }
    }
}
}