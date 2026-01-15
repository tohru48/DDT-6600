package cloudBuyLottery.loader
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.view.UIModuleSmallLoading;
   
   public class LoaderUIModule
   {
      
      private static var _instance:LoaderUIModule;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _type:String;
      
      public function LoaderUIModule(prc:PrivateClass)
      {
         super();
      }
      
      public static function get Instance() : LoaderUIModule
      {
         if(LoaderUIModule._instance == null)
         {
            LoaderUIModule._instance = new LoaderUIModule(new PrivateClass());
         }
         return LoaderUIModule._instance;
      }
      
      public function loadUIModule(complete:Function = null, completeParams:Array = null, types:String = "") : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         this._type = types;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(this._type);
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == this._type)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == this._type)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
