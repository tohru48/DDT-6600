package ddt.view.academyCommon.academyRequest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import flash.geom.Point;
   
   public class AcademyAnswerApprenticeFrame extends AcademyAnswerMasterFrame implements Disposeable
   {
      
      public function AcademyAnswerApprenticeFrame()
      {
         super();
      }
      
      override protected function initContent() : void
      {
         var pos1:Point = null;
         var pos2:Point = null;
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestMasterFrame.title");
         _alertInfo.showCancel = _alertInfo.showSubmit = _alertInfo.enterEnable = this.enterEnable = false;
         info = _alertInfo;
         pos1 = ComponentFactory.Instance.creatCustomObject("AcademyAnswerMasterFrame.inputPos1");
         pos2 = ComponentFactory.Instance.creatCustomObject("AcademyAnswerMasterFrame.inputPos2");
         _inputBG = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.inputBg2");
         addToContent(_inputBG);
         _inputBG.x = pos1.x;
         _inputBG.y = pos1.y;
         _messageText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.MessageText");
         addToContent(_messageText);
         _messageText.x = pos2.x;
         _messageText.y = pos2.y;
         _explainText = ComponentFactory.Instance.creat("academyCommon.academyAnswerApprenticeFrame.explainText");
         addToContent(_explainText);
         _lookBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyAnswerApprenticeFrame.LookButton");
         _lookBtn.text = LanguageMgr.GetTranslation("civil.leftview.equipName");
         addToContent(_lookBtn);
         _cancelBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyAnswerApprenticeFrame.submitButton");
         _cancelBtn.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestMasterFrame.submitLabel");
         addToContent(_cancelBtn);
         _unAcceptBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyAnswerApprenticeFrame.selectBtn");
         addToContent(_unAcceptBtn);
         _unAcceptBtn.text = LanguageMgr.GetTranslation("ddt.farms.refreshPetsNOAlert");
      }
      
      override protected function update() : void
      {
         _messageText.htmlText = _message;
         _explainText.htmlText = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyAnswerApprenticeFrame.AnswerApprentice",_name);
      }
      
      override protected function submit() : void
      {
         SocketManager.Instance.out.sendAcademyApprenticeConfirm(true,_uid);
         dispose();
      }
      
      override protected function hide() : void
      {
         SocketManager.Instance.out.sendAcademyApprenticeConfirm(false,_uid);
         dispose();
      }
   }
}

