package ddtBuried.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class BuriedBox extends Sprite
   {
      
      private var _mc:MovieClip;
      
      private var _winTime:uint;
      
      public function BuriedBox()
      {
         super();
      }
      
      public function initView(type:int, mcName:String = "buried.shaizi.boxOpen") : void
      {
         this._mc = ComponentFactory.Instance.creat(mcName + type);
         this._mc.x = 508;
         this._mc.y = -30;
         this._mc.gotoAndStop(1);
         addChild(this._mc);
         this._mc.addFrameScript(119,this.playOver);
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("1001");
         this._winTime = setTimeout(this.startMusic,3000);
      }
      
      private function startMusic() : void
      {
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("1001");
      }
      
      public function play() : void
      {
         this._mc.gotoAndPlay(1);
      }
      
      private function playOver() : void
      {
         this._mc.gotoAndStop(1);
         this.visible = false;
         BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.BOXMOVIE_OVER));
      }
      
      public function dispose() : void
      {
         clearTimeout(this._winTime);
         if(Boolean(this._mc))
         {
            this._mc.stop();
         }
         while(Boolean(this._mc.numChildren))
         {
            ObjectUtils.disposeObject(this._mc.getChildAt(0));
         }
         ObjectUtils.disposeObject(this._mc);
         this._mc = null;
      }
   }
}

