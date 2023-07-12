package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

/**
 * @author matthieu
 */
public class SmoothScroller extends Sprite {
    private var _dummy:Sprite;
    private var _target:MovieClip;
    private var _target_Xinit:int;
    private var _target_Yinit:int;
    private var _target_Xmin:int;
    private var _target_Xmax:int;
    private var _target_Ymin:int;
    private var _target_Ymax:int;
    private var _xp:Number = 0;
    private var _yp:Number = 0;
    private var _bounds:Rectangle;
    private var _dummy_Xpos:Number;
    private var _dummy_Ypos:Number;
    private var _dummy_Xspeed:Number;
    private var _dummy_Yspeed:Number;
    private var _draging:Boolean;
    private var _mask:Shape;
    private var _mask_w:int;
    private var _mask_h:int;
    private var _touch_zone:MovieClip;
    private var _vertical:Boolean;
    private var _horizontal:Boolean;
    private var _scrollableX:Boolean;
    private var _scrollableY:Boolean;
    private var _guide:Shape;
    private var _target_height:Number;

    public function SmoothScroller(mc:MovieClip, w:int, h:int, vertical:Boolean = true, horizontal:Boolean = false, debug:Boolean = false) {
        _target = mc;
        if (_target.parent == null) throw new Error("!!! Le mc du scroller doit être addChild !!!");

        _target_height = _target.height;
        _mask_w = w;
        _mask_h = h;
        _vertical = vertical;
        _horizontal = horizontal;

        _dummy = new Sprite();
        _target.parent.addChild(_dummy);

        _dummy_Xpos = _target.x;
        _dummy_Ypos = _target.y;
        _target_Xinit = _target.x;
        _target_Yinit = _target.y;

        // DEBUG
        if (debug) {
            var s:Shape = new Shape;
            s.graphics.beginFill(0xFF0000, 0.5);
            s.graphics.drawRect(0, 0, _mask_w, _mask_h);
            s.graphics.endFill();
            s.x = _target_Xinit;
            s.y = _target_Yinit;
            _target.parent.addChild(s);
        }

        update();
    }

    public function update(forcedHeight:Number = 0, reinitTargetX:Boolean = true, reinitTargetY:Boolean = true, goto_endY:Boolean = false):void {
        if (forcedHeight != 0) {
            _target_height = forcedHeight;
        } else {
            _target_height = _target.height;
        }
        _scrollableX = false;
        _scrollableY = false;
        _target.mouseChildren = true;

        if (_horizontal && _mask_w < _target.width) {
            _scrollableX = true;
            if (_guide) {
                _target.parent.removeChild(_guide);
                _guide = null;
            }
        }

        if (_vertical && _mask_h < _target_height) {
            _scrollableY = true;
            createGuide();
        }

        if (_scrollableX || _scrollableY) {
            if (_mask == null) createMask();
            if (_touch_zone == null) createTouchZone();
            _target.mask = _mask;
            resetBoundaries();

            if (!_target.hasEventListener(MouseEvent.MOUSE_DOWN)) {
                _target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
                _touch_zone.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            }
        } else {
            _target.mask = null;
            _mask = null;

            if (_target.hasEventListener(MouseEvent.MOUSE_DOWN)) {
                _target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
                _touch_zone.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            }
        }
        if (_scrollableY) {
            if (!_target.hasEventListener(MouseEvent.MOUSE_WHEEL)) {
                _target.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
                _touch_zone.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
            }
        }
        if (!_scrollableY) {
            if (_target.hasEventListener(MouseEvent.MOUSE_WHEEL)) {
                _target.removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
                _touch_zone.removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
            }
            _touch_zone = null;
        }

        // reinit ou pas
        if (goto_endY && _mask) {
            if (_scrollableY) {
                TweenLite.to(_target, Const.ANIM_DURATION, {y: _target_Ymin, ease: Power2.easeOut});
                TweenLite.to(_dummy, Const.ANIM_DURATION, {y: _target_Ymin, ease: Power2.easeOut});
            } else {
                TweenLite.to(_target, Const.ANIM_DURATION, {y: _target_Yinit, ease: Power2.easeOut});
                _dummy.y = _target_Yinit;
                _target_Ymin = Math.floor(_target_Yinit + _mask.height - _target_height);
                TweenLite.killTweensOf(_guide);
                _guide.visible = false;
            }
        }
        if (!goto_endY) {
            if (reinitTargetX) {
                _target.x = _target_Xinit;
            }
            if (reinitTargetY) {
                _target.y = _target_Yinit;
            }
            _dummy.x = _target.x;
            _dummy.y = _target.y;
        }
        if (!_mask) {
            _target_Ymin = _target_Yinit;
            TweenLite.to(_target, Const.ANIM_DURATION, {y: _target_Ymin, ease: Power2.easeOut});
            TweenLite.to(_dummy, Const.ANIM_DURATION, {y: _target_Ymin, ease: Power2.easeOut});
            TweenLite.killTweensOf(_guide);
        }
    }

    private function createMask():void {
        _mask = new Shape;
        _mask.graphics.beginFill(0x000000, 0);
        _mask.graphics.drawRect(0, 0, _mask_w, _mask_h);
        _mask.graphics.endFill();
        _mask.x = _target_Xinit;
        _mask.y = _target_Yinit;
        _target.parent.addChild(_mask); /* important pour localiser (x et y) le mask */
    }

    private function createTouchZone():void {
        _touch_zone = new MovieClip;
        _touch_zone.graphics.beginFill(0x000000, 0);
        _touch_zone.graphics.drawRect(0, 0, _mask_w, _mask_h);
        _touch_zone.graphics.endFill();
        _touch_zone.x = _target_Xinit;
        _touch_zone.y = _target_Yinit;
        _touch_zone.visible = visible;
        _target.parent.addChild(_touch_zone);
        _target.parent.addChild(_target);
    }

    private function handleMouseWheel(event:MouseEvent):void {
        _dummy.y += event.delta * 10;

        if (_dummy.y < _target_Ymin) {
            _dummy.y = _target_Ymin;
        }
        if (_dummy.y > _target_Ymax) {
            _dummy.y = _target_Ymax;
        }
        _dummy_Ypos = _dummy.y;

        if (!_target.hasEventListener(Event.ENTER_FRAME)) {
            _target.addEventListener(Event.ENTER_FRAME, targetEnterframeHandler);
        }

        if (_guide != null) {
            TweenLite.to(_guide, 1, {alpha: 1, ease: Power2.easeOut});
        }
    }

    private function createGuide():void {
        if (_guide != null) {
            TweenLite.killTweensOf(_guide);
            _guide.visible = false;
        }
        _guide = new Shape;
        _guide.graphics.clear();
        _guide.graphics.beginFill(0x38D7E7, .4);
        var guide_height:uint = Math.round(_mask_h / (_target_height / _mask_h));
        _guide.graphics.drawRoundRect(0, 0, 6, guide_height, 6);
        _guide.graphics.endFill();
        _guide.x = _target_Xinit + _mask_w - 12;
        _guide.y = _target_Yinit;
        _guide.alpha = 1;
        _guide.visible = visible;
        _target.parent.addChild(_guide);
        TweenLite.to(_guide, Const.ANIM_DURATION, {alpha: 0, ease: Power2.easeOut});
    }

    private function resetBoundaries():void {
        _target_Xmin = Math.floor(_target_Xinit + _mask.width - _target.width);
        _target_Xmax = _target_Xinit;
        _target_Ymin = Math.floor(_target_Yinit + _mask.height - _target_height);
        _target_Ymax = _target_Yinit;

        if (_scrollableX && _scrollableY) {
            _bounds = new Rectangle(_target_Xmin, _target_Ymin, _target_Xmax - _target_Xmin, _target_Ymax - _target_Ymin);
        }

        if (_scrollableX && !_scrollableY) {
            _bounds = new Rectangle(_target_Xmin, _target_Ymax, _target_Xmax - _target_Xmin, 0);
        }

        if (!_scrollableX && _scrollableY) {
            _bounds = new Rectangle(_target_Xmax, _target_Ymin, 0, _target_Ymax - _target_Ymin);
        }

        if (_guide != null) {
            _target.parent.addChild(_guide);
        }
    }

    private function mouseDownHandler(event:MouseEvent):void {
        _draging = true;
        _dummy.startDrag(false, _bounds);

        Main.instance.getStage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        if (!_dummy.hasEventListener(Event.ENTER_FRAME)) {
            _dummy.addEventListener(Event.ENTER_FRAME, dummyEnterframeHandler);
        }
        if (!_target.hasEventListener(Event.ENTER_FRAME)) {
            _target.addEventListener(Event.ENTER_FRAME, targetEnterframeHandler);
        }
    }

    private function dummyEnterframeHandler(event:Event):void {
        if (_guide != null) {
            TweenLite.to(_guide, .5, {alpha: 1, ease: Power2.easeOut});
        }

        if (_draging) {
            _dummy_Xspeed = _dummy.x - _dummy_Xpos;
            _dummy_Xpos = _dummy.x;
            _dummy_Yspeed = _dummy.y - _dummy_Ypos;
            _dummy_Ypos = _dummy.y;
            if (Math.abs(_dummy_Xspeed) > 1 || Math.abs(_dummy_Yspeed) > 1) {
                _target.mouseChildren = false;
            }
        } else {
            if (Math.abs(_dummy_Xspeed) > .1 || Math.abs(_dummy_Yspeed) > .1) {
                _dummy_Xpos = _dummy.x + _dummy_Xspeed;
                _dummy_Ypos = _dummy.y + _dummy_Yspeed;
                if (_dummy_Xpos < _target_Xmin) {
                    _dummy_Xpos = _target_Xmin;
                    _dummy_Xspeed = 0;
                }
                if (_dummy_Xpos > _target_Xmax) {
                    _dummy_Xpos = _target_Xmax;
                    _dummy_Xspeed = 0;
                }
                if (_dummy_Ypos < _target_Ymin) {
                    _dummy_Ypos = _target_Ymin;
                    _dummy_Yspeed = 0;
                }
                if (_dummy_Ypos > _target_Ymax) {
                    _dummy_Ypos = _target_Ymax;
                    _dummy_Yspeed = 0;
                }
                _dummy.x = _dummy_Xpos;
                _dummy.y = _dummy_Ypos;
                _dummy_Xspeed *= 0.9;
                _dummy_Yspeed *= 0.9;
                _target.mouseChildren = false;
            } else {
                _dummy.removeEventListener(Event.ENTER_FRAME, dummyEnterframeHandler);
                if (_guide != null) {
                    TweenLite.to(_guide, .5, {alpha: 0, ease: Power2.easeIn});
                }
                _target.mouseChildren = true;
            }
        }
    }

    private function targetEnterframeHandler(event:Event):void {
        if (_draging) {
            moveTarget(_dummy.x, _dummy.y, .1, .3);
            if (_guide != null) {
                TweenLite.to(_guide, .5, {alpha: 1, ease: Power2.easeIn});
            }
        } else {
            moveTarget(_dummy.x, _dummy.y, .1, .1);
            if (_guide != null) {
                TweenLite.to(_guide, .5, {alpha: 0, ease: Power2.easeIn});
            }
        }
    }

    private function moveTarget(Xend:Number, Yend:Number, inertia:Number, spring:Number):void {
        var xgo:Number = -_target.x + Xend;
        var ygo:Number = -_target.y + Yend;

        _xp = _xp * inertia + xgo * spring;
        _yp = _yp * inertia + ygo * spring;
        if (_horizontal) {
            _target.x += _xp;
        }
        if (_vertical) {
            _target.y += _yp;
        }

        if (_guide != null) {
            _guide.y = _target_Yinit - ((_target.y - _target_Yinit) / (_target_height / _mask_h));
        }

        if (!_draging && Math.abs(_xp) < .1 && Math.abs(_yp) < .1) {
            _target.removeEventListener(Event.ENTER_FRAME, targetEnterframeHandler);
        }
    }

    private function mouseUpHandler(event:MouseEvent):void {
        Main.instance.getStage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        _target.stopDrag();
        _draging = false;
    }

    public function set scrollHeight(h:int):void {
        _mask_h = h;
        update();
    }

    override public function set visible(v:Boolean):void {
        super.visible = v;
        if (_touch_zone) _touch_zone.visible = v;
        if (_guide) _guide.visible = v;
    }

    public function setInactive():void {
        TweenLite.killTweensOf(_guide);
        _guide.alpha = 0;
        _target.removeEventListener(Event.ENTER_FRAME, targetEnterframeHandler);
    }

    public function kill():void {
        _target.removeEventListener(Event.ENTER_FRAME, targetEnterframeHandler);
        _target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        _target.removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
        if (_dummy) {
            _dummy.removeEventListener(Event.ENTER_FRAME, dummyEnterframeHandler);
            Tools.safeRemoveChild(_target.parent, _dummy)
            _dummy = null;
        }
        if (_touch_zone) {
            _touch_zone.removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
            _touch_zone.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            Tools.safeRemoveChild(_target.parent, _touch_zone);
            _touch_zone = null;
        }
        if (_mask) {
            Tools.safeRemoveChild(_target.parent, _mask)
            _mask = null;
        }
        if (_guide) {
            Tools.safeRemoveChild(_target.parent, _guide);
            _guide = null;
        }
        _target.y = _target_Yinit;
        _target.parent.addChild(_target);
    }
}
}