package carnivalActivity.view
{
   import baglocked.BaglockedManager;
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class CarnivalActivityView extends Sprite implements IRightView
   {
      
      private var _bg:Bitmap;
      
      private var _titleBg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _closeTimeTxt:FilterFrameText;
      
      private var _timeTxt:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _sumTime:Number = 0;
      
      private var _sumTimeStr:String;
      
      private var _actTxt:FilterFrameText;
      
      private var _actTimeTxt:FilterFrameText;
      
      private var _getTxt:FilterFrameText;
      
      private var _getTimeTxt:FilterFrameText;
      
      private var _descSp:Sprite;
      
      private var _descTxt:FilterFrameText;
      
      private var _allDescBg:ScaleBitmapImage;
      
      private var _allDescTxt:FilterFrameText;
      
      private var _buyBg:Bitmap;
      
      private var _priceTxt:FilterFrameText;
      
      private var _buyCountTxt:FilterFrameText;
      
      private var _dailyBuyBg:Bitmap;
      
      private var _buyBtn:TextButton;
      
      private var _gift:CarnivalActivityGift;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _vBox:VBox;
      
      private var _type:int;
      
      private var _childType:int;
      
      private var _item:GmActivityInfo;
      
      private var _buyGiftItem:GmActivityInfo;
      
      private var _buyGiftCurInfo:GiftCurInfo;
      
      private var _buyCount:int;
      
      private var _hasBuyGift:Boolean = false;
      
      private var _buyGiftLimitType:int;
      
      private var _buyGiftLimitCount:int;
      
      private var _buyGiftType:int;
      
      private var _buyGiftPrice:int;
      
      private var _buyGiftActId:String = "";
      
      private var _giftInfoVec:Vector.<GiftBagInfo>;
      
      private var _infoVec:Vector.<GmActivityInfo>;
      
      private var _itemVec:Vector.<CarnivalActivityItem> = new Vector.<CarnivalActivityItem>();
      
      public function CarnivalActivityView(type:int, childType:int = 0)
      {
         this._type = type;
         this._childType = childType;
         super();
      }
      
      public function init() : void
      {
         this.initData();
         if(this._item == null)
         {
            return;
         }
         this.initView();
         this.initEvent();
         this.updateTime();
      }
      
      private function initData() : void
      {
         var item:GmActivityInfo = null;
         var k:int = 0;
         var giftItem:GmActivityInfo = null;
         var i:int = 0;
         var j:int = 0;
         this._giftInfoVec = new Vector.<GiftBagInfo>();
         this._infoVec = new Vector.<GmActivityInfo>();
         for each(item in WonderfulActivityManager.Instance.activityData)
         {
            if(item.activityType == this._type && item.activityType == WonderfulActivityTypeData.DAILY_GIFT)
            {
               this.initItem(item);
            }
            else if(this._childType == WonderfulActivityTypeData.CARNIVAL_ROOKIE && item.activityType == this._type && (item.activityChildType == WonderfulActivityTypeData.CARNIVAL_ROOKIE || item.activityChildType == WonderfulActivityTypeData.CARNIVAL_ROOKIE + 8))
            {
               this.initItem(item);
            }
            else if(item.activityType == this._type && item.activityChildType == this._childType)
            {
               this.initItem(item);
               break;
            }
         }
         CarnivalActivityManager.instance.currentType = this._type;
         CarnivalActivityManager.instance.currentChildType = this._childType;
         for(k = 0; k < this._infoVec.length; k++)
         {
            for(i = 0; i < this._infoVec[k].giftbagArray.length; i++)
            {
               if(this._infoVec[k].giftbagArray[i].rewardMark == 100)
               {
                  for(j = 0; j < this._infoVec[k].giftbagArray[i].giftConditionArr.length; j++)
                  {
                     if(this._infoVec[k].giftbagArray[i].giftConditionArr[j].conditionIndex == 101 && this._infoVec[k].giftbagArray[i].giftConditionArr[j].conditionValue == 1)
                     {
                        this._hasBuyGift = true;
                        this._buyGiftActId = this._infoVec[k].giftbagArray[i].giftConditionArr[j].remain2;
                        break;
                     }
                  }
               }
               if(this._hasBuyGift)
               {
                  break;
               }
            }
         }
         for each(giftItem in WonderfulActivityManager.Instance.activityData)
         {
            if(giftItem.activityId == this._buyGiftActId)
            {
               this._buyGiftItem = giftItem;
               this._buyGiftLimitType = this._buyGiftItem.giftbagArray[0].giftConditionArr[0].conditionValue;
               this._buyGiftLimitCount = this._buyGiftItem.giftbagArray[0].giftConditionArr[1].conditionValue;
               this._buyGiftType = this._buyGiftItem.giftbagArray[0].giftConditionArr[2].conditionValue;
               this._buyGiftPrice = this._buyGiftItem.giftbagArray[0].giftConditionArr[3].conditionValue;
               break;
            }
         }
      }
      
      private function initItem(item:GmActivityInfo) : void
      {
         if(!this._item)
         {
            this._item = item;
         }
         if(this._sumTime == 0)
         {
            this._sumTime = Date.parse(item.endTime) - new Date().time;
         }
         for(var k:int = 0; k < item.giftbagArray.length; k++)
         {
            this._giftInfoVec.push(item.giftbagArray[k]);
         }
         this._infoVec.push(item);
      }
      
      private function updateTime() : void
      {
         var hours:int = this._sumTime <= 0 ? 0 : int(this._sumTime / (1000 * 60 * 60));
         var minutes:int = this._sumTime <= 0 ? 0 : int((this._sumTime / (1000 * 60 * 60) - hours) * 60);
         var _sumTimeStr:String = "";
         if(hours < 10)
         {
            _sumTimeStr += "0" + hours;
         }
         else
         {
            _sumTimeStr += hours;
         }
         _sumTimeStr += ":";
         if(minutes < 10)
         {
            _sumTimeStr += "0" + minutes;
         }
         else
         {
            _sumTimeStr += minutes;
         }
         this._timeTxt.text = _sumTimeStr;
      }
      
      protected function __timerHandler(event:TimerEvent) : void
      {
         this._sumTime -= 1000 * 60;
         this.updateTime();
      }
      
      private function initView() : void
      {
         var posType:int = 0;
         var awardStr:String = null;
         var ki:int = 0;
         var bi:int = 0;
         var giftInfo:GiftRewardInfo = null;
         var name:String = null;
         var i:int = 0;
         var item:CarnivalActivityItem = null;
         CarnivalActivityManager.instance.getBeginTime = Date.parse(this._item.beginShowTime);
         CarnivalActivityManager.instance.getEndTime = Date.parse(this._item.endShowTime);
         CarnivalActivityManager.instance.actBeginTime = Date.parse(this._item.beginTime);
         CarnivalActivityManager.instance.actEndTime = Date.parse(this._item.endTime);
         this._bg = ComponentFactory.Instance.creat("carnicalAct.bg");
         addChild(this._bg);
         if(this._type == WonderfulActivityTypeData.MOUNT_MASTER)
         {
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.mountDarenTxt");
            addChild(this._titleTxt);
            this._titleTxt.text = "Daren bağlar";
         }
         else
         {
            if(this._type == WonderfulActivityTypeData.CARNIVAL_ACTIVITY)
            {
               this._titleBg = ComponentFactory.Instance.creat("carnicalAct.title" + this._childType);
            }
            else
            {
               this._titleBg = ComponentFactory.Instance.creat("carnicalAct.title" + this._type);
            }
            addChild(this._titleBg);
            posType = 1;
            if(this._type == 16 || this._type == 17 || this._type == 15 && this._childType == 4)
            {
               posType = 2;
            }
            PositionUtils.setPos(this._titleBg,"carnivalAct.titlePos" + posType);
         }
         this._closeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.closeTimeTxt");
         addChild(this._closeTimeTxt);
         this._closeTimeTxt.text = LanguageMgr.GetTranslation("carnival.closeTimeTxt");
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.timeTxt");
         addChild(this._timeTxt);
         this._actTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.actTxt");
         addChild(this._actTxt);
         this._actTxt.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.actTimeText");
         this._actTimeTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.actTimeTxt");
         addChild(this._actTimeTxt);
         this._actTimeTxt.text = this._item.beginTime.split(" ")[0] + "-" + this._item.endTime.split(" ")[0];
         this._getTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.getTxt");
         addChild(this._getTxt);
         this._getTxt.text = LanguageMgr.GetTranslation("carnival.getTimeTxt");
         this._getTimeTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.getTimeTxt");
         addChild(this._getTimeTxt);
         this._getTimeTxt.text = this._item.beginShowTime.split(" ")[0] + "-" + this._item.endShowTime.split(" ")[0];
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.descTxt");
         this._descSp = new Sprite();
         this._descSp.addChild(this._descTxt);
         var str:String = this._item.desc;
         this._descTxt.text = str;
         addChild(this._descSp);
         this._allDescBg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         this._allDescBg.x = this._descTxt.x;
         this._allDescBg.y = this._descTxt.y + 25;
         this._allDescTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.allDescTxt");
         this._allDescTxt.text = str;
         this._allDescBg.width = this._allDescTxt.width + 16;
         this._allDescBg.height = this._allDescTxt.height + 8;
         this._allDescTxt.x = this._allDescBg.x + 8;
         this._allDescTxt.y = this._allDescBg.y + 4;
         this._allDescBg.visible = this._allDescTxt.visible = false;
         if(this._hasBuyGift)
         {
            this._buyBg = ComponentFactory.Instance.creat("carnicalAct.buyItem");
            addChild(this._buyBg);
            this._priceTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.priceTxt");
            addChild(this._priceTxt);
            this._priceTxt.text = this._buyGiftPrice + LanguageMgr.GetTranslation("carnival.buyGiftTypeTxt" + (this._buyGiftType == -1 ? 2 : 1));
            if(this._buyGiftLimitType != 3)
            {
               if(this._buyGiftLimitType == 1)
               {
                  this._dailyBuyBg = ComponentFactory.Instance.creat("carnivalAct.dailyBuyBg");
                  addChild(this._dailyBuyBg);
               }
               this._buyCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.buyCountTxt");
               addChild(this._buyCountTxt);
            }
            else
            {
               this._priceTxt.y += 9;
            }
            this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.buyBtn");
            addChild(this._buyBtn);
            this._buyBtn.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
            this._gift = new CarnivalActivityGift();
            this._gift.tipStyle = "ddt.view.tips.OneLineTip";
            this._gift.tipDirctions = "2,7,5";
            awardStr = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle") + "\n";
            for(ki = 0; ki < this._buyGiftItem.giftbagArray.length; ki++)
            {
               for(bi = 0; bi < this._buyGiftItem.giftbagArray[ki].giftRewardArr.length; bi++)
               {
                  giftInfo = this._buyGiftItem.giftbagArray[ki].giftRewardArr[bi];
                  name = ItemManager.Instance.getTemplateById(giftInfo.templateId).Name;
                  awardStr += name + "x" + giftInfo.count + (bi == this._buyGiftItem.giftbagArray[ki].giftRewardArr.length - 1 ? "" : "、\n");
               }
            }
            this._gift.tipData = awardStr;
            this._gift.x = this._buyBg.x + 12;
            this._gift.y = this._buyBg.y + 11;
            addChild(this._gift);
         }
         else
         {
            this._actTxt.x += 125;
            this._actTimeTxt.x += 163;
            this._getTxt.x += 125;
            this._getTimeTxt.x += 163;
            this._descSp.x += 125;
            this._allDescBg.x += 125;
            this._allDescTxt.x += 125;
         }
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.vbox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.scroll");
         this._scrollPanel.setView(this._vBox);
         addChild(this._scrollPanel);
         for(var k:int = 0; k < this._infoVec.length; k++)
         {
            for(i = 0; i < this._infoVec[k].giftbagArray.length; i++)
            {
               if(this._infoVec[k].giftbagArray[i].rewardMark != 100)
               {
                  switch(this._type)
                  {
                     case WonderfulActivityTypeData.WHOLEPEOPLE_VIP:
                        item = new WholePeopleVipActItem(this._type,this._infoVec[k].giftbagArray[i],i % 2);
                        break;
                     case WonderfulActivityTypeData.WHOLEPEOPLE_PET:
                        item = new WholePeoplePetActItem(this._type,this._infoVec[k].giftbagArray[i],i % 2);
                        break;
                     case WonderfulActivityTypeData.DAILY_GIFT:
                        item = new DailyGiftItem(this._type,this._infoVec[k].giftbagArray[i],i % 2);
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_ROOKIE:
                        item = new RookieItem(this._type,this._infoVec[k].giftbagArray[i],i % 2);
                        break;
                     case WonderfulActivityTypeData.MOUNT_MASTER:
                        item = new HorseDarenItem(this._type,this._infoVec[k].giftbagArray[i],i % 2);
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_ACTIVITY:
                        if(this._childType == WonderfulActivityTypeData.CARNIVAL_ROOKIE)
                        {
                           item = new RookieItem(this._type,this._infoVec[k].giftbagArray[i],i % 2);
                        }
                        else
                        {
                           item = new CarnivalActivityItem(this._type,this._infoVec[k].giftbagArray[i],i % 2);
                        }
                  }
                  this._itemVec.push(item);
                  this._vBox.addChild(item);
               }
            }
         }
         this._scrollPanel.invalidateViewport();
         this._timer = new Timer(1000 * 60,int(this._sumTime / 1000));
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         this._timer.start();
         addChild(this._allDescBg);
         addChild(this._allDescTxt);
         this.updateView();
      }
      
      public function updateView() : void
      {
         var cItem:CarnivalActivityItem = null;
         for each(cItem in this._itemVec)
         {
            cItem.updateView();
         }
         if(!this._buyGiftItem)
         {
            return;
         }
         if(Boolean(WonderfulActivityManager.Instance.activityInitData[this._buyGiftItem.activityId]) && Boolean(WonderfulActivityManager.Instance.activityInitData[this._buyGiftItem.activityId].giftInfoDic[this._buyGiftItem.giftbagArray[0].giftbagId]))
         {
            this._buyGiftCurInfo = WonderfulActivityManager.Instance.activityInitData[this._buyGiftItem.activityId].giftInfoDic[this._buyGiftItem.giftbagArray[0].giftbagId];
         }
         if(this._buyGiftLimitType != 3)
         {
            if(Boolean(this._buyGiftCurInfo))
            {
               this._buyCount = this._buyGiftLimitCount - this._buyGiftCurInfo.times;
            }
            else
            {
               this._buyCount = this._buyGiftLimitCount;
            }
            this._buyBtn.enable = this._buyCount > 0;
         }
         else
         {
            this._buyBtn.enable = true;
         }
         if(Boolean(this._buyCountTxt))
         {
            this._buyCountTxt.text = LanguageMgr.GetTranslation("carnival.awardBuyCountTxt",this._buyCount + "/" + this._buyGiftLimitCount);
         }
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyGiftPackHandler);
         }
         this._descSp.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._descSp.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         WonderfulActivityManager.Instance.addEventListener(WonderfulActivityManager.UPDATE_MOUNT_MASTER,this.__updateMountMaster);
      }
      
      private function __updateMountMaster(e:Event) : void
      {
         this.updateView();
      }
      
      protected function __outHandler(event:MouseEvent) : void
      {
         this._allDescTxt.visible = false;
         this._allDescBg.visible = false;
      }
      
      protected function __overHandler(event:MouseEvent) : void
      {
         this._allDescTxt.visible = true;
         this._allDescBg.visible = true;
      }
      
      protected function __buyGiftPackHandler(event:MouseEvent) : void
      {
         var type:int = 0;
         SoundManager.instance.playButtonSound();
         if(!this._buyGiftItem)
         {
            return;
         }
         if(this._buyGiftType == -8)
         {
            type = AlertManager.NOSELECTBTN;
         }
         else
         {
            type = AlertManager.SELECTBTN;
         }
         var alertAsk:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("carnival.awardGiftBuyTxt",this._buyGiftPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,type);
         alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertBuyGift);
      }
      
      protected function buyGift(isBand:Boolean) : void
      {
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var info:SendGiftInfo = new SendGiftInfo();
         info.activityId = this._buyGiftItem.activityId;
         var temp:Array = [];
         for(var i:int = 0; i < this._buyGiftItem.giftbagArray.length; i++)
         {
            temp.push(this._buyGiftItem.giftbagArray[i].giftbagId + "," + (isBand ? -9 : -8));
         }
         info.giftIdArr = temp;
         sendInfoVec.push(info);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      protected function __alertBuyGift(event:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyGift);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  ObjectUtils.disposeObject(event.currentTarget);
                  return;
               }
               if(frame.isBand)
               {
                  if(!this.checkMoney(true))
                  {
                     frame.dispose();
                     alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                     alertFrame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                     return;
                  }
               }
               else if(!this.checkMoney(false))
               {
                  frame.dispose();
                  alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               this.buyGift(frame.isBand);
               break;
         }
         frame.dispose();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function onResponseHander(e:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.checkMoney(false))
            {
               alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            this.buyGift(false);
         }
         e.currentTarget.dispose();
      }
      
      private function checkMoney(isBand:Boolean) : Boolean
      {
         if(isBand)
         {
            if(PlayerManager.Instance.Self.BandMoney < this._buyGiftPrice)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < this._buyGiftPrice)
         {
            return false;
         }
         return true;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__buyGiftPackHandler);
         }
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
         }
         if(Boolean(this._descSp))
         {
            this._descSp.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this._descSp.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         }
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         ObjectUtils.disposeObject(this._closeTimeTxt);
         this._closeTimeTxt = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         ObjectUtils.disposeObject(this._actTxt);
         this._actTxt = null;
         ObjectUtils.disposeObject(this._actTimeTxt);
         this._actTimeTxt = null;
         ObjectUtils.disposeObject(this._getTxt);
         this._getTxt = null;
         ObjectUtils.disposeObject(this._getTimeTxt);
         this._getTimeTxt = null;
         ObjectUtils.disposeObject(this._descTxt);
         this._descTxt = null;
         ObjectUtils.disposeObject(this._priceTxt);
         this._priceTxt = null;
         ObjectUtils.disposeObject(this._buyCountTxt);
         this._buyCountTxt = null;
         ObjectUtils.disposeObject(this._dailyBuyBg);
         this._dailyBuyBg = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._gift);
         this._gift = null;
         ObjectUtils.disposeObject(this._buyBg);
         this._buyBg = null;
         ObjectUtils.disposeObject(this._allDescBg);
         this._allDescBg = null;
         ObjectUtils.disposeObject(this._allDescTxt);
         this._allDescTxt = null;
         ObjectUtils.disposeObject(this._descSp);
         this._descSp = null;
         ObjectUtils.disposeObject(this._titleTxt);
         this._titleTxt = null;
         this._itemVec = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

