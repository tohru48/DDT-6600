package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   
   public class IconLayer extends BaseLayer
   {
      
      public function IconLayer(info:ItemTemplateInfo, color:String = "", gunback:Boolean = false, hairType:int = 1)
      {
         super(info,color,gunback,hairType);
      }
      
      override protected function initLoaders() : void
      {
         var url:String = null;
         var l:BitmapLoader = null;
         if(_info != null)
         {
            url = this.getUrl(1);
            l = LoadResourceManager.Instance.createLoader(url,BaseLoader.BITMAP_LOADER);
            _queueLoader.addLoader(l);
            _defaultLayer = 0;
            _currentEdit = _info.Property8 == null ? 0 : uint(_info.Property8.length);
         }
      }
      
      override protected function getUrl(layer:int) : String
      {
         return PathManager.solveGoodsPath(_info.CategoryID,_info.Pic,_info.NeedSex == 1,BaseLayer.ICON,_hairType,String(layer),_info.Level,_gunBack,int(_info.Property1));
      }
   }
}

