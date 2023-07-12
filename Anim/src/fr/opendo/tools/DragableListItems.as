package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

/**
 * @author Matthieu
 */
public class DragableListItems extends MovieClip {
    private var _bt_of_draging_item:MovieClip;
    private var _items_container:MovieClip;
    private var _items_array:Array;
    private var _positions_array:Array;
    private var _timeout:uint;
    private var _grabing:Boolean = false;
    private var _current_item_to_replace:MovieClip;
    private var _function:Function;
    private var _args:*;
    private var _start_index:uint;
    private var _finish_index:uint;
    private var _start_scale:Number;

    public function DragableListItems() {
    }

    public function initContainer(m:MovieClip, f:Function = null, ...args):void {
        _items_container = m;
        _function = f;
        _args = args;
        _items_array = [];
        _positions_array = [];
    }

    public function addItem(m:MovieClip, bt:MovieClip, event_type:String, event_function:Function):void {
        _items_array.push([m, bt, event_type, event_function]);
        _positions_array.push(new Point(m.x, m.y));

        bt.addEventListener(MouseEvent.MOUSE_DOWN, btDownHandler);
        bt.addEventListener(MouseEvent.MOUSE_OUT, btOutHandler);
    }

    private function btOutHandler(e:MouseEvent):void {
        clearTimeout(_timeout);
    }

    public function removeItem(m:MovieClip, bt:MovieClip):void {
        var index:uint = getIndexFromArray(m);
        _items_array.splice(index, 1);
        _positions_array.splice(index, 1);

        bt.removeEventListener(MouseEvent.MOUSE_DOWN, btDownHandler);
    }

    // Fonctions du BT
    private function btDownHandler(e:MouseEvent):void {
        _bt_of_draging_item = e.currentTarget as MovieClip;
        _timeout = setTimeout(grab, 200, e.currentTarget);
        Main.instance.getStage.addEventListener(MouseEvent.MOUSE_UP, btUpHandler);
    }

    private function btUpHandler(e:MouseEvent):void {
        Main.instance.getStage.removeEventListener(MouseEvent.MOUSE_UP, btUpHandler);
        clearTimeout(_timeout);
        if (_grabing) {
            _grabing = false;
            var item:MovieClip = getParentFromBt(_bt_of_draging_item);
            item.stopDrag();
            TweenLite.to(item, Const.ANIM_DURATION, {
                alpha: 1,
                scaleX: _start_scale,
                scaleY: _start_scale,
                ease: Power2.easeOut
            });

            item.removeEventListener(Event.ENTER_FRAME, enterframeHandler);
            itemsPlace(null);

            _finish_index = getIndexFromArray(item);
            _function.apply(null, [item, _start_index, _finish_index]);

            var event_type:String = getEventTypeFromBt(_bt_of_draging_item);
            var event_function:Function = getEventFunctionFromBt(_bt_of_draging_item);
            setTimeout(addClick, 10, _bt_of_draging_item, event_type, event_function);
        }
    }

    private function addClick(bt:MovieClip, event_type:String, event_function:Function):void {
        bt.addEventListener(event_type, event_function);
    }

    private function removeClick(bt:MovieClip, event_type:String, event_function:Function):void {
        bt.removeEventListener(event_type, event_function);
    }

    public function updatePositions():void {
        _positions_array = [];
        for (var i:uint = 0; i < _items_array.length; i++) {
            _positions_array.push(new Point(_items_array[i][0].x, _items_array[i][0].y));
        }
    }

    private function grab(bt:MovieClip):void {
        updatePositions();

        _grabing = true;

        var item:MovieClip = getParentFromBt(bt);
        _start_scale = item.scaleX;
        item.startDrag();
        TweenLite.to(item, Const.ANIM_DURATION, {
            alpha: .5,
            scaleX: _start_scale * 1.05,
            scaleY: _start_scale * 1.05,
            ease: Power2.easeOut
        });

        startDraggable(item);

        var event_type:String = getEventTypeFromBt(bt);
        var event_function:Function = getEventFunctionFromBt(bt);
        removeClick(bt, event_type, event_function);
    }

    private function startDraggable(m:MovieClip):void {
        _items_container.addChild(m);
        _start_index = getIndexFromArray(m);
        m.addEventListener(Event.ENTER_FRAME, enterframeHandler);
    }

    private function enterframeHandler(e:Event):void {
        var draging_item:MovieClip = e.currentTarget as MovieClip;
        for (var i:uint = 0; i < _items_array.length; i++) {
            var item:MovieClip = _items_array[i][0];
            if (draging_item != item) {
                var mouse_posx:int = _items_container.mouseX + draging_item.width / 2;
                var mouse_posy:int = _items_container.mouseY + draging_item.height / 2;
                if (mouse_posx > item.x && mouse_posx < (item.x + item.width) && mouse_posy > item.y && mouse_posy < (item.y + item.height)) {
                    if (_current_item_to_replace != item) {
                        _current_item_to_replace = item;
                        insertItemIntoTab(draging_item, item);
                        return;
                    }
                }
            }
        }
    }

    private function insertItemIntoTab(draging_item:MovieClip, item_to_replace:MovieClip):void {
        for (var i:uint = 0; i < _items_array.length; i++) {
            if (draging_item == _items_array[i][0]) {
                var a:Array = _items_array[i];
                var a_index:uint = i;
            }
            if (item_to_replace == _items_array[i][0]) {
                var b_index:uint = i;
            }
        }
        if (b_index > a_index) {
            _items_array.splice(b_index + 1, 0, a);
            _items_array.splice(a_index, 1);
        } else {
            _items_array.splice(a_index, 1);
            _items_array.splice(b_index, 0, a);
        }
        itemsPlace(draging_item);
    }

    private function itemsPlace(m:MovieClip):void {
        for (var i:uint = 0; i < _items_array.length; i++) {
            var item:MovieClip = _items_array[i][0];
            if (m != null && m == item) {
            } else {
                TweenLite.to(item, Const.ANIM_DURATION, {
                    x: _positions_array[i].x,
                    y: _positions_array[i].y,
                    ease: Power2.easeInOut,
                    onComplete: function ():void {
                        _current_item_to_replace = null;
                    }
                });
            }
        }
    }

    public function positionArrayReset():void {
        for (var i:uint = 0; i < _items_array.length; i++) {
            var item:MovieClip = _items_array[i][0];
            _positions_array[i] = new Point(item.x, item.y);
        }
    }

    // Fonctions outils
    private function getParentFromBt(bt:MovieClip):MovieClip {
        var parent:MovieClip;
        for (var i:uint = 0; i < _items_array.length; i++) {
            if (bt == _items_array[i][1]) {
                parent = _items_array[i][0];
            }
        }
        return parent;
    }

    private function getEventTypeFromBt(bt:MovieClip):String {
        var mouse_event:String;
        for (var i:uint = 0; i < _items_array.length; i++) {
            if (bt == _items_array[i][1]) {
                mouse_event = _items_array[i][2];
            }
        }
        return mouse_event;
    }

    private function getEventFunctionFromBt(bt:MovieClip):Function {
        var function_event:Function;
        for (var i:uint = 0; i < _items_array.length; i++) {
            if (bt == _items_array[i][1]) {
                function_event = _items_array[i][3];
            }
        }
        return function_event;
    }

    public function getIndexFromArray(m:MovieClip):uint {
        var index:uint;
        for (var i:uint = 0; i < _items_array.length; i++) {
            if (m == _items_array[i][0]) {
                index = i;
            }
        }
        return index;
    }

    // Clean toutes les fonctions et écouteurs
    public function clean():void {
        Main.instance.getStage.removeEventListener(MouseEvent.MOUSE_UP, btUpHandler);
        clearTimeout(_timeout);
        if (_items_array) {
            for (var i:uint = 0; i < _items_array.length; i++) {
                var bt:MovieClip = _items_array[i][1];
                bt.removeEventListener(MouseEvent.MOUSE_DOWN, btDownHandler);
            }
            _items_array = [];
            _positions_array = [];
            _current_item_to_replace = null;
        }
    }

    // active / inactive
    public function setInactive():void {
        Main.instance.getStage.removeEventListener(MouseEvent.MOUSE_UP, btUpHandler);
        for (var i:uint = 0; i < _items_array.length; i++) {
            var bt:MovieClip = _items_array[i][1];
            bt.removeEventListener(MouseEvent.MOUSE_DOWN, btDownHandler);
        }
    }

    public function setActive():void {
        for (var i:uint = 0; i < _items_array.length; i++) {
            var bt:MovieClip = _items_array[i][1];
            bt.addEventListener(MouseEvent.MOUSE_DOWN, btDownHandler);
        }
    }

    public function disableItem(item:MovieClip):void {
        for (var i:uint = 0; i < _items_array.length; i++) {
            var bt:MovieClip = _items_array[i][0];
            if (item == bt) {
                bt.removeEventListener(MouseEvent.MOUSE_DOWN, btDownHandler);
            }
        }
    }
}
}