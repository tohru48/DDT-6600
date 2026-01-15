package catchInsect.player
{
   import catchInsect.loader.LoaderCatchInsectUIModule;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.view.character.BaseLayer;
   
   public class CatchInsectSceneCharacterLayer extends BaseLayer
   {
      
      private var _direction:int;
      
      private var _sex:Boolean;
      
      public function CatchInsectSceneCharacterLayer(info:ItemTemplateInfo, color:String = "", direction:int = 1, sex:Boolean = true)
      {
         this._direction = direction;
         this._sex = sex;
         super(info,color);
      }
      
      override protected function getUrl(layer:int) : String
      {
         var type:String = this._direction == 1 ? "clothF" : (this._direction == 2 ? "cloth" : "clothF");
         return LoaderCatchInsectUIModule.Instance.getCatchInsectResource() + "/cloth/" + (this._sex ? "M" : "F") + "/" + type + "/" + String(layer) + ".png";
      }
   }
}

