package sevenDayTarget.controller
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import ddt.bagStore.BagStore;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import sevenDayTarget.model.NewTargetQuestionInfo;
   import sevenDayTarget.view.NewSevenDayAndNewPlayerMainView;
   
   public class NewSevenDayAndNewPlayerManager extends EventDispatcher
   {
      
      private static var _instance:NewSevenDayAndNewPlayerManager;
      
      private var _isShowIcon:Boolean;
      
      private var _sevenDayOpen:Boolean;
      
      private var _newPlayerOpen:Boolean;
      
      public var sevenDayMainViewPreOk:Boolean;
      
      public var newPlayerMainViewPreOk:Boolean;
      
      private var _newSevenDayAndNewPlayerMainView:NewSevenDayAndNewPlayerMainView;
      
      public var enterShop:Boolean;
      
      public function NewSevenDayAndNewPlayerManager()
      {
         super();
      }
      
      public static function get Instance() : NewSevenDayAndNewPlayerManager
      {
         if(_instance == null)
         {
            _instance = new NewSevenDayAndNewPlayerManager();
         }
         return _instance;
      }
      
      public function get isShowIcon() : Boolean
      {
         if(!this.sevenDayOpen && !this.newPlayerOpen)
         {
            this._isShowIcon = false;
         }
         else
         {
            this._isShowIcon = true;
         }
         return this._isShowIcon;
      }
      
      public function get sevenDayOpen() : Boolean
      {
         return SevenDayTargetManager.Instance.isShowIcon;
      }
      
      public function set sevenDayOpen(isopen:Boolean) : void
      {
         this._sevenDayOpen = isopen;
      }
      
      public function get newPlayerOpen() : Boolean
      {
         return NewPlayerRewardManager.Instance.isShowIcon;
      }
      
      public function set newPlayerOpen(isopen:Boolean) : void
      {
         this._newPlayerOpen = isopen;
      }
      
      public function setup() : void
      {
         SevenDayTargetManager.Instance.setup();
         NewPlayerRewardManager.Instance.setup();
         addEventListener("openUpdate",this._aciveOtherManager);
         addEventListener("openSevenDayMainView",this._openMainView);
         addEventListener("clickLink",this.__clickLink);
      }
      
      private function _aciveOtherManager(e:Event) : void
      {
         if(this.isShowIcon)
         {
            this.addEnterIcon();
         }
         else
         {
            this.disposeEnterIcon();
         }
      }
      
      public function addEnterIcon() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 5)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.SEVENDAYTARGET,true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.SEVENDAYTARGET,true,5);
         }
      }
      
      private function disposeEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.SEVENDAYTARGET,false);
         HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.SEVENDAYTARGET,false);
      }
      
      public function onClickSevenDayTargetIcon(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.sevenDayOpen)
         {
            SevenDayTargetManager.Instance.onClickSevenDayTargetIcon();
         }
         if(this.newPlayerOpen)
         {
            SocketManager.Instance.out.newPlayerReward_enter();
         }
      }
      
      private function _openMainView(e:Event) : void
      {
         if(!this._newSevenDayAndNewPlayerMainView)
         {
            if(this.sevenDayOpen && this.newPlayerOpen)
            {
               if(this.sevenDayMainViewPreOk && this.newPlayerMainViewPreOk)
               {
                  this._newSevenDayAndNewPlayerMainView = ComponentFactory.Instance.creatComponentByStylename("newSevenDayTarget.newSevenDayTargetFrame");
                  this._newSevenDayAndNewPlayerMainView.show();
               }
            }
            else if(this.sevenDayOpen && !this.newPlayerOpen)
            {
               if(this.sevenDayMainViewPreOk)
               {
                  this._newSevenDayAndNewPlayerMainView = ComponentFactory.Instance.creatComponentByStylename("newSevenDayTarget.newSevenDayTargetFrame");
                  this._newSevenDayAndNewPlayerMainView.show();
               }
            }
            else if(!this.sevenDayOpen && this.newPlayerOpen)
            {
               if(this.newPlayerMainViewPreOk)
               {
                  this._newSevenDayAndNewPlayerMainView = ComponentFactory.Instance.creatComponentByStylename("newSevenDayTarget.newSevenDayTargetFrame");
                  this._newSevenDayAndNewPlayerMainView.show();
               }
            }
         }
      }
      
      public function hideMainView() : void
      {
         this._newSevenDayAndNewPlayerMainView.dispose();
         this._newSevenDayAndNewPlayerMainView = null;
      }
      
      private function __clickLink(e:Event) : void
      {
         var _todayQuestInfo:NewTargetQuestionInfo = this._newSevenDayAndNewPlayerMainView.todayInfo();
         var linkId:int = _todayQuestInfo.linkId;
         switch(linkId)
         {
            case 1:
               this.hideMainView();
               TaskManager.instance.switchVisible();
               break;
            case 2:
               if(PlayerManager.Instance.Self.Grade < 6)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",6));
               }
               else
               {
                  this.hideMainView();
                  StateManager.setState(StateType.SHOP);
                  ComponentSetting.SEND_USELOG_ID(1);
               }
               this.enterShop = true;
               break;
            case 3:
               this.hideMainView();
               BagStore.instance.show(BagStore.BAG_STORE);
               ComponentSetting.SEND_USELOG_ID(2);
               break;
            case 4:
               this.hideMainView();
               if(PlayerManager.Instance.Self.Grade < 17)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",17));
                  return;
               }
               StateManager.setState(StateType.CONSORTIA);
               ComponentSetting.SEND_USELOG_ID(5);
               break;
            case 5:
               this.hideMainView();
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",10));
                  return;
               }
               StateManager.setState(StateType.DUNGEON_LIST);
               ComponentSetting.SEND_USELOG_ID(4);
               break;
         }
      }
   }
}

