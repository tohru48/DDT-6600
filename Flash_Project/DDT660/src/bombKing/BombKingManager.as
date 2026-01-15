package bombKing
{
   import bombKing.components.BKingStatueItem;
   import bombKing.data.BKingStatueInfo;
   import bombKing.event.BombKingEvent;
   import bombKing.view.BombKingMainFrame;
   import bombKing.view.BombKingPromptFrame;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.constants.CacheConsts;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.FightReportAnalyze;
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.LoaderCreate;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.QueueManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import hall.player.HallPlayerView;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   
   public class BombKingManager extends EventDispatcher
   {
      
      private static var _instance:BombKingManager;
      
      public var Recording:Boolean;
      
      private var _frameSprite:Sprite;
      
      private var _cmdVec:Vector.<int>;
      
      private var _pkgVec:Vector.<PackageIn>;
      
      private var _cmdID:int = 0;
      
      private var _frame:BombKingMainFrame;
      
      public var isOpen:Boolean;
      
      private var _playerView:HallPlayerView;
      
      public var ReportID:String;
      
      private var _defaultFlag:Boolean = true;
      
      public var status:int;
      
      public var isOpenPromptFrame:Boolean = false;
      
      private var defaultStyleArr:Array = ["1860|head360,2201|default,3428|hair128,4429|eff129,5827|cloth327,6402|face102,70102|brick3,13201|default,15001|default,16000|default,","1730|head330,2101|default,3337|hair137,4351|eff151,5549|cloth249,6198|face98,702414|boomerang6,13101|default,15001|default,16008|chatBall8,17005|offhand5","1101|default,2101|default,3331|hair131,4151|eff51,5190|cloth90,6178|face78,70094|electricbar6,13101|default,15001|default,16000|default,"];
      
      private var showMsg:Boolean = true;
      
      private var beginOpenNowDate:Date;
      
      private var timeOutNum:uint;
      
      public function BombKingManager()
      {
         super();
         this._frameSprite = new Sprite();
         this._cmdVec = new Vector.<int>();
         this._pkgVec = new Vector.<PackageIn>();
      }
      
      public static function get instance() : BombKingManager
      {
         if(!_instance)
         {
            _instance = new BombKingManager();
         }
         return _instance;
      }
      
      public function setup(view:HallPlayerView) : void
      {
         this._playerView = view;
         this.initDefaultStatue();
         this.initEvent();
         SocketManager.Instance.out.getBKingStatueInfo();
         SocketManager.Instance.out.requestBKingShowTip();
      }
      
      private function initDefaultStatue() : void
      {
         var i:int = 0;
         var info:BKingStatueInfo = null;
         var item:BKingStatueItem = null;
         for(i = 0; i < 3; i++)
         {
            info = new BKingStatueInfo();
            info.style = this.defaultStyleArr[i];
            info.color = ",,,,,,,,,,";
            info.sex = false;
            item = new BKingStatueItem(i);
            item.info = info;
            item.mouseChildren = false;
            item.mouseEnabled = false;
            this.addToHall(item,i);
         }
      }
      
      private function initEvent() : void
      {
         RoomManager.Instance.addEventListener(BombKingEvent.STARTLOADBATTLEXML,this.__onStartLoadBattleXml);
         SocketManager.Instance.addEventListener(BombKingEvent.STATUE_INFO,this.__updateStatue);
         SocketManager.Instance.addEventListener(BombKingEvent.SHOW_TEXT,this.__showText);
         SocketManager.Instance.addEventListener(BombKingEvent.SHOW_TIP,this.__showTip);
         SocketManager.Instance.addEventListener(BombKingEvent.SHOW_FRAME,this.__showFrame);
      }
      
      protected function __showTip(event:BombKingEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this.isOpen = pkg.readBoolean();
         if(this.isOpen && this.showMsg)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("bombKing.battling"));
         }
         this.showMsg = false;
         if(Boolean(this._frame))
         {
            this._frame.setDateOfNext();
         }
      }
      
      protected function __showText(event:BombKingEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var str:String = pkg.readUTF();
         ChatManager.Instance.sysChatAmaranth(str);
      }
      
      protected function __updateStatue(event:BombKingEvent) : void
      {
         var i:int = 0;
         var isExist:Boolean = false;
         var info:BKingStatueInfo = null;
         var style:String = null;
         var item:BKingStatueItem = null;
         if(!this._playerView || !this._playerView.hallView)
         {
            return;
         }
         var pkg:PackageIn = event.pkg;
         this.clearStatue();
         this._defaultFlag = true;
         for(i = 0; i < 3; i++)
         {
            isExist = pkg.readBoolean();
            if(isExist)
            {
               this._defaultFlag = false;
               info = new BKingStatueInfo();
               info.name = pkg.readUTF();
               info.vipType = pkg.readInt();
               info.vipLevel = pkg.readInt();
               style = pkg.readUTF();
               info.style = this.cutSuitStr(style);
               info.color = pkg.readUTF();
               info.sex = pkg.readBoolean();
               info.areaName = pkg.readUTF();
               item = new BKingStatueItem(i);
               item.info = info;
               item.mouseChildren = false;
               item.mouseEnabled = false;
               this.addToHall(item,i);
            }
         }
         if(this._defaultFlag)
         {
            this.initDefaultStatue();
         }
      }
      
      public function cutSuitStr(style:String) : String
      {
         var arr:Array = style.split(",");
         arr[7] = "";
         return arr.join(",");
      }
      
      private function clearStatue() : void
      {
         var mc:MovieClip = null;
         var mcArr:Array = [];
         mcArr.push(this._playerView.hallView.getChildByName("bluePlatform") as MovieClip);
         mcArr.push(this._playerView.hallView.getChildByName("goldPlatform") as MovieClip);
         mcArr.push(this._playerView.hallView.getChildByName("redPlatform") as MovieClip);
         for(var i:int = 0; i <= mcArr.length - 1; i++)
         {
            mc = mcArr[i];
            mc.removeChildAt(mc.numChildren - 1);
         }
      }
      
      private function addToHall(item:BKingStatueItem, type:int) : void
      {
         switch(type)
         {
            case 0:
               item.x = -56;
               item.y = -281;
               (this._playerView.hallView.getChildByName("bluePlatform") as MovieClip).addChild(item);
               break;
            case 1:
               item.x = -58;
               item.y = -290;
               (this._playerView.hallView.getChildByName("goldPlatform") as MovieClip).addChild(item);
               break;
            case 2:
               item.x = -54;
               item.y = -281;
               (this._playerView.hallView.getChildByName("redPlatform") as MovieClip).addChild(item);
         }
      }
      
      protected function __onStartLoadBattleXml(event:BombKingEvent) : void
      {
         var loader:BaseLoader = LoaderCreate.Instance.getFightReportLoader(this.ReportID);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __showFrame(event:BombKingEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var minutes:int = pkg.readInt();
         if(minutes <= 5)
         {
            this.timeOutNum = setTimeout(this.checkShowPromptFrame,1000 * 60 * minutes);
         }
      }
      
      public function checkShowPromptFrame() : void
      {
         this.beginOpenNowDate = TimeManager.Instance.Now();
         if(!this.isOpenPromptFrame)
         {
            if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT) || CacheSysManager.isLock(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP))
            {
               CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP,new FunctionAction(this.showPromptFrame));
            }
            else
            {
               this.showPromptFrame();
            }
         }
         clearTimeout(this.timeOutNum);
      }
      
      private function showPromptFrame() : void
      {
         var _PromptFrame:BombKingPromptFrame = null;
         if(this.checkOpenTime())
         {
            _PromptFrame = ComponentFactory.Instance.creat("bombKing.BombKingPromptFrame");
            _PromptFrame.show();
            this.isOpenPromptFrame = true;
         }
      }
      
      private function checkOpenTime() : Boolean
      {
         var bool:Boolean = false;
         var nowTime:Date = TimeManager.Instance.Now();
         var championMatchBeginTime:Number = this.beginOpenNowDate.hours * 60 * 60 + this.beginOpenNowDate.minutes * 60 + this.beginOpenNowDate.seconds;
         var championMatchEndTime:Number = championMatchBeginTime + 60 * 60;
         var tempNum:Number = nowTime.hours * 60 * 60 + nowTime.minutes * 60 + nowTime.seconds;
         if(tempNum >= championMatchBeginTime && tempNum < championMatchEndTime)
         {
            bool = true;
         }
         else
         {
            bool = false;
         }
         return bool;
      }
      
      public function getFightInfo(analyzer:FightReportAnalyze) : void
      {
         var code:uint = 0;
         this._pkgVec = analyzer.pkgVec;
         for(var i:int = 0; i < this._pkgVec.length; i++)
         {
            code = this._pkgVec[i].readUnsignedByte();
            if((code == CrazyTankPackageType.GAME_CREATE || code == CrazyTankPackageType.GAME_LOAD || code == CrazyTankPackageType.START_GAME) && this._cmdVec.indexOf(code) != -1)
            {
               this._pkgVec.splice(i,1);
               i--;
            }
            else
            {
               this._cmdVec.push(code);
            }
         }
         this.play();
      }
      
      public function play() : void
      {
         this.Recording = true;
         this._frameSprite.addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      protected function __onEnterFrame(evt:Event) : void
      {
         var event:CrazyTankSocketEvent = null;
         if(this._cmdID < this._cmdVec.length)
         {
            switch(this._cmdVec[this._cmdID])
            {
               case CrazyTankPackageType.GEM_GLOW:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GEM_GLOW,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SEND_PICTURE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BUFF,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GAME_MISSION_PREPARE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_PREPARE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.UPDATE_BOARD_STATE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BOARD_STATE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ADD_MAP_THING:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THING,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.BARRIER_INFO:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.BARRIER_INFO,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GAME_CREATE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_CREATE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.START_GAME:
                  if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.selfRoomPlayer.progress >= 100)
                  {
                     event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_START,this._pkgVec[this._cmdID]);
                  }
                  break;
               case CrazyTankPackageType.WANNA_LEADER:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WANNA_LEADER,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GAME_LOAD:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_LOAD,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GAME_MISSION_INFO:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_INFO,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GAME_OVER:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_OVER,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.MISSION_OVE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.MISSION_OVE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GAME_ALL_MISSION_OVER:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.DIRECTION:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.DIRECTION_CHANGED,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GUN_ROTATION:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_GUN_ANGLE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.FIRE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SYNC_LIFETIME:
                  if(QueueManager._waitlist.length <= 0)
                  {
                     QueueManager.setLifeTime(this._pkgVec[this._cmdID].readInt());
                     ++this._cmdID;
                  }
                  break;
               case CrazyTankPackageType.MOVESTART:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_START_MOVE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.MOVESTOP:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STOP_MOVE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.TURN:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_CHANGE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.HEALTH:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BLOOD,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.FROST:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FROST,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.NONOLE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_NONOLE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.CHANGE_STATE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_STATE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PLAYER_PROPERTY:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROPERTY,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.INVINCIBLY:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_INVINCIBLY,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.VANE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_VANE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.HIDE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_HIDE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.CARRY:
                  ++this._cmdID;
                  break;
               case CrazyTankPackageType.BECKON:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BECKON,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.FIGHTPROP:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FIGHT_PROP,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.STUNT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STUNT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PROP:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROP,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.DANDER:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_DANDER,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.REDUCE_DANDER:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.REDUCE_DANDER,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LOAD:
                  ++this._cmdID;
                  break;
               case CrazyTankPackageType.ADDATTACK:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDATTACK,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ADDBALL:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDBAL,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SHOOTSTRAIGHT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOOTSTRAIGHT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SUICIDE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SUICIDE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.FIRE_TAG:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.CHANGE_BALL:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_BALL,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PICK:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PICK_BOX,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.BLAST:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOMB_DIE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.BEAT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BEAT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.DISAPPEAR:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOX_DISAPPEAR,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.TAKE_CARD:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_OUT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ADD_LIVING:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_LIVING,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PLAY_MOVIE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_MOVIE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PLAY_SOUND:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_SOUND,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LOAD_RESOURCE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ADD_MAP_THINGS:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THINGS,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LIVING_BEAT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BEAT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LIVING_FALLING:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_FALLING,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LIVING_JUMP:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_JUMP,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LIVING_MOVETO:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_MOVETO,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LIVING_SAY:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SAY,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LIVING_RANGEATTACKING:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_RANGEATTACKING,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SHOW_CARDS:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_CARDS,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.FOCUS_ON_OBJECT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FOCUS_ON_OBJECT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GAME_MISSION_TRY_AGAIN:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PLAY_INFO_IN_GAME:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_INFO_IN_GAME,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GAME_ROOM_INFO:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_INFO,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ADD_TIP_LAYER:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_TIP_LAYER,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PLAY_ASIDE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_ASIDE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.FORBID_DRAG:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FORBID_DRAG,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.TOP_LAYER:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.TOP_LAYER,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.CONTROL_BGM:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTROL_BGM,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.USE_DEPUTY_WEAPON:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_LIB_INFO_CHANGE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.POPUP_QUESTION_FRAME:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PASS_STORY:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_PASS_STORY_BTN,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LIVING_BOLTMOVE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BOLTMOVE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.CHANGE_TARGET:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_TARGET,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LIVING_SHOW_BLOOD:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SHOW_BLOOD,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.TEMP_STYLE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.TEMP_STYLE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ACTION_MAPPING:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTION_MAPPING,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.FIGHT_ACHIEVEMENT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.APPLYSKILL:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.APPLYSKILL,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.REMOVESKILL:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.REMOVESKILL,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.MAXFORCE_CHANGED:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGEMAXFORCE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.WIND_PIC:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WINDPIC,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SYSMESSAGE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAMESYSMESSAGE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.LIVING_CHAGEANGLE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_CHAGEANGLE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PET_SKILL:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_PET_SKILL,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PET_BUFF:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BUFF,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PET_BEAT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BEAT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PET_SKILL_CD:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_SKILL_CD,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ADD_NEW_PLAYER:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_NEW_PLAYER,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ADD_TERRACE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_TERRACE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.WISHOFDD:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHOFDD,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.PICK_BOX:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PICK_BOX,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SELECT_OBJECT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SELECT_OBJECT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.COLOR_CHANGE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_IN_COLOR_CHANGE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.GAME_TRUSTEESHIP:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TRUSTEESHIP,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SINGLEBATTLE_STARTMATCH:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SINGLEBATTLE_STARTMATCH,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.REVIVE:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_REVIVE,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.FIGHT_STATUS:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_STATUS,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SKIPNEXT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SKIPNEXT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.CLEAR_DEBUFF:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CLEAR_DEBUFF,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ADD_ANIMATION:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_ANIMATION,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.SINGBATTLE_FORCED_EXIT:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SINGBATTLE_FORCED_EXIT,this._pkgVec[this._cmdID]);
                  break;
               case CrazyTankPackageType.ROUND_ONE_END:
                  event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ROUND_ONE_END,this._pkgVec[this._cmdID]);
                  break;
               default:
                  ++this._cmdID;
            }
            if(Boolean(event))
            {
               QueueManager.addQueue(event);
               ++this._cmdID;
            }
         }
         else
         {
            this.reset();
         }
      }
      
      public function reset() : void
      {
         this._frameSprite.removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         this._cmdVec.length = 0;
         this._pkgVec.length = 0;
         this._cmdID = 0;
      }
      
      public function onShow() : void
      {
         if(!this._frame)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createBombKingFrame);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.BOMB_KING);
         }
         else
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("bombKing.BombKingMainFrame");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function onSmallLoadingClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createBombKingFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      protected function onUIProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.BOMB_KING)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function createBombKingFrame(event:UIModuleEvent) : void
      {
         if(event.module != UIModuleTypes.BOMB_KING)
         {
            return;
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createBombKingFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         this._frame = ComponentFactory.Instance.creatComponentByStylename("bombKing.BombKingMainFrame");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function get frame() : BombKingMainFrame
      {
         return this._frame;
      }
      
      public function set frame(value:BombKingMainFrame) : void
      {
         this._frame = value;
      }
      
      public function get defaultFlag() : Boolean
      {
         return this._defaultFlag;
      }
   }
}

