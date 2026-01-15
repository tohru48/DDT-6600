package ddtBuried.items
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddtBuried.BuriedManager;
   import ddtBuried.views.BuriedView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import magpieBridge.view.MagPieBridgeView;
   
   public class BuriedReturnBtn extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _moveOutBtn:SimpleBitmapButton;
      
      private var _moveInBtn:SimpleBitmapButton;
      
      private var _returnBtn:SimpleBitmapButton;
      
      private var _isDice:Boolean;
      
      public function BuriedReturnBtn()
      {
         super();
         this.x = 909;
         this.y = 541;
         this.initView();
         this.initEvent();
         this.setInOutVisible(true);
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("buried.returnBtn.bg");
         this._moveOutBtn = ComponentFactory.Instance.creatComponentByStylename("buried.views.moveOutBtn");
         this._moveInBtn = ComponentFactory.Instance.creatComponentByStylename("buried.views.moveInBtn");
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("buried.views.returnBtn");
         addChild(this._bg);
         addChild(this._moveOutBtn);
         addChild(this._moveInBtn);
         addChild(this._returnBtn);
      }
      
      private function initEvent() : void
      {
         this._moveOutBtn.addEventListener(MouseEvent.CLICK,this.outHandler,false,0,true);
         this._moveInBtn.addEventListener(MouseEvent.CLICK,this.inHandler,false,0,true);
         this._returnBtn.addEventListener(MouseEvent.CLICK,this.exitHandler,false,0,true);
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(false);
         TweenLite.to(this,0.5,{"x":966});
      }
      
      private function setInOutVisible(isOut:Boolean) : void
      {
         this._moveOutBtn.visible = isOut;
         this._moveInBtn.visible = !isOut;
      }
      
      private function inHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(true);
         TweenLite.to(this,0.5,{"x":909});
      }
      
      private function exitHandler(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(parent is BuriedView)
         {
            BuriedView(parent).dispose();
         }
         else if(parent is MagPieBridgeView)
         {
            SocketManager.Instance.out.exitMagpieView();
            StateManager.setState(StateType.MAIN);
         }
         else
         {
            BuriedManager.Instance.dispose();
            SocketManager.Instance.out.outCard();
         }
      }
      
      public function setBtnEnable(flag:Boolean) : void
      {
         this.mouseEnabled = flag;
         this.mouseChildren = flag;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._moveOutBtn))
         {
            this._moveOutBtn.removeEventListener(MouseEvent.CLICK,this.outHandler);
         }
         if(Boolean(this._moveInBtn))
         {
            this._moveInBtn.removeEventListener(MouseEvent.CLICK,this.inHandler);
         }
         if(Boolean(this._returnBtn))
         {
            this._returnBtn.removeEventListener(MouseEvent.CLICK,this.exitHandler);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._moveOutBtn = null;
         this._moveInBtn = null;
         this._returnBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

