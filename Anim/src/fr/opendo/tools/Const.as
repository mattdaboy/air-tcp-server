package fr.opendo.tools {
/**
 * @author Matt
 */
public class Const {
    public static const ASSETS_DIR:String = "assets";
    public static const HTDOCS_DIR:String = "htdocs";
    public static const SOUND_KIT_DIR:String = "sound_kit";
    public static const ALIAS_DIR:String = "alias";
    public static var OVERWRITE_DATABASE:Boolean = false;
    public static var OVERWRITE_MEDIAS:Boolean = false;
    public static var FULLSCREENWIDTH:uint = 1920;
    public static var FULLSCREENHEIGHT:uint = 1200;
    public static var ANIM_DURATION:Number = .25;
    public static var ANIM_DURATION_SLOW:Number = 1;
    public static var CHANGE_TIMEOUT:uint;
    public static var CHANGE_TIMEOUT_DELAY:uint = 500;
    public static const FROM_EDITOR:String = "FROM_EDITOR";
    public static const FROM_CMS:String = "FROM_CMS";
    public static const CLASSE_DISTANCIEL:String = "CLASSE_DISTANCIEL";
    public static const CLASSE_PRESENTIEL:String = "CLASSE_PRESENTIEL";
    public static const MACOS:String = "MacOS";
    public static const WIN:String = "Windows";
    public static const IOS:String = "iOS";
    public static const ANDROID:String = "Android";
    public static var MOBILE_JPEG_QUALITY:Number = .9;
    public static var DESKTOP_JPEG_QUALITY:uint = 90;
    public static var FILE_SERVER_PORT_AVAILABLE:Boolean = false;
    public static const POPUP_SCALE:Number = 1.05;
    public static const POPUP_SCALE_INV:Number = .8;
    public static const SEPARATOR1:String = "¤";
    public static const SEPARATOR2:String = "ǁ";
    public static const SEPARATOR3:String = "&&&";
    public static const FILENAME_SUFFIXE_SEPARATOR:String = "-otimestamp";

    // Placement des éléments d'interface (header)
    public static const RIGHT_BTN_X:Number = -100;
    public static const RIGHT_BTN_Y:Number = 30;
    public static const TITRE_X:Number = 140;
    public static const TITRE_Y:Number = 33;
    public static const STITRE_Y:Number = 160;
    public static const PICTO_X:Number = 40;
    public static const PICTO_Y:Number = 40;
    public static const PICTO_SMALL_X:Number = 40;
    public static const PICTO_SMALL_Y:Number = 40;
    public static const ED_HEADER_X:Number = -160;

    public static const BACKGROUND_COLORS:Vector.<uint> = new <uint>[0x20A3BA, 0x13606E, 0xCC5435, 0x7F9CE1, 0x448FA3, 0xBA2554, 0x8EB1B2, 0x807959, 0xFF9D14, 0x9BB56B, 0x0E9EC9, 0xB32064, 0xB0CF40, 0x21B6D1, 0x81B39D, 0x526666, 0xE68653, 0x99947A, 0xCF5367, 0xCCAF8F, 0x26474D, 0xD96262];
    public static const PICTO_COLORS:Vector.<uint> = new <uint>[0x00AFCC, 0xFFC72B, 0x2E8299, 0xBADF44, 0x38D7E7, 0x6284BF, 0xEE316B, 0x6F93DD, 0xFF6943, 0xCC2973, 0x008AAF, 0xB0CC7A, 0x99906B, 0x9AB238, 0xFFA52E, 0x8EB1B2, 0x667F7F, 0x19767F, 0xB2AC8E, 0x92CCB3, 0xFF965C, 0xE85D74, 0xE5CFAC, 0x335F66, 0xFF7878, 0x71AECC];

    // FRONT SERVER
    public static const FRONT_SERVER:String = "https://www.opendo.fr/";

    // CMS SERVER
    public static const PROD_BO_SERVER:String = "https://bo.opendo.fr/";
    public static const PREPROD_BO_SERVER:String = "https://rct.opendo.fr/app_dev.php/";
    public static const BO_SERVER:String = PROD_BO_SERVER;

    // FILES SERVER
//    public static const FILES_SERVER:String = "https://www.bunkerbrain.com/";
    public static const FILES_SERVER:String = "https://www.opendo.fr/uploads/";

    public static const ALL:String = "ALL";
    public static const UP_LEFT:String = "UP_LEFT";
    public static const UP_RIGHT:String = "UP_RIGHT";
    public static const FIT:String = "FIT";
    public static const FILL:String = "FILL";

    // Appareils
    public static const MAC:String = "Mac";
    public static const PC:String = "PC";
    public static const IPAD:String = "iPad";
    public static const IPHONE:String = "iPhone";
    public static const ANDROID_PHONE:String = "AndroidPhone";
    public static const ANDROID_TABLET:String = "AndroidTablet";

    // Tags
    public static const TAG_MANAGER_VISIBLE:String = "manager-visible";
    public static const TAG_PUBLICATIONS:String = "publications";
    public static const TAG_PDF_REPORT:String = "pdf-report";
    public static const TAG_PART_LIST:String = "part-list";
    public static const TAG_SCREENSHOT:String = "screenshot";
    public static const TAG_PRESENCE:String = "presence";
    public static const TAG_FORMULAIRE:String = "formulaire";
    public static const TAG_SESSION:String = "session";

    // Licence tags
    public static const LIC_ANIMATOR:String = "animator";
    public static const LIC_TEAM:String = "team";
}
}