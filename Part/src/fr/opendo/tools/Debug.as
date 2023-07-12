package fr.opendo.tools {
import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * @author matthieu
 */
public class Debug extends MovieClip {
    private static var _this:Debug;
    private static var _txt:TextField;
    private static var _txt_container:Sprite;
    private static var _btClean:CustomButton;
    private static var _btCopyToClipboard:CustomButton;
    private static var _btClose:CustomButton;
    private static var _enabled:Boolean = false;

    /**
     * Note : pour utiliser cette classe, il suffit de l'instancier sur Main (juste pour lui passer stage en paramètre), puis de l'appeler de n'importe quelle classe via la fonction display.
     * Exemple : Debug.display("montexte");
     */
    public function Debug() {
        _this = this;
    }

    public static function init():void {
        _txt_container = new Sprite();
        _txt_container.x = 10;
        _txt_container.y = 10;
        _this.addChild(_txt_container);

        _txt = new TextField();
        _txt.wordWrap = true;
        _txt.background = true;
        _txt.width = 1900;
        _txt.height = 1180;
        var myFormat:TextFormat = new TextFormat();
        myFormat.size = 18;
        myFormat.font = "Arial";
        _txt.defaultTextFormat = myFormat;
        _txt_container.addChild(_txt);

        _txt_container.alpha = .6;
        _this.mouseChildren = false;
        _this.mouseEnabled = false;

        _btClean = new CustomButton("Clean", btCleanClickHandler, 100);
        _btClean.x = 1580;
        _btClean.y = 20;

        _btCopyToClipboard = new CustomButton("Copy", btCopyToClipboardClickHandler, 100);
        _btCopyToClipboard.x = 1690;
        _btCopyToClipboard.y = 20;

        _btClose = new CustomButton("Close", btCloseHandler, 100);
        _btClose.x = 1800;
        _btClose.y = 20;

        _this.visible = _enabled;
    }

    public static function show(str:String):void {
        if (_enabled) {
            var date:String = DateUtils.dateToIso(new Date());
            _txt.text = _txt.text + date + " : " + str + "\n";
            _txt.scrollV = _txt.maxScrollV;
            onTop();
        }
    }

    public static function onTop():void {
        if (_enabled) {
            Main.instance.getStage.addChild(_this);
            Main.instance.getStage.addChild(_btClean);
            Main.instance.getStage.addChild(_btCopyToClipboard);
            Main.instance.getStage.addChild(_btClose);
        }
    }

    private static function btCleanClickHandler():void {
        _txt.text = "";
    }

    private static function btCopyToClipboardClickHandler():void {
        Clipboard.generalClipboard.clear();
        Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _txt.text);
    }

    private static function btCloseHandler():void {
        hide();
        Tools.safeRemoveChild(Main.instance.getStage, _btClean);
        Tools.safeRemoveChild(Main.instance.getStage, _btCopyToClipboard);
        Tools.safeRemoveChild(Main.instance.getStage, _btClose);
        Tools.safeRemoveChild(Main.instance.getStage, _this);
    }

    private static function hide():void {
        _enabled = false;
        _this.visible = false;
        show("");
    }

    public static function activate():void {
        _enabled = true;
        _this.visible = _enabled;
    }
}
}