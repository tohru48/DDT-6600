package farm.player
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import ddt.view.character.BaseLayer;
   
   public class FarmSceneCharacterLayer extends BaseLayer
   {
      
      private var _direction:int;
      
      private var _sceneCharacterLoaderPath:String;
      
      private var _sex:Boolean;
      
      public function FarmSceneCharacterLayer(info:ItemTemplateInfo, color:String = "", direction:int = 1, sex:Boolean = true, sceneCharacterLoaderPath:String = "")
      {
         this._direction = direction;
         this._sex = sex;
         this._sceneCharacterLoaderPath = sceneCharacterLoaderPath;
         super(info,color);
      }
      
      override protected function getUrl(layer:int) : String
      {
         return PathManager.solveSceneCharacterLoaderPath(_info.CategoryID,_info.Pic,this._sex,_info.NeedSex == 1,String(layer),this._direction,this._sceneCharacterLoaderPath);
      }
   }
}

