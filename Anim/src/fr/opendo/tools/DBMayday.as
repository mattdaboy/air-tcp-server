package fr.opendo.tools {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.net.FileFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.ByteArray;
import flash.utils.setTimeout;

import fr.opendo.data.Sql;

/**
 * @author Matt - 2022-11-07
 */
public class DBMayday extends Sprite {
    private var _this:DBMayday;
    private var _message:String;
    private var _warning_title:WarningView;
    private var _txt:TextField;
    private var _btnExportDB:BtnExportDBView;
    private var _btnImportDB:BtnImportDBView;

    public function DBMayday(message:String = "") {
        _this = this;
        _message = message;
        init();
    }

    private function init():void {
        // titre
        _warning_title = new WarningView();
        _warning_title.x = 40;
        _warning_title.y = 40;
        _warning_title.$text.text = "Un problème est survenu / A problem occured";
        addChild(_warning_title);

        // Texte descriptif
        var format:TextFormat = new TextFormat();
        format.size = 20;
        format.font = "Roboto";
        format.color = 0xFFFFFF;

        _txt = new TextField();
        _txt.autoSize = TextFieldAutoSize.LEFT;
        _txt.multiline = true;
        _txt.wordWrap = true;
        _txt.width = 960 - 40 - 55;
        _txt.x = 40 + 55;
        _txt.y = _warning_title.y + _warning_title.height + 40;
        _txt.defaultTextFormat = format;
        _txt.text = "Vos données ne sont pas compromises et vous avez la possibilité d'exporter la base de données via la fonction Exporter pour l'envoyer à l'équipe technique d'Opendo. Une fois votre base de données traitée, vous pourrez l'importer de nouveau via la fonction Importer."
                + "\n\nYour datas are not compromised and you have the possibility to export the database via the Export function to send it to the Opendo technical team. Once your database has been processed, you can import it again using the Import function.";
        if (_message != "") _txt.text += "\n\nCode d'erreur (error code) : " + _message;

        addChild(_txt);

        // Export du fichier opendo.db en local
        _btnExportDB = new BtnExportDBView();
        _btnExportDB.x = _txt.x;
        _btnExportDB.y = _txt.y + _txt.height + 80;
        _btnExportDB.buttonMode = true;
        _btnExportDB.mouseChildren = false;
        _btnExportDB.addEventListener(MouseEvent.CLICK, onBtnExportClick);
        addChild(_btnExportDB);

        // Import du fichier opendo.db en local
        _btnImportDB = new BtnImportDBView();
        _btnImportDB.x = _txt.x;
        _btnImportDB.y = _btnExportDB.y + _btnExportDB.height + 40;
        _btnImportDB.buttonMode = true;
        _btnImportDB.mouseChildren = false;
        _btnImportDB.addEventListener(MouseEvent.CLICK, onBtnImportClick);
        addChild(_btnImportDB);
    }

    private function onBtnExportClick(event:MouseEvent):void {
        var dbFile:File = File.applicationStorageDirectory.resolvePath("opendo.db");
        dbFile.addEventListener(Event.COMPLETE, onFileLoaded);

        setTimeout(function ():void {
            dbFile.load();
        }, 100);

        function onFileLoaded(event:Event):void {
            dbFile.removeEventListener(Event.COMPLETE, onFileLoaded);
            dbFile.addEventListener(Event.COMPLETE, onFileSaved);
            var b:ByteArray = dbFile.data;
            dbFile.save(b, "opendo.db");
        }

        function onFileSaved(event:Event):void {
            dbFile.removeEventListener(Event.COMPLETE, onFileSaved);
        }
    }

    private function onBtnImportClick(event:MouseEvent):void {
        var dbWorkFile:File = File.applicationStorageDirectory.resolvePath("opendo.db");
        var file:File = new File();
        var fileFilter:FileFilter = new FileFilter("Documents", "*.db;");
        file.addEventListener(Event.SELECT, fileImportSelect);
        file.browseForOpen("Sélectionnez le fichier...", [fileFilter]);

        function fileImportSelect(event:Event):void {
            file.addEventListener(Event.COMPLETE, onFileImportLoad);
            file.addEventListener(IOErrorEvent.IO_ERROR, importIOErrorHandler);
            file.load();
        }

        function importIOErrorHandler(event:IOErrorEvent):void {
            file.removeEventListener(Event.COMPLETE, onFileImportLoad);
            file.removeEventListener(IOErrorEvent.IO_ERROR, importIOErrorHandler);
        }

        function onFileImportLoad(event:Event):void {
            file.removeEventListener(Event.COMPLETE, onFileImportLoad);
            file.removeEventListener(IOErrorEvent.IO_ERROR, importIOErrorHandler);

            file.addEventListener(Event.COMPLETE, fileCopiedHandler);
            file.addEventListener(IOErrorEvent.IO_ERROR, copyIOErrorHandler);

            Sql.dbClose();

            file.copyToAsync(dbWorkFile, true);

            function copyIOErrorHandler(event:IOErrorEvent):void {
                file.removeEventListener(Event.COMPLETE, fileCopiedHandler);
                file.removeEventListener(IOErrorEvent.IO_ERROR, copyIOErrorHandler);
            }

            function fileCopiedHandler(event:Event):void {
                file.removeEventListener(Event.COMPLETE, fileCopiedHandler);
                file.removeEventListener(IOErrorEvent.IO_ERROR, copyIOErrorHandler);

                _txt.text = "Vous devez relancer l'app pour que le nouveau contenu soit pris en compte.";
                _btnExportDB.visible = false;
                _btnImportDB.visible = false;
            }
        }
    }
}
}