package growthPackage.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import growthPackage.GrowthPackageManager;
   import growthPackage.event.GrowthPackageEvent;
   
   public class GrowthPackageFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _explainTxt:FilterFrameText;
      
      private var _itemsSprite:Sprite;
      
      private var _items:Vector.<GrowthPackageItem>;
      
      public function GrowthPackageFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var item:GrowthPackageItem = null;
         titleText = LanguageMgr.GetTranslation("ddt.growthPackage.frameTitle");
         this._bg = ComponentFactory.Instance.creatBitmap("assets.growthPackage.FrameBg");
         addToContent(this._bg);
         this._explainTxt = ComponentFactory.Instance.creatComponentByStylename("growthPackage.explainTxt.text");
         this._explainTxt.text = LanguageMgr.GetTranslation("growthPackage.explainTxt.txt");
         addToContent(this._explainTxt);
         this._itemsSprite = new Sprite();
         addToContent(this._itemsSprite);
         this._items = new Vector.<GrowthPackageItem>();
         for(var i:int = 0; i < GrowthPackageManager.indexMax; i++)
         {
            item = new GrowthPackageItem(i);
            item.y = i * 54;
            this._itemsSprite.addChild(item);
            this._items.push(item);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         GrowthPackageManager.instance.model.addEventListener(GrowthPackageEvent.DATA_CHANGE,this.__dataChange);
      }
      
      private function __dataChange(evt:GrowthPackageEvent) : void
      {
         this.updateItems();
      }
      
      private function updateItems() : void
      {
         var i:int = 0;
         if(Boolean(this._items))
         {
            for(i = 0; i < this._items.length; i++)
            {
               this.updateItem(i);
            }
         }
      }
      
      private function updateItem(index:int) : void
      {
         var tempItem:GrowthPackageItem = GrowthPackageItem(this._items[index]);
         tempItem.updateState();
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         GrowthPackageManager.instance.model.removeEventListener(GrowthPackageEvent.DATA_CHANGE,this.__dataChange);
      }
      
      override public function dispose() : void
      {
         var i:int = 0;
         var tempItem:GrowthPackageItem = null;
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._explainTxt);
         this._explainTxt = null;
         if(Boolean(this._items))
         {
            for(i = 0; i < this._items.length; i++)
            {
               tempItem = this._items[i];
               ObjectUtils.disposeObject(tempItem);
            }
            this._items = null;
         }
         if(Boolean(this._itemsSprite))
         {
            ObjectUtils.disposeAllChildren(this._itemsSprite);
            ObjectUtils.disposeObject(this._itemsSprite);
            this._itemsSprite = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

