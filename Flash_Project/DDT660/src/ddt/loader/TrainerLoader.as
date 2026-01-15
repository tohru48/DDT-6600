package ddt.loader
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.UIModuleTypes;
   import flash.events.EventDispatcher;
   
   public class TrainerLoader extends EventDispatcher implements Disposeable
   {
      
      private var _module:String;
      
      private var _loadCompleted:Boolean;
      
      public function TrainerLoader(module:String)
      {
         super();
         this._module = UIModuleTypes.TRAINER + module;
      }
      
      public function get completed() : Boolean
      {
         return this._loadCompleted;
      }
      
      public function load() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.addUIModuleImp(this._module);
      }
      
      private function __onUIModuleComplete(evt:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         if(evt.module == this._module)
         {
            this._loadCompleted = true;
         }
      }
      
      public function dispose() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
      }
   }
}

