package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   import worldboss.event.WorldBossRoomEvent;
   
   public class WorldBossHideBtn extends Sprite implements Disposeable
   {
      
      private var _btn:SimpleBitmapButton;
      
      private var _isOverTip:Boolean = false;
      
      private var _isOverBtn:Boolean = false;
      
      private var _isShow:Boolean = false;
      
      public function WorldBossHideBtn()
      {
         super();
         this.x = 909;
         this.y = 16;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("worldBoss.hideBtn.btn");
         this.refreshBtnStatus();
         addChild(this._btn);
      }
      
      private function refreshBtnStatus() : void
      {
         if(!this._btn)
         {
            return;
         }
         if(this._isShow)
         {
            (this._btn.backgound as MovieClip)["mc"].gotoAndStop(2);
         }
         else
         {
            (this._btn.backgound as MovieClip)["mc"].gotoAndStop(1);
         }
      }
      
      private function selectedChangeHandler(event:Event) : void
      {
         this.refreshBtnStatus();
      }
      
      private function initEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._isShow = !this._isShow;
         this.refreshBtnStatus();
         WorldBossManager.Instance.dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.HIDE_PLAYER_CHANGE,this._isShow));
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._btn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

