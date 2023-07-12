package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import flash.desktop.NativeApplication;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.setTimeout;

import fr.opendo.medias.Base64BitmapLoader;

/**
 * @author Matt - last modified 2023-04-18
 */
public class Tools {
    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function Tools() {
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // System Tools
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    public static function get OS():Object {
        var result:Object;
        var type:String = "";
        var version:String = "-";
        var manufacturer:String = Capabilities.manufacturer.toUpperCase();
        var os:String = Capabilities.os;
        var temp:Array = os.split(" ");

        if (manufacturer.indexOf("MAC") != -1) {
            type = Const.MAC;
            version = temp[2];
        }
        if (manufacturer.indexOf("WIN") != -1) {
            type = Const.WIN;
            version = temp[1];
        }
        if (manufacturer.indexOf("IOS") != -1) {
            type = Const.IOS;
            if (os.indexOf("iPadOS") != -1) version = temp[1];
            if (os.indexOf("iPhone") != -1) version = temp[2];
        }
        if (manufacturer.indexOf("ANDROID") != -1) {
            type = Const.ANDROID;
            var temp2:Array = temp[1].split("-");
            version = temp2[0];
        }
        result = {type: type, version: version};
        return result;
    }

    public static function get cpuArch():String {
        return Capabilities.cpuArchitecture;
    }

    public static function get apparel():Object {
        var result:Object;
        var type:String = "";
        var version:String = "-";
        var manufacturer:String = Capabilities.manufacturer;
        var os:String = Capabilities.os;
        var temp:Array = os.split(" ");

        if (os.indexOf("Mac") != -1) {
            type = "Mac";
        }
        if (os.indexOf("Windows") != -1) {
            type = "PC";
        }
        if (os.indexOf("iPadOS") != -1) {
            type = "iPad";
            version = temp[2];
        }
        if (os.indexOf("iPhone") != -1) {
            type = "iPhone";
            version = temp[3];
        }
        if (manufacturer.indexOf("Android") != -1) {
            var screen_ratio:Number = Capabilities.screenResolutionX / Capabilities.screenResolutionY;
            (screen_ratio > (4 / 3)) ? type = "AndroidPhone" : type = "AndroidTablet";
        }
        result = {type: type, version: version};
        return result;
    }

    public static function get screenResolution():String {
        return Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // String Tools
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * replaceString
     * @param chain la chaine à scanner
     * @param search la chaine à rechercher
     * @param replace la chaine par laquelle on remplace search
     */
    public static function replaceString(chain:String, search:String, replace:String):String {
        var final_chain:String = chain;
        if (chain.indexOf(search) != -1) {
            var temp:Array = final_chain.split(search);
            final_chain = temp[0];
            for (var i:uint = 1; i < temp.length; i++) {
                final_chain += replace + temp[i];
            }
        }
        return final_chain;
    }

    public static function splitString(str:String, char:String):Array {
        var part1:String = str.substr(0, str.indexOf(char));
        var part2:String = str.substr(str.indexOf(char) + 1);
        var array:Array = [part1, part2];
        return array;
    }

    public static function getFilenameWithoutOTimestamp(file_name:String):String {
        if (file_name.indexOf(Const.FILENAME_SUFFIXE_SEPARATOR) != -1) {
            var name_without_otimestamp:String = file_name.substr(0, file_name.indexOf(Const.FILENAME_SUFFIXE_SEPARATOR));
            var extension:String = file_name.substring(file_name.lastIndexOf("."));
            file_name = name_without_otimestamp + extension;
        }
        return file_name;
    }

    public static function safeRemoveChild(parent:DisplayObjectContainer, child:DisplayObjectContainer):void {
        if (parent != null && child != null) {
            for (var i:uint = 0; i < parent.numChildren; i++) {
                if (parent.getChildAt(i) == child) {
                    parent.removeChild(child);
                }
            }
        }
    }

    public static function convertStringToUTF8(content:String):ByteArray {
        var b:ByteArray = new ByteArray();
        // Include the byte order mark for UTF-8
        b.writeByte(0xEF);
        b.writeByte(0xBB);
        b.writeByte(0xBF);
        b.writeUTFBytes(content);
        return b;
    }

    public static function generateRandomString(strlen:Number):String {
        var chars:String = "abcdefghijkmnopqrstuvwxyz";
        var num_chars:Number = chars.length - 1;
        var randomChar:String = "";

        for (var i:Number = 0; i < strlen; i++) {
            randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
        }
        return randomChar;
    }

    // app version
    public static function get appVersion():String {
        var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
        var ns:Namespace = appXml.namespace();
        var appVersion:String = appXml.ns::versionNumber[0];
        return appVersion;
    }

    public static function versionToNumber(version:String, sequence_number:int = 3):Number {
        var pre_result:String = "";
        var temp:Array = version.split(".");
        var i:uint;
        for (i = 0; i < sequence_number; i++) if (temp[i] == null) temp[i] = "0";
        for (i = 0; i < sequence_number; i++) temp[i] = strToThousand(temp[i]);
        for (i = 0; i < sequence_number; i++) pre_result += temp[i];
        return Number(pre_result);
    }

    public static function strToThousand(str:String):String {
        while (str.length < 4) str = "0" + str;
        return str;
    }

    /*
     * enlève les espaces avant et après la chaine de caractère
     *
     * @param str la chaine de caractère
     */
    public static function trimWhitespace(str:String):String {
        if (str == null) {
            return "";
        }
        return str.replace(/^\s+|\s+$/g, "");
    }

    /*
     * Arrondir n, à p chiffre(s) après la virgule
     *
     * @param n le nombre à arrondir
     * @param p nombre de chiffre après a virgule
     */
    public static function arrondir(n:Number, p:Number):Number {
        return Math.round(n * Math.pow(10, p)) / Math.pow(10, p);
    }

    public static function removeCarriageReturnsAndNewLines($myString:String):String {
        var newString:String;
        var findCarriageReturnRegExp:RegExp = new RegExp("\r", "gi");
        newString = $myString.replace(findCarriageReturnRegExp, "");
        var findNewLineRegExp:RegExp = new RegExp("\n", "gi");
        newString = newString.replace(findNewLineRegExp, "");
        return newString;
    }

    public static function isValidEmail(email:String):Boolean {
        var emailExpression:RegExp = /^[\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
        return emailExpression.test(email);
    }

    public static function randomize(a:*, b:*):int {
        return (Math.random() > .5) ? 1 : -1;
    }

    /*
     * Extraire un noeud dans un XML par son nom
     *
     * @param xml le XML à parcourir
     * @param nodeName le noeud à extraire
     */
    public static function getNodeByName(xml:XML, nodeName:String):XMLList {
        return xml.descendants(nodeName);
    }

    /**
     * enlève tous les caracrères qui ne sont pas alphanumériques
     * @param source la chaine de caractère
     * @param replace_char le string qui remplace les caractères prohibés
     */
    public static function cleanStringForGoodFileName(source:String, replace_char:String = "-"):String {
        var rex:RegExp = /[^A-Za-z0-9.]/g;
        var str:String = source.replace(rex, replace_char);
        return str;
    }

    public static function copyFileTo(source_file_path:String, target_file_path:String):void {
        var source:File = File.applicationDirectory.resolvePath(source_file_path);
        var target:File = File.applicationStorageDirectory.resolvePath(target_file_path);

        source.addEventListener(Event.COMPLETE, CompleteHandler);
        source.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
        source.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);

        if (target.exists) {
            if (source.modificationDate > target.modificationDate) source.copyToAsync(target, true);
        } else {
            source.copyToAsync(target);
        }

        function CompleteHandler(event:Event):void {
            removeDispatchers();
        }

        function IOErrorHandler(event:IOErrorEvent):void {
            removeDispatchers();
        }

        function SecurityErrorHandler(event:SecurityErrorEvent):void {
            removeDispatchers();
        }

        function removeDispatchers():void {
            source.removeEventListener(Event.COMPLETE, CompleteHandler);
            source.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
            source.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
        }
    }

    public static function killExplosion(container:Sprite):void {
        while (container.numChildren > 0) {
            container.removeChildAt(0);
        }
    }

    public static function focusAndroidIn(view:DisplayObjectContainer, tf_ypos:Number):void {
        if (Tools.OS.type != Const.ANDROID) return;
        TweenLite.to(view, Const.ANIM_DURATION, {y: ScreenSize.top - tf_ypos + 180, delay: .25, ease: Power2.easeOut});
    }

    public static function focusAndroidOut(view:DisplayObjectContainer):void {
        if (Tools.OS.type != Const.ANDROID) return;
        TweenLite.to(view, Const.ANIM_DURATION, {y: 0, ease: Power2.easeOut});
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // Files Tools
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    public static function getFilenameFromUrl(str:String):String {
        if (str.indexOf("/") != -1) {
            var file_pos:uint = str.lastIndexOf("/") + 1;
            var filename:String = str.substr(file_pos);
            return filename;
        } else {
            return str;
        }
    }

    public static function getFilenameFromLocalFilePath(str:String):String {
        var filename:String;
        if (str.indexOf("\\") != -1) {
            filename = str.substr(str.lastIndexOf("\\") + 1);
        } else if (str.indexOf("/") != -1) {
            filename = str.substr(str.lastIndexOf("/") + 1);
        } else {
            filename = str;
        }
        return filename;
    }

    public static function getFileFromFilename(file_name:String):File {
        var file:File = File.applicationStorageDirectory.resolvePath(Const.HTDOCS_DIR + File.separator + file_name);
        return file;
    }

    public static function saveByteArrayToFile(byte_array:ByteArray, file_name:String):File {
        var destination_file:File;

        destination_file = Tools.getFileFromFilename(file_name);
        var file_stream:FileStream = new FileStream;
        file_stream.open(destination_file, FileMode.WRITE);
        file_stream.writeBytes(byte_array);
        file_stream.close();

        return destination_file;
    }

    public static function displayBase64Image(container:DisplayObjectContainer, base64_image_str:String, w:uint, h:uint, r:uint = 0):void {
        if (base64_image_str != "") {
            var b64bitmap_photo:Base64BitmapLoader = new Base64BitmapLoader(Base64BitmapLoader.FILL, w, h, r);
            b64bitmap_photo.addEventListener(Event.COMPLETE, byLoadCompleteHandler);
            b64bitmap_photo.load(base64_image_str);

            function byLoadCompleteHandler(e:Event):void {
                container.addChild(b64bitmap_photo);
                container.dispatchEvent(new Event(Event.COMPLETE));
            }
        }
    }

    public static function copyFolderTo(source_path:String, target_path:String):void {
        try {
            var source_directory:File = File.applicationDirectory.resolvePath(source_path);
            if (!source_directory.exists) return;
            source_directory.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            source_directory.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);

            var directory_listing:Array = source_directory.getDirectoryListing();
            var target:File;
            for each (var source:File in directory_listing) {
                target = File.applicationStorageDirectory.resolvePath(target_path + File.separator + source.name);
                if (target.exists) {
                    if (Tools.OS.type != Const.ANDROID) if (source.modificationDate > target.modificationDate) source.copyTo(target, true);
                    if (Tools.OS.type == Const.ANDROID) source.copyTo(target, true);
                } else {
                    source.copyTo(target);
                }
            }
        } catch (e:Error) {
            log("COPY FOLDER " + source_path.toUpperCase());
        }

        function ioErrorHandler(event:IOErrorEvent):void {
            removeDispatchers();
        }

        function SecurityErrorHandler(event:SecurityErrorEvent):void {
            removeDispatchers();
        }

        function removeDispatchers():void {
            source_directory.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            source_directory.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
        }
    }

    public static function copyDBTo(source_file_path:String, target_file_path:String):void {
        var source:File = File.applicationDirectory.resolvePath(source_file_path);
        var target:File = File.applicationStorageDirectory.resolvePath(target_file_path);
        source.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        source.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);

        try {
            if (!target.exists) source.copyTo(target);
        } catch (e:Error) {
            log("COPY FILE " + source_file_path.toUpperCase());
        }

        function ioErrorHandler(event:IOErrorEvent):void {
            removeDispatchers();
        }

        function SecurityErrorHandler(event:SecurityErrorEvent):void {
            removeDispatchers();
        }

        function removeDispatchers():void {
            source.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            source.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
        }
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // Display Tools
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Renvoie les coordonnées d'un objet en dehors d'une zone pour le replacer dans cette zone
     * @param point les coordonnées de l'objet qui va se replacer dans une zone donnée
     * @param left la position minimum à gauche
     * @param top la position minimum en haut
     * @param right la position minimum à droite
     * @param bottom la position minimum en bas
     */
    public static function replaceObjectInZone(point:Point, left:Number, top:Number, right:Number, bottom:Number):void {
        var final_point:Point = new Point();
        if (point.x < left) point.x = left;
        if (point.x > right) point.x = right;
        if (point.y < top) point.y = top;
        if (point.y > bottom) point.y = bottom;
    }

    public static function drawPieMask(graphics:Graphics, percentage:Number, radius:Number = 50, x:Number = 0, y:Number = 0, rotation:Number = 0, sides:int = 6):void {
        graphics.moveTo(x, y);
        var _rads:Number;
        if (sides < 3) sides = 3;
        radius /= Math.cos(1 / sides * Math.PI);
        var lineToRadians:Function = function (rads:Number):void {
            graphics.lineTo(Math.cos(rads) * radius + x, Math.sin(rads) * radius + y);
            _rads = rads;
        };
        var sidesToDraw:int = Math.floor(percentage * sides);
        for (var i:int = 0; i <= sidesToDraw; i++)
            lineToRadians((i / sides) * (Math.PI * 2) + rotation);
        if (percentage * sides != sidesToDraw)
            lineToRadians(percentage * (Math.PI * 2) + rotation);
    }

    /**
     * Crée une explosion de O
     * @param container le DisplayObjectContainer dans lequel sont addChild les O
     * @param center l'objet Point définissant le centre de l'explosion dans le container
     * @param delay le délai de l'explosion en millisecondes
     * @param scale l'échelle des O
     */
    public static function createExplosion(container:DisplayObjectContainer, center:Point, delay:uint = 0, scale:Number = 1):void {
        setTimeout(function ():void {
            for (var i:uint = 0; i < 20; i++) {
                var p:Particle = new Particle();
                p.mouseEnabled = false;
                p.mouseChildren = false;
                p.x = center.x;
                p.y = center.y;
                p.scaleX = scale;
                p.scaleY = scale;
                container.addChild(p);
            }
        }, delay);
    }

    /**
     * Crée une pluie de confettis qui tombent depuis le haut de l'écran
     * @param container le DisplayObjectContainer dans lequel sont addChild les confettis
     * @param duration la durée de génération des confettis en millisecondes
     */
    public static function fallingConfettis(container:DisplayObjectContainer, duration:uint):void {
        createConfetti();

        var stop:Boolean = false;
        setTimeout(function ():void {
            stop = true;
        }, duration);

        function createConfetti():void {
            for (var i:uint = 0; i < 3; i++) {
                Confetti.fallingConfetti(container);
            }
            if (!stop) setTimeout(createConfetti, 10);
        }
    }

    /**
     * Crée une explosion de confettis
     * @param container le DisplayObjectContainer dans lequel sont addChild les confettis
     * @param confetti_num le nombre de confettis créés
     * @param center l'objet Point définissant le centre de l'explosion dans le container
     */
    public static function explodingConfettis(container:DisplayObjectContainer, confetti_num:uint, center:Point):void {
        for (var i:uint = 0; i < confetti_num; i++) {
            Confetti.explodingConfetti(container, center, Const.ALL);
        }
    }

    /**
     * Crée une projection de confettis
     * @param container le DisplayObjectContainer dans lequel sont addChild les confettis
     * @param duration la durée de génération des confettis en millisecondes
     * @param center l'objet Point définissant le centre de l'explosion dans le container
     * @param direction indique la direction des confettis (ALL, UP_LEFT ou UP_RIGHT)
     */
    public static function projectingConfettis(container:DisplayObjectContainer, duration:uint, center:Point, direction:String = Const.ALL):void {
        createConfetti();

        var stop:Boolean = false;
        setTimeout(function ():void {
            stop = true;
        }, duration);

        function createConfetti():void {
            for (var i:uint = 0; i < 3; i++) {
                Confetti.explodingConfetti(container, center, direction);
            }
            if (!stop) setTimeout(createConfetti, 10);
        }
    }

    /**
     * clone
     *
     * @param source l'objet à cloner
     *
     */
    public static function clone(source:Object):* {
        var myBA:ByteArray = new ByteArray();
        myBA.writeObject(source);
        myBA.position = 0;
        return (myBA.readObject());
    }
}
}