package ddtBuried.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class BuriedItem extends Sprite implements Disposeable
   {
      
      private var _txt:FilterFrameText;
      
      private var _back:Bitmap;
      
      private var _icon:Bitmap;
      
      public function BuriedItem(txtstr:String, icon:String)
      {
         super();
         this.initView(txtstr,icon);
      }
      
      private function initView(txtstr:String, icon:String) : void
      {
         this._back = ComponentFactory.Instance.creat("buried.item.back");
         addChild(this._back);
         this._icon = ComponentFactory.Instance.creat(icon);
         addChild(this._icon);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("ddtburied.buriedItem.txt");
         addChild(this._txt);
         this._txt.text = txtstr;
      }
      
      public function upDateTxt(str:String) : void
      {
         this._txt.text = str;
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

