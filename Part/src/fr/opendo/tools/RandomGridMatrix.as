package fr.opendo.tools {
	/**
	 * @author am @ complexresponse.com
	 */
	dynamic public class RandomGridMatrix extends Array {
		private var columns : int;
		private var rows : int;

		public function RandomGridMatrix(columns : int, rows : int) {
			this.columns = columns;
			this.rows = rows;

			new Array(rows) as RandomGridMatrix;

			for (var r : int = 0;r < rows;r++) {
				this[r] = [];
				for (var c : int = 0;c < columns;c++) {
					this[r][c] = 0;
				}
			}
		}

		public function fillMatrix(moduleX : int, moduleY : int, moduleSize : int) : void {
			for (var r : int = 0;r < moduleSize;r++) {
				for (var c : int = 0;c < moduleSize;c++) {
					this[moduleY + r][moduleX + c] = 1;
				}
			}
		}

		public function resetMatrix() : void {
			for (var r : int = 0;r < rows;r++) {
				for (var c : int = 0;c < columns;c++) {
					this[r][c] = 0;
				}
			}
		}

		public function writeMatrix(moduleX : int, moduleY : int, moduleSize : int) : int {
			// detect free space to start writing
			if (this[moduleY][moduleX]) {
				return 0;
			}

			// __________________________________________________________________
			// detect overflow COLUMNS
			var fixSize : int = columns - (moduleX + moduleSize);

			if (fixSize < 0) {
				moduleSize = moduleSize + fixSize;
			}
			// read from point selected through COLUMNS
			var readColumns : int = checkFreeColumns(moduleX, moduleY, moduleSize);

			// __________________________________________________________________
			// detect overflow ROWS
			fixSize = rows - (moduleY + moduleSize);

			if (fixSize < 0) {
				moduleSize = moduleSize + fixSize;
			}
			// read from point selected through ROWS
			var readRows : int = checkFreeRows(moduleX, moduleY, moduleSize);

			// check if there is need to fix size
			if (moduleSize > readColumns || moduleSize > readRows) {
				// check the smallest read and fix the size
				if (readColumns < readRows) moduleSize = readColumns;
				else moduleSize = readRows - 1;
			}

			// write to matrix
			fillMatrix(moduleX, moduleY, moduleSize);

			// return allowed size
			return moduleSize;
		}

		private function checkFreeColumns(moduleX : int, moduleY : int, moduleSize : int) : int {
			var count : int = 0;
			var readLength : int = moduleX + moduleSize;
			for (var r : int = moduleX;r < readLength;r++) {
				if (this[moduleY][r]) {
					count++;
					return count;
				}
			}
			return moduleSize;
		}

		private function checkFreeRows(moduleX : int, moduleY : int, moduleSize : int) : int {
			var count : int = 0;
			var readLength : int = moduleY + moduleSize;
			for (var r : int = moduleY;r < readLength;r++) {
				if (this[r][moduleX]) {
					count++;
					return count;
				}
			}
			return moduleSize;
		}
	}
}


