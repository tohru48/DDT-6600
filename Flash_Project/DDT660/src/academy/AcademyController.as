package academy
{
   import academy.view.AcademyView;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.AcademyMemberListAnalyze;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.display.Sprite;
   
   public class AcademyController extends BaseStateView
   {
      
      private var _model:AcademyModel;
      
      private var _view:AcademyView;
      
      private var _chatFrame:Sprite;
      
      public function AcademyController()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this.init();
         MainToolBar.Instance.show();
         this.loadAcademyMemberList(AcademyManager.ACADEMY,this._model.state,1,"",true);
         if(PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.NONE_STATE)
         {
            AcademyManager.Instance.myAcademy();
         }
      }
      
      private function init() : void
      {
         this._model = new AcademyModel();
         this._view = new AcademyView(this);
         addChild(this._view);
         ChatManager.Instance.state = ChatManager.CHAT_ACADEMY_VIEW;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         this._model = null;
         if(Boolean(this._chatFrame) && Boolean(this._chatFrame.parent))
         {
            this._chatFrame.parent.removeChild(this._chatFrame);
         }
      }
      
      public function loadAcademyMemberList(requestType:Boolean = true, appshipStateType:Boolean = false, page:int = 1, name:String = "", isReturnSelf:Boolean = false) : void
      {
         AcademyManager.Instance.loadAcademyMemberList(this.__loadAcademyMemberList,requestType,appshipStateType,page,name,0,true,isReturnSelf);
      }
      
      public function get model() : AcademyModel
      {
         return this._model;
      }
      
      public function set currentAcademyInfo(value:AcademyPlayerInfo) : void
      {
         this._model.info = value;
         dispatchEvent(new AcademyEvent(AcademyEvent.ACADEMY_PLAYER_CHANGE));
      }
      
      private function __loadAcademyMemberList(action:AcademyMemberListAnalyze) : void
      {
         this._model.list = action.academyMemberList;
         this._model.totalPage = action.totalPage;
         AcademyManager.Instance.isSelfPublishEquip = action.isSelfPublishEquip;
         if(action.isAlter)
         {
            AcademyManager.Instance.selfIsRegister = action.selfIsRegister;
         }
         if(Boolean(action.selfDescribe) && action.selfDescribe != "")
         {
            AcademyManager.Instance.selfDescribe = action.selfDescribe;
         }
         if(this._model.list.length != 0)
         {
            this.currentAcademyInfo = this._model.list[0];
         }
         dispatchEvent(new AcademyEvent(AcademyEvent.ACADEMY_UPDATE_LIST));
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         MainToolBar.Instance.hide();
         super.leaving(next);
         this.dispose();
      }
      
      override public function getType() : String
      {
         return StateType.ACADEMY_REGISTRATION;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
   }
}

