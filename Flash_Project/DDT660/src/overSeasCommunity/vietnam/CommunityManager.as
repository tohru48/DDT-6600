package overSeasCommunity.vietnam
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import ddt.data.map.MissionInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import game.model.GameInfo;
   import im.IMController;
   import overSeasCommunity.vietnam.openapi.BaseZMOpenAPI;
   import overSeasCommunity.vietnam.openapi.ZMFeedAPI;
   import overSeasCommunity.vietnam.view.ResumeShareView;
   
   public class CommunityManager
   {
      
      private static var _instance:CommunityManager;
      
      private var _apiCtrl:InterfaceController;
      
      private var _ssController:ScreenshotController;
      
      private var _enable:Boolean;
      
      private var _currentBossName:String = "";
      
      private var _resumePlayer:PlayerInfo;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      private var _currentGame:GameInfo;
      
      private var _currentMission:MissionInfo;
      
      private var _currentLevel:int;
      
      public function CommunityManager()
      {
         super();
         this._enable = PathManager.OVERSEAS_COMMUNITY_TYPE == 2;
      }
      
      public static function get Instance() : CommunityManager
      {
         if(_instance == null)
         {
            _instance = new CommunityManager();
         }
         return _instance;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function setup() : void
      {
         this._apiCtrl = new InterfaceController();
         this._apiCtrl.setup();
         if(StringUtils.isEmpty(BaseZMOpenAPI.session_id))
         {
            this._enable = false;
         }
      }
      
      public function screenshot() : void
      {
         if(this._ssController == null)
         {
            this._ssController = new ScreenshotController(this._apiCtrl);
         }
         this._ssController.show();
      }
      
      public function shareWedding() : void
      {
         this._apiCtrl.pushFeed(3,LanguageMgr.GetTranslation("community.feed.church.wedding",PlayerManager.Instance.Self.SpouseName),LanguageMgr.GetTranslation("community.church.wedding.imagePath"),[LanguageMgr.GetTranslation("community.church.wedding.itemTitle1"),LanguageMgr.GetTranslation("community.church.wedding.itemTitle2"),LanguageMgr.GetTranslation("community.church.wedding.itemTitle3")]);
      }
      
      public function shareEffort(effortTitle:String) : void
      {
         this._apiCtrl.pushFeed(3,LanguageMgr.GetTranslation("community.feed.effort.share",PlayerManager.Instance.Self.NickName,effortTitle),LanguageMgr.GetTranslation("community.feed.effort.share.imagePath"),[LanguageMgr.GetTranslation("community.feed.effort.share.itemTitle1"),LanguageMgr.GetTranslation("community.feed.effort.share.itemTitle2"),LanguageMgr.GetTranslation("community.feed.effort.share.itemTitle3")]);
      }
      
      public function isHeroBossLevel() : Boolean
      {
         return Boolean(this._currentMission) && this._currentMission.tackCardType == 2 && this._currentLevel > 1;
      }
      
      public function set currentBossName(value:String) : void
      {
         this._currentBossName = value;
      }
      
      public function shareHeroMission() : void
      {
         this._apiCtrl.pushFeed(3,LanguageMgr.GetTranslation("community.feed.heroicMission",this._currentBossName),LanguageMgr.GetTranslation("community.feed.heroicMission.imagePath"),[LanguageMgr.GetTranslation("community.feed.hero.share.itemTitle1"),LanguageMgr.GetTranslation("community.feed.hero.share.itemTitle2"),LanguageMgr.GetTranslation("community.feed.hero.share.itemTitle3")]);
         if(Boolean(this._currentGame))
         {
            this._currentGame.dispose();
         }
         this._currentGame = null;
         this._currentMission = null;
         this._currentLevel = 0;
         this._currentBossName = "";
      }
      
      public function checkShareResume(info:PlayerInfo) : void
      {
         this._resumePlayer = null;
         this._resumePlayer = new PlayerInfo();
         ObjectUtils.copyProperties(this._resumePlayer,info);
         this._apiCtrl.checkAllowShareResume(info.LoginName,this.ckAllowShareResumeCallback);
      }
      
      private function ckAllowShareResumeCallback(allow:Boolean) : void
      {
         var frame:ResumeShareView = null;
         if(allow)
         {
            frame = ComponentFactory.Instance.creat("community.ResumeShareFrame");
            frame.player = this._resumePlayer;
            LayerManager.Instance.addToLayer(frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
         else
         {
            if(Boolean(this._baseAlerFrame))
            {
               this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventII);
               this._baseAlerFrame.dispose();
               this._baseAlerFrame = null;
            }
            this._baseAlerFrame = AlertManager.Instance.simpleAlert("",LanguageMgr.GetTranslation("community.addFriend.tip",this._resumePlayer.NickName),LanguageMgr.GetTranslation("ok"),"",true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventII);
            StageReferance.stage.focus = this._baseAlerFrame;
         }
      }
      
      private function __frameEventII(evt:FrameEvent) : void
      {
         var desc:String = null;
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(Boolean(this._baseAlerFrame))
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventII);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
               IMController.Instance.addFriend(this._resumePlayer.NickName);
               desc = LanguageMgr.GetTranslation("community.addFriend.tip",this._resumePlayer.NickName);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(Boolean(this._baseAlerFrame))
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventII);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
         }
      }
      
      public function set CurrentGame(value:GameInfo) : void
      {
         this._currentGame = value;
         this._currentMission = value.missionInfo;
      }
      
      public function set CurrentLevel(value:int) : void
      {
         this._currentLevel = value;
      }
      
      public function sendNotice(userId:int, text:String) : void
      {
         var feed:ZMFeedAPI = new ZMFeedAPI();
         feed.sendEmail([userId],"",text);
      }
   }
}

