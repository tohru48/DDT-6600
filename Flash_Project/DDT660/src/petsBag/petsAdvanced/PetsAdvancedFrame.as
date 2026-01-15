package petsBag.petsAdvanced
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import store.HelpFrame;
   
   public class PetsAdvancedFrame extends Frame
   {
      
      private var _hBox:HBox;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _ringStarBtn:SelectedButton;
      
      private var _evolutionBtn:SelectedButton;
      
      private var _formBtn:SelectedButton;
      
      private var _eatPetsBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _currentIndex:int;
      
      private var _view:*;
      
      public function PetsAdvancedFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.helpBtn");
         PositionUtils.setPos(this._helpBtn,"petsBag.form.helpBtnPos");
         addToContent(this._helpBtn);
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.hBox");
         addToContent(this._hBox);
         this._ringStarBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStarBtn");
         this._hBox.addChild(this._ringStarBtn);
         this._evolutionBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolutionBtn");
         this._hBox.addChild(this._evolutionBtn);
         this._formBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.formBtn");
         this._hBox.addChild(this._formBtn);
         this._eatPetsBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPetsBtn");
         if(PathManager.eatPetsEnable)
         {
            this._hBox.addChild(this._eatPetsBtn);
         }
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._ringStarBtn);
         this._btnGroup.addSelectItem(this._evolutionBtn);
         this._btnGroup.addSelectItem(this._formBtn);
         this._btnGroup.addSelectItem(this._eatPetsBtn);
         this._btnGroup.selectIndex = 0;
         this._currentIndex = 0;
         PetsAdvancedManager.Instance.currentViewType = 1;
         PetsAdvancedManager.Instance.isPetsAdvancedViewShow = true;
         this._view = new PetsRisingStarView();
         addToContent(this._view);
      }
      
      public function setBtnEnableFalse() : void
      {
         this._ringStarBtn.enable = false;
         this._evolutionBtn.enable = false;
         this._formBtn.enable = false;
      }
      
      public function set enableBtn(value:Boolean) : void
      {
         this._ringStarBtn.mouseEnabled = this._evolutionBtn.mouseEnabled = this._formBtn.mouseEnabled = this._eatPetsBtn.mouseEnabled = value;
      }
      
      private function addEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onPetsHelp);
      }
      
      protected function __onPetsHelp(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("petsBag.petsFormHelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("petsBag.HelpFrame");
         helpPage.setView(helpBd);
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            if(PetsAdvancedManager.Instance.isAllMovieComplete)
            {
               SoundManager.instance.play("008");
               this.dispose();
            }
         }
      }
      
      protected function __changeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._btnGroup.selectIndex == this._currentIndex)
         {
            return;
         }
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               PetsAdvancedManager.Instance.currentViewType = 1;
               this._view = new PetsRisingStarView();
               break;
            case 1:
               PetsAdvancedManager.Instance.currentViewType = 2;
               this._view = new PetsEvolutionView();
               break;
            case 2:
               PetsAdvancedManager.Instance.currentViewType = 3;
               this._view = new PetsFormView();
               break;
            case 3:
               PetsAdvancedManager.Instance.currentViewType = 4;
               this._view = new PetsEatView();
         }
         this._currentIndex = this._btnGroup.selectIndex;
         if(this._view)
         {
            addToContent(this._view);
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onPetsHelp);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         PetsAdvancedManager.Instance.isPetsAdvancedViewShow = false;
         ObjectUtils.disposeObject(this._hBox);
         this._hBox = null;
         ObjectUtils.disposeObject(this._ringStarBtn);
         this._ringStarBtn = null;
         ObjectUtils.disposeObject(this._evolutionBtn);
         this._evolutionBtn = null;
         ObjectUtils.disposeObject(this._formBtn);
         this._formBtn = null;
         ObjectUtils.disposeObject(this._eatPetsBtn);
         this._eatPetsBtn = null;
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         ObjectUtils.disposeObject(this._btnGroup);
         this._btnGroup = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         super.dispose();
      }
   }
}

