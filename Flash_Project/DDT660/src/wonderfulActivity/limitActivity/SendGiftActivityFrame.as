package wonderfulActivity.limitActivity
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class SendGiftActivityFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var sendBtn:SimpleBitmapButton;
      
      private var _info:GmActivityInfo;
      
      private var _goodContent:Sprite;
      
      private var _prizeHBox:HBox;
      
      private var _activityBox:Sprite;
      
      public var nowId:String;
      
      public function SendGiftActivityFrame()
      {
         super();
         this.initview();
         this.addEvent();
      }
      
      private function initview() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.sendGiftActivityFrame.title");
         this._bg = ComponentFactory.Instance.creat("wonderful.sendGiftActivity.bg");
         addToContent(this._bg);
         this.sendBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.sendGiftFrame.sendBtn");
         addToContent(this.sendBtn);
         this._prizeHBox = ComponentFactory.Instance.creatComponentByStylename("wonderful.sendGiftActivity.Hbox");
         addToContent(this._prizeHBox);
         this._activityBox = new Sprite();
         addToContent(this._activityBox);
      }
      
      public function setData(info:GmActivityInfo) : void
      {
         var index:int = 0;
         var j:int = 0;
         var bagInfo:GiftRewardInfo = null;
         var item:GiftItem = null;
         var now:Date = null;
         var itemCheck:GmActivityInfo = null;
         var acItem:ActivityItem = null;
         this._info = info;
         this.nowId = this._info.activityId;
         for(var i:int = 0; i < this._info.giftbagArray.length; i++)
         {
            for(j = 0; j < this._info.giftbagArray[i].giftRewardArr.length; j++)
            {
               bagInfo = new GiftRewardInfo();
               bagInfo = this._info.giftbagArray[i].giftRewardArr[j];
               item = new GiftItem();
               item.initView(j + i * this._info.giftbagArray[i].giftRewardArr.length);
               item.setCellData(bagInfo);
               this._prizeHBox.addChild(item);
            }
         }
         this._prizeHBox.x = (this.width - this._prizeHBox.width) / 2;
         var activityArr:Array = this._info.remain2.split("|");
         index = 0;
         for(i = 0; i < activityArr.length; i++)
         {
            now = TimeManager.Instance.Now();
            itemCheck = WonderfulActivityManager.Instance.activityData[activityArr[i]];
            if(Boolean(itemCheck))
            {
               if(!(now.time < Date.parse(itemCheck.beginShowTime) || now.time > Date.parse(itemCheck.endShowTime)))
               {
                  acItem = new ActivityItem();
                  acItem.setData(activityArr[i]);
                  acItem.x = 22;
                  acItem.y = 282 + 34 * index;
                  this._activityBox.addChild(acItem);
                  index++;
               }
            }
         }
      }
      
      public function setBtnFalse() : void
      {
         if(Boolean(this.sendBtn))
         {
            this.sendBtn.enable = false;
            this.sendBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function addEvent() : void
      {
         this.sendBtn.addEventListener(MouseEvent.CLICK,this.__sendBtnClickHandler);
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function __sendBtnClickHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var sendInfo:SendGiftInfo = new SendGiftInfo();
         sendInfo.activityId = this._info.activityId;
         var giftIdArr:Array = new Array();
         giftIdArr.push(this._info.giftbagArray[0].giftbagId);
         sendInfo.giftIdArr = giftIdArr;
         sendInfoVec.push(sendInfo);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         this.sendBtn.removeEventListener(MouseEvent.CLICK,this.__sendBtnClickHandler);
         removeEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this.sendBtn);
         this.sendBtn = null;
         ObjectUtils.disposeObject(this._goodContent);
         this._goodContent = null;
         ObjectUtils.disposeObject(this._prizeHBox);
         this._prizeHBox = null;
         ObjectUtils.disposeObject(this._activityBox);
         this._activityBox = null;
      }
   }
}

import bagAndInfo.cell.BagCell;
import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.controls.TextButton;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.ui.text.FilterFrameText;
import com.pickgliss.utils.ObjectUtils;
import ddt.data.goods.InventoryItemInfo;
import ddt.manager.ItemManager;
import ddt.manager.LanguageMgr;
import ddt.manager.SocketManager;
import ddt.manager.SoundManager;
import ddt.utils.PositionUtils;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import wonderfulActivity.WonderfulActivityManager;
import wonderfulActivity.data.GiftRewardInfo;

class GiftItem extends Sprite implements Disposeable
{
   
   private var index:int;
   
   private var _bg:Bitmap;
   
   private var _bagCell:BagCell;
   
   public function GiftItem()
   {
      super();
   }
   
   public function initView(index:int) : void
   {
      this.index = index;
      this._bg = ComponentFactory.Instance.creat("wonderful.sendGiftActivity.frame");
      addChild(this._bg);
      this._bagCell = new BagCell(index);
      this._bagCell.height = 70;
      this._bagCell.width = 70;
      PositionUtils.setPos(this._bagCell,"wonderful.SendGiftative.bagCellPos");
      this._bagCell.visible = false;
      addChild(this._bagCell);
   }
   
   public function setCellData(gift:GiftRewardInfo) : void
   {
      if(!gift)
      {
         this._bagCell.visible = false;
         return;
      }
      this._bagCell.visible = true;
      var info:InventoryItemInfo = new InventoryItemInfo();
      info.TemplateID = gift.templateId;
      info = ItemManager.fill(info);
      info.IsBinds = gift.isBind;
      info.ValidDate = gift.validDate;
      var attrArr:Array = gift.property.split(",");
      info._StrengthenLevel = parseInt(attrArr[0]);
      info.AttackCompose = parseInt(attrArr[1]);
      info.DefendCompose = parseInt(attrArr[2]);
      info.AgilityCompose = parseInt(attrArr[3]);
      info.LuckCompose = parseInt(attrArr[4]);
      this._bagCell.info = info;
      this._bagCell.setCount(gift.count);
      this._bagCell.setBgVisible(false);
   }
   
   public function dispose() : void
   {
      if(Boolean(this._bg))
      {
         ObjectUtils.disposeObject(this._bg);
      }
      this._bg = null;
      if(Boolean(this._bagCell))
      {
         ObjectUtils.disposeObject(this._bagCell);
      }
      this._bagCell = null;
   }
}

class ActivityItem extends Sprite implements Disposeable
{
   
   private var txtBtn:TextButton;
   
   private var nameTxt:FilterFrameText;
   
   private var _id:String;
   
   public function ActivityItem()
   {
      super();
      this.txtBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfull.sendGiftActivity.check");
      this.txtBtn.text = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.view");
      addChild(this.txtBtn);
      this.nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfull.sendGiftActivity.nameTxt");
      addChild(this.nameTxt);
      this.nameTxt.mouseEnabled = true;
      this.nameTxt.addEventListener(TextEvent.LINK,this.linkhandler);
      this.txtBtn.addEventListener(MouseEvent.CLICK,this.clickhandler);
   }
   
   private function linkhandler(e:TextEvent) : void
   {
      SoundManager.instance.play("008");
      WonderfulActivityManager.Instance.selectId = this._id;
      WonderfulActivityManager.Instance.clickWonderfulActView = true;
      SocketManager.Instance.out.requestWonderfulActInit(1);
   }
   
   private function clickhandler(e:MouseEvent) : void
   {
      SoundManager.instance.play("008");
      WonderfulActivityManager.Instance.selectId = this._id;
      WonderfulActivityManager.Instance.clickWonderfulActView = true;
      SocketManager.Instance.out.requestWonderfulActInit(1);
   }
   
   public function setData(ID:String) : void
   {
      this._id = ID;
      var _name:String = WonderfulActivityManager.Instance.activityData[ID].activityName;
      if(_name.length > 40)
      {
         this.nameTxt.htmlText = "<a href=\'event:\'>" + _name.substr(0,40) + "...</a>";
      }
      else
      {
         this.nameTxt.htmlText = "<a href=\'event:\'>" + _name + "</a>";
      }
   }
   
   public function dispose() : void
   {
      this.nameTxt.removeEventListener(TextEvent.LINK,this.linkhandler);
      this.txtBtn.removeEventListener(MouseEvent.CLICK,this.clickhandler);
      if(Boolean(this.txtBtn))
      {
         ObjectUtils.disposeObject(this.txtBtn);
      }
      this.txtBtn = null;
      if(Boolean(this.nameTxt))
      {
         ObjectUtils.disposeObject(this.nameTxt);
      }
      this.nameTxt = null;
   }
}
