package flowerGiving.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class FlowerGivingFrame extends Frame
   {
      
      private var _hBox:HBox;
      
      private var _mainPageBtn:SelectedButton;
      
      private var _todayRankBtn:SelectedButton;
      
      private var _yesRankBtn:SelectedButton;
      
      private var _cumuRankBtn:SelectedButton;
      
      private var _cumuGivingBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _view:*;
      
      private var currentIndex:int;
      
      public function FlowerGivingFrame()
      {
         super();
         escEnable = true;
         this.initView();
         this.addEvents();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("flowerGiving.title");
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.hBox");
         addToContent(this._hBox);
         this._mainPageBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.mainPageBtn");
         this._hBox.addChild(this._mainPageBtn);
         this._todayRankBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.todayRankBtn");
         this._hBox.addChild(this._todayRankBtn);
         this._yesRankBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.yesRankBtn");
         this._hBox.addChild(this._yesRankBtn);
         this._cumuRankBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.cumuRankBtn");
         this._hBox.addChild(this._cumuRankBtn);
         this._cumuGivingBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.cumuGivingBtn");
         this._hBox.addChild(this._cumuGivingBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._mainPageBtn);
         this._btnGroup.addSelectItem(this._todayRankBtn);
         this._btnGroup.addSelectItem(this._yesRankBtn);
         this._btnGroup.addSelectItem(this._cumuRankBtn);
         this._btnGroup.addSelectItem(this._cumuGivingBtn);
         this._btnGroup.selectIndex = 0;
         this.currentIndex = 0;
         this._view = new FlowerMainView();
         addToContent(this._view);
      }
      
      private function addEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
      }
      
      protected function __changeHandler(event:Event) : void
      {
         if(this._btnGroup.selectIndex == this.currentIndex)
         {
            return;
         }
         SoundManager.instance.play("008");
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._view = new FlowerMainView();
               break;
            case 1:
               this._view = new FlowerRankView(0);
               break;
            case 2:
               this._view = new FlowerRankView(1);
               break;
            case 3:
               this._view = new FlowerRankView(2);
               break;
            case 4:
               this._view = new FlowerSendRewardView();
         }
         this.currentIndex = this._btnGroup.selectIndex;
         if(this._view)
         {
            addToContent(this._view);
         }
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._hBox);
         this._hBox = null;
         ObjectUtils.disposeObject(this._mainPageBtn);
         this._mainPageBtn = null;
         ObjectUtils.disposeObject(this._todayRankBtn);
         this._todayRankBtn = null;
         ObjectUtils.disposeObject(this._yesRankBtn);
         this._yesRankBtn = null;
         ObjectUtils.disposeObject(this._cumuRankBtn);
         this._cumuRankBtn = null;
         ObjectUtils.disposeObject(this._cumuGivingBtn);
         this._cumuGivingBtn = null;
         ObjectUtils.disposeObject(this._btnGroup);
         this._btnGroup = null;
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         super.dispose();
      }
   }
}

