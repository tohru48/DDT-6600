package hall.player
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import ddt.view.character.BaseLayer;
   
   public class HallSceneCharacterLayer extends BaseLayer
   {
      
      private var _direction:int;
      
      private var _sceneCharacterLoaderType:int;
      
      private var _sex:Boolean;
      
      private var _mountsType:int;
      
      public function HallSceneCharacterLayer(info:ItemTemplateInfo, color:String = "", direction:int = 1, sex:Boolean = true, sceneCharacterLoaderType:int = 0, mountsType:int = 0)
      {
         this._direction = direction;
         this._sex = sex;
         this._sceneCharacterLoaderType = sceneCharacterLoaderType;
         this._mountsType = mountsType;
         super(info,color);
      }
      
      override protected function getUrl(layer:int) : String
      {
         var type:String = this._direction == 1 ? "clothF" : (this._direction == 2 ? "cloth" : "clothF");
         var path:String = "";
         if(layer == 1)
         {
            if(this._mountsType > 0)
            {
               if(this._sceneCharacterLoaderType == 0)
               {
                  path = PathManager.SITE_MAIN + "image/mounts/cloth/" + (this._sex ? "M" : "F") + "/1/" + String(layer) + ".png";
               }
               else if(this._sceneCharacterLoaderType == 1)
               {
                  path = PathManager.SITE_MAIN + "image/mounts/saddle/" + this._mountsType + "/" + String(layer) + ".png";
               }
               else if(this._sceneCharacterLoaderType == 2)
               {
                  path = PathManager.SITE_MAIN + "image/mounts/horse/" + this._mountsType + "/" + String(layer) + ".png";
               }
            }
            else
            {
               path = PathManager.SITE_MAIN + "image/mounts/clothZ/" + (this._sex ? "M" : "F") + "/" + type + "/1/" + String(layer) + ".png";
            }
         }
         return path;
      }
   }
}

