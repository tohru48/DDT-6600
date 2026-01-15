package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionSkillInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionOpenSkillFrame extends Frame
   {
      
      private var _cellBG:ScaleBitmapImage;
      
      private var _cell:ConsortionSkillCell;
      
      private var _numSelected:NumberSelecter;
      
      private var _riches:FilterFrameText;
      
      private var _ok:TextButton;
      
      private var _richesTxt:FilterFrameText;
      
      private var _richesbg:ScaleFrameImage;
      
      private var _info:ConsortionSkillInfo;
      
      private var _alertFrame:BaseAlerFrame;
      
      private var _isMetal:Boolean;
      
      public function ConsortionOpenSkillFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set isMetal(value:Boolean) : void
      {
         this._isMetal = value;
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortion.openSkillFrame.title");
         this._cellBG = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionOpenSkillFrame.CellBg");
         this._cell = ComponentFactory.Instance.creatCustomObject("openSkillFrame.cell");
         this._numSelected = ComponentFactory.Instance.creatComponentByStylename("consortion.openSkillFrame.numberSelected");
         this._richesTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.openSkillFrame.richesText");
         this._richesTxt.text = LanguageMgr.GetTranslation("consortion.openSkillFrame.richesText1");
         this._richesbg = ComponentFactory.Instance.creatComponentByStylename("consortion.openSkillFrame.richbg");
         this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.openSkillFrame.rich");
         this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.openSkillFrame.ok");
         addToContent(this._cellBG);
         addToContent(this._cell);
         addToContent(this._numSelected);
         addToContent(this._richesTxt);
         addToContent(this._richesbg);
         addToContent(this._riches);
         addToContent(this._ok);
         this._ok.text = LanguageMgr.GetTranslation("ok");
         this._riches.text = "0";
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._numSelected.addEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._ok.addEventListener(MouseEvent.CLICK,this.__okHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._numSelected.removeEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._ok.removeEventListener(MouseEvent.CLICK,this.__okHandler);
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __numberSelecterChange(event:Event) : void
      {
         SoundManager.instance.play("008");
         this._riches.text = String(this._numSelected.currentValue * this._info.riches);
         if(this._isMetal)
         {
            this._riches.text = String(this._info.metal * this._numSelected.currentValue);
         }
      }
      
      private function __okHandler(event:MouseEvent) : void
      {
         var temp:int = 0;
         var enoughFrame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(Boolean(this._info))
         {
            if(this._isMetal)
            {
               if(PlayerManager.Instance.Self.BandMoney < int(this._riches.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.giftLack"));
                  return;
               }
            }
            else if(this._info.type == 1 && PlayerManager.Instance.Self.consortiaInfo.Riches < int(this._riches.text) || this._info.type == 2 && PlayerManager.Instance.Self.Riches < int(this._riches.text))
            {
               enoughFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.enough" + this._info.type),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               enoughFrame.addEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
               return;
            }
            if(ConsortionModelControl.Instance.model.hasSomeGroupSkill(this._info.group,this._info.id))
            {
               this._alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortion.skillFrame.alertFrame.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,true,LayerManager.BLCAK_BLOCKGOUND);
               this._alertFrame.addEventListener(FrameEvent.RESPONSE,this.__alertResponseHandler);
               return;
            }
            temp = this._isMetal ? 2 : 1;
            SocketManager.Instance.out.sendConsortionSkill(true,this._info.id,int(this._numSelected.currentValue),temp);
            this.dispose();
         }
      }
      
      private function __noEnoughHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               ConsortionModelControl.Instance.alertTaxFrame();
         }
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
         frame.dispose();
         frame = null;
      }
      
      private function __alertResponseHandler(event:FrameEvent) : void
      {
         var temp:int = 0;
         this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__alertResponseHandler);
         this._alertFrame.dispose();
         this._alertFrame = null;
         switch(event.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(Boolean(this._info) && Boolean(this._numSelected))
               {
                  temp = this._isMetal ? 2 : 1;
                  SocketManager.Instance.out.sendConsortionSkill(true,this._info.id,int(this._numSelected.currentValue),temp);
                  this.dispose();
               }
         }
      }
      
      public function set info(value:ConsortionSkillInfo) : void
      {
         this._info = value;
         this._riches.text = String(this._info.riches * this._numSelected.currentValue);
         if(this._isMetal)
         {
            this._riches.text = String(this._info.metal * this._numSelected.currentValue);
         }
         this._richesbg.setFrame(value.type);
         this._richesTxt.text = LanguageMgr.GetTranslation("consortion.openSkillFrame.richesText" + value.type);
         if(this._isMetal)
         {
            this._richesbg.setFrame(3);
            this._richesTxt.text = LanguageMgr.GetTranslation("consortion.openSkillFrame.richesText3");
         }
         this._cell.tipData = value;
         this._cell.contentRect(60,59);
         this._cell.setGray(false);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         super.dispose();
         this._cellBG = null;
         this._cell = null;
         this._richesTxt = null;
         this._richesbg = null;
         this._numSelected = null;
         this._riches = null;
         this._ok = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

