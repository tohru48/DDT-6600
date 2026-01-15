package superWinner.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import road7th.utils.StringHelper;
   
   public class SuperWinnerAwardsTip extends Sprite implements ITransformableTip
   {
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _contentTxt:FilterFrameText;
      
      protected var _data:Object;
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      public function SuperWinnerAwardsTip()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("superWinner.tips");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("superWinner.TipText");
         addChild(this._bg);
         addChild(this._contentTxt);
      }
      
      protected function updateTransform() : void
      {
         this._bg.width = this._contentTxt.width + 16;
         this._bg.height = this._contentTxt.height + 8;
         this._contentTxt.x = this._bg.x + 8;
         this._contentTxt.y = this._bg.y + 4;
      }
      
      public function get tipWidth() : int
      {
         return this._tipWidth;
      }
      
      public function set tipWidth(w:int) : void
      {
         if(this._tipWidth != w)
         {
            this._tipWidth = w;
            this.updateTransform();
         }
      }
      
      public function get tipHeight() : int
      {
         return this._bg.height;
      }
      
      public function set tipHeight(h:int) : void
      {
      }
      
      public function get tipData() : Object
      {
         return this._data;
      }
      
      public function set tipData(data:Object) : void
      {
         this._data = data;
         this._contentTxt.htmlText = StringHelper.trim(String(this._data));
         this.updateTransform();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._contentTxt))
         {
            ObjectUtils.disposeObject(this._contentTxt);
         }
         this._contentTxt = null;
         this._data = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

