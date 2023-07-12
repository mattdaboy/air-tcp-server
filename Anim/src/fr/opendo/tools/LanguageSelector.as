package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import fr.opendo.data.DataManager;
import fr.opendo.home.abonnement.ActivationPage;

public class LanguageSelector extends LanguageSelectorView {
    private var _btnLangues:Vector.<MovieClip>;
    private var _activationPage:ActivationPage;
    private const GAPY:Number = 52;

    public function LanguageSelector(activation_page:ActivationPage) {
        var langues:Vector.<String> = new <String>["FR", "UK", "ES", "DE", "IT", "PT"];
        var i:uint = 0;
        if (Language.language != "FR") {
            for each(var l:String in langues) {
                if (l == Language.language) {
                    var tmp:String = langues[i];
                    langues[0] = tmp;
                    langues[i] = "FR";
                    break;
                }
                i++;
            }
        }
        _activationPage = activation_page;
        _btnLangues = new Vector.<MovieClip>();
        i = 0;
        for each (var langue:String in langues) {
            var btn:MovieClip = MovieClip($container["$btnLangue" + langue]);
            btn.$select.alpha = 0;
            btn.y = GAPY * i;
            _btnLangues.push(btn);
            i++;
        }
        $btnOpen.buttonMode = true;
        $btnOpen.addEventListener(MouseEvent.CLICK, btnOpenClick);
    }

    private function onBtnLangueClick(event:MouseEvent):void {
        SoundManager.playSound(SoundManager.BTN_SELECT);
        var btn:MovieClip = MovieClip(event.currentTarget);
        var langue:String = btn.name.substr(10, 2);
        // swap
        var r_index:uint = getIndex(btn);
        swapBtns(0, r_index);

        TweenLite.to($mask, Const.ANIM_DURATION, {height: GAPY, ease: Power2.easeOut});
        desactivateBtns();

        selectLangue(langue);
    }

    private function selectLangue(selected_langue:String):void {
        clearTimeout(Const.CHANGE_TIMEOUT);
        Const.CHANGE_TIMEOUT = setTimeout(rec_launch, Const.CHANGE_TIMEOUT_DELAY);

        function rec_launch():void {
            Language.updateLanguage(selected_langue);
            // save language in DB
            DataManager.parametersData.langue = selected_langue;
            DataManager.setParameters();
            _activationPage.changeLanguage();
        }
    }

    private function activateBtns():void {
        var i:uint = 0;
        for each(var btn:MovieClip in _btnLangues) {
            if (i != 0) {
                btn.buttonMode = true;
                btn.mouseChildren = false;
                btn.addEventListener(MouseEvent.CLICK, onBtnLangueClick);
                btn.addEventListener(MouseEvent.MOUSE_OVER, onBtnLangueMouseOver);
                btn.addEventListener(MouseEvent.MOUSE_OUT, onBtnLangueMouseOut);
            }
            i++;
        }
        $btnOpen.visible = false;
        $btnOpen.removeEventListener(MouseEvent.CLICK, btnOpenClick);
    }

    private function onBtnLangueMouseOver(event:MouseEvent):void {
        var btn:MovieClip = MovieClip(event.currentTarget);
        TweenLite.to(btn.$select, Const.ANIM_DURATION, {alpha: 1});
    }

    private function onBtnLangueMouseOut(event:MouseEvent):void {
        var btn:MovieClip = MovieClip(event.currentTarget);
        TweenLite.to(btn.$select, Const.ANIM_DURATION, {alpha: 0});
    }

    private function desactivateBtns():void {
        for each(var btn:MovieClip in _btnLangues) {
            TweenLite.killTweensOf(btn.$select);
            btn.$select.alpha = 0;
            btn.buttonMode = false;
            btn.mouseChildren = false;
            btn.removeEventListener(MouseEvent.CLICK, onBtnLangueClick);
            btn.removeEventListener(MouseEvent.MOUSE_OVER, onBtnLangueMouseOver);
            btn.removeEventListener(MouseEvent.MOUSE_OUT, onBtnLangueMouseOut);
        }
        $btnOpen.visible = true;
        $btnOpen.addEventListener(MouseEvent.CLICK, btnOpenClick);
    }

    private function btnOpenClick(event:MouseEvent):void {
        TweenLite.to($mask, Const.ANIM_DURATION, {height: 6 * GAPY, ease: Power2.easeOut});
        activateBtns();
    }

    private function getIndex(search_btn:MovieClip):uint {
        var r_index:uint;
        var i:uint = 0;
        for each(var btn:MovieClip in _btnLangues) {
            if (search_btn == btn) {
                r_index = i;
                break;
            }
            i++;
        }
        return r_index;
    }

    private function swapBtns(index_A:uint, index_B:uint):void {
        var first_btn:MovieClip = _btnLangues[index_A];
        _btnLangues[index_A] = _btnLangues[index_B];
        var select_btn_posy:Number = _btnLangues[index_B].y;
        _btnLangues[index_B] = first_btn;
        _btnLangues[0].y = 0;
        _btnLangues[index_B] = first_btn;
        first_btn.y = select_btn_posy;
    }

}
}
