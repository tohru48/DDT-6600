package christmas.player
{
   import christmas.loader.LoaderChristmasUIModule;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.view.character.BaseLayer;
   
   public class ChristmasSceneCharacterLayer extends BaseLayer
   {
      
      private var _direction:int;
      
      private var _sex:Boolean;
      
      public function ChristmasSceneCharacterLayer(info:ItemTemplateInfo, color:String = "", direction:int = 1, sex:Boolean = true)
      {
         this._direction = direction;
         this._sex = sex;
         super(info,color);
      }
      
      override protected function getUrl(layer:int) : String
      {
         var type:String = this._direction == 1 ? "clothF" : (this._direction == 2 ? "cloth" : "clothF");
         return LoaderChristmasUIModule.Instance.getChristmasResource() + "/cloth/" + (this._sex ? "M" : "F") + "/" + type + "/" + String(layer) + ".png";
      }
   }
}

