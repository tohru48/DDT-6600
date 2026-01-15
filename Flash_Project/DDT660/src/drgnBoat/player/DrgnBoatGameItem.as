package drgnBoat.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class DrgnBoatGameItem extends Sprite implements Disposeable
   {
      
      private var _itemMc:MovieClip;
      
      public function DrgnBoatGameItem(index:int, type:int, posX:int)
      {
         super();
         this.x = 280 + posX;
         var t:int = index >= 2 ? index + 1 : index;
         this.y = 195 + 75 * t;
         this._itemMc = ComponentFactory.Instance.creat("drgnBoat.itemMc" + type);
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

