package game.actions
{
   import game.view.map.MapView;
   
   public class ViewEachObjectAction extends BaseAction
   {
      
      private var _map:MapView;
      
      private var _objects:Array;
      
      private var _interval:Number;
      
      private var _index:int;
      
      private var _count:int;
      
      private var _type:int;
      
      public function ViewEachObjectAction(map:MapView, objects:Array, type:int = 0, interval:Number = 1500)
      {
         super();
         this._objects = objects;
         this._map = map;
         this._interval = interval / 40;
         this._index = 0;
         this._count = 0;
         this._type = type;
      }
      
      override public function execute() : void
      {
         if(this._count <= 0)
         {
            if(this._index < this._objects.length)
            {
               this._map.scenarioSetCenter(this._objects[this._index].x,this._objects[this._index].y,this._type);
               this._count = this._interval;
               ++this._index;
            }
            else
            {
               _isFinished = true;
            }
         }
         --this._count;
      }
   }
}

