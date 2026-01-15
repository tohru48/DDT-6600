package store.forge
{
   import bagAndInfo.bag.RichesButton;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import flash.display.Shape;
   import flash.display.Sprite;
   import store.StoreBagBgWHPoint;
   import store.view.storeBag.StoreBagbgbmp;
   
   public class ForgeRightBgView extends Sprite implements Disposeable
   {
      
      private var _bitmapBg:StoreBagbgbmp;
      
      private var bagBg:ScaleFrameImage;
      
      private var _equipmentsColumnBg:Image;
      
      private var _itemsColumnBg:Image;
      
      public var msg_txt:ScaleFrameImage;
      
      private var goldTxt:FilterFrameText;
      
      private var moneyTxt:FilterFrameText;
      
      private var giftTxt:FilterFrameText;
      
      private var _goldButton:RichesButton;
      
      private var _giftButton:RichesButton;
      
      private var _moneyButton:RichesButton;
      
      private var _bgPoint:StoreBagBgWHPoint;
      
      private var _bgShape:Shape;
      
      private var _equipmentTitleText:FilterFrameText;
      
      private var _itemTitleText:FilterFrameText;
      
      private var _equipmentTipText:FilterFrameText;
      
      private var _itemTipText:FilterFrameText;
      
      public function ForgeRightBgView()
      {
         super();
         this.initView();
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function initView() : void
      {
         this._bitmapBg = new StoreBagbgbmp();
         addChildAt(this._bitmapBg,0);
         this.bagBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagViewBg2");
         this.bagBg.setFrame(1);
         addChild(this.bagBg);
         this._equipmentTitleText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.EquipmentTitleText");
         this._equipmentTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.EquipmentTitleText");
         this._itemTitleText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.ItemTitleText");
         this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
         this._equipmentTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.EquipmentTipText");
         this._itemTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.ItemTipText");
         addChild(this._equipmentTitleText);
         addChild(this._itemTitleText);
         addChild(this._equipmentTipText);
         addChild(this._itemTipText);
         var showMoneyBG:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.MoneyPanelBg");
         addChild(showMoneyBG);
         this.moneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.TicketText");
         addChild(this.moneyTxt);
         this._goldButton = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagView.GoldButton");
         this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         addChild(this._goldButton);
         this.giftTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.GiftText");
         addChild(this.giftTxt);
         this._giftButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.GiftButton");
         this._giftButton = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagView.GiftButton");
         var levelNum:int = int(ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel));
         this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections",levelNum.toString());
         addChild(this._giftButton);
         this._moneyButton = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagView.MoneyButton");
         this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
         addChild(this._moneyButton);
         this.goldTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.GoldText");
         addChild(this.goldTxt);
         this.updateMoney();
      }
      
      private function __propertyChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["Money"]) || Boolean(evt.changedProperties["Gold"]) || Boolean(evt.changedProperties[PlayerInfo.DDT_MONEY]) || Boolean(evt.changedProperties[PlayerInfo.BandMONEY]))
         {
            this.updateMoney();
         }
      }
      
      public function showStoreBagViewText(equipmentTip:String, itemTip:String, isShowItemTip:Boolean = true) : void
      {
         this._equipmentTipText.text = LanguageMgr.GetTranslation(equipmentTip);
         if(isShowItemTip)
         {
            this._itemTipText.text = LanguageMgr.GetTranslation(itemTip);
         }
         this._itemTipText.visible = isShowItemTip;
         this._itemTitleText.visible = isShowItemTip;
      }
      
      private function updateMoney() : void
      {
         this.goldTxt.text = String(PlayerManager.Instance.Self.Gold);
         this.moneyTxt.text = String(PlayerManager.Instance.Self.Money);
         this.giftTxt.text = String(PlayerManager.Instance.Self.BandMoney);
      }
      
      public function dispose() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

