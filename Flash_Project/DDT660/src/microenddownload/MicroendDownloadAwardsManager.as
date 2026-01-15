package microenddownload
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import microenddownload.view.MicroendDownload;
   
   public class MicroendDownloadAwardsManager extends EventDispatcher
   {
      
      private static var instance:MicroendDownloadAwardsManager;
      
      public static const SHOW:String = "show";
      
      private var _callback:Function;
      
      private var _loadProgress:int = 0;
      
      private var _UILoadComplete:Boolean = false;
      
      private var _frameConfirm:MicroendDownload;
      
      private var info:ItemTemplateInfo;
      
      private var bagCellIdList:Vector.<ItemTemplateInfo>;
      
      private var _list:Array;
      
      public function MicroendDownloadAwardsManager(single:inner)
      {
         super();
      }
      
      public static function getInstance() : MicroendDownloadAwardsManager
      {
         if(!instance)
         {
            instance = new MicroendDownloadAwardsManager(new inner());
         }
         return instance;
      }
      
      public function loadUIModule() : void
      {
         if(!this._UILoadComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FRISTRECHARGE_SYS);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MICRO_END_DOWNLOAD);
         }
         else
         {
            this.show();
         }
      }
      
      private function show() : void
      {
         this._frameConfirm = ComponentFactory.Instance.creatComponentByStylename("microenddownload.firstView");
         LayerManager.Instance.addToLayer(this._frameConfirm,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function setup(list:Array) : void
      {
         this._list = list;
         this.bagCellIdList = new Vector.<ItemTemplateInfo>();
         for(var i:int = 0; i < list.length; i++)
         {
            this.bagCellIdList[i] = ItemManager.Instance.getTemplateById(list[i]["id"]);
         }
      }
      
      public function getAwardsDetail() : Vector.<ItemTemplateInfo>
      {
         return this.bagCellIdList;
      }
      
      public function getCount(index:int) : int
      {
         return this._list[index]["count"];
      }
      
      protected function __onProgress(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      protected function __onUIModuleComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.FRISTRECHARGE_SYS || event.module == UIModuleTypes.MICRO_END_DOWNLOAD)
         {
            ++this._loadProgress;
            if(this._loadProgress >= 2)
            {
               this._UILoadComplete = true;
            }
         }
         if(this._UILoadComplete)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleSmallLoading.Instance.hide();
            if(this._callback != null)
            {
               this._callback();
            }
            this.show();
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

class inner
{
   
   public function inner()
   {
      super();
   }
}
