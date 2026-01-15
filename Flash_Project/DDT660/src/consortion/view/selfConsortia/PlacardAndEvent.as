package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import consortion.view.selfConsortia.consortiaTask.ConsortiaTaskView;
   import ddt.data.ConsortiaDutyType;
   import ddt.data.ConsortiaEventInfo;
   import ddt.data.ConsortiaInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import road7th.utils.StringHelper;
   
   public class PlacardAndEvent extends Sprite implements Disposeable
   {
      
      private var _taskBtn:SelectedTextButton;
      
      private var _placardBtn:SelectedTextButton;
      
      private var _eventBtn:SelectedTextButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _BG:MutipleImage;
      
      private var _placard:TextArea;
      
      private var _editBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _vote:BaseButton;
      
      private var _vbox:VBox;
      
      private var _eventPanel:ScrollPanel;
      
      private var _lastPlacard:String;
      
      private var _myTaskView:ConsortiaTaskView;
      
      public function PlacardAndEvent()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.ListBG");
         this._taskBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.taskBtn");
         this._placardBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.placard");
         this._eventBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.event");
         this._placard = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.placardText");
         this._editBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.edit");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.cancel");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.eventVbox");
         this._eventPanel = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.eventPanel");
         this._vote = ComponentFactory.Instance.creatComponentByStylename("consortion.placardAndEvent.vote");
         this._myTaskView = ComponentFactory.Instance.creatCustomObject("ConsortiaTaskView");
         PositionUtils.setPos(this._myTaskView,"placardAndEvent.ConsortiaTaskView.pos");
         this._taskBtn.text = LanguageMgr.GetTranslation("consortia.PlacardAndEvent.SelectBtnText1");
         this._placardBtn.text = LanguageMgr.GetTranslation("consortia.PlacardAndEvent.SelectBtnText2");
         this._eventBtn.text = LanguageMgr.GetTranslation("consortia.PlacardAndEvent.SelectBtnText3");
         addChild(this._BG);
         addChild(this._taskBtn);
         addChild(this._placardBtn);
         addChild(this._eventBtn);
         addChild(this._placard);
         addChild(this._editBtn);
         addChild(this._cancelBtn);
         addChild(this._eventPanel);
         addChild(this._vote);
         addChild(this._myTaskView);
         this._eventPanel.setView(this._vbox);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._placardBtn);
         this._btnGroup.addSelectItem(this._eventBtn);
         this._btnGroup.addSelectItem(this._taskBtn);
         this._btnGroup.selectIndex = 2;
         this._editBtn.text = LanguageMgr.GetTranslation("ok");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         this.showPlacardOrEvent(this._btnGroup.selectIndex);
      }
      
      private function initEvent() : void
      {
         this._taskBtn.addEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._placardBtn.addEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._eventBtn.addEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._vote.addEventListener(MouseEvent.CLICK,this.__voteHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__groupChangeHandler);
         this._editBtn.addEventListener(MouseEvent.CLICK,this.__editHandler);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._placard.addEventListener(MouseEvent.MOUSE_DOWN,this.__isClearHandler);
         this._placard.textField.addEventListener(Event.CHANGE,this.__inputHandler);
         PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__placardChangeHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__rightChangeHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.EVENT_LIST_CHANGE,this.__eventChangeHandler);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._taskBtn))
         {
            this._taskBtn.removeEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         }
         if(Boolean(this._placardBtn))
         {
            this._placardBtn.removeEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         }
         if(Boolean(this._eventBtn))
         {
            this._eventBtn.removeEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         }
         if(Boolean(this._vote))
         {
            this._vote.removeEventListener(MouseEvent.CLICK,this.__voteHandler);
         }
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.removeEventListener(Event.CHANGE,this.__groupChangeHandler);
         }
         if(Boolean(this._editBtn))
         {
            this._editBtn.removeEventListener(MouseEvent.CLICK,this.__editHandler);
         }
         if(Boolean(this._cancelBtn))
         {
            this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         }
         if(Boolean(this._placard))
         {
            this._placard.removeEventListener(MouseEvent.MOUSE_DOWN,this.__isClearHandler);
         }
         if(Boolean(this._placard))
         {
            this._placard.textField.removeEventListener(Event.CHANGE,this.__inputHandler);
         }
         PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__placardChangeHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__rightChangeHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.EVENT_LIST_CHANGE,this.__eventChangeHandler);
      }
      
      private function __voteHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var pollFrame:ConsortionPollFrame = ComponentFactory.Instance.creatComponentByStylename("consortionPollFrame");
         LayerManager.Instance.addToLayer(pollFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         ConsortionModelControl.Instance.loadPollList(PlayerManager.Instance.Self.ConsortiaID);
      }
      
      private function upPlacard() : void
      {
         var str:String = PlayerManager.Instance.Self.consortiaInfo.Placard;
         this._placard.text = str == "" ? LanguageMgr.GetTranslation("tank.consortia.myconsortia.systemWord") : str;
         this._lastPlacard = this._placard.text;
         this._editBtn.enable = this._cancelBtn.enable = false;
         this._vote.visible = PlayerManager.Instance.Self.consortiaInfo.IsVoting;
         this._placard.editable = this._editBtn.visible = this._cancelBtn.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._4_Notice) && this._btnGroup.selectIndex == 0;
      }
      
      private function __btnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __groupChangeHandler(event:Event) : void
      {
         this.showPlacardOrEvent(this._btnGroup.selectIndex);
      }
      
      private function showPlacardOrEvent(type:int) : void
      {
         switch(type)
         {
            case 0:
               this._placard.visible = this._editBtn.visible = this._cancelBtn.visible = true;
               this._eventPanel.visible = false;
               this._myTaskView.visible = false;
               this.upPlacard();
               break;
            case 1:
               this._placard.visible = this._editBtn.visible = this._cancelBtn.visible = false;
               this._eventPanel.visible = true;
               this._vote.visible = false;
               this._myTaskView.visible = false;
               ConsortionModelControl.Instance.loadEventList(ConsortionModelControl.Instance.eventListComplete,PlayerManager.Instance.Self.ConsortiaID);
               break;
            case 2:
               this._placard.visible = this._editBtn.visible = this._cancelBtn.visible = false;
               this._eventPanel.visible = false;
               this._vote.visible = false;
               this._myTaskView.visible = true;
         }
      }
      
      private function __eventChangeHandler(event:ConsortionEvent) : void
      {
         var item:EventListItem = null;
         this._vbox.disposeAllChildren();
         var list:Vector.<ConsortiaEventInfo> = ConsortionModelControl.Instance.model.eventList;
         var len:int = int(list.length);
         for(var i:int = 0; i < len; i++)
         {
            item = new EventListItem();
            item.info = list[i];
            this._vbox.addChild(item);
         }
         this._eventPanel.invalidateViewport();
      }
      
      private function __editHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var b:ByteArray = new ByteArray();
         b.writeUTF(StringHelper.trim(this._placard.textField.text));
         if(b.length > 300)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaAfficheFrame.long"));
            return;
         }
         if(FilterWordManager.isGotForbiddenWords(this._placard.textField.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaAfficheFrame"));
            return;
         }
         var str:String = FilterWordManager.filterWrod(this._placard.textField.text);
         str = StringHelper.trim(str);
         SocketManager.Instance.out.sendConsortiaUpdatePlacard(str);
         this._cancelBtn.enable = false;
         this._editBtn.enable = false;
      }
      
      private function __cancelHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._placard.text = this._lastPlacard;
         this._cancelBtn.enable = false;
         this._editBtn.enable = false;
      }
      
      private function __isClearHandler(event:MouseEvent) : void
      {
         if(this._placard.editable)
         {
            this._placard.text = this._placard.text == LanguageMgr.GetTranslation("tank.consortia.myconsortia.systemWord") ? "" : this._placard.text;
         }
      }
      
      private function __inputHandler(event:Event) : void
      {
         this._cancelBtn.enable = true;
         this._editBtn.enable = true;
         StringHelper.checkTextFieldLength(this._placard.textField,200);
      }
      
      private function __placardChangeHandler(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties[ConsortiaInfo.PLACARD]) || Boolean(event.changedProperties[ConsortiaInfo.IS_VOTING]))
         {
            this.upPlacard();
         }
      }
      
      private function __rightChangeHandler(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Right"]))
         {
            this.upPlacard();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._vbox))
         {
            this._vbox.disposeAllChildren();
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._taskBtn))
         {
            ObjectUtils.disposeObject(this._taskBtn);
         }
         this._taskBtn = null;
         if(Boolean(this._myTaskView))
         {
            ObjectUtils.disposeObject(this._myTaskView);
         }
         this._myTaskView = null;
         if(Boolean(this._placardBtn))
         {
            ObjectUtils.disposeObject(this._placardBtn);
         }
         this._placardBtn = null;
         if(Boolean(this._eventBtn))
         {
            ObjectUtils.disposeObject(this._eventBtn);
         }
         this._eventBtn = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._placard))
         {
            ObjectUtils.disposeObject(this._placard);
         }
         this._placard = null;
         if(Boolean(this._editBtn))
         {
            ObjectUtils.disposeObject(this._editBtn);
         }
         this._editBtn = null;
         if(Boolean(this._cancelBtn))
         {
            ObjectUtils.disposeObject(this._cancelBtn);
         }
         this._cancelBtn = null;
         if(Boolean(this._vote))
         {
            ObjectUtils.disposeObject(this._vote);
         }
         this._vote = null;
         if(Boolean(this._eventPanel))
         {
            ObjectUtils.disposeObject(this._eventPanel);
         }
         this._eventPanel = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

