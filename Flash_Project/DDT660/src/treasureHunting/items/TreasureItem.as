package treasureHunting.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   
   public class TreasureItem extends Component implements Disposeable
   {
      
      private static const LIGHT_OFFSET:int = -3;
      
      private var _itemIcon:Bitmap;
      
      public var selectedLight:ScaleBitmapImage;
      
      private var _index:int;
      
      public function TreasureItem()
      {
         super();
      }
      
      public function initView(index:int) : void
      {
         this._index = index;
         this._itemIcon = ComponentFactory.Instance.creat("treasureHunting.treasure.item" + this._index);
         addChild(this._itemIcon);
         this.selectedLight = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Treasure.ItemLight");
         this.selectedLight.x += LIGHT_OFFSET;
         this.selectedLight.y += LIGHT_OFFSET;
         this.selectedLight.visible = false;
         addChild(this.selectedLight);
      }
      
      override public function dispose() : void
      {
         if(this._itemIcon != null)
         {
            ObjectUtils.disposeObject(this._itemIcon);
         }
         this._itemIcon = null;
         if(this.selectedLight != null)
         {
            ObjectUtils.disposeObject(this.selectedLight);
         }
         this.selectedLight = null;
         super.dispose();
      }
      
      public function get itemIcon() : Bitmap
      {
         return this._itemIcon;
      }
      
      public function set itemIcon(value:Bitmap) : void
      {
         this._itemIcon = value;
      }
   }
}

