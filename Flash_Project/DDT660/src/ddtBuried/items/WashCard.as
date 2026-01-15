package ddtBuried.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class WashCard extends Sprite
   {
      
      private var _mc:MovieClip;
      
      public function WashCard()
      {
         super();
         this._mc = ComponentFactory.Instance.creat("buried.card.wash");
         addChild(this._mc);
         this._mc.addFrameScript(65,this.washOver);
      }
      
      public function resetFrame() : void
      {
         this._mc.gotoAndStop(1);
      }
      
      public function play() : void
      {
         this._mc.play();
      }
      
      private function washOver() : void
      {
         this._mc.stop();
         BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.CARD_WASH_OVER));
      }
      
      public function dispose() : void
      {
         this._mc.stop();
         while(Boolean(this._mc.numChildren))
         {
            ObjectUtils.disposeObject(this._mc.getChildAt(0));
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

