package ddt.view.academyCommon.academyRequest
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFormat;
   
   public class AcademyAnswerMasterFrame extends AcademyRequestMasterFrame implements Disposeable
   {
      
      public static const BINGIN_INDEX:int = 3;
      
      protected var _messageText:FilterFrameText;
      
      protected var _uid:int;
      
      protected var _name:String;
      
      protected var _message:String;
      
      protected var _nameLabel:TextFormat;
      
      protected var _lookBtn:TextButton;
      
      protected var _cancelBtn:TextButton;
      
      protected var _unAcceptBtn:SelectedCheckButton;
      
      public function AcademyAnswerMasterFrame()
      {
         super();
      }
      
      override public function show() : void
      {
         SoundManager.instance.play("008");
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override protected function initContent() : void
      {
         var pos1:Point = null;
         var pos2:Point = null;
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestApprenticeFrame.title");
         _alertInfo.showCancel = _alertInfo.showSubmit = _alertInfo.enterEnable = this.enterEnable = false;
         info = _alertInfo;
         pos1 = ComponentFactory.Instance.creatCustomObject("AcademyAnswerMasterFrame.inputPos1");
         pos2 = ComponentFactory.Instance.creatCustomObject("AcademyAnswerMasterFrame.inputPos2");
         _inputBG = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.inputBg2");
         addToContent(_inputBG);
         _inputBG.x = pos1.x;
         _inputBG.y = pos1.y;
         this._messageText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.MessageText");
         addToContent(this._messageText);
         this._messageText.x = pos2.x;
         this._messageText.y = pos2.y;
         _explainText = ComponentFactory.Instance.creat("academyCommon.academyAnswerMasterFrame.explainText");
         addToContent(_explainText);
         this._nameLabel = ComponentFactory.Instance.model.getSet("academyCommon.academyRequest.explainNameTextTF");
         this._lookBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyAnswerApprenticeFrame.LookButton");
         this._lookBtn.text = LanguageMgr.GetTranslation("civil.leftview.equipName");
         addToContent(this._lookBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRequestApprenticeFrame.submitButton");
         this._cancelBtn.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestApprenticeFrame.submitLabel");
         addToContent(this._cancelBtn);
         this._unAcceptBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyAnswerApprenticeFrame.selectBtn");
         addToContent(this._unAcceptBtn);
         this._unAcceptBtn.text = LanguageMgr.GetTranslation("ddt.farms.refreshPetsNOAlert");
      }
      
      override protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._lookBtn.addEventListener(MouseEvent.CLICK,this.__onLookBtnClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__onCancelBtnClick);
         this._unAcceptBtn.addEventListener(Event.SELECT,this.notAcceptAnswer);
      }
      
      protected function notAcceptAnswer(event:Event) : void
      {
         var index:int = 0;
         SoundManager.instance.play("008");
         var playerinfo:PlayerInfo = PlayerManager.Instance.findPlayer(this._uid,PlayerManager.Instance.Self.ZoneID);
         if(this._unAcceptBtn.selected)
         {
            if(SharedManager.Instance.unAcceptAnswer.indexOf(playerinfo.ID) < 0)
            {
               SharedManager.Instance.unAcceptAnswer.push(playerinfo.ID);
            }
         }
         else
         {
            index = int(SharedManager.Instance.unAcceptAnswer.indexOf(playerinfo.ID));
            SharedManager.Instance.unAcceptAnswer.splice(index,1);
         }
      }
      
      protected function __onCancelBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.submit();
      }
      
      protected function __onLookBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.lookUpEquip();
      }
      
      override protected function __onResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               this.lookUpEquip();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.hide();
               break;
            case FrameEvent.CANCEL_CLICK:
               this.submit();
         }
      }
      
      public function setMessage(id:int, name:String, message:String) : void
      {
         this._uid = id;
         this._name = name;
         this._message = message;
         this.update();
      }
      
      protected function update() : void
      {
         this._messageText.htmlText = this._message;
         _explainText.htmlText = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyAnswerMasterFrame.AnswerMaster",this._name);
      }
      
      protected function lookUpEquip() : void
      {
         PlayerInfoViewControl.viewByID(this._uid,PlayerManager.Instance.Self.ZoneID);
      }
      
      override protected function submit() : void
      {
         SocketManager.Instance.out.sendAcademyMasterConfirm(true,this._uid);
         this.dispose();
      }
      
      override protected function hide() : void
      {
         SocketManager.Instance.out.sendAcademyMasterConfirm(false,this._uid);
         this.dispose();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._unAcceptBtn))
         {
            ObjectUtils.disposeObject(this._unAcceptBtn);
            this._unAcceptBtn = null;
         }
         if(Boolean(this._messageText))
         {
            ObjectUtils.disposeObject(this._messageText);
            this._messageText = null;
         }
         if(Boolean(this._lookBtn))
         {
            this._lookBtn.removeEventListener(MouseEvent.CLICK,this.__onLookBtnClick);
            ObjectUtils.disposeObject(this._lookBtn);
            this._lookBtn = null;
         }
         if(Boolean(this._cancelBtn))
         {
            this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__onCancelBtnClick);
            ObjectUtils.disposeObject(this._cancelBtn);
            this._lookBtn = null;
         }
         this._nameLabel = null;
         super.dispose();
      }
   }
}

