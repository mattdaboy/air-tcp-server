package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Elastic;
import com.greensock.easing.Power2;

/**
 * @author Matt - 2022-03-25
 */
public class SelectLine extends SelectLineView {
    private var _line_height:uint;

    public function SelectLine(line_height:uint) {
        _line_height = line_height;
        init();
    }

    private function init():void {
        $line_top.height = 4;
        $line_bottom.y = _line_height - 50;
    }

    public function set position(ypos:Number):void {
        if (ypos > _line_height - 50) ypos = _line_height - 50;

        var ease_type:*;
        if (ypos > 25 && ypos < _line_height - 75) ease_type = Elastic.easeOut.config(1, 1);
        if (ypos <= 25 || ypos >= _line_height - 75) ease_type = Power2.easeOut;

        TweenLite.to($line_top, Const.ANIM_DURATION, {height: ypos + 4, ease: ease_type});
        TweenLite.to($arrow, Const.ANIM_DURATION, {y: ypos, ease: ease_type});
        TweenLite.to($line_bottom, Const.ANIM_DURATION, {y: ypos + 50 - 4, height: _line_height - ypos - 50 + 4, ease: ease_type});
    }
}
}