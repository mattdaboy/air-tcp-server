package fr.opendo.medias {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

import fr.opendo.IKillable;

/**
	 * @author nicolas
	 * EVENT > Event.SOUND_COMPLETE lorsque que l'on est arrivé a la fin du morceau
	 * prend en charge le controle d'un son déja chargé
	 * PLAY
	 * STOP
	 * PAUSE
	 * AUTO LOOP
	 * SEEK
	 */
	public class SoundController extends EventDispatcher implements IKillable {
		/**
		 * constante des sons en SOURDINE
		 */
		public static const MUTE_SOUND_TRANSFORM : SoundTransform = new SoundTransform(0);
		/**
		 * l'objet sound
		 */
		private var _sound : Sound;
		/**
		 * SOUND CHANNEL
		 */
		private var _soundChannel : SoundChannel;
		/**
		 * 
		 */
		private var _autoLoop : Boolean;
		/**
		 * objet Soundtransform pour controler le volume du son
		 */
		private var _soundTransform : SoundTransform;
		/**
		 * indique si le son est en cours de lecture
		 */
		private var _isPlaying : Boolean;
		/**
		 * derniere position connue de la tete de lecture
		 */
		private var _lastPosition : Number;
		/**
		 * le soundtransform courant
		 */
		private var _currentSoundTransform : SoundTransform;

		/**
		 * CONSTRUCTEUR
		 * @throws ERROR					si l'objet son passé en parametre n'est pas completement chargé
		 * @param sound:Sound=null			l'objet sound a controller
		 * @param autoLoop:Boolean=false	indique si le mode de bouclage automatique est activé
		 */
		public function SoundController(sound : Sound = null, autoLoop : Boolean = false) {
			// on verifie que l'objet son transmit n'est pas encore en cours de chargement
			if (sound) if (sound.bytesLoaded != sound.bytesTotal) throw new Error("SoundControler > Sound is not fully loaded");
			_sound = sound;
			_autoLoop = autoLoop;
			_currentSoundTransform = _soundTransform = new SoundTransform;
			_isPlaying = false;
			_lastPosition = 0;
			_soundChannel = new SoundChannel;
		}

		/**
		 * lance la lecture
		 * @param position:int=-1	position de depart pour la lecture (par defaut prend la lecture a l'endroit oule son c'est arreté pour la derniere fois)
		 */
		public function play(position : int = -1) : void {
			// si le son n'existe pas ou est déja en cours de lecture on quitte
			if (!_sound || _isPlaying) return;
			if (position == -1) {
				_soundChannel = _sound.play(_lastPosition);
			} else {
				_soundChannel = _sound.play(position);
			}
			// on ecoute l'event de fin de lecture
			addSoundChannelListener();
			// on reafecte le sound transform courant
			_soundChannel.soundTransform = _currentSoundTransform;
			_isPlaying = true;
		}

		/**
		 * arrete la lecture (place la tete de lecture a ZERO)
		 * @return void
		 */
		public function stop() : void {
			_soundChannel.stop();
			_lastPosition = 0;
			_isPlaying = false;
		}

		/**
		 * met en pause la lecture (ne deplace pas la tete de lecture)
		 * @return void
		 */
		public function pause() : void {
			_lastPosition = _soundChannel.position;
			_soundChannel.stop();
			_isPlaying = false;
		}

		/**
		 * deplace la tete de lecture a la position passée en parametre LE CONTROLLEUR DOIT ETRE EN LECTURE
		 * @param position:Number			la position a atteindre en POURCENT (valeur de 0 a 1) ou en position fixe
		 * @param usePercent:Boolean=true	indique si la parametre doit etre utilisé en tant que pourcentage ou en tant que valeur fixe
		 * @return void
		 */
		public function seek(position : Number, usePercent : Boolean = true) : void {
			// il n'y a pas de lecture en cours ou qu'il n'y a pas d'objet son
			if (!_isPlaying || !_sound) return;
			if (usePercent) {
				position = position * _sound.length;
			}
			// si la position demandée est hors limite on place la position a ZERO
			position = position < _sound.length ? position : 0;
			// on arrete le lecture
			stop();
			// on la relance a la position demandée
			play(position);
		}

		/**
		 * met le volume du son a ZERO
		 * @return void
		 */
		public function mute() : void {
			// on affete le sound transform sourdine
			_currentSoundTransform = _soundChannel.soundTransform = MUTE_SOUND_TRANSFORM;
		}

		/**
		 * sort le son du mode mute
		 * @return void
		 */
		public function unmute() : void {
			// on reafecte le sound transform courant
			_currentSoundTransform = _soundChannel.soundTransform = _soundTransform;
		}

		/**
		 * permet de TUER "PROPREMENT" le controlleur
		 * PAS DE RETOUR EN ARRIERE POSSIBLE
		 * @see IKIllable
		 * @return void
		 */
		public function kill() : void {
			if (_isPlaying) stop();
			_sound = null;
			_soundChannel = null;
			_soundTransform = _currentSoundTransform = null;
		}

		/**
		 * ajoute les ecouteurs d'evenements pour le son courant
		 * @return void
		 */
		private function addSoundChannelListener() : void {
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete, false, 0, true);
		}

		/**
		 * SOUND COMPLETE
		 * @param e:Event
		 * @return void
		 */
		private function soundComplete(e : Event) : void {
			_isPlaying = false;
			_lastPosition = 0;
			// si on est en mode auto loop on relance la lecture
			if (_autoLoop) {
				play();
				return;
			}
			// on dispatch un event pour indiquer que la lecture c'est arrétée
			if (this.hasEventListener(Event.SOUND_COMPLETE)) dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}

		/**
		 * GETTER
		 * retourne une reference au son en cours de lecture
		 * @return Sound
		 */
		public function get sound() : Sound {
			return _sound;
		}

		/**
		 * SETTER
		 * affecte le son a controller
		 * @throws ERROR		si l'objet Sound passé en parametre n'est pas totalement downloadé
		 * @param value:Sound
		 * @return void
		 */
		public function set sound(value : Sound) : void {
			// en fonction de la valeur passée en parametre
			if (value) {
				// on verifie que l'objet son transmit n'est pas encore en cours de chargement
				// si c'est le cas on lance une EXCEPTION
				if (value.bytesLoaded != value.bytesTotal) throw new Error("SoundControler > Sound is not fully loaded");
			}
			//
			_sound = value;
			if (_isPlaying) {
				stop();
				play();
			}
		}

		/**
		 * GETTER
		 * @return Boolean
		 */
		public function get autoLoop() : Boolean {
			return _autoLoop;
		}

		/**
		 * SETTER
		 * @param value:Boolean
		 * @return void
		 */
		public function set autoLoop(value : Boolean) : void {
			_autoLoop = value;
		}

		/**
		 * retourne le volume courant pour le controlleur de son (de 0 a 1)
		 * @return Number
		 */
		public function get volume() : Number {
			return _soundTransform.volume;
		}

		/**
		 * affecte le volume pour le controlleur VALEUR devrait etre comprise entre 0 et 1		
		 * @param value:Number
		 * @return void
		 */
		public function set volume(value : Number) : void {
			// si le son est a ZERO on ne passe pas en mode mute
			// dans le cas contraire il faudrait dispatcher une event pour rendre compte du changement d'etat
			_soundTransform.volume = value;
			if (_currentSoundTransform != MUTE_SOUND_TRANSFORM) {
				_soundChannel.soundTransform = _soundTransform;
			}
		}

		/**
		 * change le panoramique audio valeurs de -1 a 1
		 * @param value:Number
		 * @return void
		 */
		public function set pan(value : Number) : void {
			_soundTransform.pan = value;
			if (_currentSoundTransform != MUTE_SOUND_TRANSFORM) {
				_soundChannel.soundTransform = _soundTransform;
			}
		}

		/**
		 * GETTER
		 * indique si la lecture du son est en cours
		 * @return Boolean
		 */
		public function get isPlaying() : Boolean {
			return _isPlaying;
		}

		/**
		 * GETTER
		 * retourne le LEFT PEAK du soundchannel
		 * @return Number
		 */
		public function get leftPeak() : Number {
			return _soundChannel.leftPeak;
		}

		/**
		 * GETTER
		 * retourne le RIGHT PEAK du soundchannel
		 * @return Number
		 */
		public function get rightPeak() : Number {
			return _soundChannel.rightPeak;
		}
	}
}
