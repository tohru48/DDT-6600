package treasureLost.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TreasureLostDiceRoll extends Sprite
   {
      
      private var _mc:MovieClip;
      
      private var cFrame:String;
      
      private var _type:String;
      
      public function TreasureLostDiceRoll(type:String = "normal")
      {
         super();
         this._type = type;
         this.initView();
      }
      
      private function initView() : void
      {
         if(this._type == "normal")
         {
            this._mc = ComponentFactory.Instance.creat("treasureLost.diceRoll");
         }
         else if(this._type == "gold")
         {
            this._mc = ComponentFactory.Instance.creat("treasureLost.goldDiceRoll");
         }
         this._mc.gotoAndStop(1);
         addChild(this._mc);
      }
      
      public function play() : void
      {
         this._mc.play();
      }
      
      public function stop() : void
      {
         this._mc.stop();
      }
      
      public function goFrame(str:String) : void
      {
         this._mc.gotoAndStop(str);
      }
      
      public function resetFrame() : void
      {
         this._mc.gotoAndStop(1);
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

