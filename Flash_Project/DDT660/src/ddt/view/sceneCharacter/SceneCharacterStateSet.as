package ddt.view.sceneCharacter
{
   public class SceneCharacterStateSet
   {
      
      private var _dataSet:Vector.<SceneCharacterStateItem>;
      
      public function SceneCharacterStateSet()
      {
         super();
         this._dataSet = new Vector.<SceneCharacterStateItem>();
      }
      
      public function push(sceneCharacterStateItem:SceneCharacterStateItem) : void
      {
         if(!sceneCharacterStateItem)
         {
            return;
         }
         sceneCharacterStateItem.update();
         this._dataSet.push(sceneCharacterStateItem);
      }
      
      public function get length() : uint
      {
         return this._dataSet.length;
      }
      
      public function get dataSet() : Vector.<SceneCharacterStateItem>
      {
         return this._dataSet;
      }
      
      public function getItem(type:String) : SceneCharacterStateItem
      {
         var i:int = 0;
         if(Boolean(this._dataSet) && this._dataSet.length > 0)
         {
            for(i = 0; i < this._dataSet.length; i++)
            {
               if(this._dataSet[i].type == type)
               {
                  return this._dataSet[i];
               }
            }
         }
         return null;
      }
      
      public function dispose() : void
      {
         while(Boolean(this._dataSet) && this._dataSet.length > 0)
         {
            this._dataSet[0].dispose();
            this._dataSet.shift();
         }
         this._dataSet = null;
      }
   }
}

