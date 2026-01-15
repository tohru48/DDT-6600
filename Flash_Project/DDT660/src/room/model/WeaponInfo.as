package room.model
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.WeaponBallManager;
   
   public class WeaponInfo
   {
      
      public static var ROTATITON_SPEED:Number = 1;
      
      private var _info:ItemTemplateInfo;
      
      public var armMaxAngle:Number = 90;
      
      public var armMinAngle:Number = 50;
      
      public var commonBall:int;
      
      public var skillBall:int;
      
      public var skill:int = -1;
      
      public var actionType:int;
      
      public var specialSkillMovie:int;
      
      public var refineryLevel:int;
      
      public var bombs:Array;
      
      public function WeaponInfo(info:ItemTemplateInfo)
      {
         super();
         this._info = info;
         this.armMinAngle = Number(info.Property5);
         this.armMaxAngle = Number(info.Property6);
         this.commonBall = Number(info.Property1);
         this.skillBall = Number(info.Property2);
         this.actionType = Number(info.Property3);
         this.skill = int(info.Property4);
         this.bombs = WeaponBallManager.getWeaponBallInfo(info.TemplateID);
         if(Boolean(this.bombs) && Boolean(this.bombs[0]))
         {
            this.commonBall = this.bombs[0];
         }
         this.refineryLevel = int(info.RefineryLevel);
      }
      
      public function get TemplateID() : int
      {
         return this._info.TemplateID;
      }
      
      public function dispose() : void
      {
         this._info = null;
      }
   }
}

