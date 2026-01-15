package enchant.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.data.BagInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import enchant.EnchantManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import shop.manager.ShopBuyManager;
   import store.HelpFrame;
   import store.HelpPrompt;
   
   public class EnchantMainView extends Sprite implements Disposeable
   {
      
      private var _itemBg:Bitmap;
      
      private var _enchantValueTxt:FilterFrameText;
      
      private var _enchantDesc:FilterFrameText;
      
      private var _bagCell:BagCell;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _upGradeBtn:SelectedCheckButton;
      
      private var _enchantBtn:SimpleBitmapButton;
      
      private var _successMc:MovieClip;
      
      private var _enchantMc:MovieClip;
      
      private var _expBar:EnchantExpBar;
      
      private var _equipListView:EnchantBagListView;
      
      private var _propListView:EnchantBagListView;
      
      private var _leftDrapSprite:EnchantLeftDragSprite;
      
      private var _itemCell:EnchantItemCell;
      
      private var _equipCell:EnchantEquipCell;
      
      public var updateEquipCellFunc:Function;
      
      public var updateEquipCellInfo:InventoryItemInfo;
      
      private var _helpBtn:BaseButton;
      
      private var _lastExaltTime:int = 0;
      
      public function EnchantMainView()
      {
         super();
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._enchantCompHander);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._enchantProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ENCHANT);
      }
      
      protected function _enchantProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.ENCHANT)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function _enchantCompHander(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.ENCHANT)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._enchantCompHander);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._enchantProgress);
            this.initView();
            this.initEvent();
            this.createAcceptDragSprite();
         }
      }
      
      private function initView() : void
      {
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HelpButton");
         addChild(this._helpBtn);
         this._helpBtn.x = 625;
         this._helpBtn.y = -58;
         this._itemBg = ComponentFactory.Instance.creatBitmap("asset.enchant.itemBg");
         addChild(this._itemBg);
         this._enchantValueTxt = ComponentFactory.Instance.creatComponentByStylename("enchant.valueTxt");
         addChild(this._enchantValueTxt);
         this._enchantValueTxt.text = LanguageMgr.GetTranslation("enchant.valueTxt");
         this._enchantDesc = ComponentFactory.Instance.creatComponentByStylename("enchant.descTxt");
         addChild(this._enchantDesc);
         this._enchantDesc.text = LanguageMgr.GetTranslation("enchant.descTxt");
         this._enchantBtn = ComponentFactory.Instance.creatComponentByStylename("enchant.enchantBtn");
         addChild(this._enchantBtn);
         var info:ItemTemplateInfo = ItemManager.Instance.getTemplateById(EnchantManager.instance.soulStoneId);
         this._bagCell = new BagCell(0,info);
         PositionUtils.setPos(this._bagCell,"enchant.bagCellPos");
         addChild(this._bagCell);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("enchant.buyBtn");
         addChild(this._buyBtn);
         this._upGradeBtn = ComponentFactory.Instance.creatComponentByStylename("enchant.upGrade");
         addChild(this._upGradeBtn);
         this._expBar = new EnchantExpBar();
         this._expBar.upGradeFunc = this.showSuccessMovie;
         addChild(this._expBar);
         this._expBar.x = 84;
         this._expBar.y = 175;
         this._equipListView = new EnchantBagListView();
         this._equipListView.setup(0,null,21);
         PositionUtils.setPos(this._equipListView,"enchant.bagListPos");
         addChild(this._equipListView);
         this._propListView = new EnchantBagListView();
         PositionUtils.setPos(this._propListView,"enchant.proBagListPos");
         this._propListView.setup(1,null,21);
         addChild(this._propListView);
         this.refreshBagList();
         this._equipCell = new EnchantEquipCell(1,0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         this._equipCell.BGVisible = false;
         PositionUtils.setPos(this._equipCell,"enchant.equipCellPos");
         addChild(this._equipCell);
         this._equipCell.setContentSize(68,68);
         this._equipCell.tipDirctions = "5,2,7";
         this._equipCell.PicPos = new Point(-3,-5);
         this._itemCell = new EnchantItemCell(0,0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         PositionUtils.setPos(this._itemCell,"enchant.itemCellPos");
         this._itemCell.BGVisible = false;
         addChild(this._itemCell);
      }
      
      private function initEvent() : void
      {
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__showHelpFrame);
         this._enchantBtn.addEventListener(MouseEvent.CLICK,this.__enchantHandler);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buySoulStoneHander);
         this._equipListView.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._equipListView.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._propListView.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._propListView.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
      }
      
      protected function __showHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var helpBd:HelpPrompt = ComponentFactory.Instance.creat("enchant.ComposeHelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("enchant.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("enchant.help.title");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initProgress(isUpdate:Boolean) : void
      {
         if(!this._equipCell || !this._equipCell.info)
         {
            this._expBar.initPercentAndTip();
            return;
         }
         var curLevel:int = (this._equipCell.info as InventoryItemInfo).MagicLevel;
         var isFull:Boolean = curLevel >= EnchantManager.instance.infoVec.length;
         var curExp:Number = EnchantManager.instance.getEnchantInfoByLevel(curLevel).Exp;
         var exp:Number = isFull ? 0 : (this._equipCell.info as InventoryItemInfo).MagicExp - curExp;
         var sumExp:Number = isFull ? 0 : EnchantManager.instance.getEnchantInfoByLevel(curLevel + 1).Exp - curExp;
         if(isUpdate)
         {
            this._enchantBtn.enable = EnchantManager.instance.isUpGrade == false;
            this._expBar.updateProgress(exp,sumExp,EnchantManager.instance.isUpGrade);
         }
         else
         {
            this._expBar.initProgress(exp,sumExp);
         }
      }
      
      protected function __updateStoreBag(event:BagEvent) : void
      {
         var place:String = null;
         var itemPlace:int = 0;
         var info:InventoryItemInfo = null;
         for(place in event.changedSlots)
         {
            itemPlace = int(place);
            info = PlayerManager.Instance.Self.StoreBag.items[itemPlace];
            if(itemPlace == 0)
            {
               this._itemCell.info = info;
            }
            else if(itemPlace == 1)
            {
               if(this._leftDrapSprite.equipCellActionState)
               {
                  this._equipCell.info = info;
                  this.initProgress(false);
                  this._leftDrapSprite.equipCellActionState = false;
               }
               else
               {
                  if(EnchantManager.instance.isUpGrade)
                  {
                     this.updateEquipCellInfo = info;
                     this.updateEquipCellFunc = this.updateEquipCell;
                  }
                  else
                  {
                     this._equipCell.info = info;
                  }
                  this.initProgress(true);
               }
            }
         }
      }
      
      public function updateEquipCell() : void
      {
         this._equipCell.info = this.updateEquipCellInfo;
      }
      
      private function cellClickHandler(event:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var cell:BagCell = event.data as BagCell;
         cell.dragStart();
      }
      
      protected function __cellDoubleClick(evt:CellEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var info:InventoryItemInfo = (evt.data as BagCell).info as InventoryItemInfo;
         if(info.MagicLevel >= EnchantManager.instance.infoVec.length)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("enchant.cannotUp"));
            return;
         }
         if(evt.target == this._propListView)
         {
            SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,0,info.Count,true);
         }
         else
         {
            this._leftDrapSprite.equipCellActionState = true;
            SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,1,1);
         }
      }
      
      protected function __buySoulStoneHander(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _shopItemInfo:ShopItemInfo = ShopManager.Instance.getShopItemByGoodsID(EnchantManager.instance.soulStoneGoodsId);
         ShopBuyManager.Instance.buy(_shopItemInfo.GoodsID,_shopItemInfo.isDiscount,_shopItemInfo.getItemPrice(1).PriceType);
      }
      
      private function removeFromStageHandler(event:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(evt:ShortcutBuyEvent) : void
      {
         evt.stopImmediatePropagation();
      }
      
      private function createAcceptDragSprite() : void
      {
         this._leftDrapSprite = new EnchantLeftDragSprite();
         this._leftDrapSprite.mouseEnabled = false;
         this._leftDrapSprite.mouseChildren = false;
         this._leftDrapSprite.graphics.beginFill(0,0);
         this._leftDrapSprite.graphics.drawRect(0,0,347,404);
         this._leftDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._leftDrapSprite,"enchant.leftDrapSpritePos");
         addChild(this._leftDrapSprite);
      }
      
      protected function __enchantHandler(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.playButtonSound();
         var time:int = getTimer();
         if(time - this._lastExaltTime > 1400)
         {
            this._lastExaltTime = time;
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(this._equipCell.info == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("enchant.noEquip"));
               return;
            }
            if(this._itemCell.info == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("enchant.noSouleStone"));
               return;
            }
            if((this._equipCell.info as InventoryItemInfo).MagicLevel >= EnchantManager.instance.infoVec.length)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("enchant.cannotUp"));
               return;
            }
            if(!this._equipCell.itemInfo.IsBinds && this._itemCell.itemInfo.IsBinds)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
            }
            else
            {
               this.showEnchantMovie();
               SocketManager.Instance.out.sendEnchant(this._upGradeBtn.selected);
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
         }
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = BaseAlerFrame(e.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.showEnchantMovie();
            SocketManager.Instance.out.sendEnchant(this._upGradeBtn.selected);
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function showEnchantMovie() : void
      {
         if(Boolean(this._enchantMc))
         {
            this._enchantMc.stop();
         }
         ObjectUtils.disposeObject(this._enchantMc);
         this._enchantMc = null;
         this._enchantMc = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.movieII",this);
         PositionUtils.setPos(this._enchantMc,"enchant.moviePos");
         this._enchantMc.gotoAndPlay(1);
         this._enchantMc.addFrameScript(this._enchantMc.totalFrames - 1,this.disposeExaltMovie);
      }
      
      private function disposeExaltMovie() : void
      {
         if(Boolean(this._enchantMc))
         {
            this._enchantMc.stop();
         }
         ObjectUtils.disposeObject(this._enchantMc);
         this._enchantMc = null;
      }
      
      private function showSuccessMovie() : void
      {
         if(Boolean(this._successMc))
         {
            this._successMc.stop();
         }
         ObjectUtils.disposeObject(this._successMc);
         this._successMc = null;
         this._successMc = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.movieI",this);
         this._successMc.gotoAndPlay(1);
         PositionUtils.setPos(this._successMc,"enchant.moviePos2");
         this._successMc.addFrameScript(this._successMc.totalFrames - 1,this.disposeSuccessMovie);
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(value)
         {
            this.refreshBagList();
            this.addUpdateStoreEvent();
            if(Boolean(this._expBar))
            {
               this._expBar.initPercentAndTip();
            }
         }
         else
         {
            SocketManager.Instance.out.sendClearStoreBag();
            this.clearCellInfo();
            this._expBar.initProgress(0,0);
            this.removeUpdateStoreEvent();
         }
      }
      
      private function refreshBagList() : void
      {
         if(Boolean(this._equipListView))
         {
            this._equipListView.setData(EnchantManager.instance.model.canEnchantEquipList);
         }
         if(Boolean(this._propListView))
         {
            this._propListView.setData(EnchantManager.instance.model.canEnchantPropList);
         }
      }
      
      public function addUpdateStoreEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
      }
      
      public function removeUpdateStoreEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
      }
      
      public function clearCellInfo() : void
      {
         if(Boolean(this._equipCell))
         {
            this._equipCell.info = null;
         }
         if(Boolean(this._itemCell))
         {
            this._itemCell.info = null;
         }
      }
      
      private function disposeSuccessMovie() : void
      {
         if(Boolean(this._successMc))
         {
            this._successMc.stop();
         }
         ObjectUtils.disposeObject(this._successMc);
         this._successMc = null;
         EnchantManager.instance.isUpGrade = false;
         if(this.updateEquipCellFunc != null)
         {
            this.updateEquipCellFunc();
         }
         this._enchantBtn.enable = EnchantManager.instance.isUpGrade == false;
      }
      
      private function removeEvent() : void
      {
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__showHelpFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._enchantCompHander);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._enchantProgress);
         this._enchantBtn.removeEventListener(MouseEvent.CLICK,this.__enchantHandler);
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__buySoulStoneHander);
         this._equipListView.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._equipListView.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._propListView.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._propListView.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeExaltMovie();
         this.disposeSuccessMovie();
         ObjectUtils.disposeAllChildren(this);
         this._helpBtn = null;
         this._expBar = null;
         this._itemBg = null;
         this._enchantValueTxt = null;
         this._enchantDesc = null;
         this._enchantBtn = null;
         this._buyBtn = null;
         this._upGradeBtn = null;
         this._bagCell = null;
         this._equipListView = null;
         this._propListView = null;
         this._leftDrapSprite = null;
         this._equipCell = null;
         this._itemCell = null;
      }
   }
}

