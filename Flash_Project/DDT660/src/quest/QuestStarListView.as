package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   
   public class QuestStarListView extends Component
   {
      
      private var _level:int;
      
      private var _starContainer:HBox;
      
      private var _starImg:Vector.<ScaleFrameImage>;
      
      private var _lightMovie:MovieClip;
      
      public function QuestStarListView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._starContainer = new HBox();
         addChild(this._starContainer);
         this._starImg = new Vector.<ScaleFrameImage>(5);
         for(var i:int = 0; i < 5; i++)
         {
            this._starImg[i] = ComponentFactory.Instance.creatComponentByStylename("quest.complete.star");
         }
         this._lightMovie = ComponentFactory.Instance.creat("asset.core.improveEffect");
      }
      
      public function level(value:int, improve:Boolean = false) : void
      {
         if(value > 5 || value < 0)
         {
            return;
         }
         this._level = value;
         for(var i:int = 0; i < 5; i++)
         {
            if(this._level > i)
            {
               if(improve && this._level - 1 == i)
               {
                  this._starContainer.addChild(this._lightMovie);
                  this._lightMovie.play();
               }
               else
               {
                  this._starContainer.addChild(this._starImg[i]);
                  this._starImg[i].setFrame(2);
               }
            }
            else
            {
               this._starContainer.addChild(this._starImg[i]);
               this._starImg[i].setFrame(1);
            }
         }
      }
      
      override public function dispose() : void
      {
         var i:int = 0;
         super.dispose();
         if(Boolean(this._starContainer))
         {
            ObjectUtils.disposeObject(this._starContainer);
         }
         this._starContainer = null;
         if(Boolean(this._lightMovie))
         {
            ObjectUtils.disposeObject(this._lightMovie);
         }
         this._lightMovie = null;
         if(Boolean(this._starImg))
         {
            for(i = 0; i < 5; i++)
            {
               if(Boolean(this._starImg[i]))
               {
                  ObjectUtils.disposeObject(this._starImg[i]);
               }
               this._starImg[i] = null;
            }
         }
         if(Boolean(this._starImg))
         {
            ObjectUtils.disposeObject(this._starImg);
         }
         this._starImg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

