package ddt.command
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ShineObject extends Sprite
   {
      
      private var _shiner:MovieClip;
      
      private var _addToBottom:Boolean;
      
      public function ShineObject(shiner:MovieClip, addToBottom:Boolean = true)
      {
         this._shiner = shiner;
         this._addToBottom = addToBottom;
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         addChild(this._shiner);
         this._shiner.stop();
      }
      
      private function initEvents() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function __addToStage(evt:Event) : void
      {
         if(Boolean(parent))
         {
            this.scaleX = 1 / parent.scaleX;
            this.scaleY = 1 / parent.scaleY;
            this._shiner.x = (parent.width * parent.scaleX - this._shiner.width) * 0.5;
            this._shiner.y = (parent.height * parent.scaleY - this._shiner.height) * 0.5;
            if(this._addToBottom)
            {
               parent.addChildAt(this,0);
            }
         }
      }
      
      public function shine(playSound:Boolean = false) : void
      {
         if(Boolean(this._shiner))
         {
            if(!SoundManager.instance.isPlaying("044") && playSound)
            {
               SoundManager.instance.play("044",false,true,100);
            }
            this._shiner.play();
         }
      }
      
      public function stopShine() : void
      {
         if(Boolean(this._shiner))
         {
            SoundManager.instance.stop("044");
            this._shiner.gotoAndStop(1);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._shiner))
         {
            this._shiner.stop();
            ObjectUtils.disposeObject(this._shiner);
         }
         this._shiner = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

