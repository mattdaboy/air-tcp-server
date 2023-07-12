package fr.opendo.tools {
	/**
	 * @author Noel
	 */
	public class RandomUnique {
		public static function between(startNumber : int = 0, endNumber : int = 9) : Array {
			var baseNumber : Array = [];
			var randNumber : Array = [];
			for (var i : int = startNumber; i <= endNumber; i++) {
				baseNumber[i] = i;
			}
			for (i = endNumber; i > startNumber; i--) {
				var tempRandom : Number = startNumber + Math.floor(Math.random() * (i - startNumber));
				randNumber[i] = baseNumber[tempRandom];
				baseNumber[tempRandom] = baseNumber[i];
			}
			randNumber[startNumber] = baseNumber[startNumber];
			return randNumber;
		}
	}
}


