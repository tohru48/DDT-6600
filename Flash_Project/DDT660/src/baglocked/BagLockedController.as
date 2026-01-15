package baglocked
{
   import baglocked.data.BagLockedInfo;
   import baglocked.phone4399.ConfirmNum4399Frame;
   import baglocked.phone4399.GetConfirmFrame;
   import baglocked.phoneServiceFrames.BenefitOfBindingFrame;
   import baglocked.phoneServiceFrames.DeleteConfirmFrame;
   import baglocked.phoneServiceFrames.DeleteInputFrame;
   import baglocked.phoneServiceFrames.MsnConfirmFrame;
   import baglocked.phoneServiceFrames.PhoneConfirmFrame;
   import baglocked.phoneServiceFrames.PhoneInputFrame;
   import baglocked.phoneServiceFrames.PhoneServiceFrame;
   import baglocked.phoneServiceFrames.QuestionConfirmFrame;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BagLockedController extends EventDispatcher
   {
      
      private static var _instance:BagLockedController;
      
      public static var TEMP_PWD:String = "";
      
      public static var PWD:String = "";
      
      public static var LOCK_SETTING:int = 0;
      
      private var _explainFrame:ExplainFrame;
      
      private var _explainFrame2:ExplainFrame2;
      
      private var _explainFrame4399:ExplainFrame4399;
      
      private var _setPassFrame1:SetPassFrame1;
      
      private var _setPassFrame2:SetPassFrame2;
      
      private var _setPassFrame3:SetPassFrame3;
      
      private var _setPassFrameNew:SetPassFrameNew;
      
      private var _appealFrame:AppealFrame;
      
      private var _phoneServiceFrame:PhoneServiceFrame;
      
      private var _changePhoneFrame:PhoneServiceFrame;
      
      private var _changePhoneFrame1:PhoneInputFrame;
      
      private var _changePhoneFrame2:MsnConfirmFrame;
      
      private var _changePhoneFrame3:PhoneConfirmFrame;
      
      private var _changePhoneFrame4:MsnConfirmFrame;
      
      private var _questionConfirmFrame1:QuestionConfirmFrame;
      
      private var _questionConfirmFrame2:PhoneConfirmFrame;
      
      private var _questionConfirmFrame3:MsnConfirmFrame;
      
      private var _deleteQuestionFrame1:DeleteInputFrame;
      
      private var _deleteQuestionFrame2:DeleteConfirmFrame;
      
      private var _deletePwdFrame:PhoneServiceFrame;
      
      private var _deletePwdFrame1:DeleteInputFrame;
      
      private var _deletePwdFrame2:DeleteConfirmFrame;
      
      private var _benefitOfBindingFrame:BenefitOfBindingFrame;
      
      private var _getConfirmFrame:GetConfirmFrame;
      
      private var _confirmNum4399Frame:ConfirmNum4399Frame;
      
      private var _delPassFrame:DelPassFrame;
      
      private var _bagLockedGetFrame:BagLockedGetFrame;
      
      private var _updatePassFrame:UpdatePassFrame;
      
      private var _visible:Boolean = false;
      
      private var _bagLockedInfo:BagLockedInfo;
      
      private var _currentFn:Function;
      
      public function BagLockedController()
      {
         super();
      }
      
      public static function get Instance() : BagLockedController
      {
         if(_instance == null)
         {
            _instance = new BagLockedController();
         }
         return _instance;
      }
      
      public function set bagLockedInfo(value:BagLockedInfo) : void
      {
         this._bagLockedInfo = value;
      }
      
      public function get bagLockedInfo() : BagLockedInfo
      {
         if(!this._bagLockedInfo)
         {
            this._bagLockedInfo = new BagLockedInfo();
         }
         return this._bagLockedInfo;
      }
      
      private function loadUi(fn:Function) : void
      {
         this._currentFn = fn;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__uiProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__uiComplete);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_BAGLOCKER);
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__uiProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__uiComplete);
      }
      
      private function __uiProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_BAGLOCKER)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __uiComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_BAGLOCKER)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__uiProgress);
            event.currentTarget.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__uiComplete);
            UIModuleSmallLoading.Instance.hide();
            if(this._currentFn != null)
            {
               this._currentFn();
            }
            this._currentFn = null;
         }
      }
      
      public function show() : void
      {
         this.loadUi(this.onShow);
      }
      
      private function onShow() : void
      {
         switch(LOCK_SETTING)
         {
            case -1:
               if(!this._explainFrame)
               {
                  this._explainFrame = ComponentFactory.Instance.creat("baglocked.explainFrame");
                  this._explainFrame.bagLockedController = this;
               }
               this._explainFrame.show();
               break;
            case 0:
               if(!this._explainFrame2)
               {
                  this._explainFrame2 = ComponentFactory.Instance.creat("baglocked.explainFrame2");
                  this._explainFrame2.bagLockedController = this;
               }
               this._explainFrame2.show();
               BaglockedManager.Instance.checkBindCase = 0;
               SocketManager.Instance.out.checkPhoneBind();
               BaglockedManager.Instance.addLockPwdEvent();
               break;
            case 1:
               if(!this._explainFrame4399)
               {
                  this._explainFrame4399 = ComponentFactory.Instance.creat("baglocked.explainFrame4399");
                  this._explainFrame4399.bagLockedController = this;
               }
               this._explainFrame4399.show();
               break;
            case 2:
         }
      }
      
      public function closeExplainFrame() : void
      {
         if(Boolean(this._explainFrame))
         {
            ObjectUtils.disposeObject(this._explainFrame);
         }
         this._explainFrame = null;
         if(Boolean(this._explainFrame2))
         {
            ObjectUtils.disposeObject(this._explainFrame2);
         }
         this._explainFrame2 = null;
         if(Boolean(this._explainFrame4399))
         {
            ObjectUtils.disposeObject(this._explainFrame4399);
         }
         this._explainFrame4399 = null;
      }
      
      public function openSetPassFrame1() : void
      {
         this._setPassFrame1 = ComponentFactory.Instance.creat("baglocked.setPassFrame1");
         this._setPassFrame1.bagLockedController = this;
         this._setPassFrame1.show();
      }
      
      public function closeSetPassFrame1() : void
      {
         ObjectUtils.disposeObject(this._setPassFrame1);
         this._setPassFrame1 = null;
      }
      
      public function openSetPassFrame2() : void
      {
         this._setPassFrame2 = ComponentFactory.Instance.creat("baglocked.setPassFrame2");
         this._setPassFrame2.bagLockedController = this;
         this._setPassFrame2.show();
      }
      
      public function closeSetPassFrame2() : void
      {
         ObjectUtils.disposeObject(this._setPassFrame2);
         this._setPassFrame2 = null;
      }
      
      public function openSetPassFrame3() : void
      {
         this._setPassFrame3 = ComponentFactory.Instance.creat("baglocked.setPassFrame3");
         this._setPassFrame3.bagLockedController = this;
         this._setPassFrame3.show();
      }
      
      public function closeSetPassFrame3() : void
      {
         ObjectUtils.disposeObject(this._setPassFrame3);
         this._setPassFrame3 = null;
      }
      
      public function setPassComplete() : void
      {
         SocketManager.Instance.out.sendBagLocked(this._bagLockedInfo.psw,1,"",this._bagLockedInfo.questionOne,this._bagLockedInfo.answerOne,this._bagLockedInfo.questionTwo,this._bagLockedInfo.answerTwo);
         this._bagLockedInfo = null;
      }
      
      public function openBagLockedGetFrame() : void
      {
         this.loadUi(this.onOpenBagLockedGetFrame);
      }
      
      private function onOpenBagLockedGetFrame() : void
      {
         if(this._bagLockedGetFrame == null)
         {
            this._bagLockedGetFrame = ComponentFactory.Instance.creat("baglocked.bagLockedGetFrame");
            this._bagLockedGetFrame.bagLockedController = this;
         }
         this._bagLockedGetFrame.show();
      }
      
      public function clearBagLockedGetFrame() : void
      {
         this._bagLockedGetFrame = null;
      }
      
      public function BagLockedGetFrameController() : void
      {
         SocketManager.Instance.out.sendBagLocked(this._bagLockedInfo.psw,2);
         this._bagLockedInfo = null;
      }
      
      public function closeBagLockedGetFrame() : void
      {
         this.close();
      }
      
      public function openUpdatePassFrame() : void
      {
         this._updatePassFrame = ComponentFactory.Instance.creat("baglocked.updatePassFrame");
         this._updatePassFrame.bagLockedController = this;
         this._updatePassFrame.show();
      }
      
      public function updatePassFrameController() : void
      {
         SocketManager.Instance.out.sendBagLocked(this._bagLockedInfo.psw,3,this._bagLockedInfo.newPwd);
         this._bagLockedInfo = null;
      }
      
      public function closeUpdatePassFrame() : void
      {
         this.close();
      }
      
      public function openDelPassFrame() : void
      {
         this._delPassFrame = ComponentFactory.Instance.creat("baglocked.delPassFrame");
         this._delPassFrame.bagLockedController = this;
         this._delPassFrame.show();
      }
      
      public function delPassFrameController() : void
      {
         SocketManager.Instance.out.sendBagLocked("",4,"",this._bagLockedInfo.questionOne,this._bagLockedInfo.answerOne,this._bagLockedInfo.questionTwo,this._bagLockedInfo.answerTwo);
         this._bagLockedInfo = null;
      }
      
      public function closeDelPassFrame() : void
      {
         this.close();
      }
      
      public function openSetPassFrameNew() : void
      {
         this._setPassFrameNew = ComponentFactory.Instance.creat("baglocked.setPassFrameNew");
         this._setPassFrameNew.bagLockedController = this;
         this._setPassFrameNew.show();
      }
      
      public function setPassFrameNewController() : void
      {
         SocketManager.Instance.out.sendBagLocked(this._bagLockedInfo.psw,1);
         this._bagLockedInfo = null;
      }
      
      public function closeSetPassFrameNew() : void
      {
         this.close();
      }
      
      public function openAppealFrame() : void
      {
         this._appealFrame = ComponentFactory.Instance.creat("baglocked.appealFrame");
         this._appealFrame.bagLockedController = this;
         this._appealFrame.show();
      }
      
      public function openPhoneServiceFrame() : void
      {
         this._phoneServiceFrame = ComponentFactory.Instance.creat("baglocked.phoneServiceFrame");
         this._phoneServiceFrame.init2(PhoneServiceFrame.TYPE_SERVICE);
         this._phoneServiceFrame.bagLockedController = this;
         this._phoneServiceFrame.show();
      }
      
      public function openChangePhoneFrame() : void
      {
         this._changePhoneFrame = ComponentFactory.Instance.creat("baglocked.phoneServiceFrame");
         this._changePhoneFrame.init2(PhoneServiceFrame.TYPE_CHANGE);
         this._changePhoneFrame.bagLockedController = this;
         this._changePhoneFrame.show();
      }
      
      public function openChangePhoneFrame1() : void
      {
         this._changePhoneFrame1 = ComponentFactory.Instance.creat("baglocked.phoneInputFrame");
         this._changePhoneFrame1.init2(0);
         this._changePhoneFrame1.bagLockedController = this;
         this._changePhoneFrame1.show();
      }
      
      public function openChangePhoneFrame2() : void
      {
         this._changePhoneFrame2 = ComponentFactory.Instance.creat("baglocked.msnConfirmFrame");
         this._changePhoneFrame2.init2(0);
         this._changePhoneFrame2.bagLockedController = this;
         this._changePhoneFrame2.show();
      }
      
      public function openChangePhoneFrame3() : void
      {
         this._changePhoneFrame3 = ComponentFactory.Instance.creat("baglocked.phoneConfirmFrame");
         this._changePhoneFrame3.init2(0);
         this._changePhoneFrame3.bagLockedController = this;
         this._changePhoneFrame3.show();
      }
      
      public function openChangePhoneFrame4() : void
      {
         this._changePhoneFrame4 = ComponentFactory.Instance.creat("baglocked.msnConfirmFrame");
         this._changePhoneFrame4.init2(1);
         this._changePhoneFrame4.bagLockedController = this;
         this._changePhoneFrame4.show();
      }
      
      public function openQuestionConfirmFrame1() : void
      {
         this._questionConfirmFrame1 = ComponentFactory.Instance.creat("baglocked.questionConfirmFrame");
         this._questionConfirmFrame1.bagLockedController = this;
         this._questionConfirmFrame1.show();
      }
      
      public function openQuestionConfirmFrame2() : void
      {
         this._questionConfirmFrame2 = ComponentFactory.Instance.creat("baglocked.phoneConfirmFrame");
         this._questionConfirmFrame2.init2(1);
         this._questionConfirmFrame2.bagLockedController = this;
         this._questionConfirmFrame2.show();
      }
      
      public function openQuestionConfirmFrame3() : void
      {
         this._questionConfirmFrame3 = ComponentFactory.Instance.creat("baglocked.msnConfirmFrame");
         this._questionConfirmFrame3.init2(2);
         this._questionConfirmFrame3.bagLockedController = this;
         this._questionConfirmFrame3.show();
      }
      
      public function openDeleteQuestionFrame1() : void
      {
         this._deleteQuestionFrame1 = ComponentFactory.Instance.creat("baglocked.deleteInputFrame");
         this._deleteQuestionFrame1.init2(0);
         this._deleteQuestionFrame1.bagLockedController = this;
         this._deleteQuestionFrame1.show();
      }
      
      public function openDeleteQuestionFrame2() : void
      {
         this._deleteQuestionFrame2 = ComponentFactory.Instance.creat("baglocked.deleteConfirmFrame");
         this._deleteQuestionFrame2.init2(0);
         this._deleteQuestionFrame2.bagLockedController = this;
         this._deleteQuestionFrame2.show();
      }
      
      public function openDeletePwdFrame() : void
      {
         this._deletePwdFrame = ComponentFactory.Instance.creat("baglocked.phoneServiceFrame");
         this._deletePwdFrame.init2(PhoneServiceFrame.TYPE_DELETE);
         this._deletePwdFrame.bagLockedController = this;
         this._deletePwdFrame.show();
      }
      
      public function openDeletePwdByphoneFrame1() : void
      {
         this._deletePwdFrame1 = ComponentFactory.Instance.creat("baglocked.deleteInputFrame");
         this._deletePwdFrame1.init2(1);
         this._deletePwdFrame1.bagLockedController = this;
         this._deletePwdFrame1.show();
      }
      
      public function openDeletePwdByphoneFrame2() : void
      {
         this._deletePwdFrame2 = ComponentFactory.Instance.creat("baglocked.deleteConfirmFrame");
         this._deletePwdFrame2.init2(1);
         this._deletePwdFrame2.bagLockedController = this;
         this._deletePwdFrame2.show();
      }
      
      public function openBindPhoneFrame() : void
      {
         this._benefitOfBindingFrame = ComponentFactory.Instance.creat("baglocked.benefitOfBindingFrame");
         this._benefitOfBindingFrame.bagLockedController = this;
         this._benefitOfBindingFrame.show();
      }
      
      public function openGetConfirmFrame() : void
      {
         this._getConfirmFrame = ComponentFactory.Instance.creat("baglocked.getConfirmFrame");
         this._getConfirmFrame.bagLockedController = this;
         this._getConfirmFrame.show();
      }
      
      public function openConfirmNum4399Frame() : void
      {
         this._confirmNum4399Frame = ComponentFactory.Instance.creat("baglocked.confirmNum4399Frame");
         this._confirmNum4399Frame.bagLockedController = this;
         this._confirmNum4399Frame.show();
      }
      
      public function close() : void
      {
         ObjectUtils.disposeObject(this._updatePassFrame);
         this._updatePassFrame = null;
         ObjectUtils.disposeObject(this._bagLockedGetFrame);
         this._bagLockedGetFrame = null;
         ObjectUtils.disposeObject(this._delPassFrame);
         this._delPassFrame = null;
         ObjectUtils.disposeObject(this._setPassFrameNew);
         this._setPassFrameNew = null;
         ObjectUtils.disposeObject(this._setPassFrame3);
         this._setPassFrame3 = null;
         ObjectUtils.disposeObject(this._setPassFrame2);
         this._setPassFrame2 = null;
         ObjectUtils.disposeObject(this._setPassFrame1);
         this._setPassFrame1 = null;
         ObjectUtils.disposeObject(this._explainFrame);
         this._explainFrame = null;
         ObjectUtils.disposeObject(this._explainFrame2);
         this._explainFrame2 = null;
         ObjectUtils.disposeObject(this._explainFrame4399);
         this._explainFrame4399 = null;
         ObjectUtils.disposeObject(this._appealFrame);
         this._appealFrame = null;
         ObjectUtils.disposeObject(this._phoneServiceFrame);
         this._phoneServiceFrame = null;
         ObjectUtils.disposeObject(this._changePhoneFrame);
         this._changePhoneFrame = null;
         ObjectUtils.disposeObject(this._changePhoneFrame1);
         this._changePhoneFrame1 = null;
         ObjectUtils.disposeObject(this._changePhoneFrame2);
         this._changePhoneFrame2 = null;
         ObjectUtils.disposeObject(this._changePhoneFrame3);
         this._changePhoneFrame3 = null;
         ObjectUtils.disposeObject(this._changePhoneFrame4);
         this._changePhoneFrame4 = null;
         ObjectUtils.disposeObject(this._questionConfirmFrame1);
         this._questionConfirmFrame1 = null;
         ObjectUtils.disposeObject(this._questionConfirmFrame2);
         this._questionConfirmFrame2 = null;
         ObjectUtils.disposeObject(this._questionConfirmFrame3);
         this._questionConfirmFrame3 = null;
         ObjectUtils.disposeObject(this._deleteQuestionFrame1);
         this._deleteQuestionFrame1 = null;
         ObjectUtils.disposeObject(this._deleteQuestionFrame2);
         this._deleteQuestionFrame2 = null;
         ObjectUtils.disposeObject(this._deletePwdFrame);
         this._deletePwdFrame = null;
         ObjectUtils.disposeObject(this._deletePwdFrame1);
         this._deletePwdFrame1 = null;
         ObjectUtils.disposeObject(this._deletePwdFrame2);
         this._deletePwdFrame2 = null;
         ObjectUtils.disposeObject(this._benefitOfBindingFrame);
         this._benefitOfBindingFrame = null;
         ObjectUtils.disposeObject(this._getConfirmFrame);
         this._getConfirmFrame = null;
         ObjectUtils.disposeObject(this._confirmNum4399Frame);
         this._confirmNum4399Frame = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get questionConfirmFrame1() : QuestionConfirmFrame
      {
         return this._questionConfirmFrame1;
      }
      
      public function get explainFrame2() : ExplainFrame2
      {
         return this._explainFrame2;
      }
   }
}

