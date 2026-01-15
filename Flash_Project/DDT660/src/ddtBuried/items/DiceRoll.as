package ddtBuried.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class DiceRoll extends Sprite
   {
      
      private var _mc:MovieClip;
      
      private var cFrame:String;
      
      public function DiceRoll()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._mc = ComponentFactory.Instance.creat("buried.newshaizi.movie");
         this._mc.gotoAndStop(1);
         this._mc.x = 476;
         this._mc.y = 295;
         addChild(this._mc);
         this._mc.addFrameScript(22,this.goFrame);
         this._mc.addFrameScript(23,this.mcover);
         this._mc.addFrameScript(24,this.mcover);
         this._mc.addFrameScript(25,this.mcover);
         this._mc.addFrameScript(26,this.mcover);
         this._mc.addFrameScript(27,this.mcover);
         this._mc.addFrameScript(28,this.mcover);
      }
      
      public function play() : void
      {
         this._mc.play();
      }
      
      private function goFrame() : void
      {
         this._mc.gotoAndStop(this.cFrame);
      }
      
      public function resetFrame() : void
      {
         this._mc.gotoAndStop(1);
      }
      
      public function setCrFrame(str:String) : void
      {
         this.cFrame = str;
      }
      
      private function mcover() : void
      {
         BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.DICEOVER));
      }
      
      public function dispose() : void
      {
         if(Boolean(this._mc))
         {
            this._mc.gotoAndStop(1);
            while(Boolean(this._mc.numChildren))
            {
               this._mc.removeChildAt(0);
            }
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

