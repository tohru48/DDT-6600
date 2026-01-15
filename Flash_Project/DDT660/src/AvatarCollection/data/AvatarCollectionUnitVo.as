package AvatarCollection.data
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.ui.controls.cell.INotSameHeightListCellData;
   
   public class AvatarCollectionUnitVo implements INotSameHeightListCellData
   {
      
      public var id:int;
      
      public var sex:int;
      
      public var name:String;
      
      public var Attack:int;
      
      public var Defence:int;
      
      public var Agility:int;
      
      public var Luck:int;
      
      public var Blood:int;
      
      public var Damage:int;
      
      public var Guard:int;
      
      public var needHonor:int;
      
      public var endTime:Date;
      
      public function AvatarCollectionUnitVo()
      {
         super();
      }
      
      public function get totalItemList() : Array
      {
         return AvatarCollectionManager.instance.getItemListById(this.sex,this.id);
      }
      
      public function get totalActivityItemCount() : int
      {
         var tmp:AvatarCollectionItemVo = null;
         var tmpList:Array = this.totalItemList;
         var tmpCount:int = 0;
         for each(tmp in tmpList)
         {
            if(tmp.isActivity)
            {
               tmpCount++;
            }
         }
         return tmpCount;
      }
      
      public function get canActivityCount() : int
      {
         var tmp:AvatarCollectionItemVo = null;
         var tmpList:Array = this.totalItemList;
         var tmpCount:int = 0;
         for each(tmp in tmpList)
         {
            if(!tmp.isActivity && tmp.isHas)
            {
               tmpCount++;
            }
         }
         return tmpCount;
      }
      
      public function get canBuyCount() : int
      {
         var tmp:AvatarCollectionItemVo = null;
         var tmpList:Array = this.totalItemList;
         var tmpCount:int = 0;
         for each(tmp in tmpList)
         {
            if(!tmp.isActivity && !tmp.isHas && tmp.canBuyStatus == 1)
            {
               tmpCount++;
            }
         }
         return tmpCount;
      }
      
      public function getCellHeight() : Number
      {
         return 37;
      }
   }
}

