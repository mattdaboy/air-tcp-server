package fr.opendo.medias {
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.filesystem.File;
import flash.net.FileFilter;

import fr.opendo.events.CustomEvent;
import fr.opendo.events.MobileImagePickerEvent;
import fr.opendo.tools.Const;
import fr.opendo.tools.Tools;

/**
 * @author matthieu
 */
public class ImagePicker extends MovieClip {
    private var _file:File;

    public function ImagePicker() {
    }

    public function browseForOpen():void {
        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) {
            var mobile_image_picker:MobileImagePicker = new MobileImagePicker();
            mobile_image_picker.addEventListener(MobileImagePickerEvent.IMAGE_BYTES, imageBytesHandler);
        } else {
            var imagesFilter:FileFilter = new FileFilter("Images", "*.jpg;*.jpeg;*.png");
            _file = new File();
            _file.browseForOpen("Sélectionnez le fichier...", [imagesFilter]);
            _file.addEventListener(Event.SELECT, fileSelectHandler);
        }
    }

    private function imageBytesHandler(event:MobileImagePickerEvent):void {
        dispatchEvent(new CustomEvent(CustomEvent.MOBILE_IMAGE_PICK_COMPLETE, [event.imageBytes]));
    }

    private function fileSelectHandler(evt:Event):void {
        _file.addEventListener(Event.COMPLETE, fileLoadCompletHandler);
        _file.load();
    }

    private function fileLoadCompletHandler(event:Event):void {
        _file.removeEventListener(Event.COMPLETE, fileLoadCompletHandler);
        var image:Loader = new Loader();
        image.loadBytes(_file.data);
        image.contentLoaderInfo.addEventListener(Event.COMPLETE, fileLoadBytesCompleteHandler);
    }

    private function fileLoadBytesCompleteHandler(event:Event):void {
        dispatchEvent(new CustomEvent(CustomEvent.DESKTOP_IMAGE_PICK_COMPLETE, [_file.name, _file.data, _file]));
    }
}
}