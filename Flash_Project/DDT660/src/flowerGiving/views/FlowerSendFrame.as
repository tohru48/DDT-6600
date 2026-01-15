package flowerGiving.views
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flowerGiving.FlowerGivingManager;
   import flowerGiving.components.FlowerSendFrameItem;
   import flowerGiving.components.FlowerSendFrameNameInput;
   import flowerGiving.data.FlowerSendRecordInfo;
   import flowerGiving.events.FlowerGivingEvent;
   import flowerGiving.events.FlowerSendRecordEvent;
   import road7th.comm.PackageIn;
   import road7th.utils.StringHelper;
   import shop.manager.ShopBuyManager;
   
   public class FlowerSendFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _sendBtnBg:ScaleBitmapImage;
      
      private var _leftBit:Bitmap;
      
      private var _rightBit:Bitmap;
      
      private var _sendRecordBtn:SimpleBitmapButton;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _numTxt:FilterFrameText;
      
      private var _otherNumTxt:FilterFrameText;
      
      private var _otherSelectBtn:SelectedCheckButton;
      
      private var _selectBtnGroup:SelectedButtonGroup;
      
      private var _sendBtn:SimpleBitmapButton;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _sendToOtherTxt:FilterFrameText;
      
      private var _itemArr:Array;
      
      private var _sendRecordFrame:Frame;
      
      private var _dataArr:Array;
      
      private var _myFlowerBagCell:BagCell;
      
      private var _maxNum:int;
      
      private var _nameInput:FlowerSendFrameNameInput;
      
      private var _dropList:DropList;
      
      public function FlowerSendFrame()
      {
         super();
         this.initView();
         this.initViewWithData();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._itemArr = new Array();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.FlowerSendFrame.scale9ImageBg");
         addToContent(this._bg);
         this._leftBit = ComponentFactory.Instance.creat("flowerGiving.flowerSendFrame.sendLeft");
         addToContent(this._leftBit);
         this._selectBtnGroup = new SelectedButtonGroup();
         this._otherSelectBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.selectedBtn");
         addToContent(this._otherSelectBtn);
         PositionUtils.setPos(this._otherSelectBtn,"flowerGiving.flowerSendFrame.oselectBtnPos");
         this._selectBtnGroup.addSelectItem(this._otherSelectBtn);
         this._rightBit = ComponentFactory.Instance.creat("flowerGiving.flowerSendFrame.sendRight");
         addToContent(this._rightBit);
         this._sendRecordBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendRecordBtn");
         addToContent(this._sendRecordBtn);
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.numTxt");
         this._numTxt.restrict = "0-9";
         addToContent(this._numTxt);
         this._numTxt.text = "1";
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.maxBtn");
         addToContent(this._maxBtn);
         this._otherNumTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendTxt2");
         addToContent(this._otherNumTxt);
         PositionUtils.setPos(this._otherNumTxt,"flowerGiving.flowerSendFrame.otherNumPos");
         this._otherNumTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.otherNumTxt");
         this._sendBtnBg = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendBtnBackBg");
         addToContent(this._sendBtnBg);
         this._sendBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendBtn");
         addToContent(this._sendBtn);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.buyBtn");
         addToContent(this._buyBtn);
         this._nameInput = ComponentFactory.Instance.creatCustomObject("flowerGiving.FlowerSendFrame.nameInput");
         PositionUtils.setPos(this._nameInput,"flowerGiving.flowerSendFrame.searchTxtPos");
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._nameInput;
         this._dropList.x = this._nameInput.x - 63;
         this._dropList.y = this._nameInput.y + this._nameInput.height;
         addToContent(this._nameInput);
         this._sendToOtherTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendToOtherTxt");
         addToContent(this._sendToOtherTxt);
         this._sendToOtherTxt.maxChars = 35;
         this._sendToOtherTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.sendToOther");
      }
      
      private function initViewWithData() : void
      {
         var flowerItem:FlowerSendFrameItem = null;
         this._dataArr = FlowerGivingManager.instance.getDataByRewardMark(5);
         for(var i:int = 0; i < this._dataArr.length; i++)
         {
            flowerItem = new FlowerSendFrameItem(this._dataArr[i]);
            PositionUtils.setPos(flowerItem,"flowerGiving.flowerSendFrame.itemPos" + (i + 1));
            addToContent(flowerItem);
            this._selectBtnGroup.addSelectItem(flowerItem.selectBtn);
            this._itemArr.push(flowerItem);
         }
         this._selectBtnGroup.selectIndex = 0;
         var bagInfo:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG);
         this._maxNum = bagInfo.getItemCountByTemplateId(FlowerGivingManager.instance.flowerTempleteId);
         this._myFlowerBagCell = this.createBagCell(FlowerGivingManager.instance.flowerTempleteId);
         this._myFlowerBagCell.setCount(this._maxNum);
         addToContent(this._myFlowerBagCell);
         PositionUtils.setPos(this._myFlowerBagCell,"flowerGiving.flowerSendFrame.myFlowerBagCell");
      }
      
      private function createBagCell(templeteId:int) : BagCell
      {
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = templeteId;
         info = ItemManager.fill(info);
         info.IsBinds = true;
         var bagCell:BagCell = new BagCell(0);
         bagCell.info = info;
         bagCell.setBgVisible(false);
         return bagCell;
      }
      
      protected function __onReceiverChange(event:Event) : void
      {
         if(this._nameInput.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var list:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(list),this._nameInput.text);
      }
      
      private function filterRepeatInArray(filterArr:Array) : Array
      {
         var j:int = 0;
         var arr:Array = new Array();
         for(var i:int = 0; i < filterArr.length; i++)
         {
            if(i == 0)
            {
               arr.push(filterArr[i]);
            }
            for(j = 0; j < arr.length; j++)
            {
               if(arr[j].NickName == filterArr[i].NickName)
               {
                  break;
               }
               if(j == arr.length - 1)
               {
                  arr.push(filterArr[i]);
               }
            }
         }
         return arr;
      }
      
      private function filterSearch(list:Array, targetStr:String) : Array
      {
         var result:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            if(list[i].NickName.indexOf(targetStr) != -1)
            {
               result.push(list[i]);
            }
         }
         return result;
      }
      
      protected function __hideDropList(event:Event) : void
      {
         if(event.target is FilterFrameText && event.target != this._numTxt && event.target != this._sendToOtherTxt)
         {
            return;
         }
         if(Boolean(this._dropList) && Boolean(this._dropList.parent))
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._responseHandle);
         this._sendRecordBtn.removeEventListener(MouseEvent.CLICK,this.__recordHandler);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.__maxHandler);
         this._numTxt.removeEventListener(Event.CHANGE,this.__inputHandler);
         this._selectBtnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._nameInput.removeEventListener(Event.CHANGE,this.__onReceiverChange);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyHandler);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideDropList);
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.GIVE_FLOWER,this.__giveHandler);
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.GET_RECORD,this.__getRecordHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS,this.__flowerBuyHandler);
         FlowerGivingManager.instance.removeEventListener(FlowerSendRecordEvent.HUIKUI_FLOWER,this._huiKuiHandler);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._responseHandle);
         this._sendRecordBtn.addEventListener(MouseEvent.CLICK,this.__recordHandler);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.__maxHandler);
         this._numTxt.addEventListener(Event.CHANGE,this.__inputHandler);
         this._selectBtnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._nameInput.addEventListener(Event.CHANGE,this.__onReceiverChange);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideDropList);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyHandler);
         SocketManager.Instance.addEventListener(FlowerGivingEvent.GIVE_FLOWER,this.__giveHandler);
         SocketManager.Instance.addEventListener(FlowerGivingEvent.GET_RECORD,this.__getRecordHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.__flowerBuyHandler);
         FlowerGivingManager.instance.addEventListener(FlowerSendRecordEvent.HUIKUI_FLOWER,this._huiKuiHandler);
      }
      
      protected function _huiKuiHandler(event:FlowerSendRecordEvent) : void
      {
         this._nameInput.text = event.nickName;
         if(Boolean(this._sendRecordFrame))
         {
            this._sendRecordFrame.dispose();
         }
      }
      
      protected function __flowerBuyHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var successType:int = pkg.readInt();
         var buyFrom:int = pkg.readInt();
         this.updateFlowerNum();
      }
      
      protected function __buyHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _shopItemInfo:ShopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(FlowerGivingManager.instance.flowerTempleteId);
         ShopBuyManager.Instance.buy(_shopItemInfo.GoodsID,_shopItemInfo.isDiscount,_shopItemInfo.getItemPrice(1).PriceType);
      }
      
      protected function __getRecordHandler(event:FlowerGivingEvent) : void
      {
         var info:FlowerSendRecordInfo = null;
         var arr:Array = new Array();
         var pkg:PackageIn = event.pkg;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            info = new FlowerSendRecordInfo();
            info.date = pkg.readUTF();
            info.selfId = pkg.readInt();
            info.playerId = pkg.readInt();
            info.nickName = pkg.readUTF();
            info.flag = pkg.readBoolean();
            info.num = pkg.readInt();
            arr.push(info);
         }
         this._sendRecordFrame = ComponentFactory.Instance.creatCustomObject("flowerGiving.FlowerSendRecordFrame",[arr]);
         this._sendRecordFrame.titleText = LanguageMgr.GetTranslation("flowerGiving.flowerSendRecordFrame.title");
         LayerManager.Instance.addToLayer(this._sendRecordFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __giveHandler(event:FlowerGivingEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var isSuccess:Boolean = pkg.readBoolean();
         this.updateFlowerNum();
      }
      
      private function updateFlowerNum() : void
      {
         var bagInfo:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG);
         this._maxNum = bagInfo.getItemCountByTemplateId(FlowerGivingManager.instance.flowerTempleteId);
         this._myFlowerBagCell.setCount(this._maxNum);
      }
      
      protected function __sendHandler(event:MouseEvent) : void
      {
         var num:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var playerName:String = this._nameInput.text;
         if(playerName == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.nameInputTxt"));
            return;
         }
         if(this._selectBtnGroup.selectIndex != 0)
         {
            num = int(this._dataArr[this._selectBtnGroup.selectIndex - 1].giftConditionArr[0].conditionValue);
         }
         else
         {
            num = int(this._numTxt.text);
         }
         if(num > this._maxNum)
         {
            this.__buyHandler(null);
            return;
         }
         var text:String = this._sendToOtherTxt.text;
         text = StringHelper.trim(text);
         text = FilterWordManager.filterWrod(text);
         text = StringHelper.rePlaceHtmlTextField(text);
         SocketManager.Instance.out.sendFlower(playerName,num,text);
      }
      
      protected function __changeHandler(event:Event) : void
      {
         var item:FlowerSendFrameItem = null;
         SoundManager.instance.play("008");
         for each(item in this._itemArr)
         {
            item.updateShine();
         }
      }
      
      protected function __inputHandler(event:Event) : void
      {
         if(int(this._numTxt.text) < 1)
         {
            this._numTxt.text = "1";
         }
         else if(int(this._numTxt.text) > this._maxNum)
         {
            this._numTxt.text = "" + this._maxNum;
         }
      }
      
      protected function __maxHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._maxNum = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(FlowerGivingManager.instance.flowerTempleteId);
         this._numTxt.text = this._maxNum > 0 ? "" + this._maxNum : "1";
      }
      
      protected function __recordHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendFlowerRecord();
      }
      
      protected function _responseHandle(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         var item:FlowerSendFrameItem = null;
         this._sendRecordFrame = null;
         this.removeEvent();
         for each(item in this._itemArr)
         {
            ObjectUtils.disposeObject(item);
            item = null;
         }
         this._itemArr = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._sendBtnBg))
         {
            ObjectUtils.disposeObject(this._sendBtnBg);
         }
         this._sendBtnBg = null;
         if(Boolean(this._leftBit))
         {
            ObjectUtils.disposeObject(this._leftBit);
         }
         this._leftBit = null;
         if(Boolean(this._rightBit))
         {
            ObjectUtils.disposeObject(this._rightBit);
         }
         this._rightBit = null;
         if(Boolean(this._sendRecordBtn))
         {
            ObjectUtils.disposeObject(this._sendRecordBtn);
         }
         this._sendRecordBtn = null;
         if(Boolean(this._numTxt))
         {
            ObjectUtils.disposeObject(this._numTxt);
         }
         this._numTxt = null;
         if(Boolean(this._otherNumTxt))
         {
            ObjectUtils.disposeObject(this._otherNumTxt);
         }
         this._otherNumTxt = null;
         if(Boolean(this._maxBtn))
         {
            ObjectUtils.disposeObject(this._maxBtn);
         }
         this._maxBtn = null;
         if(Boolean(this._otherSelectBtn))
         {
            ObjectUtils.disposeObject(this._otherSelectBtn);
         }
         this._otherSelectBtn = null;
         if(Boolean(this._selectBtnGroup))
         {
            ObjectUtils.disposeObject(this._selectBtnGroup);
         }
         this._selectBtnGroup = null;
         if(Boolean(this._sendBtn))
         {
            ObjectUtils.disposeObject(this._sendBtn);
         }
         this._sendBtn = null;
         if(Boolean(this._buyBtn))
         {
            ObjectUtils.disposeObject(this._buyBtn);
         }
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._dropList);
         this._dropList = null;
         this._nameInput = null;
         if(Boolean(this._sendToOtherTxt))
         {
            ObjectUtils.disposeObject(this._sendToOtherTxt);
         }
         this._sendToOtherTxt = null;
         if(Boolean(this._myFlowerBagCell))
         {
            ObjectUtils.disposeObject(this._myFlowerBagCell);
         }
         this._myFlowerBagCell = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

