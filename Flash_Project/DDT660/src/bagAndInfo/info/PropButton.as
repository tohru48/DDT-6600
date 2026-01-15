package bagAndInfo.info
{
   import bagAndInfo.tips.CharacterPropTxtTipInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.Directions;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PropButton extends Sprite implements Disposeable, ITipedDisplay
   {
      
      protected var _back:DisplayObject;
      
      protected var _tipGapH:int = 0;
      
      protected var _tipGapV:int = 0;
      
      protected var _tipDirection:String = Directions.DIRECTION_BR + "," + Directions.DIRECTION_TR + "," + Directions.DIRECTION_BL + "," + Directions.DIRECTION_TL;
      
      protected var _tipStyle:String = "core.PropTxtTips";
      
      protected var _tipData:CharacterPropTxtTipInfo = new CharacterPropTxtTipInfo();
      
      public function PropButton()
      {
         super();
         mouseChildren = false;
         this.addChildren();
      }
      
      protected function addChildren() : void
      {
         if(!this._back)
         {
            this._back = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.background_propbutton");
            addChild(this._back);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get color() : int
      {
         return this._tipData.color;
      }
      
      public function set color(val:int) : void
      {
         this._tipData.color = val;
      }
      
      public function get property() : String
      {
         return this._tipData.property;
      }
      
      public function set property(val:String) : void
      {
         this._tipData.property = "[" + val + "]";
      }
      
      public function get detail() : String
      {
         return this._tipData.detail;
      }
      
      public function set detail(val:String) : void
      {
         this._tipData.detail = val;
      }
      
      public function get propertySource() : String
      {
         return this._tipData.propertySource;
      }
      
      public function set propertySource(val:String) : void
      {
         this._tipData.propertySource = val;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value as CharacterPropTxtTipInfo;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirection;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirection = value;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

