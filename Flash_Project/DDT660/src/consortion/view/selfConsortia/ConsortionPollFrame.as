package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionPollInfo;
   import consortion.event.ConsortionEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class ConsortionPollFrame extends Frame
   {
      
      private var _bg:MutipleImage;
      
      private var _name:FilterFrameText;
      
      private var _ticketCount:FilterFrameText;
      
      private var _vote:BaseButton;
      
      private var _help:BaseButton;
      
      private var _mark:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _items:Vector.<ConsortionPollItem>;
      
      private var _currentItem:ConsortionPollItem;
      
      private var _helpFrame:Frame;
      
      private var _helpContentBG:Scale9CornerImage;
      
      private var _helpContent:MovieImage;
      
      private var _helpClose:TextButton;
      
      public function ConsortionPollFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortion.pollFrame.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.bg");
         this._name = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.name");
         this._name.text = LanguageMgr.GetTranslation("tank.consortion.pollFrame.name.text");
         this._ticketCount = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.ticketCount");
         this._ticketCount.text = LanguageMgr.GetTranslation("tank.consortion.pollFrame.ticketCount.text");
         this._vote = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.vote");
         this._help = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.help");
         this._mark = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.mark");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.vbox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.panel");
         addToContent(this._bg);
         addToContent(this._name);
         addToContent(this._ticketCount);
         addToContent(this._vote);
         addToContent(this._help);
         addToContent(this._mark);
         addToContent(this._panel);
         this._panel.setView(this._vbox);
         this.dataList = ConsortionModelControl.Instance.model.pollList;
         this._mark.text = LanguageMgr.GetTranslation("ddt.consortion.pollFrame.continueDay",PlayerManager.Instance.Self.consortiaInfo.VoteRemainDay);
         if(PlayerManager.Instance.Self.Riches < 100 || ConsortionModelControl.Instance.model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).IsVote)
         {
            this._vote.enable = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._vote.addEventListener(MouseEvent.CLICK,this.__voteHandler);
         this._help.addEventListener(MouseEvent.CLICK,this.__helpHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.POLL_LIST_CHANGE,this.__pollListChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.POLL_CANDIDATE,this.__consortiaPollHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._vote.removeEventListener(MouseEvent.CLICK,this.__voteHandler);
         this._help.removeEventListener(MouseEvent.CLICK,this.__helpHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.POLL_LIST_CHANGE,this.__pollListChange);
         for(var i:int = 0; i < this._items.length; i++)
         {
            this._items[i].removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.POLL_CANDIDATE,this.__consortiaPollHandler);
      }
      
      private function __consortiaPollHandler(evt:CrazyTankSocketEvent) : void
      {
         var isSuccess:Boolean = evt.pkg.readBoolean();
         if(isSuccess)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.pollFrame.success"));
            ConsortionModelControl.Instance.model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).IsVote = true;
            this.dispose();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.pollFrame.fail"));
            this._vote.enable = true;
         }
      }
      
      private function __pollListChange(event:ConsortionEvent) : void
      {
         this.dataList = ConsortionModelControl.Instance.model.pollList;
      }
      
      private function clearList() : void
      {
         var i:int = 0;
         if(Boolean(this._items))
         {
            for(i = 0; i < this._items.length; i++)
            {
               this._items[i].removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
               this._items[i].dispose();
               this._items[i] = null;
            }
         }
         this._items = new Vector.<ConsortionPollItem>();
      }
      
      private function set dataList(value:Vector.<ConsortionPollInfo>) : void
      {
         var item:ConsortionPollItem = null;
         this.clearList();
         if(value == null)
         {
            return;
         }
         for(var i:int = 0; i < value.length; i++)
         {
            item = new ConsortionPollItem(i);
            item.addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            item.info = value[i];
            this._items.push(item);
            this._vbox.addChild(item);
         }
         this._panel.invalidateViewport();
      }
      
      private function __itemClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentItem = event.currentTarget as ConsortionPollItem;
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(this._currentItem == this._items[i])
            {
               this._items[i].selected = true;
            }
            else
            {
               this._items[i].selected = false;
            }
         }
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __voteHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currentItem == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.pollFrame.pleaseSelceted"));
            return;
         }
         if(ConsortionModelControl.Instance.model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).IsVote)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.pollFrame.double"));
            return;
         }
         SocketManager.Instance.out.sendConsortionPoll(this._currentItem.info.pollID);
         this._vote.enable = false;
      }
      
      private function __helpHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.helpFrame");
         this._helpContentBG = ComponentFactory.Instance.creatComponentByStylename("consortion.consortion.pollFrame.helpFrame.bg");
         this._helpContent = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.explain");
         this._helpClose = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.helpFrame.close");
         this._helpFrame.addToContent(this._helpContentBG);
         this._helpFrame.addToContent(this._helpContent);
         this._helpFrame.addToContent(this._helpClose);
         this._helpFrame.escEnable = true;
         this._helpFrame.disposeChildren = true;
         this._helpFrame.titleText = LanguageMgr.GetTranslation("ddt.consortion.pollFrame.helpFrame.title");
         this._helpClose.text = LanguageMgr.GetTranslation("close");
         this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpResoponseHandler);
         this._helpClose.addEventListener(MouseEvent.CLICK,this.__closeHelpHandler);
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __helpResoponseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.helpDispose();
         }
      }
      
      private function __closeHelpHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.helpDispose();
      }
      
      private function helpDispose() : void
      {
         this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpResoponseHandler);
         this._helpClose.removeEventListener(MouseEvent.CLICK,this.__closeHelpHandler);
         this._helpFrame.dispose();
         this._helpContent = null;
         this._helpClose = null;
         if(Boolean(this._helpFrame.parent))
         {
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         super.dispose();
         this._bg = null;
         this._name = null;
         this._ticketCount = null;
         this._vote = null;
         this._help = null;
         this._mark = null;
         this._vbox = null;
         this._panel = null;
         this._items = null;
         this._currentItem = null;
         this._helpContentBG = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

