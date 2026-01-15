package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class BaseWingLayer extends Sprite implements ILayer
   {
      
      public static const SHOW_WING:int = 0;
      
      public static const GAME_WING:int = 1;
      
      protected var _info:ItemTemplateInfo;
      
      protected var _callBack:Function;
      
      protected var _loader:ModuleLoader;
      
      protected var _showType:int = 0;
      
      protected var _wing:MovieClip;
      
      private var _isComplete:Boolean;
      
      public function BaseWingLayer(info:ItemTemplateInfo, showType:int = 0)
      {
         this._info = info;
         this._showType = showType;
         super();
      }
      
      protected function initLoader() : void
      {
         if(!ClassUtils.uiSourceDomain.hasDefinition("wing_" + this.getshowTypeString() + "_" + this.info.TemplateID))
         {
            this._loader = LoadResourceManager.Instance.createLoader(this.getUrl(),BaseLoader.MODULE_LOADER);
            this._loader.addEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
            LoadResourceManager.Instance.startLoad(this._loader);
         }
         else
         {
            this.__sourceComplete();
         }
      }
      
      protected function __sourceComplete(event:LoaderEvent = null) : void
      {
         var WingClass:Object = null;
         if(this.info == null)
         {
            return;
         }
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
         }
         if(event != null && !event.loader.isSuccess)
         {
            this._wing = null;
         }
         else
         {
            WingClass = ClassUtils.uiSourceDomain.getDefinition("wing_" + this.getshowTypeString() + "_" + this.info.TemplateID) as Class;
            this._wing = new WingClass();
         }
         this._isComplete = true;
         if(this._callBack != null)
         {
            this._callBack(this);
         }
      }
      
      public function setColor(color:*) : Boolean
      {
         return false;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._info;
      }
      
      public function set info(value:ItemTemplateInfo) : void
      {
         this._info = value;
      }
      
      public function getContent() : DisplayObject
      {
         return this._wing;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
            this._loader = null;
         }
         this._wing = null;
         this._callBack = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function load(callBack:Function) : void
      {
         this._callBack = callBack;
         this.initLoader();
      }
      
      private function loadLayerComplete() : void
      {
      }
      
      public function set currentEdit(n:int) : void
      {
      }
      
      public function get currentEdit() : int
      {
         return 0;
      }
      
      override public function get width() : Number
      {
         return 0;
      }
      
      override public function get height() : Number
      {
         return 0;
      }
      
      protected function getUrl() : String
      {
         return PathManager.soloveWingPath(this.info.Pic);
      }
      
      public function getshowTypeString() : String
      {
         if(this._showType == 0)
         {
            return "show";
         }
         return "game";
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
   }
}

