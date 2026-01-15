package ddt.view.sceneCharacter
{
   public class SceneCharacterSet
   {
      
      private var _dataSet:Vector.<SceneCharacterItem>;
      
      public function SceneCharacterSet()
      {
         super();
         this._dataSet = new Vector.<SceneCharacterItem>();
      }
      
      public function push(sceneCharacterItem:SceneCharacterItem) : void
      {
         this._dataSet.push(sceneCharacterItem);
      }
      
      public function get length() : uint
      {
         return this._dataSet.length;
      }
      
      public function get dataSet() : Vector.<SceneCharacterItem>
      {
         return this._dataSet.sort(this.sortOn);
      }
      
      private function sortOn(a:SceneCharacterItem, b:SceneCharacterItem) : Number
      {
         if(a.sortOrder < b.sortOrder)
         {
            return -1;
         }
         if(a.sortOrder > b.sortOrder)
         {
            return 1;
         }
         return 0;
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

