package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   
   public class SpecialEffectsLayer extends BaseLayer
   {
      
      private var _specialType:int;
      
      public function SpecialEffectsLayer(layer:int = 1)
      {
         this._specialType = layer;
         super(new ItemTemplateInfo());
      }
      
      override protected function getUrl(layer:int) : String
      {
         return PathManager.SITE_MAIN + "image/equip/effects/specialEffect/effect_" + layer + ".png";
      }
      
      override protected function initLoaders() : void
      {
         var url:String = this.getUrl(this._specialType);
         var l:BitmapLoader = LoadResourceManager.Instance.createLoader(url,BaseLoader.BITMAP_LOADER);
         _queueLoader.addLoader(l);
      }
   }
}

