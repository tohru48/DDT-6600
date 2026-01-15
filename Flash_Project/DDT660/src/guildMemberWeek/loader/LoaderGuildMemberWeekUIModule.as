package guildMemberWeek.loader
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.controls.Frame;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   
   public class LoaderGuildMemberWeekUIModule extends Frame
   {
      
      private static var _instance:LoaderGuildMemberWeekUIModule;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _LoadResourseOK:Boolean = false;
      
      public function LoaderGuildMemberWeekUIModule(pct:PrivateClass)
      {
         super();
      }
      
      public static function get Instance() : LoaderGuildMemberWeekUIModule
      {
         if(LoaderGuildMemberWeekUIModule._instance == null)
         {
            LoaderGuildMemberWeekUIModule._instance = new LoaderGuildMemberWeekUIModule(new PrivateClass());
         }
         return LoaderGuildMemberWeekUIModule._instance;
      }
      
      public function loadUIModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         if(!this._LoadResourseOK)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GUILDMEMBERWEEK);
         }
         else
         {
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         this._LoadResourseOK = true;
         if(event.module == UIModuleTypes.GUILDMEMBERWEEK)
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
         if(event.module == UIModuleTypes.CHRISTMAS)
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
