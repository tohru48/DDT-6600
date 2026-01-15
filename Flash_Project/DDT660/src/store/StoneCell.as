package store
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class StoneCell extends StoreCell
   {
      
      public static const CONTENTSIZE:int = 62;
      
      public static const PICPOS:int = 17;
      
      protected var _types:Array;
      
      public function StoneCell(stoneType:Array, $index:int)
      {
         var bg:Sprite = new Sprite();
         var bgBit:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.BlankCellBG");
         bg.addChild(bgBit);
         super(bg,$index);
         this._types = stoneType;
         setContentSize(CONTENTSIZE,CONTENTSIZE);
         PicPos = new Point(PICPOS,PICPOS);
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
         if(Boolean(sourceInfo) && effect.action != DragEffect.SPLIT)
         {
            effect.action = DragEffect.NONE;
            if(sourceInfo.CategoryID == 11 && this._types.indexOf(sourceInfo.Property1) > -1 && sourceInfo.getRemainDate() > 0)
            {
               SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,index,1,false);
               effect.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
            }
         }
      }
      
      public function get types() : Array
      {
         return this._types;
      }
      
      override public function dispose() : void
      {
         this._types = null;
         super.dispose();
      }
   }
}

