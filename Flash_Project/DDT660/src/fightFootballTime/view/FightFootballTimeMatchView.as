package fightFootballTime.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class FightFootballTimeMatchView extends Frame implements Disposeable
   {
      
      private const MAXMATCHTIME:int = 180;
      
      private var _bg:Bitmap;
      
      private var _btnbg:Bitmap;
      
      private var _timeTxt:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _matchingTxt:Bitmap;
      
      private var _startBtn:MovieClip;
      
      private var _cancelBtn:SimpleBitmapButton;
      
      private var _matchTxtBg:Bitmap;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _tipTxt:FilterFrameText;
      
      private var _descTxt:FilterFrameText;
      
      private var _descBg:Bitmap;
      
      public function FightFootballTimeMatchView()
      {
         super();
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("fightFootballTime.match.bg");
         this._btnbg = ComponentFactory.Instance.creatBitmap("fightFootballTime.match.btnBg");
         PositionUtils.setPos(this._btnbg,"fightFootballTime.match.bntBgPos");
         titleText = LanguageMgr.GetTranslation("fightFootballTime.title");
         this._startBtn = ClassUtils.CreatInstance("fightFootballTime.match.startMovie") as MovieClip;
         PositionUtils.setPos(this._startBtn,"fightFootballTime.match.startbtnPos");
         this._startBtn.buttonMode = true;
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.match.CancelButton");
         this._descBg = ComponentFactory.Instance.creatBitmap("fightFootballTime.match.descBg");
         this._matchTxtBg = ComponentFactory.Instance.creatBitmap("fightFootballTime.match.matchingTxtBg");
         this._matchTxtBg.visible = false;
         this._matchingTxt = ComponentFactory.Instance.creatBitmap("fightFootballTime.match.matchingTxt");
         this._matchingTxt.visible = false;
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.match.tipTxt");
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.match.descTxt");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.match.txtVBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.match.txtScrollPanel");
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.match.timeTxt");
         this._timeTxt.text = "00";
         this._timeTxt.visible = false;
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this.refreshShowTxt();
         addToContent(this._bg);
         addToContent(this._descBg);
         addToContent(this._scrollPanel);
         addToContent(this._matchTxtBg);
         addToContent(this._matchingTxt);
         addToContent(this._btnbg);
         addToContent(this._startBtn);
         addToContent(this._cancelBtn);
         addToContent(this._timeTxt);
      }
      
      private function refreshShowTxt() : void
      {
         this._tipTxt.text = LanguageMgr.GetTranslation("fightFootballTime.match.descTxt");
         var tmpStr:String = "";
         for(var i:int = 0; i < 5; i++)
         {
            tmpStr += LanguageMgr.GetTranslation("fightFootballTime.match.descTxt" + (i + 1)) + "\n";
         }
         this._descTxt.htmlText = tmpStr;
         this._vbox.addChild(this._tipTxt);
         this._vbox.addChild(this._descTxt);
         this._scrollPanel.setView(this._vbox);
      }
      
      private function __timer(evt:TimerEvent) : void
      {
         if(this._timer.currentCount >= this.MAXMATCHTIME)
         {
            this._timer.stop();
            this.dispose();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("fightFootballTime.noMatch"),0,false,1);
            return;
         }
         var sec:uint = this._timer.currentCount % this.MAXMATCHTIME;
         this._timeTxt.text = sec > 9 ? sec.toString() : "0" + sec;
      }
      
      private function __cancelClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._timer.stop();
         this._timer.reset();
         this._timeTxt.text = "00";
         this._timeTxt.visible = this._matchingTxt.visible = this._matchTxtBg.visible = this._cancelBtn.visible = this._cancelBtn.enable = false;
         this._startBtn.visible = true;
         this._descBg.visible = true;
         this._scrollPanel.visible = true;
         GameInSocketOut.sendCancelWait();
      }
      
      private function initEvent() : void
      {
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__toStartMatch);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelClick);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__onStartLoad);
      }
      
      protected function __onStartLoad(event:Event) : void
      {
         var roomInfo:RoomInfo = RoomManager.Instance.current;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         this.dispose();
         StateManager.setState(StateType.FIGHTFOOTBALLTIME,GameManager.Instance.Current);
      }
      
      private function __toStartMatch(evt:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) != null)
         {
            SoundManager.instance.play("008");
            this._timeTxt.visible = this._matchingTxt.visible = this._matchTxtBg.visible = this._cancelBtn.visible = this._cancelBtn.enable = true;
            this._startBtn.visible = false;
            this._descBg.visible = false;
            this._scrollPanel.visible = false;
            this._timer.start();
         }
         GameInSocketOut.sendSingleRoomBegin(RoomManager.FIGHTFOOTBALLTIME_ROOM);
      }
      
      private function removeEvent() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__toStartMatch);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelClick);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__onStartLoad);
      }
      
      private function disposeView() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._btnbg))
         {
            ObjectUtils.disposeObject(this._btnbg);
         }
         this._btnbg = null;
         if(Boolean(this._descBg))
         {
            ObjectUtils.disposeObject(this._descBg);
         }
         this._descBg = null;
         if(Boolean(this._scrollPanel))
         {
            ObjectUtils.disposeObject(this._scrollPanel);
         }
         this._scrollPanel = null;
         if(Boolean(this._startBtn))
         {
            ObjectUtils.disposeObject(this._startBtn);
         }
         this._startBtn = null;
         if(Boolean(this._cancelBtn))
         {
            ObjectUtils.disposeObject(this._cancelBtn);
         }
         this._cancelBtn = null;
         if(Boolean(this._matchTxtBg))
         {
            ObjectUtils.disposeObject(this._matchTxtBg);
         }
         this._matchTxtBg = null;
         if(Boolean(this._matchingTxt))
         {
            ObjectUtils.disposeObject(this._matchingTxt);
         }
         this._matchingTxt = null;
         if(Boolean(this._timeTxt))
         {
            ObjectUtils.disposeObject(this._timeTxt);
         }
         this._timeTxt = null;
         this._timer = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.disposeView();
      }
   }
}

