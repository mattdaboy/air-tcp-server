package fr.opendo.tools {
import com.greensock.TweenLite;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

/**
 * @author Matt - 2022-07-01
 */
public class InputField extends Sprite {
    private var _input_text:TextField;
    private var _placeholder_text:TextField;
    private var _placeholder:String;
    private var _restriction:String;
    private var _error:Sprite;
    private const BACK_COLOR:uint = 0xFFFFFF;
    private const TEXT_COLOR_OFF:uint = 0xB8B8B8;
    private const TEXT_COLOR_ON:uint = 0x4D4D4D;
    private const ERROR_COLOR:uint = 0xB2001E;

    public function InputField(w:uint, h:uint, placeholder:String = "Saisir ici", restriction:String = "") {
        _placeholder = placeholder;
        _restriction = restriction;

        var background:Sprite = new Sprite();
        background.graphics.beginFill(BACK_COLOR);
        background.graphics.drawRoundRect(0, 0, w, h, 20);
        background.graphics.endFill();
        addChild(background);

        var myFormat:TextFormat = new TextFormat();
        myFormat.size = 30;
        myFormat.font = "RobotoBold";
        myFormat.color = TEXT_COLOR_ON;

        _placeholder_text = new TextField();
        _placeholder_text.defaultTextFormat = myFormat;
        _placeholder_text.x = 40;
        _placeholder_text.y = 22;
        _placeholder_text.width = w - 80;
        _placeholder_text.textColor = TEXT_COLOR_OFF;
        _placeholder_text.text = _placeholder;
        addChild(_placeholder_text);

        _input_text = new TextField();
        _input_text.defaultTextFormat = myFormat;
        _input_text.selectable = true;
        _input_text.type = TextFieldType.INPUT;
        if (_restriction != "") _input_text.restrict = _restriction;
        _input_text.x = 40;
        _input_text.y = 22;
        _input_text.width = w - 80;
        addChild(_input_text);

        // Error frame
        var border:Sprite = new Sprite();
        border.graphics.lineStyle(4, ERROR_COLOR);
        border.graphics.drawRoundRect(0, 0, w, h, 20);

        _error = new Sprite();
        _error.alpha = 0;
        _error.addChild(border);
        addChild(_error);

        addListeners();
    }

    private function addListeners():void {
        _input_text.addEventListener(Event.CHANGE, changeHandler);
    }

    private function changeHandler(event:Event):void {
        (_input_text.text == "") ? _placeholder_text.visible = true : _placeholder_text.visible = false;
        dispatchEvent(event);
    }

    private function parseInputText():void {
        inputContent = Tools.replaceString(inputContent, "  ", " ");
        inputContent = Tools.trimWhitespace(inputContent);
    }

    public function checkIfCorrect():void {
        if (inputContent == "") {
            showErrorMessage();
        }

        if (inputContent != "") {
            hideErrorMessage();
        }
    }

    private function showErrorMessage():void {
        TweenLite.to(_error, Const.ANIM_DURATION, {alpha: 1});
    }

    private function hideErrorMessage():void {
        TweenLite.to(_error, Const.ANIM_DURATION, {alpha: 0});
    }

    public function get placeHolder():String {
        return _placeholder;
    }

    public function get inputContent():String {
        return _input_text.text;
    }

    public function set inputContent(str:String):void {
        _input_text.text = str;
        (_input_text.text == "") ? _placeholder_text.visible = true : _placeholder_text.visible = false;
    }

    public function get isCorrect():Boolean {
        var re:Boolean = false;

        parseInputText();

        if (_input_text.text != "") re = true;

        return re;
    }
}
}