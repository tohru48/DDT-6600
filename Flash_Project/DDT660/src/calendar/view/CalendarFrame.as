package calendar.view
{
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.AwardsViewII;
   import ddt.view.bossbox.VipInfoTipBox;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mainbutton.MainButtnController;
   import road7th.data.DictionaryData;
   import vip.VipController;
   import vip.view.VipViewFrame;
   
   public class CalendarFrame extends Frame
   {
      
      private var _model:CalendarModel;
      
      private var _stateback:MovieImage;
      
      private var _currentState:ICalendar;
      
      private var _state:int;
      
      private var _activityList:ActivityList;
      
      private var _titlebitmap:Bitmap;
      
      private var _recentbitmap:Bitmap;
      
      private var _dateCombox:ComboBox;
      
      private var _vipInfoTipBox:VipInfoTipBox;
      
      private var awards:AwardsViewII;
      
      private var alertFrame:BaseAlerFrame;
      
      public function CalendarFrame(model:CalendarModel)
      {
         super();
         this._model = model;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._stateback = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.StateBg");
         addToContent(this._stateback);
         this._activityList = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityList",[this._model]);
         addToContent(this._activityList);
         this._recentbitmap = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityRecent");
         addToContent(this._recentbitmap);
         this._dateCombox = ComponentFactory.Instance.creatComponentByStylename("dateSelect.combox");
         var rec:Rectangle = ComponentFactory.Instance.creatCustomObject("dateSelect.comboxRec");
         ObjectUtils.copyPropertyByRectangle(this._dateCombox,rec);
         this._dateCombox.beginChanges();
         this._dateCombox.selctedPropName = "text";
         this._dateCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("ddt.today"));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(1));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(2));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(3));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(4));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(5));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(6));
         this._dateCombox.commitChanges();
         this._dateCombox.textField.text = LanguageMgr.GetTranslation("ddt.today");
         addToContent(this._dateCombox);
      }
      
      public function lookActivity(date:Date) : void
      {
      }
      
      private function getWeek(add:int) : String
      {
         var week:String = null;
         var isNext:Boolean = false;
         var today:Date = this._model.today;
         var date:Date = new Date(today.fullYearUTC,today.monthUTC,today.dateUTC + add);
         if(today.day > date.day)
         {
            if(date.day == 0)
            {
               isNext = false;
            }
            else
            {
               isNext = true;
            }
         }
         switch(date.day)
         {
            case 0:
               if(isNext)
               {
                  week = LanguageMgr.GetTranslation("ddt.weekNextSunday");
               }
               else
               {
                  week = LanguageMgr.GetTranslation("ddt.weekSunday");
               }
               break;
            case 1:
               if(isNext)
               {
                  week = LanguageMgr.GetTranslation("ddt.weekNextMonday");
               }
               else
               {
                  week = LanguageMgr.GetTranslation("ddt.weekMonday");
               }
               break;
            case 2:
               if(isNext)
               {
                  week = LanguageMgr.GetTranslation("ddt.weekNextTuesday");
               }
               else
               {
                  week = LanguageMgr.GetTranslation("ddt.weekTuesday");
               }
               break;
            case 3:
               if(isNext)
               {
                  week = LanguageMgr.GetTranslation("ddt.weekNextWednesday");
               }
               else
               {
                  week = LanguageMgr.GetTranslation("ddt.weekWednesday");
               }
               break;
            case 4:
               if(isNext)
               {
                  week = LanguageMgr.GetTranslation("ddt.weekNextThursday");
               }
               else
               {
                  week = LanguageMgr.GetTranslation("ddt.weekThursday");
               }
               break;
            case 5:
               if(isNext)
               {
                  week = LanguageMgr.GetTranslation("ddt.weekNextFriday");
               }
               else
               {
                  week = LanguageMgr.GetTranslation("ddt.weekFriday");
               }
               break;
            case 6:
               if(isNext)
               {
                  week = LanguageMgr.GetTranslation("ddt.weekNextSaturday");
               }
               else
               {
                  week = LanguageMgr.GetTranslation("ddt.weekSaturday");
               }
         }
         return week;
      }
      
      public function get activityList() : ActivityList
      {
         return this._activityList;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         addEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         this._dateCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this.__dateComboxChanged);
      }
      
      private function __dateComboxChanged(e:Event) : void
      {
         SoundManager.instance.play("008");
         var index:int = this._dateCombox.currentSelectedIndex;
         var today:Date = TimeManager.Instance.Now();
         var date:Date = new Date(today.fullYearUTC,today.monthUTC,today.dateUTC + index,today.hours,today.minutes,today.seconds);
         CalendarManager.getInstance().lookActivity(date);
      }
      
      private function __getAward(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CalendarManager.getInstance().reciveDayAward();
      }
      
      private function __vipOpen(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.showVipPackage();
      }
      
      private function showVipPackage() : void
      {
         var incream:int = 0;
         var date:Date = null;
         var nowDate:Date = null;
         if(PlayerManager.Instance.Self.canTakeVipReward || PlayerManager.Instance.Self.IsVIP == false)
         {
            if(VipController.loadComplete)
            {
               this._vipInfoTipBox = ComponentFactory.Instance.creat("vip.VipInfoTipFrame");
               this._vipInfoTipBox.escEnable = true;
               this._vipInfoTipBox.vipAwardGoodsList = this.getVIPInfoTip(BossBoxManager.instance.inventoryItemList);
               this._vipInfoTipBox.addEventListener(FrameEvent.RESPONSE,this.__responseVipInfoTipHandler);
               LayerManager.Instance.addToLayer(this._vipInfoTipBox,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            }
            else if(VipController.useFirst)
            {
               UIModuleSmallLoading.Instance.progress = 0;
               UIModuleSmallLoading.Instance.show();
               UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
               UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
               VipController.useFirst = false;
            }
         }
         else
         {
            incream = 0;
            date = PlayerManager.Instance.Self.systemDate as Date;
            nowDate = new Date();
            this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.vip.vipView.cueDateScript",nowDate.month + 1,nowDate.date + 1),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alertFrame.moveEnable = false;
            this.alertFrame.addEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         }
      }
      
      private function __alertHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         if(Boolean(this.alertFrame) && Boolean(this.alertFrame.parent))
         {
            this.alertFrame.parent.removeChild(this.alertFrame);
         }
         if(Boolean(this.alertFrame))
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
      }
      
      private function __responseVipInfoTipHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._vipInfoTipBox.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
               break;
            case FrameEvent.ENTER_CLICK:
               MainButtnController.instance.VipAwardState = false;
               MainButtnController.instance.dispatchEvent(new Event(MainButtnController.ICONCLOSE));
               this.showAwards(this._vipInfoTipBox.selectCellInfo);
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
         }
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.awards.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.awards.dispose();
               this.awards = null;
         }
      }
      
      private function showAwards(para:ItemTemplateInfo) : void
      {
         this.awards = ComponentFactory.Instance.creat("vip.awardFrame");
         this.awards.escEnable = true;
         this.awards.boxType = 2;
         this.awards.vipAwardGoodsList = this._getStrArr(BossBoxManager.instance.inventoryItemList);
         this.awards.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.awards.addEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         LayerManager.Instance.addToLayer(this.awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __sendReward(event:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDailyAward(3);
         this.awards.removeEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.dispose();
         PlayerManager.Instance.Self.canTakeVipReward = false;
      }
      
      private function getVIPInfoTip(dic:DictionaryData) : Array
      {
         var resultGoodsArray:Array = null;
         return PlayerManager.Instance.Self.VIPLevel == 12 ? [ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 2])),ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]))] : [ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1])),ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel]))];
      }
      
      private function _getStrArr(dic:DictionaryData) : Array
      {
         return dic[VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]];
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            VipController.loadComplete = true;
            this.showVipPackage();
         }
      }
      
      private function __getFocus(evt:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         StageReferance.stage.focus = this;
      }
      
      private function __response(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               CalendarManager.getInstance().close();
               this.dispose();
         }
      }
      
      private function __signCountChanged(event:Event) : void
      {
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
      }
      
      public function setState(data:* = null) : void
      {
         if(this._state != data)
         {
            this._state = data;
            ObjectUtils.disposeObject(this._currentState);
            this._currentState = null;
            this._currentState = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityState",[this._model]);
            addToContent(this._currentState as DisplayObject);
         }
         if(Boolean(this._currentState))
         {
            this._currentState.setData(data);
         }
      }
      
      public function showByQQ(activeID:int) : void
      {
         this._activityList.showByQQ(activeID);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._stateback);
         this._stateback = null;
         ObjectUtils.disposeObject(this._activityList);
         this._activityList = null;
         ObjectUtils.disposeObject(this._currentState);
         this._currentState = null;
         ObjectUtils.disposeObject(this._titlebitmap);
         this._titlebitmap = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

