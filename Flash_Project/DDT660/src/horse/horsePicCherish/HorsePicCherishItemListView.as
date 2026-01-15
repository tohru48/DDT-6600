package horse.horsePicCherish
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class HorsePicCherishItemListView extends Sprite implements Disposeable
   {
      
      private var _itemList:Vector.<HorsePicCherishItem>;
      
      public function HorsePicCherishItemListView(list:Vector.<HorsePicCherishItem>)
      {
         super();
         this._itemList = list;
      }
      
      public function show(index:int) : void
      {
         var count:int = 0;
         var item:HorsePicCherishItem = null;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         var i:int = (index - 1) * 8;
         while(i < index * 8 && i < this._itemList.length)
         {
            item = this._itemList[i];
            item.x = count % 4 * (item.width + 2);
            item.y = int(count / 4) * (item.height - 2);
            addChild(item);
            i++;
            count++;
         }
      }
      
      public function dispose() : void
      {
         var item:HorsePicCherishItem = null;
         for each(item in this._itemList)
         {
            ObjectUtils.disposeObject(item);
            item = null;
         }
         this._itemList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

