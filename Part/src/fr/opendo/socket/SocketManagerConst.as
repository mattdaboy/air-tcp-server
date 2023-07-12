package fr.opendo.socket {
/**
 * @author Matthieu
 */
public class SocketManagerConst {
    public static var TCP_SERVER_PORT:int = 6665;
    public static var HTTP_SERVER_PORT:int = 6664;
    public static var LOCAL_ADDRESS:String;

    public static const USER_INFO:String = "USER_INFO";

    public static const OPEN_QUIZ:String = "OPEN_QUIZ";
    public static const QUIZ_REPONSES:String = "QUIZ_REPONSES";
    public static const QUIZ_REPONSES_SEQUENCE:String = "QUIZ_REPONSES_SEQUENCE";

    public static const OPEN_SONDAGE:String = "OPEN_SONDAGE";
    public static const SONDAGE_REPONSES:String = "SONDAGE_REPONSES";
    public static const SONDAGE_PAUSE:String = "SONDAGE_PAUSE";
    public static const SONDAGE_PLAY:String = "SONDAGE_PLAY";

    public static const OPEN_ID:String = "OPEN_ID";
    public static const ID_IMG:String = "ID_IMG";

    public static const OPEN_DESSIN:String = "OPEN_DESSIN";
    public static const DESSIN_IMG:String = "DESSIN_IMG";

    public static const OPEN_TABLEAU_BLANC:String = "OPEN_TABLEAU_BLANC";
    public static const TABLEAU_BLANC_MSG:String = "TABLEAU_BLANC_MSG";
    public static const TABLEAU_BLANC_MSG_POS:String = "TABLEAU_BLANC_MSG_POS";
    public static const TABLEAU_BLANC_MSG_LIKE:String = "TABLEAU_BLANC_MSG_LIKE";
    public static const TABLEAU_BLANC_MSG_DISLIKE:String = "TABLEAU_BLANC_MSG_DISLIKE";
    public static const TABLEAU_BLANC_UPDATE_LIKES:String = "TABLEAU_BLANC_UPDATE_LIKES";
    public static const TABLEAU_BLANC_MSG_DELETE:String = "TABLEAU_BLANC_MSG_DELETE";
    public static const TABLEAU_BLANC_DEMARRER:String = "TABLEAU_BLANC_DEMARRER";

    public static const OPEN_DEBRIEFING:String = "OPEN_DEBRIEFING";
    public static const DEBRIEFING_NOTE:String = "DEBRIEFING_NOTE";

    public static const OPEN_PUZZLE:String = "OPEN_PUZZLE";
    public static const PUZZLE_LOCK:String = "PUZZLE_LOCK";
    public static const PUZZLE_UNLOCK:String = "PUZZLE_UNLOCK";
    public static const PUZZLE_POS:String = "PUZZLE_POS";
    public static const PUZZLE_IMG:String = "PUZZLE_IMG";

    public static const OPEN_QUESTION:String = "OPEN_QUESTION";
    public static const QUESTION_GO:String = "QUESTION_GO";
    public static const QUESTION_BUZZ:String = "QUESTION_BUZZ";
    public static const QUESTION_PAUSE:String = "QUESTION_PAUSE";
    public static const QUESTION_RESUME:String = "QUESTION_RESUME";
    public static const QUESTION_POINTS:String = "QUESTION_POINTS";

    public static const OPEN_EVALUATION:String = "OPEN_EVALUATION";
    public static const EVALUATION_REPONSES:String = "EVALUATION_REPONSES";

    public static const APPRECIATION:String = "APPRECIATION";

    public static const HUMEUR:String = "HUMEUR";
    public static const MESSAGE:String = "MESSAGE";

    public static const OPEN_ANIMATON:String = "OPEN_ANIMATON";
    public static const ANIMATION_SELECTION:String = "ANIMATION_SELECTION";

    public static const OPEN_BD:String = "OPEN_BD";
    public static const BD_IMG:String = "BD_IMG";

    public static const OPEN_SITUATION:String = "OPEN_SITUATION";
    public static const SITUATION_CONTENU:String = "SITUATION_CONTENU";

    public static const OPEN_FORM:String = "OPEN_FORM";
    public static const FORM_ANSWERS:String = "FORM_ANSWERS";

    public static const CLOSE_MODULE:String = "CLOSE_MODULE";
    public static const PING:String = "PING";
    public static const PONG:String = "PONG";

    public static const SEPARATOR1:String = "¤";
    public static const SEPARATOR2:String = "ǁ";

    public static const EVALUATION:String = "EVALUATION";
    public static const SEND_INFOS_TO_FORMATEUR:String = "SEND_INFOS_TO_FORMATEUR";
    public static const PARAMETERS_DATAS:String = "PARAMETERS_DATAS";
    public static const QUIZ_ANIMATION_CODE_REPONSES:String = "QUIZ_ANIMATION_CODE_REPONSES";
    public static const ANIMATION_RESTART:String = "ANIMATION_RESTART";
    public static const FORCE_SOCKET_CLOSE:String = "FORCE_SOCKET_CLOSE";
    public static const FORCE_DECONNECTION_FROM_WEB_SOCKET:String = "FORCE_DECONNECTION_FROM_WEB_SOCKET";
    public static const ADMINISTRATIF_REPONSES:String = "ADMINISTRATIF_REPONSES";
    public static const PRESENCE_REPONSES:String = "PRESENCE_REPONSES";
    public static const MATHS_REPONSES:String = "MATHS_REPONSES";
    public static const PAIR_REPONSES:String = "PAIR_REPONSES";

    public static const ANIMATION_CODE_CONTENT:String = "ANIMATION_CODE_CONTENT";
    public static const SHARE_FILES_CONTENT:String = "SHARE_FILES_CONTENT";

    public static const USER_NOTE:String = "USER_NOTE";

    public static const TEST_DATA:String = "TEST_DATA";
    public static const QANDA_MESSAGE:String = "QANDA_MESSAGE";
    public static const QANDA_MESSAGE_LIKE:String = "QANDA_MESSAGE_LIKE";
    public static const QANDA_MESSAGE_DISLIKE:String = "QANDA_MESSAGE_DISLIKE";
    public static const QANDA_MESSAGE_DELETE:String = "QANDA_MESSAGE_DELETE";
    public static const QANDA_UPDATE_LIKES:String = "QANDA_UPDATE_LIKES";
    public static const QANDA_PAUSE:String = "QANDA_PAUSE";
    public static const QANDA_PLAY:String = "QANDA_PLAY";
    public static const QANDA_QUESTION_ALREADY_EXISTS:String = "QANDA_QUESTION_ALREADY_EXISTS";

    public static const OFFRE_DECOUVERTE:String = "OFFRE_DECOUVERTE";

    // ping pong
    public static const ARE_YOU_THERE:String = "ARE_YOU_THERE";
    public static const IM_THERE:String = "IM_THERE";
    public static const CHAT_MESSAGE:String = "CHAT_MESSAGE";

    // Card Picker
    public static const CARD_USER_SELECTED:String = "CARD_USER_SELECTED";
    public static const CARD_NO_USER_SELECTED:String = "CARD_NO_USER_SELECTED";
    public static const CARD_RETURNED:String = "CARD_RETURNED";
    public static const CARD_POINTS:String = "CARD_POINTS";
    public static const CARDS_CONTENT:String = "CARDS_CONTENT";

    // Whois
    public static const WHOIS_CONTENT:String = "WHOIS_CONTENT";
    public static const WHOIS_REPONSES:String = "WHOIS_REPONSES";
    public static const WHOIS_REVEAL:String = "WHOIS_REVEAL";

    // video synchro
    public static const VIDEO_SYNCHRO_CONTENT:String = "VIDEO_SYNCHRO_CONTENT";
    public static const VIDEO_SYNCHRO_PLAY_AT:String = "VIDEO_SYNCHRO_PLAY_AT";
    public static const VIDEO_SYNCHRO_PAUSE_AT:String = "VIDEO_SYNCHRO_PAUSE_AT";
    public static const VIDEO_SYNCHRO_USER_READY:String = "VIDEO_SYNCHRO_USER_READY";
    public static const VIDEO_SYNCHRO_NEED_DATA:String = "VIDEO_SYNCHRO_NEED_DATA";

    // Formulaire administratif
    public static const ADMINISTRATIF_DATA_RECEIVED:String = "ADMINISTRATIF_DATA_RECEIVED";

    // nuage
    public static const NUAGE_PAUSE:String = "NUAGE_PAUSE";
    public static const NUAGE_PLAY:String = "NUAGE_PLAY";
    public static const NUAGE_MSG:String = "NUAGE_MSG";
    public static const NUAGE_UPDATE:String = "NUAGE_UPDATE";
}
}