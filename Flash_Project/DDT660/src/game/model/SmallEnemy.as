package game.model
{
   import ddt.events.LivingEvent;
   
   [Event(name="modelChanged",type="tank.events.LivingEvent")]
   public class SmallEnemy extends Living
   {
      
      public var stateType:int;
      
      private var _modelID:int;
      
      public function SmallEnemy(id:int, team:int, maxBlood:int)
      {
         super(id,team,maxBlood);
      }
      
      public function set modelID(value:int) : void
      {
         var old:int = this._modelID;
         this._modelID = value;
         dispatchEvent(new LivingEvent(LivingEvent.MODEL_CHANGED,this._modelID,old));
      }
      
      public function get modelID() : int
      {
         return this._modelID;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

