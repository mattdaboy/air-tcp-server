package fr.opendo.tools {
import flash.utils.getTimer;

/**
 * @author Matt - 2022-02-04
 */
public class Timing {

    public static var _timings:Vector.<Object> = new Vector.<Object>();

    public function Timing() {
        throw new Error("!!! Timing est un singleton et ne peut pas être instancié !!!");
    }

    /**
     * addTiming
     * @param name le nom du timing à débuter
     */
    public static function addTiming(name:String):void {
        var t:uint = getTimer();
        var obj:Object = {name: name, timing: t};
        _timings.push(obj);
    }

    public static function getTimingByName(name:String):uint {
        var timing_searched:Object;
        for each (var timing_in_vector:Object in _timings) {
            if (timing_in_vector.name == name) return getTimer() - timing_in_vector.timing;
        }
        return 0;
    }
}
}