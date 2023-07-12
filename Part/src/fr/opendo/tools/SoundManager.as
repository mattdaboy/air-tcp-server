package fr.opendo.tools {
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.media.Sound;
import flash.net.URLRequest;

/**
 * @author noel
 */
public class SoundManager {
    public static const BTN_CLOSE:String = "btn_close.mp3";
    public static const DIALOGBOX:String = "dialogbox.mp3";
    public static const BTN_OK:String = "btn_ok.mp3";
    public static const BTN_CANCEL:String = "btn_cancel.mp3";
    public static const BTN_ON_OFF:String = "btn_on_off.mp3";
    public static const BTN_TAB:String = "btn_tab.mp3";
    public static const MODAL:String = "modal.mp3";
    public static const ROCKET:String = "rising.mp3";
    public static const OPEN_ACTIVITY:String = "open_activity2.mp3";
    public static const CLOSE_ACTIVITY:String = "close_activity.mp3";
    public static const CAPTURE:String = "flash.mp3";
    public static const BANNER:String = "banner.mp3";
    public static const TRANSITION_POPUP:String = "";
    private static var _active:Boolean = false;

    public static function playSound(value:String):void {
        if (_active) {
            var sound:Sound = new Sound();
            sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            sound.load(new URLRequest(Const.ASSETS_DIR + File.separator + value));
            sound.play();
        }
    }

    public static function init(value:Boolean):void {
        setActive(value);
    }

    public static function setActive(value:Boolean):void {
        _active = value;
    }

    public function SoundManager() {
        throw new Error("!!! SoundManager est un singleton et ne peut pas être instancié !!!");
    }

    private static function onIOError(event:IOErrorEvent):void {
    }
}
}