package worldBossHelper.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import labyrinth.LabyrinthManager;
   import store.HelpFrame;
   import worldBossHelper.WorldBossHelperManager;
   import worldBossHelper.data.WorldBossHelperTypeData;
   import worldBossHelper.event.WorldBossHelperEvent;
   
   public class WorldBossHelperFrame extends Frame
   {
      
      private var _leftView:WorldBossHelperLeftView;
      
      private var _rightView:WorldBossHelperRightView;
      
      private var _chatBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _data:WorldBossHelperTypeData;
      
      private var _helperState:Boolean;
      
      public function WorldBossHelperFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function addPlayerInfo(isFightOver:Boolean, num:int, hurtArr:Array, honor:int) : void
      {
         this._leftView.addDescription(isFightOver,num,hurtArr,honor);
      }
      
      public function updateView() : void
      {
         this._leftView.changeState();
         this._rightView.setState();
      }
      
      private function initView() : void
      {
         this._leftView = new WorldBossHelperLeftView();
         this._leftView.buyAddMoney = this.getBuyAddMoney;
         addToContent(this._leftView);
         this._rightView = new WorldBossHelperRightView();
         addToContent(this._rightView);
         this.updateView();
         this._chatBtn = ComponentFactory.Instance.creatComponentByStylename("worldbosshelper.chatButton");
         this._chatBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.chat");
         addToContent(this._chatBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("worldbosshelper.helpBtn");
         addToContent(this._helpBtn);
         WorldBossHelperManager.Instance.isInWorldBossHelperFrame = true;
      }
      
      private function initEvent() : void
      {
         this._chatBtn.addEventListener(MouseEvent.CLICK,this.__chatClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpClick);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._leftView.addEventListener(WorldBossHelperEvent.CHANGE_HELPER_STATE,this.__changeStateHandler);
      }
      
      private function __helpClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var movie:MovieClip = ComponentFactory.Instance.creatCustomObject("worldbosshelper.helpBg");
         var frame:HelpFrame = ComponentFactory.Instance.creat("worldBossHelper.HelpFrame");
         frame.setView(movie);
         frame.titleText = LanguageMgr.GetTranslation("tank.view.emailII.ReadingView.useHelp");
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      protected function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var frame:Disposeable = event.target as Disposeable;
         frame.dispose();
         frame = null;
      }
      
      private function __chatClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LabyrinthManager.Instance.chat();
      }
      
      public function startFight() : void
      {
         this._leftView.startFight();
      }
      
      protected function __changeStateHandler(event:WorldBossHelperEvent) : void
      {
         this._data = this._rightView.typeData;
         this._data.requestType = 2;
         this._data.isOpen = event.state;
         SocketManager.Instance.out.openOrCloseWorldBossHelper(this._data);
      }
      
      public function getBuyAddMoney() : int
      {
         var dataObj:WorldBossHelperTypeData = this._rightView.typeData;
         if(dataObj.type == 1)
         {
            return 10;
         }
         if(dataObj.type == 2)
         {
            return 12;
         }
         return 0;
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         var alertAsk:BaseAlerFrame = null;
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            if(!WorldBossHelperManager.Instance.isFighting)
            {
               WorldBossHelperManager.Instance.dispose();
            }
            else
            {
               alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("worldboss.helper.closehelper"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertCloseHelper);
            }
         }
      }
      
      private function __alertCloseHelper(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               WorldBossHelperManager.Instance.helperOpen = false;
               WorldBossHelperManager.Instance.dispose();
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertCloseHelper);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function removeEvent() : void
      {
         this._chatBtn.removeEventListener(MouseEvent.CLICK,this.__chatClick);
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._leftView.removeEventListener(WorldBossHelperEvent.CHANGE_HELPER_STATE,this.__changeStateHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._leftView = null;
         this._rightView = null;
         this._chatBtn = null;
      }
   }
}

