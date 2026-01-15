package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import road7th.utils.StringHelper;
   
   public class KingBlessTip extends Sprite implements ITransformableTip
   {
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _title:FilterFrameText;
      
      protected var _contentTxt:FilterFrameText;
      
      protected var _notOpenContentTxt:FilterFrameText;
      
      protected var _bottomTxt:FilterFrameText;
      
      protected var _data:Object;
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      private var isOpen:Boolean = false;
      
      private var isSelf:Boolean;
      
      public function KingBlessTip()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         this._title = ComponentFactory.Instance.creatComponentByStylename("hall.kingBlessTips.title");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("hall.kingBlessTips.commonText");
         this._notOpenContentTxt = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
         this._bottomTxt = ComponentFactory.Instance.creatComponentByStylename("hall.kingBlessTips.bottomText");
         addChild(this._bg);
         addChild(this._title);
         addChild(this._contentTxt);
         addChild(this._notOpenContentTxt);
         addChild(this._bottomTxt);
      }
      
      public function get tipData() : Object
      {
         return this._data;
      }
      
      public function set tipData(data:Object) : void
      {
         if(Boolean(data))
         {
            this._data = data;
            if(this._data.hasOwnProperty("isOpen"))
            {
               this.isOpen = this._data["isOpen"];
            }
            if(this._data.hasOwnProperty("isSelf"))
            {
               this.isSelf = this._data["isSelf"];
            }
            if(this.isOpen && this.isSelf)
            {
               this._bottomTxt.visible = this._title.visible = this._contentTxt.visible = true;
               this._notOpenContentTxt.visible = false;
               this._title.text = this._data["title"];
               this._contentTxt.text = StringHelper.trim(String(this._data["content"]));
               this._bottomTxt.text = this._data["bottom"];
            }
            else
            {
               this._bottomTxt.visible = this._title.visible = this._contentTxt.visible = false;
               this._notOpenContentTxt.visible = true;
               this._notOpenContentTxt.text = StringHelper.trim(String(this._data["content"]));
            }
            this.updateTransform();
         }
      }
      
      protected function updateTransform() : void
      {
         if(this.isOpen && this.isSelf)
         {
            this._contentTxt.x = this._bg.x + 8;
            this._contentTxt.y = 4 + this._title.height;
            this._bg.width = Math.max(this._title.width,this._contentTxt.width,this._bottomTxt.width) + 20;
            this._bg.height = this._contentTxt.y + this._contentTxt.textHeight + this._bottomTxt.height + 10;
            this._bottomTxt.x = this._contentTxt.x;
            this._bottomTxt.y = this._contentTxt.y + this._contentTxt.textHeight + 4;
         }
         else
         {
            this._bg.width = this._notOpenContentTxt.width + 16;
            this._bg.height = this._notOpenContentTxt.height + 8;
            this._notOpenContentTxt.x = this._bg.x + 8;
            this._notOpenContentTxt.y = this._bg.y + 4;
         }
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
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._contentTxt))
         {
            ObjectUtils.disposeObject(this._contentTxt);
         }
         this._contentTxt = null;
         if(Boolean(this._notOpenContentTxt))
         {
            ObjectUtils.disposeObject(this._notOpenContentTxt);
         }
         this._notOpenContentTxt = null;
         if(Boolean(this._bottomTxt))
         {
            ObjectUtils.disposeObject(this._bottomTxt);
         }
         this._bottomTxt = null;
         this._data = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

