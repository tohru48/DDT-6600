package effortView.movieClip
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.effort.EffortInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import effortView.rightView.AchievementPointView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EffortMovieClipView extends Sprite implements Disposeable
   {
      
      public static const MAX_FRAME:int = 75;
      
      public static const ALPHA_FRAME:int = 22;
      
      public static const MOVIE_END:String = "MovieEnd";
      
      protected var _info:EffortInfo;
      
      protected var alphaArray:Array = [0,0,0.2,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.66,0.7,0.7,0.7,0.65,0.5,0.4,0.3,0.4,0.5,0.6,0.8,1];
      
      protected var _achievementPointView:AchievementPointView;
      
      protected var _movieClipView:MovieClip;
      
      public function EffortMovieClipView(info:EffortInfo)
      {
         super();
         this._info = info;
         this.init();
         this.initEvent();
      }
      
      protected function init() : void
      {
         var pos:Point = null;
         var pos2:Point = null;
         this.buttonMode = true;
         this.mouseChildren = true;
         this.mouseEnabled = true;
         this._movieClipView = ComponentFactory.Instance.creat("asset.Effort.EffortMovieClipAsset");
         addChild(this._movieClipView);
         this._movieClipView.content_txt.text = this._info.Title;
         this._movieClipView.content_txt.mouseEnabled = false;
         this._achievementPointView = new AchievementPointView();
         this._achievementPointView.value = this._info.AchievementPoint;
         pos = ComponentFactory.Instance.creatCustomObject("effortView.EffortMovieClipView.AchievementPointView");
         this._achievementPointView.x = pos.x;
         this._achievementPointView.y = pos.y;
         this._movieClipView.addChild(this._achievementPointView);
         pos2 = ComponentFactory.Instance.creatCustomObject("effortView.EffortMovieClipView.EffortMovieClipViewPos");
         this._movieClipView.x = pos2.x;
         this._movieClipView.y = pos2.y;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
         this._movieClipView.play();
         SoundManager.instance.play("121");
      }
      
      protected function initEvent() : void
      {
         this._movieClipView.addEventListener(Event.ENTER_FRAME,this.__cartoonFrameHandler);
         addEventListener(MouseEvent.CLICK,this.__thisClick);
      }
      
      protected function __thisClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         removeEventListener(MouseEvent.CLICK,this.__thisClick);
         if(!EffortManager.Instance.getMainFrameVisible())
         {
            EffortManager.Instance.isSelf = true;
            EffortManager.Instance.switchVisible();
         }
      }
      
      protected function __cartoonFrameHandler(event:Event) : void
      {
         if(!this._movieClipView)
         {
            return;
         }
         if(this._movieClipView.currentFrame <= MAX_FRAME)
         {
            this.setAlpha();
         }
         if(this._movieClipView.currentFrame == this._movieClipView.totalFrames)
         {
            this.end();
            dispatchEvent(new Event(MOVIE_END));
         }
      }
      
      protected function end() : void
      {
         this._movieClipView.removeEventListener(Event.ENTER_FRAME,this.__cartoonFrameHandler);
         removeEventListener(MouseEvent.CLICK,this.__thisClick);
         this._movieClipView.gotoAndStop(this._movieClipView.totalFrames);
         this.dispose();
      }
      
      protected function setAlpha() : void
      {
         if(this._movieClipView.currentFrame <= ALPHA_FRAME)
         {
            this._movieClipView.content_txt.alpha = this.alphaArray[this._movieClipView.currentFrame];
            this._achievementPointView.alpha = this.alphaArray[this._movieClipView.currentFrame];
         }
         else
         {
            this._movieClipView.content_txt.alpha = 1;
            this._achievementPointView.alpha = 1;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._achievementPointView) && Boolean(this._achievementPointView.parent))
         {
            this._achievementPointView.parent.removeChild(this._achievementPointView);
            this._achievementPointView.dispose();
            this._achievementPointView = null;
         }
         if(Boolean(this._movieClipView) && Boolean(this._movieClipView.parent))
         {
            this._movieClipView.stop();
            this._movieClipView.parent.removeChild(this._movieClipView);
            this._movieClipView = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

