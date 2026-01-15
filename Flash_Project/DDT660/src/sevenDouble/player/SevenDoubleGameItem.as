package sevenDouble.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class SevenDoubleGameItem extends Sprite implements Disposeable
   {
      
      private var _itemMc:MovieClip;
      
      public function SevenDoubleGameItem(index:int, type:int, posX:int)
      {
         super();
         this.x = 280 + posX;
         this.y = 195 + 65 * index;
         this._itemMc = ComponentFactory.Instance.creat("asset.sevenDouble.itemMc" + type);
         this._itemMc.gotoAndStop(1);
         addChild(this._itemMc);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._itemMc))
         {
            this._itemMc.gotoAndStop(2);
            removeChild(this._itemMc);
         }
         this._itemMc = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

