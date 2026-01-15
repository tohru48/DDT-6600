package firstRecharge.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Sprite;
   
   public class FTextButton extends Sprite
   {
      
      private var _btn:SimpleBitmapButton;
      
      private var _txt:FilterFrameText;
      
      public var id:int;
      
      public function FTextButton(str:String, txtstr:String)
      {
         super();
         this._btn = ComponentFactory.Instance.creatComponentByStylename(str);
         addChild(this._btn);
         this._txt = ComponentFactory.Instance.creatComponentByStylename(txtstr);
         this._txt.text = "前去充值";
         this._txt.selectable = false;
         addChild(this._txt);
      }
      
      public function setTxt(str:String) : void
      {
         this._txt.text = str;
      }
   }
}

