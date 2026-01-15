package trainer.controller
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PreviewFrameManager;
   import ddt.manager.SocketManager;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import road7th.utils.MovieClipWrapper;
   import trainer.data.Step;
   
   public class WeakGuildManager
   {
      
      private static var _instance:WeakGuildManager;
      
      private const LV:int = 15;
      
      private var _type:String;
      
      private var _title:String;
      
      private var _newTask:Boolean;
      
      private var _bmpLoader:BitmapLoader;
      
      public function WeakGuildManager()
      {
         super();
      }
      
      public static function get Instance() : WeakGuildManager
      {
         if(_instance == null)
         {
            _instance = new WeakGuildManager();
         }
         return _instance;
      }
      
      public function get switchUserGuide() : Boolean
      {
         return PathManager.solveUserGuildEnable();
      }
      
      public function get newTask() : Boolean
      {
         return this._newTask;
      }
      
      public function set newTask(value:Boolean) : void
      {
         this._newTask = value;
      }
      
      public function setup() : void
      {
         if(this.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onChange);
         }
      }
      
      private function __onChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Grade"]) && PlayerManager.Instance.Self.IsUpGrade)
         {
            this.checkLevelFunction();
            MainToolBar.Instance.btnOpen();
            MainToolBar.Instance.refresh();
         }
      }
      
      public function timeStatistics(type:int, startTime:Number) : void
      {
         var time:Number = new Date().getTime() - startTime;
         if(type == 0)
         {
            if(time <= 60 * 1000)
            {
               return;
            }
         }
         else if(type == 1)
         {
            if(time <= 30 * 1000)
            {
               return;
            }
         }
         var urlVar:URLVariables = new URLVariables();
         urlVar.id = PlayerManager.Instance.Self.ID;
         urlVar.type = type;
         urlVar.time = time;
         urlVar.grade = PlayerManager.Instance.Self.Grade;
         urlVar.serverID = PlayerManager.Instance.Self.ZoneID;
         var url:URLRequest = new URLRequest(PathManager.solveRequestPath("LogTime.ashx"));
         url.method = URLRequestMethod.POST;
         url.data = urlVar;
         var loader:URLLoader = new URLLoader();
         loader.load(url);
      }
      
      public function statistics(type:int, startTime:Number) : void
      {
         var time:Number = new Date().getTime() - startTime;
         var urlVar:URLVariables = new URLVariables();
         urlVar.id = PlayerManager.Instance.Self.ID;
         urlVar.type = type;
         urlVar.time = time;
         urlVar.grade = PlayerManager.Instance.Self.Grade;
         urlVar.serverID = PlayerManager.Instance.Self.ZoneID;
         var url:URLRequest = new URLRequest(PathManager.solveRequestPath("LogTime.ashx"));
         url.method = URLRequestMethod.POST;
         url.data = urlVar;
         var loader:URLLoader = new URLLoader();
         loader.load(url);
      }
      
      public function setStepFinish(step:int) : void
      {
         step--;
         var index:int = step / 8;
         var offset:int = step % 8;
         var b:ByteArray = PlayerManager.Instance.Self.weaklessGuildProgress;
         if(Boolean(b))
         {
            b[index] |= 1 << offset;
            PlayerManager.Instance.Self.weaklessGuildProgress = b;
         }
      }
      
      public function showMainToolBarBtnOpen(step:int, pos:String) : void
      {
         var p:Point = null;
         var mc:MovieClipWrapper = null;
         p = ComponentFactory.Instance.creatCustomObject(pos);
         mc = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer.openMainToolBtn"),true,true);
         mc.movie.x = p.x;
         mc.movie.y = p.y;
         LayerManager.Instance.addToLayer(mc.movie,LayerManager.GAME_DYNAMIC_LAYER,false);
         SocketManager.Instance.out.syncWeakStep(step);
      }
      
      public function checkFunction() : void
      {
         this.checkLevelFunction();
      }
      
      public function checkOpen(step:int, lv:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Grade < lv)
         {
            return false;
         }
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return true;
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(step))
         {
            return false;
         }
         return true;
      }
      
      public function openBuildTip(buildName:String) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.hall.ChooseHallView.openBuildTip",LanguageMgr.GetTranslation(buildName)));
      }
      
      public function showBuildPreview(type:String, title:String) : void
      {
         this._type = type;
         this._title = title;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         this._bmpLoader = LoadResourceManager.Instance.createLoader(PathManager.solveNewHandBuild(this._type),BaseLoader.BITMAP_LOADER);
         this._bmpLoader.addEventListener(LoaderEvent.PROGRESS,this.__loadProgress);
         this._bmpLoader.addEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
         LoadResourceManager.Instance.startLoad(this._bmpLoader);
      }
      
      private function __loadProgress(evt:LoaderEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = evt.loader.progress * 100;
      }
      
      private function __loadComplete(evt:LoaderEvent) : void
      {
         this.disposeBmpLoader();
         if(evt.loader.isSuccess)
         {
            PreviewFrameManager.Instance.createBuildPreviewFrame(this._title,evt.loader.content);
         }
      }
      
      private function __onClose(event:Event) : void
      {
         this.disposeBmpLoader();
      }
      
      private function disposeBmpLoader() : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleSmallLoading.Instance.hide();
         if(Boolean(this._bmpLoader))
         {
            this._bmpLoader.removeEventListener(LoaderEvent.PROGRESS,this.__loadProgress);
            this._bmpLoader.removeEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
            this._bmpLoader = null;
         }
      }
      
      private function checkLevelFunction() : void
      {
         var lv:int = PlayerManager.Instance.Self.Grade;
         if(lv > 1)
         {
            this.openFunction(Step.GAME_ROOM_OPEN);
            this.openFunction(Step.CHANNEL_OPEN);
         }
         if(lv > 2)
         {
            this.openFunction(Step.SHOP_OPEN);
            this.openFunction(Step.STORE_OPEN);
            this.openFunction(Step.BAG_OPEN);
            this.openFunction(Step.MAIL_OPEN);
            this.openFunction(Step.SIGN_OPEN);
         }
         if(lv > 3)
         {
            this.openFunction(Step.HP_PROP_OPEN);
         }
         if(lv > 4)
         {
            this.openFunction(Step.GAME_ROOM_SHOW_OPEN);
            this.openFunction(Step.CIVIL_OPEN);
            this.openFunction(Step.IM_OPEN);
            this.openFunction(Step.GUILD_PROP_OPEN);
         }
         if(lv > 5)
         {
            this.openFunction(Step.CIVIL_SHOW);
            this.openFunction(Step.MASTER_ROOM_OPEN);
            this.openFunction(Step.POWER_PROP_OPEN);
         }
         if(lv > 6)
         {
            this.openFunction(Step.MASTER_ROOM_SHOW);
            this.openFunction(Step.CONSORTIA_OPEN);
            this.openFunction(Step.HIDE_PROP_OPEN);
            this.openFunction(Step.PLANE_PROP_OPEN);
         }
         if(lv > 7)
         {
            this.openFunction(Step.CONSORTIA_SHOW);
            this.openFunction(Step.DUNGEON_OPEN);
            this.openFunction(Step.FROZE_PROP_OPEN);
         }
         if(lv > 8)
         {
            this.openFunction(Step.DUNGEON_SHOW);
            this.openFunction(Step.VANE_OPEN);
         }
         if(lv > 9)
         {
            this.openFunction(Step.CHURCH_OPEN);
         }
         if(lv > 11)
         {
            this.openFunction(Step.CHURCH_SHOW);
            this.openFunction(Step.TOFF_LIST_OPEN);
         }
         if(lv > 12)
         {
            this.openFunction(Step.TOFF_LIST_SHOW);
            this.openFunction(Step.HOT_WELL_OPEN);
         }
         if(lv > 13)
         {
            this.openFunction(Step.HOT_WELL_SHOW);
            this.openFunction(Step.AUCTION_OPEN);
         }
         if(lv > 14)
         {
            this.openFunction(Step.AUCTION_SHOW);
            this.openFunction(Step.CAMPAIGN_LAB_OPEN);
         }
      }
      
      private function openFunction(id:int) : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(id))
         {
            SocketManager.Instance.out.syncWeakStep(id);
            if(id == Step.POWER_PROP_OPEN)
            {
               NoviceDataManager.instance.saveNoviceData(560,PathManager.userName(),PathManager.solveRequestPath());
            }
         }
      }
   }
}

