package store.view.embed
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class EmbedStoneTip extends GoodTip
   {
      
      public static const P_backgoundInnerRect:String = "backOutterRect";
      
      public static const P_tipTextField:String = "tipTextField";
      
      protected var _backInnerRect:InnerRectangle;
      
      protected var _backgoundInnerRectString:String;
      
      protected var _tipTextField:TextField;
      
      protected var _tipTextStyle:String;
      
      private var _currentData:Object;
      
      public function EmbedStoneTip()
      {
         super();
      }
      
      public function set backgoundInnerRectString(value:String) : void
      {
         if(this._backgoundInnerRectString == value)
         {
            return;
         }
         this._backgoundInnerRectString = value;
         this._backInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._backgoundInnerRectString));
         onPropertiesChanged(P_backgoundInnerRect);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._tipTextField))
         {
            ObjectUtils.disposeObject(this._tipTextField);
         }
         this._tipTextField = null;
         super.dispose();
      }
      
      public function set tipTextField(field:TextField) : void
      {
         if(this._tipTextField == field)
         {
            return;
         }
         ObjectUtils.disposeObject(this._tipTextField);
         this._tipTextField = field;
         onPropertiesChanged(P_tipTextField);
      }
      
      public function set tipTextStyle(stylename:String) : void
      {
         if(this._tipTextStyle == stylename)
         {
            return;
         }
         this._tipTextStyle = stylename;
         this.tipTextField = ComponentFactory.Instance.creat(this._tipTextStyle);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._tipTextField))
         {
            addChild(this._tipTextField);
         }
         if(_tipData is DisplayObject)
         {
            addChild(_tipData as DisplayObject);
         }
      }
      
      override public function get tipData() : Object
      {
         return this._currentData;
      }
      
      override public function set tipData(data:Object) : void
      {
         var rectangle:Rectangle = null;
         var obj:GoodTipInfo = null;
         if(Boolean(data as String))
         {
            if(data is String)
            {
               this._tipTextField.wordWrap = false;
               this._tipTextField.text = String(data);
               rectangle = this._backInnerRect.getInnerRect(this._tipTextField.width,this._tipTextField.height);
               _width = _tipbackgound.width = rectangle.width;
               _height = _tipbackgound.height = rectangle.height;
            }
            else if(data is Array)
            {
               this._tipTextField.wordWrap = true;
               this._tipTextField.width = int(data[1]);
               this._tipTextField.text = String(data[0]);
               rectangle = this._backInnerRect.getInnerRect(this._tipTextField.width,this._tipTextField.height);
               _width = _tipbackgound.width = rectangle.width;
               _height = _tipbackgound.height = rectangle.height;
            }
            visible = true;
            this._tipTextField.x = this._backInnerRect.para1;
            this._tipTextField.y = this._backInnerRect.para3;
            this._currentData = data;
         }
         else if(Boolean(data as GoodTipInfo))
         {
            obj = data as GoodTipInfo;
            this._currentData = obj;
            showTip(obj.itemInfo,obj.typeIsSecond);
            visible = true;
         }
         else
         {
            visible = false;
            this._currentData = null;
         }
      }
   }
}

