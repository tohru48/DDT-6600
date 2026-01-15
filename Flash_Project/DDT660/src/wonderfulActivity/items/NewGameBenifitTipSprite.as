package wonderfulActivity.items
{
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   
   public class NewGameBenifitTipSprite extends Component
   {
      
      private var _back:DisplayObject;
      
      public function NewGameBenifitTipSprite()
      {
         super();
      }
      
      public function set back(back:DisplayObject) : void
      {
         this._back = back;
         this._back.alpha = 0;
         _width = this._back.width;
         _height = this._back.height;
         addChild(this._back);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

