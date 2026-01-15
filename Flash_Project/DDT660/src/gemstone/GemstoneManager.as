package gemstone
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstonInitInfo;
   import gemstone.info.GemstoneAnalyze;
   import gemstone.info.GemstoneInfo;
   import gemstone.info.GemstoneStaticInfo;
   import gemstone.info.GemstoneUpGradeInfo;
   import gemstone.items.ExpBar;
   import gemstone.items.GemstoneContent;
   import gemstone.items.Item;
   
   public class GemstoneManager extends EventDispatcher
   {
      
      private static var _instance:GemstoneManager;
      
      public static const SuitPLACE:int = 11;
      
      public static const GlassPPLACE:int = 5;
      
      public static const HariPPLACE:int = 2;
      
      public static const FacePLACE:int = 3;
      
      public static const DecorationPLACE:int = 13;
      
      public static const ID1:int = 100001;
      
      public static const ID2:int = 100002;
      
      public static const ID3:int = 100003;
      
      public static const ID4:int = 100004;
      
      public static const ID5:int = 100005;
      
      private var _gemstoneFrame:GemstoneFrame;
      
      private var _stoneInfoList:Vector.<GemstoneInfo>;
      
      private var _stoneItemList:Vector.<Item>;
      
      private var _stoneContentGroupList:Array;
      
      private var _stoneContentList:Array;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _loader:BaseLoader;
      
      private var _redUrl:String;
      
      private var _bulUrl:String;
      
      private var _greUrl:String;
      
      private var _yelUrl:String;
      
      private var _purpleUrl:String;
      
      private var _upGradeList:Vector.<GemstoneUpGradeInfo>;
      
      public var redInfoList:Vector.<GemstoneStaticInfo>;
      
      public var bluInfoList:Vector.<GemstoneStaticInfo>;
      
      public var greInfoList:Vector.<GemstoneStaticInfo>;
      
      public var yelInfoList:Vector.<GemstoneStaticInfo>;
      
      public var purpleInfoList:Vector.<GemstoneStaticInfo>;
      
      public var curstatiDataList:Vector.<GemstoneStaticInfo>;
      
      public var curItem:GemstoneContent;
      
      public var curGemstoneUpInfo:GemstoneUpGradeInfo;
      
      private var _gInfoList:Object;
      
      public var suitList:Vector.<GemstListInfo> = new Vector.<GemstListInfo>();
      
      public var glassList:Vector.<GemstListInfo> = new Vector.<GemstListInfo>();
      
      public var hariList:Vector.<GemstListInfo> = new Vector.<GemstListInfo>();
      
      public var faceList:Vector.<GemstListInfo> = new Vector.<GemstListInfo>();
      
      public var decorationList:Vector.<GemstListInfo> = new Vector.<GemstListInfo>();
      
      public var curMaxLevel:uint = 12;
      
      public function GemstoneManager()
      {
         super();
         this._upGradeList = new Vector.<GemstoneUpGradeInfo>();
      }
      
      public static function get Instance() : GemstoneManager
      {
         if(_instance == null)
         {
            _instance = new GemstoneManager();
         }
         return _instance;
      }
      
      public function loaderData() : void
      {
         this._loader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("FightSpiritTemplateList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.loaderComplete);
      }
      
      private function compeleteHander(analyze:GemstoneAnalyze) : void
      {
      }
      
      private function loaderComplete(event:LoaderEvent) : void
      {
         var gInfo:GemstoneStaticInfo = null;
         this.redInfoList = new Vector.<GemstoneStaticInfo>();
         this.bluInfoList = new Vector.<GemstoneStaticInfo>();
         this.greInfoList = new Vector.<GemstoneStaticInfo>();
         this.yelInfoList = new Vector.<GemstoneStaticInfo>();
         this.purpleInfoList = new Vector.<GemstoneStaticInfo>();
         this._gInfoList = new Vector.<GemstoneStaticInfo>();
         var xml:XML = new XML(event.loader.content);
         var len:int = int(xml.item.length());
         for(var i:int = 0; i < len; i++)
         {
            gInfo = new GemstoneStaticInfo();
            gInfo.id = xml.item[i].@FightSpiritID;
            gInfo.fightSpiritIcon = xml.item[i].@FightSpiritIcon;
            gInfo.attack = xml.item[i].@Attack;
            gInfo.level = xml.item[i].@Level;
            gInfo.luck = xml.item[i].@Lucky;
            gInfo.Exp = xml.item[i].@Exp;
            gInfo.agility = xml.item[i].@Agility;
            gInfo.defence = xml.item[i].@Defence;
            gInfo.blood = xml.item[i].@Blood;
            this._gInfoList.push(gInfo);
            if(gInfo.id == ID1)
            {
               GemstoneManager.Instance.setRedUrl(gInfo.fightSpiritIcon);
               this.redInfoList.push(gInfo);
            }
            else if(gInfo.id == ID2)
            {
               GemstoneManager.Instance.setBulUrl(gInfo.fightSpiritIcon);
               this.bluInfoList.push(gInfo);
            }
            else if(gInfo.id == ID3)
            {
               GemstoneManager.Instance.setGreUrl(gInfo.fightSpiritIcon);
               this.greInfoList.push(gInfo);
            }
            else if(gInfo.id == ID4)
            {
               GemstoneManager.Instance.setYelUrl(gInfo.fightSpiritIcon);
               this.yelInfoList.push(gInfo);
            }
            else if(gInfo.id == ID5)
            {
               GemstoneManager.Instance.setPurpleUrl(gInfo.fightSpiritIcon);
               this.purpleInfoList.push(gInfo);
            }
         }
         this.curMaxLevel = this.bluInfoList.length - 1;
      }
      
      public function initView() : GemstoneFrame
      {
         this._gemstoneFrame = ComponentFactory.Instance.creatCustomObject("gemstoneFrame");
         return this._gemstoneFrame;
      }
      
      public function initFrame(gemstoneFrame:GemstoneFrame) : void
      {
         this._gemstoneFrame = gemstoneFrame;
      }
      
      public function clearFrame() : void
      {
         this._gemstoneFrame = null;
      }
      
      public function upDataFitCount() : void
      {
         if(Boolean(this._gemstoneFrame))
         {
            this._gemstoneFrame.upDatafitCount();
         }
      }
      
      public function get gemstoneFrame() : GemstoneFrame
      {
         return this._gemstoneFrame;
      }
      
      public function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_FIGHT_SPIRIT_UP,this.playerFigSpiritUp);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_SPIRIT_INIT,this.playerFigSpiritinit);
      }
      
      private function playerFigSpiritinit(event:CrazyTankSocketEvent) : void
      {
         var obj:GemstonInitInfo = null;
         var arr:Array = null;
         var list:Vector.<GemstListInfo> = null;
         var t_i:int = 0;
         var gems1:Array = null;
         var ginfo:GemstListInfo = null;
         var bool:Boolean = event.pkg.readBoolean();
         var count:int = event.pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            obj = new GemstonInitInfo();
            obj.userId = event.pkg.readInt();
            obj.figSpiritId = event.pkg.readInt();
            obj.figSpiritIdValue = event.pkg.readUTF();
            obj.equipPlace = event.pkg.readInt();
            arr = this.rezArr(obj.figSpiritIdValue);
            list = new Vector.<GemstListInfo>();
            for(t_i = 0; t_i < 3; t_i++)
            {
               gems1 = arr[t_i].split(",");
               ginfo = new GemstListInfo();
               ginfo.fightSpiritId = obj.figSpiritId;
               ginfo.level = gems1[0];
               ginfo.exp = gems1[1];
               ginfo.place = gems1[2];
               list.push(ginfo);
            }
            obj.list = list;
            switch(obj.equipPlace)
            {
               case SuitPLACE:
                  this.suitList = list;
                  break;
               case GlassPPLACE:
                  this.glassList = list;
                  break;
               case HariPPLACE:
                  this.hariList = list;
                  break;
               case FacePLACE:
                  this.faceList = list;
                  break;
               case DecorationPLACE:
                  this.decorationList = list;
                  break;
            }
         }
      }
      
      private function rezArr(str:String) : Array
      {
         return str.split("|");
      }
      
      protected function playerFigSpiritUp(event:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var gemstListInfo:GemstListInfo = null;
         var curGemstoneUpInfo:GemstoneUpGradeInfo = new GemstoneUpGradeInfo();
         curGemstoneUpInfo.isUp = event.pkg.readBoolean();
         curGemstoneUpInfo.isMaxLevel = event.pkg.readBoolean();
         curGemstoneUpInfo.isFall = event.pkg.readBoolean();
         curGemstoneUpInfo.num = event.pkg.readInt();
         var list:Vector.<GemstListInfo> = new Vector.<GemstListInfo>();
         for(var count:int = event.pkg.readInt(); i < count; )
         {
            gemstListInfo = new GemstListInfo();
            gemstListInfo.fightSpiritId = event.pkg.readInt();
            gemstListInfo.level = event.pkg.readInt();
            gemstListInfo.exp = event.pkg.readInt();
            gemstListInfo.place = event.pkg.readInt();
            list.push(gemstListInfo);
            i++;
         }
         curGemstoneUpInfo.equipPlace = event.pkg.readInt();
         curGemstoneUpInfo.dir = event.pkg.readInt();
         curGemstoneUpInfo.list = list;
         this.setGemstoneListInfo(curGemstoneUpInfo);
         if(Boolean(this._gemstoneFrame))
         {
            this._gemstoneFrame.upDatafitCount();
            this._gemstoneFrame.gemstoneAction(curGemstoneUpInfo);
         }
      }
      
      public function loadGemstoneModule(completeHandler:Function = null, completeParams:Array = null) : void
      {
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,completeHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GEMSTONE_SYS);
      }
      
      public function get expBar() : ExpBar
      {
         return this._gemstoneFrame.expBar;
      }
      
      public function getRedUrl() : String
      {
         return this._redUrl;
      }
      
      public function getYelUrl() : String
      {
         return this._yelUrl;
      }
      
      public function getPurpleUrl() : String
      {
         return this._purpleUrl;
      }
      
      public function getBulUrl() : String
      {
         return this._bulUrl;
      }
      
      public function getGreUrl() : String
      {
         return this._greUrl;
      }
      
      public function setRedUrl(str:String) : void
      {
         this._redUrl = str;
      }
      
      public function setYelUrl(str:String) : void
      {
         this._yelUrl = str;
      }
      
      public function setBulUrl(str:String) : void
      {
         this._bulUrl = str;
      }
      
      public function setGreUrl(str:String) : void
      {
         this._greUrl = str;
      }
      
      public function setPurpleUrl(str:String) : void
      {
         this._purpleUrl = str;
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.GEMSTONE_SYS)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      public function getSelfList(p:int) : Vector.<GemstListInfo>
      {
         if(p == GemstoneManager.DecorationPLACE)
         {
            return this.decorationList;
         }
         if(p == GemstoneManager.FacePLACE)
         {
            return this.faceList;
         }
         if(p == GemstoneManager.GlassPPLACE)
         {
            return this.glassList;
         }
         if(p == GemstoneManager.HariPPLACE)
         {
            return this.hariList;
         }
         if(p == GemstoneManager.SuitPLACE)
         {
            return this.suitList;
         }
         return null;
      }
      
      public function getByPlayerInfoList(p:int, playerID:int) : Vector.<GemstListInfo>
      {
         var gemstoneList:Vector.<GemstonInitInfo> = null;
         var playerInfo:PlayerInfo = PlayerManager.Instance.findPlayer(playerID);
         if(playerInfo is SelfInfo)
         {
            return this.getSelfList(p);
         }
         gemstoneList = playerInfo.gemstoneList;
         if(Boolean(this.getPlaceByGemstonInitInfo(p,gemstoneList)))
         {
            return this.getPlaceByGemstonInitInfo(p,gemstoneList).list;
         }
         return null;
      }
      
      public function setGemstoneListInfo(info:GemstoneUpGradeInfo) : void
      {
         if(info.equipPlace == GemstoneManager.FacePLACE)
         {
            this.faceList = info.list;
         }
         else if(info.equipPlace == GemstoneManager.SuitPLACE)
         {
            this.suitList = info.list;
         }
         else if(info.equipPlace == GemstoneManager.GlassPPLACE)
         {
            this.glassList = info.list;
         }
         else if(info.equipPlace == GemstoneManager.DecorationPLACE)
         {
            this.decorationList = info.list;
         }
         else if(info.equipPlace == GemstoneManager.HariPPLACE)
         {
            this.hariList = info.list;
         }
      }
      
      public function getPlaceByGemstonInitInfo(p:int, gemstoneList:Vector.<GemstonInitInfo>) : GemstonInitInfo
      {
         if(!gemstoneList || gemstoneList.length <= 0)
         {
            return null;
         }
         for(var i:int = 0; i < gemstoneList.length; i++)
         {
            if(gemstoneList[i].equipPlace == p)
            {
               return gemstoneList[i];
            }
         }
         return null;
      }
   }
}

