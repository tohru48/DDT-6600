package game.model
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.utils.StringUtils;
   import ddt.manager.LoadBombManager;
   import ddt.manager.PathManager;
   import flash.events.EventDispatcher;
   
   public class GameNeedMovieInfo extends EventDispatcher
   {
      
      private var _type:int;
      
      public var path:String;
      
      private var _classPath:String;
      
      private var _loader:BaseLoader;
      
      public var bombId:int;
      
      public function GameNeedMovieInfo()
      {
         super();
      }
      
      public function get classPath() : String
      {
         return this._classPath;
      }
      
      public function set classPath(value:String) : void
      {
         this._classPath = value;
         var id:String = this.classPath.replace("tank.resource.bombs.Bomb","");
         this.bombId = int(id);
      }
      
      public function get filePath() : String
      {
         var mainPath:String = "";
         if(this._type == 2)
         {
            mainPath = PathManager.SITE_MAIN;
         }
         return mainPath + this.path;
      }
      
      public function startLoad() : void
      {
         if(StringUtils.endsWith(this.filePath.toLocaleLowerCase(),"jpg") || StringUtils.endsWith(this.filePath.toLocaleLowerCase(),"png"))
         {
            LoadResourceManager.Instance.creatAndStartLoad(this.filePath,BaseLoader.BITMAP_LOADER);
         }
         else
         {
            if(this._type == 2)
            {
               this._loader = LoadResourceManager.Instance.createLoader(this.filePath,BaseLoader.MODULE_LOADER);
               this._loader.addEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
               LoadResourceManager.Instance.startLoad(this._loader);
            }
            if(this._type == 1)
            {
               LoadBombManager.Instance.loadLivingBomb(this.bombId);
            }
         }
      }
      
      private function __loaderComplete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
         dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,event.loader));
      }
      
      public function get loader() : BaseLoader
      {
         return this._loader;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(value:int) : void
      {
         this._type = value;
      }
   }
}

