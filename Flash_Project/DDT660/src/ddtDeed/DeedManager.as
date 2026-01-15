package ddtDeed
{
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class DeedManager extends EventDispatcher
   {
      
      private static var _instance:DeedManager;
      
      public static const UPDATE_BUFF_DATA_EVENT:String = "update_buff_data_event";
      
      public static const UPDATE_MAIN_EVENT:String = "update_main_event";
      
      public static const PET_GRANT:int = 10;
      
      public static const PET_STAR:int = 11;
      
      public static const HORSE_LIGHT:int = 12;
      
      public static const HORSE_ANGER:int = 13;
      
      private var _openType:int;
      
      private var _endTime:Date;
      
      private var _buffData:Object;
      
      private var _timer:Timer;
      
      private var _count:int;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _isChecked:Boolean = false;
      
      private var _confirmFrame:BaseAlerFrame;
      
      public function DeedManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : DeedManager
      {
         if(_instance == null)
         {
            _instance = new DeedManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DEED_MAIN,this.updateAllData);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DEED_UPDATE_BUFF_DATA,this.updateBuffData);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
      }
      
      public function getRemainTimeTxt() : Object
      {
         var obj:Object = null;
         var stateTipStr:String = null;
         var petGrantTipStr:String = null;
         var petStarStr:String = null;
         var horseLightTipStr:String = null;
         var horseAngerTipStr:String = null;
         var bottomStr:String = null;
         if(this.isOpen)
         {
            stateTipStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameStateTxt") + "\r";
            petGrantTipStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameTxt1",this.getOneBuffData(PET_GRANT)) + "\r";
            petStarStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameTxt2",this.getOneBuffData(PET_STAR)) + "\r";
            horseLightTipStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameTxt3",this.getOneBuffData(HORSE_LIGHT)) + "\r";
            horseAngerTipStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameTxt4",this.getOneBuffData(HORSE_ANGER)) + "\r";
            bottomStr = LanguageMgr.GetTranslation("ddt.deedFrame.remainTimeTxt") + this.deedTimeStr;
         }
         else
         {
            stateTipStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameStateTxt2") + "\r";
            petGrantTipStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameTxt1",1) + "\r";
            petStarStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameTxt2",1) + "\r";
            horseLightTipStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameTxt3",1) + "\r";
            horseAngerTipStr = LanguageMgr.GetTranslation("ddt.deedFrame.awardNameTxt4",1) + "\r";
            bottomStr = LanguageMgr.GetTranslation("ddt.deedFrame.remainTimeTxt") + 7 + LanguageMgr.GetTranslation("day");
         }
         var sumStr:String = petGrantTipStr + petStarStr + horseLightTipStr + horseAngerTipStr;
         obj = new Object();
         obj.isOpen = true;
         obj.isSelf = true;
         obj.title = stateTipStr;
         obj.content = sumStr;
         obj.bottom = bottomStr;
         return obj;
      }
      
      public function get isOpen() : Boolean
      {
         if(this._endTime == null)
         {
            this._endTime = TimeManager.Instance.Now();
         }
         var differ:Number = this._endTime.getTime() - TimeManager.Instance.Now().getTime();
         if(this._openType == 0 || differ < 1000)
         {
            return false;
         }
         return true;
      }
      
      public function get deedTimeStr() : String
      {
         var timeTxtStr:String = null;
         if(this._endTime == null)
         {
            this._endTime = TimeManager.Instance.Now();
         }
         var endTimestamp:Number = Number(this._endTime.getTime());
         var nowTimestamp:Number = Number(TimeManager.Instance.Now().getTime());
         var differ:Number = endTimestamp - nowTimestamp;
         var count:int = 0;
         if(differ / TimeManager.DAY_TICKS > 1)
         {
            count = differ / TimeManager.DAY_TICKS;
            if(count < 0)
            {
               count = 0;
            }
            timeTxtStr = count + LanguageMgr.GetTranslation("day");
         }
         else if(differ / TimeManager.HOUR_TICKS > 1)
         {
            count = differ / TimeManager.HOUR_TICKS;
            if(count < 0)
            {
               count = 0;
            }
            timeTxtStr = count + LanguageMgr.GetTranslation("hour");
         }
         else if(differ / TimeManager.Minute_TICKS > 1)
         {
            count = differ / TimeManager.Minute_TICKS;
            if(count < 0)
            {
               count = 0;
            }
            timeTxtStr = count + LanguageMgr.GetTranslation("minute");
         }
         else
         {
            count = differ / TimeManager.Second_TICKS;
            if(count < 0)
            {
               count = 0;
            }
            timeTxtStr = count + LanguageMgr.GetTranslation("second");
         }
         return timeTxtStr;
      }
      
      public function getOneBuffData(type:int) : int
      {
         if(this._openType > 0 && Boolean(this._buffData))
         {
            return this._buffData[type];
         }
         return 0;
      }
      
      public function get openType() : int
      {
         return this._openType;
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
         dispatchEvent(new Event(UPDATE_MAIN_EVENT));
      }
      
      private function updateBuffData(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var tmpkey:int = pkg.readInt();
         this._buffData[tmpkey] = pkg.readInt();
         dispatchEvent(new Event(UPDATE_BUFF_DATA_EVENT));
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         --this._count;
         if(this._count <= 0)
         {
            this._openType = 0;
            this._timer.stop();
            dispatchEvent(new Event(UPDATE_MAIN_EVENT));
         }
      }
   }
}

