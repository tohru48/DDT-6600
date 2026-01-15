package escort.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class EscortGameItem extends Sprite implements Disposeable
   {
      
      private var _itemMc:MovieClip;
      
      public function EscortGameItem(index:int, type:int, posX:int)
      {
         super();
         this.x = 280 + posX;
         this.y = 170 + 65 * index;
         this._itemMc = ComponentFactory.Instance.creat("asset.escort.itemMc" + type);
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

