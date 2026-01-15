package exitPrompt
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.DuowanInterfaceEvent;
   import ddt.manager.DuowanInterfaceManage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class ExitPromptFrame extends BaseAlerFrame
   {
      
      private var _alertInfo:AlertInfo;
      
      private var _BG:MutipleImage;
      
      private var _menu:ExitAllButton;
      
      private var _listScroll:ScrollPanel;
      
      private const CENTERX:int = 13;
      
      private const CENTERY:int = 46;
      
      public function ExitPromptFrame()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.exitPrompt.prompt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true);
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._BG = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.bg");
         addToContent(this._BG);
         this._menu = ComponentFactory.Instance.creatComponentByStylename("ExitAllButton");
         this._menu.start();
         if(this._menu.needScorllBar)
         {
            this._listScroll = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.scrollPanel");
            this._listScroll.hScrollProxy = ScrollPanel.OFF;
            this._listScroll.vScrollProxy = ScrollPanel.ON;
            this._listScroll.setView(this._menu);
            addToContent(this._listScroll);
            this._listScroll.invalidateViewport();
         }
         else
         {
            this._menu.x = this.CENTERX;
            this._menu.y = this.CENTERY;
            addToContent(this._menu);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
         StageReferance.stage.focus = this;
      }
      
      public function setList(arr:Array) : void
      {
      }
      
      public function _menuChange(e:Event) : void
      {
         if(Boolean(this._listScroll))
         {
            this._listScroll.invalidateViewport();
         }
      }
      
      private function removeView() : void
      {
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         if(Boolean(this._menu))
         {
            ObjectUtils.disposeObject(this._menu);
         }
         if(Boolean(this._listScroll))
         {
            ObjectUtils.disposeObject(this._listScroll);
         }
         this._BG = null;
         this._menu = null;
         this._listScroll = null;
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._menu.addEventListener(ExitAllButton.CHANGE,this._menuChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               dispatchEvent(new Event("close"));
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.dispose();
               DuowanInterfaceManage.Instance.dispatchEvent(new DuowanInterfaceEvent(DuowanInterfaceEvent.OUTLINE));
               dispatchEvent(new Event("submit"));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

