package game.gametrainer.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.manager.PlayerManager;
   import flash.display.MovieClip;
   import phy.object.PhysicalObj;
   
   public class TrainerEquip extends PhysicalObj
   {
      
      private var _equip:MovieClip;
      
      public function TrainerEquip(id:int, layerType:int = 1, mass:Number = 1, gravityFactor:Number = 1, windFactor:Number = 1, airResitFactor:Number = 1)
      {
         super(id,layerType,mass,gravityFactor,windFactor,airResitFactor);
         this.init();
      }
      
      private function init() : void
      {
         var str:String = PlayerManager.Instance.Self.Sex ? "asset.trainer.TrainerManEquipAsset" : "asset.trainer.TrainerWomanEquipAsset";
         this._equip = ComponentFactory.Instance.creat(str);
         addChild(this._equip);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._equip) && Boolean(this._equip.parent))
         {
            this._equip.parent.removeChild(this._equip);
         }
         this._equip = null;
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

