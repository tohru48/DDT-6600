package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import pet.date.PetInfo;
   import petsBag.view.item.PetSmallItem;
   
   public class PetsEatSmallItem extends PetSmallItem implements Disposeable
   {
      
      private var starMc:MovieClip;
      
      public function PetsEatSmallItem(info:PetInfo = null)
      {
         super(info);
      }
      
      public function initTips() : void
      {
         tipStyle = "petsBag.petsAdvanced.PetAttributeTip";
         tipDirctions = "6";
      }
      
      override protected function initView() : void
      {
         super.initView();
         this.starMc = ComponentFactory.Instance.creat("assets.PetsBag.eatPets.starMc");
         this.starMc.x = 31;
         this.starMc.y = 67;
         addChild(this.starMc);
         this.starMc.gotoAndStop(1);
      }
      
      override public function set info(value:PetInfo) : void
      {
         super.info = value;
         tipData = value;
         this.starMc.gotoAndStop(_info.StarLevel);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this.starMc))
         {
            ObjectUtils.disposeObject(this.starMc);
            this.starMc = null;
         }
      }
   }
}

