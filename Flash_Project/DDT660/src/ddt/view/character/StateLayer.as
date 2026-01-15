package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import flash.events.Event;
   
   public class StateLayer extends BaseLayer
   {
      
      private var _stateType:int;
      
      private var _sex:Boolean;
      
      public function StateLayer(info:ItemTemplateInfo, sex:Boolean, color:String, type:int = 1)
      {
         this._stateType = type;
         this._sex = sex;
         super(info,color);
      }
      
      override protected function getUrl(layer:int) : String
      {
         return PathManager.SITE_MAIN + "image/equip/effects/state/" + (this._sex ? "m/" : "f/") + this._stateType + "/show" + layer + ".png";
      }
      
      override protected function initLoaders() : void
      {
         var url:String = null;
         var l:BitmapLoader = null;
         for(var i:int = 0; i < 3; i++)
         {
            url = this.getUrl(i + 1);
            l = LoadResourceManager.Instance.createLoader(url,BaseLoader.BITMAP_LOADER);
            _queueLoader.addLoader(l);
         }
         _defaultLayer = 0;
         _currentEdit = _queueLoader.length;
      }
      
      override protected function __loadComplete(event:Event) : void
      {
         reSetBitmap();
         _queueLoader.removeEventListener(Event.COMPLETE,this.__loadComplete);
         _queueLoader.removeEvent();
         initColors(_color);
         loadCompleteCallBack();
      }
   }
}

