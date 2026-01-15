package game.actions
{
   import game.objects.GamePlayer;
   import game.objects.SimpleBox;
   import phy.object.PhysicalObj;
   
   public class PickBoxAction
   {
      
      public var executed:Boolean = false;
      
      private var _time:int;
      
      private var _boxid:int;
      
      public function PickBoxAction(boxid:int, time:int)
      {
         super();
         this._time = time;
         this._boxid = boxid;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function execute(player:GamePlayer) : void
      {
         this.executed = true;
         var obj:PhysicalObj = player.map.getPhysical(this._boxid);
         if(obj is SimpleBox)
         {
            SimpleBox(obj).pickByLiving(player.info);
         }
      }
   }
}

