package fr.opendo.tools {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

/**
 * @author Matt - 2021-10-12
 */
public class Button extends Sprite {
    private var _button:Sprite;
    private var _button_class:Class;
    private var _mouse_event:String;
    private var _function:Function;
    private var _enabled:Boolean;
    private var _label_str:String;
    private const ALPHA_DISABLED:Number = .25;

    /**
     * Button
     * @param button_class la classe graphique du bouton
     * @param mouse_event le mouse_event du bouton (généralement CLICK)
     * @param func la fonction à lancer suite au mouse_event
     * @param initial_enabled si le bouton n'est pas enabled, il est désactivé et grisé
     * @param label_str le texte du bouton
     */
    public function Button(button_class:Class, mouse_event:String, func:Function, initial_enabled:Boolean = true, label_str:String = "") {
        _button_class = button_class;
        _mouse_event = mouse_event;
        _function = func;
        _enabled = initial_enabled;
        _label_str = label_str;

        init();
    }

    private function init():void {
        _button = new _button_class();
        buttonMode = true;
        mouseChildren = false;
        addEventListener(_mouse_event, btClickHandler);
        enabled(_enabled);

        if (label != null) {
            label.autoSize=TextFieldAutoSize.LEFT;
            setText(_label_str);
        }

        addChild(_button);
    }

    private function labelChanged():void {
        var cliczone:DisplayObjectContainer = _button["$cliczone"] as DisplayObjectContainer;
        if (label != null && cliczone != null) {
            Tools.setClicZoneSize(label, cliczone);
        }
    }

    private function btClickHandler(event:MouseEvent):void {
        launchFunction(event);
    }

    public function setText(str:String):void {
        label.text = str;
        labelChanged();
    }

    public function launchFunction(event:MouseEvent):void {
        _function(event);
    }

    public function get label():TextField {
        var lab:TextField = TextField(_button.getChildByName("$label"));
        return lab;
    }

    public function get button():Sprite {
        return _button;
    }

    public function enabled(value:Boolean):void {
        mouseEnabled = value;
        (value) ? alpha = 1 : alpha = ALPHA_DISABLED;
    }
}
}