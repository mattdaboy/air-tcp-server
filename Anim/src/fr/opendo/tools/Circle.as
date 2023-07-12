package fr.opendo.tools {
import flash.display.Sprite;

/**
 * @author Matthieu 2018
 */
public class Circle extends Sprite {
    private var _canvas:Sprite;
    private var _thickness:uint;
    private var _color:uint;
    private var _radius:uint;

    public function Circle(thickness:uint, color:uint, radius:uint) {
        _canvas = new Sprite();
        _thickness = thickness;
        _color = color;
        _radius = radius;
        addChild(_canvas);

        clear();
    }

    public function clear():void {
        _canvas.graphics.clear();
        _canvas.graphics.lineStyle(_thickness, _color);
    }

    public function draw(angle_start:int, angle_end:int):void {
        clear();
        draw_arc(_canvas, _radius, angle_start, angle_end);
    }

    private function draw_arc(s:Sprite, radius:uint, angle_start:int, angle_end:int):void {
        var angle_diff:Number = angle_end - angle_start;
        var angle:int = angle_start;
        var px:Number = radius * Math.cos(angle * Math.PI / 180);
        var py:Number = radius * Math.sin(angle * Math.PI / 180);
        s.graphics.moveTo(px, py);

        for (var i:int = 1; i <= angle_diff; i++) {
            angle = angle_start + i;
            s.graphics.lineTo(radius * Math.cos(angle * Math.PI / 180), radius * Math.sin(angle * Math.PI / 180));
        }
    }
}
}