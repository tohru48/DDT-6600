package sevenDayTarget.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import sevenDayTarget.controller.NewSevenDayAndNewPlayerManager;
   import sevenDayTarget.model.NewTargetQuestionInfo;
   
   public class NewSevenDayAndNewPlayerMainView extends Frame
   {
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _sevenDayBtn:SelectedButton;
      
      private var _newPlayerBtn:SelectedButton;
      
      private var _sevenDayMainView:SevenDayTargetMainView;
      
      private var _newPlayerRewardMainView:NewPlayerRewardMainView;
      
      public function NewSevenDayAndNewPlayerMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._sevenDayBtn = ComponentFactory.Instance.creatComponentByStylename("sevenDay.sevenDayBtn");
         this._newPlayerBtn = ComponentFactory.Instance.creatComponentByStylename("sevenDay.newPlayerBtn");
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         if(NewSevenDayAndNewPlayerManager.Instance.sevenDayOpen && NewSevenDayAndNewPlayerManager.Instance.newPlayerOpen)
         {
            this._sevenDayMainView = ComponentFactory.Instance.creatComponentByStylename("sevenDayTarget.sevenDayTargetFrame");
            addToContent(this._sevenDayMainView);
            this._newPlayerRewardMainView = new NewPlayerRewardMainView();
            addToContent(this._newPlayerRewardMainView);
            addToContent(this._sevenDayBtn);
            addToContent(this._newPlayerBtn);
            this._btnGroup.addSelectItem(this._sevenDayBtn);
            this._btnGroup.addSelectItem(this._newPlayerBtn);
            this._btnGroup.selectIndex = 0;
         }
         else if(NewSevenDayAndNewPlayerManager.Instance.sevenDayOpen && NewSevenDayAndNewPlayerManager.Instance.newPlayerOpen == false)
         {
            this._sevenDayMainView = ComponentFactory.Instance.creatComponentByStylename("sevenDayTarget.sevenDayTargetFrame");
            addToContent(this._sevenDayMainView);
            addToContent(this._sevenDayBtn);
            this._btnGroup.addSelectItem(this._sevenDayBtn);
            this._btnGroup.selectIndex = 0;
         }
         else if(NewSevenDayAndNewPlayerManager.Instance.sevenDayOpen == false && NewSevenDayAndNewPlayerManager.Instance.newPlayerOpen)
         {
            this._newPlayerRewardMainView = new NewPlayerRewardMainView();
            addToContent(this._newPlayerRewardMainView);
            addToContent(this._newPlayerBtn);
            PositionUtils.setPos(this._newPlayerBtn,"sevenDayAndNewPlayer.newPlayerBntPos");
            this._newPlayerBtn.selected = true;
         }
         else
         {
            this.dispose();
         }
      }
      
      private function __changeHandler(event:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               if(Boolean(this._sevenDayMainView))
               {
                  this._sevenDayMainView.visible = true;
               }
               if(Boolean(this._newPlayerRewardMainView))
               {
                  this._newPlayerRewardMainView.visible = false;
               }
               break;
            case 1:
               if(Boolean(this._sevenDayMainView))
               {
                  this._sevenDayMainView.visible = false;
               }
               if(Boolean(this._newPlayerRewardMainView))
               {
                  this._newPlayerRewardMainView.visible = true;
               }
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               NewSevenDayAndNewPlayerManager.Instance.hideMainView();
         }
      }
      
      public function todayInfo() : NewTargetQuestionInfo
      {
         if(Boolean(this._sevenDayMainView))
         {
            return this._sevenDayMainView.todayQuestInfo;
         }
         return null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         NewSevenDayAndNewPlayerManager.Instance.newPlayerMainViewPreOk = false;
         NewSevenDayAndNewPlayerManager.Instance.sevenDayMainViewPreOk = false;
      }
   }
}

