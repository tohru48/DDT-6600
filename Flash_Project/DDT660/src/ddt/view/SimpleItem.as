package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   
   public class SimpleItem extends Component
   {
      
      public static const P_backStyle:String = "backStyle";
      
      public static const P_foreStyle:String = "foreStyle";
      
      private var _backStyle:String;
      
      private var _foreStyle:String;
      
      private var _back:DisplayObject;
      
      private var _fore:Vector.<DisplayObject>;
      
      private var _foreLinks:Array;
      
      public function SimpleItem()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._fore = new Vector.<DisplayObject>();
         this._foreLinks = new Array();
         super.init();
      }
      
      public function set backStyle(stylename:String) : void
      {
         if(stylename == this._backStyle)
         {
            return;
         }
         this._backStyle = stylename;
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = ComponentFactory.Instance.creat(this._backStyle);
         onPropertiesChanged(P_backStyle);
      }
      
      public function set foreStyle(stylename:String) : void
      {
         if(stylename == this._foreStyle)
         {
            return;
         }
         this._foreStyle = stylename;
         this.clearObject();
         this._foreLinks = ComponentFactory.parasArgs(stylename);
         onPropertiesChanged(P_foreStyle);
      }
      
      private function clearObject() : void
      {
         for(var i:int = 0; i < this._foreLinks.length; i++)
         {
            if(Boolean(this._foreLinks[i]))
            {
               ObjectUtils.disposeObject(this._foreLinks[i]);
            }
         }
      }
      
      private function createObject() : void
      {
         var dp:DisplayObject = null;
         for(var i:int = 0; i < this._foreLinks.length; i++)
         {
            dp = ComponentFactory.Instance.creat(this._foreLinks[i]);
            this._fore.push(dp);
         }
      }
      
      public function get foreItems() : Vector.<DisplayObject>
      {
         return this._fore;
      }
      
      public function get backItem() : DisplayObject
      {
         return this._back;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._back))
         {
            addChild(this._back);
         }
         for(var i:int = 0; i < this._fore.length; i++)
         {
            addChild(this._fore[i]);
         }
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(Boolean(_changedPropeties[P_backStyle]))
         {
            if(Boolean(this._back) && (this._back.width > 0 || this._back.height > 0))
            {
               _width = this._back.width;
               _height = this._back.height;
            }
         }
         if(Boolean(_changedPropeties[P_foreStyle]))
         {
            this.createObject();
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         for(var i:int = 0; i < this._fore.length; i++)
         {
            ObjectUtils.disposeObject(this._fore[i]);
            this._fore[i] = null;
         }
         this._foreLinks = null;
         super.dispose();
      }
   }
}

