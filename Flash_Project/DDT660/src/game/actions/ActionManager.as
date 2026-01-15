package game.actions
{
   import ddt.manager.SocketManager;
   import flash.utils.getQualifiedClassName;
   
   public class ActionManager
   {
      
      private var _queue:Array;
      
      public function ActionManager()
      {
         super();
         this._queue = new Array();
      }
      
      public function act(action:BaseAction) : void
      {
         var c:BaseAction = null;
         for(var i:int = 0; i < this._queue.length; i++)
         {
            c = this._queue[i];
            if(c.connect(action))
            {
               return;
            }
            if(c.canReplace(action))
            {
               action.prepare();
               this._queue[i] = action;
               return;
            }
         }
         this._queue.push(action);
         if(this._queue.length == 1)
         {
            action.prepare();
         }
      }
      
      public function execute() : void
      {
         var c:BaseAction = null;
         if(this._queue.length > 0)
         {
            c = this._queue[0];
            if(!c.isFinished)
            {
               c.execute();
            }
            else
            {
               this._queue.shift();
               if(this._queue.length > 0)
               {
                  this._queue[0].prepare();
               }
            }
         }
      }
      
      public function traceAllRemainAction(name:String = "") : void
      {
         var actionClassName:String = null;
         var tmpArr:Array = null;
         var tmp:String = "";
         for(var i:int = 0; i < this._queue.length; i++)
         {
            actionClassName = getQualifiedClassName(this._queue[i]);
            tmpArr = actionClassName.split("::");
            tmp += tmpArr[tmpArr.length - 1] + " | ";
         }
         SocketManager.Instance.out.sendErrorMsg("客户端卡死了" + name + " : " + tmp);
      }
      
      public function get actionCount() : int
      {
         return this._queue.length;
      }
      
      public function executeAtOnce() : void
      {
         var action:BaseAction = null;
         for each(action in this._queue)
         {
            action.executeAtOnce();
         }
      }
      
      public function clear() : void
      {
         var action:BaseAction = null;
         for each(action in this._queue)
         {
            action.cancel();
         }
         this._queue = [];
      }
   }
}

