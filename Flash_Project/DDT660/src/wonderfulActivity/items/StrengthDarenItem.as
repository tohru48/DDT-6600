package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class StrengthDarenItem extends Sprite implements Disposeable
   {
      
      private var _back:MovieClip;
      
      private var _icon:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _goodContent:Sprite;
      
      private var _btn:SimpleBitmapButton;
      
      private var _data:GiftBagInfo;
      
      private var _giftcurInfo:GiftCurInfo;
      
      private var _strengthGrade:int;
      
      private var _statusArr:Array;
      
      private var _activityId:String;
      
      public function StrengthDarenItem(type:int, activityId:String, data:GiftBagInfo, giftcurInfo:GiftCurInfo, statusArr:Array)
      {
         super();
         this._activityId = activityId;
         this._data = data;
         this._giftcurInfo = giftcurInfo;
         this._strengthGrade = statusArr[0].statusValue;
         this._statusArr = statusArr;
         this.initView(type);
      }
      
      private function initView(type:int = 1) : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.newListItem");
         addChild(this._back);
         if(type == 1)
         {
            this._back.gotoAndStop(1);
         }
         else
         {
            this._back.gotoAndStop(2);
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.strength.nameTxt");
         addChild(this._nameTxt);
         this._nameTxt.text = LanguageMgr.GetTranslation("wonderfulActivity.strength.nameTxt",this._data.giftConditionArr[0].conditionValue);
         this._icon = ComponentFactory.Instance.creat("wonderfulactivity.strength" + this._data.giftConditionArr[0].conditionValue);
         addChild(this._icon);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
         PositionUtils.setPos(this._icon,"wonderful.strengthdaren.iconPos");
         if(this._strengthGrade < this._data.giftConditionArr[0].conditionValue || this.checkBtnState())
         {
            this._btn.enable = false;
         }
         else
         {
            this._btn.enable = true;
         }
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.btnHandler);
         this.initGoods();
      }
      
      private function checkBtnState() : Boolean
      {
         var flag:Boolean = false;
         for(var i:int = 0; i < this._statusArr.length; i++)
         {
            if(this._statusArr[i].statusID == this._data.giftConditionArr[0].conditionValue)
            {
               flag = true;
               if(this._statusArr[i].statusValue == 0)
               {
                  return true;
               }
            }
         }
         if(!flag)
         {
            return true;
         }
         return false;
      }
      
      private function btnHandler(e:MouseEvent) : void
      {
         this._btn.enable = false;
         addChild(this._btn);
         SoundManager.instance.play("008");
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var sendInfo:SendGiftInfo = new SendGiftInfo();
         sendInfo.activityId = this._activityId;
         var giftIdArr:Array = new Array();
         giftIdArr.push(this._data.giftbagId);
         sendInfo.giftIdArr = giftIdArr;
         sendInfoVec.push(sendInfo);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      private function initGoods() : void
      {
         var bagCell:BagCell = null;
         var back:Bitmap = null;
         this._goodContent = new Sprite();
         addChild(this._goodContent);
         for(var i:int = 0; i < this._data.giftRewardArr.length; i++)
         {
            bagCell = this.createBagCell(0,this._data.giftRewardArr[i]);
            back = ComponentFactory.Instance.creat("wonderfulactivity.goods.back");
            back.x = (back.width + 5) * i;
            bagCell.x = back.width / 2 - bagCell.width / 2 + back.x + 2;
            bagCell.y = back.height / 2 - bagCell.height / 2 + 1;
            this._goodContent.addChild(back);
            this._goodContent.addChild(bagCell);
         }
         this._goodContent.x = 142;
         this._goodContent.y = 9;
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
      
      public function dispose() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.btnHandler);
         while(Boolean(this._goodContent.numChildren))
         {
            ObjectUtils.disposeObject(this._goodContent.getChildAt(0));
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
         this._goodContent = null;
         this._back = null;
         this._nameTxt = null;
         this._btn = null;
         this._icon = null;
      }
   }
}

