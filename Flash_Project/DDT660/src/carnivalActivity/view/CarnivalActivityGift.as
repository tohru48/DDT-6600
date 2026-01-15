package carnivalActivity.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   
   public class CarnivalActivityGift extends Component
   {
      
      private var _bg:Bitmap;
      
      public function CarnivalActivityGift()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("carnicalAct.gift");
         addChild(this._bg);
         this._bg.width = 43;
         this._bg.height = 43;
         width = this._bg.width + 5;
         height = this._bg.height + 5;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         super.dispose();
      }
   }
}

