package fr.opendo.tools {
/**
 * @author Matt - 2022-06-08
 */
public class TimeTools {

    public function TimeTools() {
        throw new Error("!!! TimeTools est un singleton et ne peut pas être instancié !!!");
    }

    /**
     * secToHMS
     * @param sec le nombre de secondes
     */
    public static function secToHMS(sec:uint):String {
        var d:uint;
        var h:uint;
        var m:uint;
        var s:uint;
        var final_chain:String;

        d = Math.floor(sec / 86400);
        h = Math.floor(sec % 86400 / 3600);
        m = Math.floor(sec % 86400 % 3600 / 60);
        s = sec % 86400 % 3600 % 60;

        if (sec < 60) final_chain = s + " s";
        if (sec >= 60 && sec < 3600) final_chain = m + " m, " + s + " s";
        if (sec >= 3600 && sec < 86400) final_chain = h + " h, " + m + " m, " + s + " s";
        if (sec >= 86400) final_chain = d + " j, " + h + " h, " + m + " m, " + s + " s";

        return final_chain;
    }
}
}