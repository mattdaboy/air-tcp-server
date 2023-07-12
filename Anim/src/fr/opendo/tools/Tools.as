package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Power2;
import com.hurlant.util.Base64;

import flash.desktop.NativeApplication;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.display.StageDisplayState;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;
import flash.utils.setTimeout;

import fr.opendo.data.DataConst;
import fr.opendo.data.DataManager;
import fr.opendo.data.UserData;
import fr.opendo.medias.Base64Files;
import fr.opendo.medias.ImageLoader;

/**
 * @author matthieu
 */
public class Tools {
    private static var _dispatcher:EventDispatcher = new EventDispatcher();

    public function Tools() {
        throw new Error("!!! Tools est un singleton et ne peut pas être instancié !!!");
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
            final_chain = replaceString(final_chain, search, replace);
        }
        return final_chain;
    }

    public static function randomStringNumber(strlen:int):String {
        var chars:String = "123456789";
        var num_chars:int = chars.length - 1;
        var randomChar:String = "";
        for (var i:uint = 0; i < strlen; i++) {
            randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
        }
        return randomChar;
    }

    public static function randomNumberSeries(serieslen:int):String {
        var randomChar:String = "";
        if (serieslen < 1) serieslen = 1;
        for (var i:uint = 0; i < serieslen; i++) {
            if (i < serieslen - 1) randomChar += randomStringNumber(3) + ".";
            if (i == serieslen - 1) randomChar += randomStringNumber(3);
        }
        return randomChar;
    }

    /**
     * enlève les espaces avant et après la chaine de caractère
     * @param str la chaine de caractère
     */
    public static function trimWhitespace(str:String):String {
        if (str == null) {
            return "";
        }
        return str.replace(/^\s+|\s+$/g, "");
    }

    /**
     * Enlève tous les caractères qui ne sont pas alphanumériques
     * @param source la chaine de caractère
     * @param space_char
     * @space_char le string qui remplace les espaces
     */
    public static function cleanSpecialChars(source:String, space_char:String = "-"):String {
        source = source.toLowerCase();
        source = source.replace(/[àáâãäåæā]/g, "a");
        source = source.replace(/[èéêëęėē]/g, "e");
        source = source.replace(/[îïìíįī]/g, "i");
        source = source.replace(/[ôöœòóõøō]/g, "o");
        source = source.replace(/[ûüùúū]/g, "u");
        source = source.replace(/ÿ/g, "y");
        source = source.replace(/[çćč]/g, "c");
        source = source.replace(/[ñń]/g, "c");
        source = source.replace(/[^a-z0-9.]/gi, space_char); // final clean up
        return source;
    }

    public static function addOTimestampTo(file_name:String):String {
        if (file_name.indexOf(Const.FILENAME_SUFFIXE_SEPARATOR) != -1)
            return file_name;

        var str:String = file_name.substring(0, file_name.lastIndexOf("."));
        var extension:String = file_name.substring(file_name.lastIndexOf("."));
        str += Const.FILENAME_SUFFIXE_SEPARATOR + new Date().time + extension;
        return str;
    }

    public static function addSuffixe(file_name:String, suffixe:String):String {
        var str:String = file_name.substring(0, file_name.lastIndexOf("."));
        var extension:String = file_name.substring(file_name.lastIndexOf("."));
        str += suffixe + extension;
        return str;
    }

    public static function getFilenameWithoutOTimestamp(file_name:String):String {
        if (file_name.indexOf(Const.FILENAME_SUFFIXE_SEPARATOR) != -1) {
            var name_without_otimestamp:String = file_name.substr(0, file_name.indexOf(Const.FILENAME_SUFFIXE_SEPARATOR));
            var extension:String = file_name.substring(file_name.lastIndexOf("."));
            file_name = name_without_otimestamp + extension;
        }
        return file_name;
    }

    public static function splitString(str:String, char:String):Array {
        var part1:String = str.substr(0, str.indexOf(char));
        var part2:String = str.substr(str.indexOf(char) + 1);
        var array:Array = [part1, part2];
        return array;
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

    public static function removeCarriageReturnsAndNewLines(myString:String):String {
        var newString:String;
        var findCarriageReturnRegExp:RegExp = new RegExp("\r", "gi");
        newString = myString.replace(findCarriageReturnRegExp, "");
        var findNewLineRegExp:RegExp = new RegExp("\n", "gi");
        newString = newString.replace(findNewLineRegExp, "");
        return newString;
    }

    public static function replaceTabsAndNewLinesBySpace($str:String):String {
        var rex:RegExp = /(\t|\n|\r)/gi;
        $str = $str.replace(rex, ' ');
        return $str;
    }

    public static function randomString(strlen:Number):String {
        var chars:String = "abcdefghijkmnopqrstuvwxyz";
        var num_chars:Number = chars.length - 1;
        var randomChar:String = "";

        for (var i:Number = 0; i < strlen; i++) {
            randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
        }
        return randomChar;
    }

    /**
     * Ajoute les balises CDATA à une string
     * @param str la string à encapsuler
     */
    public static function addCData(str:String):XML {
        return XML("<![CDATA[" + str + "]]>");
    }

    /**
     * Transforme un String en Base64
     * @param str la string à transformer
     */
    public static function stringToBase64(str:String):String {
        var bytes:ByteArray = new ByteArray();
        bytes.writeMultiByte(str, "iso-8859-1");
        var result:String = Base64.encodeByteArray(bytes);
        return result;
    }

    /**
     * Transforme un Base64 en String
     * @param str la string à transformer
     */
    public static function base64ToString(str:String):String {
        var bytes:ByteArray = Base64.decodeToByteArray(str);
        var result:String = bytes.toString();
        return result;
    }

    /**
     * Renvoie true si le string comporte opendo.fr et false si c'est un base64
     * @param photo_string la string à analyser
     */
    public static function isPhotoUrl(photo_string:String):Boolean {
        var ret:Boolean = false;
        if (photo_string.indexOf("opendo.fr/") != -1) ret = true;
        return ret;
    }

    /**
     * Renvoie true si le string comporte opendo.fr et false si c'est un base64
     * @param photo_string la string à analyser
     */
    public static function isPhotoLocalImage(photo_string:String):Boolean {
        var ret:Boolean = false;
        if (photo_string.indexOf(".") != -1) ret = true;
        return ret;
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // Number Tools
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Arrondir n, à p chiffre(s) après la virgule
     * @param n le nombre à arrondir
     * @param p nombre de chiffre après a virgule
     */
    public static function arrondir(n:Number, p:Number):Number {
        // Si p = 1, pas de décimal
        // Si p = 10, arrondi au dixième
        // Si p = 100, arrondi au centième
        // etc...
        return Math.round(n * p) / p;
    }

    public static function randomize(a:*, b:*):int {
        return (Math.random() > .5) ? 1 : -1;
    }

    /**
     * convertToHHMMSS
     * @param secondes les secondes à convertir
     */
    public static function convertToHHMMSS(secondes:Number):String {
        var s:Number = secondes % 60;
        var m:Number = Math.floor((secondes % 3600) / 60);
        var h:Number = Math.floor(secondes / (60 * 60));
        var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
        var minuteStr:String = doubleDigitFormat(m) + ":";
        var secondsStr:String = doubleDigitFormat(s);

        return hourStr + minuteStr + secondsStr;
    }

    /**
     * convertToMMSS
     * @param secondes les secondes à convertir
     */
    public static function convertToMMSS(secondes:Number):String {
        var s:Number = secondes % 60;
        var m:Number = Math.floor((secondes % 3600) / 60);
        var minuteStr:String = doubleDigitFormat(m) + ":";
        var secondsStr:String = doubleDigitFormat(s);

        return minuteStr + secondsStr;
    }

    private static function doubleDigitFormat($num:uint):String {
        if ($num < 10) {
            return ("0" + $num);
        }
        return String($num);
    }

    /**
     * secToDuration
     * @param sec les secondes à convertir en mm:ss
     */
    public static function secToDuration(sec:uint):String {
        var min:uint = sec / 60;
        var min_def:String;
        if (min < 10) {
            if (min != 0)
                min_def = "0" + min as String;
            else
                min_def = "00";
        } else {
            min_def = "" + min as String;
        }
        var sec_left:uint = sec - 60 * min;
        var sec_def:String;
        if (sec_left < 10) {
            if (sec_left != 0)
                sec_def = "0" + sec_left as String;
            else
                sec_def = "00";
        } else {
            sec_def = "" + sec_left as String;
        }
        return (min_def + ":" + sec_def);
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // XML Tools
    // ----------------------------------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Extraire un noeud dans un XML par son nom
     * @param xml le XML à parcourir
     * @param nodeName le noeud à extraire
     */
    public static function getNodeListByName(xml:XML, nodeName:String):XMLList {
        return xml.descendants(nodeName);
    }

    public static function replaceNodeName(node:XML, nodeName:String):void {
        node.parent().replace(node.name(), <{nodeName}>{node.toString()}</{nodeName}>);
    }

    public static function getNodeIndex(node_to_scan:XMLList, node_to_find:XML):int {
        var index:int = -1;
        for (var i:uint = 0; i < node_to_scan.length(); i++) {
            if (node_to_scan[i].contains(node_to_find)) return i;
        }
        return index;
    }

    public static function addIdToModules(xml:XML):void {
        var modules_list:XMLList = getNodeListByName(xml, "module");

        // On détermine l'id max dans la liste de modules pour incrémenter à partir de cet id
        var next_available_id:uint = getNextAvailableModuleId(modules_list);

        // On ajoute les id pour les modules qui n'en ont pas, en incrémentant à partir de max_id
        for each (var node:XML in modules_list) {
            if (!isNodeExists(node, "id")) {
                setModuleId(node, next_available_id);
                next_available_id++;
            }
            if (node.id == "") {
                node.id = next_available_id;
                next_available_id++;
            }
        }
    }

    public static function getNextAvailableModuleId(modules_list:XMLList):uint {
        var max_id:uint = 0;
        for each (var node:XML in modules_list) {
            if (node.id.length() != 0) {
                if (uint(node.id) > max_id) {
                    max_id = uint(node.id);
                }
            }
        }
        return max_id + 1;
    }

    public static function setModuleId(module:XML, id:uint):void {
        module.appendChild(XML(<id>{id}</id>));
    }

    public static function cleanBrokenModule(content:XML):XML {
        var temp:String;
        for (var i:uint = 0; i < content.module.length(); i++) {
            temp = content.module[i].toXMLString();
            temp = Tools.replaceString(temp, "&lt;", "<");
            temp = Tools.replaceString(temp, "&gt;", ">");
            if (temp.indexOf("<module>null<module>") != -1) delete content.module[i];
        }
        return content;
    }

    public static function parseSessionXML(modules_session_xml:XML):XML {
        // 1. TRAITEMENT DE DIFFERENTS BUGS
        // --------------------------------

        // Si le xml de la session est vide (même pas de balise <content>)
        // Update 12.11 (bug DB Tristan Couedel)
        var temp:String = modules_session_xml.toXMLString();
        if (temp == "") temp = "<content></content>";

        // Traitement des modules nom de code "BROKEN" (encodage des chevrons altéré, string null après le noeud ouvrant, double noeud <module>) :
        //  <module>null&lt;module&gt;
        //  &lt;titre&gt;&lt;![CDATA[FORMULAIRE3]]&gt;&lt;/titre&gt;
        //  &lt;type&gt;form&lt;/type&gt;
        //  &lt;actif&gt;1&lt;/actif&gt;
        //  &lt;fond&gt;
        //  &lt;file_name/&gt;
        //  &lt;/fond&gt;
        //  &lt;id&gt;4&lt;/id&gt;
        //  &lt;/module&gt;</module>
        // Remplacement des chevrons dont l'encodage a sauté
        // Remarque : la cause de cette altération reste à découvrir et à corriger (2023-04-14)
        temp = Tools.replaceString(temp, "&lt;", "<");
        temp = Tools.replaceString(temp, "&gt;", ">");

        // Si on trouve un noeud module dans un noeud module, on stocke temporairement le noeud <module> interne,
        // on supprime le premier noeud (qui contient null, au passage) et on appendChild le noeud stocké temporairement.
        // Remarque : ça déplace l'activité à la fin de la session, mais c'est déjà ça ;)
        // (Bug opendo Cécile Gachignard 2023-04-07)
        var cleaned_modules_session_xml:XML = new XML(temp);
        var i:int;
        for (i = cleaned_modules_session_xml.module.length() - 1; i >= 0; i--) {
            if (cleaned_modules_session_xml.module[i].module.length() > 0) {
                var temp_xml:XML = new XML(cleaned_modules_session_xml.module[i].module[0].toString());
                delete cleaned_modules_session_xml.module[i];
                cleaned_modules_session_xml.appendChild(temp_xml);
            }
        }
        // Fin du traitement des modules nom de code "BROKEN"

        var type:String;
        for (i = cleaned_modules_session_xml.module.length() - 1; i >= 0; i--) {
            type = cleaned_modules_session_xml.module[i].type;
            if (String(type) == "contenu") {
                for (var k:int = cleaned_modules_session_xml.module[i].contenus.item.length() - 1; k >= 0; k--) {
                    if (cleaned_modules_session_xml.module[i].contenus.item[k].img.length() > 0) delete cleaned_modules_session_xml.module[i].contenus.item[k];
                }
            }

            // Modification 10.1.3 pour désactiver le module Evaluation des compétences (et BD accessoirement)
            if (String(type) == "eval" || String(type) == "bd") delete cleaned_modules_session_xml.module[i];
        }

        // Q&A (2023-01-30)
        for (i = cleaned_modules_session_xml.module.length() - 1; i >= 0; i--) {
            type = cleaned_modules_session_xml.module[i].type;
            if (String(type) == "qanda" && cleaned_modules_session_xml.module[i].contenus.toString() != "")
                cleaned_modules_session_xml.module[i].contenus.setChildren("");
        }

        // 2. AJOUT D'ELEMENTS
        // --------------------------------

        var list:XMLList;
        var node:XML;

        // Ajout d'un id pour chaque activité
        addIdToModules(cleaned_modules_session_xml);

        // Ajout de noeuds de PDFS et Notes preformatées de session
        // paramètres additionnels de session
        // Update 10.0
        if (!isNodeExists(cleaned_modules_session_xml, "params")) cleaned_modules_session_xml.appendChild(DataConst.SESSION_PARAMS_XML);

        // Ajout du noeud locked_email
        // paramètres additionnels de session
        // Update 12.0
        if (!isNodeExists(XML(cleaned_modules_session_xml.params), "locked_email")) cleaned_modules_session_xml.params.appendChild(DataConst.LOCKED_EMAIL_XML);

        // Ajout de noeud de fond de session
        // Update 11.1+
        if (!isNodeExists(cleaned_modules_session_xml, "fond")) cleaned_modules_session_xml.appendChild(DataConst.SESSION_FOND);

        // Ajout du noeud anim_messages
        // Update 12.11
        list = getNodeListByName(cleaned_modules_session_xml, "group_name");
        for each (node in list) {
            if (!isNodeExists(node.parent(), "anim_messages")) node.parent().appendChild(new XML(<anim_messages/>));
        }

        // Ajout de noeud de date de synchro avec Opendo Cloud
        // Update 12.18+
        if (!isNodeExists(cleaned_modules_session_xml, "synchro_date")) cleaned_modules_session_xml.appendChild(new XML(DataConst.SYNCHRO_OLD_DATE_XML));
        // update 12.19
        if (!isNodeExists(cleaned_modules_session_xml, "session_deleted")) cleaned_modules_session_xml.appendChild(new XML(DataConst.SESSION_DELETED_XML));

        // Date de synchro à 2 nombres (jj-mm) lors d'une duplication (<12.19.x)
        if (cleaned_modules_session_xml.synchro_date.toString().length <= 5) cleaned_modules_session_xml.synchro_date.setChildren(DateUtils.dateToIso(new Date()));

        // Ajout du  noeud sequence dans sondage
        // Update 13.0+
        // Q&A (2023-01-30)
        for (i = cleaned_modules_session_xml.module.length() - 1; i >= 0; i--) {
            type = cleaned_modules_session_xml.module[i].type;
            if (String(type) == "sondage") {
                if (cleaned_modules_session_xml.module[i].sequence.length() == 0) {
                    cleaned_modules_session_xml.module[i].appendChild(new XML(<sequence>0</sequence>));
                }
            }
        }

        // 3. RENOMMAGE DES NOEUDS
        // --------------------------------

        list = getNodeListByName(cleaned_modules_session_xml, "code");
        for each (node in list) {
            if (node.nom.length() > 0) replaceNodeName(XML(node.nom), "code_name");
        }

        list = getNodeListByName(cleaned_modules_session_xml, "path");
        for each (node in list) {
            replaceNodeName(node, "file_name");
        }

        list = getNodeListByName(cleaned_modules_session_xml, "nom");
        for each (node in list) {
            replaceNodeName(node, "file_name");
        }

        // Ajout de CDATA si nécessaire dans les noeuds de contenu texte
        // module titre, quiz, animationCode question pour un champion, administratif, maths, situation, presence
        // maths : q, valeur, unite, solution
        var tab:Vector.<String> = new <String>["titre", "q", "r", "code_name", "reponse", "texte", "valeur", "unite", "solution", "consigne", "disclaimer_text", "footer_text", "txt", "group_name", "corps"];
        for each(var node_name:String in tab) {
            list = getNodeListByName(cleaned_modules_session_xml, node_name);
            for each (node in list) {
                if (node.toXMLString().indexOf("<![CDATA[") == -1 && node.children().length() == 1) {
                    node.setChildren(addCData(node.toString()));
                }
            }
        }

        // Cas particulier : lors de l'import d'un XML, si on a les 2 noeuds <img> et <base64>, on supprime <img>
        list = getNodeListByName(cleaned_modules_session_xml, "base64");
        for each (node in list) {
            if (node.parent().img.length() > 0) delete node.parent().img;
        }

        list = getNodeListByName(cleaned_modules_session_xml, "img");
        for each (node in list) {
            replaceNodeName(node, "base64");
        }

        list = getNodeListByName(cleaned_modules_session_xml, "file_name");
        for each (node in list) {
            if (node.toString() == "Image par défaut") node.setChildren("");
        }

        // Vérification de la présence de 2 noeuds file_name dans le même item (2022-12-08)
        list = getNodeListByName(cleaned_modules_session_xml, "file_name");
        for each (node in list) {
            if (node.parent().file_name.length() > 1) {
                for (i = 0; i < node.parent().file_name.length(); i++) {
                    if (node.parent().file_name[i].toString() == "") {
                        delete node.parent().file_name[i];
                        break;
                    }
                }
            }
        }

        // 4. ENREGISTREMENT DES BASE64 DANS Const.HTDOCS_DIR
        // --------------------------------

        var base64_str:String;
        var file_name:String;
        var file:File;

        list = getNodeListByName(cleaned_modules_session_xml, "base64");
        for each (node in list) {
            base64_str = node.toString();
            file_name = node.parent().file_name.toString();
            // Si il n'y a pas de données base64
            if (node.toString().length > 0) {
                // Si on a le nom du fichier, on vérifie si il existe dans Const.HTDOCS_DIR
                if (file_name.length != 0) {
                    file = getFileFromFilename(file_name);
                    if (!file.exists) {
                        Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                    }
                }
                // Si on n'a pas de nom de fichier (Appariemment), on en crée un au hasard
                if (file_name.length == 0) {
                    file_name = randomStringNumber(12) + ".jpg";
                    Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                    node.parent().appendChild(new XML(<file_name>{file_name}</file_name>));
                }
            }
        }

        // 5. SUPPRESSION DES NOEUDS BASE64
        // --------------------------------

        list = getNodeListByName(cleaned_modules_session_xml, "base64");
        for each (node in list) {
            delete node.parent().base64;
        }

        // tableau blanc v1 -> tbaleau V2
        // version 11 -> version 12
        var bkg_file_name:String;
        list = getNodeListByName(cleaned_modules_session_xml, "type");
        for each (node in list) {
            if (node.toString() == "tableauBlanc") {
                if (isNodeExists(node.parent(), "fond_formateur")) {
                    bkg_file_name = node.parent().fond_formateur.file_name.toString();
                    delete node.parent().fond_formateur;
                    delete node.parent().fond_apprenant;
                    node.parent().appendChild(new XML(<contenus>
                        <groupes>
                            <g>
                                <group_name><![CDATA[Groupe n°1]]></group_name>
                                <consigne><![CDATA[]]></consigne>
                                <file_name>{bkg_file_name}</file_name>
                                <anim_messages/>
                            </g>
                        </groupes>
                    </contenus>));
                }
            }
        }

        return cleaned_modules_session_xml;
    }

    public static function parseParametersXML(parameters_xml:XML):XML {
        var cleaned_parameters_xml:XML = XML(parameters_xml);
        var list:XMLList;
        var node:XML;

        // 1. RENOMMAGE DES NOEUDS
        // --------------------------------

        if (isNodeExists(XML(cleaned_parameters_xml), "interface")) {
            var interface_content:String = cleaned_parameters_xml["interface"].toString();
            interface_content = replaceString(interface_content, "<interface>", "<ihm>");
            interface_content = replaceString(interface_content, "</interface>", "</ihm>");
            delete cleaned_parameters_xml["interface"];
            if (isNodeExists(XML(cleaned_parameters_xml), "ihm")) delete cleaned_parameters_xml.ihm;
            cleaned_parameters_xml.appendChild(new XML(interface_content));
        }

        list = getNodeListByName(cleaned_parameters_xml, "logo");
        for each (node in list) {
            if (node.nom.length() > 0) replaceNodeName(XML(node.nom), "file_name");
        }

        list = getNodeListByName(cleaned_parameters_xml, "home");
        for each (node in list) {
            if (node.nom.length() > 0) replaceNodeName(XML(node.nom), "file_name");
        }

        list = getNodeListByName(cleaned_parameters_xml, "waiting");
        for each (node in list) {
            if (node.nom.length() > 0) replaceNodeName(XML(node.nom), "file_name");
        }

        list = getNodeListByName(cleaned_parameters_xml, "img");
        for each (node in list) {
            replaceNodeName(node, "base64");
        }

        list = getNodeListByName(cleaned_parameters_xml, "ihm");
        if (list.length() > 1) delete list[0]; // Si on a 2 noeuds <ihm> dans Parameters, on supprime le plus ancien

        // 2. SUPPRESSION DES INFOS INUTILES
        // --------------------------------

        list = getNodeListByName(cleaned_parameters_xml, "file_name");
        for each (node in list) {
            if (node.toString() == "Image par défaut") node.setChildren("");
        }

        // 3. AJOUT DES INFOS MANQUANTES
        // --------------------------------

        // Room
        if (!isNodeExists(cleaned_parameters_xml, "room_name")) cleaned_parameters_xml.appendChild(<room_name></room_name>);

        // IHM (anciennement interface, mais interface est un mot réservé en programmation)
        if (!isNodeExists(cleaned_parameters_xml, "ihm")) cleaned_parameters_xml.appendChild(<ihm>
            <logo>
                <file_name/>
            </logo>
            <home>
                <file_name/>
            </home>
            <waiting>
                <file_name/>
            </waiting>
            <couleur>0xC80427</couleur>
            <son>0</son>
        </ihm>);

        // Son
        if (!isNodeExists(XML(cleaned_parameters_xml.ihm), "son")) cleaned_parameters_xml.ihm.appendChild(<son>0</son>);

        // Synchro automatique des sessions avec Opendo Cloud
        // Changement de place si le noeud <synchro_auto> existe dans <ihm>
        if (isNodeExists(XML(cleaned_parameters_xml.ihm), "synchro_auto")) {
            var synchro_auto_xml:XML = new XML(cleaned_parameters_xml.ihm.synchro_auto.toXMLString());
            delete cleaned_parameters_xml.ihm.synchro_auto;
            cleaned_parameters_xml.appendChild(synchro_auto_xml);
        }
        // Création du noeud <synchro_auto> à la racine si il n'existe pas
        if (!isNodeExists(cleaned_parameters_xml, "synchro_auto")) cleaned_parameters_xml.appendChild(<synchro_auto>1</synchro_auto>);

        // Langue
        if (!isNodeExists(cleaned_parameters_xml, "langue")) cleaned_parameters_xml.appendChild(<langue>FR</langue>);

        // Onboarding (0 ou 1 : si l'utilisateur est allé au bout de son activation (abonné ou découverte)
        if (!isNodeExists(cleaned_parameters_xml, "on_boarding")) cleaned_parameters_xml.appendChild(<on_boarding>0</on_boarding>);

        // enabled (0 ou 1 : correspond à l'abonnement)
        if (!isNodeExists(cleaned_parameters_xml, "enabled")) cleaned_parameters_xml.appendChild(<enabled>0</enabled>);

        // Aide
        if (!isNodeExists(cleaned_parameters_xml, "aide")) cleaned_parameters_xml.appendChild(<aide>1</aide>);

        // News
        if (!isNodeExists(cleaned_parameters_xml, "news")) cleaned_parameters_xml.appendChild(XML(<news>
            <date>2000-01-01</date>
            <seen>false</seen>
        </news>));

        // Démarrages de l'application
        if (!isNodeExists(cleaned_parameters_xml, "startups")) cleaned_parameters_xml.appendChild(XML(<startups>
            <date>{DateUtils.dateToIso(new Date())}</date>
            <nb>0</nb>
        </startups>));

        // Infos de l'utilisateur en mode découverte
        if (!isNodeExists(cleaned_parameters_xml, "discover")) cleaned_parameters_xml.appendChild(XML(<discover>
            <date></date>
            <firstname></firstname>
            <lastname></lastname>
            <email></email>
            <phone></phone>
            <company></company>
        </discover>));

        // Optimisation de la database
        if (!isNodeExists(cleaned_parameters_xml, "db_optimisation")) cleaned_parameters_xml.appendChild(XML(<db_optimisation>
            <date></date>
            <version>0.0</version>
        </db_optimisation>));

        // 4. TRAITEMENTS DIVERS
        // --------------------------------

        // activated/on_boarding
        if (cleaned_parameters_xml.activated == "1") cleaned_parameters_xml.on_boarding = "1";

        // Aide
        if (cleaned_parameters_xml.activated == "1") cleaned_parameters_xml.aide = "0";

        // 5. ENREGISTREMENT DES BASE64 DANS Const.HTDOCS_DIR
        // --------------------------------

        var base64_str:String;
        var file_name:String;
        var file:File;

        list = getNodeListByName(cleaned_parameters_xml, "base64");
        for each (node in list) {
            base64_str = node.toString();
            file_name = node.parent().file_name.toString();
            // Si il n'y a pas de données base64
            if (node.toString().length > 0) {
                // Si on a le nom du fichier, on vérifie si il existe dans Const.HTDOCS_DIR
                if (file_name.length != 0) {
                    file = getFileFromFilename(file_name);
                    if (!file.exists) {
                        Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                    }
                }
            }
        }

        // 6. SUPPRESSION DES NOEUDS BASE64
        // --------------------------------

        list = getNodeListByName(cleaned_parameters_xml, "base64");
        for each (node in list) {
            delete node.parent().base64;
        }

        return cleaned_parameters_xml;
    }

    public static function parseUserContents(users_contents_str:String):String {
        var cleaned_str:String = users_contents_str;

        // 1. RENOMMAGE DES NOEUDS
        // --------------------------------

        if (cleaned_str.indexOf("<data>") != -1) {
            cleaned_str = replaceString(cleaned_str, "<data>", "<content>");
            cleaned_str = replaceString(cleaned_str, "</data>", "</content>");
        }

        if (cleaned_str.indexOf("<content>") == -1) {
            cleaned_str = "<content><![CDATA[" + cleaned_str + "]]></content>";
        }

        // 2. AJOUT DE CDATA (si nécessaire dans les noeuds de contenu texte)
        // --------------------------------

        var list:XMLList;
        var node:XML;
        var cleaned_xml:XML = XML(cleaned_str);

        var tab:Vector.<String> = new <String>["msg", "user_prenom", "prenom", "nom", "entreprise", "metier", "adresse", "txt"];
        for each(var node_name:String in tab) {
            list = getNodeListByName(cleaned_xml, node_name);
            for each (node in list) {
                if (node.toXMLString().indexOf("<![CDATA[") == -1 && node.children().length() == 1) {
                    node.setChildren(addCData(node.toString()));
                }
            }
        }

        // 3. MODIFICATION DES NOEUDS DE FORMULAIRE ADMINISTRATIF
        // --------------------------------

        var value:String;

        list = getNodeListByName(cleaned_xml, "item");
        for each (node in list) {
            // Modification du noeud check
            if (isNodeExists(node, "check")) {
                if (!isNodeExists(XML(node.check), "show")) {
                    value = node.check.toString();
                    delete node.check;
                    node.appendChild(new XML(<check>
                        <show>{value}</show>
                    </check>));
                }
            }

            // Modification du noeud photo
            if (node.type.toString() == "profil") {
                if (isNodeExists(node, "photo")) {
                    value = node.photo.toString();
                    delete node.photo;
                    node.appendChild(new XML(<picture>
                        <photo>{value}</photo>
                    </picture>));
                }
            }
            if (node.type.toString() != "profil") {
                if (isNodeExists(node, "picture"))
                    if (isNodeExists(XML(node.picture), "file_name"))
                        if (node.picture.file_name.length() > 1)
                            delete node.picture.file_name[0];
            }

            // Modification du noeud signature
            if (isNodeExists(node, "signature")) {
                if (!isNodeExists(XML(node.signature), "file_name")) {
                    value = node.signature.toString();
                    delete node.signature;
                    node.appendChild(new XML(<signature>
                        <photo>{value}</photo>
                    </signature>));
                }
            }
        }

        // 4. ENREGISTREMENT DES BASE64 DANS Const.HTDOCS_DIR
        // --------------------------------

        var base64_str:String;
        var file_name:String;
        var file:File;

        list = getNodeListByName(cleaned_xml, "photo");
        for each (node in list) {
            base64_str = node.toString();
            if (base64_str.indexOf("/9j/4AA") != -1 || base64_str.indexOf("iVBORw0KGgoAA") != -1) {
                file_name = node.parent().file_name.toString();
                // Si il n'y a pas de données base64
                if (node.toString().length > 0 && node.toString() != "0") {
                    // Si on a le nom du fichier, on vérifie si il existe dans Const.HTDOCS_DIR
                    if (file_name.length != 0) {
                        file = getFileFromFilename(file_name);
                        if (!file.exists) {
                            Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                        }
                    }
                    // Si on n'a pas de nom de fichier (Appariemment), on en crée un au hasard
                    if (file_name.length == 0) {
                        file_name = randomStringNumber(12) + ".jpg";
                        Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                        node.parent().appendChild(new XML(<file_name>{file_name}</file_name>));
                    }
                }
            } else {
                node.parent().appendChild(new XML(<file_name>{base64_str}</file_name>));
            }
        }

        list = getNodeListByName(cleaned_xml, "user_photo");
        for each (node in list) {
            base64_str = node.toString();
            if (base64_str.indexOf("/9j/4AA") != -1) {
                file_name = randomStringNumber(12) + ".jpg";
                Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                node.setChildren(file_name);
            }
        }

        // Dessin libre
        if (cleaned_xml.toString().indexOf("/9j/4AA") == 0 || cleaned_xml.toString().indexOf("iVBORw0KGgoAA") == 0) {
            base64_str = cleaned_xml.toString();
            file_name = randomStringNumber(12) + ".jpg";
            Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
            cleaned_xml.setChildren(file_name);
        }

        // 5. SUPPRESSION DES NOEUDS BASE64
        // --------------------------------

        list = getNodeListByName(cleaned_xml, "photo");
        for each (node in list) {
            delete node.parent().photo;
        }
        cleaned_str = cleaned_xml.toXMLString();
        return cleaned_str;
    }

    public static function parseUserPresences(str:String):String {
        var cleaned_str:String = str;

        // 1. AJOUT DE CDATA (si nécessaire dans les noeuds de contenu texte)
        // --------------------------------

        var list:XMLList;
        var node:XML;
        var cleaned_xml:XML = XML(cleaned_str);
        var tab:Vector.<String> = new <String>["disclaimer_text", "footer_text"];
        for each(var node_name:String in tab) {
            list = getNodeListByName(cleaned_xml, node_name);
            for each (node in list) {
                if (node.toXMLString().indexOf("<![CDATA[") == -1 && node.children().length() == 1) {
                    node.setChildren(addCData(node.toString()));
                }
            }
        }

        // 2. ENREGISTREMENT DES BASE64 DANS Const.HTDOCS_DIR ET MODIFICATIONS DES NOEUDS signature et photo_id
        // --------------------------------

        var base64_str:String;
        var file_name:String;
        var file:File;

        list = getNodeListByName(cleaned_xml, "file_name");
        for each (node in list) {
            if (node.parent().name() != "photo_id" && node.parent().name() != "signature") {
                node.parent().appendChild(new XML(<signature>
                    <file_name>{node.toString()}</file_name>
                </signature>));
                delete node.parent().file_name;
            }
        }

        list = getNodeListByName(cleaned_xml, "signature");
        for each (node in list) {
            if (isNodeExists(node, "file_name")) break;
            base64_str = node.toString();
            file_name = node.file_name.toString();
            // Si il y a du contenu dans le noeud
            if (node.toString().length > 0) {
                // Si on a le nom du fichier, on vérifie si il existe dans Const.HTDOCS_DIR
                if (file_name.length != 0) {
                    file = getFileFromFilename(file_name);
                    if (!file.exists) {
                        Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                    }
                }
                // Si on n'a pas de nom de fichier, on en crée un au hasard
                if (file_name.length == 0) {
                    file_name = randomStringNumber(12) + ".jpg";
                    Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                    node.setChildren(new XML(<file_name>{file_name}</file_name>));
                }
            }
        }

        list = getNodeListByName(cleaned_xml, "photo_id");
        for each (node in list) {
            if (isNodeExists(node, "file_name")) break;
            base64_str = node.toString();
            file_name = node.file_name.toString();
            // Si il y a du contenu dans le noeud
            if (node.toString().length > 0) {
                // Si on a le nom du fichier, on vérifie si il existe dans Const.HTDOCS_DIR
                if (file_name.length != 0) {
                    file = getFileFromFilename(file_name);
                    if (!file.exists) {
                        Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                    }
                }
                // Si on n'a pas de nom de fichier, on en crée un au hasard
                if (file_name.length == 0) {
                    file_name = randomStringNumber(12) + ".jpg";
                    Base64Files.Base64ToFile(base64_str, Const.HTDOCS_DIR + File.separator + file_name);
                    node.setChildren(new XML(<file_name>{file_name}</file_name>));
                }
            }
        }

        // 3. Correction des noms de sessions pour ne pas casser le process d'enregistrement sur disque
        // --------------------------------


        cleaned_str = cleaned_xml.toXMLString();
        return cleaned_str;
    }

    public static function parseUserPhoto(email:String, photo:String):String {
        var photo_filename:String = "" + photo;

        // 1. TRANSFORMATION DE PHOTO EN JPG
        // --------------------------------

        if (photo.indexOf(".") == -1 && photo_filename.length > 4) {
            photo_filename = "photo_" + email + ".jpg";
            Base64Files.Base64ToFile(photo, Const.HTDOCS_DIR + File.separator + photo_filename);
        }

        if (photo_filename.length <= 4) photo_filename = "Opendo_avatar_2.png";
        return photo_filename;
    }

    public static function parseSnapshots(snapshot:ByteArray):String {
        // 1. TRANSFORMATION DE BYTEARRAY EN FICHIER
        // --------------------------------

        var file_name:String = "snapshot_" + Tools.randomStringNumber(12) + ".jpg";
        Tools.saveByteArrayToFile(snapshot, file_name);

        return file_name;
    }

    /**
     * Retourne l'existence d'un noeud
     * @param parent_node le noeud dans lequel chercher
     * @param nodeName le noeud à tester
     */
    public static function isNodeExists(parent_node:XML, nodeName:String):Boolean {
        var result:Boolean = false;
        if (parent_node.descendants(nodeName) != undefined) result = true;
        return result;
    }

    /**
     * Retourne le xml des parameters data envoyé au part adapté à l'ancienne version (inférieure à V12)
     * @param data : l'xml à convertir
     *
     */
    public static function convertParametersDataV12ToOldParametersData(data:XML):XML {
        var new_ihm:XML = new XML(data);
        XML(new_ihm.logo).appendChild(<img/>);
        XML(new_ihm.waiting).appendChild(<img/>);
        return new_ihm;
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

    public static function copyFileTo(source_file_path:String, target_file_path:String):void {
        var source:File = File.applicationDirectory.resolvePath(source_file_path);
        if (!source.exists) return;
        source.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        source.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);

        var target:File = File.applicationStorageDirectory.resolvePath(target_file_path);
        if (target.exists) {
            if (source.modificationDate > target.modificationDate) source.copyTo(target, true);
        } else {
            source.copyTo(target);
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
            Main.instance.showMayday("COPY FOLDER " + source_path.toUpperCase());
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
            Main.instance.showMayday("COPY FILE " + source_file_path.toUpperCase());
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

    public static function saveByteArrayToFile(byte_array:ByteArray, file_name:String):File {
        var destination_file:File;

        destination_file = Tools.getFileFromFilename(file_name);
        var file_stream:FileStream = new FileStream;
        file_stream.open(destination_file, FileMode.WRITE);
        file_stream.writeBytes(byte_array);
        file_stream.close();

        return destination_file;
    }

// ////////////////////////////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------
// Particles Tools
// ----------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////////////////////////////

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
     * @param direction la direction des confettis (ALL, UP_LEFT ou UP_RIGHT)
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
     * Crée une envolée d'étoiles qui partent du bas de l'écran
     * @param container le DisplayObjectContainer dans lequel sont addChild les étoiles
     * @param duration la durée de génération des étoiles en millisecondes
     */
    public static function createStars(container:DisplayObjectContainer, duration:uint):void {
        createStar();

        var stop:Boolean = false;
        setTimeout(function ():void {
            stop = true;
        }, duration);

        function createStar():void {
            var posx:int = ScreenSize.left + (Math.random() * ScreenSize.width);
            var posy:int = ScreenSize.bottom;

            var c:Star = new Star();
            c.mouseEnabled = false;
            c.mouseChildren = false;
            c.x = posx;
            c.y = posy;
            c.z = (Math.random() * 3000) - 1500;
            container.addChild(c);

            if (!stop) setTimeout(createStar, 10);
        }
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
            type = Const.MACOS;
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
            type = Const.MAC;
        }
        if (os.indexOf("Windows") != -1) {
            type = Const.PC;
        }
        if (os.indexOf("iPadOS") != -1) {
            type = Const.IPAD;
            version = temp[2];
        }
        if (os.indexOf("iPhone") != -1) {
            type = Const.IPHONE;
            version = temp[3];
        }
        if (manufacturer.indexOf("Android") != -1) {
            var screen_ratio:Number = Capabilities.screenResolutionX / Capabilities.screenResolutionY;
            (screen_ratio > (16 / 9)) ? type = Const.ANDROID_PHONE : type = Const.ANDROID_TABLET;
        }
        result = {type: type, version: version};
        return result;
    }

    public static function get screenResolution():String {
        return Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
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

// ////////////////////////////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------
// Display Tools
// ----------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////////////////////////////

    public static function setClicZoneSize(label:TextField, clic_zone:DisplayObject):void {
        label.autoSize = TextFieldAutoSize.LEFT;
        clic_zone.width = label.x + label.width + 20;
    }

    public static function centerInView(display_object:DisplayObject):void {
        display_object.x = 960 - display_object.width / 2;
    }

    public static function safeRemoveChild(parent:DisplayObjectContainer, child:*):void {
        if (parent) {
            for (var i:uint = 0; i < parent.numChildren; i++) {
                if (parent.getChildAt(i) == child) {
                    parent.removeChild(child);
                }
            }
        }
    }

    public static function displayUserPhoto(container:DisplayObjectContainer, photo:Bitmap, w:uint, h:uint, r:uint = 0):void {
        if (!photo) return;

        photo.width = w;
        photo.height = h;
        container.addChild(photo);
        CustomMask.setMask(photo, photo.x, photo.y, photo.width, photo.height, r);
    }

    public static function displayUserPhotoByEmail(container:DisplayObjectContainer, email:String, w:uint, h:uint, r:uint = 0, animation:Boolean = false):void {
        var user_data:UserData = DataManager.getUserDataByEmail(email);
        var file_name:String = user_data.photoFilename;

        if (file_name != "") {
            var image_loader:ImageLoader = new ImageLoader(ImageLoader.FILL, w, h, r, animation);
            container.addChild(image_loader);

            if (Tools.isPhotoLocalImage(file_name)) {
                var file:File = Tools.getFileFromFilename(file_name);
                image_loader.load(file.url);
            } else {
                image_loader.load(file_name);
            }
        }
    }

    /**
     * alignObjectInPlaceHolder
     * @param object l'objet qui va se redimensionner (en respectant son ratio) et se placer au centre du placeHolder
     * @param placeHolder la zone dans lequel l'object va se centrer et se redimensionner
     * @param resizeObject resize homothétique
     * @param width la largeur du placeHolder si jamais celui-là est vide et qu'on veut en forcer une
     * @param height la hauteur du placeHolder si jamais celui-là est vide et qu'on veut en forcer une
     */
    public static function alignObjectInPlaceHolder(object:DisplayObject, placeHolder:DisplayObject, resizeObject:Boolean = true, width:Number = 0, height:Number = 0):void {
        var w:Number;
        var h:Number;
        if (width != 0) {
            w = width;
        } else {
            w = placeHolder.width;
        }
        if (height != 0) {
            h = height;
        } else {
            h = placeHolder.height;
        }
        if (resizeObject) {
            var placeholder_ratio:Number = w / h;
            var object_ratio:Number = object.width / object.height;
            if (object_ratio <= placeholder_ratio) {
                object.height = h;
                object.scaleX = object.scaleY;
            } else {
                object.width = w;
                object.scaleY = object.scaleX;
            }
        }
        object.x = Math.round((w - object.width) / 2);
        object.y = Math.round((h - object.height) / 2);
    }

    /**
     * objectInZone
     * @param object l'objet qui va se redimensionner (en respectant son ratio)
     * @param width la largeur de la zone
     * @param height la hauteur de la zone
     * @param zoom définit comment l'objet se redimensionne par rapport à la zone (FIT : tient dans la zone, FILL : remplit la zone)
     */
    public static function objectInPlaceHolder(object:DisplayObject, width:Number, height:Number, zoom:String = Const.FIT):void {
        var w:Number = width;
        var h:Number = height;

        var zone_ratio:Number = w / h;
        var object_ratio:Number = object.width / object.height;

        switch (zoom) {
            case Const.FIT :
                if (object_ratio <= zone_ratio) {
                    object.height = h;
                    object.scaleX = object.scaleY;
                } else {
                    object.width = w;
                    object.scaleY = object.scaleX;
                }
                break;
            case Const.FILL :
                if (object_ratio <= zone_ratio) {
                    object.width = w;
                    object.scaleY = object.scaleX;
                } else {
                    object.height = h;
                    object.scaleX = object.scaleY;
                }
                break;
        }

        object.x = Math.round((w - object.width) / 2);
        object.y = Math.round((h - object.height) / 2);
    }

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

    /**
     * Renvoie le BT du module selon le type d'activité dans le XML
     * la classe du bouton dans la lib est Bt+NomModule+View
     * @param module_type le type de l'activité
     */
    public static function getBtViewByType(module_type:String):MovieClip {
        var ctype:String = module_type.substring(0, 1).toUpperCase();
        var atype:String = module_type.substring(1);
        var nomClassModule:String = "Bt" + ctype + atype + "View";
        var classM:Class = getDefinitionByName(nomClassModule) as Class;
        var view:MovieClip = new classM();
        return view;
    }

    /**
     * Renvoie le BT Editor du module selon le type d'activité dans le XML
     * la classe du bouton dans la lib est Editor+NomModule+BtView
     * @param module_type le type de l'activité
     */
    public static function getEditorBtViewByType(module_type:String):MovieClip {
        // Forced import
        var imports:Array = [EditorTableauBlancBtView, EditorAnimationBtView, EditorSituationBtView, EditorDessinBtView, EditorIdBtView, EditorPuzzleBtView, EditorDebriefingBtView, EditorQuestionBtView, EditorQuizBtView, EditorSondageBtView, EditorOpenfileBtView, EditorContenuBtView, EditorAnimationCodeBtView, EditorAdministratifBtView, EditorFormBtView, EditorMathsBtView, EditorQandaBtView, EditorPresenceBtView, EditorPairBtView, EditorCardpickerBtView, EditorWhoisBtView, EditorVideosynchroBtView, EditorTracesBtView, EditorNuageBtView];

        var ctype:String = module_type.substring(0, 1).toUpperCase();
        var atype:String = module_type.substring(1);
        var nomClassBt:String = "Editor" + ctype + atype + "BtView";
        var classM:Class = getDefinitionByName(nomClassBt) as Class;
        var view:MovieClip = new classM();
        return view;
    }

    /**
     * Renvoie la vue du module selon le type d'activité dans le XML
     * la classe du module dans src est fr.opendo.editor.modules.+NomModule+Edit
     * @param module_type le type de l'activité
     */
    public static function getEditorModuleViewByType(module_type:String):MovieClip {
        var ctype:String = module_type.substring(0, 1).toUpperCase();
        var atype:String = module_type.substring(1);
        var nomClassModule:String = "fr.opendo.editor.modules." + ctype + atype + "Edit";
        var classM:Class = getDefinitionByName(nomClassModule) as Class;
        var view:MovieClip = new classM();
        return view;
    }

    /**
     * Renvoie le picto du module (en @2x) selon le type d'activité dans le XML
     * @param module_type le type de l'activité
     */
    public static function getPictoClassByType(module_type:String):* {
        // Forced import
        var imports:Array = [ModTableauBlancView, ModAnimationView, ModSituationView, ModDessinView, ModIdView, ModPuzzleView, ModDebriefingView, ModQuestionView, ModQuizView, ModSondageView, ModOpenfileView, ModContenuView, ModAnimationCodeView, ModAdministratifView, ModFormView, ModMathsView, ModQandaView, ModPresenceView, ModPairView, ModCardpickerView, ModWhoisView, ModVideosynchroView, ModTracesView, ModNuageView];

        var ctype:String = module_type.substring(0, 1).toUpperCase();
        var atype:String = module_type.substring(1);
        var nomClassBt:String = "Mod" + ctype + atype + "View";
        var classM:Class = getDefinitionByName(nomClassBt) as Class;
        var view:MovieClip = new classM();
        return view;
    }

    public static function fullScreenToggle():void {
        if (Tools.OS.type == Const.MACOS || Tools.OS.type == Const.WIN) {
            var stage:Stage = Main.instance.getStage;
            (stage.displayState == StageDisplayState.NORMAL) ? stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE : stage.displayState = StageDisplayState.NORMAL;
        }
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

// ////////////////////////////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------
// Divers
// ----------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Vérifie si l'email est valide (dans son écriture)
     * @param email l'email à vérifier
     * return true ou false
     */
    public static function isValidEmail(email:String):Boolean {
        var emailExpression:RegExp = /^[\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
        return emailExpression.test(email);
    }

    public static function isRandomEmail(email:String):Boolean {
        var state:Boolean = false;
        var prefixe:String = email.substring(0, email.indexOf("@"));
        var domain:String = email.substring(email.indexOf("@") + 1);
        if (!isNaN(Number(prefixe)) && domain == "opendo.fr") state = true;
        return state;
    }

// Raccourci .opendolink (lien vers une activité)
    public static function createOpendoLink(link_prefixe:String):void {
        var str:String = DataManager.currentSessionData.title + ";"
        str += DataManager.currentSessionData.id + ";"
        str += DataManager.currentModuleData.titre + ";"
        str += DataManager.currentModuleData.id;
        var ba:ByteArray = convertStringToUTF8(str);
        var file_name:String = DataManager.currentModuleData.type + ".opendolink";
        var file:File = File.documentsDirectory.resolvePath(file_name);
        file.save(ba, file_name);
    }

    /**
     * clone
     * @param source l'objet à cloner
     */
    public static function clone(source:Object):* {
        var myBA:ByteArray = new ByteArray();
        myBA.writeObject(source);
        myBA.position = 0;
        return (myBA.readObject());
    }

    public static function setLight(label:TextField):void {
        var myFormat:TextFormat = new TextFormat();
        myFormat.font = "Roboto Light";
        label.setTextFormat(myFormat);
    }

    public static function setRegular(label:TextField):void {
        var myFormat:TextFormat = new TextFormat();
        myFormat.font = "Roboto Regular";
        label.setTextFormat(myFormat);
    }

    public static function setBold(label:TextField):void {
        var myFormat:TextFormat = new TextFormat();
        myFormat.font = "Roboto Bold";
        label.setTextFormat(myFormat);
    }

    public static function isExcludedDomain(mail:String):Boolean {
        var exists:Boolean = false;
        var mail_domain:String = mail.substr(mail.indexOf("@") + 1);
        for each (var domain:String in DataConst.OPENDO_DOMAINS) {
            if (mail_domain == domain) {
                exists = true;
                break;
            }
        }
        return exists;
    }

// pour gérer le clavier Android de m... !!
    public static function focusAndroidIn(view:DisplayObjectContainer, tf_ypos:Number):void {
        if (Tools.OS.type != Const.ANDROID) return;
        TweenLite.to(view, Const.ANIM_DURATION, {y: ScreenSize.top - tf_ypos + 180, delay: .25, ease: Power2.easeOut});
    }

    public static function focusAndroidOut(view:DisplayObjectContainer):void {
        if (Tools.OS.type != Const.ANDROID) return;
        TweenLite.to(view, Const.ANIM_DURATION, {y: 0, ease: Power2.easeOut});
    }

    /**
     * teste si la session est locké (édition impossible) pour l'animateur
     * @param parameters_xml de la session a tester
     */
    public static function isLockedSession(parameters_xml:XML):Boolean {
        var locked:Boolean;
        var locked_email:String = parameters_xml.locked_email.toString();
        var anim_email:String = DataManager.parametersData.license_email.toString();
        if (locked_email == "") {
            locked = false;
        } else {
            (locked_email == anim_email) ? locked = false : locked = true;
        }
        return locked;
    }

    /**
     *
     */
    public static function createTextField(text:String, size:Number, font:String, color:uint, w:Number, autoSize:String, textFieldType:String = TextFieldType.DYNAMIC):TextField {
        var myFormat:TextFormat = new TextFormat();
        myFormat.size = size;
        myFormat.font = font;
        myFormat.color = color;
        var txt:TextField = new TextField();
        txt.defaultTextFormat = myFormat;
        txt.type = textFieldType;
        txt.selectable = false;
        txt.embedFonts = true;
        txt.width = w;
        txt.autoSize = autoSize;
        txt.cacheAsBitmap = true;
        txt.text = text;
        return txt;
    }

    public static function get dispatcher():EventDispatcher {
        return _dispatcher;
    }
}
}