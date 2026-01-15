package game.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.events.SharedEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import game.GameManager;
   import room.RoomManager;
   
   public class GameTrusteeshipView extends Sprite implements Disposeable
   {
      
      private var _trusteeshipBtn:SelectedButton;
      
      private var _trusteeshipMovie:MovieClip;
      
      private var _cancelText:TextField;
      
      private var _trusteeshipState:Boolean;
      
      public function GameTrusteeshipView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._trusteeshipBtn = UICreatShortcut.creatAndAdd("game.view.GameTrusteeshipView.trusteeshipBtn",this);
         this._trusteeshipBtn.tipData = LanguageMgr.GetTranslation("game.view.GameTrusteeshipView.tipsData");
         this._trusteeshipMovie = UICreatShortcut.creatAndAdd("game.view.TrusteeshipMC",this);
         this._cancelText = new TextField();
         this._cancelText.setTextFormat(ComponentFactory.Instance.model.getSet("game.view.GameTrusteeshipView.cancelText.tf"));
         this._cancelText.filters = [ComponentFactory.Instance.model.getSet("game.view.GameTrusteeshipView.cancelText.gf")];
         this._cancelText.x = 54;
         this._cancelText.y = 5;
         this._cancelText.htmlText = LanguageMgr.GetTranslation("game.view.GameTrusteeshipView.cancelTxt");
         addChild(this._cancelText);
         this.trusteeshipState = false;
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            visible = false;
         }
      }
      
      private function initEvent() : void
      {
         this._trusteeshipBtn.addEventListener(MouseEvent.CLICK,this.__onTrusteeshipBtnClick);
         this._cancelText.addEventListener(TextEvent.LINK,this.__onTrusteeshipBtnClick);
         SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.DIE,this.__die);
         PlayerManager.Instance.Self.addEventListener(GameEvent.TRUSTEESHIP_CHANGE,this.__trusteeshipChange);
      }
      
      private function removeEvent() : void
      {
         this._trusteeshipBtn.removeEventListener(MouseEvent.CLICK,this.__onTrusteeshipBtnClick);
         this._cancelText.removeEventListener(TextEvent.LINK,this.__onTrusteeshipBtnClick);
         SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.DIE,this.__die);
         PlayerManager.Instance.Self.removeEventListener(GameEvent.TRUSTEESHIP_CHANGE,this.__trusteeshipChange);
      }
      
      protected function __die(event:Event) : void
      {
         visible = false;
         this.trusteeshipState = false;
         SocketManager.Instance.out.sendGameTrusteeship(false);
      }
      
      protected function __transparentChanged(event:Event) : void
      {
         if(Boolean(parent))
         {
            if(SharedManager.Instance.propTransparent)
            {
               this._trusteeshipBtn.alpha = 0.5;
            }
            else
            {
               this._trusteeshipBtn.alpha = 1;
            }
         }
      }
      
      protected function __onTrusteeshipBtnClick(event:Event) : void
      {
         SoundManager.instance.playButtonSound();
         this.trusteeshipState = !this.trusteeshipState;
         this._trusteeshipBtn.selected = this.trusteeshipState;
         SocketManager.Instance.out.sendGameTrusteeship(this.trusteeshipState);
      }
      
      public function set trusteeshipState(value:Boolean) : void
      {
         this._trusteeshipState = value;
         this.update();
      }
      
      public function get trusteeshipState() : Boolean
      {
         return this._trusteeshipState;
      }
      
      private function update() : void
      {
         if(Boolean(this._trusteeshipMovie))
         {
            this._trusteeshipMovie.visible = this._trusteeshipState;
         }
         if(Boolean(this._cancelText))
         {
            this._cancelText.visible = this._trusteeshipState;
         }
      }
      
      private function __trusteeshipChange(event:GameEvent) : void
      {
         var flag:Boolean = event.data as Boolean;
         if(flag)
         {
            this.trusteeshipState = true;
            if(Boolean(this._trusteeshipBtn))
            {
               this._trusteeshipBtn.selected = true;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._trusteeshipBtn);
         this._trusteeshipBtn = null;
         ObjectUtils.disposeObject(this._trusteeshipMovie);
         this._trusteeshipMovie = null;
         ObjectUtils.disposeObject(this._cancelText);
         this._cancelText = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

