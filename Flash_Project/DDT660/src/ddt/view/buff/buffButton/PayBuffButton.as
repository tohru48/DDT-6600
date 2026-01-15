package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.BuffTipInfo;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import shop.view.SetsShopView;
   
   public class PayBuffButton extends BuffButton
   {
      
      private var _buffs:Vector.<BuffInfo> = new Vector.<BuffInfo>();
      
      private var _isActived:Boolean = false;
      
      private var _timer:Timer;
      
      private var _str:String;
      
      private var _isMouseOver:Boolean = false;
      
      public function PayBuffButton(str:String = "")
      {
         if(str == "")
         {
            this._str = "asset.core.payBuffAsset";
         }
         else
         {
            this._str = str;
         }
         super(this._str);
         _tipStyle = "core.PayBuffTip";
         info = new BuffInfo(BuffInfo.Pay_Buff);
         this._timer = new Timer(10000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerTick);
         this._timer.start();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._buffs))
         {
            this._buffs.length = 0;
            this._buffs = null;
         }
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timerTick);
         this._timer.stop();
         this._timer = null;
         super.dispose();
      }
      
      private function __timerTick(event:TimerEvent) : void
      {
         this.validBuff();
         if(this._isMouseOver)
         {
            ShowTipManager.Instance.showTip(this);
         }
      }
      
      private function validBuff() : void
      {
         var unValidedCount:int = 0;
         var buff:BuffInfo = null;
         if(this._isActived)
         {
            unValidedCount = 0;
            for each(buff in this._buffs)
            {
               buff.calculatePayBuffValidDay();
               if(!buff.valided)
               {
                  unValidedCount++;
               }
            }
            if(unValidedCount >= this._buffs.length)
            {
               this.setAcived(false);
            }
         }
      }
      
      override protected function __onclick(evt:MouseEvent) : void
      {
         if(!CanClick)
         {
            return;
         }
         this.shop();
      }
      
      private function shop() : void
      {
         var item:ShopItemInfo = null;
         var carItem:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         var list:Array = [];
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Caddy_Good);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Save_Life);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Agility_Get);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.ReHealth);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Train_Good);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Level_Try);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Card_Get);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         var setspayFrame:SetsShopView = new SetsShopView();
         setspayFrame.initialize(list);
         LayerManager.Instance.addToLayer(setspayFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         ShowTipManager.Instance.hideTip(this);
      }
      
      public function addBuff(buff:BuffInfo) : void
      {
         for(var i:int = 0; i < this._buffs.length; i++)
         {
            if(this._buffs[i].Type == buff.Type)
            {
               this._buffs[i] = buff;
               this.setAcived(true);
               return;
            }
         }
         this._buffs.push(buff);
         this.setAcived(true);
         this.__timerTick(null);
      }
      
      public function setAcived(val:Boolean) : void
      {
         if(this._isActived == val)
         {
            return;
         }
         this._isActived = val;
         if(this._isActived)
         {
            filters = null;
         }
         else
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      override protected function __onMouseOver(evt:MouseEvent) : void
      {
         if(this._isActived)
         {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
         this._isMouseOver = true;
      }
      
      override protected function __onMouseOut(evt:MouseEvent) : void
      {
         if(this._isActived)
         {
            filters = null;
         }
         this._isMouseOver = false;
      }
      
      override public function get tipData() : Object
      {
         _tipData = new BuffTipInfo();
         this.validBuff();
         if(Boolean(_info))
         {
            _tipData.isActive = this._isActived;
            _tipData.describe = this._isActived ? "" : LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Note");
            _tipData.name = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Name");
            _tipData.isFree = false;
            _tipData.linkBuffs = this._buffs;
         }
         return _tipData;
      }
   }
}

