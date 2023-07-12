package fr.opendo.tools {
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
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
    public static const ROCKET:String = "go.mp3";
    public static const OPEN_ACTIVITY:String = "open_activity2.mp3";
    public static const CLOSE_ACTIVITY:String = "close_activity.mp3";
    public static const ADD_NEW_ACTIVITY:String = "add_activity.mp3";
    public static const CAPTURE:String = "flash.mp3";
    public static const BANNER:String = "banner.mp3";
    public static const OPEN_TRANSITION:String = "open_transition1.mp3";
    public static const CLOSE_TRANSITION:String = "close_transition1.mp3";
    public static const START_SEANCE:String = "transition2.mp3";
    public static const BTN_SELECT:String = "btn_select.mp3";
    public static const HOME:String = "home.mp3";
    public static const BTN_ADD_ITEM:String = "btn_add_item.mp3";
    public static const BTN_OPEN_CONTEXTUAL_MENU:String = "btn_open_contextual_menu.mp3";
    public static const BTN_CLOSE_CONTEXTUAL_MENU:String = "btn_close_contextual_menu.mp3";
    public static const JINGLE1:String = "jingle1.mp3";
    public static const BTN_NAVIGATION_FW:String = "btn_navigation_fw.mp3";
    public static const BTN_NAVIGATION_REW:String = "btn_navigation_rew.mp3";
    public static const BTN_RESULTATS:String = "btn_resultats.mp3";
    public static const BTN_CLASSEMENT:String = "btn_classement.mp3";
    public static const CARD_REVEAL:String = "card_reveal.mp3";
    public static const TIMER_END:String = "timer_end.mp3";
    public static const MOVEMENT:String = "movement1.mp3";
    // activités
    public static const PART_HIT:String = "question_hit.mp3";
    public static const YOU_WIN:String = "you_win1.mp3";
    public static const YOU_LOSE:String = "you_lose.mp3";
    public static const PART_MESSAGE:String = "part_message2.mp3";
    public static const DELETE_ITEM:String = "delete_item.mp3";
    public static const RECREATE_NUAGE:String = "recreate_nuage.mp3";
    public static const TICK_TACK:String = "tick_tack.mp3";
    public static const PHOTO_FLASH:String = "photo_flash.mp3";
    public static const END_GAME:String = "end_game1.mp3";
    public static const START_GAME_LOOP:String = "start_game_loop.mp3";
    public static const BUZZ:String = "buzz.mp3";
    public static const PODIUM:String = "podium.mp3";
    public static const TIMER_STEP:String = "timer_step.mp3";
    public static const PUZZLE_HIT:String = "puzzle_hit.mp3";
    public static const BTN_RANDOM:String = "btn_random.mp3";
    //
    private static var _active:Boolean = false;

    private static var _sounds_vector:Vector.<Object> = new Vector.<Object>();

    public function SoundManager() {
        throw new Error("!!! SoundManager est un singleton et ne peut pas être instancié !!!");
    }

    public static function playSound(value:String, loops:uint = 0):void {
        if (_active) {
            var sound:Sound = new Sound();
            var sound_file:File = File.applicationStorageDirectory.resolvePath(Const.ASSETS_DIR + File.separator + Const.SOUND_KIT_DIR + File.separator + value);
            sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            sound.load(new URLRequest(sound_file.url));

            var channel:SoundChannel = new SoundChannel();
            channel = sound.play(0, loops);

            var obj:Object = {id: value, channel: channel};
            _sounds_vector.push(obj);
        }
    }

    public static function stopSound(id:String):void {
        var channel:SoundChannel = getSoundChannelById(id);
        if (channel) channel.stop();
        deleteSoundChannelById(id);
    }

    public static function setLowVolume(id:String):void {
        var channel:SoundChannel = getSoundChannelById(id);
        var sound:SoundTransform = new SoundTransform();
        sound.volume = .2;
        if (channel) channel.soundTransform = sound;
    }

    public static function setHighVolume(id:String):void {
        var channel:SoundChannel = getSoundChannelById(id);
        var sound:SoundTransform = new SoundTransform();
        sound.volume = 1;
        if (channel) channel.soundTransform = sound;
    }

    private static function getSoundChannelById(id:String):SoundChannel {
        for each (var sound_in_vector:Object in _sounds_vector) {
            if (sound_in_vector.id == id) return sound_in_vector.channel;
        }
        return null;
    }

    private static function deleteSoundChannelById(id:String):void {
        for (var i:int = _sounds_vector.length - 1; i >= 0; i--) {
            if (_sounds_vector[i].id == id) {
                _sounds_vector.splice(i, 1);
            }
        }
    }

    public static function init(value:Boolean):void {
        setActive(value);
    }

    public static function setActive(value:Boolean):void {
        _active = value;
    }

    private static function onIOError(event:IOErrorEvent):void {
    }
}
}