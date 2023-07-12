package fr.opendo.tools {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * @author matthieu
 */
public class CustomButton extends MovieClip {
    private var _function:Function;

    public function CustomButton(label:String, func:Function, w:uint = 200, h:uint = 40) {
        _function = func;

        var background:Sprite = new Sprite();
        background.graphics.beginFill(0x38D7E7);
        background.graphics.drawRoundRect(0, 0, w, h, 8);
        background.graphics.endFill();
        addChild(background);

        var myFormat:TextFormat = new TextFormat();
        myFormat.size = 24;
        myFormat.font = "Arial";
        myFormat.color = 0xFFFFFF;

        var txt:TextField = new TextField();
        txt.width = w;
        txt.height = h;
        txt.defaultTextFormat = myFormat;
        txt.text = label;
        addChild(txt);

        buttonMode = true;
        mouseChildren = false;
        addEventListener(MouseEvent.CLICK, btClickHandler);
    }

    private function btClickHandler(e:MouseEvent):void {
        _function();
    }
}
}