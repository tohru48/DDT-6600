package farm.viewx
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import flash.display.DisplayObject;
   
   public class confirmStopHelperFrame extends BaseAlerFrame
   {
      
      private var _addBtn:BaseButton;
      
      private var _removeBtn:BaseButton;
      
      private var _msgTxt:FilterFrameText;
      
      private var _bgTitle:DisplayObject;
      
      public function confirmStopHelperFrame()
      {
         super();
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.title = LanguageMgr.GetTranslation("ddt.farms.stopHelperComfirm");
         alertInfo.bottomGap = 37;
         alertInfo.buttonGape = 65;
         alertInfo.customPos = ComponentFactory.Instance.creat("farm.confirmStopHelperFramePos");
         this.info = alertInfo;
         this.intView();
         this.initEvent();
      }
      
      private function intView() : void
      {
         this._bgTitle = ComponentFactory.Instance.creat("assets.farm.titleSmall");
         addChild(this._bgTitle);
         PositionUtils.setPos(this._bgTitle,PositionUtils.creatPoint("farm.confirmStopHelperFrameTitlePos"));
         this._msgTxt = ComponentFactory.Instance.creat("farm.killCrop.msgtext");
         this._msgTxt.text = LanguageMgr.GetTranslation("ddt.farms.stopHelperComfirmText");
         addToContent(this._msgTxt);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      protected function __framePesponse(event:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               FarmModelController.instance.dispatchEvent(new FarmEvent(FarmEvent.CONFIRM_STOP_HELPER));
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
         }
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._msgTxt))
         {
            ObjectUtils.disposeObject(this._msgTxt);
            this._msgTxt = null;
         }
         if(Boolean(this._addBtn))
         {
            ObjectUtils.disposeObject(this._addBtn);
            this._addBtn = null;
         }
         if(Boolean(this._removeBtn))
         {
            ObjectUtils.disposeObject(this._removeBtn);
            this._removeBtn = null;
         }
         if(Boolean(this._bgTitle))
         {
            ObjectUtils.disposeObject(this._bgTitle);
            this._bgTitle = null;
         }
         super.dispose();
      }
   }
}

