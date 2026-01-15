package littleGame.actions
{
   import ddt.ddt_internal;
   
   use namespace ddt_internal;
   
   public class LittleActionManager
   {
      
      ddt_internal var _queue:Array;
      
      public function LittleActionManager()
      {
         super();
         this.ddt_internal::_queue = new Array();
      }
      
      public function act(action:LittleAction) : void
      {
         var c:LittleAction = null;
         for(var i:int = 0; i < this.ddt_internal::_queue.length; i++)
         {
            c = this.ddt_internal::_queue[i];
            if(c.connect(action))
            {
               return;
            }
            if(c.canReplace(action))
            {
               action.prepare();
               this.ddt_internal::_queue[i] = action;
               return;
            }
         }
         this.ddt_internal::_queue.push(action);
         if(this.ddt_internal::_queue.length == 1)
         {
            action.prepare();
         }
      }
      
      public function execute() : void
      {
         var c:LittleAction = null;
         if(this.ddt_internal::_queue.length > 0)
         {
            c = this.ddt_internal::_queue[0];
            if(!c.isFinished)
            {
               c.execute();
            }
            else
            {
               this.ddt_internal::_queue.shift();
               if(this.ddt_internal::_queue.length > 0)
               {
                  this.ddt_internal::_queue[0].prepare();
               }
            }
         }
      }
      
      public function dispose() : void
      {
         var action:LittleAction = null;
         for each(action in this.ddt_internal::_queue)
         {
            action.cancel();
         }
         this.ddt_internal::_queue = null;
      }
   }
}

