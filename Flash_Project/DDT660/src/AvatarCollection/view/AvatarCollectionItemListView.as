package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionItemVo;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class AvatarCollectionItemListView extends Sprite implements Disposeable
   {
      
      private var _itemList:Vector.<AvatarCollectionItemCell>;
      
      private var _dataList:Array;
      
      public function AvatarCollectionItemListView()
      {
         super();
         this.x = 29;
         this.y = 25;
         this.initView();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmp:AvatarCollectionItemCell = null;
         this._itemList = new Vector.<AvatarCollectionItemCell>();
         for(i = 0; i < 12; i++)
         {
            tmp = new AvatarCollectionItemCell();
            tmp.x = i % 6 * 84;
            tmp.y = int(i / 6) * 87;
            addChild(tmp);
            this._itemList.push(tmp);
         }
      }
      
      public function refreshView(dataList:Array) : void
      {
         var tmpData:AvatarCollectionItemVo = null;
         this._dataList = dataList;
         var tmpLen:int = Boolean(this._dataList) ? int(this._dataList.length) : 0;
         for(var i:int = 0; i < 12; i++)
         {
            tmpData = null;
            if(i < tmpLen)
            {
               tmpData = this._dataList[i];
            }
            this._itemList[i].refreshView(tmpData);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._itemList = null;
         this._dataList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

