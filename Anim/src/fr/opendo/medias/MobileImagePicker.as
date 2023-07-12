package fr.opendo.medias {
import by.blooddy.crypto.image.JPEGEncoder;

import com.distriqt.extension.image.Image;
import com.distriqt.extension.image.ImageFormat;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.MediaEvent;
import flash.media.CameraRoll;
import flash.media.MediaPromise;
import flash.utils.ByteArray;
import flash.utils.IDataInput;

import fr.opendo.events.MobileImagePickerEvent;
import fr.opendo.modals.Modals;
import fr.opendo.tools.Const;
import fr.opendo.tools.Language;
import fr.opendo.tools.Tools;

/**
 * @author noel
 */
public class MobileImagePicker extends EventDispatcher {
    private static var _instance:MobileImagePicker;
    private var _dataSource:IDataInput;
    private var _originalBmpd:BitmapData;

    public function MobileImagePicker() {
        _instance = this;
        var cameraRoll:CameraRoll = new CameraRoll();

        cameraRoll.requestPermission();
        cameraRoll.addEventListener(ErrorEvent.ERROR, mediaError);

        if (CameraRoll.supportsBrowseForImage && CameraRoll.permissionStatus != "denied") {
            cameraRoll.addEventListener(MediaEvent.SELECT, imageSelected);
            cameraRoll.addEventListener(Event.CANCEL, browseCanceled);
            cameraRoll.browseForImage();
        } else {
            // "Veuillez autoriser l'accès aux photos dans Réglages / Formateur"
            Modals.dialogbox.show(Language.getValue("dialogbox-autorise-acces-photos"));
            Modals.dialogbox.setNoCancel();
            dispatchEvent(new MobileImagePickerEvent(MobileImagePickerEvent.BROWSING_NOT_SUPPORTED));
        }
    }

    private function browseCanceled(event:Event):void {
        dispatchEvent(new MobileImagePickerEvent(MobileImagePickerEvent.BROWSE_CANCEL));
    }

    private function mediaError(error:ErrorEvent):void {
        // "Veuillez autoriser l'accès aux photos dans Réglages / Formateur"
        Modals.dialogbox.show(Language.getValue("dialogbox-autorise-acces-photos"));
        Modals.dialogbox.setNoCancel();
        dispatchEvent(new MobileImagePickerEvent(MobileImagePickerEvent.MEDIA_ERROR));
    }

    private function imageSelected(event:MediaEvent):void {
        var imagePromise:MediaPromise = event.data;
        _dataSource = imagePromise.open();
        if (imagePromise.isAsync) {
            var eventSource:IEventDispatcher = _dataSource as IEventDispatcher;
            eventSource.addEventListener(Event.COMPLETE, onDataComplete);
        } else {
            readMediaData();
        }
    }

    public static function get instance():MobileImagePicker {
        return _instance;
    }

    private function onDataComplete(event:Event):void {
        readMediaData();
    }

    private function readMediaData():void {
        var by:ByteArray = new ByteArray();
        _dataSource.readBytes(by);
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
        loader.loadBytes(by);
    }

    private function loaderComplete(e:Event):void {
        var loader:Loader = e.currentTarget.loader as Loader;
        _originalBmpd = new BitmapData(loader.width, loader.height, true, 0);
        _originalBmpd.draw(loader);

        var encodedData:ByteArray = new ByteArray();
        if (Tools.OS.type == Const.IOS || Tools.OS.type == Const.ANDROID) Image.service.encode(_originalBmpd, encodedData, ImageFormat.JPG, Const.MOBILE_JPEG_QUALITY);
        if (Tools.OS.type == Const.MACOS || Tools.OS.type == Const.WIN) encodedData = JPEGEncoder.encode(_originalBmpd, Const.DESKTOP_JPEG_QUALITY);

        // on dispatch les bytes de l'image sélectionnée
        dispatchEvent(new MobileImagePickerEvent(MobileImagePickerEvent.IMAGE_BYTES, encodedData));
    }
}
}