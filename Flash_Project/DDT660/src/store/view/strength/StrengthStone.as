package store.view.strength
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import store.StoneCell;
   
   public class StrengthStone extends StoneCell
   {
      
      private var _stoneType:String = "";
      
      private var _itemType:int = -1;
      
      private var _aler:StrengthSelectNumAlertFrame;
      
      public function StrengthStone(stoneType:Array, i:int)
      {
         super(stoneType,i);
      }
      
      public function set itemType(value:int) : void
      {
         this._itemType = value;
      }
      
      public function get itemType() : int
      {
         return this._itemType;
      }
      
      public function get stoneType() : String
      {
         return this._stoneType;
      }
      
      public function set stoneType(value:String) : void
      {
         this._stoneType = value;
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var sourceInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(sourceInfo.BagType == BagInfo.STOREBAG && info != null)
         {
            return;
         }
         if(_types.indexOf(sourceInfo.Property1) == -1)
         {
            return;
         }
         if(Boolean(sourceInfo) && effect.action != DragEffect.SPLIT)
         {
            effect.action = DragEffect.NONE;
            if(this._stoneType == "" || this._stoneType == sourceInfo.Property1)
            {
               this._stoneType = sourceInfo.Property1;
               if(sourceInfo.Count == 1)
               {
                  SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,index,1,true);
               }
               else
               {
                  this.showNumAlert(sourceInfo,index);
               }
               DragManager.acceptDrag(this,DragEffect.NONE);
               this.reset();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
            }
         }
      }
      
      private function showNumAlert(info:InventoryItemInfo, index:int) : void
      {
         if(this._stoneType == "35" || this._stoneType == "2")
         {
            this._aler = ComponentFactory.Instance.creat("ddtstore.StrengthSelectNumAlertFrame");
            this._aler.addExeFunction(this.sellFunction,this.notSellFunction);
            this._aler.goodsinfo = info;
            this._aler.index = index;
            this._aler.show(info.Count);
         }
         else if(this._stoneType == "45")
         {
            this._aler = ComponentFactory.Instance.creat("store.view.exalt.exaltSelectNumAlertFrame");
            this._aler.addExeFunction(this.sellFunction,this.notSellFunction);
            this._aler.goodsinfo = info;
            this._aler.index = index;
            this._aler.show(info.Count);
         }
      }
      
      private function sellFunction(_nowNum:int, goodsinfo:InventoryItemInfo, index:int) : void
      {
         SocketManager.Instance.out.sendMoveGoods(goodsinfo.BagType,goodsinfo.Place,BagInfo.STOREBAG,index,_nowNum,true);
         if(Boolean(this._aler))
         {
            this._aler.dispose();
         }
         if(Boolean(this._aler) && Boolean(this._aler.parent))
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function notSellFunction() : void
      {
         if(Boolean(this._aler))
         {
            this._aler.dispose();
         }
         if(Boolean(this._aler) && Boolean(this._aler.parent))
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function reset() : void
      {
         this._stoneType = "";
         this._itemType = -1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._aler))
         {
            ObjectUtils.disposeObject(this._aler);
         }
         this._aler = null;
      }
   }
}

