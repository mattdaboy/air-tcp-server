package fr.opendo.tools {
import com.distriqt.extension.core.Core;
import com.distriqt.extension.share.Share;
import com.distriqt.extension.share.ShareOptions;
import com.distriqt.extension.share.events.ShareEvent;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.geom.Rectangle;

/**
 * @author matthieu
 */
public class DataShare extends MovieClip {
    private static var _dispatcher:EventDispatcher = new EventDispatcher();

    public function DataShare() {
        throw new Error("!!! DataShare est un singleton et ne peut pas être instancié !!!");
    }

    public static function init():void {
        try {
            Core.init();
            if (Share.isSupported) {
                Share.service.addEventListener(ShareEvent.COMPLETE, shareCompleteHandler, false, 0, true);
                Share.service.addEventListener(ShareEvent.CANCELLED, share_shareHandler, false, 0, true);
                Share.service.addEventListener(ShareEvent.FAILED, share_shareHandler, false, 0, true);
                Share.service.addEventListener(ShareEvent.CLOSED, share_shareHandler, false, 0, true);
            }
        } catch (e:Error) {
        }

        function shareCompleteHandler(event:ShareEvent):void {
            _dispatcher.dispatchEvent(new Event(Event.COMPLETE));
        }

        function share_shareHandler(event:ShareEvent):void {
        }
    }

    /* @fileName : le nom du fichier
     * @mimeType : exemple : "text/css", "image/jpeg", "application/pdf", "video/mp4"...
     *
     */
    public static function fileShareByName(file_name:String, mimeType:String = ""):void {
        if (Share.service.isShareSupported) {
            var options:ShareOptions = new ShareOptions();
            options.position = new Rectangle(100, 100, 100, 0);
            options.title = "Share with...";
            options.showOpenIn = false;
            var file:File = File.applicationStorageDirectory.resolvePath(Const.ASSETS_DIR + File.separator + file_name);

            if (file_name != "" && file.exists) {
                var path:String = File.applicationStorageDirectory.nativePath + File.separator + Const.ASSETS_DIR + File.separator + file_name;
                Share.service.shareFile(path, file_name, mimeType, options, true);
            } else {
//                Debug.show("ERROR: File doesn't exist: " + file.nativePath);
            }
        }
    }

    public static function get dispatcher():EventDispatcher {
        return _dispatcher;
    }
}
}