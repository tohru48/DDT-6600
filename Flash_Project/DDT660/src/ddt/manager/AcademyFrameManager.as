package ddt.manager
{
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.constants.CacheConsts;
   import ddt.data.player.BasePlayer;
   import ddt.states.StateType;
   import ddt.view.academyCommon.academyRequest.AcademyAnswerApprenticeFrame;
   import ddt.view.academyCommon.academyRequest.AcademyAnswerMasterFrame;
   import ddt.view.academyCommon.academyRequest.AcademyRequestApprenticeFrame;
   import ddt.view.academyCommon.academyRequest.AcademyRequestMasterFrame;
   import ddt.view.academyCommon.data.SimpleMessger;
   import ddt.view.academyCommon.graduate.ApprenticeGraduate;
   import ddt.view.academyCommon.graduate.MasterGraduate;
   import ddt.view.academyCommon.myAcademy.MyAcademyApprenticeFrame;
   import ddt.view.academyCommon.myAcademy.MyAcademyMasterFrame;
   import ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame;
   import ddt.view.academyCommon.recommend.AcademyMasterMainFrame;
   import ddt.view.academyCommon.register.AcademyRegisterFrame;
   
   public class AcademyFrameManager
   {
      
      private static var _instance:AcademyFrameManager;
      
      private var _academyRegisterFrame:AcademyRegisterFrame;
      
      private var _myAcademyMasterFrame:MyAcademyMasterFrame;
      
      private var _myAcademyApprenticeFrame:MyAcademyApprenticeFrame;
      
      private var _academyMasterMainFrame:AcademyMasterMainFrame;
      
      private var _academyApprenticeMainFrame:AcademyApprenticeMainFrame;
      
      private var _academyRequestMasterFrame:AcademyRequestMasterFrame;
      
      private var _academyAnswerMasterFrame:AcademyAnswerMasterFrame;
      
      private var _academyAnswerApprenticeFrame:AcademyAnswerApprenticeFrame;
      
      private var _apprenticeGraduate:ApprenticeGraduate;
      
      private var _masterGraduate:MasterGraduate;
      
      public function AcademyFrameManager()
      {
         super();
      }
      
      public static function get Instance() : AcademyFrameManager
      {
         if(_instance == null)
         {
            _instance = new AcademyFrameManager();
         }
         return _instance;
      }
      
      public function showRegisterFrame(isAmend:Boolean) : void
      {
         this._academyRegisterFrame = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame");
         this._academyRegisterFrame.isAmend(isAmend);
         this._academyRegisterFrame.show();
      }
      
      public function showMyAcademyMasterFrame() : void
      {
         if(Boolean(this._myAcademyMasterFrame))
         {
            this._myAcademyMasterFrame.dispose();
            this._myAcademyMasterFrame = null;
         }
         this._myAcademyMasterFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterFrame");
         this._myAcademyMasterFrame.show();
         this._myAcademyMasterFrame.addEventListener(FrameEvent.RESPONSE,this.__clearMyAcademyMasterFrame);
      }
      
      private function __clearMyAcademyMasterFrame(event:FrameEvent) : void
      {
         this._myAcademyMasterFrame.removeEventListener(FrameEvent.RESPONSE,this.__clearMyAcademyMasterFrame);
         this._myAcademyMasterFrame.dispose();
         this._myAcademyMasterFrame = null;
      }
      
      public function showMyAcademyApprenticeFrame() : void
      {
         if(Boolean(this._myAcademyApprenticeFrame))
         {
            this._myAcademyApprenticeFrame.dispose();
            this._myAcademyApprenticeFrame = null;
         }
         this._myAcademyApprenticeFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyApprenticeFrame");
         this._myAcademyApprenticeFrame.show();
         this._myAcademyApprenticeFrame.addEventListener(FrameEvent.RESPONSE,this.__clearMyAcademyApprenticeFrame);
      }
      
      private function __clearMyAcademyApprenticeFrame(event:FrameEvent) : void
      {
         this._myAcademyApprenticeFrame.removeEventListener(FrameEvent.RESPONSE,this.__clearMyAcademyApprenticeFrame);
         this._myAcademyApprenticeFrame.dispose();
         this._myAcademyApprenticeFrame = null;
      }
      
      public function showAcademyMasterMainFrame() : void
      {
         this._academyMasterMainFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyMasterMainFrame");
         this._academyMasterMainFrame.show();
         this._academyMasterMainFrame.addEventListener(FrameEvent.RESPONSE,this.__clearAcademyMasterMainFrame);
      }
      
      private function __clearAcademyMasterMainFrame(event:FrameEvent) : void
      {
         this._academyMasterMainFrame.removeEventListener(FrameEvent.RESPONSE,this.__clearAcademyMasterMainFrame);
         this._academyMasterMainFrame.dispose();
         this._academyMasterMainFrame = null;
      }
      
      public function showAcademyApprenticeMainFrame() : void
      {
         this._academyApprenticeMainFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame");
         this._academyApprenticeMainFrame.show();
         this._academyApprenticeMainFrame.addEventListener(FrameEvent.RESPONSE,this.__clearAcademyApprenticeMainFrame);
      }
      
      private function __clearAcademyApprenticeMainFrame(event:FrameEvent) : void
      {
         this._academyApprenticeMainFrame.removeEventListener(FrameEvent.RESPONSE,this.__clearAcademyApprenticeMainFrame);
         this._academyApprenticeMainFrame.dispose();
         this._academyApprenticeMainFrame = null;
      }
      
      public function showAcademyRequestMasterFrame(info:BasePlayer) : void
      {
         this._academyRequestMasterFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.AcademyRequestMasterFrame");
         this._academyRequestMasterFrame.show();
         this._academyRequestMasterFrame.setInfo(info);
      }
      
      public function showAcademyRequestApprenticeFrame(info:BasePlayer) : void
      {
         var academyRequestApprenticeFrame:AcademyRequestApprenticeFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.AcademyRequestApprenticeFrame");
         academyRequestApprenticeFrame.show();
         academyRequestApprenticeFrame.setInfo(info);
      }
      
      public function showAcademyAnswerMasterFrame(id:int, name:String, messger:String) : void
      {
         var messgerInfo:SimpleMessger = null;
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP))
         {
            this._academyAnswerMasterFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.AcademyAnswerMasterFrame");
            this._academyAnswerMasterFrame.setMessage(id,name,messger);
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP,new FunctionAction(this._academyAnswerMasterFrame.show));
         }
         else if(StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.LITTLEGAME)
         {
            this._academyAnswerMasterFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.AcademyAnswerMasterFrame");
            this._academyAnswerMasterFrame.show();
            this._academyAnswerMasterFrame.setMessage(id,name,messger);
         }
         else
         {
            messgerInfo = new SimpleMessger(id,name,messger,SimpleMessger.ANSWER_MASTER);
            AcademyManager.Instance.messgers.push(messgerInfo);
         }
      }
      
      public function showAcademyAnswerApprenticeFrame(id:int, name:String, messger:String) : void
      {
         var messgerInfo:SimpleMessger = null;
         if(StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.LITTLEGAME)
         {
            this._academyAnswerApprenticeFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.AcademyAnswerApprenticeFrame");
            this._academyAnswerApprenticeFrame.show();
            this._academyAnswerApprenticeFrame.setMessage(id,name,messger);
         }
         else
         {
            messgerInfo = new SimpleMessger(id,name,messger,SimpleMessger.ANSWER_APPRENTICE);
            AcademyManager.Instance.messgers.push(messgerInfo);
         }
      }
      
      public function showApprenticeGraduate() : void
      {
         if(StateManager.currentStateType == StateType.FIGHT_LIB || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.LITTLEGAME)
         {
            return;
         }
         this._apprenticeGraduate = ComponentFactory.Instance.creatComponentByStylename("academyCommon.graduate.apprenticeGraduate");
         this._apprenticeGraduate.show();
      }
      
      public function showMasterGraduate(value:String) : void
      {
         if(StateManager.currentStateType == StateType.FIGHT_LIB || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.LITTLEGAME)
         {
            return;
         }
         this._masterGraduate = ComponentFactory.Instance.creatComponentByStylename("academyCommon.graduate.masterGraduate");
         this._masterGraduate.setName(value);
         this._masterGraduate.show();
      }
      
      public function showAcademyPreviewFrame() : void
      {
         var submitEnable:Boolean = PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.MASTER_FULL_STATE && PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.APPRENTICE_STATE;
         if(PlayerManager.Instance.Self.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
         {
            PreviewFrameManager.Instance.createsPreviewFrame(LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree"),"asset.PreviewFrame.PreviewContent","view.common.apprenticeAcademyPreviewFrame","view.common.masterAcademyPreviewFrame.PreviewScroll",AcademyManager.Instance.recommends,submitEnable);
         }
         else
         {
            PreviewFrameManager.Instance.createsPreviewFrame(LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree"),"asset.PreviewFrame.PreviewContent","view.common.masterAcademyPreviewFrame","view.common.masterAcademyPreviewFrame.PreviewScroll",AcademyManager.Instance.recommends,submitEnable);
         }
      }
      
      public function showRecommendAcademyPreviewFrame() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            PreviewFrameManager.Instance.createsPreviewFrame(LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree"),"asset.PreviewFrame.PreviewContent","view.common.apprenticeAcademyPreviewFrame","view.common.masterAcademyPreviewFrame.PreviewScroll");
         }
         else
         {
            PreviewFrameManager.Instance.createsPreviewFrame(LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree"),"asset.PreviewFrame.PreviewContent","view.common.masterAcademyPreviewFrame","view.common.masterAcademyPreviewFrame.PreviewScroll");
         }
      }
   }
}

