package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class AvatarCollectionAllPropertyView extends Sprite implements Disposeable
   {
      
      private var _allPropertyCellList:Vector.<AvatarCollectionPropertyCell>;
      
      public function AvatarCollectionAllPropertyView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmp:AvatarCollectionPropertyCell = null;
         this._allPropertyCellList = new Vector.<AvatarCollectionPropertyCell>();
         for(i = 0; i < 7; i++)
         {
            tmp = new AvatarCollectionPropertyCell(i);
            tmp.x = int(i / 4) * 110;
            tmp.y = i % 4 * 25;
            addChild(tmp);
            this._allPropertyCellList.push(tmp);
         }
      }
      
      public function refreshView() : void
      {
         var tmp:AvatarCollectionPropertyCell = null;
         var data:AvatarCollectionUnitVo = null;
         var addedPropertyArr:Array = null;
         var totalCount:int = 0;
         var activityCount:int = 0;
         var p:int = 0;
         var j:int = 0;
         var k:int = 0;
         var dataArr:Array = AvatarCollectionManager.instance.maleUnitList.concat(AvatarCollectionManager.instance.femaleUnitList);
         var value:AvatarCollectionUnitVo = new AvatarCollectionUnitVo();
         var propertyArr:Array = [value.Attack,value.Defence,value.Agility,value.Luck,value.Damage,value.Guard,value.Blood];
         for(var i:int = 0; i < dataArr.length; i++)
         {
            data = dataArr[i];
            addedPropertyArr = [data.Attack,data.Defence,data.Agility,data.Luck,data.Damage,data.Guard,data.Blood];
            totalCount = int(data.totalItemList.length);
            activityCount = data.totalActivityItemCount;
            if(activityCount < totalCount / 2)
            {
               for(p = 0; p < propertyArr.length; p++)
               {
                  propertyArr[p] += 0;
               }
            }
            else if(activityCount == totalCount)
            {
               for(j = 0; j < propertyArr.length; j++)
               {
                  propertyArr[j] += addedPropertyArr[j] * 2;
               }
            }
            else
            {
               for(k = 0; k < propertyArr.length; k++)
               {
                  propertyArr[k] += addedPropertyArr[k];
               }
            }
         }
         value.Attack = propertyArr[0];
         value.Defence = propertyArr[1];
         value.Agility = propertyArr[2];
         value.Luck = propertyArr[3];
         value.Damage = propertyArr[4];
         value.Guard = propertyArr[5];
         value.Blood = propertyArr[6];
         for each(tmp in this._allPropertyCellList)
         {
            tmp.refreshAllProperty(value);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._allPropertyCellList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

