package roulette
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HelpFrame extends Frame
   {
      
      private var _view:Sprite;
      
      private var _submitButton:TextButton;
      
      public function HelpFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._view = new Sprite();
         this._submitButton = ComponentFactory.Instance.creat("roulette.helpFrameEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("ok");
         this._view.addChild(this._submitButton);
         addToContent(this._view);
         escEnable = true;
         enterEnable = true;
      }
      
      public function set submitButtonPos(value:String) : void
      {
         PositionUtils.setPos(this._submitButton,value);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this._submit);
      }
      
      public function setView(view:DisplayObject) : void
      {
         this._view.addChild(view);
      }
      
      private function _submit(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._submitButton))
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this._submit);
            ObjectUtils.disposeObject(this._submitButton);
         }
         this._submitButton = null;
         if(Boolean(this._view))
         {
            ObjectUtils.disposeAllChildren(this._view);
         }
         this._view = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

