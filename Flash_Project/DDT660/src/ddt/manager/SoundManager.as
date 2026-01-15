package ddt.manager
{
   import com.pickgliss.loader.ModuleLoader;
   import ddt.loader.StartupResourceLoader;
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.utils.Dictionary;
   import road7th.math.randRange;
   
   public class SoundManager
   {
      
      private static var _instance:SoundManager;
      
      private static const MusicFailedTryTime:int = 3;
      
      public static var SITE_MAIN:String = "";
      
      private var currentMusicTry:int = 0;
      
      private var _dic:Dictionary;
      
      private var _music:Array;
      
      private var _allowSound:Boolean;
      
      private var _currentSound:Dictionary;
      
      private var _allowMusic:Boolean;
      
      private var _currentMusic:String;
      
      private var _musicLoop:Boolean;
      
      private var _isMusicPlaying:Boolean;
      
      private var _musicPlayList:Array;
      
      private var _musicVolume:Number;
      
      private var soundVolumn:Number;
      
      private var _nc:NetConnection;
      
      private var _ns:NetStream;
      
      private var isInitSevendDouble:Boolean = false;
      
      private var isInitEscort:Boolean = false;
      
      public function SoundManager()
      {
         super();
         this._dic = new Dictionary();
         this._currentSound = new Dictionary(true);
         this._isMusicPlaying = false;
         this._musicLoop = false;
         this._allowMusic = true;
         this._allowSound = true;
         this._nc = new NetConnection();
         this._nc.connect(null);
         this._ns = new NetStream(this._nc);
         this._ns.bufferTime = 0.3;
         this._ns.client = this;
         this._ns.addEventListener(NetStatusEvent.NET_STATUS,this.__netStatus);
         this._musicPlayList = [];
      }
      
      public static function get instance() : SoundManager
      {
         if(_instance == null)
         {
            _instance = new SoundManager();
         }
         return _instance;
      }
      
      public function get allowSound() : Boolean
      {
         return this._allowSound;
      }
      
      public function set allowSound(value:Boolean) : void
      {
         if(this._allowSound == value)
         {
            return;
         }
         this._allowSound = value;
         if(!this._allowSound)
         {
            this.stopAllSound();
         }
      }
      
      public function get allowMusic() : Boolean
      {
         return this._allowMusic;
      }
      
      public function set allowMusic(value:Boolean) : void
      {
         if(this._allowMusic == value)
         {
            return;
         }
         this._allowMusic = value;
         if(this._allowMusic)
         {
            this.resumeMusic();
         }
         else
         {
            this.pauseMusic();
         }
      }
      
      public function onPlayStatus(e:*) : void
      {
      }
      
      public function setup(music:Array, siteMain:String) : void
      {
         this._music = Boolean(music) ? music : [];
         SITE_MAIN = siteMain;
      }
      
      public function setConfig(allowMusic:Boolean, allowSound:Boolean, musicVolumn:Number, soundVolumn:Number) : void
      {
         this.allowMusic = allowMusic;
         this.allowSound = allowSound;
         this._musicVolume = musicVolumn;
         if(this.allowMusic)
         {
            this._ns.soundTransform = new SoundTransform(musicVolumn / 100);
         }
         this.soundVolumn = soundVolumn;
      }
      
      public function setupAudioResource(isAudioII:Boolean) : void
      {
         if(!isAudioII)
         {
            this.initI();
         }
         this.initII();
      }
      
      private function initI() : void
      {
         this._dic["001"] = ModuleLoader.getDefinition("Sound001");
         this._dic["006"] = ModuleLoader.getDefinition("Sound006");
         this._dic["007"] = ModuleLoader.getDefinition("Sound007");
         this._dic["008"] = ModuleLoader.getDefinition("Sound008");
         this._dic["009"] = ModuleLoader.getDefinition("Sound009");
         this._dic["010"] = ModuleLoader.getDefinition("Sound010");
         this._dic["012"] = ModuleLoader.getDefinition("Sound012");
         this._dic["014"] = ModuleLoader.getDefinition("Sound014");
         this._dic["015"] = ModuleLoader.getDefinition("Sound015");
         this._dic["017"] = ModuleLoader.getDefinition("Sound017");
         this._dic["018"] = ModuleLoader.getDefinition("Sound018");
         this._dic["021"] = ModuleLoader.getDefinition("Sound021");
         this._dic["023"] = ModuleLoader.getDefinition("Sound023");
         this._dic["025"] = ModuleLoader.getDefinition("Sound025");
         this._dic["027"] = ModuleLoader.getDefinition("Sound027");
         this._dic["031"] = ModuleLoader.getDefinition("Sound031");
         this._dic["033"] = ModuleLoader.getDefinition("Sound033");
         this._dic["035"] = ModuleLoader.getDefinition("Sound035");
         this._dic["039"] = ModuleLoader.getDefinition("Sound039");
         this._dic["040"] = ModuleLoader.getDefinition("Sound040");
         this._dic["041"] = ModuleLoader.getDefinition("Sound041");
         this._dic["042"] = ModuleLoader.getDefinition("Sound042");
         this._dic["043"] = ModuleLoader.getDefinition("Sound043");
         this._dic["044"] = ModuleLoader.getDefinition("Sound044");
         this._dic["045"] = ModuleLoader.getDefinition("Sound045");
         this._dic["047"] = ModuleLoader.getDefinition("Sound047");
         this._dic["048"] = ModuleLoader.getDefinition("Sound048");
         this._dic["049"] = ModuleLoader.getDefinition("Sound049");
         this._dic["050"] = ModuleLoader.getDefinition("Sound050");
         this._dic["057"] = ModuleLoader.getDefinition("Sound057");
         this._dic["058"] = ModuleLoader.getDefinition("Sound058");
         this._dic["063"] = ModuleLoader.getDefinition("Sound063");
         this._dic["064"] = ModuleLoader.getDefinition("Sound064");
         this._dic["067"] = ModuleLoader.getDefinition("Sound067");
         this._dic["069"] = ModuleLoader.getDefinition("Sound069");
         this._dic["071"] = ModuleLoader.getDefinition("Sound071");
         this._dic["073"] = ModuleLoader.getDefinition("Sound073");
         this._dic["075"] = ModuleLoader.getDefinition("Sound075");
         this._dic["078"] = ModuleLoader.getDefinition("Sound078");
         this._dic["081"] = ModuleLoader.getDefinition("Sound081");
         this._dic["083"] = ModuleLoader.getDefinition("Sound083");
         this._dic["087"] = ModuleLoader.getDefinition("Sound087");
         this._dic["088"] = ModuleLoader.getDefinition("Sound088");
         this._dic["091"] = ModuleLoader.getDefinition("Sound091");
         this._dic["092"] = ModuleLoader.getDefinition("Sound092");
         this._dic["093"] = ModuleLoader.getDefinition("Sound093");
         this._dic["094"] = ModuleLoader.getDefinition("Sound094");
         this._dic["095"] = ModuleLoader.getDefinition("Sound095");
         this._dic["096"] = ModuleLoader.getDefinition("Sound096");
         this._dic["098"] = ModuleLoader.getDefinition("Sound098");
         this._dic["099"] = ModuleLoader.getDefinition("Sound099");
         this._dic["100"] = ModuleLoader.getDefinition("Sound100");
         this._dic["101"] = ModuleLoader.getDefinition("Sound101");
         this._dic["102"] = ModuleLoader.getDefinition("Sound102");
         this._dic["103"] = ModuleLoader.getDefinition("Sound103");
         this._dic["104"] = ModuleLoader.getDefinition("Sound104");
         this._dic["105"] = ModuleLoader.getDefinition("Sound105");
         this._dic["106"] = ModuleLoader.getDefinition("Sound106");
         this._dic["107"] = ModuleLoader.getDefinition("Sound107");
         this._dic["108"] = ModuleLoader.getDefinition("Sound108");
         this._dic["109"] = ModuleLoader.getDefinition("Sound109");
         this._dic["110"] = ModuleLoader.getDefinition("Sound110");
         this._dic["111"] = ModuleLoader.getDefinition("Sound111");
         this._dic["112"] = ModuleLoader.getDefinition("Sound112");
         this._dic["113"] = ModuleLoader.getDefinition("Sound113");
         this._dic["114"] = ModuleLoader.getDefinition("Sound114");
         this._dic["115"] = ModuleLoader.getDefinition("Sound115");
         this._dic["116"] = ModuleLoader.getDefinition("Sound116");
         this._dic["117"] = ModuleLoader.getDefinition("Sound117");
         this._dic["118"] = ModuleLoader.getDefinition("Sound118");
         this._dic["119"] = ModuleLoader.getDefinition("Sound119");
         this._dic["120"] = ModuleLoader.getDefinition("Sound120");
         this._dic["121"] = ModuleLoader.getDefinition("Sound121");
         this._dic["122"] = ModuleLoader.getDefinition("Sound122");
         this._dic["123"] = ModuleLoader.getDefinition("Sound123");
         this._dic["124"] = ModuleLoader.getDefinition("Sound124");
         this._dic["125"] = ModuleLoader.getDefinition("Sound125");
         this._dic["126"] = ModuleLoader.getDefinition("Sound126");
         this._dic["127"] = ModuleLoader.getDefinition("Sound127");
         this._dic["128"] = ModuleLoader.getDefinition("Sound128");
         this._dic["129"] = ModuleLoader.getDefinition("Sound129");
         this._dic["130"] = ModuleLoader.getDefinition("Sound130");
         this._dic["131"] = ModuleLoader.getDefinition("Sound131");
         this._dic["132"] = ModuleLoader.getDefinition("Sound132");
         this._dic["133"] = ModuleLoader.getDefinition("Sound133");
         this._dic["134"] = ModuleLoader.getDefinition("Sound134");
         this._dic["135"] = ModuleLoader.getDefinition("Sound135");
         this._dic["136"] = ModuleLoader.getDefinition("Sound136");
         this._dic["137"] = ModuleLoader.getDefinition("Sound137");
         this._dic["138"] = ModuleLoader.getDefinition("Sound138");
         this._dic["139"] = ModuleLoader.getDefinition("Sound139");
         this._dic["141"] = ModuleLoader.getDefinition("Sound141");
         this._dic["142"] = ModuleLoader.getDefinition("Sound142");
         this._dic["143"] = ModuleLoader.getDefinition("Sound143");
         this._dic["144"] = ModuleLoader.getDefinition("Sound144");
         this._dic["145"] = ModuleLoader.getDefinition("Sound145");
         this._dic["146"] = ModuleLoader.getDefinition("Sound146");
         this._dic["147"] = ModuleLoader.getDefinition("Sound147");
         this._dic["148"] = ModuleLoader.getDefinition("Sound148");
         this._dic["149"] = ModuleLoader.getDefinition("Sound149");
         this._dic["150"] = ModuleLoader.getDefinition("Sound150");
         this._dic["151"] = ModuleLoader.getDefinition("Sound151");
         this._dic["152"] = ModuleLoader.getDefinition("Sound152");
         this._dic["153"] = ModuleLoader.getDefinition("Sound153");
         this._dic["155"] = ModuleLoader.getDefinition("Sound155");
         this._dic["156"] = ModuleLoader.getDefinition("Sound156");
         this._dic["158"] = ModuleLoader.getDefinition("Sound158");
         this._dic["159"] = ModuleLoader.getDefinition("Sound159");
         this._dic["160"] = ModuleLoader.getDefinition("Sound160");
         this._dic["161"] = ModuleLoader.getDefinition("Sound161");
         this._dic["162"] = ModuleLoader.getDefinition("Sound162");
         this._dic["163"] = ModuleLoader.getDefinition("Sound163");
         this._dic["164"] = ModuleLoader.getDefinition("Sound164");
         this._dic["165"] = ModuleLoader.getDefinition("Sound165");
         this._dic["166"] = ModuleLoader.getDefinition("Sound166");
         this._dic["167"] = ModuleLoader.getDefinition("Sound167");
         this._dic["200"] = ModuleLoader.getDefinition("Sound200");
         this._dic["201"] = ModuleLoader.getDefinition("Sound201");
         this._dic["202"] = ModuleLoader.getDefinition("Sound202");
         this._dic["168"] = ModuleLoader.getDefinition("Sound168");
         this._dic["169"] = ModuleLoader.getDefinition("Sound169");
         this._dic["170"] = ModuleLoader.getDefinition("Sound170");
         this._dic["171"] = ModuleLoader.getDefinition("Sound171");
         this._dic["1001"] = ModuleLoader.getDefinition("Sound1001");
         this._dic["203"] = ModuleLoader.getDefinition("Sound203");
         this._dic["204"] = ModuleLoader.getDefinition("Sound204");
         this._dic["210"] = ModuleLoader.getDefinition("Sound210");
         this._dic["211"] = ModuleLoader.getDefinition("Sound211");
         this._dic["212"] = ModuleLoader.getDefinition("Sound212");
         this._dic["211"] = ModuleLoader.getDefinition("Sound211");
         this._dic["212"] = ModuleLoader.getDefinition("Sound212");
      }
      
      private function initII() : void
      {
         this._dic["003"] = ModuleLoader.getDefinition("Sound003");
         this._dic["013"] = ModuleLoader.getDefinition("Sound013");
         this._dic["016"] = ModuleLoader.getDefinition("Sound016");
         this._dic["019"] = ModuleLoader.getDefinition("Sound019");
         this._dic["020"] = ModuleLoader.getDefinition("Sound020");
         this._dic["029"] = ModuleLoader.getDefinition("Sound029");
         this._dic["038"] = ModuleLoader.getDefinition("Sound038");
         this._dic["079"] = ModuleLoader.getDefinition("Sound079");
         this._dic["089"] = ModuleLoader.getDefinition("Sound089");
         this._dic["090"] = ModuleLoader.getDefinition("Sound090");
         this._dic["097"] = ModuleLoader.getDefinition("Sound097");
         this._dic["157"] = ModuleLoader.getDefinition("Sound157");
      }
      
      public function initSevenDoubleSound() : void
      {
         if(this.isInitSevendDouble)
         {
            return;
         }
         this._dic["sevenDouble01"] = ModuleLoader.getDefinition("sevenDoubleSound01");
         this._dic["sevenDouble02"] = ModuleLoader.getDefinition("sevenDoubleSound02");
         this._dic["sevenDouble03"] = ModuleLoader.getDefinition("sevenDoubleSound03");
         this._dic["sevenDouble04"] = ModuleLoader.getDefinition("sevenDoubleSound04");
         this._dic["sevenDouble05"] = ModuleLoader.getDefinition("sevenDoubleSound05");
         this.isInitSevendDouble = true;
      }
      
      public function initEscortSound() : void
      {
         if(this.isInitEscort)
         {
            return;
         }
         this._dic["escort01"] = ModuleLoader.getDefinition("escortSound01");
         this._dic["escort02"] = ModuleLoader.getDefinition("escortSound02");
         this._dic["escort03"] = ModuleLoader.getDefinition("escortSound03");
         this._dic["escort04"] = ModuleLoader.getDefinition("escortSound04");
         this._dic["escort05"] = ModuleLoader.getDefinition("escortSound05");
         this.isInitEscort = true;
      }
      
      public function checkHasSound(sound:String) : Boolean
      {
         if(this._dic[sound] != null)
         {
            return true;
         }
         return false;
      }
      
      public function initSound(sound:String) : void
      {
         if(this.checkHasSound(sound))
         {
            return;
         }
         this._dic[sound] = ModuleLoader.getDefinition("Sound" + sound);
      }
      
      public function play(id:String, allowMulti:Boolean = false, replaceSame:Boolean = true, loop:Number = 0) : SoundChannel
      {
         if(this._dic[id] == null)
         {
            return null;
         }
         if(this._allowSound)
         {
            try
            {
               if(allowMulti || replaceSame || !this.isPlaying(id))
               {
                  return this.playSoundImp(id,loop);
               }
            }
            catch(e:Error)
            {
            }
         }
         return null;
      }
      
      public function playButtonSound() : void
      {
         this.play("008");
      }
      
      private function playSoundImp(id:String, loop:Number) : SoundChannel
      {
         var ss:Sound = new this._dic[id]();
         var sc:SoundChannel = ss.play(0,loop,new SoundTransform(this.soundVolumn / 100));
         sc.addEventListener(Event.SOUND_COMPLETE,this.__soundComplete);
         this._currentSound[id] = sc;
         return sc;
      }
      
      private function __soundComplete(evt:Event) : void
      {
         var i:String = null;
         var c:SoundChannel = evt.currentTarget as SoundChannel;
         c.removeEventListener(Event.SOUND_COMPLETE,this.__soundComplete);
         c.stop();
         for(i in this._currentSound)
         {
            if(this._currentSound[i] == c)
            {
               this._currentSound[i] = null;
               return;
            }
         }
      }
      
      public function stop(s:String) : void
      {
         if(Boolean(this._currentSound[s]))
         {
            this._currentSound[s].stop();
            this._currentSound[s] = null;
         }
      }
      
      public function stopAllSound() : void
      {
         var sound:SoundChannel = null;
         for each(sound in this._currentSound)
         {
            if(Boolean(sound))
            {
               sound.stop();
            }
         }
         this._currentSound = new Dictionary();
      }
      
      public function isPlaying(s:String) : Boolean
      {
         return this._currentSound[s] == null ? false : true;
      }
      
      public function playMusic(id:String, loops:Boolean = true, replaceSame:Boolean = false) : void
      {
         this.currentMusicTry = 0;
         if(replaceSame || this._currentMusic != id)
         {
            if(this._isMusicPlaying)
            {
               this.stopMusic();
            }
            this.playMusicImp([id],loops);
         }
      }
      
      private function playMusicImp(list:Array, loops:Boolean) : void
      {
         this._musicLoop = loops;
         this._musicPlayList = list;
         if(list.length > 0)
         {
            this._currentMusic = list[0];
            this._isMusicPlaying = true;
            if(StartupResourceLoader.firstEnterHall && this._currentMusic == "062")
            {
               return;
            }
            this._ns.play(SITE_MAIN + "sound/" + this._currentMusic + ".flv");
            this._ns.soundTransform = new SoundTransform(this._musicVolume / 100);
            if(!this._allowMusic)
            {
               this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.__onMusicStaus);
               this.pauseMusic();
            }
            else
            {
               this._ns.addEventListener(NetStatusEvent.NET_STATUS,this.__onMusicStaus);
            }
         }
      }
      
      private function __onMusicStaus(e:NetStatusEvent) : void
      {
         if(e.info.code == "NetConnection.Connect.Failed" || e.info.code == "NetStream.Play.StreamNotFound")
         {
            if(this.currentMusicTry < MusicFailedTryTime)
            {
               ++this.currentMusicTry;
               this._ns.play(SITE_MAIN + "sound/" + this._currentMusic + ".flv");
            }
            else
            {
               this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.__onMusicStaus);
            }
         }
         else if(e.info.code == "NetStream.Play.Start")
         {
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.__onMusicStaus);
         }
      }
      
      public function setMusicVolumeByRatio(ratio:Number) : void
      {
         if(this.allowMusic)
         {
            this._musicVolume *= ratio;
            this._ns.soundTransform = new SoundTransform(this._musicVolume / 100);
         }
      }
      
      public function pauseMusic() : void
      {
         if(this._isMusicPlaying)
         {
            this._ns.soundTransform = new SoundTransform(0);
            this._isMusicPlaying = false;
         }
      }
      
      public function resumeMusic() : void
      {
         if(this._allowMusic && Boolean(this._currentMusic))
         {
            this._ns.soundTransform = new SoundTransform(this._musicVolume / 100);
            this._isMusicPlaying = true;
         }
      }
      
      public function stopMusic() : void
      {
         if(Boolean(this._currentMusic))
         {
            this._isMusicPlaying = false;
            this._ns.close();
            this._currentMusic = null;
         }
      }
      
      public function playGameBackMusic(id:String) : void
      {
         this.playMusicImp([id,id],false);
      }
      
      private function __netStatus(event:NetStatusEvent) : void
      {
         var index:int = 0;
         if(event.info.code == "NetStream.Play.Stop")
         {
            if(this._musicLoop)
            {
               this.playMusicImp(this._musicPlayList,true);
            }
            else if(this._musicPlayList.length > 0)
            {
               this.playMusicImp(this._musicPlayList,false);
            }
            else
            {
               index = randRange(0,this._music.length - 1);
               this.playMusicImp([this._music[index]],false);
            }
         }
      }
      
      public function onMetaData(info:Object) : void
      {
      }
      
      public function onXMPData(info:Object) : void
      {
      }
      
      public function onCuePoint(info:Object) : void
      {
      }
   }
}

