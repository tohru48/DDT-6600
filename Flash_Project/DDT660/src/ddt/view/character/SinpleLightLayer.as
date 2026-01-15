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
   
   public class SinpleLightLayer extends Sprite implements ILayer
   {
      
      private var _light:MovieClip;
      
      private var _type:int;
      
      private var _callBack:Function;
      
      private var _loader:ModuleLoader;
      
      private var _nimbus:int;
      
      private var _isComplete:Boolean;
      
      public function SinpleLightLayer(nimbus:int, showType:int = 0)
      {
         super();
         this._nimbus = nimbus;
         this._type = showType;
      }
      
      public function load(callBack:Function) : void
      {
         this._callBack = callBack;
         this.initLoader();
      }
      
      protected function initLoader() : void
      {
         if(this._nimbus < 100)
         {
            return;
         }
         if(!ClassUtils.uiSourceDomain.hasDefinition("game.crazyTank.view.light.SinpleLightAsset_" + this.getId()))
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
      
      private function getId() : String
      {
         var i:int = int(this._nimbus / 100);
         return i.toString();
      }
      
      protected function __sourceComplete(event:LoaderEvent = null) : void
      {
         var LightClass:Object = null;
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
         }
         if(event != null && !event.loader.isSuccess)
         {
            this._light = null;
         }
         else
         {
            LightClass = ClassUtils.uiSourceDomain.getDefinition("game.crazyTank.view.light.SinpleLightAsset_" + this.getId()) as Class;
            this._light = new LightClass() as MovieClip;
         }
         this._isComplete = true;
         if(this._callBack != null)
         {
            this._callBack(this);
         }
      }
      
      protected function getUrl() : String
      {
         return PathManager.soloveSinpleLightPath(this.getId());
      }
      
      public function getshowTypeString() : String
      {
         if(this._type == 0)
         {
            return "show";
         }
         return "game";
      }
      
      public function get info() : ItemTemplateInfo
      {
         return null;
      }
      
      public function set info(value:ItemTemplateInfo) : void
      {
      }
      
      public function getContent() : DisplayObject
      {
         return this._light;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._light) && Boolean(this._light.parent))
         {
            this._light.parent.removeChild(this._light);
         }
         this._light = null;
         this._callBack = null;
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
         }
         this._loader = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function set currentEdit(n:int) : void
      {
      }
      
      public function get currentEdit() : int
      {
         return 0;
      }
      
      public function setColor(color:*) : Boolean
      {
         return false;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
   }
}

