package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.ColorEditor;
   import ddt.view.character.RoomCharacter;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class ShopLeftViewPropCollection
   {
      
      public static const PLAYER_MAX_EQUIP_CNT:uint = 8;
      
      private var itemList:Vector.<ShopCartItem>;
      
      public var bg:MutipleImage;
      
      public var btnClearLastEquip:BaseButton;
      
      public var cartList:VBox;
      
      public var cartScroll:ScrollPanel;
      
      public var cbHideGlasses:SelectedCheckButton;
      
      public var cbHideHat:SelectedCheckButton;
      
      public var cbHideSuit:SelectedCheckButton;
      
      public var cbHideWings:SelectedCheckButton;
      
      public var colorEditor:ColorEditor;
      
      public var dressView:Sprite;
      
      public var femaleCharacter:RoomCharacter;
      
      public var infoBg:DisplayObject;
      
      public var fittingRoomText:Bitmap;
      
      public var lastItem:ShopPlayerCell;
      
      public var maleCharacter:RoomCharacter;
      
      public var middlePanelBg:ScaleFrameImage;
      
      public var leftMoneyPanelBuyBtn:BaseButton;
      
      public var muteLock:Boolean;
      
      public var panelBtnGroup:SelectedButtonGroup;
      
      public var panelCartBtn:SelectedTextButton;
      
      public var panelColorBtn:SelectedTextButton;
      
      public var playerCells:Vector.<ShopPlayerCell>;
      
      public var playerGiftTxt:FilterFrameText;
      
      public var playerMoneyTxt:FilterFrameText;
      
      public var presentBtn:BaseButton;
      
      public var purchaseBtn:IconButton;
      
      public var checkOutPanel:ShopCheckOutView;
      
      public var saveFigureBtn:BaseButton;
      
      public var addedManNewEquip:int = 0;
      
      public var addedWomanNewEquip:int = 0;
      
      public var purchaseView:Sprite;
      
      public var adjustColorView:Sprite;
      
      public var presentEffet:IEffect;
      
      public var purchaseEffet:IEffect;
      
      public var askBtnEffet:IEffect;
      
      public var saveFigureEffet:IEffect;
      
      public var colorEffet:IEffect;
      
      public var canShine:Boolean;
      
      public var cartItemList:Sprite;
      
      public var randomBtn:TextButton;
      
      private var moneyPanelTipText:FilterFrameText;
      
      private var playerNameText:FilterFrameText;
      
      private var rankingLabelText:FilterFrameText;
      
      private var rankingText:FilterFrameText;
      
      public var askBtn:SimpleBitmapButton;
      
      public function ShopLeftViewPropCollection()
      {
         super();
      }
      
      public function addItemToList($item:ShopCartItem) : void
      {
         var len:int = int(this.itemList.length);
         if(len > 0)
         {
            $item.y = this.itemList[len - 1].y + this.itemList[len - 1].height;
         }
         else
         {
            $item.y = 0;
         }
         this.itemList.push($item);
         $item.id = this.itemList.length - 1;
         this.cartItemList.addChild($item);
      }
      
      public function setup() : void
      {
         var cell:ShopPlayerCell = null;
         this.itemList = new Vector.<ShopCartItem>();
         this.cartItemList = new Sprite();
         this.panelBtnGroup = new SelectedButtonGroup();
         this.playerCells = new Vector.<ShopPlayerCell>();
         this.dressView = new Sprite();
         this.dressView.x = 1;
         this.dressView.y = -1;
         this.purchaseView = new Sprite();
         this.adjustColorView = new Sprite();
         this.lastItem = CellFactory.instance.createShopColorItemCell() as ShopPlayerCell;
         this.bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.LeftViewBg");
         this.infoBg = ComponentFactory.Instance.creatCustomObject("ddtshop.BodyInfoBg");
         this.fittingRoomText = ComponentFactory.Instance.creatBitmap("asset.ddtshop.FittingRoomText");
         this.playerNameText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PlayerNameText");
         this.playerNameText.text = PlayerManager.Instance.Self.NickName;
         this.rankingLabelText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RankingLabelText");
         this.rankingLabelText.text = LanguageMgr.GetTranslation("shop.ShopLeftView.BodyInfo.RankingtLabel");
         this.rankingText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RankingText");
         this.rankingText.text = PlayerManager.Instance.Self.Repute.toString();
         this.middlePanelBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.LeftMiddlePanelBg");
         this.leftMoneyPanelBuyBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.LeftMoneyPanelBuyBtn");
         this.saveFigureBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnSaveFigure");
         this.presentBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnPresent");
         this.purchaseBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnPurchase");
         this.askBtn = ComponentFactory.Instance.creatComponentByStylename("asset.core.askGoodsBtn");
         this.panelCartBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnCartPanel");
         this.panelCartBtn.text = LanguageMgr.GetTranslation("shop.ShopLeftView.CartPaneText");
         this.panelColorBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnColorPanel");
         this.panelColorBtn.text = LanguageMgr.GetTranslation("shop.ShopLeftView.ColorPaneText");
         this.btnClearLastEquip = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnClearLastEquip");
         this.btnClearLastEquip.tipData = LanguageMgr.GetTranslation("");
         this.moneyPanelTipText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.MoneyPanelTipText");
         this.moneyPanelTipText.text = LanguageMgr.GetTranslation("shop.ShopLeftView.MoneyPanelTip");
         this.playerMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PlayerMoney");
         PositionUtils.setPos(this.playerMoneyTxt,"ddtshop.playerMoneyTxtPos");
         this.playerGiftTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PlayerGift");
         PositionUtils.setPos(this.playerGiftTxt,"ddtshop.playerGiftTxtPos");
         this.cartScroll = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemList");
         this.cartList = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemContainer");
         this.cbHideGlasses = ComponentFactory.Instance.creatComponentByStylename("ddtshop.HideGlassesCb");
         this.cbHideHat = ComponentFactory.Instance.creatComponentByStylename("ddtshop.HideHatCb");
         this.cbHideSuit = ComponentFactory.Instance.creatComponentByStylename("ddtshop.HideSuitCb");
         this.cbHideWings = ComponentFactory.Instance.creatComponentByStylename("ddtshop.HideWingsCb");
         this.colorEditor = ComponentFactory.Instance.creatCustomObject("ddtshop.ColorEdit");
         this.checkOutPanel = ComponentFactory.Instance.creatCustomObject("ddtshop.CheckOutView");
         this.presentEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.presentBtn);
         this.purchaseEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.purchaseBtn,{"color":EffectColorType.GOLD});
         this.saveFigureEffet = EffectManager.Instance.creatEffect(EffectTypes.SHINER_ANIMATION,this.saveFigureBtn,{"color":EffectColorType.GOLD});
         this.askBtnEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.askBtn,{"color":EffectColorType.GOLD});
         this.btnClearLastEquip.tipData = LanguageMgr.GetTranslation("shop.ShopLeftView.BodyInfo.LastEquipTipText");
         this.muteLock = false;
         this.middlePanelBg.setFrame(1);
         this.cartScroll.vScrollProxy = ScrollPanel.ON;
         this.cartScroll.setView(this.cartItemList);
         this.cartScroll.invalidateViewport(true);
         this.cartScroll.vUnitIncrement = 15;
         this.cartScroll.visible = false;
         this.cartList.strictSize = 66;
         this.cartList.isReverAdd = true;
         this.panelBtnGroup.addSelectItem(this.panelCartBtn);
         this.panelBtnGroup.addSelectItem(this.panelColorBtn);
         this.panelColorBtn.displacement = false;
         this.panelCartBtn.displacement = false;
         this.panelBtnGroup.selectIndex = 0;
         this.saveFigureBtn.enable = false;
         this.presentBtn.enable = false;
         this.askBtn.enable = false;
         this.purchaseBtn.enable = false;
         this.panelColorBtn.enable = false;
         this.leftMoneyPanelBuyBtn.enable = false;
         this.playerMoneyTxt.text = String(PlayerManager.Instance.Self.Money);
         this.playerGiftTxt.text = String(PlayerManager.Instance.Self.BandMoney);
         this.colorEditor.visible = false;
         this.colorEditor.restorable = false;
         this.lastItem.visible = false;
         PositionUtils.setPos(this.lastItem,"ddtshop.LastItemPos");
         this.canShine = true;
         this.dressView.addChild(this.infoBg);
         this.dressView.addChild(this.saveFigureBtn);
         this.dressView.addChild(this.btnClearLastEquip);
         this.dressView.addChild(this.cbHideGlasses);
         this.dressView.addChild(this.cbHideHat);
         this.dressView.addChild(this.cbHideSuit);
         this.dressView.addChild(this.cbHideWings);
         this.purchaseView.addChild(this.moneyPanelTipText);
         this.purchaseView.addChild(this.playerMoneyTxt);
         this.purchaseView.addChild(this.playerGiftTxt);
         this.purchaseView.addChild(this.leftMoneyPanelBuyBtn);
         for(var i:int = 0; i < PLAYER_MAX_EQUIP_CNT; i++)
         {
            cell = CellFactory.instance.createShopPlayerItemCell() as ShopPlayerCell;
            PositionUtils.setPos(cell,"ddtshop.PlayerCellPos_" + String(i));
            this.playerCells.push(cell);
            this.dressView.addChild(cell);
         }
         this.randomBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnRandom");
         this.randomBtn.text = LanguageMgr.GetTranslation("shop.ShopLeftView.BodyInfo.RandomBtnText");
         this.randomBtn.tipData = LanguageMgr.GetTranslation("shop.ShopLeftView.BodyInfo.RandomBtnTipText");
      }
      
      public function addChildrenTo(display:DisplayObjectContainer) : void
      {
         display.addChild(this.bg);
         display.addChild(this.middlePanelBg);
         display.addChild(this.presentBtn);
         display.addChild(this.purchaseBtn);
         display.addChild(this.askBtn);
         display.addChild(this.panelCartBtn);
         display.addChild(this.panelColorBtn);
         display.addChild(this.dressView);
         display.addChild(this.colorEditor);
         display.addChild(this.purchaseView);
         display.addChild(this.cartScroll);
         display.addChild(this.lastItem);
         display.addChild(this.randomBtn);
         display.addChild(this.playerNameText);
         display.addChild(this.rankingLabelText);
         display.addChild(this.rankingText);
         display.addChild(this.fittingRoomText);
      }
      
      public function disposeAllChildrenFrom(display:DisplayObjectContainer) : void
      {
         EffectManager.Instance.removeEffect(this.presentEffet);
         EffectManager.Instance.removeEffect(this.purchaseEffet);
         EffectManager.Instance.removeEffect(this.saveFigureEffet);
         EffectManager.Instance.removeEffect(this.askBtnEffet);
         ObjectUtils.disposeAllChildren(this.colorEditor);
         ObjectUtils.disposeAllChildren(this.dressView);
         ObjectUtils.disposeAllChildren(this.purchaseView);
         ObjectUtils.disposeAllChildren(display);
         ObjectUtils.disposeObject(this.moneyPanelTipText);
         this.panelBtnGroup.dispose();
         this.panelBtnGroup = null;
         for(var i:int = 0; i < this.playerCells.length; this.playerCells[i] = null,i++)
         {
         }
         this.dressView = null;
         this.purchaseView = null;
         display = null;
         this.playerCells = null;
         this.dressView = null;
         this.lastItem = null;
         this.bg = null;
         this.infoBg = null;
         this.middlePanelBg = null;
         this.leftMoneyPanelBuyBtn = null;
         this.saveFigureBtn = null;
         this.presentBtn = null;
         this.purchaseBtn = null;
         this.panelCartBtn = null;
         this.panelColorBtn = null;
         this.moneyPanelTipText = null;
         this.btnClearLastEquip = null;
         this.playerMoneyTxt = null;
         this.playerGiftTxt = null;
         this.cartScroll = null;
         this.cartList = null;
         this.cbHideGlasses = null;
         this.cbHideHat = null;
         this.cbHideSuit = null;
         this.colorEditor = null;
         this.randomBtn = null;
         this.askBtn = null;
      }
   }
}

