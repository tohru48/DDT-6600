package horse.horsePicCherish
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.SimpleItem;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class HorsePicCherishTip extends Sprite implements ITransformableTip
   {
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _typeItem:SimpleItem;
      
      protected var _title:FilterFrameText;
      
      private var _rule:ScaleBitmapImage;
      
      protected var _data:Object;
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      private var _vBox:VBox;
      
      private var _itemVec:Vector.<HorsePicCherishTipItem>;
      
      public function HorsePicCherishTip()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         var item:HorsePicCherishTipItem = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         this._title = ComponentFactory.Instance.creatComponentByStylename("horsePicCherish.titleTxt");
         this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
         this._rule = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         addChild(this._bg);
         addChild(this._title);
         addChild(this._typeItem);
         addChild(this._rule);
         this._itemVec = new Vector.<HorsePicCherishTipItem>();
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("horsePicCherish.vBox");
         for(var i:int = 1; i < 5; i++)
         {
            item = new HorsePicCherishTipItem(i);
            this._vBox.addChild(item);
            this._itemVec.push(item);
         }
         addChild(this._vBox);
         PositionUtils.setPos(this._typeItem,"horsePicCherish.typeItem.pos");
         PositionUtils.setPos(this._rule,"hall.tip.rule.pos");
      }
      
      public function get tipData() : Object
      {
         return this._data;
      }
      
      public function set tipData(data:Object) : void
      {
         var fft:FilterFrameText = null;
         if(data != null)
         {
            this._data = data;
            fft = this._typeItem.foreItems[0] as FilterFrameText;
            fft.text = this._data["type"];
            this._title.text = this._data["title"];
            this._itemVec[0].isActive = this._data["isActive"];
            this._itemVec[0].value = this._data["state"];
            this._itemVec[1].value = this._data["activeValue"];
            this._itemVec[2].value = this._data["propertyValue"];
            this._itemVec[3].value = this._data["getValue"];
            this.update();
         }
      }
      
      private function update() : void
      {
         this._vBox.arrange();
         this._bg.width = this._vBox.width + 20;
         this._bg.height = this._vBox.y + this._vBox.height + 10;
         this._rule.width = this._bg.width - 10;
      }
      
      public function get tipWidth() : int
      {
         return this._tipWidth;
      }
      
      public function set tipWidth(w:int) : void
      {
         this._tipWidth = w;
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
         var item:HorsePicCherishTipItem = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._typeItem);
         this._typeItem = null;
         ObjectUtils.disposeObject(this._rule);
         this._rule = null;
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
         for each(item in this._itemVec)
         {
            ObjectUtils.disposeObject(item);
            item = null;
         }
         this._itemVec = null;
         this._data = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

