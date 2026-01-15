package game.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class FightAchievBar extends Sprite implements Disposeable
   {
      
      private var _animates:Vector.<AchieveAnimation> = new Vector.<AchieveAnimation>();
      
      private var _displays:Vector.<AchieveAnimation> = new Vector.<AchieveAnimation>();
      
      private var _started:Boolean = false;
      
      public function FightAchievBar()
      {
         super();
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__onFrame);
      }
      
      public function addAnimate(animate:AchieveAnimation) : void
      {
         this._animates.push(animate);
         if(animate.interval <= 0)
         {
            this.playAnimate(animate);
         }
         if(!this._started)
         {
            addEventListener(Event.ENTER_FRAME,this.__onFrame);
            this._started = true;
         }
      }
      
      private function playAnimate(animate:AchieveAnimation) : void
      {
         var a:AchieveAnimation = null;
         animate.play();
         addChild(animate);
         animate.addEventListener(Event.COMPLETE,this.__animateComplete);
         this._displays.unshift(animate);
         if(this._displays.length > 4)
         {
            a = this._displays.pop();
            this.removeAnimate(a);
            ObjectUtils.disposeObject(a);
         }
         this.drawLayer();
      }
      
      private function __animateComplete(event:Event) : void
      {
         var animate:AchieveAnimation = event.currentTarget as AchieveAnimation;
         animate.removeEventListener(Event.COMPLETE,this.__animateComplete);
         this.removeAnimate(animate);
         ObjectUtils.disposeObject(animate);
      }
      
      private function __onFrame(event:Event) : void
      {
         var animate:AchieveAnimation = null;
         var now:int = getTimer();
         for each(animate in this._animates)
         {
            if(!animate.show && animate.delay >= now)
            {
               this.playAnimate(animate);
            }
         }
      }
      
      public function removeAnimate(animate:AchieveAnimation) : void
      {
         var idx:int = int(this._animates.indexOf(animate));
         if(idx >= 0)
         {
            this._animates.splice(idx,1);
         }
         if(animate.show)
         {
            idx = int(this._displays.indexOf(animate));
            if(idx >= 0)
            {
               this._displays.splice(idx,1);
            }
         }
         if(this._animates.length <= 0)
         {
            removeEventListener(Event.ENTER_FRAME,this.__onFrame);
            this._started = false;
         }
      }
      
      public function rePlayAnimate(animate:AchieveAnimation) : void
      {
      }
      
      public function getAnimate(id:int) : AchieveAnimation
      {
         var animate:AchieveAnimation = null;
         for each(animate in this._animates)
         {
            if(animate.id == id)
            {
               return animate;
            }
         }
         return null;
      }
      
      private function drawLayer() : void
      {
         var len:int = int(this._displays.length);
         for(var i:int = 0; i < len; i++)
         {
            if(i == 0)
            {
               this._displays[i].y = -this._displays[i].height;
            }
            else
            {
               this._displays[i].y = this._displays[i - 1].y - this._displays[i].height - 4;
            }
         }
      }
   }
}

