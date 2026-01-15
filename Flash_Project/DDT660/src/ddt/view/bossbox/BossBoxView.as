package ddt.view.bossbox
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.BossBoxManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class BossBoxView extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _downBox:MovieImage;
      
      private var _templateIds:Array;
      
      public var boxType:int = 0;
      
      public var boxID:int;
      
      private var _time:Timer;
      
      private var awards:AwardsView;
      
      private var _fightLibType:int;
      
      private var _fightLibLevel:int;
      
      private var _mission:int;
      
      private var _alertTitle:FilterFrameText;
      
      private var _frame:BaseAlerFrame;
      
      private var _winTime:uint;
      
      public function BossBoxView(t:int, id:int, itemArr:Array, fightLibType:int = -1, fightLibLevel:int = -1)
      {
         super();
         buttonMode = true;
         this._templateIds = itemArr;
         this.boxType = t;
         this.boxID = id;
         this._fightLibType = fightLibType;
         this._fightLibLevel = fightLibLevel;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("bossbox.TimeBoxBG");
         this._downBox = ComponentFactory.Instance.creat("bossbox.downBox");
         addChild(this._bg);
         addChild(this._downBox);
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("1001");
         this._winTime = setTimeout(this.startMusic,3000);
      }
      
      private function startMusic() : void
      {
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("1001");
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this._boxClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this._boxClick);
      }
      
      private function _boxClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._downBox.movie.gotoAndPlay("openBox");
         this.removeEvent();
         this._time = new Timer(500,1);
         this._time.start();
         this._time.addEventListener(TimerEvent.TIMER_COMPLETE,this._time_complete);
      }
      
      private function _time_complete(e:TimerEvent) : void
      {
         var ai:AlertInfo = null;
         if(this.boxType == BossBoxManager.FightLibAwardBox)
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("bossbox.AwardsFrame");
            this.awards = new AwardsView();
            this.awards.boxType = this.boxType;
            this.awards.goodsList = this._templateIds;
            this._frame.addToContent(this.awards);
            this._alertTitle = ComponentFactory.Instance.creatComponentByStylename("bossbox.alert.alertTextStyle");
            this._alertTitle.text = LanguageMgr.GetTranslation("tank.timeBox.awardsTitle");
            this._frame.addToContent(this._alertTitle);
            ai = new AlertInfo();
            ai.title = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
            ai.showCancel = false;
            ai.moveEnable = false;
            ai.submitLabel = LanguageMgr.GetTranslation("tank.timeBox.awardsBtn");
            this._frame.info = ai;
            this._frame.submitButtonStyle = "bossbox.getAwardBtn";
            this._frame.addEventListener(FrameEvent.RESPONSE,this._close);
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            this.awards = ComponentFactory.Instance.creat("bossbox.AwardsViewAsset");
            this.awards.closeButton.visible = false;
            this.awards.escEnable = false;
            this.awards.boxType = this.boxType;
            this.awards.goodsList = this._templateIds;
            this.awards.addEventListener(AwardsView.HAVEBTNCLICK,this._close);
            LayerManager.Instance.addToLayer(this.awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         removeChild(this._downBox);
         removeChild(this._bg);
         this._downBox = null;
         this._bg = null;
         this._time.removeEventListener(TimerEvent.TIMER_COMPLETE,this._time_complete);
         this._time.stop();
         this._time = null;
      }
      
      private function _close(e:Event) : void
      {
         switch(this.boxType)
         {
            case 0:
               SocketManager.Instance.out.sendGetTimeBox(1,this.boxType);
               break;
            case 1:
               SocketManager.Instance.out.sendGetTimeBox(1,this.boxType);
               BossBoxManager.instance.showOtherGradeBox();
               break;
            case BossBoxManager.FightLibAwardBox:
               this._frame.removeEventListener(AwardsView.HAVEBTNCLICK,this._close);
               this._frame.dispose();
               SocketManager.Instance.out.sendGetTimeBox(2,-1,this._fightLibType,this._fightLibLevel);
               FightLibManager.Instance.gainAward(FightLibManager.Instance.lastInfo);
               break;
            case BossBoxManager.SignAward:
         }
         this.dispose();
      }
      
      public function dispose() : void
      {
         SoundManager.instance.resumeMusic();
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._downBox))
         {
            ObjectUtils.disposeObject(this._downBox);
         }
         this._downBox = null;
         clearTimeout(this._winTime);
         if(Boolean(this._time))
         {
            this._time.removeEventListener(TimerEvent.TIMER_COMPLETE,this._time_complete);
            this._time.stop();
         }
         this._time = null;
         if(Boolean(this._alertTitle))
         {
            ObjectUtils.disposeObject(this._alertTitle);
         }
         this._alertTitle = null;
         if(Boolean(this._frame))
         {
            this._frame.removeEventListener(AwardsView.HAVEBTNCLICK,this._close);
            ObjectUtils.disposeObject(this._frame);
         }
         this._frame = null;
         if(Boolean(this.awards))
         {
            this.awards.removeEventListener(AwardsView.HAVEBTNCLICK,this._close);
            ObjectUtils.disposeObject(this.awards);
         }
         this.awards = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

