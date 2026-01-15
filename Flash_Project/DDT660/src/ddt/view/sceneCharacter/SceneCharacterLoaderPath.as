package ddt.view.sceneCharacter
{
   public class SceneCharacterLoaderPath
   {
      
      private var _clothPath:String;
      
      public function SceneCharacterLoaderPath()
      {
         super();
      }
      
      public function set clothPath(value:String) : void
      {
         this._clothPath = value;
      }
      
      public function get clothPath() : String
      {
         return this._clothPath;
      }
   }
}

