package activeEvents
{
   import activeEvents.data.ActiveEventsInfo;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class ActiveEventsModel extends EventDispatcher
   {
      
      public static var newMovement:Dictionary = new Dictionary();
      
      private var _list:Array;
      
      private var _activesList:Array;
      
      public function ActiveEventsModel()
      {
         super();
      }
      
      public function get actives() : Array
      {
         return this._activesList;
      }
      
      public function get list() : Array
      {
         return this._list;
      }
      
      public function set actives($list:Array) : void
      {
         this._list = $list;
         this._activesList = this._list.concat();
         this.filtTime();
         this._activesList = this.sortActives();
      }
      
      private function filtTime() : void
      {
         var info:ActiveEventsInfo = null;
         for(var i:int = this.actives.length - 1; i >= 0; i--)
         {
            info = this.actives[i];
            if(info.overdue())
            {
               this.actives.splice(i,1);
            }
         }
      }
      
      private function sortActives() : Array
      {
         var info:ActiveEventsInfo = null;
         var first:Array = new Array();
         var second:Array = new Array();
         var third:Array = new Array();
         for(var i:int = 0; i < this.actives.length; i++)
         {
            info = this.actives[i];
            if(info.Type == 0)
            {
               third.push(info);
            }
            else if(info.Type == 1)
            {
               second.push(info);
               if(newMovement[info.ActiveID] == null)
               {
                  newMovement[info.ActiveID] = false;
               }
            }
            else if(info.Type == 2)
            {
               first.push(info);
            }
         }
         return first.concat(second,third);
      }
   }
}

