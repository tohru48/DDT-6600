package room.model
{
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.WebSpeedEvent;
   import ddt.manager.ItemManager;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.RoomCharacter;
   import ddt.view.character.ShowCharacter;
   import flash.events.EventDispatcher;
   import game.model.PlayerAdditionInfo;
   import room.events.RoomPlayerEvent;
   
   [Event(name="is_host_change",type="room.events.RoomPlayerEvent")]
   [Event(name="ready_change",type="room.events.RoomPlayerEvent")]
   public class RoomPlayer extends EventDispatcher
   {
      
      public static const BLUE_TEAM:uint = 1;
      
      public static const RED_TEAM:uint = 2;
      
      public var horseSkillEquipList:Array;
      
      private var _playerInfo:PlayerInfo;
      
      private var _team:int;
      
      private var _place:int;
      
      private var _isHost:Boolean;
      
      private var _isReady:Boolean;
      
      private var _webSpeedInfo:WebSpeedInfo;
      
      private var _progress:Number;
      
      private var _additionInfo:PlayerAdditionInfo;
      
      private var _isFirstIn:Boolean;
      
      private var _position:int;
      
      private var _character:ShowCharacter;
      
      private var _movie:GameCharacter;
      
      private var _roomCharater:RoomCharacter;
      
      public function RoomPlayer(playerInfo:PlayerInfo)
      {
         super();
         this._playerInfo = playerInfo;
         this.initEvents();
         this._webSpeedInfo = new WebSpeedInfo(this._playerInfo.webSpeed);
         this._additionInfo = new PlayerAdditionInfo();
      }
      
      public function get isViewer() : Boolean
      {
         return this._place >= 8;
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function set position(value:int) : void
      {
         this._position = value;
      }
      
      private function initEvents() : void
      {
         this._playerInfo.addEventListener(WebSpeedEvent.STATE_CHANE,this.__webSpeedHandler);
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._playerInfo))
         {
            this._playerInfo.removeEventListener(WebSpeedEvent.STATE_CHANE,this.__webSpeedHandler);
         }
      }
      
      private function __webSpeedHandler(evt:WebSpeedEvent) : void
      {
         this._webSpeedInfo.delay = this._playerInfo.webSpeed;
      }
      
      public function get webSpeedInfo() : WebSpeedInfo
      {
         return this._webSpeedInfo;
      }
      
      public function hasDeputyWeapon() : Boolean
      {
         return this._playerInfo.DeputyWeaponID > 0;
      }
      
      public function get team() : int
      {
         return this._team;
      }
      
      public function set team(value:int) : void
      {
         this._team = value;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function set place(value:int) : void
      {
         this._place = value;
      }
      
      public function get isFirstIn() : Boolean
      {
         return this._isFirstIn;
      }
      
      public function set isFirstIn(value:Boolean) : void
      {
         this._isFirstIn = value;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      public function get isSelf() : Boolean
      {
         return this.playerInfo is SelfInfo;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._playerInfo = null;
         this._webSpeedInfo = null;
         if(Boolean(this._character))
         {
            this._character.dispose();
         }
         this._character = null;
         if(Boolean(this._movie))
         {
            this._movie.dispose();
         }
         this._movie = null;
         if(Boolean(this._roomCharater))
         {
            this._roomCharater.dispose();
         }
         this._roomCharater = null;
      }
      
      public function get isHost() : Boolean
      {
         return this._isHost;
      }
      
      public function set isHost(value:Boolean) : void
      {
         this._isHost = value;
         dispatchEvent(new RoomPlayerEvent(RoomPlayerEvent.IS_HOST_CHANGE));
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
      
      public function set isReady(value:Boolean) : void
      {
         this._isReady = value;
         dispatchEvent(new RoomPlayerEvent(RoomPlayerEvent.READY_CHANGE));
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function set progress(value:Number) : void
      {
         this._progress = value;
         dispatchEvent(new RoomPlayerEvent(RoomPlayerEvent.PROGRESS_CHANGE));
      }
      
      public function get additionInfo() : PlayerAdditionInfo
      {
         return this._additionInfo;
      }
      
      public function get currentWeapInfo() : WeaponInfo
      {
         return new WeaponInfo(ItemManager.Instance.getTemplateById(this._playerInfo.WeaponID));
      }
      
      public function get currentDeputyWeaponInfo() : DeputyWeaponInfo
      {
         return new DeputyWeaponInfo(ItemManager.Instance.getTemplateById(this._playerInfo.DeputyWeaponID));
      }
      
      public function get character() : ShowCharacter
      {
         if(this._character == null)
         {
            this._character = CharactoryFactory.createCharacter(this._playerInfo,CharactoryFactory.SHOW,true) as ShowCharacter;
         }
         return this._character;
      }
      
      public function get movie() : GameCharacter
      {
         if(this._movie == null)
         {
            this._movie = CharactoryFactory.createCharacter(this._playerInfo,CharactoryFactory.GAME) as GameCharacter;
         }
         return this._movie;
      }
      
      public function get roomCharater() : RoomCharacter
      {
         if(this._roomCharater == null)
         {
            this._roomCharater = CharactoryFactory.createCharacter(this._playerInfo,CharactoryFactory.ROOM) as RoomCharacter;
         }
         this._roomCharater.showGun = true;
         return this._roomCharater;
      }
      
      public function resetCharacter() : void
      {
         if(Boolean(this._character))
         {
            this._character.x = 0;
            this._character.y = 0;
            this._character.doAction(ShowCharacter.STAND);
         }
      }
   }
}

