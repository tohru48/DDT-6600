package auctionHouse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class BrowserLeftStripAsset extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _icon:ScaleFrameImage;
      
      private var _filterTextImage:ScaleFrameImage;
      
      protected var _type_txt:GradientText;
      
      public function BrowserLeftStripAsset(img:ScaleFrameImage)
      {
         super();
         this._filterTextImage = img;
         this.initView();
      }
      
      public function set selectState(value:Boolean) : void
      {
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripBG");
         addChild(this._bg);
         this._icon = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripIcon");
         this._type_txt = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripTextFilt");
         addChild(this._type_txt);
         addChild(this._filterTextImage);
      }
      
      public function set bg(value:ScaleFrameImage) : void
      {
         this._bg = value;
      }
      
      public function set icon(value:ScaleFrameImage) : void
      {
         this._icon = value;
      }
      
      public function set type_txt(value:GradientText) : void
      {
         this._type_txt = value;
      }
      
      public function get bg() : ScaleFrameImage
      {
         return this._bg;
      }
      
      public function get icon() : ScaleFrameImage
      {
         return this._icon;
      }
      
      public function get type_txt() : GradientText
      {
         return this._type_txt;
      }
      
      public function setFrameOnImage(index:int) : void
      {
         if(Boolean(this._filterTextImage))
         {
            this._filterTextImage.setFrame(index);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._icon))
         {
            ObjectUtils.disposeObject(this._icon);
         }
         this._icon = null;
         if(Boolean(this._type_txt))
         {
            ObjectUtils.disposeObject(this._type_txt);
         }
         this._type_txt = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function set type_text(str:String) : void
      {
      }
      
      public function set type_text1(str:String) : void
      {
      }
   }
}

