package fr.opendo.tools {
/**
 * @author Matthieu
 */
public class DateUtils {
    public function DateUtils() {
        // DateUtils is a static class and should not be instantiated
    }

    // Prend un string de type jj/mm/aaaa en entrée et retourne un objet Date
    public static function stringToDate(s:String):Date {
        var date_array:Array = s.split("/");
        var date:Date = new Date(date_array[2], date_array[1] - 1, date_array[0]);
        return date;
    }

    // Prend un objet Date en entrée et retourne un string de type jj/mm/aaaa
    public static function dateToString(d:Date):String {
        var jj:String;
        var mm:String;

        var j:int = d.getDate();
        (j < 10) ? jj = "0" + j : jj = String(j);

        var m:int = d.getMonth() + 1;
        (m < 10) ? mm = "0" + m : mm = String(m);

        var aaaa:int = d.getFullYear();

        var result:String = jj + "/" + mm + "/" + aaaa;

        return result;
    }

    // Prend un objet Date en entrée et retourne un string de type aaaa-mm-jj hh:mm:ss
    // si la valeur de truncate==true on renvoie un string de type aaaa-mm-jj
    public static function dateToIso(d:Date, truncate:Boolean = false):String {
        var jj:String;
        var mm:String;
        var hh:String;
        var mi:String;
        var se:String;

        var j:int = d.getDate();
        (j < 10) ? jj = "0" + j : jj = String(j);

        var m:int = d.getMonth() + 1;
        (m < 10) ? mm = "0" + m : mm = String(m);

        var aaaa:int = d.getFullYear();

        var h:int = d.hours;
        (h < 10) ? hh = "0" + h : hh = String(h);

        var min:int = d.minutes;
        (min < 10) ? mi = "0" + min : mi = String(min);

        var sec:int = d.seconds;
        (sec < 10) ? se = "0" + sec : se = String(sec);

        var result:String
        if (truncate) {
            result = aaaa + "-" + mm + "-" + jj
        } else {
            result = aaaa + "-" + mm + "-" + jj + " " + hh + ":" + mi + ":" + se;
        }

        return result;
    }

    public static function dateToDayMonthIso(d:Date):String {
        var jj:String;
        var mm:String;

        var j:int = d.getDate();
        (j < 10) ? jj = "0" + j : jj = String(j);

        var m:int = d.getMonth() + 1;
        (m < 10) ? mm = "0" + m : mm = String(m);

        var result:String = jj + "-" + mm;

        return result;
    }

    // Prend un objet Date en entrée et retourne un string de type hh:mm:ss
    public static function dateToHMS(d:Date):String {
        var hh:String;
        var mi:String;
        var se:String;

        var h:int = d.hours;
        (h < 10) ? hh = "0" + h : hh = String(h);

        var min:int = d.minutes;
        (min < 10) ? mi = "0" + min : mi = String(min);

        var sec:int = d.seconds;
        (sec < 10) ? se = "0" + sec : se = String(sec);

        var result:String = hh + ":" + mi + ":" + se;

        return result;
    }

    // Prend un string de type aaaa-mm-jj hh:mm en entrée et retourne un string de type jj/mm/aaaa
    public static function isoToString(s:String):String {
        var date_array:Array = s.substr(0, 10).split("-");
        var result:String = date_array[2] + "/" + date_array[1] + "/" + date_array[0];
        return result;
    }

    // Prend un string de type aaaa-mm-jj hh:mm en entrée et retourne un string de type jj/mm/aaaa - hh:mm
    public static function isoToStringFull(s:String):String {
        var time:String = s.substr(11);
        var date_array:Array = s.substr(0, 10).split("-");
        var result:String = date_array[2] + "/" + date_array[1] + "/" + date_array[0] + " - " + time;
        return result;
    }

    // Prend un string de type iso (aaaa-mm-jj hh:mm) en entrée et retourne un string de type jj/mm/aaaa
    public static function isoToStringFrenchDate(s:String, abr:Boolean = false):String {
        var date_array:Array = s.substr(0, 10).split("-");
        var day:String = date_array[2];
        var month:String = date_array[1];
        var fmonth:String;
        switch (month) {
            case "01":
                (abr) ? fmonth = "janv." : fmonth = "janvier";
                break;
            case "02":
                (abr) ? fmonth = "févr." : fmonth = "février";
                break;
            case "03":
                fmonth = "mars";
                break;
            case "04":
                (abr) ? fmonth = "avr." : fmonth = "avril";
                break;
            case "05":
                fmonth = "mai";
                break;
            case "06":
                fmonth = "juin";
                break;
            case "07":
                (abr) ? fmonth = "juil." : fmonth = "juillet";
                break;
            case "08":
                fmonth = "août";
                break;
            case "09":
                (abr) ? fmonth = "sept." : fmonth = "septembre";
                break;
            case "10":
                (abr) ? fmonth = "oct." : fmonth = "octobre";
                break;
            case "11":
                (abr) ? fmonth = "nov." : fmonth = "novembre";
                break;
            case "12":
                (abr) ? fmonth = "déc." : fmonth = "décembre";
                break;
        }
        var year:String = date_array[0];
        var result:String = day + " " + fmonth + " " + year;
        return result;
    }

    public static function isoToStringFrenchFullDate(s:String):String {
        var date_time_array:Array = s.split(" ");
        var result:String = isoToStringFrenchDate(s, true) + " " + date_time_array[1];
        return result;
    }

    // Prend un string de type aaaa-mm-jj hh:mm en entrée et retourne un objet Date
    public static function isoToDate(s:String):Date {
        var date_time_array:Array = s.split(" ");
        var date_array:Array = date_time_array[0].split("-");
        var time_array:Array = date_time_array[1].split(":");
        var date:Date = new Date(date_array[0], date_array[1] - 1, date_array[2], time_array[0], time_array[1]);
        return date;
    }

    // Prend un string de type aaaa-mm-jj hh:mm:ss en entrée et retourne un objet Date
    public static function isoFullToDate(str:String):Date {
        var date_time_array:Array = str.split(" ");
        var date_array:Array = date_time_array[0].split("-");
        var time_array:Array = date_time_array[1].split(":");
        var sec:String;
        (time_array.length == 2) ? sec = "00" : sec = time_array[2];
        var date:Date = new Date(date_array[0], date_array[1] - 1, date_array[2], time_array[0], time_array[1], sec);
        return date;
    }

    // renvoie le nombre de secondes entre les 2 dates (dates à minuit)
    public static function differenceInSeconds(d1:Date, d2:Date):int {
        var diff:int = (d2.valueOf() - d1.valueOf()) / 1000;
        return diff;
    }

    // renvoie le nombre de secondes du jour depuis 00:00
    public static function daySeconds(d:Date):int {
        var result:int = (d.hours * 3600) + (d.minutes * 60) + d.seconds;
        return result;
    }

    // renvoie le nombre de jours entre les 2 dates (dates à minuit)
    public static function differenceInDays(d1:Date, d2:Date):int {
        var diff:int = (d2.valueOf() - d1.valueOf()) / 1000 / 3600 / 24;
        return diff;
    }

    // renvoie le jour suivant
    public static function dayAdd(d:Date, n:int):Date {
        var d_next:Date = new Date(d.fullYear, d.month, d.date + n);
        return d_next;
    }

    // test 2 objets Date
    public static function isSamedDay(d1:Date, d2:Date):Boolean {
        var result:Boolean = false;
        if (d1.fullYear == d2.fullYear && d1.month == d2.month && d1.date == d2.date) result = true;
        return result;
    }
}
}