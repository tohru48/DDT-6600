package worldboss.player
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import ddt.view.character.BaseLayer;
   
   public class WorldBossSceneCharacterLayer extends BaseLayer
   {
      
      private var _direction:int;
      
      private var _sex:Boolean;
      
      public function WorldBossSceneCharacterLayer(info:ItemTemplateInfo, color:String = "", direction:int = 1, sex:Boolean = true)
      {
         this._direction = direction;
         this._sex = sex;
         super(info,color);
      }
      
      override protected function getUrl(layer:int) : String
      {
         var type:String = this._direction == 1 ? "clothF" : (this._direction == 2 ? "cloth" : "clothF");
         return PathManager.SITE_MAIN + "image/mounts/clothZ/" + (this._sex ? "M" : "F") + "/" + type + "/1/" + String(layer) + ".png";
      }
   }
}

