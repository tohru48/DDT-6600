package overSeasCommunity
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.action.FrameShowAction;
   import ddt.constants.CacheConsts;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.PathManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.sendToURL;
   import game.model.GameInfo;
   import overSeasCommunity.overseas.controllers.BaseCommunityController;
   import overSeasCommunity.overseas.controllers.EasyGameController;
   import overSeasCommunity.overseas.controllers.ElexController;
   import overSeasCommunity.overseas.model.BaseCommunityModel;
   import overSeasCommunity.overseas.view.CommunityFrame;
   import overSeasCommunity.overseas.vo.OverSeasCommunType;
   import overSeasCommunity.vietnam.CommunityManager;
   
   public class OverSeasCommunController extends EventDispatcher
   {
      
      private static var _instance:OverSeasCommunController;
      
      private var _debug:Boolean = true;
      
      private var _communityType:int = 0;
      
      private var _model:BaseCommunityModel;
      
      private var _control:BaseCommunityController;
      
      public function OverSeasCommunController()
      {
         super();
      }
      
      public static function instance() : OverSeasCommunController
      {
         if(!_instance)
         {
            _instance = new OverSeasCommunController();
         }
         return _instance;
      }
      
      public function get model() : BaseCommunityModel
      {
         return this._model;
      }
      
      public function get communityType() : int
      {
         return this._communityType;
      }
      
      public function setup() : void
      {
         this._communityType = PathManager.OVERSEAS_COMMUNITY_TYPE;
         if(this._communityType == OverSeasCommunType.VIETNAME_COMMUNITY)
         {
            CommunityManager.Instance.setup();
            return;
         }
         if(!this._debug && this._communityType != OverSeasCommunType.VIETNAME_COMMUNITY)
         {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_DYNAMIC,this.__overSeasCommun);
         }
         else
         {
            SocketManager.Instance.addEventListener("TestOverSeasCommun",this.__overSeasCommun);
         }
      }
      
      private function __overSeasCommun(event:CrazyTankSocketEvent) : void
      {
         switch(this._communityType)
         {
            case OverSeasCommunType.NONE_COMMUNITY:
               break;
            case OverSeasCommunType.COMMON_COMMUNITY:
               this._model = new BaseCommunityModel();
               this._control = new BaseCommunityController(this._model);
               break;
            case OverSeasCommunType.VIETNAME_COMMUNITY:
               break;
            case OverSeasCommunType.ELEX_COMMUNITY:
               this._model = new BaseCommunityModel();
               this._control = new ElexController(this._model);
               this._control.isShowFrame = false;
               break;
            case OverSeasCommunType.EASYGAME_COMMUNITY:
               this._model = new BaseCommunityModel();
               this._control = new EasyGameController(this._model);
         }
         if(SharedManager.Instance.isCommunity)
         {
            if(!this._debug)
            {
               this._model.typeId = event.pkg.readInt();
               this._model.backgroundServerTxt = event.pkg.readUTF();
               this._model.receptionistTxt = event.pkg.readUTF();
            }
            else
            {
               this._model.typeId = 17;
               this._model.backgroundServerTxt = "Hi,This Test!";
               this._model.receptionistTxt = "Test";
            }
            if(this._control.openTypeIDList.indexOf(this._model.typeId) != -1)
            {
               if(this._control.isShowFrame)
               {
                  this.showDialog();
               }
               else
               {
                  this._control.sendDynamic();
               }
            }
         }
      }
      
      private function showDialog() : void
      {
         var snsFrame:CommunityFrame = ComponentFactory.Instance.creatComponentByStylename("core.CommunityFrameView");
         snsFrame.model = this._model;
         snsFrame.control = this._control;
         snsFrame.receptionistTxt = this._model.receptionistTxt;
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new FrameShowAction(snsFrame));
         }
         else if(CacheSysManager.isLock(CacheConsts.ALERT_IN_MOVIE))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_MOVIE,new FrameShowAction(snsFrame));
         }
         else if(AcademyManager.Instance.isFighting())
         {
            return;
         }
         snsFrame.show();
      }
      
      public function vietnamCommunityInterfacePath(method:String) : String
      {
         return PathManager.vietnamCommunityInterfacePath(method);
      }
      
      public function elexOverseasCommunity_CallJS() : String
      {
         return PathManager.OVERSEAS_COMMUNITY_CALLJS;
      }
      
      public function sendToAgent(op:int, userID:int = -1, nickName:String = "", serverName:String = "", num:int = -1, pName:String = "", nickName2:String = "") : void
      {
         var ur:URLRequest = new URLRequest(PathManager.getSnsPath());
         var variable:URLVariables = new URLVariables();
         variable["op"] = op;
         if(userID > -1)
         {
            variable["uid"] = userID;
         }
         if(nickName != "")
         {
            variable["role"] = nickName;
         }
         if(serverName != "")
         {
            variable["ser"] = serverName;
         }
         if(num > -1)
         {
            variable["num"] = num;
         }
         if(pName != "")
         {
            variable["pn"] = pName;
         }
         if(nickName2 != "")
         {
            variable["role2"] = nickName2;
         }
         ur.data = variable;
         sendToURL(ur);
      }
      
      public function isVNG() : Boolean
      {
         return OverSeasCommunController.instance().communityType != OverSeasCommunType.VIETNAME_COMMUNITY ? false : true;
      }
      
      public function activeVNG() : Boolean
      {
         return this.isVNG() && CommunityManager.Instance.enable;
      }
      
      public function checkKillHeroBoss() : void
      {
         if(OverSeasCommunController.instance().communityType != OverSeasCommunType.VIETNAME_COMMUNITY)
         {
            return;
         }
         if(!CommunityManager.Instance.enable)
         {
            return;
         }
         if(CommunityManager.Instance.isHeroBossLevel())
         {
            CommunityManager.Instance.shareHeroMission();
         }
      }
      
      public function setGameInfo(currentGame:GameInfo, currentLev:int) : void
      {
         if(this.isVNG())
         {
            CommunityManager.Instance.CurrentGame = currentGame;
            CommunityManager.Instance.CurrentLevel = currentLev;
         }
      }
      
      public function setBoosName(boosName:String) : void
      {
         if(this.isVNG())
         {
            if(CommunityManager.Instance.enable)
            {
               CommunityManager.Instance.currentBossName = boosName;
            }
         }
      }
      
      public function shareEffort(title:String) : void
      {
         if(this.isVNG())
         {
            if(CommunityManager.Instance.enable)
            {
               CommunityManager.Instance.shareEffort(title);
            }
         }
      }
      
      public function shareWedding() : void
      {
         if(!this.isVNG())
         {
            return;
         }
         if(CommunityManager.Instance.enable)
         {
            CommunityManager.Instance.shareWedding();
         }
      }
      
      public function isVisibleShareBtn() : Boolean
      {
         return this.isVNG() && CommunityManager.Instance.enable;
      }
      
      public function checkShareResume(info:PlayerInfo) : void
      {
         if(!this.isVNG())
         {
            return;
         }
         if(CommunityManager.Instance.enable)
         {
            CommunityManager.Instance.checkShareResume(info);
         }
      }
      
      public function screenShot() : void
      {
         if(this.activeVNG())
         {
            CommunityManager.Instance.screenshot();
         }
      }
   }
}

