package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestCondition;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class QuestConditionView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _cond:QuestCondition;
      
      private var conditionText:FilterFrameText;
      
      private var statusText:FilterFrameText;
      
      public function QuestConditionView(condition:QuestCondition)
      {
         super();
         this._bg = ComponentFactory.Instance.creat("asset.core.quest.QuestConditionBGHighlight");
         addChild(this._bg);
         this.conditionText = ComponentFactory.Instance.creat("core.quest.QuestConditionText");
         addChild(this.conditionText);
         this.statusText = ComponentFactory.Instance.creat("core.quest.QuestConditionStatus");
         addChild(this.statusText);
         this._cond = condition;
         this.text = this._cond.description;
      }
      
      public function set status(value:String) : void
      {
         this.statusText.text = value;
      }
      
      public function set text(value:String) : void
      {
         this.conditionText.text = value;
         this.statusText.x = this.conditionText.x + this.conditionText.width + 2;
      }
      
      public function set isComplete(value:Boolean) : void
      {
         if(value == true)
         {
         }
      }
      
      override public function get height() : Number
      {
         return 35;
      }
      
      public function dispose() : void
      {
         this._cond = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this.conditionText))
         {
            ObjectUtils.disposeObject(this.conditionText);
         }
         this.conditionText = null;
         if(Boolean(this.statusText))
         {
            ObjectUtils.disposeObject(this.statusText);
         }
         this.statusText = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

