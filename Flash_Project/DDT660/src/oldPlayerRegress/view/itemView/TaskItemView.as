package oldPlayerRegress.view.itemView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class TaskItemView extends Frame
   {
      
      private var _func:Function;
      
      private var _clickID:int;
      
      private var _itemBg:ScaleFrameImage;
      
      private var _light:Scale9CornerImage;
      
      private var _titleField:FilterFrameText;
      
      private var _bmpOK:Bitmap;
      
      public function TaskItemView(func:Function)
      {
         super();
         this._func = func;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.itemBg = ComponentFactory.Instance.creat("regress.taskItemBG");
         this.itemBg.setFrame(1);
         addChild(this.itemBg);
         this._light = ComponentFactory.Instance.creatComponentByStylename("regress.taskItemLight");
         addChild(this._light);
         this._light.visible = false;
         this.titleField = ComponentFactory.Instance.creat("regress.taskItemTitleNormal");
         addChild(this.titleField);
         this.bmpOK = ComponentFactory.Instance.creat("asset.taskMenuItem.textImg.OK");
         this.bmpOK.visible = false;
         addChild(this.bmpOK);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__MouseClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__MouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__MouseOut);
      }
      
      protected function __MouseOver(event:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      protected function __MouseOut(event:MouseEvent) : void
      {
         this._light.visible = false;
      }
      
      protected function __MouseClick(event:MouseEvent) : void
      {
         this._func(this._clickID);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__MouseClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__MouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__MouseOut);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeVariable();
      }
      
      private function removeVariable() : void
      {
         this.clickID = 0;
         if(Boolean(this.itemBg))
         {
            this.itemBg.dispose();
            this.itemBg = null;
         }
         if(Boolean(this._light))
         {
            this._light.dispose();
            this._light = null;
         }
         if(Boolean(this.titleField))
         {
            this.titleField.dispose();
            this.titleField = null;
         }
         if(this._func != null)
         {
            this._func = null;
         }
         if(Boolean(this.bmpOK))
         {
            this.bmpOK = null;
         }
      }
      
      public function get clickID() : int
      {
         return this._clickID;
      }
      
      public function set clickID(value:int) : void
      {
         this._clickID = value;
      }
      
      public function get itemBg() : ScaleFrameImage
      {
         return this._itemBg;
      }
      
      public function set itemBg(value:ScaleFrameImage) : void
      {
         this._itemBg = value;
      }
      
      public function get titleField() : FilterFrameText
      {
         return this._titleField;
      }
      
      public function set titleField(value:FilterFrameText) : void
      {
         this._titleField = value;
      }
      
      public function get bmpOK() : Bitmap
      {
         return this._bmpOK;
      }
      
      public function set bmpOK(value:Bitmap) : void
      {
         this._bmpOK = value;
      }
   }
}

