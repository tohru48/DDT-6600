package wonderfulActivity.newActivity.ExchangeAct
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.event.ActivityEvent;
   
   public class ExchangeGoodsCell extends BaseCell
   {
      
      private var _gooodsExchangeInfo:GiftRewardInfo;
      
      private var _countText:FilterFrameText;
      
      private var _type:Boolean;
      
      private var _haveCount:int;
      
      private var _needCount:int;
      
      private var _haveCountTemp:int;
      
      private var _num:int;
      
      private var _id:int;
      
      public function ExchangeGoodsCell(exchangeInfo:GiftRewardInfo, activeType:int = -1, type:Boolean = true, id:int = -1, num:int = 1)
      {
         var itemInfo:ItemTemplateInfo = null;
         var item:InventoryItemInfo = null;
         var attrArr:Array = null;
         var tempId:int = 0;
         this.intEvent();
         this._gooodsExchangeInfo = exchangeInfo;
         this._type = type;
         this._id = id;
         this._num = num;
         if(Boolean(exchangeInfo) && (activeType == 3 || activeType == 4))
         {
            if(activeType == 4)
            {
               if(this._type)
               {
                  _bg = ComponentFactory.Instance.creatBitmap("asset.activity.wordBg");
               }
               else
               {
                  _bg = ComponentFactory.Instance.creatBitmap("asset.activity.seedBg");
               }
               _bg.alpha = 0;
            }
            else
            {
               _bg = ComponentFactory.Instance.creatBitmap("asset.activity.seedBg");
            }
         }
         else
         {
            _bg = ComponentFactory.Instance.creatBitmap("ddtcalendar.exchange.cellBg");
         }
         this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.cellCount");
         if(this._gooodsExchangeInfo == null)
         {
            _info = null;
            this._countText.text = "";
         }
         else
         {
            itemInfo = ItemManager.Instance.getTemplateById(this._gooodsExchangeInfo.templateId);
            item = new InventoryItemInfo();
            item.TemplateID = itemInfo.TemplateID;
            ItemManager.fill(item);
            attrArr = this._gooodsExchangeInfo.property.split(",");
            item._StrengthenLevel = parseInt(attrArr[0]);
            item.AttackCompose = parseInt(attrArr[1]);
            item.DefendCompose = parseInt(attrArr[2]);
            item.AgilityCompose = parseInt(attrArr[3]);
            item.LuckCompose = parseInt(attrArr[4]);
            if(EquipType.isMagicStone(item.CategoryID))
            {
               item.Level = item.StrengthenLevel;
               item.Attack = item.AttackCompose;
               item.Defence = item.DefendCompose;
               item.Agility = item.AgilityCompose;
               item.Luck = item.LuckCompose;
               item.MagicAttack = parseInt(attrArr[6]);
               item.MagicDefence = parseInt(attrArr[7]);
               item.StrengthenExp = parseInt(attrArr[8]);
            }
            item.IsBinds = true;
            item.isShowBind = this._type != true;
            _info = item;
            if(this._type)
            {
               tempId = exchangeInfo.templateId;
               if(item.CanStrengthen)
               {
                  this._haveCount = PlayerManager.Instance.Self.findItemCount(tempId,item._StrengthenLevel);
               }
               else
               {
                  this._haveCount = PlayerManager.Instance.Self.findItemCount(tempId);
               }
               if(this._haveCount == 0)
               {
                  this._haveCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(tempId);
               }
               if(this._haveCount == 0)
               {
                  this._haveCount = PlayerManager.Instance.Self.BeadBag.getItemCountByTemplateId(tempId);
               }
               this._countText.text = this._haveCount.toString() + "/" + (this._gooodsExchangeInfo.count * this._num).toString();
            }
            else
            {
               this._countText.text = (this._gooodsExchangeInfo.count * this._num).toString();
            }
         }
         this._haveCountTemp = this._haveCount;
         super(_bg,_info);
         addChild(this._countText);
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         var array:Array = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(this._gooodsExchangeInfo.templateId);
         if(array.length == 0)
         {
            array = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(this._gooodsExchangeInfo.templateId);
         }
         if(array.length == 0)
         {
            array = PlayerManager.Instance.Self.BeadBag.findItemsByTempleteID(this._gooodsExchangeInfo.templateId);
         }
         return array[0];
      }
      
      private function intEvent() : void
      {
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.AFTERDEL,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.AFTERDEL,this.__updateCount);
      }
      
      private function __updateCount(event:BagEvent) : void
      {
         var evt:ActivityEvent = null;
         if(!this._gooodsExchangeInfo)
         {
            return;
         }
         var tempId:int = this._gooodsExchangeInfo.templateId;
         var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._gooodsExchangeInfo.templateId);
         var item:InventoryItemInfo = new InventoryItemInfo();
         item.TemplateID = itemInfo.TemplateID;
         ItemManager.fill(item);
         var attrArr:Array = this._gooodsExchangeInfo.property.split(",");
         item._StrengthenLevel = parseInt(attrArr[0]);
         item.AttackCompose = parseInt(attrArr[1]);
         item.DefendCompose = parseInt(attrArr[2]);
         item.AgilityCompose = parseInt(attrArr[3]);
         item.LuckCompose = parseInt(attrArr[4]);
         item.IsBinds = true;
         item.isShowBind = this._type != true;
         if(item.CanStrengthen)
         {
            this._haveCount = PlayerManager.Instance.Self.findItemCount(tempId,item.StrengthenLevel);
         }
         else
         {
            this._haveCount = PlayerManager.Instance.Self.findItemCount(tempId);
         }
         if(this._haveCount == 0)
         {
            this._haveCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(tempId);
         }
         if(this._haveCount == 0)
         {
            this._haveCount = PlayerManager.Instance.Self.BeadBag.getItemCountByTemplateId(tempId);
         }
         if(!this._countText)
         {
            this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.cellCount");
            addChild(this._countText);
         }
         if(this._haveCountTemp != this._haveCount)
         {
            this._haveCountTemp = this._haveCount;
            evt = new ActivityEvent(ActivityEvent.UPDATE_COUNT);
            evt.id = this._id;
            dispatchEvent(evt);
         }
         if(this._type)
         {
            this._countText.text = this._haveCount.toString() + "/" + (this._gooodsExchangeInfo.count * 1).toString();
         }
         else
         {
            this._countText.text = (this._gooodsExchangeInfo.count * 1).toString();
         }
      }
      
      public function get haveCount() : int
      {
         return this._haveCount;
      }
      
      public function get needCount() : int
      {
         return this._needCount = int(this.haveCount / this._gooodsExchangeInfo.count);
      }
      
      override public function dispose() : void
      {
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.AFTERDEL,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.AFTERDEL,this.__updateCount);
         super.dispose();
         if(Boolean(this._countText))
         {
            ObjectUtils.disposeObject(this._countText);
         }
         this._countText = null;
      }
   }
}

