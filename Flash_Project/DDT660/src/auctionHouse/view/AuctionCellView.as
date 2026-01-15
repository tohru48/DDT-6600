package auctionHouse.view
{
   import auctionHouse.event.AuctionSellEvent;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class AuctionCellView extends LinkedBagCell
   {
      
      public static const SELECT_BID_GOOD:String = "selectBidGood";
      
      public static const SELECT_GOOD:String = "selectGood";
      
      public static const CELL_MOUSEOVER:String = "Cell_mouseOver";
      
      public static const CELL_MOUSEOUT:String = "Cell_mouseOut";
      
      private var _picRect:Rectangle;
      
      private var _temporaryInfo:InventoryItemInfo;
      
      private var _temporaryCount:int;
      
      private var _goodsCount:int = 1;
      
      public function AuctionCellView()
      {
         var bg:Sprite = new Sprite();
         bg.addChild(ComponentFactory.Instance.creatBitmap("asset.auctionHouse.CellBgIIAsset"));
         super(bg);
         tipDirctions = "7";
         (_bg as Sprite).graphics.beginFill(0,0);
         (_bg as Sprite).graphics.drawRect(-5,-5,203,55);
         (_bg as Sprite).graphics.endFill();
         this._picRect = ComponentFactory.Instance.creatCustomObject("auctionHouse.sell.cell.PicRect");
         PicPos = this._picRect.topLeft;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         var _aler:AuctionSellLeftAler = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(Boolean(info) && effect.action != DragEffect.SPLIT)
         {
            effect.action = DragEffect.NONE;
            if(info.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionCellView.Object"));
            }
            else if(info.IsBinds)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionCellView.Sale"));
            }
            else
            {
               this._goodsCount = 1;
               bagCell = effect.source as BagCell;
               this._temporaryCount = bagCell.itemInfo.Count;
               this._temporaryInfo = bagCell.itemInfo;
               if(bagCell.itemInfo.Count > 1)
               {
                  _aler = ComponentFactory.Instance.creat("auctionHouse.AuctionSellLeftAler");
                  _aler.show(this._temporaryInfo.Count);
                  _aler.addEventListener(AuctionSellEvent.SELL,this._alerSell);
                  _aler.addEventListener(AuctionSellEvent.NOTSELL,this._alerNotSell);
               }
               DragManager.acceptDrag(bagCell,DragEffect.LINK);
            }
         }
      }
      
      private function _alerSell(e:AuctionSellEvent) : void
      {
         var _aler:AuctionSellLeftAler = e.currentTarget as AuctionSellLeftAler;
         this._goodsCount = e.sellCount;
         this._temporaryInfo.Count = e.sellCount;
         info = this._temporaryInfo;
         if(Boolean(bagCell))
         {
            bagCell.itemInfo.Count = this._temporaryCount;
         }
         _aler.dispose();
         if(Boolean(_aler) && Boolean(_aler.parent))
         {
            removeChild(_aler);
         }
         _aler = null;
      }
      
      private function _alerNotSell(e:AuctionSellEvent) : void
      {
         var _aler:AuctionSellLeftAler = e.currentTarget as AuctionSellLeftAler;
         info = null;
         bagCell.locked = false;
         bagCell = null;
         _aler.dispose();
         if(Boolean(_aler) && Boolean(_aler.parent))
         {
            removeChild(_aler);
         }
         _aler = null;
      }
      
      public function get goodsCount() : int
      {
         return this._goodsCount;
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         super.dragStop(effect);
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
         super.onMouseClick(evt);
         dispatchEvent(new Event(AuctionCellView.SELECT_BID_GOOD));
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
         dispatchEvent(new Event(CELL_MOUSEOVER));
      }
      
      override protected function onMouseOut(evt:MouseEvent) : void
      {
         dispatchEvent(new Event(CELL_MOUSEOUT));
      }
      
      public function onObjectClicked() : void
      {
         super.dragStart();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function updateCount() : void
      {
         if(_tbxCount == null)
         {
            return;
         }
         if(_info && itemInfo && itemInfo.MaxCount > 1)
         {
            _tbxCount.visible = true;
            _tbxCount.text = String(itemInfo.Count);
            _tbxCount.x = this._picRect.right - _tbxCount.width;
            _tbxCount.y = this._picRect.bottom - _tbxCount.height;
            addChild(_tbxCount);
         }
         else
         {
            _tbxCount.visible = false;
         }
      }
   }
}

