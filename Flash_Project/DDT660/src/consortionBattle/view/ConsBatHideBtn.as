package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ConsBatHideBtn extends Sprite implements Disposeable
   {
      
      private var _btn:SimpleBitmapButton;
      
      private var _tip:ConsBatHideTip;
      
      private var _isOverTip:Boolean = false;
      
      private var _isOverBtn:Boolean = false;
      
      public function ConsBatHideBtn()
      {
         super();
         this.x = 782;
         this.y = 16;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.hideBtn.btn");
         this.refreshBtnStatus();
         this._tip = new ConsBatHideTip();
         PositionUtils.setPos(this._tip,"consortiaBattle.hideTipPos");
         addChild(this._btn);
      }
      
      private function refreshBtnStatus() : void
      {
         if(!this._btn)
         {
            return;
         }
         if(!ConsortiaBattleManager.instance.isHide(1) && !ConsortiaBattleManager.instance.isHide(2) && !ConsortiaBattleManager.instance.isHide(3))
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
         this._btn.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this._btn.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._tip.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this._tip.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
         this._tip.addEventListener(ConsBatHideTip.SELECTED_CHANGE,this.selectedChangeHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ConsortiaBattleManager.instance.isHide(1) && ConsortiaBattleManager.instance.isHide(2) && ConsortiaBattleManager.instance.isHide(3))
         {
            this._tip.showAll();
         }
         else
         {
            this._tip.hideAll();
         }
         this.refreshBtnStatus();
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         if(event.currentTarget == this._tip)
         {
            this._isOverTip = true;
         }
         if(event.currentTarget == this._btn)
         {
            this._isOverBtn = true;
         }
         if(!contains(this._tip))
         {
            addChild(this._tip);
         }
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         if(event.currentTarget == this._tip)
         {
            this._isOverTip = false;
         }
         if(event.currentTarget == this._btn)
         {
            this._isOverBtn = false;
         }
         setTimeout(this.delayRemoveTip,100);
      }
      
      private function delayRemoveTip() : void
      {
         if(contains(this._tip) && !this._isOverTip && !this._isOverBtn)
         {
            removeChild(this._tip);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this._btn.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         if(Boolean(this._tip))
         {
            this._tip.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this._tip.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
            this._tip.removeEventListener(ConsBatHideTip.SELECTED_CHANGE,this.selectedChangeHandler);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._btn = null;
         this._tip = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

