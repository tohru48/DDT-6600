package ddt.view.sceneCharacter
{
   public class SceneCharacterActionSet
   {
      
      private var _dataSet:Vector.<SceneCharacterActionItem>;
      
      public function SceneCharacterActionSet()
      {
         super();
         this._dataSet = new Vector.<SceneCharacterActionItem>();
      }
      
      public function push(sceneCharacterActionItem:SceneCharacterActionItem) : void
      {
         this._dataSet.push(sceneCharacterActionItem);
      }
      
      public function get length() : uint
      {
         return this._dataSet.length;
      }
      
      public function get dataSet() : Vector.<SceneCharacterActionItem>
      {
         return this._dataSet;
      }
      
      public function getItem(type:String) : SceneCharacterActionItem
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

