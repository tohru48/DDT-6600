package game.gametrainer.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.MovieClip;
   import phy.object.PhysicalObj;
   
   public class TrainerArrowTip extends PhysicalObj
   {
      
      private var _bannerAsset:MovieClip;
      
      public function TrainerArrowTip(id:int, layerType:int = 1, mass:Number = 1, gravityFactor:Number = 1, windFactor:Number = 1, airResitFactor:Number = 1)
      {
         super(id,layerType,mass,gravityFactor,windFactor,airResitFactor);
         this.init();
      }
      
      private function init() : void
      {
         this._bannerAsset = ComponentFactory.Instance.creat("asset.trainer.TrainerArrowAsset");
         this.addChild(this._bannerAsset);
      }
      
      public function gotoAndStopII(I:int) : void
      {
         if(Boolean(this._bannerAsset))
         {
            this._bannerAsset.gotoAndStop(I);
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._bannerAsset))
         {
            if(Boolean(this._bannerAsset.parent))
            {
               this._bannerAsset.parent.removeChild(this._bannerAsset);
            }
         }
         this._bannerAsset = null;
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

