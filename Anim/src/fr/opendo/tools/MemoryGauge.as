package fr.opendo.tools {
import flash.display.MovieClip;
import flash.system.System;
import flash.text.TextField;
import flash.utils.setInterval;

public class MemoryGauge extends MovieClip {
    private var _interval:uint;
    private var _interval_duration:uint;
    private var _background:MovieClip;
    private var _txt:TextField;

    public function MemoryGauge() {
        init();
    }

    private function init():void {
        _interval_duration = 500;

        _background = new MovieClip();
        _background.graphics.beginFill(0xFFFFFF);
        _background.graphics.drawRect(0, 0, 30, 20);
        _background.graphics.endFill();
        addChild(_background);

        _txt = new TextField();
        _txt.width = 30;
        _txt.height = 20;
        _txt.text = "---";
        addChild(_txt);

        _interval = setInterval(memoryDisplay, _interval_duration);
    }

    private function memoryDisplay():void {
        _txt.text = "" + Math.round(System.totalMemory / 1000000);
        parent.addChild(this);
    }
}
}