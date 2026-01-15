package consortion.view.selfConsortia.consortiaTask
{
   public class ConsortiaTaskInfo
   {
      
      public var itemList:Vector.<Object>;
      
      public var exp:int;
      
      public var offer:int;
      
      public var riches:int;
      
      public var buffID:int;
      
      public var beginTime:Date;
      
      public var time:int;
      
      public var contribution:int;
      
      public var level:int;
      
      private var sortKey:Array = [3,4,1,5,2];
      
      public function ConsortiaTaskInfo()
      {
         super();
         this.itemList = new Vector.<Object>();
      }
      
      public function addItemData(id:int, content:String, taskType:int = 0, currenValue:Number = 0, targetValue:int = 0, finishValue:int = 0) : void
      {
         var obj:Object = new Object();
         obj["id"] = id;
         obj["taskType"] = taskType;
         obj["content"] = content;
         obj["currenValue"] = currenValue;
         obj["targetValue"] = targetValue;
         obj["finishValue"] = finishValue;
         this.itemList.push(obj);
      }
      
      public function sortItem() : void
      {
         var i:int = 0;
         var obj:Object = null;
         for(var tempList:Vector.<Object> = new Vector.<Object>(); i < this.sortKey.length; )
         {
            for each(obj in this.itemList)
            {
               if(this.sortKey[i] == obj["taskType"])
               {
                  tempList.push(obj);
               }
            }
            i++;
         }
         this.itemList = tempList;
      }
      
      public function updateItemData(id:int, currenValue:Number = 0, finishValue:int = 0) : void
      {
         var obj:Object = null;
         for each(obj in this.itemList)
         {
            if(obj["id"] == id)
            {
               obj["currenValue"] = currenValue;
               obj["finishValue"] = finishValue;
            }
         }
      }
   }
}

