package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class JoinIsPowerView extends Sprite implements IRightView
   {
      
      private var _back:Bitmap;
      
      private var _activityTimeTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _getButton:SimpleBitmapButton;
      
      private var _activityInfo:GmActivityInfo;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      private var _giftCondition:int;
      
      private var _hbox:HBox;
      
      public function JoinIsPowerView()
      {
         super();
      }
      
      public function init() : void
      {
         this.initView();
         this.initData();
         this.initViewWithData();
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.tuanjie.back");
         addChild(this._back);
         this._activityTimeTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.activetimeTxt");
         addChild(this._activityTimeTxt);
         PositionUtils.setPos(this._activityTimeTxt,"wonderful.joinispower.activetime.pos");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.joinIsPowerContentTxt");
         addChild(this._contentTxt);
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.GetButton");
         addChild(this._getButton);
         PositionUtils.setPos(this._getButton,"wonderful.getButton.pos");
         this._getButton.enable = false;
         this._hbox = ComponentFactory.Instance.creatComponentByStylename("wonderful.joinIsPower.Hbox");
         addChild(this._hbox);
      }
      
      private function initData() : void
      {
         var item:GmActivityInfo = null;
         for each(item in WonderfulActivityManager.Instance.activityData)
         {
            if(item.activityType == WonderfulActivityTypeData.CONSORTION_ACTIVITY && item.activityChildType == WonderfulActivityTypeData.TUANJIE_POWER)
            {
               this._activityInfo = item;
               this._giftCondition = this._activityInfo.giftbagArray[0].giftConditionArr[0].conditionValue;
               if(Boolean(WonderfulActivityManager.Instance.activityInitData[item.activityId]))
               {
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[item.activityId]["giftInfoDic"];
                  this._statusArr = WonderfulActivityManager.Instance.activityInitData[item.activityId]["statusArr"];
               }
            }
         }
      }
      
      private function initViewWithData() : void
      {
         var j:int = 0;
         var bagCell:BagCell = null;
         if(!this._activityInfo)
         {
            return;
         }
         var timeArr:Array = [this._activityInfo.beginTime.split(" ")[0],this._activityInfo.endTime.split(" ")[0]];
         this._activityTimeTxt.text = timeArr[0] + "-" + timeArr[1];
         this._contentTxt.text = this._activityInfo.desc;
         this.changeBtnState();
         for(var i:int = 0; i < this._activityInfo.giftbagArray.length; i++)
         {
            for(j = 0; j < this._activityInfo.giftbagArray[i].giftRewardArr.length; j++)
            {
               bagCell = this.createBagCell(0,this._activityInfo.giftbagArray[i].giftRewardArr[j]);
               this._hbox.addChild(bagCell);
            }
         }
      }
      
      private function createBagCell(order:int, gift:GiftRewardInfo) : BagCell
      {
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
         if(EquipType.isMagicStone(info.CategoryID))
         {
            info.Level = info.StrengthenLevel;
            info.Attack = info.AttackCompose;
            info.Defence = info.DefendCompose;
            info.Agility = info.AgilityCompose;
            info.Luck = info.LuckCompose;
            info.MagicAttack = parseInt(attrArr[6]);
            info.MagicDefence = parseInt(attrArr[7]);
            info.StrengthenExp = parseInt(attrArr[8]);
         }
         var bagCell:BagCell = new BagCell(order);
         bagCell.info = info;
         bagCell.setCount(gift.count);
         bagCell.setBgVisible(false);
         return bagCell;
      }
      
      public function refresh() : void
      {
         if(Boolean(WonderfulActivityManager.Instance.activityInitData[this._activityInfo.activityId]))
         {
            this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[this._activityInfo.activityId]["giftInfoDic"];
            this._statusArr = WonderfulActivityManager.Instance.activityInitData[this._activityInfo.activityId]["statusArr"];
         }
         this.changeBtnState();
      }
      
      private function changeBtnState() : void
      {
         if(this._statusArr[0].statusValue - this._giftInfoDic[this._activityInfo.giftbagArray[0].giftbagId].times * this._giftCondition >= this._giftCondition)
         {
            this._getButton.enable = true;
            this._getButton.addEventListener(MouseEvent.CLICK,this.__getAwardHandler);
         }
         else
         {
            this._getButton.enable = false;
         }
      }
      
      protected function __getAwardHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var sendInfo:SendGiftInfo = new SendGiftInfo();
         sendInfo.activityId = this._activityInfo.activityId;
         var giftIdArr:Array = new Array();
         for(var j:int = 0; j < this._activityInfo.giftbagArray.length; j++)
         {
            giftIdArr.push(this._activityInfo.giftbagArray[j].giftbagId);
         }
         sendInfo.giftIdArr = giftIdArr;
         sendInfoVec.push(sendInfo);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      public function setData(val:* = null) : void
      {
      }
      
      public function dispose() : void
      {
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(Boolean(this._activityTimeTxt))
         {
            ObjectUtils.disposeObject(this._activityTimeTxt);
            this._activityTimeTxt = null;
         }
         if(Boolean(this._contentTxt))
         {
            ObjectUtils.disposeObject(this._contentTxt);
            this._contentTxt = null;
         }
         if(Boolean(this._getButton))
         {
            this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAwardHandler);
            ObjectUtils.disposeObject(this._getButton);
            this._getButton = null;
         }
         if(Boolean(this._hbox))
         {
            ObjectUtils.disposeObject(this._hbox);
            this._hbox = null;
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}

