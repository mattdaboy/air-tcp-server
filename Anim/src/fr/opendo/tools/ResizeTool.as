package fr.opendo.tools {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import fr.opendo.events.CustomEvent;

/**
 * @author Matt - 2022-11-27
 */
public class ResizeTool extends Sprite {
    private var _mc:Sprite;
    private var _parent_mc:Sprite;
    private var _mc_scalex:Number;
    private var _mc_scaley:Number;
    private var _mc_center_to_button_width:Number;
    private var _mc_center_to_button_height:Number;
    private var _button:Sprite;
    private var _center:Point;
    private var _bounds:Rectangle;
    private var _guide:Sprite;
    private var _center_guide:Sprite;
    private var _slider:Sprite;
    private var _minimum_distance_from_center:Number;
    private var _maximum_distance_from_center:Number;
    private var _distance_from_center_to_mouse:Number;
    private var _scale:Number;
    private var _min_scale:Number;
    private var _max_scale:Number;
    private const MIN_SCALE:Number = .5;
    private const MAX_SCALE:Number = 3;

    /**
     * ResizeTool
     * @param mc le Sprite à redimensionner
     * @param button le bouton dans le sprite qui déclenche le redimensionnement (placé à priori en bas à droite)
     * @param center le centre d'homothétie
     * @param min_scale le redimensionnement minimum (défaut 0.5)
     * @param max_scale le redimensionnement maximum (défaut 3)
     */
    public function ResizeTool(mc:Sprite, button:Sprite, center:Point, min_scale:Number = MIN_SCALE, max_scale:Number = MAX_SCALE) {
        _mc = Sprite(mc);
        _button = Sprite(button);
        _center = center;
        _min_scale = min_scale;
        _max_scale = max_scale;

        init();
    }

    private function addedHandler(event:Event):void {
        init();
    }

    private function init():void {
        mouseEnabled = false;
        mouseChildren = false;

        _minimum_distance_from_center = Math.sqrt(Math.pow((_button.x - _center.x) * MIN_SCALE, 2) + Math.pow((_button.y - _center.y) * MIN_SCALE, 2));
        _maximum_distance_from_center = Math.sqrt(Math.pow((_button.x - _center.x) * MAX_SCALE, 2) + Math.pow((_button.y - _center.y) * MAX_SCALE, 2));

        // _center_guide utilisé pour le débug (A COMMENTER EN PROD)
//        _center_guide = new Sprite();
//        _center_guide.graphics.beginFill(0x38D7E7);
//        _center_guide.graphics.drawRoundRect(-2, -2, 4, 4, 4);
//        _center_guide.graphics.endFill();
//        addChild(_center_guide);

        // _guide utilisé pour le débug (A COMMENTER EN PROD)
//        _guide = new Sprite();
//        _guide.graphics.beginFill(0x38D7E7);
//        _guide.graphics.drawRect(_minimum_distance_from_center, 0, _maximum_distance_from_center - _minimum_distance_from_center, 1);
//        _guide.graphics.endFill();
//        addChild(_guide);

        _slider = new Sprite();
        _slider.graphics.beginFill(0x38D7E7);
        _slider.graphics.drawRect(0, 0, 0, 0);
        _slider.graphics.endFill();
        addChild(_slider);

        _button.buttonMode = true;
        _button.mouseChildren = false;
        _button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
    }

    private function placeTool():void {
        _mc_scalex = _mc.scaleX;
        _mc_scaley = _mc.scaleY;
        _mc_center_to_button_width = _button.x * _mc_scalex - _center.x * _mc_scalex;
        _mc_center_to_button_height = _button.y * _mc_scalex - _center.y * _mc_scaley;

        var angle_from_center_to_button:Number = Math.atan((_mc_center_to_button_height) / (_mc_center_to_button_width)) * (180 / Math.PI);
        _distance_from_center_to_mouse = Math.sqrt(Math.pow(_mc.mouseX * _mc_scalex - _center.x * _mc_scalex, 2) + Math.pow(_mc.mouseY * _mc_scaley - _center.y * _mc_scaley, 2));
        rotation = angle_from_center_to_button;
        x = _mc.x + _center.x * _mc_scalex;
        y = _mc.y + _center.y * _mc_scaley;

        _slider.x = _distance_from_center_to_mouse;
        _slider.y = -_slider.height / 2;

        _bounds = new Rectangle(_minimum_distance_from_center, _slider.y, _maximum_distance_from_center - _minimum_distance_from_center, 0);
    }

    private function mouseDownHandler(event:MouseEvent):void {
        _button.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        Main.instance.getStage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        _parent_mc = Sprite(_mc.parent);
        _parent_mc.addChild(this);
        placeTool();
        _slider.startDrag(true, _bounds);
        addEventListener(Event.ENTER_FRAME, enterframeHandler);
    }

    private function enterframeHandler(event:Event):void {
        var slider_x:Number = _slider.x + _mc_center_to_button_width;
        var slider_y:Number = _slider.y + _mc_center_to_button_height;
        var distance_from_center_to_mouse:Number = Math.sqrt(Math.pow(slider_x - _mc_center_to_button_width, 2) + Math.pow(slider_y - _mc_center_to_button_height, 2));
        _scale = distance_from_center_to_mouse / _distance_from_center_to_mouse;
        scaleAroundPoint(_mc, _center.x, _center.y, _mc_scalex * _scale, _mc_scaley * _scale);
    }

    private function mouseUpHandler(event:MouseEvent):void {
        Main.instance.getStage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        _button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        removeEventListener(Event.ENTER_FRAME, enterframeHandler);
        _slider.stopDrag();
        _parent_mc.removeChild(this);
        _mc.dispatchEvent(new CustomEvent(CustomEvent.MOUSE_UP, [_mc_scalex * _scale]));
    }

    private function scaleAroundPoint(object:DisplayObject, offsetX:Number, offsetY:Number, absScaleX:Number, absScaleY:Number):void {
        var relScaleX:Number = absScaleX / object.scaleX;
        var relScaleY:Number = absScaleY / object.scaleY;
        var AC:Point = new Point(offsetX, offsetY);
        AC = object.localToGlobal(AC);
        AC = object.parent.globalToLocal(AC);
        var AB:Point = new Point(object.x, object.y);
        var CB:Point = AB.subtract(AC);
        CB.x *= relScaleX;
        CB.y *= relScaleY;
        AB = AC.add(CB);
        object.scaleX *= relScaleX;
        object.scaleY *= relScaleY;
        object.x = AB.x;
        object.y = AB.y;
    }
}
}