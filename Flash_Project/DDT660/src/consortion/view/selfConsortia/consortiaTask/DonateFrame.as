package consortion.view.selfConsortia.consortiaTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class DonateFrame extends Frame
   {
      
      private var _conentText:FilterFrameText;
      
      private var _ownMoney:FilterFrameText;
      
      private var _taxMedal:TextInput;
      
      private var _confirm:TextButton;
      
      private var _cancel:TextButton;
      
      private var _targetValue:int;
      
      public function DonateFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         escEnable = true;
         enterEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("consortia.donateMEDAL");
         this._conentText = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.conentTxt");
         this._conentText.text = LanguageMgr.GetTranslation("core.MyConsortiaTax.conentTxt.text");
         this._ownMoney = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.totalMEDALTxt");
         this._taxMedal = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaMEDAL.input");
         this._confirm = ComponentFactory.Instance.creatComponentByStylename("core.DonateFrame.okBtn");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("core.DonateFrame.cancelBtn");
         addToContent(this._conentText);
         addToContent(this._ownMoney);
         addToContent(this._taxMedal);
         addToContent(this._confirm);
         addToContent(this._cancel);
         this._taxMedal.textField.restrict = "0-9";
         this._taxMedal.textField.maxChars = 8;
         this._confirm.text = LanguageMgr.GetTranslation("ok");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._confirm.enable = false;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._confirm.addEventListener(MouseEvent.CLICK,this.__confirmHanlder);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxMedal.addEventListener(Event.CHANGE,this.__taxChangeHandler);
         this._taxMedal.addEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._confirm.removeEventListener(MouseEvent.CLICK,this.__confirmHanlder);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxMedal.removeEventListener(Event.CHANGE,this.__taxChangeHandler);
         this._taxMedal.removeEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
      }
      
      private function __response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.CLOSE_CLICK)
         {
            this.dispose();
         }
      }
      
      private function __addToStageHandler(e:Event) : void
      {
         this._taxMedal.setFocus();
         this._ownMoney.text = PlayerManager.Instance.Self.BandMoney.toString();
         this._taxMedal.text = "";
      }
      
      private function __confirmHanlder(e:MouseEvent) : void
      {
         var Medal:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._taxMedal != null)
         {
            Medal = int(this._taxMedal.text);
            SocketManager.Instance.out.sendDonate(EquipType.MEDAL,Medal);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.donateOK"));
            this.dispose();
         }
      }
      
      private function __cancelHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __taxChangeHandler(e:Event) : void
      {
         if(this._taxMedal.text == "")
         {
            this._confirm.enable = false;
            return;
         }
         if(this._taxMedal.text == String(0))
         {
            this._taxMedal.text = "";
            return;
         }
         this._confirm.enable = true;
         var Medal:int = int(this._taxMedal.text);
         if(Medal >= PlayerManager.Instance.Self.BandMoney || Medal >= this._targetValue)
         {
            this._taxMedal.text = PlayerManager.Instance.Self.BandMoney <= this._targetValue ? PlayerManager.Instance.Self.BandMoney.toString() : this._targetValue.toString();
         }
      }
      
      private function __enterHanlder(event:KeyboardEvent) : void
      {
         event.stopImmediatePropagation();
         if(event.keyCode == Keyboard.ENTER)
         {
            if(this._taxMedal.text == "")
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.plaese"));
            }
            else
            {
               this.__confirmHanlder(null);
            }
         }
         if(event.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function set targetValue(value:int) : void
      {
         this._targetValue = value;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._conentText))
         {
            ObjectUtils.disposeObject(this._conentText);
         }
         this._conentText = null;
         if(Boolean(this._ownMoney))
         {
            ObjectUtils.disposeObject(this._ownMoney);
         }
         this._ownMoney = null;
         if(Boolean(this._taxMedal))
         {
            ObjectUtils.disposeObject(this._taxMedal);
         }
         this._taxMedal = null;
         if(Boolean(this._confirm))
         {
            ObjectUtils.disposeObject(this._confirm);
         }
         this._confirm = null;
         if(Boolean(this._cancel))
         {
            ObjectUtils.disposeObject(this._cancel);
         }
         this._cancel = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

