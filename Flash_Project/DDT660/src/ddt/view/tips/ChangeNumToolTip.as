package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class ChangeNumToolTip extends BaseTip implements ITransformableTip
   {
      
      private var _title:FilterFrameText;
      
      private var _currentTxt:FilterFrameText;
      
      private var _totalTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _container:Sprite;
      
      private var _tempData:Object;
      
      private var _bg:ScaleBitmapImage;
      
      public function ChangeNumToolTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._title = ComponentFactory.Instance.creatComponentByStylename("ChangeNumToolTip.titleTxt");
         this._totalTxt = ComponentFactory.Instance.creatComponentByStylename("ChangeNumToolTip.totalTxt");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("ChangeNumToolTip.contentTxt");
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._container = new Sprite();
         this._container.addChild(this._title);
         this._container.addChild(this._totalTxt);
         this._container.addChild(this._contentTxt);
         super.init();
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(data:Object) : void
      {
         if(data is ChangeNumToolTipInfo)
         {
            this.update(data.currentTxt,data.title,data.current,data.total,data.content);
         }
         else
         {
            this.visible = false;
         }
         this._tempData = data;
      }
      
      private function update(currentTxt:FilterFrameText, title:String, current:int, total:int, content:String) : void
      {
         var crntTxt:FilterFrameText = this._currentTxt;
         this._currentTxt = currentTxt;
         this._container.addChild(this._currentTxt);
         this._title.text = title;
         this._currentTxt.text = String(current);
         this._totalTxt.text = "/" + String(total);
         this._contentTxt.text = content;
         this.drawBG();
         if(crntTxt != null && crntTxt != this._currentTxt && Boolean(crntTxt.parent))
         {
            crntTxt.parent.removeChild(crntTxt);
         }
      }
      
      private function reset() : void
      {
         this._bg.height = 0;
         this._bg.width = 0;
      }
      
      private function drawBG($width:int = 0) : void
      {
         this.reset();
         if($width == 0)
         {
            this._bg.width = this._container.width + 10;
            this._bg.height = this._container.height + 10;
         }
         else
         {
            this._bg.width = $width + 2;
            this._bg.height = this._container.height + 10;
         }
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(w:int) : void
      {
      }
      
      public function get tipHeight() : int
      {
         return 0;
      }
      
      public function set tipHeight(h:int) : void
      {
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._currentTxt))
         {
            ObjectUtils.disposeObject(this._currentTxt);
         }
         this._currentTxt = null;
         if(Boolean(this._totalTxt))
         {
            ObjectUtils.disposeObject(this._totalTxt);
         }
         this._totalTxt = null;
         if(Boolean(this._contentTxt))
         {
            ObjectUtils.disposeObject(this._contentTxt);
         }
         this._contentTxt = null;
         if(Boolean(this._container))
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

