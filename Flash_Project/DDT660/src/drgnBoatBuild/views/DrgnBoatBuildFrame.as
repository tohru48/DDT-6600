package drgnBoatBuild.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import drgnBoatBuild.DrgnBoatBuildManager;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import store.HelpFrame;
   
   public class DrgnBoatBuildFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _leftView:DrgnBoatBuildLeftView;
      
      private var _rightView:DrgnBoatBuildRightView;
      
      private var _helpBtn:SimpleBitmapButton;
      
      public function DrgnBoatBuildFrame()
      {
         super();
         escEnable = true;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         _titleText = LanguageMgr.GetTranslation("drgnBoatBuild.frameTitle");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.bg");
         addToContent(this._bg);
         this._leftView = new DrgnBoatBuildLeftView();
         PositionUtils.setPos(this._leftView,"drgnBoatBuild.leftViewPos");
         addToContent(this._leftView);
         this._rightView = new DrgnBoatBuildRightView();
         PositionUtils.setPos(this._rightView,"drgnBoatBuild.rightViewPos");
         addToContent(this._rightView);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.helpBtn");
         addToContent(this._helpBtn);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      protected function __helpBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("drgnBoatBuild.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("drgnBoatBuild.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         helpPage.changeSubmitButtonY(-71);
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopPropagation();
         (event.currentTarget as DrgnBoatBuildFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpBtnClick);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         DrgnBoatBuildManager.instance.frame = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._leftView);
         this._leftView = null;
         ObjectUtils.disposeObject(this._rightView);
         this._rightView = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         super.dispose();
      }
   }
}

