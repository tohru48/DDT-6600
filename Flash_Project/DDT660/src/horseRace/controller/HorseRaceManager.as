package horseRace.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import horseRace.data.HorseRacePackageType;
   import horseRace.events.HorseRaceEvents;
   import horseRace.view.HorseRaceMatchView;
   import horseRace.view.HorseRaceView;
   import road7th.comm.PackageIn;
   
   public class HorseRaceManager extends EventDispatcher
   {
      
      private static var _instance:HorseRaceManager;
      
      public static var loadComplete:Boolean = false;
      
      private var _isShowIcon:Boolean;
      
      private var _matchView:HorseRaceMatchView;
      
      public var showBuyCountFram:Boolean = true;
      
      public var showPingzhangBuyFram:Boolean = true;
      
      private var _horseRaceView:HorseRaceView;
      
      public var horseRaceCanRaceTime:int = 0;
      
      public var itemInfoList:Array;
      
      public var buffCD:int;
      
      public function HorseRaceManager()
      {
         super();
      }
      
      public static function get Instance() : HorseRaceManager
      {
         if(_instance == null)
         {
            _instance = new HorseRaceManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HORSERACE_OPEN_CLOSE,this._open_close);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HORSERACE_CMD,this.pkgHandler);
      }
      
      public function templateDataSetup(dataList:Array) : void
      {
         this.itemInfoList = dataList;
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var type:int = pkg.readByte();
         switch(type)
         {
            case HorseRacePackageType.HORSERACE_INITPLAYER:
               this.initPlayerData(pkg);
               break;
            case HorseRacePackageType.HORSERACE_UPDATECOUNT:
               this.updateCount(pkg);
               break;
            case HorseRacePackageType.HORSERACE_START_FIVE:
               this.startFiveCountDown(pkg);
               break;
            case HorseRacePackageType.HORSERACE_BEGIN_RACE:
               this.beginRace(pkg);
               break;
            case HorseRacePackageType.HORSERACE_PLAYERSPEED_CHANGE:
               this.playerSpeedChange(pkg);
               break;
            case HorseRacePackageType.HORSERACE_RACE_END:
               this.playerRaceEnd(pkg);
               break;
            case HorseRacePackageType.HORSERACE_ALLPLAYER_RACEEND:
               this.allPlayerRaceEnd(pkg);
               break;
            case HorseRacePackageType.HORSERACE_SYN_ONESECOND:
               this.syn_onesecond(pkg);
               break;
            case HorseRacePackageType.HORSERACE_BUFF_ITEMFLUSH:
               this.flush_buffItem(pkg);
               break;
            case HorseRacePackageType.HORSERACE_SHOW_MSG:
               this.show_msg(pkg);
         }
      }
      
      private function updateCount(pkg:PackageIn) : void
      {
         this.horseRaceCanRaceTime = pkg.readInt();
         if(Boolean(this._matchView))
         {
            this._matchView.reflushHorseRaceTime();
         }
      }
      
      private function show_msg(pkg:PackageIn) : void
      {
         dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_SHOW_MSG,pkg));
      }
      
      private function flush_buffItem(pkg:PackageIn) : void
      {
         dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_BUFF_ITEMFLUSH,pkg));
      }
      
      private function syn_onesecond(pkg:PackageIn) : void
      {
         dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_SYN_ONESECOND,pkg));
      }
      
      private function allPlayerRaceEnd(pkg:PackageIn) : void
      {
         dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_ALLPLAYER_RACEEND,pkg));
      }
      
      private function initPlayerData(pkg:PackageIn) : void
      {
         this._matchView.dispose2();
         this.showRaceView();
         dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_INITPLAYER,pkg));
      }
      
      private function startFiveCountDown(pkg:PackageIn) : void
      {
         dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_START_FIVE,pkg));
      }
      
      private function beginRace(pkg:PackageIn) : void
      {
         dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_BEGIN_RACE,pkg));
      }
      
      private function playerSpeedChange(pkg:PackageIn) : void
      {
         dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_PLAYERSPEED_CHANGE,pkg));
      }
      
      private function playerRaceEnd(pkg:PackageIn) : void
      {
         dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_RACE_END,pkg));
      }
      
      private function _open_close(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = event._cmd;
         switch(cmd)
         {
            case HorseRacePackageType.HORSERACE_OPEN_CLOSE:
               this.openOrclose(pkg);
         }
      }
      
      public function get isShowIcon() : Boolean
      {
         return this._isShowIcon;
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         this._isShowIcon = pkg.readBoolean();
         if(this._isShowIcon)
         {
            this.addEnterIcon();
         }
         else
         {
            this.disposeEnterIcon();
            if(Boolean(this._matchView))
            {
               this._matchView.dispose();
            }
            LayerManager.Instance.clearnGameDynamic();
         }
      }
      
      public function enterView() : void
      {
         if(loadComplete)
         {
            this.showMatchView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.HORSERACE);
         }
      }
      
      private function showMatchView() : void
      {
         this._matchView = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.matchView");
         LayerManager.Instance.addToLayer(this._matchView,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function showRaceView() : void
      {
         this._horseRaceView = new HorseRaceView();
         LayerManager.Instance.addToLayer(this._horseRaceView,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
      }
      
      public function addEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.HORSERACE,true);
         var chatData:ChatData = new ChatData();
         chatData.channel = ChatInputView.COMPLEX_NOTICE;
         chatData.childChannelArr = [ChatInputView.SYS_TIP,ChatInputView.GM_NOTICE];
         chatData.type = ChatFormats.HORESRACE;
         chatData.msg = LanguageMgr.GetTranslation("horseRace.sysOpentxt");
         ChatManager.Instance.chat(chatData);
      }
      
      private function disposeEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.HORSERACE,false);
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TREASURE_LOST)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __completeShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.HORSERACE)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            this.showMatchView();
         }
      }
   }
}

