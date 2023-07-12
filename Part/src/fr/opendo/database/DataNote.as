package fr.opendo.database {
import flash.events.EventDispatcher;

/**
	 * @author noel
	 */
	public class DataNote extends EventDispatcher {
		private var _date : String;
		private var _note_content : String;
		private var _db_id : uint;
		private var _note_img : String = "";
		private var _note_id : String;

		public function DataNote(db_id : uint, date : String, content : String, img : String) {
			_date = (date == null) ? "" : date;
			_note_content = (content == null) ? "" : content;
			_db_id = db_id;
			_note_id = DataManager.user.email + db_id;
			if (img) {
				if(img.length>10){
					_note_img = img;
				}
				
			}
		}

		public function get db_id() : uint {
			return _db_id;
		}

		public function get date() : String {
			return _date;
		}

		public function get note_content() : String {
			return _note_content;
		}

		public function set note_content(content : String) : void {
			_note_content = content;
		}

		public function get note_img() : String {
			return _note_img;
		}

		public function set note_img(img : String) : void {
			_note_img = img;
		}

		public function get note_id() : String {
			return _note_id;
		}
	}
}