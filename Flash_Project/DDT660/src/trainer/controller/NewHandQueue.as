package trainer.controller
{
   import com.pickgliss.toplevel.StageReferance;
   import flash.events.Event;
   import trainer.data.Step;
   
   public class NewHandQueue
   {
      
      private static var _instance:NewHandQueue;
      
      private var _queue:Array;
      
      private var _isDelay:Boolean;
      
      public function NewHandQueue(enforcer:NewHandQueueEnforcer)
      {
         super();
         this._queue = new Array();
         this._isDelay = false;
         StageReferance.stage.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      public static function get Instance() : NewHandQueue
      {
         if(!_instance)
         {
            _instance = new NewHandQueue(new NewHandQueueEnforcer());
         }
         return _instance;
      }
      
      public function push(step:Step) : void
      {
         this._queue.push(step);
         if(this._queue.length == 1)
         {
            this._queue[0].prepare();
         }
      }
      
      private function __enterFrame(evt:Event) : void
      {
         var step:Step = null;
         if(this._isDelay)
         {
            step = this._queue[0];
            --step.delay;
            if(step.delay <= 0)
            {
               step.prepare();
               this._isDelay = false;
            }
         }
         else
         {
            this.execute();
         }
      }
      
      private function execute() : void
      {
         var step:Step = null;
         if(!this._queue)
         {
            return;
         }
         if(this._queue.length > 0)
         {
            step = this._queue[0];
            if(step.execute())
            {
               if(step.ID != Step.POP_LOST)
               {
                  NewHandGuideManager.Instance.progress = step.ID;
               }
               step.finish();
               step.dispose();
               if(Boolean(this._queue))
               {
                  this._queue.shift();
                  this.next();
               }
            }
         }
      }
      
      private function next() : void
      {
         var current:Step = null;
         if(this._queue.length > 0)
         {
            current = this._queue[0];
            if(current.delay > 0)
            {
               this._isDelay = true;
            }
            else
            {
               current.prepare();
            }
         }
      }
      
      public function dispose() : void
      {
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         _instance = null;
         this._queue = null;
      }
   }
}

class NewHandQueueEnforcer
{
   
   public function NewHandQueueEnforcer()
   {
      super();
   }
}
