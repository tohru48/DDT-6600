package dragonBoat.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import dragonBoat.DragonBoatManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
   public class DragonBoatShopCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _needMoneyTxt:FilterFrameText;
      
      private var _cannotBuyTipTxt:FilterFrameText;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _itemCell:ShopItemCell;
      
      private var _shopItemInfo:ShopItemInfo;
      
      public function DragonBoatShopCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.shopFrame.cellBg");
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.coinTxt");
         this._moneyTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.shopCellMoneyTxt");
         PositionUtils.setPos(this._moneyTxt,"dragonBoat.shopFrame.cellMoneyTxtPos");
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.cellBuyBtn");
         this._buyBtn.visible = false;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.cellNameTxt");
         this._needMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.cellNeedMoneyTxt");
         this._cannotBuyTipTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.cellCannotBuyTipTxt");
         this._cannotBuyTipTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.shopScoreNotEnough");
         this._cannotBuyTipTxt.visible = false;
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,70,70);
         sp.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
         PositionUtils.setPos(this._itemCell,"dragonBoat.shopFrame.cellItemCellPos");
         addChild(this._bg);
         addChild(this._moneyTxt);
         addChild(this._buyBtn);
         addChild(this._nameTxt);
         addChild(this._needMoneyTxt);
         addChild(this._cannotBuyTipTxt);
         addChild(this._itemCell);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.buyHandler,false,0,true);
      }
      
      private function buyHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var buyFrame:DragonBoatBuyFrame = ComponentFactory.Instance.creatComponentByStylename("DragonBoatBuyFrame");
         buyFrame.shopItem = this._shopItemInfo;
         LayerManager.Instance.addToLayer(buyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function refreshShow(value:ShopItemInfo) : void
      {
         this._shopItemInfo = value;
         if(Boolean(this._shopItemInfo))
         {
            this._itemCell.visible = true;
            this._nameTxt.visible = true;
            this._needMoneyTxt.visible = true;
            this._buyBtn.visible = true;
            this._cannotBuyTipTxt.visible = true;
            this._moneyTxt.visible = true;
            this._itemCell.info = this._shopItemInfo.TemplateInfo;
            this._itemCell.tipInfo = this._shopItemInfo;
            this._nameTxt.text = this._itemCell.info.Name;
            this._needMoneyTxt.text = this._shopItemInfo.AValue1.toString();
            if(int(this._needMoneyTxt.text) > DragonBoatManager.instance.useableScore)
            {
               this._buyBtn.visible = false;
               this._cannotBuyTipTxt.visible = true;
               this._itemCell.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            }
            else
            {
               this._buyBtn.visible = true;
               this._cannotBuyTipTxt.visible = false;
               this._itemCell.filters = null;
            }
         }
         else
         {
            this._itemCell.visible = false;
            this._nameTxt.visible = false;
            this._needMoneyTxt.visible = false;
            this._buyBtn.visible = false;
            this._cannotBuyTipTxt.visible = false;
            this._moneyTxt.visible = false;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._moneyTxt = null;
         this._buyBtn = null;
         this._nameTxt = null;
         this._needMoneyTxt = null;
         this._cannotBuyTipTxt = null;
         this._itemCell = null;
         this._shopItemInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

