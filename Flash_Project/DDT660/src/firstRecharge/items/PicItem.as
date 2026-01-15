package firstRecharge.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PicItem extends Sprite
   {
      
      private var _back:Bitmap;
      
      private var _btn:SimpleBitmapButton;
      
      private var _icon:Bitmap;
      
      private var _txt:FilterFrameText;
      
      public var id:int;
      
      public function PicItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creatBitmap("fristRecharge.wupin.back");
         addChild(this._back);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.picTxt");
         addChild(this._txt);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("accumulationView.btn");
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      public function setTxtStr(str:String) : void
      {
         this._txt.text = str;
         this._txt.x = this._back.width / 2 - this._txt.width / 2;
      }
      
      protected function mouseClickHander(event:MouseEvent) : void
      {
      }
      
      public function addIcon(str:String) : void
      {
         if(Boolean(this._icon))
         {
            ObjectUtils.disposeObject(this._icon);
         }
         this._icon = ComponentFactory.Instance.creatBitmap(str);
         this._icon.x = this._back.width / 2 - this._icon.width / 2;
         this._icon.y = this._back.height / 2 - this._icon.height / 2;
         addChild(this._icon);
      }
      
      public function dispose() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         if(Boolean(this._icon))
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(Boolean(this._btn))
         {
            ObjectUtils.disposeObject(this._btn);
            this._btn = null;
         }
      }
   }
}

