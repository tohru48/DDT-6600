package game.view.tool
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.RightChatFacePanel;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import game.GameManager;
   import im.IMController;
   import org.aswing.KeyboardManager;
   import setting.controll.SettingController;
   import trainer.view.GhostTipFrame;
   
   public class ToolStripView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _faceBtn:SimpleBitmapButton;
      
      private var _fastMovie:MovieClip;
      
      private var _fastChatBtn:SimpleBitmapButton;
      
      private var _bloodStrip:BloodStrip;
      
      private var _powerStrip:PowerStrip;
      
      private var _facePanelPos:Point;
      
      private var _center:Bitmap;
      
      private var _transparentBtn:BaseButton;
      
      private var _startDate:Date;
      
      private var _facePanel:RightChatFacePanel;
      
      private var _danderBar:DanderBar;
      
      private var _frame:int;
      
      public function ToolStripView()
      {
         super();
         this.initView();
         this.initEvents();
         this._startDate = TimeManager.Instance.Now();
      }
      
      private function initView() : void
      {
         var powerStripPos:Point = null;
         mouseEnabled = false;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.health.back");
         addChild(this._bg);
         this._bloodStrip = new BloodStrip();
         var bloodStripPos:Point = ComponentFactory.Instance.creatCustomObject("asset.game.bloodStripPos");
         this._bloodStrip.x = bloodStripPos.x;
         this._bloodStrip.y = bloodStripPos.y;
         addChild(this._bloodStrip);
         this._danderBar = new DanderBar(GameManager.Instance.Current.selfGamePlayer,this);
         this._danderBar.x = 120;
         this._danderBar.y = 1;
         addChild(this._danderBar);
         this._faceBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.faceButton");
         this.setTip(this._faceBtn,LanguageMgr.GetTranslation("tank.game.ToolStripView.face"));
         addChild(this._faceBtn);
         this._fastChatBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.chatButton");
         this.setTip(this._fastChatBtn,LanguageMgr.GetTranslation("tank.game.ToolStripView.chat"));
         addChild(this._fastChatBtn);
         this._fastMovie = ClassUtils.CreatInstance("asset.game.prop.chatMoive") as MovieClip;
         PositionUtils.setPos(this._fastMovie,"asset.game.chatmoviePos");
         this._fastChatBtn.addChild(this._fastMovie);
         if(IMController.Instance.hasUnreadMessage() && !IMController.Instance.cancelflashState)
         {
            this._fastMovie.gotoAndPlay(1);
         }
         else
         {
            this._fastMovie.gotoAndStop(this._fastMovie.totalFrames);
         }
         this._facePanel = ComponentFactory.Instance.creatCustomObject("chat.rightFacePanel",[true]);
         this._facePanelPos = ComponentFactory.Instance.creatCustomObject("asset.game.facePanelView");
         this._powerStrip = new PowerStrip();
         powerStripPos = ComponentFactory.Instance.creatCustomObject("asset.game.powerStripPos");
         this._powerStrip.x = powerStripPos.x;
         this._powerStrip.y = powerStripPos.y;
         addChild(this._powerStrip);
         this._transparentBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.TransparentButton");
         this.setTip(this._transparentBtn,LanguageMgr.GetTranslation("tank.game.ToolStripView.transparent"));
         addChild(this._transparentBtn);
      }
      
      private function setTip(btn:BaseButton, data:String) : void
      {
         btn.tipStyle = "ddt.view.tips.OneLineTip";
         btn.tipDirctions = "0";
         btn.tipGapV = 5;
         btn.tipData = data;
      }
      
      private function initEvents() : void
      {
         this._faceBtn.addEventListener(MouseEvent.CLICK,this.__face);
         this._fastChatBtn.addEventListener(MouseEvent.CLICK,this.__fastChat);
         this._fastChatBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._fastChatBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._facePanel.addEventListener(Event.SELECT,this.__onFaceSelect);
         this._transparentBtn.addEventListener(MouseEvent.CLICK,this.__transparentChanged);
         IMController.Instance.addEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewHandler);
         IMController.Instance.addEventListener(IMController.NO_MESSAGE,this.__noMessageHandler);
      }
      
      protected function __noMessageHandler(event:Event) : void
      {
         this._fastMovie.gotoAndStop(this._fastMovie.totalFrames);
      }
      
      protected function __hasNewHandler(event:Event) : void
      {
         this._fastMovie.gotoAndPlay(1);
      }
      
      protected function __overHandler(event:MouseEvent) : void
      {
         if(KeyboardManager.isDown(Keyboard.SPACE))
         {
            return;
         }
         IMController.Instance.showMessageBox(this._faceBtn);
      }
      
      protected function __outHandler(event:MouseEvent) : void
      {
         IMController.Instance.hideMessageBox();
      }
      
      protected function __transparentChanged(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.propTransparent = !SharedManager.Instance.propTransparent;
      }
      
      private function removeEvents() : void
      {
         this._fastChatBtn.removeEventListener(MouseEvent.CLICK,this.__fastChat);
         this._fastChatBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._fastChatBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._facePanel.removeEventListener(Event.SELECT,this.__onFaceSelect);
         this._transparentBtn.removeEventListener(MouseEvent.CLICK,this.__transparentChanged);
         IMController.Instance.removeEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewHandler);
         IMController.Instance.removeEventListener(IMController.NO_MESSAGE,this.__noMessageHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._facePanel.dispose();
         this._facePanel = null;
         if(Boolean(this._bloodStrip))
         {
            if(Boolean(this._bloodStrip.parent))
            {
               this._bloodStrip.parent.removeChild(this._bloodStrip);
            }
            this._bloodStrip.dispose();
         }
         this._bloodStrip = null;
         if(Boolean(this._powerStrip))
         {
            if(Boolean(this._powerStrip.parent))
            {
               this._powerStrip.parent.removeChild(this._powerStrip);
            }
            this._powerStrip.dispose();
         }
         this._powerStrip = null;
         if(Boolean(this._faceBtn))
         {
            if(Boolean(this._faceBtn.parent))
            {
               this._faceBtn.parent.removeChild(this._faceBtn);
            }
            this._faceBtn.dispose();
         }
         if(Boolean(this._fastMovie))
         {
            ObjectUtils.disposeObject(this._fastMovie);
            this._fastMovie = null;
         }
         this._faceBtn = null;
         if(Boolean(this._fastChatBtn))
         {
            if(Boolean(this._fastChatBtn.parent))
            {
               this._fastChatBtn.parent.removeChild(this._fastChatBtn);
            }
            this._fastChatBtn.dispose();
         }
         this._fastChatBtn = null;
         ObjectUtils.disposeObject(this._danderBar);
         this._danderBar = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __fastChat(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         ChatManager.Instance.switchVisible();
      }
      
      private function __setBtn(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SettingController.Instance.switchVisible();
      }
      
      private function __face(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._facePanel.x = localToGlobal(new Point(this._facePanelPos.x,this._facePanelPos.y)).x;
         this._facePanel.y = localToGlobal(new Point(this._facePanelPos.x,this._facePanelPos.y)).y;
         this._facePanel.setVisible = true;
      }
      
      private function __onFaceSelect(event:Event) : void
      {
         ChatManager.Instance.sendFace(this._facePanel.selected);
         this._facePanel.setVisible = false;
         StageReferance.stage.focus = null;
      }
      
      private function __im(event:MouseEvent) : void
      {
         IMController.Instance.switchVisible();
         SoundManager.instance.play("008");
      }
      
      private function updateDander(dander:int) : void
      {
      }
      
      private function __dander(event:LivingEvent) : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            this.updateDander(GameManager.Instance.Current.selfGamePlayer.dander);
         }
      }
      
      private function __ok() : void
      {
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            mouseChildren = false;
            GameInSocketOut.sendGamePlayerExit();
            SoundManager.instance.play("008");
         }
      }
      
      private function __cancel() : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __die(event:LivingEvent) : void
      {
         this.updateDander(0);
         this.showDeadTip();
      }
      
      private function showDeadTip() : void
      {
         var alert:GhostTipFrame = null;
         if(GameManager.Instance.Current.selfGamePlayer.playerInfo.Grade >= 10)
         {
            return;
         }
         if(!GameManager.Instance.Current.haveAllias)
         {
            return;
         }
         if(SharedManager.Instance.deadtip < 2)
         {
            ++SharedManager.Instance.deadtip;
            alert = ComponentFactory.Instance.creat("GhostTip");
            LayerManager.Instance.addToLayer(alert,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function set specialEnabled(value:Boolean) : void
      {
         this._danderBar.specialEnabled = value;
      }
      
      public function setDanderEnable(e:Boolean) : void
      {
         this._danderBar.setVisible(e);
      }
   }
}

