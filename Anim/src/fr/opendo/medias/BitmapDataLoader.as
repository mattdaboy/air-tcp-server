package fr.opendo.medias {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;

/**
 * @author matt
 * version : 2.0
 */
public class BitmapDataLoader extends MovieClip {
    private var _bmpd:BitmapData;
    private var _w:uint;
    private var _h:uint;
    public var _round:uint;

    public function BitmapDataLoader(bmpd:BitmapData, w:uint = 0, h:uint = 0, r:uint = 0) {
        _bmpd = bmpd;
        _w = w;
        _h = h;
        _round = r;

        var bmp:Bitmap = new Bitmap(_bmpd);
        bmp.width = _w;
        bmp.height = _h;
        addChild(bmp);

        // masque
        var masque:Sprite = new Sprite();
        masque.graphics.beginFill(0x000000);
        masque.graphics.drawRoundRect(0, 0, _w, _h, _round);
        bmp.mask = masque;
        addChild(masque);
    }

    public function get bmpd():BitmapData {
        return _bmpd;
    }
}
}