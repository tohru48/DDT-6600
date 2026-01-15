package kingBless
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kingBless.view.KingBlessMainFrame;
   import road7th.comm.PackageIn;
   
   public class KingBlessManager extends EventDispatcher
   {
      
      private static var _instance:KingBlessManager;
      
      public static const UPDATE_BUFF_DATA_EVENT:String = "update_buff_data_event";
      
      public static const UPDATE_MAIN_EVENT:String = "update_main_event";
      
      public static const STRENGTH_ENCHANCE:int = 1;
      
      public static const PET_REFRESH:int = 2;
      
      public static const BEAD_MASTER:int = 3;
      
      public static const HELP_STRAW:int = 4;
      
      public static const DUNGEON_HERO:int = 5;
      
      public static const TASK_SPIRIT:int = 6;
      
      public static const TIME_DEITY:int = 7;
      
      private var _openType:int;
      
      private var _endTime:Date;
      
      private var _buffData:Object;
      
      private var _timer:Timer;
      
      private var _count:int;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _isChecked:Boolean = false;
      
      private var _confirmFrame:BaseAlerFrame;
      
      public function KingBlessManager()
      {
         super(null);
      }
      
      public static function get instance() : KingBlessManager
      {
         if(_instance == null)
         {
            _instance = new KingBlessManager();
         }
         return _instance;
      }
      
      public function get openType() : int
      {
         return this._openType;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.KING_BLESS_MAIN,this.updateAllData);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.KING_BLESS_UPDATE_BUFF_DATA,this.updateBuffData);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
      }
      
      public function clearConfirmFrame() : void
      {
         if(Boolean(this._confirmFrame))
         {
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmOneDay);
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmDue);
            ObjectUtils.disposeObject(this._confirmFrame);
         }
         this._confirmFrame = null;
      }
      
      public function checkShowDueAlert() : void
      {
         if(this._isChecked)
         {
            return;
         }
         this._isChecked = true;
         var selfInfo:SelfInfo = PlayerManager.Instance.Self;
         if(selfInfo.Grade < 10 || selfInfo.isSameDay)
         {
            return;
         }
         if(!this._endTime)
         {
            return;
         }
         if(this._openType > 0 && this._endTime.getTime() - TimeManager.Instance.Now().getTime() < TimeManager.DAY_TICKS)
         {
            this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.kingBless.oneDayTipTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            this._confirmFrame.moveEnable = false;
            this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmOneDay);
         }
         else if(this._openType == 0 && selfInfo.LastDate.valueOf() < this._endTime.valueOf())
         {
            this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.kingBless.dueTipTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            this._confirmFrame.moveEnable = false;
            this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmDue);
         }
      }
      
      private function __confirmOneDay(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmOneDay);
         this._confirmFrame = null;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.loadKingBlessModule(this.doOpenKingBlessFrame);
         }
      }
      
      private function __confirmDue(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmDue);
         this._confirmFrame = null;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.loadKingBlessModule(this.doOpenKingBlessFrame);
         }
      }
      
      public function doOpenKingBlessFrame() : void
      {
         var frame:KingBlessMainFrame = ComponentFactory.Instance.creatComponentByStylename("KingBlessMainFrame");
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function getRemainTimeTxt() : Object
      {
         var obj:Object = null;
         var restHelpStraw:int = 0;
         var timeTxtStr:String = null;
         var endTimestamp:Number = Number(this._endTime.getTime());
         var nowTimestamp:Number = Number(TimeManager.Instance.Now().getTime());
         var differ:Number = endTimestamp - nowTimestamp;
         if(this._openType == 0 || differ < 1000)
         {
            obj = new Object();
            obj.isOpen = false;
            obj.content = LanguageMgr.GetTranslation("ddt.kingBlessFrame.noOpenIconBtnTipTxt");
            return obj;
         }
         var stateTipStr:String = LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardNameStateTxt") + "\r";
         var strengthTipStr:String = LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardNameTxt5") + "\r";
         var petTipStr:String = LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardNameTxt1",this.getOneBuffData(PET_REFRESH)) + "\r";
         var beadTipStr:String = LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardNameTxt2",this.getOneBuffData(BEAD_MASTER)) + "\r";
         var tmpHelpStraw:int = this.getOneBuffData(HELP_STRAW);
         var tmpBuffInfo:BuffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.Save_Life] as BuffInfo;
         if(Boolean(tmpBuffInfo))
         {
            restHelpStraw = tmpBuffInfo.ValidCount > tmpHelpStraw ? tmpHelpStraw : tmpBuffInfo.ValidCount;
         }
         else
         {
            restHelpStraw = 0;
         }
         var helpTipStr:String = LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardNameTxt3",restHelpStraw) + "\r";
         var dungeonTipStr:String = LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardNameTxt4",this.getOneBuffData(DUNGEON_HERO)) + "\r";
         var taskSpiritTipStr:String = LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardNameTxt6") + "\r";
         var sumStr:String = petTipStr + beadTipStr + helpTipStr + dungeonTipStr + strengthTipStr + taskSpiritTipStr;
         var count:int = 0;
         if(differ / TimeManager.DAY_TICKS > 1)
         {
            count = differ / TimeManager.DAY_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("day");
         }
         else if(differ / TimeManager.HOUR_TICKS > 1)
         {
            count = differ / TimeManager.HOUR_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("hour");
         }
         else if(differ / TimeManager.Minute_TICKS > 1)
         {
            count = differ / TimeManager.Minute_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("minute");
         }
         else
         {
            count = differ / TimeManager.Second_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("second");
         }
         obj = new Object();
         obj.isOpen = true;
         obj.isSelf = true;
         obj.title = stateTipStr;
         obj.content = sumStr;
         obj.bottom = LanguageMgr.GetTranslation("ddt.kingBlessFrame.remainTimeTxt") + timeTxtStr;
         return obj;
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         --this._count;
         if(this._count <= 0)
         {
            this._openType = 0;
            this._timer.stop();
            this.helpStrawShowHandler();
            dispatchEvent(new Event(UPDATE_MAIN_EVENT));
         }
      }
      
      private function updateAllData(event:CrazyTankSocketEvent) : void
      {
         var count:int = 0;
         var i:int = 0;
         var tmpkey:int = 0;
         var pkg:PackageIn = event.pkg;
         this._openType = pkg.readInt();
         this._endTime = pkg.readDate();
         if(this._openType > 0)
         {
            count = pkg.readInt();
            this._buffData = {};
            for(i = 0; i < count; i++)
            {
               tmpkey = pkg.readInt();
               this._buffData[tmpkey] = pkg.readInt();
            }
            this._count = int((this._endTime.getTime() - TimeManager.Instance.Now().getTime()) / 1000);
            if(this._count > 0)
            {
               this._timer.reset();
               this._timer.start();
            }
         }
         else
         {
            this._buffData = null;
         }
         this.helpStrawShowHandler();
         dispatchEvent(new Event(UPDATE_MAIN_EVENT));
      }
      
      private function helpStrawShowHandler() : void
      {
         var buffInfo:BuffInfo = PlayerManager.Instance.Self.getBuff(BuffInfo.Save_Life);
         if(Boolean(buffInfo))
         {
            buffInfo.additionCount = this.getOneBuffData(HELP_STRAW);
         }
      }
      
      private function updateBuffData(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var tmpkey:int = pkg.readInt();
         this._buffData[tmpkey] = pkg.readInt();
         dispatchEvent(new Event(UPDATE_BUFF_DATA_EVENT));
      }
      
      public function getOneBuffData(type:int) : int
      {
         if(this._openType > 0 && Boolean(this._buffData))
         {
            return this._buffData[type];
         }
         return 0;
      }
      
      public function loadKingBlessModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.KING_BLESS);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.KING_BLESS)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.KING_BLESS)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
   }
}

