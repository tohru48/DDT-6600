package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class ChatFaceTip extends Sprite implements Disposeable, ITip
   {
      
      private var _minW:int;
      
      private var _minH:int;
      
      private var tip_txt:FilterFrameText;
      
      private var _tempData:Object;
      
      public function ChatFaceTip()
      {
         super();
         this.tip_txt = ComponentFactory.Instance.creat("core.ChatFaceTxt");
         this.tip_txt.border = true;
         this.tip_txt.background = true;
         this.tip_txt.backgroundColor = 16777215;
         this.tip_txt.borderColor = 3355443;
         this.tip_txt.mouseEnabled = false;
         this._minW = this.tip_txt.width;
         this.mouseChildren = false;
         this.init();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this.tip_txt);
         this.tip_txt = null;
         ObjectUtils.disposeObject(this);
      }
      
      public function get tipData() : Object
      {
         return this._tempData;
      }
      
      public function set tipData(data:Object) : void
      {
         if(data is String && data != "")
         {
            this.tip_txt.width = this.updateW(String(data));
            this.tip_txt.text = String(data);
            this.visible = true;
         }
         else
         {
            this.visible = false;
         }
         this._tempData = data;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function init() : void
      {
         addChild(this.tip_txt);
      }
      
      private function updateW(data:String) : int
      {
         var txt:TextField = new TextField();
         txt.autoSize = TextFieldAutoSize.LEFT;
         txt.text = data;
         if(txt.width < this._minW)
         {
            return this._minW;
         }
         return int(txt.width + 8);
      }
   }
}

