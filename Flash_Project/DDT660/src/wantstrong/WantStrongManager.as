package wantstrong
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import wantstrong.data.WantStrongMenuData;
   import wantstrong.data.WantStrongModel;
   import wantstrong.view.WantStrongFrame;
   
   public class WantStrongManager extends EventDispatcher
   {
      
      private static var _instance:WantStrongManager;
      
      private var _frame:Frame;
      
      private var _model:WantStrongModel;
      
      private var _initState:*;
      
      private var _isTimeUpdated:Boolean;
      
      private var _findBackExist:Boolean;
      
      private var _findBackDataExist:Array;
      
      public var findBackDic:Dictionary;
      
      public var isPlayMovie:Boolean;
      
      public function WantStrongManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get Instance() : WantStrongManager
      {
         if(_instance == null)
         {
            _instance = new WantStrongManager();
         }
         return _instance;
      }
      
      public function get findBackDataExist() : Array
      {
         if(this._findBackDataExist == null)
         {
            this._findBackDataExist = new Array();
            this._findBackDataExist.push(false);
            this._findBackDataExist.push(false);
            this._findBackDataExist.push(false);
            this._findBackDataExist.push(false);
            this._findBackDataExist.push(false);
         }
         return this._findBackDataExist;
      }
      
      public function get findBackExist() : Boolean
      {
         return this._findBackExist;
      }
      
      public function set findBackExist(value:Boolean) : void
      {
         this.isPlayMovie = this._findBackExist = value;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.Find_Back_Income,this.findBackHandler);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WANT_STRONG);
      }
      
      private function findBackHandler(e:CrazyTankSocketEvent) : void
      {
         var data:Vector.<WantStrongMenuData> = null;
         var bType:int = e.pkg.readInt();
         var arr:Array = new Array();
         arr[0] = e.pkg.readBoolean();
         arr[1] = e.pkg.readBoolean();
         if(this.isPlayMovie)
         {
            if(Boolean(arr[0]) || Boolean(arr[1]))
            {
               this.isPlayMovie = false;
               WantStrongManager.Instance.dispatchEvent(new Event("alreadyFindBack"));
            }
         }
         this.findBackDic[bType] = arr;
         for(var i:int = 0; i < this._model.data[5].length; i++)
         {
            if((this._model.data[5][i] as WantStrongMenuData).bossType == bType)
            {
               (this._model.data[5][i] as WantStrongMenuData).freeBackBtnEnable = !arr[0];
               (this._model.data[5][i] as WantStrongMenuData).allBackBtnEnable = !arr[1];
               if(Boolean(arr[0]) && Boolean(arr[1]))
               {
                  data = this._model.data[5];
                  data.splice(i,1);
                  if(bType == 6)
                  {
                     this.findBackDataExist[0] = false;
                  }
                  else if(bType == 18)
                  {
                     this.findBackDataExist[1] = false;
                  }
                  else if(bType == 19)
                  {
                     this.findBackDataExist[2] = false;
                  }
                  else if(bType == 4)
                  {
                     this.findBackDataExist[4] = false;
                  }
                  else if(bType == 5)
                  {
                     this.findBackDataExist[3] = false;
                  }
               }
            }
         }
         this.updateFindBackView();
      }
      
      private function updateFindBackView() : void
      {
         if(this._model.data[5].length > 0)
         {
            this._model.activeId = 5;
         }
         else
         {
            this._model.activeId = 1;
         }
         dispatchEvent(new Event("cellChange"));
         this.setCurrentInfo(this._model.data[this._model.activeId],true);
      }
      
      private function setData() : void
      {
         if(this.findBackExist)
         {
            this._model.initFindBackData();
            this._model.activeId = 5;
         }
         this._model.initData();
         this._initState = this._model.data[this._model.activeId];
      }
      
      public function setFindBackData(index:int) : void
      {
         this.findBackDataExist[index] = true;
      }
      
      protected function _loaderErrorHandle(event:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
         this.close();
      }
      
      public function close() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
         ObjectUtils.disposeObject(this._model);
         this._model = null;
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
      }
      
      protected function _loaderProgressHandle(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      public function setCurrentInfo(data:* = null, stateChange:Boolean = false) : void
      {
         if(Boolean(this._frame))
         {
            (this._frame as WantStrongFrame).setInfo(data,stateChange);
         }
      }
      
      protected function _loaderCompleteHandle(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.WANT_STRONG)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
            UIModuleSmallLoading.Instance.hide();
            if(!this._model)
            {
               this._model = new WantStrongModel();
            }
            this.setData();
            this._frame = ComponentFactory.Instance.creatCustomObject("wantStrong.WantStrongFrame",[this._model]);
            this._frame.titleText = LanguageMgr.GetTranslation("ddt.wantStrong.view.titleText");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this.setCurrentInfo(this._initState);
         }
      }
      
      protected function _loadingCloseHandle(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
      }
      
      public function setinitState(value:*) : void
      {
         this._initState = value;
      }
      
      public function get isTimeUpdated() : Boolean
      {
         return this._isTimeUpdated;
      }
      
      public function set isTimeUpdated(value:Boolean) : void
      {
         this._isTimeUpdated = value;
      }
   }
}

