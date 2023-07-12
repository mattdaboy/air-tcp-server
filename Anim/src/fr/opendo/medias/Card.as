package fr.opendo.medias {
import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;

/**
 * @author matthieu
 */
public class Card extends Sprite {
    private var _w:Number;
    private var _h:Number;
    private var _background:Sprite;
    private var _border:Sprite;

    public function Card(w:Number, h:Number) {
        _w = w;
        _h = h;
        init();
    }

    private function init():void {
        _background = new Sprite();
        _background.graphics.beginFill(0x38D7E7);
        _background.graphics.drawRoundRect(-_w / 2, -_h / 2, _w, _h, 40);
        _background.graphics.endFill();
        addChild(_background);

        _border = new Sprite();
        _border.graphics.lineStyle(4, 0xFFFFFF);
        _border.graphics.drawRoundRect(-_w / 2, -_h / 2, _w, _h, 40);
        addChild(_border);
    }

    public function setTexture(img_file:File):void {
        var img_loader:ImageLoader = new ImageLoader(ImageLoader.FILL, 960, 600, 40);
        img_loader.addEventListener(Event.COMPLETE, imgComplete);
        img_loader.load(img_file.url);

        function imgComplete(e:Event):void {
            var bmp:BitmapDataLoader = new BitmapDataLoader(img_loader.bitmapData, _w, _h, 40);
            bmp.x = -_w / 2;
            bmp.y = -_h / 2;
            addChild(bmp);
            addChild(_border);
        }
    }
}
}