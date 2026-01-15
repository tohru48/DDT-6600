package consortionBattle.player
{
   import ddt.data.player.PlayerInfo;
   import flash.geom.Point;
   
   public class ConsortiaBattlePlayerInfo extends PlayerInfo
   {
      
      public var id:int;
      
      public var pos:Point = new Point(600,580);
      
      public var clothIndex:int = 1;
      
      public var sex:Boolean;
      
      public var selfOrEnemy:int;
      
      public var consortiaName:String;
      
      public var tombstoneEndTime:Date;
      
      public var status:int;
      
      public var winningStreak:int;
      
      public var failBuffCount:int;
      
      private var _walkPath:Array = [];
      
      public var currentWalkStartPoint:Point;
      
      public function ConsortiaBattlePlayerInfo()
      {
         super();
      }
      
      public function get walkPath() : Array
      {
         return this._walkPath;
      }
      
      public function set walkPath(value:Array) : void
      {
         this._walkPath = value;
      }
   }
}

