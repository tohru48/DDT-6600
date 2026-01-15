package itemActivityGift
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import itemActivityGift.data.ItemEveryDayRecordData;
   import itemActivityGift.model.ItemActivityGiftModel;
   import road7th.comm.PackageIn;
   
   public class ItemActivityGiftManager extends EventDispatcher
   {
      
      private static var _instance:ItemActivityGiftManager;
      
      private var _model:ItemActivityGiftModel;
      
      private var frameObj:Object;
      
      private var frameType:int;
      
      private var tipsFrame:BaseAlerFrame;
      
      public function ItemActivityGiftManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : ItemActivityGiftManager
      {
         if(_instance == null)
         {
            _instance = new ItemActivityGiftManager();
         }
         return _instance;
      }
      
      public function get model() : ItemActivityGiftModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._model = new ItemActivityGiftModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEMACTIVITYGIFT_DATA,this.__itemActivityGiftDataHandler);
      }
      
      private function __itemActivityGiftDataHandler(event:CrazyTankSocketEvent) : void
      {
         var cmd:int = event.pkg.readInt();
         if(cmd == ItemActivityGiftType.EVERYDAYGIFTRECORD)
         {
            this.everyDayGiftRecordDataHandler(event.pkg);
         }
      }
      
      private function everyDayGiftRecordDataHandler(pkg:PackageIn) : void
      {
         var dataInfo:ItemEveryDayRecordData = null;
         var dataDic:Dictionary = new Dictionary();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            dataInfo = new ItemEveryDayRecordData();
            dataInfo.UserID = pkg.readInt();
            dataInfo.TemplateID = pkg.readInt();
            dataInfo.ItemID = pkg.readInt();
            dataInfo.OpenTime = pkg.readDate();
            dataInfo.OpenIndex = pkg.readInt();
            dataDic[dataInfo.TemplateID + "," + dataInfo.ItemID] = dataInfo;
         }
         this.model.itemEveryDayRecord = dataDic;
      }
      
      public function showFrame($frameType:int, $frameObj:Object = null) : void
      {
         var tempItemInfo:InventoryItemInfo = null;
         var itemEveryDayRecordData:ItemEveryDayRecordData = null;
         var tempIndex:int = 0;
         var tempStr:String = null;
         var tempArr:Array = null;
         var paramStr:String = null;
         var currentTime:Date = null;
         this.frameType = $frameType;
         this.frameObj = $frameObj;
         if(this.frameType == ItemActivityGiftType.EVERYDAYGIFTRECORD)
         {
            tempItemInfo = this.frameObj as InventoryItemInfo;
            itemEveryDayRecordData = ItemActivityGiftManager.instance.model.itemEveryDayRecord[tempItemInfo.TemplateID + "," + tempItemInfo.ItemID];
            tempIndex = 0;
            if(Boolean(itemEveryDayRecordData))
            {
               tempIndex = itemEveryDayRecordData.OpenIndex;
            }
            else
            {
               tempIndex = 0;
            }
            if(tempIndex > 0)
            {
               currentTime = TimeManager.Instance.Now();
               if(currentTime.getFullYear() == itemEveryDayRecordData.OpenTime.getFullYear() && currentTime.getMonth() == itemEveryDayRecordData.OpenTime.getMonth() && currentTime.getDay() == itemEveryDayRecordData.OpenTime.getDay())
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("itemActivityGift.frame.stepGiftLimit"));
                  return;
               }
            }
            tempStr = ServerConfigManager.instance.getEveryDayOpenPrice[tempIndex];
            tempArr = tempStr.split(",");
            paramStr = "";
            if(tempArr[0] == -300)
            {
               paramStr = tempArr[1] + " " + LanguageMgr.GetTranslation("ddtMoney");
            }
            else if(tempArr[0] == -200)
            {
               paramStr = tempArr[1] + " " + LanguageMgr.GetTranslation("money");
            }
            this.tipsFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("itemActivityGift.frame.everyDayGiftRecordTxt",tempIndex + 1,paramStr),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
            this.tipsFrame.addEventListener(FrameEvent.RESPONSE,this.__onFrameResponse);
         }
      }
      
      private function __onFrameResponse(evt:FrameEvent) : void
      {
         var tempItemInfo:InventoryItemInfo = null;
         var itemEveryDayRecordData:ItemEveryDayRecordData = null;
         var tempIndex:int = 0;
         var tempStr:String = null;
         var tempArr:Array = null;
         SoundManager.instance.play("008");
         this.tipsDispose();
         switch(this.frameType)
         {
            case ItemActivityGiftType.EVERYDAYGIFTRECORD:
               if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  tempItemInfo = this.frameObj as InventoryItemInfo;
                  itemEveryDayRecordData = ItemActivityGiftManager.instance.model.itemEveryDayRecord[tempItemInfo.TemplateID + "," + tempItemInfo.ItemID];
                  tempIndex = 0;
                  if(Boolean(itemEveryDayRecordData))
                  {
                     tempIndex = itemEveryDayRecordData.OpenIndex;
                  }
                  else
                  {
                     tempIndex = 0;
                  }
                  tempStr = ServerConfigManager.instance.getEveryDayOpenPrice[tempIndex];
                  tempArr = tempStr.split(",");
                  if(tempArr[0] == -300 && PlayerManager.Instance.Self.BandMoney < tempArr[1])
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bindMoneyPoorNote"));
                  }
                  else if(tempArr[0] == -200 && PlayerManager.Instance.Self.Money < tempArr[1])
                  {
                     LeavePageManager.showFillFrame();
                  }
                  else
                  {
                     SocketManager.Instance.out.sendUseEveryDayGiftRecord(tempItemInfo.TemplateID,tempItemInfo.ItemID,tempIndex + 1);
                  }
               }
         }
      }
      
      private function tipsDispose() : void
      {
         if(Boolean(this.tipsFrame))
         {
            this.tipsFrame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameResponse);
            ObjectUtils.disposeAllChildren(this.tipsFrame);
            ObjectUtils.disposeObject(this.tipsFrame);
            this.tipsFrame = null;
         }
      }
   }
}

