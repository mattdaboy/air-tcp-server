package fr.opendo.medias {
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
import fr.opendo.tools.Language;

/**
 * @author Matthieu 2018
 */
public class MobileImagePicker2 extends EventDispatcher {
    private var _dataSource:IDataInput;

    public function MobileImagePicker2() {
    }

    public function browseForOpen():void {
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

    private function onDataComplete(event:Event):void {
        readMediaData();
    }

    private function readMediaData():void {
        var by:ByteArray = new ByteArray();
        _dataSource.readBytes(by);

        // on dispatch les bytes de l'image sélectionnée
        dispatchEvent(new MobileImagePickerEvent(MobileImagePickerEvent.IMAGE_BYTES, by));
    }
}
}