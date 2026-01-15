package effortView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import effortView.leftView.EffortLeftView;
   import effortView.rightView.EffortFullView;
   import effortView.rightView.EffortRightHonorView;
   import effortView.rightView.EffortRightView;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class EffortPannelView extends Sprite implements Disposeable
   {
      
      private var _effortLeftView:EffortLeftView;
      
      private var _effoetRigthView:EffortRightView;
      
      private var _effoetFullView:EffortFullView;
      
      private var _effoetRigthHonorView:EffortRightHonorView;
      
      private var _controller:EffortController;
      
      public function EffortPannelView(controller:EffortController)
      {
         this._controller = controller;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._effortLeftView = new EffortLeftView(this._controller);
         var pos1:Point = ComponentFactory.Instance.creatCustomObject("effortView.EffortLeftView.EffortLeftViewPos");
         this._effortLeftView.x = pos1.x;
         this._effortLeftView.y = pos1.y;
         addChild(this._effortLeftView);
         this._effoetFullView = new EffortFullView(this._controller);
         addChild(this._effoetFullView);
      }
      
      private function initEvent() : void
      {
         this._controller.addEventListener(Event.CHANGE,this.__rightChange);
      }
      
      private function __rightChange(event:Event) : void
      {
         var pos2:Point = null;
         var pos4:Point = null;
         var pos3:Point = null;
         if(this._controller.currentRightViewType == 0)
         {
            if(Boolean(this._effoetRigthView))
            {
               removeChild(this._effoetRigthView);
               this._effoetRigthView.dispose();
               this._effoetRigthView = null;
            }
            if(Boolean(this._effoetRigthHonorView))
            {
               removeChild(this._effoetRigthHonorView);
               this._effoetRigthHonorView.dispose();
               this._effoetRigthHonorView = null;
            }
            if(!this._effoetFullView)
            {
               this._effoetFullView = new EffortFullView(this._controller);
               pos2 = ComponentFactory.Instance.creatCustomObject("effortView.EffortLeftView.EffortFullViewPos");
               this._effoetFullView.x = pos2.x;
               this._effoetFullView.y = pos2.y;
               addChild(this._effoetFullView);
            }
         }
         else if(this._controller.currentRightViewType == 6)
         {
            if(Boolean(this._effoetRigthView))
            {
               removeChild(this._effoetRigthView);
               this._effoetRigthView.dispose();
               this._effoetRigthView = null;
            }
            if(Boolean(this._effoetFullView))
            {
               removeChild(this._effoetFullView);
               this._effoetFullView.dispose();
               this._effoetFullView = null;
            }
            if(!this._effoetRigthHonorView)
            {
               this._effoetRigthHonorView = new EffortRightHonorView(this._controller);
               pos4 = ComponentFactory.Instance.creatCustomObject("effortView.EffortLeftView.EffortRightViewPos");
               this._effoetRigthHonorView.x = pos4.x;
               this._effoetRigthHonorView.y = pos4.y;
               addChild(this._effoetRigthHonorView);
            }
         }
         else
         {
            if(Boolean(this._effoetRigthHonorView))
            {
               removeChild(this._effoetRigthHonorView);
               this._effoetRigthHonorView.dispose();
               this._effoetRigthHonorView = null;
            }
            if(Boolean(this._effoetFullView))
            {
               removeChild(this._effoetFullView);
               this._effoetFullView.dispose();
            }
            this._effoetFullView = null;
            if(!this._effoetRigthView)
            {
               this._effoetRigthView = new EffortRightView(this._controller);
               pos3 = ComponentFactory.Instance.creatCustomObject("effortView.EffortLeftView.EffortRightViewPos");
               this._effoetRigthView.x = pos3.x;
               this._effoetRigthView.y = pos3.y;
               addChild(this._effoetRigthView);
            }
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._effoetRigthView))
         {
            removeChild(this._effoetRigthView);
            this._effoetRigthView.dispose();
            this._effoetRigthView = null;
         }
         if(Boolean(this._effoetFullView))
         {
            removeChild(this._effoetFullView);
            this._effoetFullView.dispose();
            this._effoetFullView = null;
         }
         if(Boolean(this._effortLeftView))
         {
            removeChild(this._effortLeftView);
            this._effortLeftView.dispose();
         }
         if(Boolean(this._effoetRigthHonorView))
         {
            removeChild(this._effoetRigthHonorView);
            this._effoetRigthHonorView.dispose();
            this._effoetRigthHonorView = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

