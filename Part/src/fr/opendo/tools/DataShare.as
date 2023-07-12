package fr.opendo.tools {
import com.distriqt.extension.core.Core;
import com.distriqt.extension.share.Share;
import com.distriqt.extension.share.ShareOptions;
import com.distriqt.extension.share.events.ShareEvent;

import flash.display.MovieClip;
import flash.filesystem.File;
import flash.geom.Rectangle;

/**
 * @author matthieu
 */
public class DataShare extends MovieClip {
    public function DataShare() {
    }

    public static function init():void {
        try {
            Core.init();
            if (Share.isSupported) {
                Share.service.addEventListener(ShareEvent.COMPLETE, share_shareHandler, false, 0, true);
                Share.service.addEventListener(ShareEvent.CANCELLED, share_shareHandler, false, 0, true);
                Share.service.addEventListener(ShareEvent.FAILED, share_shareHandler, false, 0, true);
                Share.service.addEventListener(ShareEvent.CLOSED, share_shareHandler, false, 0, true);
            }
        } catch (e:Error) {
        }

        function share_shareHandler(event:ShareEvent):void {
            Share.service.removeEventListener(ShareEvent.COMPLETE, share_shareHandler);
            Share.service.removeEventListener(ShareEvent.CANCELLED, share_shareHandler);
            Share.service.removeEventListener(ShareEvent.FAILED, share_shareHandler);
            Share.service.removeEventListener(ShareEvent.CLOSED, share_shareHandler);
        }
    }

    /* @file : le fichier
     * @mimeType : exemple : "text/css", "image/jpeg", "application/pdf", "video/mp4"...
     *
     */
    public static function fileShare(file:File, mimeType:String = ""):void {
        if (Share.service.isShareSupported) {
            var options:ShareOptions = new ShareOptions();
            options.position = new Rectangle(100, 100, 100, 0);
            options.title = "Share with...";
            options.showOpenIn = false;

            if (file.exists) {
                var path:String = file.nativePath;
                var file_name:String = file.name;
                Share.service.shareFile(path, file_name, mimeType, options, true);
            } else {
            }
        }
    }

    /* @fileName : le nom du fichier
     * @mimeType : exemple : "text/css", "image/jpeg", "application/pdf", "video/mp4"...
     *
     */
    public static function fileShareByName(fileName:String, mimeType:String = ""):void {
        if (Share.service.isShareSupported) {
            var options:ShareOptions = new ShareOptions();
            options.position = new Rectangle(100, 100, 100, 0);
            options.title = "Share with...";
            options.showOpenIn = false;
            var file:File = File.applicationStorageDirectory.resolvePath(Const.ASSETS_DIR + File.separator + fileName);

            if (file.exists) {
                var path:String = File.applicationStorageDirectory.nativePath + File.separator + Const.ASSETS_DIR + File.separator + fileName;
                Share.service.shareFile(path, fileName, mimeType, options, true);
            } else {
            }
        }
    }
}
}