package collectionTask.view
{
   import collectionTask.CollectionTaskManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ProgressSprite extends Sprite implements Disposeable
   {
      
      private var _progressMc:MovieClip;
      
      private var _currentFrame:int;
      
      private var _completeFunc:Function;
      
      public function ProgressSprite(fun:Function)
      {
         this._completeFunc = fun;
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._progressMc = ComponentFactory.Instance.creat("asset.collectionTask.progressMc");
         addChild(this._progressMc);
         CollectionTaskManager.Instance.isCollecting = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(Event.ENTER_FRAME,this.__enterHandler);
      }
      
      protected function __enterHandler(event:Event) : void
      {
         ++this._currentFrame;
         if(this._currentFrame >= 117)
         {
            this.dispose();
            if(this._completeFunc != null)
            {
               this._completeFunc(CollectionTaskManager.Instance.collectedId);
            }
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__enterHandler);
      }
      
      public function dispose() : void
      {
         CollectionTaskManager.Instance.isCollecting = false;
         this.removeEvent();
         ObjectUtils.disposeObject(this._progressMc);
         this._progressMc = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

