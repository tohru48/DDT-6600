package GodSyah
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   
   public class SyahManager extends EventDispatcher
   {
      
      private static var _syahManager:SyahManager;
      
      public const SYAHVIEW:String = "syahview";
      
      public const BAGANDOTHERS:String = "bagandothers";
      
      public const OTHERS:String = "others";
      
      public var totalDamage:int;
      
      public var totalArmor:int;
      
      private var _isOpen:Boolean = false;
      
      private var _syahItemVec:Vector.<SyahMode>;
      
      private var _valid:String;
      
      private var _description:String;
      
      private var _startTime:Date;
      
      private var _endTime:Date;
      
      private var _enableIndexs:Array;
      
      private var _earlyTime:Date;
      
      private var _isStart:Boolean;
      
      private var _timer:Timer;
      
      private var _login:Boolean;
      
      private var _cellItems:Vector.<InventoryItemInfo>;
      
      private var _cellItemsArray:Array;
      
      private var _inView:Boolean;
      
      public function SyahManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get Instance() : SyahManager
      {
         if(_syahManager == null)
         {
            _syahManager = new SyahManager();
         }
         return _syahManager;
      }
      
      private function setup() : void
      {
         this._isOpen = true;
         this.showIcon();
      }
      
      public function stopSyah() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.SYAH,false);
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.SYAH,true);
      }
      
      public function showFrame() : void
      {
         SoundManager.instance.play("008");
         var _view:SyahView = new SyahView();
         _view.init();
         _view.x = -227;
         HallIconManager.instance.showCommonFrame(_view,"wonderfulActivityManager.btnTxt13");
      }
      
      public function godSyahLoaderCompleted(analyzer:SyahAnalyzer) : void
      {
         var j:int = 0;
         var arr:Array = analyzer.details;
         if(arr == null)
         {
            return;
         }
         var now:Date = analyzer.nowTime;
         this._earlyTime = arr[0][4];
         this._enableIndexs = null;
         this._enableIndexs = new Array();
         this._cellItemsArray = null;
         this._cellItemsArray = new Array();
         this._cellItems = null;
         this._cellItems = new Vector.<InventoryItemInfo>();
         this._syahItemVec = null;
         this._syahItemVec = new Vector.<SyahMode>();
         for(var i:int = 0; i < arr.length; i++)
         {
            this._startTime = arr[i][3];
            this._endTime = arr[i][4];
            if(this._earlyTime.time > this._startTime.time)
            {
               this._earlyTime = this._startTime;
               this._valid = arr[i][1];
               this._description = arr[i][2];
            }
            if(now.time >= this._startTime.time && now.time < this._endTime.time)
            {
               this._enableIndexs.push(i);
               this._cellItemsArray.push(analyzer.infos[i]);
               for(j = 0; j < analyzer.modes[i].length; j++)
               {
                  this._syahItemVec.push(analyzer.modes[i][j]);
               }
            }
         }
         if(this._enableIndexs.length > 0)
         {
            this.setup();
         }
      }
      
      private function __checkSyahValid(e:TimerEvent) : void
      {
         var now:Date = TimeManager.Instance.serverDate;
         if(this._isStart)
         {
            if(now.time > this._endTime.time)
            {
               this._timer.stop();
               this._timer.removeEventListener(TimerEvent.TIMER,this.__checkSyahValid);
               this._timer = null;
               this.stopSyah();
            }
         }
         else if(now.time >= this._startTime.time)
         {
            this.showIcon();
         }
      }
      
      public function selectFromBagAndInfo() : void
      {
         var j:int = 0;
         var now:Date = TimeManager.Instance.serverDate;
         var valid:Number = this._endTime.time - now.time;
         var arr:Array = PlayerManager.Instance.Self.Bag.items.list;
         for(var i:int = 0; i < this._syahItemVec.length; i++)
         {
            this._syahItemVec[i].isHold = false;
            this._syahItemVec[i].isValid = false;
            for(j = 0; j < arr.length; j++)
            {
               if(this._syahItemVec[i].level == -1 && this._syahItemVec[i].syahID == arr[j].TemplateID)
               {
                  this._syahItemVec[i].isHold = true;
                  if(arr[j].ValidDate == 0)
                  {
                     this._syahItemVec[i].isValid = true;
                  }
                  else if(arr[j].getRemainDate() * 24 * 60 * 60 * 1000 >= valid)
                  {
                     this._syahItemVec[i].isValid = true;
                  }
               }
               else if(this._syahItemVec[i].syahID == arr[j].TemplateID && this._syahItemVec[i].isGold == arr[j].isGold && this._syahItemVec[i].level == arr[j].StrengthenLevel)
               {
                  this._syahItemVec[i].isHold = true;
                  if(arr[j].ValidDate == 0)
                  {
                     this._syahItemVec[i].isValid = true;
                  }
                  else if(arr[j].getRemainDate() * 24 * 60 * 60 * 1000 >= valid)
                  {
                     this._syahItemVec[i].isValid = true;
                  }
               }
            }
         }
      }
      
      public function setModeValid(info:Object) : Boolean
      {
         var now:Date = TimeManager.Instance.serverDate;
         var valid:Number = this._endTime.time - now.time;
         if(info is InventoryItemInfo)
         {
            if(info.ValidDate == 0)
            {
               return true;
            }
            if(info.getRemainDate() * 24 * 60 * 60 * 1000 >= valid)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getSyahModeByInfo(info:ItemTemplateInfo) : SyahMode
      {
         for(var i:int = 0; i < this._syahItemVec.length; i++)
         {
            if(info is InventoryItemInfo)
            {
               if(this._syahItemVec[i].level == -1 && this._syahItemVec[i].syahID == info.TemplateID)
               {
                  return this._syahItemVec[i];
               }
               if(this._syahItemVec[i].syahID == info.TemplateID && this._syahItemVec[i].isGold == (info as InventoryItemInfo).isGold && this._syahItemVec[i].level == (info as InventoryItemInfo).StrengthenLevel)
               {
                  return this._syahItemVec[i];
               }
            }
            else if(this._syahItemVec[i].syahID == info.TemplateID)
            {
               return this._syahItemVec[i];
            }
         }
         return null;
      }
      
      public function getSyahModeByID(modeId:int) : SyahMode
      {
         for(var i:int = 0; i < this._syahItemVec.length; i++)
         {
            if(this._syahItemVec[i].syahID == modeId)
            {
               return this._syahItemVec[i];
            }
         }
         return null;
      }
      
      public function get syahItemVec() : Vector.<SyahMode>
      {
         return this._syahItemVec;
      }
      
      public function get valid() : String
      {
         return this._valid;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(value:Boolean) : void
      {
         this._isOpen = value;
      }
      
      public function get login() : Boolean
      {
         return this._login;
      }
      
      public function set login(value:Boolean) : void
      {
         this._login = value;
      }
      
      public function get isStart() : Boolean
      {
         return this._isStart;
      }
      
      public function get cellItems() : Vector.<InventoryItemInfo>
      {
         var j:int = 0;
         var cellItems:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         for(var i:int = 0; i < this._cellItemsArray.length; i++)
         {
            for(j = 0; j < this._cellItemsArray[i].length; j++)
            {
               cellItems.push(this._cellItemsArray[i][j]);
            }
         }
         return cellItems;
      }
      
      public function get inView() : Boolean
      {
         return this._inView;
      }
      
      public function set inView(value:Boolean) : void
      {
         this._inView = value;
      }
   }
}

