package fr.opendo.home {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;

import fr.opendo.data.DataManager;
import fr.opendo.medias.ImageLoader;
import fr.opendo.socket.SocketManager;
import fr.opendo.socket.SocketManagerConst;
import fr.opendo.socket.Users;
import fr.opendo.tools.Const;
import fr.opendo.tools.ScreenSize;
import fr.opendo.tools.Tools;

/**
 * @author noel
 */
public class Logo extends LogoOpendoView implements IView {
    private var _logo:LogoOpendoMcView;
    private var _loader:ImageLoader;
    private var _logo_down_left:LogoDownLeft;

    public function Logo() {
        init();
    }

    private function init():void {
        _logo_down_left = new LogoDownLeft();

        x = ScreenSize.left + 40;
        y = ScreenSize.top + 40;
        addEventListener(MouseEvent.CLICK, clickLogoHandler);
        updateImage();
    }

    public function show():void {
        ViewManager.addIView(Main.instance, this);
    }

    private function clickLogoHandler(event:MouseEvent):void {
        Tools.fullScreenToggle();
    }

    public function updateImage():void {
        alpha = 0;
        while (numChildren > 0) removeChildAt(0);
        var file_name:String = DataManager.parametersData.ihm.logo.file_name.toString();
        if (file_name != "") {
            var file:File = Tools.getFileFromFilename(file_name);
            _loader = new ImageLoader(ImageLoader.FIT, 320, 120);
            _loader.y = -20;
            _loader.addEventListener(Event.COMPLETE, onComplete);
            _loader.load(file.url);
            _logo_down_left.display(true);
        } else {
            _logo = new LogoOpendoMcView();
            addChild(_logo);
            TweenLite.to(this, Const.ANIM_DURATION, {alpha: 1, ease: Power2.easeOut});
            _logo_down_left.display(false);
        }
        // si les parts sont déjà connectés on renvoie le logo
        if (Users.users.length > 0) {
            var xml:XML = new XML(DataManager.parametersData.ihm);
            xml.appendChild(<http_server_port>{SocketManagerConst.HTTP_SERVER_PORT}</http_server_port>);
            xml.appendChild(<app_version>{Main.instance.version}</app_version>);
            delete (xml.home);
            SocketManager.sendToApprenants(SocketManagerConst.PARAMETERS_DATAS + Const.SEPARATOR1 + String(xml));
        }
    }

    private function onComplete(event:Event):void {
        addChild(_loader);
        TweenLite.to(this, Const.ANIM_DURATION, {alpha: 1, ease: Power2.easeOut});
    }

    public function display(isGoingVisible:Boolean):void {
        if (isGoingVisible) {
            visible = true;
            ViewManager.addIView(Main.instance, this);
            TweenLite.to(this, Const.ANIM_DURATION, {alpha: 1, ease: Power2.easeOut});
        } else {
            ViewManager.addIView(Main.instance, this);
            TweenLite.to(this, Const.ANIM_DURATION, {
                alpha: 0, ease: Power2.easeIn, onComplete: function ():void {
                    visible = false;
                }
            });
        }
    }

    public function get view():DisplayObjectContainer {
        return this;
    }

    public function get type():String {
        return ViewManager.LOGO;
    }

    public function clean():void {
    }
}
}