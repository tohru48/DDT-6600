package guildMemberWeek.manager
{
   import com.pickgliss.action.AlertAction;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.constants.CacheConsts;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import guildMemberWeek.controller.GuildMemberWeekController;
   import guildMemberWeek.data.GuildMemberWeekPackageType;
   import guildMemberWeek.loader.LoaderGuildMemberWeekUIModule;
   import guildMemberWeek.model.GuildMemberWeekModel;
   import guildMemberWeek.view.GuildMemberWeekFrame;
   import guildMemberWeek.view.ShowRankingFrame.GuildMemberWeekShowRankingFrame;
   import guildMemberWeek.view.addRankingFrame.GuildMemberWeekAddRankingFrame;
   import guildMemberWeek.view.mainFrame.GuildMemberWeekPromptFrame;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class GuildMemberWeekManager extends EventDispatcher
   {
      
      private static var _instance:GuildMemberWeekManager;
      
      private var _model:GuildMemberWeekModel;
      
      private var _Controller:GuildMemberWeekController;
      
      private var _isShowIcon:Boolean = false;
      
      private var _AddRankingFrame:GuildMemberWeekAddRankingFrame;
      
      private var _FinishActivityFrame:GuildMemberWeekShowRankingFrame;
      
      private var _WorkFrame:GuildMemberWeekFrame;
      
      private var _Top10PromptFrame:GuildMemberWeekPromptFrame;
      
      public function GuildMemberWeekManager(pct:PrivateClass)
      {
         super();
         if(pct == null)
         {
            throw new Error("错误:GuildMemberWeekManager为单例，请使用instance获取实例!");
         }
      }
      
      public static function get instance() : GuildMemberWeekManager
      {
         if(_instance == null)
         {
            _instance = new GuildMemberWeekManager(new PrivateClass());
         }
         return _instance;
      }
      
      public function get MainFrame() : GuildMemberWeekFrame
      {
         return this._WorkFrame;
      }
      
      public function get Controller() : GuildMemberWeekController
      {
         return this._Controller;
      }
      
      public function setup() : void
      {
         if(this._model == null)
         {
            this._model = new GuildMemberWeekModel();
         }
         this._Controller = GuildMemberWeekController.instance;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_SYSTEM,this.pkgHandler);
      }
      
      private function pkgHandler(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         var event:CrazyTankSocketEvent = null;
         switch(cmd)
         {
            case GuildMemberWeekPackageType.OPEN:
               this.openOrclose(pkg);
               break;
            case GuildMemberWeekPackageType.PLAYERTOP10:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_PLAYERTOP10,pkg);
               break;
            case GuildMemberWeekPackageType.ADDPOINTBOOK10:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_POINTBOOK,pkg);
               break;
            case GuildMemberWeekPackageType.ADDPOINTBOOKRECORD:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_ADDPOINTBOOKRECORD,pkg);
               break;
            case GuildMemberWeekPackageType.GET_MYRUNKING:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_MYRUNKING,pkg);
               break;
            case GuildMemberWeekPackageType.UPADDPOINTBOOK:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_UPADDPOINTBOOK,pkg);
               break;
            case GuildMemberWeekPackageType.SHOWACTIVITYEND:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_SHOWACTIVITYEND,pkg);
         }
         if(Boolean(event))
         {
            dispatchEvent(event);
         }
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         if(pkg != null)
         {
            this._model.isOpen = pkg.readBoolean();
            this._isShowIcon = this._model.isOpen;
            if(this._model.isOpen)
            {
               this._model.ActivityStartTime = pkg.readUTF();
               this._model.ActivityEndTime = pkg.readUTF();
            }
         }
         if(this._model.isOpen)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
         }
      }
      
      public function showEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.GUILDMEMBERWEEK,true);
      }
      
      public function hideEnterIcon() : void
      {
         this._isShowIcon = false;
         HallIconManager.instance.updateSwitchHandler(HallIconType.GUILDMEMBERWEEK,false);
         this.disposeEnterIcon();
      }
      
      private function disposeEnterIcon() : void
      {
         if(Boolean(this._WorkFrame))
         {
            this._WorkFrame.dispose();
            this._WorkFrame = null;
         }
         if(Boolean(this._AddRankingFrame))
         {
            this._AddRankingFrame.dispose();
            this._AddRankingFrame = null;
         }
         if(Boolean(this._FinishActivityFrame))
         {
            this._FinishActivityFrame.dispose();
            this._FinishActivityFrame = null;
         }
      }
      
      public function onClickguildMemberWeekIcon(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            if(PlayerManager.Instance.Self.Grade < 17)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.player.Level.CannotInActivity"));
               return;
            }
            StateManager.setState(StateType.CONSORTIA);
            return;
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            LoaderGuildMemberWeekUIModule.Instance.loadUIModule(this.doOpenGuildMemberWeekFrame);
         }
      }
      
      public function doOpenGuildMemberWeekFrame() : void
      {
         if(PlayerManager.Instance.Self.DutyLevel <= 3)
         {
            this._model.CanAddPointBook = true;
         }
         else
         {
            this._model.CanAddPointBook = false;
         }
         if(this._isShowIcon)
         {
            if(Boolean(this._AddRankingFrame))
            {
               this._AddRankingFrame.dispose();
               this._AddRankingFrame = null;
            }
            this._WorkFrame = ComponentFactory.Instance.creatComponentByStylename("Window.guildmemberweek.GuildMemberWeekFrame");
            LayerManager.Instance.addToLayer(this._WorkFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            SocketManager.Instance.out.sendGuildMemberWeekStarEnter();
         }
      }
      
      public function LoadAndOpenGuildMemberWeekFinishActivity() : void
      {
         LoaderGuildMemberWeekUIModule.Instance.loadUIModule(this.doOpenGuildMemberWeekFinishActivity);
      }
      
      public function get FinishActivityFrame() : GuildMemberWeekShowRankingFrame
      {
         return this._FinishActivityFrame;
      }
      
      public function doOpenGuildMemberWeekFinishActivity() : void
      {
         var tempTAction:AlertAction = null;
         if(Boolean(this._WorkFrame))
         {
            this._WorkFrame.dispose();
            this._WorkFrame = null;
         }
         this._FinishActivityFrame = ComponentFactory.Instance.creatComponentByStylename("Window.guildmemberweek.GuildMemberWeekShowRankingFrame");
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            tempTAction = new AlertAction(this._FinishActivityFrame,LayerManager.GAME_UI_LAYER,LayerManager.BLCAK_BLOCKGOUND);
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,tempTAction);
            return;
         }
         LayerManager.Instance.addToLayer(this._FinishActivityFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function get AddRankingFrame() : GuildMemberWeekAddRankingFrame
      {
         return this._AddRankingFrame;
      }
      
      public function doOpenaddRankingFrame() : void
      {
         if(PlayerManager.Instance.Self.DutyLevel > 3 || !this._model.CanAddPointBook)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.CantNotAddPointBook"));
            return;
         }
         this._AddRankingFrame = ComponentFactory.Instance.creatComponentByStylename("Window.guildmemberweek.GuildMemberWeekAddRankingFrame");
         LayerManager.Instance.addToLayer(this._AddRankingFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function CloseAddRankingFrame() : void
      {
         if(this._AddRankingFrame == null)
         {
            return;
         }
         this._AddRankingFrame.dispose();
         this._AddRankingFrame = null;
      }
      
      public function get model() : GuildMemberWeekModel
      {
         if(this._model == null)
         {
            this._model = new GuildMemberWeekModel();
         }
         return this._model;
      }
      
      public function returnComponentBnt(Spr:Sprite, BtnTip:Boolean = true) : BaseButton
      {
         var Btn:BaseButton = new BaseButton();
         if(BtnTip)
         {
            Btn.tipDirctions = "0,5";
            Btn.tipStyle = "ddt.view.tips.OneLineTip";
         }
         Btn.filterString = "null,lightFilter,lightFilter,grayFilter";
         Btn.backgound = Spr;
         Btn.tipGapV = 20;
         Btn.addChild(Spr);
         return Btn;
      }
      
      public function LoadAndOpenShowTop10PromptFrame() : void
      {
         LoaderGuildMemberWeekUIModule.Instance.loadUIModule(this.doOpenGuildMemberWeekTop10PromptFrame);
      }
      
      public function doOpenGuildMemberWeekTop10PromptFrame() : void
      {
         var tempTAction:AlertAction = null;
         var Str:String = "";
         this._Top10PromptFrame = ComponentFactory.Instance.creatComponentByStylename("guildMemberWeek.view.GuildMemberWeekPromptFrame");
         Str = LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.PromptFrameF");
         this._Top10PromptFrame.setPromptFrameTxt(Str);
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            tempTAction = new AlertAction(this._Top10PromptFrame,LayerManager.GAME_UI_LAYER,LayerManager.BLCAK_BLOCKGOUND);
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,tempTAction);
            return;
         }
         LayerManager.Instance.addToLayer(this._Top10PromptFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function CloseShowTop10PromptFrame() : void
      {
         this._Top10PromptFrame.dispose();
         this._Top10PromptFrame = null;
         var evt:CrazyTankSocketEvent = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_SHOWRUNKING);
         dispatchEvent(evt);
      }
      
      public function get getGiftType() : int
      {
         return 15;
      }
      
      public function templateDataSetup(dataList:Array) : void
      {
         this.model.TopTenGiftData = [];
         var tempStr:String = "";
         var tempArray:Array = dataList;
         var i:int = 0;
         var len:int = int(tempArray.length);
         var j:int = 0;
         var len2:int = 0;
         for(i = 0; i < len; i++)
         {
            len2 = int(tempArray[i].length);
            tempStr = "";
            for(j = 0; j < len2; j++)
            {
               if(j < 3)
               {
                  tempStr += tempArray[i][j].TemplateID + "," + tempArray[i][j].Count + ",";
               }
               else if(j == 3)
               {
                  tempStr += tempArray[i][j].TemplateID + "," + tempArray[i][j].Count;
                  break;
               }
            }
            this.model.TopTenGiftData.push(tempStr);
         }
         while(this.model.TopTenGiftData.length < 10)
         {
            this.model.TopTenGiftData.push("");
         }
         this.model.items = dataList;
      }
      
      public function CheckShowEndFrame(playerType:Boolean) : void
      {
         if(playerType)
         {
            this.LoadAndOpenShowTop10PromptFrame();
         }
         else
         {
            this.LoadAndOpenGuildMemberWeekFinishActivity();
         }
      }
      
      public function disposeAllFrame(deleteType:Boolean = false) : void
      {
         if(Boolean(this._WorkFrame))
         {
            this._WorkFrame.dispose();
            this._WorkFrame = null;
         }
         if(Boolean(this._AddRankingFrame))
         {
            this._AddRankingFrame.dispose();
            this._AddRankingFrame = null;
         }
         if(Boolean(this._FinishActivityFrame))
         {
            this._FinishActivityFrame.dispose();
            this._FinishActivityFrame = null;
         }
         this._model.AddRanking.splice(0);
         this._model.TopTenMemberData.splice(0);
         this._model.TopTenAddPointBook = [0,0,0,0,0,0,0,0,0,0];
         this._model.PlayerAddPointBook = [0,0,0,0,0,0,0,0,0,0];
         this._model.PlayerAddPointBookBefor = [0,0,0,0,0,0,0,0,0,0];
         SocketManager.Instance.out.sendGuildMemberWeekStarClose();
         if(deleteType)
         {
            if(Boolean(this._Controller))
            {
               this._Controller.dispose();
            }
         }
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
