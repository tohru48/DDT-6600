package game.view
{
   import ddt.data.BallInfo;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import game.objects.ActionType;
   
   public class Bomb extends EventDispatcher
   {
      
      public static const FLY_BOMB:int = 3;
      
      public static const FREEZE_BOMB:int = 1;
      
      public var Id:int;
      
      public var X:int;
      
      public var Y:int;
      
      public var VX:int;
      
      public var VY:int;
      
      public var Actions:Array = new Array();
      
      public var UsedActions:Array = new Array();
      
      public var Template:BallInfo;
      
      public var targetX:Number;
      
      public var targetY:Number;
      
      public var damageMod:Number;
      
      public var changedPartical:String;
      
      private var i:int = 0;
      
      public var number:int;
      
      public var shootCount:int;
      
      public var IsHole:Boolean;
      
      public function Bomb()
      {
         super();
      }
      
      private function checkFly(arr1:Array, arr2:Array) : Boolean
      {
         if(int(arr1[0]) != int(arr2[0]))
         {
            return true;
         }
         return false;
      }
      
      public function get target() : Point
      {
         for(var i:int = 0; i < this.Actions.length; i++)
         {
            if(this.Actions[i].type == ActionType.BOMB)
            {
               return new Point(this.Actions[i].param1,this.Actions[i].param2);
            }
            if(this.Actions[i].type == ActionType.FLY_OUT)
            {
               return new Point(this.Actions[i].param1,this.Actions[i].param2);
            }
         }
         for(var j:int = 0; j < this.UsedActions.length; j++)
         {
            if(this.UsedActions[j].type == ActionType.BOMB)
            {
               return new Point(this.UsedActions[j].param1,this.UsedActions[j].param2);
            }
            if(this.UsedActions[j].type == ActionType.FLY_OUT)
            {
               return new Point(this.UsedActions[j].param1,this.UsedActions[j].param2);
            }
         }
         return null;
      }
      
      public function get isCritical() : Boolean
      {
         for(var i:int = 0; i < this.Actions.length; i++)
         {
            if(this.Actions[i].type == ActionType.BOMBED)
            {
               return true;
            }
         }
         return false;
      }
   }
}

