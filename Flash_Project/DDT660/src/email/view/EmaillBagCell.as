package email.view
{
   import auctionHouse.event.AuctionSellEvent;
   import auctionHouse.view.AuctionSellLeftAler;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.events.MouseEvent;
   
   public class EmaillBagCell extends LinkedBagCell
   {
      
      private var _temporaryCount:int;
      
      private var _temporaryInfo:InventoryItemInfo;
      
      private var _goodsCount:int;
      
      public function EmaillBagCell()
      {
         super(null);
         this._goodsCount = 1;
         _bg.alpha = 0;
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
         if(Boolean(info) && effect.action == DragEffect.MOVE)
         {
            effect.action = DragEffect.NONE;
            if(info.IsBinds)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.isBinds"));
            }
            else if(info.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.RemainDate"));
            }
            else
            {
               this._goodsCount = 1;
               bagCell = effect.source as BagCell;
               effect.action = DragEffect.LINK;
               this._temporaryCount = bagCell.itemInfo.Count;
               this._temporaryInfo = bagCell.itemInfo;
               if(bagCell.locked == false)
               {
                  bagCell.locked = true;
                  return;
               }
               if(bagCell.itemInfo.Count > 1)
               {
                  _aler = ComponentFactory.Instance.creat("auctionHouse.AuctionSellLeftAler");
                  _aler.titleText = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagBreak");
                  _aler.show(this._temporaryInfo.Count);
                  _aler.addEventListener(AuctionSellEvent.SELL,this._alerSell);
                  _aler.addEventListener(AuctionSellEvent.NOTSELL,this._alerNotSell);
               }
            }
            DragManager.acceptDrag(this);
         }
      }
      
      private function _alerSell(e:AuctionSellEvent) : void
      {
         var _aler:AuctionSellLeftAler = e.currentTarget as AuctionSellLeftAler;
         this._temporaryInfo.Count = e.sellCount;
         this._goodsCount = e.sellCount;
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
            addChild(_tbxCount);
         }
         else
         {
            _tbxCount.visible = false;
         }
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
         buttonMode = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      public function get goodsCount() : int
      {
         return this._goodsCount;
      }
   }
}

