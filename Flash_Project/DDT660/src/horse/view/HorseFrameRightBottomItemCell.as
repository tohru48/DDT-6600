package horse.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import shop.manager.ShopBuyManager;
   
   public class HorseFrameRightBottomItemCell extends Sprite implements Disposeable
   {
      
      private var _itemCell:BagCell;
      
      private var _buyImage:Bitmap;
      
      private var _itemId:int;
      
      public function HorseFrameRightBottomItemCell(itemId:int)
      {
         super();
         this.buttonMode = true;
         this._itemId = itemId;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var bg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.horse.frame.itemBg");
         this._itemCell = new BagCell(1,ItemManager.Instance.getTemplateById(this._itemId),true,bg,false);
         this._itemCell.PicPos = new Point(9,9);
         this._itemCell.setContentSize(59,59);
         this.updateItemCellCount();
         addChild(this._itemCell);
         this._buyImage = ComponentFactory.Instance.creatBitmap("asset.horse.frame.buyBtn");
         addChild(this._buyImage);
         this._buyImage.alpha = 0;
         this._buyImage.x = 6;
         this._buyImage.y = 40;
      }
      
      private function updateItemCellCount() : void
      {
         this._itemCell.setCount(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._itemId));
         this._itemCell.refreshTbxPos();
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.itemUpdateHandler);
      }
      
      private function itemUpdateHandler(event:BagEvent) : void
      {
         this.updateItemCellCount();
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         ShopBuyManager.Instance.buy(this._itemId,1,-1);
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         TweenLite.to(this._buyImage,0.25,{"alpha":1});
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         TweenLite.to(this._buyImage,0.25,{"alpha":0});
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.clickHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.itemUpdateHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._itemCell = null;
         this._buyImage = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get itemCell() : BagCell
      {
         return this._itemCell;
      }
   }
}

