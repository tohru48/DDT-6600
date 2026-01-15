package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PetsFormItemsTip extends Sprite implements ITransformableTip
   {
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _title:FilterFrameText;
      
      protected var _data:Object;
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      private var _rule:ScaleBitmapImage;
      
      private var _itemVec:Vector.<PetsFormItemsTipItem>;
      
      public function PetsFormItemsTip()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         var item:PetsFormItemsTipItem = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsTip.bg");
         addChild(this._bg);
         this._title = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsTip.titleTxt");
         addChild(this._title);
         this._rule = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule.width = this._bg.width;
         addChild(this._rule);
         PositionUtils.setPos(this._rule,"hall.tip.rule.pos");
         this._itemVec = new Vector.<PetsFormItemsTipItem>();
         for(var i:int = 1; i < 5; i++)
         {
            item = new PetsFormItemsTipItem(i);
            addChild(item);
            this._itemVec.push(item);
         }
      }
      
      public function get tipData() : Object
      {
         return this._data;
      }
      
      public function set tipData(data:Object) : void
      {
         if(data != null)
         {
            this._data = data;
            this._title.text = this._data["title"];
            this._itemVec[0].isActive = this._data["isActive"];
            this._itemVec[0].value = this._data["state"];
            this._itemVec[1].value = this._data["activeValue"];
            this._itemVec[2].value = this._data["propertyValue"];
            this._itemVec[3].value = this._data["getValue"];
         }
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
         var item:PetsFormItemsTipItem = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._rule);
         this._rule = null;
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

