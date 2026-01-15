package effortView.movieClip
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class EffortHonorMovieClipView extends EffortMovieClipView
   {
      
      public static const HONOR_MAX_FRAME:int = 59;
      
      public function EffortHonorMovieClipView(info:EffortInfo)
      {
         super(info);
      }
      
      override protected function init() : void
      {
         var pos2:Point = null;
         this.buttonMode = true;
         this.mouseChildren = true;
         this.mouseEnabled = true;
         _movieClipView = ComponentFactory.Instance.creat("asset.Effort.honorEffortMovieClipAsset");
         addChild(_movieClipView);
         for(var i:int = 0; i < _info.effortRewardArray.length; i++)
         {
            if((_info.effortRewardArray[i] as EffortRewardInfo).RewardType == 1)
            {
               _movieClipView.honorText.text = EffortManager.Instance.splitTitle((_info.effortRewardArray[i] as EffortRewardInfo).RewardPara);
            }
         }
         _movieClipView.honorText.mouseEnabled = false;
         pos2 = ComponentFactory.Instance.creatCustomObject("effortView.EffortMovieClipView.EffortMovieClipViewPos");
         _movieClipView.x = pos2.x;
         _movieClipView.y = pos2.y;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
         _movieClipView.play();
         SoundManager.instance.play("121");
      }
      
      override protected function __cartoonFrameHandler(event:Event) : void
      {
         if(!_movieClipView)
         {
            return;
         }
         if(_movieClipView.currentFrame <= HONOR_MAX_FRAME)
         {
            this.setAlpha();
         }
         if(_movieClipView.currentFrame == _movieClipView.totalFrames)
         {
            end();
            dispatchEvent(new Event(MOVIE_END));
         }
      }
      
      override protected function setAlpha() : void
      {
         if(_movieClipView.currentFrame <= ALPHA_FRAME)
         {
            _movieClipView.honorText.alpha = alphaArray[_movieClipView.currentFrame];
         }
         else
         {
            _movieClipView.honorText.alpha = 1;
         }
      }
   }
}

