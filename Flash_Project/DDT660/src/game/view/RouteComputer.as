package game.view
{
   import flash.geom.Point;
   import game.GameManager;
   import phy.maps.Map;
   import phy.object.PhysicalObj;
   
   public class RouteComputer
   {
      
      private static var DELAY_TIME:Number = 0.04;
      
      private var _map:Map;
      
      public function RouteComputer(map:Map)
      {
         super();
         this._map = map;
      }
      
      public function getPath(angle:int, power:int) : Array
      {
         var obj:PhysicalObj = null;
         obj = new PhysicalObj(0,1,10,70,240,1);
         obj.x = GameManager.Instance.Current.selfGamePlayer.pos.x;
         obj.y = GameManager.Instance.Current.selfGamePlayer.pos.y;
         obj.setSpeedXY(new Point(this.getVx(angle,power),this.getVy(angle,power)));
         obj.setCollideRect(-3,-3,6,6);
         this._map.addPhysical(obj);
         obj.startMoving();
         var result:Array = [];
         while(obj.isMoving())
         {
            result.push(new Point(obj.x,obj.y));
            obj.update(DELAY_TIME);
         }
         return result;
      }
      
      private function getVx(angle:int, power:int) : Number
      {
         return power * Math.cos(angle / 180 * Math.PI);
      }
      
      private function getVy(angle:int, power:int) : Number
      {
         return power * Math.sin(angle / 180 * Math.PI);
      }
   }
}

