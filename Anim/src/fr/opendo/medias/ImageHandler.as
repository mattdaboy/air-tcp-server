package fr.opendo.medias {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;

import fr.opendo.data.DataManager;
import fr.opendo.events.CustomEvent;
import fr.opendo.events.StoreEvent;
import fr.opendo.tools.CustomMask;
import fr.opendo.tools.Language;
import fr.opendo.data.StoreLocalFilesToCLoud;
import fr.opendo.tools.Tools;

/**
 * @author Matt - update 2022-04-08
 */
public class ImageHandler extends ImageHandlerView {
    private var _image_resized_width:uint;
    private var _image_resized_height:uint;
    private var _bt_default_visible:Boolean;
    private var _img_loader:ImageLoader;
    private var _image_node:XML;
    private var _save_function:Function;
    public static const SAVE_TYPE_SESSIONS:String = "SAVE_TYPE_SESSIONS";
    public static const SAVE_TYPE_PARAMETERS:String = "SAVE_TYPE_PARAMETERS";
    private var _save_type:String;
    private var _file:File;

    public function ImageHandler(w:uint = 1920, h:uint = 1200, bt_default_visible:Boolean = true, save_type:String = SAVE_TYPE_SESSIONS) {
        _image_resized_width = w;
        _image_resized_height = h;
        _bt_default_visible = bt_default_visible;
        _save_type = save_type;

        _img_loader = new ImageLoader(ImageLoader.FILL, $btImage.width, $btImage.height, 20);
        _img_loader.addEventListener(Event.COMPLETE, onLoadComplete);
        addChild(_img_loader);

        $btnInsererImage.buttonMode = $btImage.buttonMode = true;
        $btnInsererImage.mouseChildren = $btImage.mouseChildren = false;
        $btnInsererImage.addEventListener(MouseEvent.CLICK, btNewImageHandler);
        $btnInsererImage.$label.text = Language.getValue("inserer-photo");

        $btImage.addEventListener(MouseEvent.CLICK, btNewImageHandler);

        CustomMask.setMask($btImage, $btImage.x, $btImage.y, $btImage.width, $btImage.height, 20);

        $btDefaultImage.buttonMode = true;
        $btDefaultImage.mouseChildren = false;
        $btDefaultImage.addEventListener(MouseEvent.CLICK, btDefaultImageHandler);
        $btDefaultImage.visible = _bt_default_visible;

        changeLanguage();
    }

    public function setContent(image_node:XML, save_function:Function = null):void {
        _image_node = image_node;
        _save_function = save_function;
        _img_loader.unload();
        var file_name:String = _image_node.toString();
        _file = Tools.getFileFromFilename(file_name);
        if (file_name != "" && _file.exists) showImage(_file);
    }

    private function btNewImageHandler(event:MouseEvent):void {
        var image_picker:ImagePickResizeStore = new ImagePickResizeStore(_image_resized_width, _image_resized_height);
        image_picker.addEventListener(StoreEvent.COMPLETE, imagePickerCompleteHandler);
        image_picker.browseForOpen();
    }

    private function imagePickerCompleteHandler(event:StoreEvent):void {
        var image_picker:ImagePickResizeStore = event.currentTarget as ImagePickResizeStore;
        image_picker.removeEventListener(StoreEvent.COMPLETE, imagePickerCompleteHandler);
        _file = event.file;
        showImage(_file);
        saveImageInXML(_file);
    }

    private function saveImageInXML(file:File):void {
        _image_node.setChildren(file.name);
        saveInDB();

        StoreLocalFilesToCLoud.dispatcher.addEventListener(CustomEvent.FILE_UPLOADED, fileUploadedHandler);
        StoreLocalFilesToCLoud.uploadFile(file, _image_node);

        function fileUploadedHandler(event:CustomEvent):void {
            StoreLocalFilesToCLoud.dispatcher.removeEventListener(CustomEvent.FILE_UPLOADED, fileUploadedHandler);
            saveInDB();
        }
    }

    private function btDefaultImageHandler(event:MouseEvent):void {
        resetImage();
    }

    public function changeLanguage():void {
        $btnInsererImage.$label.text = Language.getValue("inserer-photo");
    }

    public function showImage(file:File):void {
        _img_loader.unload();
        _img_loader.load(file.url);
    }

    public function resetImage():void {
        _img_loader.unload();
        _image_node.setChildren("");
        if (Tools.isNodeExists(_image_node.parent(), "served_url")) _image_node.parent().served_url.setChildren("");
        saveInDB();
    }

    private function saveInDB():void {
        switch (_save_type) {
            case SAVE_TYPE_SESSIONS:
                DataManager.setSessionModules();
                break;
            case SAVE_TYPE_PARAMETERS:
                DataManager.setParameters();
                break;
        }
        if (_save_function) _save_function.apply(null, new Array(_file));
    }

    private function onLoadComplete(event:Event):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}