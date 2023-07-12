package fr.opendo.tools {
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;
import flash.utils.getTimer;
import flash.utils.setInterval;

public class FpsGauge extends MovieClip {
    private var _fps:Number;
    private var _frame_start:uint;
    private var _frame_duration:uint;
    private var _fps_tab:Array;
    private var _fps_tab_nb:uint;
    private var _fps_total:Number;
    private var _interval:uint;
    private var _interval_duration:uint;
    private var _background:MovieClip;
    private var _txt:TextField;

    public function FpsGauge() {
        init();
    }

    private function init():void {
        _interval_duration = 100;
        _fps_tab = [];
        _fps_tab_nb = 10;

        _background = new MovieClip();
        _background.graphics.beginFill(0xFFFFFF);
        _background.graphics.drawRect(0, 0, 30, 20);
        _background.graphics.endFill();
        this.addChild(_background);

        _txt = new TextField();
        _txt.width = 30;
        _txt.height = 20;
        _txt.text = "---";
        addChild(_txt);

        _frame_start = getTimer();
        addEventListener(Event.ENTER_FRAME, loop);

        _interval = setInterval(fpsDisplay, _interval_duration);
    }

    private function loop(e:Event):void {
        _frame_duration = getTimer() - _frame_start;
        _frame_start = getTimer();
        _fps = 1000 / _frame_duration;
        if (_fps_tab.length < _fps_tab_nb) {
            _fps_tab.push(_fps);
        } else {
            _fps_tab.shift();
            _fps_tab.push(_fps);
        }
        calculateFps();

        parent.addChild(this);
    }

    private function calculateFps():void {
        _fps_total = 0;
        for (var i:uint = 0; i < _fps_tab.length; i++) {
            _fps_total += _fps_tab[i];
        }
        _fps = _fps_total / _fps_tab.length;
    }

    private function fpsDisplay():void {
        _txt.text = "" + Math.round(_fps);
    }
}
}