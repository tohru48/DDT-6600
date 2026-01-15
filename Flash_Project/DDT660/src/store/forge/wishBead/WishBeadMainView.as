package store.forge.wishBead
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import store.HelpFrame;
   import store.HelpPrompt;
   
   public class WishBeadMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _bagList:WishBeadBagListView;
      
      private var _proBagList:WishBeadBagListView;
      
      private var _leftDrapSprite:WishBeadLeftDragSprite;
      
      private var _rightDrapSprite:WishBeadRightDragSprite;
      
      private var _itemCell:WishBeadItemCell;
      
      private var _equipCell:WishBeadEquipCell;
      
      private var _continuousBtn:SelectedCheckButton;
      
      private var _doBtn:SimpleBitmapButton;
      
      private var _tip:WishTips;
      
      private var _helpBtn:BaseButton;
      
      private var _isDispose:Boolean = false;
      
      private var _equipBagInfo:BagInfo;
      
      public function WishBeadMainView()
      {
         super();
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
         this.createAcceptDragSprite();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.wishBead.leftViewBg");
         this._bagList = new WishBeadBagListView(BagInfo.EQUIPBAG,7,21);
         PositionUtils.setPos(this._bagList,"wishBeadMainView.bagListPos");
         this.refreshBagList();
         this._proBagList = new WishBeadBagListView(BagInfo.PROPBAG,7,21);
         PositionUtils.setPos(this._proBagList,"wishBeadMainView.proBagListPos");
         this._proBagList.setData(WishBeadManager.instance.getWishBeadItemData());
         this._equipCell = new WishBeadEquipCell(0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         this._equipCell.BGVisible = false;
         PositionUtils.setPos(this._equipCell,"wishBeadMainView.equipCellPos");
         this._equipCell.setContentSize(68,68);
         this._equipCell.PicPos = new Point(-3,-5);
         this._itemCell = new WishBeadItemCell(0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         PositionUtils.setPos(this._itemCell,"wishBeadMainView.itemCellPos");
         this._itemCell.BGVisible = false;
         this._continuousBtn = ComponentFactory.Instance.creatComponentByStylename("wishBeadMainView.continuousBtn");
         this._doBtn = ComponentFactory.Instance.creatComponentByStylename("wishBeadMainView.doBtn");
         this._doBtn.enable = false;
         var tipTxt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("wishBeadMainView.tipTxt");
         tipTxt.text = LanguageMgr.GetTranslation("wishBeadMainView.tipTxt");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("wishBead.NodeBtn");
         addChild(this._bg);
         addChild(this._bagList);
         addChild(this._proBagList);
         addChild(this._equipCell);
         addChild(this._itemCell);
         addChild(tipTxt);
         addChild(this._continuousBtn);
         addChild(this._doBtn);
         addChild(this._helpBtn);
         this._tip = ComponentFactory.Instance.creat("store.forge.wishBead.WishTip");
         LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER).addChild(this._tip);
      }
      
      private function refreshBagList() : void
      {
         this._equipBagInfo = WishBeadManager.instance.getCanWishBeadData();
         this._bagList.setData(this._equipBagInfo);
      }
      
      private function initEvent() : void
      {
         this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._equipCell.addEventListener(Event.CHANGE,this.itemEquipChangeHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._itemCell.addEventListener(Event.CHANGE,this.itemEquipChangeHandler,false,0,true);
         this._doBtn.addEventListener(MouseEvent.CLICK,this.doHandler,false,0,true);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WISHBEADEQUIP,this.__showTip);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__clickHelp,false,0,true);
      }
      
      private function bagInfoChangeHandler(event:BagEvent) : void
      {
         var changeItemInfo:InventoryItemInfo = null;
         var tmp:InventoryItemInfo = null;
         var tmp2:BagInfo = null;
         var changedSlots:Dictionary = event.changedSlots;
         var _loc7_:int = 0;
         var _loc8_:* = changedSlots;
         for each(tmp in _loc8_)
         {
            changeItemInfo = tmp;
         }
         if(Boolean(changeItemInfo) && !PlayerManager.Instance.Self.Bag.items[changeItemInfo.Place])
         {
            if(Boolean(this._equipCell.info) && (this._equipCell.info as InventoryItemInfo).Place == changeItemInfo.Place)
            {
               this._equipCell.info = null;
            }
            else
            {
               this.refreshBagList();
            }
         }
         else
         {
            tmp2 = WishBeadManager.instance.getCanWishBeadData();
            if(tmp2.items.length != this._equipBagInfo.items.length)
            {
               this._equipBagInfo = tmp2;
               this._bagList.setData(this._equipBagInfo);
            }
         }
         var tmpInfo:InventoryItemInfo = this._equipCell.itemInfo;
         if(Boolean(tmpInfo) && tmpInfo.isGold)
         {
            this._equipCell.info = null;
            this._equipCell.info = tmpInfo;
         }
      }
      
      private function __clickHelp(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         var helpBd:HelpPrompt = ComponentFactory.Instance.creat("wishBead.wishBeadHelp");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("wishBead.helpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("wishBead.wishBeadHelp.say");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function propInfoChangeHandler(event:BagEvent) : void
      {
         var changeItemInfo:InventoryItemInfo = null;
         var tmp:InventoryItemInfo = null;
         var tmpItemInfo:InventoryItemInfo = null;
         var changedSlots:Dictionary = event.changedSlots;
         var _loc6_:int = 0;
         var _loc7_:* = changedSlots;
         for each(tmp in _loc7_)
         {
            changeItemInfo = tmp;
         }
         if(Boolean(changeItemInfo) && !PlayerManager.Instance.Self.PropBag.items[changeItemInfo.Place])
         {
            if(Boolean(this._itemCell.info) && (this._itemCell.info as InventoryItemInfo).Place == changeItemInfo.Place)
            {
               this._itemCell.info = null;
            }
            else
            {
               this._proBagList.setData(WishBeadManager.instance.getWishBeadItemData());
            }
         }
         else
         {
            if(!this._itemCell || !this._itemCell.info)
            {
               return;
            }
            tmpItemInfo = this._itemCell.info as InventoryItemInfo;
            if(!PlayerManager.Instance.Self.PropBag.items[tmpItemInfo.Place])
            {
               this._itemCell.info = null;
            }
            else
            {
               this._itemCell.setCount(tmpItemInfo.Count);
            }
         }
      }
      
      private function __showTip(evt:CrazyTankSocketEvent) : void
      {
         this._tip.isDisplayerTip = true;
         var result:int = evt.pkg.readInt();
         switch(result)
         {
            case 0:
               this._continuousBtn.selected = false;
               this._tip.showSuccess(this.judgeAgain);
               break;
            case 1:
               this._tip.showFail(this.judgeAgain);
               break;
            case 5:
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.notCanWish"));
               this.judgeDoBtnStatus(false);
               break;
            case 6:
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.equipIsGold"));
               this.judgeDoBtnStatus(false);
               break;
            case 8:
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.remainTimeShort"));
               this.judgeDoBtnStatus(false);
               break;
            default:
               this.judgeDoBtnStatus(false);
         }
      }
      
      private function judgeAgain() : void
      {
         if(this._isDispose)
         {
            return;
         }
         if(this._continuousBtn.selected)
         {
            if((this._itemCell.info as InventoryItemInfo).Count <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.noBead"));
               return;
            }
            this.sendMess();
         }
         else
         {
            this.judgeDoBtnStatus(false);
         }
      }
      
      private function doHandler(event:MouseEvent) : void
      {
         var confirmFrame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this._equipCell.info)
         {
            return;
         }
         if(!this._itemCell.info)
         {
            return;
         }
         if((this._itemCell.info as InventoryItemInfo).Count <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.noBead"));
            return;
         }
         if(!(this._equipCell.info as InventoryItemInfo).IsBinds)
         {
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm,false,0,true);
         }
         else
         {
            this.sendMess();
         }
      }
      
      private function __confirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendMess();
         }
      }
      
      private function sendMess() : void
      {
         this._doBtn.enable = false;
         var equipInfo:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         var itemInfo:InventoryItemInfo = this._itemCell.info as InventoryItemInfo;
         SocketManager.Instance.out.sendWishBeadEquip(equipInfo.Place,equipInfo.BagType,equipInfo.TemplateID,itemInfo.Place,itemInfo.BagType,itemInfo.TemplateID);
      }
      
      private function itemEquipChangeHandler(event:Event) : void
      {
         this._continuousBtn.selected = false;
         this.judgeDoBtnStatus(true);
      }
      
      private function judgeDoBtnStatus(isShowTip:Boolean) : void
      {
         if(Boolean(this._equipCell.info) && Boolean(this._itemCell.info))
         {
            if(WishBeadManager.instance.getIsEquipMatchWishBead(this._itemCell.info.TemplateID,this._equipCell.info.CategoryID,isShowTip))
            {
               this._doBtn.enable = true;
            }
            else
            {
               this._doBtn.enable = false;
            }
         }
         else
         {
            this._doBtn.enable = false;
         }
      }
      
      protected function __cellDoubleClick(evt:CellEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpStr:String = "";
         if(evt.target == this._proBagList)
         {
            tmpStr = WishBeadManager.ITEM_MOVE;
         }
         else
         {
            tmpStr = WishBeadManager.EQUIP_MOVE;
         }
         var event:WishBeadEvent = new WishBeadEvent(tmpStr);
         var cell:BagCell = evt.data as BagCell;
         event.info = cell.info as InventoryItemInfo;
         event.moveType = 1;
         WishBeadManager.instance.dispatchEvent(event);
      }
      
      private function cellClickHandler(event:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var cell:BagCell = event.data as BagCell;
         cell.dragStart();
      }
      
      private function createAcceptDragSprite() : void
      {
         this._leftDrapSprite = new WishBeadLeftDragSprite();
         this._leftDrapSprite.mouseEnabled = false;
         this._leftDrapSprite.mouseChildren = false;
         this._leftDrapSprite.graphics.beginFill(0,0);
         this._leftDrapSprite.graphics.drawRect(0,0,347,404);
         this._leftDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._leftDrapSprite,"wishBeadMainView.leftDrapSpritePos");
         addChild(this._leftDrapSprite);
         this._rightDrapSprite = new WishBeadRightDragSprite();
         this._rightDrapSprite.mouseEnabled = false;
         this._rightDrapSprite.mouseChildren = false;
         this._rightDrapSprite.graphics.beginFill(0,0);
         this._rightDrapSprite.graphics.drawRect(0,0,374,407);
         this._rightDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._rightDrapSprite,"wishBeadMainView.rightDrapSpritePos");
         addChild(this._rightDrapSprite);
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(value)
         {
            if(!this._isDispose)
            {
               this.refreshListData();
               PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
               PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
            }
         }
         else
         {
            this.clearCellInfo();
            PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         }
      }
      
      public function clearCellInfo() : void
      {
         if(Boolean(this._equipCell))
         {
            this._equipCell.clearInfo();
         }
         if(Boolean(this._itemCell))
         {
            this._itemCell.clearInfo();
         }
      }
      
      public function refreshListData() : void
      {
         if(Boolean(this._bagList))
         {
            this.refreshBagList();
         }
         if(Boolean(this._proBagList))
         {
            this._proBagList.setData(WishBeadManager.instance.getWishBeadItemData());
         }
      }
      
      private function removeEvent() : void
      {
         this._bagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equipCell.removeEventListener(Event.CHANGE,this.itemEquipChangeHandler);
         this._proBagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._proBagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._itemCell.removeEventListener(Event.CHANGE,this.itemEquipChangeHandler);
         this._doBtn.removeEventListener(MouseEvent.CLICK,this.doHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WISHBEADEQUIP,this.__showTip);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__clickHelp);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._tip);
         this._tip = null;
         this._bg = null;
         this._bagList = null;
         this._proBagList = null;
         this._leftDrapSprite = null;
         this._rightDrapSprite = null;
         this._itemCell = null;
         this._equipCell = null;
         this._continuousBtn = null;
         this._doBtn = null;
         this._helpBtn = null;
         this._equipBagInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._isDispose = true;
      }
   }
}

