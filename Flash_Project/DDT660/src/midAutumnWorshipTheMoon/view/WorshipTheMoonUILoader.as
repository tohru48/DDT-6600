package midAutumnWorshipTheMoon.view
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class WorshipTheMoonUILoader
   {
      
      private static var _loadedDic:Dictionary = new Dictionary();
      
      private var _loadProgress:int = 0;
      
      private var _UILoadComplete:Boolean = false;
      
      private var _list:Array;
      
      private var _update:Function;
      
      private var _loadListID:String;
      
      public function WorshipTheMoonUILoader()
      {
         super();
      }
      
      public function loadUIModule(loadListID:String, list:Array, update:Function) : void
      {
         var len:int = 0;
         var i:int = 0;
         if(_loadedDic[loadListID] != null)
         {
            update();
            return;
         }
         this._loadListID = loadListID;
         this._list = list;
         this._update = update;
         if(!this._UILoadComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            len = int(list.length);
            for(i = 0; i < len; i++)
            {
               UIModuleLoader.Instance.addUIModuleImp(list[i]);
            }
         }
         else
         {
            this._update();
         }
      }
      
      protected function __onProgress(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      protected function __onUIModuleComplete(event:UIModuleEvent) : void
      {
         this.checkComplete(event.module);
         if(this._UILoadComplete)
         {
            _loadedDic[this._loadListID] = 1;
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleSmallLoading.Instance.hide();
            this._update();
         }
      }
      
      private function checkComplete(moduleName:String) : void
      {
         var n:String = null;
         for each(n in this._list)
         {
            if(n == moduleName)
            {
               ++this._loadProgress;
               if(this._loadProgress >= this._list.length)
               {
                  this._UILoadComplete = true;
               }
            }
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
   }
}

