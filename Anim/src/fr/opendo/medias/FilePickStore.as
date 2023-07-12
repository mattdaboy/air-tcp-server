package fr.opendo.medias {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;

import fr.opendo.events.StoreEvent;
import fr.opendo.modals.Modals;
import fr.opendo.tools.Const;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu 2018
 */
public class FilePickStore extends Sprite {
    private var _desktop_file:File;

    public function FilePickStore() {
    }

    public function browseForOpen(filters:Array = null):void {
        _desktop_file = new File();

        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) {
            Modals.banner.show("Not availbale yet on mobile. Soon... ;)");
        } else {
            _desktop_file.addEventListener(Event.SELECT, desktopFileSelectHandler);
            _desktop_file.addEventListener(IOErrorEvent.IO_ERROR, desktopErrorHandler);
            _desktop_file.browseForOpen("Open", filters);
        }
    }

    // Desktop
    private function desktopFileSelectHandler(event:Event):void {
        _desktop_file.removeEventListener(Event.SELECT, desktopFileSelectHandler);

        // Copie du fichier dans applicationStorageDirectory
        var file_name:String = _desktop_file.name;
        file_name = Tools.cleanSpecialChars(file_name);
        file_name = Tools.addOTimestampTo(file_name);
        var destination_file:File = Tools.getFileFromFilename(file_name);

        _desktop_file.addEventListener(Event.COMPLETE, copyCompleteHandler);
        _desktop_file.copyToAsync(destination_file, true);

        function copyCompleteHandler(event:Event):void {
            _desktop_file.removeEventListener(Event.COMPLETE, copyCompleteHandler);
            dispatchComplete(destination_file);
        }
    }

    // Dispatch du COMPLETE avec le fichier dans l'event
    private function dispatchComplete(file:File):void {
        dispatchEvent(new StoreEvent(StoreEvent.COMPLETE, file));
    }

    private function desktopErrorHandler(event:IOErrorEvent):void {
    }
}
}