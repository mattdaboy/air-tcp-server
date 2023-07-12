package fr.opendo.medias {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.utils.ByteArray;

import fr.opendo.events.CustomEvent;
import fr.opendo.modals.Modals;
import fr.opendo.tools.Const;
import fr.opendo.tools.Tools;

/**
 * @author Matthieu 2018
 */
public class MultipleFilesPickStore extends Sprite {
    private var _fileRefList:FileReferenceList = new FileReferenceList();
    private var _filesName:Array;
    private var _totalSize:Number;

    public function MultipleFilesPickStore() {
        _filesName = [];
        _totalSize = 0;
    }

    public function browseForOpen(filters:Array = null):void {
        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) {
            Modals.banner.show("Cette fonctionnalité n'est pas encore disponible sur mobile. Bientôt... ;)");
        } else {
            _fileRefList.addEventListener(Event.SELECT, selectHandler);
            _fileRefList.browse(filters);
        }
    }

    // Desktop
    private function selectHandler(event:Event):void {
        _fileRefList.removeEventListener(Event.SELECT, selectHandler);
        var files:FileReferenceList = FileReferenceList(event.target);
        writeFile(0);
    }

    private function writeFile(index:Number):void {
        var fileRef:FileReference = _fileRefList.fileList[index];
        fileRef.addEventListener(Event.COMPLETE, onLoadComplete);
        _totalSize += fileRef.size;
        fileRef.load();

        function onLoadComplete(e:Event):void {
            fileRef.removeEventListener(Event.COMPLETE, onLoadComplete);
            var by:ByteArray = fileRef.data;
            var file_name:String = fileRef.name;
//            file_name = Tools.cleanSpecialChars(file_name);
            file_name = Tools.addOTimestampTo(file_name);
            var destination_file:File = Tools.getFileFromFilename(file_name);
            _filesName.push(file_name);
            var file_stream:FileStream = new FileStream;
            file_stream.addEventListener(Event.CLOSE, copyCompleteHandler);
            file_stream.openAsync(destination_file, FileMode.WRITE);
            file_stream.writeBytes(by);
            file_stream.close();

            function copyCompleteHandler(event:Event):void {
                file_stream.removeEventListener(Event.CLOSE, copyCompleteHandler);
                var next_index:uint = index + 1;
                if (next_index < _fileRefList.fileList.length) {
                    writeFile(next_index);
                } else {
                    dispatchComplete();
                }
            }
        }
    }

    // Dispatch du COMPLETE
    private function dispatchComplete():void {
        dispatchEvent(new CustomEvent(CustomEvent.COMPLETE, [_filesName, _totalSize]));
    }

    private function desktopErrorHandler(event:IOErrorEvent):void {
    }
}
}