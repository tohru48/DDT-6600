package game.actions.pet
{
   import flash.geom.Point;
   import game.actions.BaseAction;
   import game.model.Living;
   import game.model.Player;
   import game.objects.GamePet;
   import game.objects.GamePlayer;
   
   public class PetBeatAction extends BaseAction
   {
      
      private var _pet:GamePet;
      
      private var _act:String;
      
      private var _pt:Point;
      
      private var _targets:Array;
      
      private var _master:GamePlayer;
      
      private var _updated:Boolean = false;
      
      public function PetBeatAction(pet:GamePet, master:GamePlayer, act:String, pt:Point, targets:Array)
      {
         this._pet = pet;
         this._act = act;
         this._pt = pt;
         this._targets = targets;
         this._master = master;
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
         if(this._pet == null || this._pet.info == null)
         {
            this.finish();
            return;
         }
         this._pet.show();
         this._pet.info.pos = this._pt;
         this._pet.map.setCenter(this._pt.x,this._pt.y,true);
         this._pet.map.bringToFront(this._pet.info);
         this._pet.actionMovie.doAction(this._act,this.updateHp);
      }
      
      private function updateHp() : void
      {
         var target:Object = null;
         var t:Living = null;
         var hp:int = 0;
         var dam:int = 0;
         var dander:int = 0;
         if(this._pet == null || this._pet.info == null || this._master == null || this._master.info == null)
         {
            this.finish();
            return;
         }
         if(!this._updated)
         {
            for each(target in this._targets)
            {
               t = target.target;
               hp = int(target.hp);
               dam = int(target.dam);
               dander = int(target.dander);
               t.updateBlood(hp,3,dam);
               if(t is Player)
               {
                  Player(t).dander = dander;
               }
            }
            this._updated = true;
            _isFinished = true;
            if(Boolean(this._pet))
            {
               this._pet.hide();
            }
         }
      }
      
      override public function cancel() : void
      {
         var target:Object = null;
         var t:Living = null;
         var hp:int = 0;
         var dam:int = 0;
         var dander:int = 0;
         if(this._pet == null || this._pet.info == null || this._master == null || this._master.info == null)
         {
            this.finish();
            return;
         }
         if(!this._updated)
         {
            for each(target in this._targets)
            {
               t = target.target;
               hp = int(target.hp);
               dam = int(target.dam);
               dander = int(target.dander);
               t.updateBlood(hp,3,dam);
               if(t is Player)
               {
                  Player(t).dander = dander;
               }
            }
            this._pet.info.pos = this._master.info.pos;
            this._updated = true;
         }
      }
      
      private function finish() : void
      {
         this._pet = null;
         this._targets = null;
         this._master = null;
         _isFinished = true;
      }
      
      override public function executeAtOnce() : void
      {
         this.cancel();
      }
      
      override public function execute() : void
      {
         if(this._pet == null || this._pet.info == null || this._master == null || this._master.info == null)
         {
            this.finish();
            return;
         }
         if(this._updated && Point.distance(this._pet.info.pos,this._master.info.pos) < 1)
         {
            this.finish();
         }
      }
   }
}

