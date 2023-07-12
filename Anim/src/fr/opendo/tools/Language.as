package fr.opendo.tools {
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import fr.opendo.events.CustomEvent;

/**
 * @author noel
 */
public class Language extends EventDispatcher {
    private static var _dispatcher:EventDispatcher;
    private static var _dictionnary:Array;
    private static var _file:File;

    public function Language() {
        throw new Error("!!! Language est un singleton et ne peut pas être instancié !!!");
    }

    private static var _language:String = "FR";

    public static function get language():String {
        return _language;
    }

    public static function init():void {
        _file = File.applicationStorageDirectory.resolvePath(Const.ASSETS_DIR + File.separator + "anim_dictionnaire.csv");
        var fileStream:FileStream = new FileStream();
        fileStream.open(_file, FileMode.READ);
        var str:String = fileStream.readUTFBytes(_file.size);
        fileStream.close();

        var temp:Array = str.split("\n");
        var languages:Array = temp[0].split(";");
        languages.splice(0, 1);
        var languages_nb:uint = languages.length;

        var traductions:Array = str.split("\n");
        traductions.splice(0, 1);

        _dictionnary = [];

        for each (var line:String in traductions) {
            var elems:Array = line.split(";");
            if (elems.length > 1) {
                var key:String = elems[0];
                for (var i:uint = 1; i <= languages_nb; i++) {
                    addValue(key, elems[i], languages[i - 1]);
                }
            }
        }

        _dispatcher = new EventDispatcher();
    }

    public static function updateLanguage(langue:String):void {
        _language = langue;
        _dispatcher.dispatchEvent(new CustomEvent(CustomEvent.CHANGE_LANGUAGE, [_language]));
    }

    public static function getValue(key:String):String {
        var r:String = "-";
        if (_dictionnary[key] != undefined) {
            r = _dictionnary[key][_language];
        }
        return r;
    }

    public static function clear():void {
        _dictionnary = [];
    }

    private static function addValue(key:String, value:String, language:String):void {
        // on vire les retours chariots pourris de excel
        key = Tools.removeCarriageReturnsAndNewLines(key);
        if (value != "") {
            value = Tools.removeCarriageReturnsAndNewLines(value);
        }
        language = Tools.removeCarriageReturnsAndNewLines(language);

        if (!_dictionnary[key]) {
            _dictionnary[key] = [];
        }
        _dictionnary[key][language] = value;
    }

    public static function get dispatcher():EventDispatcher {
        return _dispatcher;
    }
}
}