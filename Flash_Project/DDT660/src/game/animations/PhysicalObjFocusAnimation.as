package game.animations
{
   import game.objects.SimpleBomb;
   import phy.object.PhysicalObj;
   
   public class PhysicalObjFocusAnimation extends BaseSetCenterAnimation
   {
      
      private var _phy:PhysicalObj;
      
      public function PhysicalObjFocusAnimation(phy:PhysicalObj, life:int = 100, offsetY:int = 0)
      {
         super(phy.x,phy.y + offsetY,life,false);
         this._phy = phy;
         _level = AnimationLevel.MIDDLE;
      }
      
      override public function canReplace(anit:IAnimate) : Boolean
      {
         var at:PhysicalObjFocusAnimation = anit as PhysicalObjFocusAnimation;
         if(Boolean(at) && at._phy != this._phy)
         {
            if(this._phy is SimpleBomb && at._phy is SimpleBomb)
            {
               if(!this._phy.isLiving || SimpleBomb(this._phy).info.Id > SimpleBomb(at._phy).info.Id)
               {
                  return true;
               }
               return false;
            }
         }
         return true;
      }
   }
}

