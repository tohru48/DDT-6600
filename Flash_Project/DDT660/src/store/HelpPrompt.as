package store
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   
   public class HelpPrompt extends Component
   {
      
      private var _bg9Scale:Scale9CornerImage;
      
      public var bg9ScalseStyle:String;
      
      public var contentStyle:String;
      
      private var contentArr:Array;
      
      public function HelpPrompt()
      {
         super();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         var content:DisplayObject = null;
         super.onProppertiesUpdate();
         this._bg9Scale = ComponentFactory.Instance.creat(this.bg9ScalseStyle);
         addChild(this._bg9Scale);
         var styleArr:Array = this.contentStyle.split(/,/g);
         this.contentArr = new Array();
         for(var i:int = 0; i < styleArr.length; i++)
         {
            content = ComponentFactory.Instance.creat(styleArr[i]);
            addChild(content);
            this.contentArr.push(content);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bg9Scale))
         {
            ObjectUtils.disposeObject(this._bg9Scale);
         }
         this._bg9Scale = null;
         for(var i:int = 0; i < this.contentArr.length; i++)
         {
            ObjectUtils.disposeObject(this.contentArr[i]);
            this.contentArr[i] = null;
         }
         this.contentArr = null;
      }
   }
}

