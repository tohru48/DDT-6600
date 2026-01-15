package game.animations
{
   import game.objects.GameLiving;
   import game.objects.SimpleBomb;
   import game.view.map.MapView;
   import phy.object.PhysicalObj;
   
   public class BombFocusAnimation extends PhysicalObjFocusAnimation
   {
      
      protected var _phy:SimpleBomb;
      
      protected var _owner:GameLiving;
      
      public function BombFocusAnimation(phy:SimpleBomb, life:int = 100, offsetY:int = 0, owner:PhysicalObj = null)
      {
         super(phy,life,offsetY);
         this._phy = phy;
         _level = AnimationLevel.MIDDLE;
         this._owner = owner as GameLiving;
      }
      
      override public function update(movie:MapView) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         return super.update(movie);
      }
      
      private function smoothDown(start:Number, target:Number, progress:Number) : Number
      {
         progress = Math.sqrt(progress);
         var smooth:Number = (target - start) * progress;
         return start + smooth;
      }
      
      private function smoothUp(start:Number, target:Number, progress:Number) : Number
      {
         progress *= progress;
         var smooth:Number = (target - start) * progress;
         return start + smooth;
      }
   }
}

