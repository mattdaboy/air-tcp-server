package fr.opendo.data {
import fr.opendo.tools.DateUtils;
import fr.opendo.tools.Language;

/**
 * @author Matthieu
 */
public class DataConst {
    // ELEMENTS DES MODULES

    public static const NEW_TABLEAU_CONTENUS:XML = <contenus>
        <groupes/>
    </contenus>;
    public static const NEW_TABLEAU_BLANC_GROUPE1_XML:XML = <g>
        <group_name><![CDATA[Groupe n°1]]></group_name>
        <consigne><![CDATA[]]></consigne>
        <file_name></file_name>
        <anim_messages/>
    </g>;
    public static const NEW_TABLEAU_BLANC_GROUPE_XML:XML = <g>
        <group_name><![CDATA[]]></group_name>
        <consigne><![CDATA[]]></consigne>
        <file_name></file_name>
        <anim_messages/>
    </g>;
    public static const NEW_ADMINISTRATIF_ITEM_XML:XML = <item>
        <type>text</type>
        <txt>{Language.getValue("administratif-optin-defaut")}</txt>
        <check>
            <show>1</show>
        </check>
        <picture>
            <show>0</show>
        </picture>
    </item>;
    public static const NEW_QUESTION_MATHS_XML:XML = <item>
        <q><![CDATA[Question]]></q>
        <valeur/>
        <unite/>
        <solution/>
    </item>;
    public static const NEW_QUESTION_XML:XML = <item>
        <q><![CDATA[Question]]></q>
        <good>0</good>
        <r><![CDATA[Oui]]></r>
        <r><![CDATA[Non]]></r>
        <image>
            <file_name/>
        </image>
    </item>;
    public static const NEW_ANSWER_XML:XML = <r><![CDATA[]]></r>;
    public static const NEW_FORM_ITEM_XML:XML = <item>
        <q><![CDATA[]]></q>
        <type>0</type>
    </item>;
    public static const NEW_PAIR_ITEM_XML:XML = <item>
        <elemA>
            <id>111111111</id>
            <texte><![CDATA[Un éléphant]]></texte>
            <file_name/>
        </elemA>
        <elemB>
            <id>111111111</id>
            <texte><![CDATA[Ça trompe énormément]]></texte>
            <file_name/>
        </elemB>
        <link>{TEXT_TEXT}</link>
    </item>;
    public static const NEW_OPENFILE_ITEM_XML:XML = <file>
        <file_name/>
    </file>;
    public static const NEW_CARDPICKER_ITEM_XML:XML = <card>
        <file_name/>
        <desc/>
    </card>;
    public static const NEW_WHOIS_ITEM_XML:XML = <item>
        <file_name/>
        <good/>
    </item>;
    public static const NEW_CONTENU_ITEM_XML:XML = <item>
        <file_name/>
    </item>;
    public static const DEFAULT_PLAY_CARD:String = "play-card.png";
    public static const DEFAULT_PLAY_CARD_LANDSCAPE:String = "play-card-lanscape.png";
    public static const NEW_TRACES_CODE_XML:XML = <item>
        <code_name/>
        <id/>
        <infos/>
    </item>;
    //
    // MODULES
    public static const NEW_ID_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("id").toUpperCase() + "]]>")}</titre>
        <type>id</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
    </module>;
    public static const NEW_MATHS_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("maths").toUpperCase() + "]]>")}</titre>
        <type>maths</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <item>
            <q><![CDATA[Combien font 12% de 1000€ ?]]></q>
            <valeur><![CDATA[120]]></valeur>
            <unite>€</unite>
            <solution><![CDATA[Pour calculer un pourcentage, vous pouvez utiliser la formule suivante :
(pourcentage x valeur totale)/100.
Ici on aura donc : (12x1000)/100 = 120]]></solution>
        </item>
        <item>
            <q><![CDATA[Quel est l'aire d'un triangle isocèle dont la base fait 10cm et la hauteur 8cm ?]]></q>
            <valeur><![CDATA[40]]></valeur>
            <unite>cm²</unite>
            <solution><![CDATA[L'aire d'un triangle isocèle est : A = base x hauteur / 2.
Ici on aura donc 10x8/2 = 40cm²]]></solution>
        </item>
        <item>
            <q><![CDATA[Le prix d'achat d'un produit est de 150€. Sachant que les frais d'achat sont de 8 %, calculez le coût d'achat du produit.]]></q>
            <valeur><![CDATA[162]]></valeur>
            <unite>€</unite>
            <solution><![CDATA[Le coût d'achat se calcule ainsi :
Prix d'achat net + 8% du prix d'achat : 150 + ((8x150)/100) = 162]]></solution>
        </item>
        <solution_affichee>1</solution_affichee>
        <delai></delai>
        <random>0</random>
    </module>;
    public static const NEW_QUIZ_INDICE_XML:XML = <image>
        <file_name/>
    </image>;
    public static const NEW_QUIZ_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("quiz").toUpperCase() + "]]>")}</titre>
        <type>quiz</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <item>
            <q><![CDATA[Qui était Alan Turing ?]]></q>
            <r><![CDATA[Un informaticien]]></r>
            <r><![CDATA[Un mathématicien]]></r>
            <r><![CDATA[Un logisticien]]></r>
            {NEW_QUIZ_INDICE_XML}
            <good>1</good>
        </item>
        <item>
            <q><![CDATA[Rangez par ordre croissant :]]></q>
            <r><![CDATA[Ko, Mo, To, Go]]></r>
            <r><![CDATA[To, Mo, Go, Ko]]></r>
            <r><![CDATA[Ko, Mo, Go, To]]></r>
            <image>
                <file_name/>
            </image>
            <good>2</good>
        </item>
        <item>
            <q><![CDATA[Qu'est-ce qu'une IP ?]]></q>
            <r><![CDATA[Une Interruption Provisoire]]></r>
            <r><![CDATA[Une personne à la mode]]></r>
            <r><![CDATA[Une identification sur un réseau informatique]]></r>
            <image>
                <file_name/>
            </image>
            <good>2</good>
        </item>
        <qcm>0</qcm>
        <delai></delai>
        <random>0</random>
        <comptage>
            <actif>0</actif>
            <good>1</good>
            <bad>0.5</bad>
        </comptage>
    </module>;
    public static const NEW_SONDAGE_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("sondage").toUpperCase() + "]]>")}</titre>
        <type>sondage</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <item>
            <q><![CDATA[Aimez-vous les produits digitaux ?]]></q>
            <r><![CDATA[Pas du tout]]></r>
            <r><![CDATA[Non]]></r>
            <r><![CDATA[Moyennement]]></r>
            <r><![CDATA[Oui]]></r>
            <r><![CDATA[Énormément !]]></r>
            <image><file_name/><served_url/></image>
        </item>
        <item>
            <q><![CDATA[Pensez-vous que l'utilisation d'un outil comme Opendo puisse être bénéfique à vos formations ou réunions de travail ?]]></q>
            <r><![CDATA[Oui]]></r>
            <r><![CDATA[Non]]></r>
            <r><![CDATA[Peut-être]]></r>
            <image><file_name/><served_url/></image>
        </item>
        <sequence>0</sequence>
    </module>;
    public static const NEW_TABLEAU_BLANC_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("tableauBlanc").toUpperCase() + "]]>")}</titre>
        <type>tableauBlanc</type>
        <actif>1</actif>
        <messages_part_visible>1</messages_part_visible>
        <contenus>
            <groupes>
                {NEW_TABLEAU_BLANC_GROUPE1_XML}
            </groupes>
        </contenus>
    </module>;
    public static const NEW_CONTENU_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("contenu").toUpperCase() + "]]>")}</titre>
        <type>contenu</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <contenus/>
    </module>;
    public static const NEW_DESSIN_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("dessin").toUpperCase() + "]]>")}</titre>
        <type>dessin</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <contenus/>
    </module>;
    public static const NEW_PUZZLE_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("puzzle").toUpperCase() + "]]>")}</titre>
        <type>puzzle</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <puzzle>
            <file_name>opendo_puzzle.jpg</file_name>
        </puzzle>
        <dim>
            <colonnes>3</colonnes>
            <lignes>3</lignes>
        </dim>
    </module>;
    public static const NEW_DEBRIEFING_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("debriefing").toUpperCase() + "]]>")}</titre>
        <type>debriefing</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <contenus/>
    </module>;
    public static const NEW_OPENFILE_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("openfile").toUpperCase() + "]]>")}</titre>
        <type>openfile</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <files/>
        <share>0</share>
    </module>;
    public static const NEW_HASARD_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("animation").toUpperCase() + "]]>")}</titre>
        <type>animation</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <message>{new XML("<![CDATA[" + Language.getValue("hasard-message") + "]]>")}</message>
        <contenus/>
    </module>;
    public static const NEW_QANDA_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("qanda").toUpperCase() + "]]>")}</titre>
        <type>qanda</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <contenus/>
    </module>;
    public static const NEW_QUESTION_CHAMPION_IMAGES_XML:XML = <images>
        <image>
            <file_name/>
        </image>
        <image>
            <file_name/>
        </image>
        <image>
            <file_name/>
        </image>
        <image>
            <file_name/>
        </image>
    </images>;
    public static const NEW_QUESTION_CHAMPION_XML:XML = <q>
        <texte><![CDATA[Question]]></texte>
        <delai>40</delai>
        {NEW_QUESTION_CHAMPION_IMAGES_XML}
    </q>;
    public static const NEW_QUESTION_POUR_UN_CHAMPION_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("question").toUpperCase() + "]]>")}</titre>
        <type>question</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <mode>4points</mode>
        <q>
            <texte><![CDATA[Que signifie l'acronyme GAFAM ?]]></texte>
            <delai>40</delai>
            <reponse><![CDATA[Google Amazon Facebook Apple Microsoft]]></reponse>
            {NEW_QUESTION_CHAMPION_IMAGES_XML}
        </q>
        <q>
            <texte><![CDATA[Qui est Elon Musk ?]]></texte>
            <delai>30</delai>
            {NEW_QUESTION_CHAMPION_IMAGES_XML}
            <reponse><![CDATA[Directeur général de la société Tesla]]></reponse>
        </q>
        <q>
            <texte><![CDATA[A combien d'exemplaires s'est vendu Super Mario Bros ?]]></texte>
            <delai>20</delai>
            <reponse><![CDATA[40 millions de copies]]></reponse>
            {NEW_QUESTION_CHAMPION_IMAGES_XML}
        </q>
    </module>;
    public static const NEW_GROUPE_XML:XML = <groupe>
        <titre><![CDATA[Titre du groupe]]></titre>
        <consigne><![CDATA[Consignes du groupe...]]></consigne>
    </groupe>;
    public static const NEW_SCENARIO_XML:XML = <scenario>
        <titre><![CDATA[Titre du scénario]]></titre>
        <descriptif><![CDATA[Descriptif du scénario]]></descriptif>
        {NEW_GROUPE_XML}
        {NEW_GROUPE_XML}
    </scenario>;
    public static const NEW_SITUATION_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("situation").toUpperCase() + "]]>")}</titre>
        <type>situation</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        {NEW_SCENARIO_XML}
    </module>;
    public static var NEW_CODE_ITEM_XML:XML = <code>
        <code_name>{new XML("<![CDATA[Code n°1]]>")}</code_name>
        <id>{Math.floor(Math.random() * 9999999)}</id>
        <content/>
    </code>;
    public static const NEW_ANIMATION_CODE_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("animationCode").toUpperCase() + "]]>")}</titre>
        <type>animationCode</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <codes>
            {NEW_CODE_ITEM_XML}
        </codes>
    </module>;
    public static const NEW_ADMINISTRATIF_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("administratif").toUpperCase() + "]]>")}</titre>
        <type>administratif</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <contenus>
            <item>
                <type>profil</type>
                <actif>1</actif>
            </item>
            <item>
                <type>work</type>
                <actif>1</actif>
            </item>
            <item>
                <type>text</type>
                <txt>{Language.getValue("administratif-optin-defaut")}</txt>
                <check>
                    <show>1</show>
                </check>
                <picture>
                    <show>0</show>
                </picture>
            </item>
            <item>
                <type>sign</type>
                <actif>1</actif>
            </item>
        </contenus>
    </module>;
    public static const NEW_FORM_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("form").toUpperCase() + "]]>")}</titre>
        <type>form</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <item>
            <q><![CDATA[Comment evaluez-vous la formation à laquelle vous venez de participer ?]]></q>
            <type>0</type>
        </item>
    </module>;
    public static const NEW_PRESENCE_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("presence").toUpperCase() + "]]>")}</titre>
        <type>presence</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <photo>0</photo>
        <disclaimer_text/>
        <footer_text/>
        <contenus/>
    </module>;
    public static const NEW_PAIR_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("pair").toUpperCase() + "]]>")}</titre>
        <type>pair</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <solution_affichee>1</solution_affichee>
        <delai></delai>
        <contenus>{NEW_PAIR_ITEM_XML}</contenus>
    </module>;
    public static const NEW_CARD_PICKER_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("cardpicker").toUpperCase() + "]]>")}</titre>
        <type>cardpicker</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <cardback>
            <file_name>{DEFAULT_PLAY_CARD_LANDSCAPE}</file_name>
        </cardback>
        <contenus>
            <card>
                <file_name>Opendo - fond cafe.png</file_name>
                <desc/>
                <served_url>https://www.opendo.fr/assets/images/Opendo - fond cafe.png</served_url>
            </card>
            <card>
                <file_name>Opendo - fond coupe.png</file_name>
                <desc/>
                <served_url>https://www.opendo.fr/assets/images/Opendo - fond coupe.png</served_url>
            </card>
            <card>
                <file_name>Opendo - fond courte-paille.png</file_name>
                <desc/>
                <served_url>https://www.opendo.fr/assets/images/Opendo - fond courte-paille.png</served_url>
            </card>
        </contenus>
    </module>;
    public static const NEW_WHOIS_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("whois").toUpperCase() + "]]>")}</titre>
        <type>whois</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <cardback>
            <file_name>Opendo - whois cardback.png</file_name>
            <served_url>https://www.opendo.fr/assets/images/Opendo - whois cardback.png</served_url>
        </cardback>
        <contenus>
            <item>
                <file_name>shutterstock_1880283043_lt.jpg</file_name>
                <good>1</good>
                <served_url>https://www.opendo.fr/assets/images/shutterstock_1880283043_lt.jpg</served_url>
            </item>
            <item>
                <file_name>shutterstock_1996007297_lt.jpg</file_name>
                <good>0</good>
                <served_url>https://www.opendo.fr/assets/images/shutterstock_1996007297_lt.jpg</served_url>
            </item>
            <item>
                <file_name>shutterstock_2049830318_lt.jpg</file_name>
                <good>0</good>
                <served_url>https://www.opendo.fr/assets/images/shutterstock_2049830318_lt.jpg</served_url>
            </item>
            <item>
                <file_name>shutterstock_2094420823_lt.jpg</file_name>
                <good>0</good>
                <served_url>https://www.opendo.fr/assets/images/shutterstock_2094420823_lt.jpg</served_url>
            </item>
        </contenus>
    </module>;
    public static const NEW_VIDEO_SYNCHRO_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("videosynchro").toUpperCase() + "]]>")}</titre>
        <type>videosynchro</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <son>0</son>
        <contenus>
            <video></video>
        </contenus>
    </module>;
    public static const NEW_TRACES_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("traces").toUpperCase() + "]]>")}</titre>
        <type>traces</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <contenus/>
    </module>;
    public static const NEW_NUAGE_XML:XML = <module>
        <titre>{new XML("<![CDATA[" + Language.getValue("nuage").toUpperCase() + "]]>")}</titre>
        <type>nuage</type>
        <actif>1</actif>
        <fond>
            <file_name/>
        </fond>
        <contenus/>
    </module>;

    //
    // EDITOR
    public static const SESSION_FOND:XML = <fond>
        <file_name/>
    </fond>;
    public static const SESSION_FULL:String = "SESSION_FULL";
    public static const SESSION_EMPTY:String = "SESSION_EMPTY";
    public static const PAS_DE_REPONSE:String = "X";
    public static const MODULE_TITRE_MAX_CHARS:int = 40;
    public static const SESSION_TITRE_MAX_CHARS:int = 35;
    public static const IMG_IMG:String = "IMG_IMG";
    public static const IMG_TEXT:String = "IMG_TEXT";
    public static const TEXT_IMG:String = "TEXT_IMG";
    public static const TEXT_TEXT:String = "TEXT_TEXT";
    public static const NEW_PDF_ITEM_XML:XML = <item>
        <file_name/>
    </item>;
    public static const NEW_NOTE_XML:XML = <item>
        <id/>
        <titre>{new XML("<![CDATA[" + Language.getValue("note").toUpperCase() + "]]>")}</titre>
        <corps><![CDATA[]]></corps>
    </item>;
    public static const SESSION_PARAMS_XML:XML = <params>
        <pdfs/>
        <notes/>
        <locked_email/>
    </params>;
    public static const OPENDO_DOMAINS:Vector.<String> = new <String>["ag.fr", "opendo.fr"];
    public static const LOCKED_EMAIL_XML:XML = <locked_email/>;
    public static const SYNCHRO_OLD_DATE_XML:XML = <synchro_date>2022-01-01 00:00:00</synchro_date>;
    public static const SYNCHRO_TODAY_DATE_XML:XML = <synchro_date>{DateUtils.dateToIso(new Date())}</synchro_date>;
    public static const SESSION_DELETED_XML:XML = <session_deleted>0</session_deleted>;
}
}