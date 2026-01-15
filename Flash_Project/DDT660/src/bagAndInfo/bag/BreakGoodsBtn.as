package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import ddt.interfaces.ICell;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class BreakGoodsBtn extends TextButton implements IDragable
   {
      
      private var _dragTarget:BagCell;
      
      private var _enabel:Boolean;
      
      private var win:BreakGoodsView;
      
      private var myColorMatrix_filter:ColorMatrixFilter;
      
      private var lightingFilter:ColorMatrixFilter;
      
      public function BreakGoodsBtn()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         buttonMode = true;
         this.initEvent();
      }
      
      private function __mouseClick(event:MouseEvent) : void
      {
         if(!PlayerManager.Instance.Self.bagLocked)
         {
            this.dragStart(event.stageX,event.stageY);
         }
      }
      
      public function dragStart(stageX:Number, stageY:Number) : void
      {
         DragManager.startDrag(this,this,ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.breakIconAsset"),stageX,stageY,DragEffect.MOVE);
      }
      
      public function dragStop(effect:DragEffect) : void
      {
         var cell:BagCell = null;
         if(effect.action == DragEffect.MOVE && effect.target is ICell)
         {
            cell = effect.target as BagCell;
            if(Boolean(cell))
            {
               if(cell.itemInfo.Count > 1 && cell.itemInfo.BagType != 11)
               {
                  this._dragTarget = cell;
                  SoundManager.instance.play("008");
                  this._dragTarget = cell;
                  SoundManager.instance.play("008");
                  this.win = ComponentFactory.Instance.creatComponentByStylename("breakGoodsView");
                  this.win.cell = cell;
                  this.win.show();
               }
            }
         }
      }
      
      private function breakBack() : void
      {
         if(Boolean(this._dragTarget))
         {
         }
         if(Boolean(stage))
         {
            this.dragStart(stage.mouseX,stage.mouseY);
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function getDragData() : Object
      {
         return this;
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeFromStage);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._dragTarget))
         {
            this._dragTarget.locked = false;
         }
         PlayerManager.Instance.Self.Bag.unLockAll();
         if(this.win != null)
         {
            this.win.dispose();
         }
         this.win = null;
         super.dispose();
      }
      
      private function __addToStage(evt:Event) : void
      {
      }
      
      private function __removeFromStage(evt:Event) : void
      {
      }
      
      private function cancelBack() : void
      {
         if(Boolean(this._dragTarget))
         {
            this._dragTarget.locked = false;
         }
      }
   }
}

