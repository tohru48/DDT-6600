package store.view.transfer
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.view.ConsortiaRateManager;
   import store.view.StoneCellFrame;
   
   public class StoreIITransferBG extends Sprite implements IStoreViewBG
   {
      
      private var _bg:MutipleImage;
      
      private var _area:TransferDragInArea;
      
      private var _items:Vector.<TransferItemCell>;
      
      private var _transferBtnAsset:BaseButton;
      
      private var _transferHelpAsset:BaseButton;
      
      private var transShine:MovieImage;
      
      private var transArr:MutipleImage;
      
      private var _pointArray:Vector.<Point>;
      
      private var gold_txt:FilterFrameText;
      
      private var _goldIcon:Image;
      
      private var _transferBefore:Boolean = false;
      
      private var _transferAfter:Boolean = false;
      
      private var _equipmentCell1:StoneCellFrame;
      
      private var _equipmentCell2:StoneCellFrame;
      
      private var _transferArrow:Bitmap;
      
      private var _transferTitleSmall:Bitmap;
      
      private var _transferTitleLarge:Bitmap;
      
      private var _neededGoldTipText:FilterFrameText;
      
      private var _transferBtnAsset_shineEffect:IEffect;
      
      public function StoreIITransferBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var i:int = 0;
         var item:TransferItemCell = null;
         this._transferTitleSmall = ComponentFactory.Instance.creatBitmap("asset.ddtstore.TransferTitleSmall");
         this._transferTitleLarge = ComponentFactory.Instance.creatBitmap("asset.ddtstore.TransferTitleLarge");
         addChild(this._transferTitleSmall);
         addChild(this._transferTitleLarge);
         this._equipmentCell1 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransferBG.EquipmentCell1");
         this._equipmentCell2 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransferBG.EquipmentCell2");
         this._equipmentCell1.label = this._equipmentCell2.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
         addChild(this._equipmentCell1);
         addChild(this._equipmentCell2);
         this._transferArrow = ComponentFactory.Instance.creatBitmap("asset.ddtstore.TransferArrow");
         addChild(this._transferArrow);
         this._transferBtnAsset = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.TransferBtn");
         addChild(this._transferBtnAsset);
         this._transferBtnAsset_shineEffect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION,this._transferBtnAsset,{"color":EffectColorType.GOLD});
         this._transferHelpAsset = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HelpButton");
         addChild(this._transferHelpAsset);
         this.transArr = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ArrowHeadTransferTip");
         addChild(this.transArr);
         this._neededGoldTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.NeededGoldTipText");
         this._neededGoldTipText.text = LanguageMgr.GetTranslation("store.Transfer.NeededGoldTipText");
         addChild(this._neededGoldTipText);
         this.gold_txt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITarnsferBG.NeedMoneyText");
         addChild(this.gold_txt);
         this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.GoldIcon");
         addChild(this._goldIcon);
         this.getCellsPoint();
         this._items = new Vector.<TransferItemCell>();
         for(i = 0; i < 2; i++)
         {
            item = new TransferItemCell(i);
            item.addEventListener(Event.CHANGE,this.__itemInfoChange);
            item.x = this._pointArray[i].x;
            item.y = this._pointArray[i].y;
            addChild(item);
            this._items.push(item);
         }
         this._area = new TransferDragInArea(this._items);
         addChildAt(this._area,0);
         this.hideArr();
         this.hide();
      }
      
      private function getCellsPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Vector.<Point>();
         for(var i:int = 0; i < 2; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransferBG.Transferpoint" + i);
            this._pointArray.push(point);
         }
      }
      
      private function initEvent() : void
      {
         this._transferBtnAsset.addEventListener(MouseEvent.CLICK,this.__transferHandler);
         this._transferHelpAsset.addEventListener(MouseEvent.CLICK,this.__openHelpHandler);
      }
      
      private function removeEvent() : void
      {
         this._transferBtnAsset.removeEventListener(MouseEvent.CLICK,this.__transferHandler);
         this._transferHelpAsset.removeEventListener(MouseEvent.CLICK,this.__openHelpHandler);
      }
      
      public function startShine(cellId:int) : void
      {
         this._items[cellId].startShine();
      }
      
      public function stopShine() : void
      {
         for(var i:int = 0; i < 2; i++)
         {
            this._items[i].stopShine();
         }
      }
      
      private function showArr() : void
      {
         this.transArr.visible = true;
         this._transferBtnAsset_shineEffect.play();
      }
      
      private function hideArr() : void
      {
         this.transArr.visible = false;
         this._transferBtnAsset_shineEffect.stop();
      }
      
      public function get area() : Vector.<TransferItemCell>
      {
         return this._items;
      }
      
      public function dragDrop(source:BagCell) : void
      {
         var item:TransferItemCell = null;
         if(source == null)
         {
            return;
         }
         var info:InventoryItemInfo = source.info as InventoryItemInfo;
         for each(item in this._items)
         {
            if(item.info == null)
            {
               if(this._items[0].info && this._items[0].info.CategoryID != info.CategoryID || this._items[1].info && this._items[1].info.CategoryID != info.CategoryID)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                  return;
               }
               SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,item.index,1);
               return;
            }
         }
      }
      
      private function __transferHandler(evt:MouseEvent) : void
      {
         var infoText:String = null;
         var alert2:BaseAlerFrame = null;
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         var item1:TransferItemCell = this._items[0] as TransferItemCell;
         var item2:TransferItemCell = this._items[1] as TransferItemCell;
         if(this._showDontClickTip())
         {
            return;
         }
         if(Boolean(item1.info) && Boolean(item2.info))
         {
            if(PlayerManager.Instance.Self.Gold < Number(this.gold_txt.text))
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               alert.moveEnable = false;
               alert.addEventListener(FrameEvent.RESPONSE,this._responseV);
               return;
            }
            this.hideArr();
            this._transferAfter = false;
            this._transferBefore = false;
            infoText = "";
            if(EquipType.isArm(item1.info) || EquipType.isCloth(item1.info) || EquipType.isHead(item1.info) || EquipType.isArm(item2.info) || EquipType.isCloth(item2.info) || EquipType.isHead(item2.info))
            {
               infoText = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.sure2");
            }
            else
            {
               infoText = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.sure");
            }
            alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),infoText,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert2.addEventListener(FrameEvent.RESPONSE,this._responseII);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.EmptyItem"));
         }
      }
      
      private function _responseV(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFastPurchaseGold();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function _response(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.depositAction();
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function _responseII(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = BaseAlerFrame(e.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this._transferAfter = true;
            this._transferBefore = true;
            this.sendSocket();
         }
         else
         {
            this.cannel();
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function cannel() : void
      {
         this.showArr();
      }
      
      private function depositAction() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("setFlashCall");
         }
         navigateToURL(new URLRequest(PathManager.solveFillPage()),"_blank");
      }
      
      private function isComposeStrengthen(info:BagCell) : Boolean
      {
         if(info.itemInfo.StrengthenLevel > 0)
         {
            return true;
         }
         if(info.itemInfo.AttackCompose > 0)
         {
            return true;
         }
         if(info.itemInfo.DefendCompose > 0)
         {
            return true;
         }
         if(info.itemInfo.LuckCompose > 0)
         {
            return true;
         }
         if(info.itemInfo.AgilityCompose > 0)
         {
            return true;
         }
         if(info.itemInfo.MagicLevel > 0)
         {
            return true;
         }
         return false;
      }
      
      private function sendSocket() : void
      {
         SocketManager.Instance.out.sendItemTransfer(this._transferBefore,this._transferAfter);
      }
      
      private function __itemInfoChange(evt:Event) : void
      {
         this.gold_txt.text = "0";
         var item1:TransferItemCell = this._items[0];
         var item2:TransferItemCell = this._items[1];
         if(Boolean(item1.info))
         {
            item1.categoryId = -1;
            if(Boolean(item2.info))
            {
               item1.categoryId = item1.info.CategoryID;
            }
            item2.categoryId = item1.info.CategoryID;
         }
         else
         {
            item2.categoryId = -1;
            if(Boolean(item2.info))
            {
               item1.categoryId = item2.info.CategoryID;
            }
            else
            {
               item1.categoryId = -1;
            }
         }
         if(Boolean(item1.info))
         {
            item1.Refinery = item2.Refinery = item1.info.RefineryLevel;
         }
         else if(Boolean(item2.info))
         {
            item1.Refinery = item2.Refinery = item2.info.RefineryLevel;
         }
         else
         {
            item1.Refinery = item2.Refinery = -1;
         }
         if(Boolean(item1.info) && Boolean(item2.info))
         {
            if(item1.info.CategoryID != item2.info.CategoryID)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.put"));
               return;
            }
            if(this.isComposeStrengthen(item1) || this.isOpenHole(item1) || this.isHasBead(item1) || this.isComposeStrengthen(item2) || this.isOpenHole(item2) || this.isHasBead(item2) || item1.itemInfo.isHasLatentEnergy || item2.itemInfo.isHasLatentEnergy)
            {
               this.showArr();
               this.goldMoney();
            }
            else
            {
               this.hideArr();
            }
         }
         else
         {
            this.hideArr();
         }
         if(Boolean(item1.info) && !item2.info)
         {
            ConsortiaRateManager.instance.sendTransferShowLightEvent(item1.info,true);
         }
         else if(Boolean(item2.info) && !item1.info)
         {
            ConsortiaRateManager.instance.sendTransferShowLightEvent(item2.info,true);
         }
         else
         {
            ConsortiaRateManager.instance.sendTransferShowLightEvent(null,false);
         }
      }
      
      private function _showDontClickTip() : Boolean
      {
         var item1:TransferItemCell = this._items[0];
         var item2:TransferItemCell = this._items[1];
         if(item1.info == null && item2.info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.NoItem"));
            return true;
         }
         if(item1.info == null || item2.info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.EmptyItem"));
            return true;
         }
         if(!this.isComposeStrengthen(item1) && !this.isOpenHole(item1) && !this.isHasBead(item1) && !this.isComposeStrengthen(item2) && !this.isOpenHole(item2) && !this.isHasBead(item2) && !item1.itemInfo.isHasLatentEnergy && !item2.itemInfo.isHasLatentEnergy)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.transfer.dontTransferII"));
            return true;
         }
         return false;
      }
      
      private function isHasBead(info:BagCell) : Boolean
      {
         var item:InventoryItemInfo = info.itemInfo;
         return item.Hole1 + item.Hole2 + item.Hole3 + item.Hole4 + item.Hole5 + item.Hole6 > 0;
      }
      
      private function isOpenHole(info:BagCell) : Boolean
      {
         if(info.itemInfo.Hole5Level > 0 || info.itemInfo.Hole6Level > 0 || info.itemInfo.Hole5Exp > 0 || info.itemInfo.Hole6Exp > 0)
         {
            return true;
         }
         return false;
      }
      
      private function goldMoney() : void
      {
         this.gold_txt.text = ServerConfigManager.instance.TransferStrengthenEx;
      }
      
      public function show() : void
      {
         this.initEvent();
         this.visible = true;
         this.updateData();
      }
      
      public function refreshData(items:Dictionary) : void
      {
         var place:String = null;
         var itemPlace:int = 0;
         for(place in items)
         {
            itemPlace = int(place);
            if(itemPlace < this._items.length)
            {
               this._items[itemPlace].info = PlayerManager.Instance.Self.StoreBag.items[itemPlace];
            }
         }
      }
      
      public function updateData() : void
      {
         for(var i:int = 0; i < 2; i++)
         {
            this._items[i].info = PlayerManager.Instance.Self.StoreBag.items[i];
         }
      }
      
      public function hide() : void
      {
         this.removeEvent();
         this.visible = false;
         this.hideArr();
      }
      
      private function __openHelpHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         var helpBd:HelpPrompt = ComponentFactory.Instance.creat("ddtstore.TransferHelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.move");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function clearTransferItemCell() : void
      {
         var item1:TransferItemCell = this._items[0];
         var item2:TransferItemCell = this._items[1];
         if(item1.info != null)
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,item1.index,item1.itemBagType,-1);
         }
         if(item2.info != null)
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,item2.index,item2.itemBagType,-1);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         for(var i:int = 0; i < this._items.length; i++)
         {
            this._items[i].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[i].dispose();
         }
         this._items = null;
         EffectManager.Instance.removeEffect(this._transferBtnAsset_shineEffect);
         this._pointArray = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._neededGoldTipText))
         {
            ObjectUtils.disposeObject(this._neededGoldTipText);
         }
         this._neededGoldTipText = null;
         if(Boolean(this._goldIcon))
         {
            ObjectUtils.disposeObject(this._goldIcon);
         }
         this._goldIcon = null;
         if(Boolean(this._transferTitleLarge))
         {
            ObjectUtils.disposeObject(this._transferTitleLarge);
         }
         this._transferTitleLarge = null;
         if(Boolean(this._transferTitleSmall))
         {
            ObjectUtils.disposeObject(this._transferTitleSmall);
         }
         this._transferTitleSmall = null;
         if(Boolean(this._transferArrow))
         {
            ObjectUtils.disposeObject(this._transferArrow);
         }
         this._transferArrow = null;
         if(Boolean(this._equipmentCell1))
         {
            ObjectUtils.disposeObject(this._equipmentCell1);
         }
         this._equipmentCell1 = null;
         if(Boolean(this._equipmentCell2))
         {
            ObjectUtils.disposeObject(this._equipmentCell2);
         }
         this._equipmentCell2 = null;
         if(Boolean(this._area))
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(Boolean(this._transferBtnAsset))
         {
            ObjectUtils.disposeObject(this._transferBtnAsset);
         }
         this._transferBtnAsset = null;
         if(Boolean(this._transferHelpAsset))
         {
            ObjectUtils.disposeObject(this._transferHelpAsset);
         }
         this._transferHelpAsset = null;
         if(Boolean(this.transShine))
         {
            ObjectUtils.disposeObject(this.transShine);
         }
         this.transShine = null;
         if(Boolean(this.transArr))
         {
            ObjectUtils.disposeObject(this.transArr);
         }
         this.transArr = null;
         if(Boolean(this.gold_txt))
         {
            ObjectUtils.disposeObject(this.gold_txt);
         }
         this.gold_txt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

