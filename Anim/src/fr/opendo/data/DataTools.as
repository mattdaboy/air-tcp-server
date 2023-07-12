package fr.opendo.data {
import flash.events.EventDispatcher;

import fr.opendo.tools.Debug;
import fr.opendo.tools.Tools;

/**
 * @author Matt - 2023-01-22
 */
public class DataTools extends EventDispatcher {
    private static var _dispatcher:EventDispatcher = new EventDispatcher();

    private static const LOG:Boolean = false;

    private static function log(str:String):void {
        if (LOG) Debug.show(str);
        if (LOG) trace(str);
    }

    public function DataTools() {
        throw new Error("!!! DataTools est un singleton et ne peut pas être instancié !!!");
    }

    /**
     * Formate les données d'une session venant de la db en XML pour synchro sur le Cloud
     * @param author_session_id l'id de db de la session
     */
    public static function sessionDataToXML(author_session_id:uint):XML {
        var session_data:SessionData = DataManager.getSessionDataByAuthorId(author_session_id);
        var date:String = session_data.date;
        var title:String = session_data.title;
        var modules_xml:XML = session_data.modules_xml;
        var xml:XML = new XML(<content>
            <session_id>{session_data.id}</session_id>
            <exp_email>{DataManager.getEmail()}</exp_email>
            <date>{date}</date>
            <session_title>{title}</session_title>
            <author_session_id>{author_session_id}</author_session_id>
            {modules_xml}
        </content>);
        return xml;
    }

    /**
     * Ajoute une session dans la db à partir d'un XML provenant de synchro sur le Cloud
     * @param session_xml le XML de la session
     */
    public static function addSession(session_xml:XML):void {
        var author_session_id:uint = uint(session_xml.author_session_id.toString())
        var modules_xml:XML = Tools.parseSessionXML(XML(session_xml.content.toXMLString()));
        var session_title:String;
        if (Tools.isNodeExists(session_xml, "title")) session_title = session_xml.title.toString();
        if (Tools.isNodeExists(session_xml, "session_title")) session_title = session_xml.session_title.toString();
        DataManager.addSessionInDB(
                session_title,
                session_xml.date.toString(),
                session_xml.exp_email.toString(),
                author_session_id,
                modules_xml);

//        log("DataTools.addSession()");
//        log(DataManager.getSessionDataByAuthorId(author_session_id).title);
//        log(DataManager.getSessionDataByAuthorId(author_session_id).date);
//        log(DataManager.getSessionDataByAuthorId(author_session_id).exp_email);
//        log(DataManager.getSessionDataByAuthorId(author_session_id).author_session_id);
//        log(DataManager.getSessionDataByAuthorId(author_session_id).modules_xml);
    }

    /**
     * Mise à jour d'une session dans la db à partir d'un XML provenant de synchro sur le Cloud
     * @param session_xml le XML de la session
     */
    public static function updateSession(session_xml:XML):void {
        var modules_xml:XML = Tools.parseSessionXML(XML(session_xml.content.toXMLString()));
        var session_title:String;
        if (Tools.isNodeExists(session_xml, "title")) session_title = session_xml.title.toString();
        if (Tools.isNodeExists(session_xml, "session_title")) session_title = session_xml.session_title.toString();
        var author_session_id:uint = uint(session_xml.author_session_id.toString());
        DataManager.updateSessionInDB(
                session_title,
                session_xml.date.toString(),
                session_xml.exp_email.toString(),
                author_session_id,
                modules_xml);

        DataManager.getSessionDataByAuthorId(author_session_id).title = session_title;
        DataManager.getSessionDataByAuthorId(author_session_id).modules_xml = modules_xml;
        Main.instance.home.sessionsList.changeSessionName(author_session_id, session_title);

//        log("DataTools.updateSession()");
//        log(DataManager.getSessionDataByAuthorId(author_session_id).title);
//        log(DataManager.getSessionDataByAuthorId(author_session_id).date);
//        log(DataManager.getSessionDataByAuthorId(author_session_id).exp_email);
//        log(DataManager.getSessionDataByAuthorId(author_session_id).author_session_id);
//        log(DataManager.getSessionDataByAuthorId(author_session_id).modules_xml);
    }

    public static function get dispatcher():EventDispatcher {
        return _dispatcher;
    }
}
}