package collectionTask.view
{
   import collectionTask.CollectionTaskManager;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CollectionTaskExitMenuView extends Sprite implements Disposeable
   {
      
      private var _menuIsOpen:Boolean = true;
      
      private var _BG:Bitmap;
      
      private var _moveOutBtn:SimpleBitmapButton;
      
      private var _moveInBtn:SimpleBitmapButton;
      
      private var _returnBtn:SimpleBitmapButton;
      
      public function CollectionTaskExitMenuView()
      {
         super();
         this.x = 909;
         this.y = 541;
         this.initialize();
         this.setEvent();
         this.setInOutVisible(true);
      }
      
      private function initialize() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("collectionTask.menuBG");
         addChild(this._BG);
         this._moveOutBtn = ComponentFactory.Instance.creatComponentByStylename("collectionTask.views.moveOutBtn");
         this._moveInBtn = ComponentFactory.Instance.creatComponentByStylename("collectionTask.views.moveInBtn");
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("collectionTask.views.returnBtn");
         addChild(this._moveOutBtn);
         addChild(this._moveInBtn);
         addChild(this._returnBtn);
      }
      
      private function setEvent() : void
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
         var alert:BaseAlerFrame = null;
         SoundManager.instance.playButtonSound();
         if(!CollectionTaskManager.Instance.isTaskComplete)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("collectionTask.leaveScene"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__frameResponse);
         }
         else
         {
            SocketManager.Instance.out.sendLeaveCollectionScene();
            StateManager.setState(StateType.MAIN);
         }
      }
      
      private function __frameResponse(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse);
         switch(e.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.sendLeaveCollectionScene();
               StateManager.setState(StateType.MAIN);
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               alert.dispose();
         }
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
         this._BG = null;
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

