package changeColor.view
{
   import changeColor.ChangeColorCellEvent;
   import changeColor.ChangeColorController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.geom.Rectangle;
   
   public class ChangeColorFrame extends Frame
   {
      
      private var _changeColorLeftView:ChangeColorLeftView;
      
      private var _changeColorRightView:ChangeColorRightView;
      
      public function ChangeColorFrame()
      {
         super();
      }
      
      override public function dispose() : void
      {
         this.remvoeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._changeColorLeftView = null;
         this._changeColorRightView = null;
         ChangeColorController.instance.changeColorModel.clear();
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._changeColorLeftView.model = ChangeColorController.instance.changeColorModel;
         this._changeColorRightView.model = ChangeColorController.instance.changeColorModel;
      }
      
      override protected function init() : void
      {
         var rec:Rectangle = null;
         super.init();
         this._changeColorLeftView = new ChangeColorLeftView();
         addToContent(this._changeColorLeftView);
         this._changeColorRightView = new ChangeColorRightView();
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.rightViewRec");
         ObjectUtils.copyPropertyByRectangle(this._changeColorRightView,rec);
         addToContent(this._changeColorRightView);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._changeColorRightView.addEventListener(ChangeColorCellEvent.CLICK,this.__cellClickHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_CARD,this.__useCardHandler);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               ChangeColorController.instance.close();
         }
      }
      
      private function __cellClickHandler(evt:ChangeColorCellEvent) : void
      {
         if(Boolean(evt.data))
         {
            this._changeColorLeftView.setCurrentItem(evt.data);
         }
      }
      
      private function __useCardHandler(evt:CrazyTankSocketEvent) : void
      {
         var state:Boolean = evt.pkg.readBoolean();
         if(state)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.success"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.failed"));
         }
      }
      
      public function setFirstItemSelected() : void
      {
         this._changeColorLeftView.setCurrentItem(this._changeColorRightView.bag.cells[0]);
      }
   }
}

