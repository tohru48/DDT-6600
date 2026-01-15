package cryptBoss
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import cryptBoss.data.CryptBossItemInfo;
   import cryptBoss.view.CryptBossMainFrame;
   import ddt.data.UIModuleTypes;
   import ddt.data.map.DungeonInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.MapManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   
   public class CryptBossManager
   {
      
      private static var _instance:CryptBossManager;
      
      public static var loadComplete:Boolean = false;
      
      public var RoomType:int = 0;
      
      public var openWeekDaysDic:Dictionary;
      
      private var _cryptBossFrame:CryptBossMainFrame;
      
      public function CryptBossManager()
      {
         super();
      }
      
      public static function get instance() : CryptBossManager
      {
         if(!_instance)
         {
            _instance = new CryptBossManager();
         }
         return _instance;
      }
      
      public function setUp() : void
      {
         this.openWeekDaysDic = new Dictionary();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CRYPTBOSS,this.pkgHandler);
      }
      
      protected function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case CryptBossEvent.GET_BOSS_DATA:
               this.initAllData(pkg);
               break;
            case CryptBossEvent.UPDATE_SINGLEBOSS_DATA:
               this.updateSingleData(pkg);
         }
      }
      
      private function updateSingleData(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var star:int = pkg.readInt();
         var state:int = pkg.readInt();
         var itemInfo:CryptBossItemInfo = this.openWeekDaysDic[id];
         itemInfo.id = id;
         itemInfo.star = star;
         itemInfo.state = state;
         if(Boolean(this._cryptBossFrame))
         {
            this._cryptBossFrame.updateView();
         }
      }
      
      private function initAllData(pkg:PackageIn) : void
      {
         var info:CryptBossItemInfo = null;
         var temp:Array = null;
         var openArr:Array = null;
         var j:int = 0;
         var count:int = pkg.readInt();
         if(count == 0)
         {
            return;
         }
         for(var k:int = 0; k < count; k++)
         {
            info = new CryptBossItemInfo();
            info.id = pkg.readInt();
            info.star = pkg.readInt();
            info.state = pkg.readInt();
            this.openWeekDaysDic[info.id] = info;
         }
         var arr:Array = ServerConfigManager.instance.cryptBossOpenDay;
         for(var i:int = 0; i < arr.length; i++)
         {
            temp = arr[i].split(",");
            openArr = [];
            for(j = 1; j < temp.length; j++)
            {
               openArr.push(temp[j]);
            }
            (this.openWeekDaysDic[temp[0]] as CryptBossItemInfo).openWeekDaysArr = openArr;
         }
         if(Boolean(this._cryptBossFrame))
         {
            this._cryptBossFrame.updateView();
         }
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showFrame();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CRYPT_BOSS);
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CRYPT_BOSS)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            loadComplete = true;
            this.show();
         }
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.HORSE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function showFrame() : void
      {
         if(!this._cryptBossFrame)
         {
            this._cryptBossFrame = ComponentFactory.Instance.creatComponentByStylename("CryptBossMainFrame");
            this._cryptBossFrame.addEventListener(ComponentEvent.DISPOSE,this.frameDisposeHandler,false,0,true);
            LayerManager.Instance.addToLayer(this._cryptBossFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function getTemplateIdArr(mapId:int, star:int) : Array
      {
         var dungeon:DungeonInfo = MapManager.getDungeonInfo(mapId);
         switch(star)
         {
            case 1:
               return dungeon.SimpleTemplateIds.split(",");
            case 2:
               return dungeon.NormalTemplateIds.split(",");
            case 3:
               return dungeon.HardTemplateIds.split(",");
            case 4:
               return dungeon.TerrorTemplateIds.split(",");
            case 5:
               return dungeon.NightmareTemplateIds.split(",");
            default:
               return [];
         }
      }
      
      private function frameDisposeHandler(event:ComponentEvent) : void
      {
         if(Boolean(this._cryptBossFrame))
         {
            this._cryptBossFrame.removeEventListener(ComponentEvent.DISPOSE,this.frameDisposeHandler);
         }
         this._cryptBossFrame = null;
      }
   }
}

