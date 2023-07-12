package fr.opendo.tools {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;

/**
 * @author noel
 */
public class Avatar extends AvatarView {
    private var _round:uint;
    private var _bmpd:BitmapData;

    public function Avatar(r:uint = 0) {
        _round = r;
        init();
    }

    private function init():void {
        _bmpd = new BitmapData(480, 480);
        colorise(null);

        buttonMode = true;
        mouseChildren = false;
        addEventListener(MouseEvent.CLICK, colorise);

        // masque
        var masque:Sprite = new Sprite();
        masque.alpha = 0;
        masque.graphics.beginFill(0xFFFFFF);
        masque.graphics.drawRoundRect(0, 0, 480, 480, _round);
        mask = masque;
        addChild(masque);
    }

    private function colorise(event:MouseEvent):void {
        var tabColor:Array = [0x20A3BA, 0x13606E, 0xCC5435, 0x7F9CE1, 0x5671A6, 0x448FA3, 0xBA2554, 0x807959, 0xFF9D14, 0x9BB56B, 0x0E9EC9, 0xB32064, 0xB0CF40, 0xB0CF40, 0x95B536, 0x21B6D1, 0x81B39D];
        var colorTransform:ColorTransform = new ColorTransform();
        colorTransform.color = tabColor[Math.floor(Math.random() * tabColor.length)];
        $container.$background.transform.colorTransform = colorTransform;

        _bmpd.draw($container);
    }

    public function get bmpd():BitmapData {
        return _bmpd;
    }
}
}