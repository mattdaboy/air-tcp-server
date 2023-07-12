package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Elastic;

import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

import fr.opendo.home.ViewManager;

/**
 * @author Matt - 2022-03_24
 */
public class Tooltip extends TooltipView {
    public static const RIGHT_TOP:String = "RIGHT_TOP";
    public static const RIGHT_DOWN:String = "RIGHT_DOWN";
    public static const LEFT_TOP:String = "LEFT_TOP";
    public static const LEFT_DOWN:String = "LEFT_DOWN";

    public function Tooltip(txt:String, xpos:Number, ypos:Number, position:String = RIGHT_TOP) {
        x = xpos;
        y = ypos;
        visible = false;

        Shadow.shadow(this);

        switch (position) {
            case RIGHT_TOP:
                gotoAndStop(1);
                break;
            case RIGHT_DOWN:
                gotoAndStop(2);
                break;
            case LEFT_TOP:
                gotoAndStop(3);
                break;
            case LEFT_DOWN:
                gotoAndStop(4);
                break;
        }

        $picto.mouseEnabled = false;
        $txt.mouseEnabled = false;
        $btnClose.mouseEnabled = false;
        $btnClose.mouseChildren = false;
        $circle.mouseEnabled = false;
        $circle.gotoAndPlay(2);
        $background.buttonMode = true;
        $background.addEventListener(MouseEvent.CLICK, clickHandler);

        updateLanguage(txt);
    }

    public function updateLanguage(txt:String):void {
        $txt.autoSize = TextFieldAutoSize.LEFT;
        $txt.htmlText = txt;
    }

    public function show(show_delay:uint = 0):void {
        if (!visible) {
            var start_scalex:Number = scaleX;
            var start_scaley:Number = scaleY;
            scaleX = 0;
            scaleY = 0;
            visible = true;

            TweenLite.to(this, Const.ANIM_DURATION, {scaleX: start_scalex, scaleY: start_scaley, delay: show_delay, ease: Elastic.easeOut.config(1, 1)});
        }
    }

    private function clickHandler(event:MouseEvent):void {
        hideAndLaunch();
    }

    private function hideAndLaunch():void {
        TweenLite.to(this, Const.ANIM_DURATION, {scaleX: 0, scaleY: 0, ease: Elastic.easeIn.config(1, 1), onComplete: hideAndLaunchEnd});
    }

    private function hideAndLaunchEnd():void {
        parent.removeChild(this);
    }

    public function get view():DisplayObjectContainer {
        return this;
    }

    public function get type():String {
        return ViewManager.MODAL;
    }

    public function clean():void {
    }
}
}