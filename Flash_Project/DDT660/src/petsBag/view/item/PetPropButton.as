package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.view.tips.PropTxtTipInfo;
   import flash.text.TextFormat;
   
   public class PetPropButton extends Component
   {
      
      private var _propName:FilterFrameText;
      
      private var _propValue:FilterFrameText;
      
      protected var _tipInfo:PropTxtTipInfo;
      
      private var _currentPropValue:int;
      
      private var _addedPropValue:int;
      
      public function PetPropButton()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._propName = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.propName");
         addChild(this._propName);
         this._propValue = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.propValue");
         addChild(this._propValue);
         this._propName.mouseEnabled = false;
         this._propValue.mouseEnabled = false;
         this._tipInfo = new PropTxtTipInfo();
      }
      
      public function set propName(name:String) : void
      {
         this._propName.text = name;
         this.fixPos();
      }
      
      public function set propValue(value:int) : void
      {
         this._propValue.text = value.toString();
         this.fixPos();
      }
      
      public function set propColor(value:int) : void
      {
         var format:TextFormat = this._propValue.getTextFormat();
         format.color = value;
         this._propValue.setTextFormat(format);
      }
      
      public function set valueFilterString(index:int) : void
      {
         this._propValue.setFrame(index);
      }
      
      private function fixPos() : void
      {
         this._propValue.x = 77;
      }
      
      override public function get tipStyle() : String
      {
         return "core.PropTxtTips";
      }
      
      override public function get tipData() : Object
      {
         return this._tipInfo;
      }
      
      public function get color() : int
      {
         return this._tipInfo.color;
      }
      
      public function set color(val:int) : void
      {
         this._tipInfo.color = val;
      }
      
      public function get property() : String
      {
         return this._tipInfo.property;
      }
      
      public function set property(val:String) : void
      {
         this._tipInfo.property = "[" + val + "] " + this._currentPropValue + "+" + this._addedPropValue + "（" + LanguageMgr.GetTranslation("petsBag.petPropButtonTipSignTxt") + "）";
      }
      
      public function get currentPropValue() : int
      {
         return this._currentPropValue;
      }
      
      public function set currentPropValue(value:int) : void
      {
         this._currentPropValue = value;
      }
      
      public function get addedPropValue() : int
      {
         return this._addedPropValue;
      }
      
      public function set addedPropValue(value:int) : void
      {
         this._addedPropValue = value;
      }
      
      public function get detail() : String
      {
         return this._tipInfo.detail;
      }
      
      public function set detail(val:String) : void
      {
         this._tipInfo.detail = val;
      }
      
      override public function dispose() : void
      {
         this._tipInfo = null;
         ObjectUtils.disposeObject(this._propName);
         this._propName = null;
         ObjectUtils.disposeObject(this._propValue);
         this._propValue = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

