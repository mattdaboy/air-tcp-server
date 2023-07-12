package fr.opendo.tools {
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

/**
 * @author Matt - 2022-02-19
 */
public class ForbiddenWords extends EventDispatcher {
    private static var _dictionnary:Array;
    private static var _file:File;
    private static var _language:String = "FR";
    private static const PONCTUATIONS:Array = [" ", ".", ",", ";", ":", "=", "'", '"', "!", "?", "+", "-", "(", ")", "@", "&", "/"];
    private static const REPLACE_WORD:String = "***";

    public function ForbiddenWords() {
        throw new Error("!!! Language est un singleton et ne peut pas être instancié !!!");
    }

    public static function init():void {
        _file = File.applicationStorageDirectory.resolvePath(Const.ASSETS_DIR + File.separator + "forbidden_words.csv");
        var fileStream:FileStream = new FileStream();
        fileStream.open(_file, FileMode.READ);
        var str:String = fileStream.readUTFBytes(_file.size);
        fileStream.close();

        var temp:Array = str.split("\n");
        var languages:Array = temp[0].split(";");

        var traductions:Array = str.split("\n");
        traductions.splice(0, 1);

        _dictionnary = [];

        for each (var line:String in traductions) {
            var words:Array = line.split(";");
            for (var i:uint = 0; i < languages.length; i++) {
                addValue(words[i], languages[i]);
            }
        }
    }

    private static function addValue(word:String, language:String):void {
        if (word != "") word = Tools.removeCarriageReturnsAndNewLines(word);
        language = Tools.removeCarriageReturnsAndNewLines(language);

        if (!_dictionnary[language]) _dictionnary[language] = [];
        _dictionnary[language].push(word);
    }

    public static function verify(str:String):String {
        var final_str:String = "";
        var i:int;
        var j:int;

        // On split le texte avec toutes les ponctuations qu'on trouve
        var words:Array = [];
        for (i = str.length - 1; i >= 0; i--) {
            for (j = 0; j < PONCTUATIONS.length; j++) {
                if (str.substr(i, 1) == PONCTUATIONS[j]) {
                    if (i != str.length - 1) words.unshift(str.substr(i + 1));
                    words.unshift(PONCTUATIONS[j]);
                    str = str.substring(0, i);
                }
            }
        }
        if (str.length > 0) words.unshift(str);

        // On analyse tous les mots
        for (i = 0; i < words.length; i++) {
            // On vérifie si il y a des mots interdits et on les remplace par ***
            for (j = 0; j < _dictionnary[language].length; j++) {
                if (words[i].toLowerCase() == _dictionnary[language][j].toLowerCase()) words[i] = REPLACE_WORD;
            }
            // On reconstitue le texte
            if (i == 0) final_str = words[i];
            if (i > 0) final_str += words[i];
        }

        return final_str;
    }

    public static function updateLanguage(langue:String):void {
        _language = langue;
    }

    public static function get language():String {
        return _language;
    }

    public static function clear():void {
        _dictionnary = [];
    }
}
}