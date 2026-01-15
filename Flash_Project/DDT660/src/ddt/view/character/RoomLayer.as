package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   
   public class RoomLayer extends BaseLayer
   {
      
      private var _clothType:int = 0;
      
      public function RoomLayer(info:ItemTemplateInfo, color:String = "", gunback:Boolean = false, hairType:int = 1, pic:String = null, clothType:int = 0)
      {
         this._clothType = clothType;
         super(info,color,gunback,hairType,pic);
      }
      
      override protected function getUrl(layer:int) : String
      {
         if(this._clothType == 0)
         {
            return PathManager.solveGoodsPath(_info.CategoryID,_pic,_info.NeedSex == 1,SHOW,_hairType,String(layer),_info.Level,_gunBack,int(_info.Property1));
         }
         return "normal.png";
      }
      
      override protected function initLoaders() : void
      {
         var url:String = null;
         var l:BitmapLoader = null;
         if(Boolean(_info))
         {
            url = this.getUrl(0);
            l = LoadResourceManager.Instance.createLoader(url,BaseLoader.BITMAP_LOADER);
            _queueLoader.addLoader(l);
         }
      }
      
      override public function reSetBitmap() : void
      {
         var i:int = 0;
         clearBitmap();
         for(i = 0; i < _queueLoader.loaders.length; i++)
         {
            _bitmaps.push(_queueLoader.loaders[i].content);
            if(Boolean(_bitmaps[i]))
            {
               _bitmaps[i].smoothing = true;
               _bitmaps[i].visible = false;
               addChild(_bitmaps[i]);
            }
         }
      }
   }
}

