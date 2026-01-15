package foodActivity.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   
   public class FoodActivityBox extends Component
   {
      
      private var _data:Object;
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      private var _box:MovieClip;
      
      private var _bg:ScaleBitmapImage;
      
      private var _content:FilterFrameText;
      
      public function FoodActivityBox()
      {
         super();
      }
      
      override protected function addChildren() : void
      {
         this._box = ComponentFactory.Instance.creat("foodActivity.box");
         addChild(this._box);
         width = this._box.width + 2;
         height = this._box.height + 2;
      }
      
      public function play(frame:int) : void
      {
         this._box.gotoAndStop(frame);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._box.stop();
         ObjectUtils.disposeObject(this._box);
         this._box = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         this._data = null;
         super.dispose();
      }
   }
}

