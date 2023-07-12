package fr.opendo.tools {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

// Classe
	public class XMLLoader extends EventDispatcher {
		public var xml : XML;
		public var totalBytes : Number = 0;
		public var currentBytesLoaded : Number = 0;
		private var urlLoader : URLLoader;
		private var completeFunction : Function;
		private var errorFunction : Function;

		public function XMLLoader(url : String, postData : URLVariables = null) {
			xml = new XML();
			var request : URLRequest = new URLRequest(url + "?t=" + Math.floor(Math.random() * 99999));
			if (postData != null) {
				request.data = postData;
				request.method = URLRequestMethod.POST;
			}
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlError);
			urlLoader.addEventListener(Event.OPEN, onDownloadStart);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			urlLoader.load(request);
		}

		private function onProgress(event : ProgressEvent) : void {
			currentBytesLoaded = urlLoader.bytesLoaded;
			totalBytes = urlLoader.bytesTotal;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}

		private function onDownloadStart(event : Event) : void {
			urlLoader.removeEventListener(Event.OPEN, onDownloadStart);
			dispatchEvent(new Event(Event.OPEN));
		}

		// XML Chargé
		private function xmlLoaded(e : Event) : void {
			xml = XML(e.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function xmlError(e : IOErrorEvent) : void {
			dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}
	}
}
