package fr.opendo.tools {
import com.greensock.TweenLite;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

/**
 * @author Matt - 2022-08-22
 */
public class ActivationField extends Sprite {
    private var _input_text:TextField;
    private var _placeholder_text:TextField;
    private var _error_text:TextField;
    private var _error:Sprite;
    private var _placeholder:String;
    private var _restriction:String;
    private var _is_email:Boolean;
    private const BACK_COLOR:uint = 0xFFFFFF;
    private const TEXT_COLOR_OFF:uint = 0xB8B8B8;
    private const TEXT_COLOR_ON:uint = 0x4D4D4D;
    private const ERROR_COLOR:uint = 0xB2001E;

    public function ActivationField(placeholder:String = "Saisir ici", restriction:String = "", is_email:Boolean = false) {
        _placeholder = placeholder;
        _restriction = restriction;
        _is_email = is_email;

        var background:Sprite = new Sprite();
        background.graphics.beginFill(BACK_COLOR);
        background.graphics.drawRoundRect(0, 0, 720, 100, 20);
        background.graphics.endFill();
        addChild(background);

        var myFormat:TextFormat = new TextFormat();
        myFormat.size = 40;
        myFormat.font = "Roboto Bold";
        myFormat.color = TEXT_COLOR_ON;

        _placeholder_text = new TextField();
        _placeholder_text.defaultTextFormat = myFormat;
        _placeholder_text.x = 40;
        _placeholder_text.y = 22;
        _placeholder_text.width = 720 - 80;
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
        _input_text.width = 720 - 80;
        addChild(_input_text);

        // Error message and frame
        var errorFormat:TextFormat = new TextFormat();
        errorFormat.size = 20;
        errorFormat.font = "Roboto Regular";
        errorFormat.color = ERROR_COLOR;

        _error_text = new TextField();
        _error_text.defaultTextFormat = errorFormat;
        _error_text.x = 40;
        _error_text.y = 105;
        _error_text.width = 720 - 80;

        var border:Sprite = new Sprite();
        border.graphics.lineStyle(4, ERROR_COLOR);
        border.graphics.drawRoundRect(0, 0, 720, 100, 20);

        _error = new Sprite();
        _error.alpha = 0;
        _error.addChild(_error_text);
        _error.addChild(border);
        addChild(_error);

        addListeners();
    }

    private function addListeners():void {
        _input_text.addEventListener(Event.CHANGE, changeHandler);
        _input_text.addEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn);
    }

    private function onTxtFocusIn(event:FocusEvent):void {
        _input_text.removeEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn);
        _input_text.addEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut);
    }

    private function onTxtFocusOut(event:FocusEvent):void {
        _input_text.removeEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut);
        _input_text.addEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn);

        parseInputText();

        checkIfCorrect();
    }

    private function parseInputText():void {
        inputContent = Tools.replaceString(inputContent, "  ", " ");
        inputContent = Tools.trimWhitespace(inputContent);
        if (_is_email) inputContent = Tools.replaceString(inputContent, " ", "");
    }

    public function checkIfCorrect():void {
        if (inputContent == "") {
            showErrorMessage(Language.getValue("requis"));
        }

        if (inputContent != "") {
            hideErrorMessage();
            if (_is_email && !Tools.isValidEmail(inputContent)) showErrorMessage(Language.getValue("email-pas-valide"));
            if (_is_email && Tools.isValidEmail(inputContent)) hideErrorMessage();
        }
    }

    private function showErrorMessage(message:String):void {
        _error_text.text = message;
        TweenLite.to(_error, Const.ANIM_DURATION, {alpha: 1});
    }

    private function hideErrorMessage():void {
        TweenLite.to(_error, Const.ANIM_DURATION, {alpha: 0});
    }

    private function changeHandler(event:Event):void {
        hideErrorMessage();
        (inputContent == "") ? _placeholder_text.visible = true : _placeholder_text.visible = false;
        dispatchEvent(event);
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

        if (inputContent != "") re = true;
        if (_is_email && !Tools.isValidEmail(inputContent)) re = false;

        return re;
    }
}
}