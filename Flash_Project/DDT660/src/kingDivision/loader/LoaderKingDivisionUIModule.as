package kingDivision.loader
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   
   public class LoaderKingDivisionUIModule
   {
      
      private static var _instance:LoaderKingDivisionUIModule;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public function LoaderKingDivisionUIModule(prc:PrivateClass)
      {
         super();
      }
      
      public static function get Instance() : LoaderKingDivisionUIModule
      {
         if(LoaderKingDivisionUIModule._instance == null)
         {
            LoaderKingDivisionUIModule._instance = new LoaderKingDivisionUIModule(new PrivateClass());
         }
         return LoaderKingDivisionUIModule._instance;
      }
      
      public function loadUIModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.KINGDIVISION);
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.KINGDIVISION)
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
         if(event.module == UIModuleTypes.KINGDIVISION)
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
