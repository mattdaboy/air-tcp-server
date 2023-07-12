package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.setTimeout;

/**
 * @author matthieu
 */
public class Scroller extends Sprite {
    private var _stage:Stage;
    private var _target:MovieClip;
    private var _target_Xinit:int;
    private var _target_Yinit:int;
    private var _target_Xstart:int;
    private var _target_Ystart:int;
    private var _target_Xmove:int;
    private var _target_Ymove:int;
    private var _target_Xmin:int;
    private var _target_Xmax:int;
    private var _target_Ymin:int;
    private var _target_Ymax:int;
    private var _mouse_Xstart:int;
    private var _mouse_Ystart:int;
    private var _mouse_Xmove:int;
    private var _mouse_Ymove:int;
    private var _target_Xspeed:int;
    private var _target_Yspeed:int;
    private var _mask:Shape;
    private var _mask_w:int;
    private var _mask_h:int;
    private var _vertical:Boolean;
    private var _horizontal:Boolean;
    private var _scrollableX:Boolean;
    private var _scrollableY:Boolean;
    private static var INERTIE:uint = 6;
    private static var TIME_DECREASE:uint = 120;

    public function Scroller(stage:Stage, mc:MovieClip, w:int, h:int, vertical:Boolean = true, horizontal:Boolean = false) {
        _stage = stage;
        _target = mc;
        _mask_w = w;
        _mask_h = h;
        _vertical = vertical;
        _horizontal = horizontal;

        _target_Xinit = _target.x;
        _target_Yinit = _target.y;
        _scrollableX = false;
        _scrollableY = false;
        _target.mouseChildren = true;

        if (_horizontal && _mask_w < _target.width) {
            _scrollableX = true;
        }
        if (_vertical && _mask_h < _target.height) {
            _scrollableY = true;
        }

        if (_scrollableX || _scrollableY) {
            _mask = new Shape;
            _mask.graphics.beginFill(0x000000, 0);
            _mask.graphics.drawRect(0, 0, _mask_w, _mask_h);
            _mask.graphics.endFill();
            _mask.x = _target_Xinit;
            _mask.y = _target_Yinit;
            _target.mask = _mask;

            resetBoundaries();

            _target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }
    }

    public function update():void {
        _scrollableX = false;
        _scrollableY = false;
        _target.mouseChildren = true;

        if (_horizontal && _mask_w < _target.width) {
            _scrollableX = true;
        }
        if (_vertical && _mask_h < _target.height) {
            _scrollableY = true;
        }

        if (_scrollableX || _scrollableY) {
            if (_mask == null) {
                _mask = new Shape;
                _mask.graphics.beginFill(0x000000, 0);
                _mask.graphics.drawRect(0, 0, _mask_w, _mask_h);
                _mask.graphics.endFill();
                _mask.x = _target_Xinit;
                _mask.y = _target_Yinit;
                _target.mask = _mask;
            }

            resetBoundaries();

            if (!_target.hasEventListener(MouseEvent.MOUSE_DOWN)) _target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        } else {
            _target.mask = null;

            if (_target.hasEventListener(MouseEvent.MOUSE_DOWN)) _target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }

        _target.x = _target_Xinit;
        _target.y = _target_Yinit;
    }

    private function resetBoundaries():void {
        _target_Xmin = _target_Xinit + _mask.width - _target.width;
        _target_Xmax = _target_Xinit;
        _target_Ymin = _target_Yinit + _mask.height - _target.height;
        _target_Ymax = _target_Yinit;
    }

    private function mouseDownHandler(event:MouseEvent):void {
        TweenLite.killTweensOf(_target);

        _target_Xstart = _target.x;
        _target_Ystart = _target.y;
        _target_Xmove = _target.x;
        _target_Ymove = _target.y;

        _stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        _stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        _target.addEventListener(Event.ENTER_FRAME, enterframeHandler);

        _mouse_Xstart = _stage.mouseX;
        _mouse_Ystart = _stage.mouseY;
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        _mouse_Xmove = _stage.mouseX;
        _mouse_Ymove = _stage.mouseY;

        var deltaX:int = _mouse_Xmove - _mouse_Xstart;
        var deltaY:int = _mouse_Ymove - _mouse_Ystart;

        var targetx:int = _target_Xstart + deltaX;
        var targety:int = _target_Ystart + deltaY;

        if (_scrollableX) {
            _target.x = targetx;
        }
        if (_scrollableY) {
            _target.y = targety;
        }
    }

    private function enterframeHandler(event:Event):void {
        _target_Xspeed = _target.x - _target_Xmove;
        _target_Yspeed = _target.y - _target_Ymove;

        if (Math.abs(_target_Xspeed) > 0 || Math.abs(_target_Yspeed) > 0) {
            _target.mouseChildren = false;
        }

        _target_Xmove = _target.x;
        _target_Ymove = _target.y;
    }

    private function mouseUpHandler(event:MouseEvent):void {
        _stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        _stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        _target.removeEventListener(Event.ENTER_FRAME, enterframeHandler);

        var target_Xend:int = _target_Xmove + _target_Xspeed * INERTIE;
        var target_Yend:int = _target_Ymove + _target_Yspeed * INERTIE;

        if (target_Xend < _target_Xmin) {
            target_Xend = _target_Xmin;
        }
        if (target_Xend > _target_Xmax) {
            target_Xend = _target_Xmax;
        }

        if (target_Yend < _target_Ymin) {
            target_Yend = _target_Ymin;
        }
        if (target_Yend > _target_Ymax) {
            target_Yend = _target_Ymax;
        }

        var timeX:Number = Math.abs(_target_Xspeed / TIME_DECREASE);
        var timeY:Number = Math.abs(_target_Yspeed / TIME_DECREASE);

        TweenLite.to(_target, timeX, {x: target_Xend, ease: Power2.easeOut});
        TweenLite.to(_target, timeY, {x: target_Yend, ease: Power2.easeOut});

        setTimeout(mouseUpEnd, 100);
    }

    private function mouseUpEnd():void {
        _target.mouseChildren = true;
    }
}
}