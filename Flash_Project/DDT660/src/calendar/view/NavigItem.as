package calendar.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class NavigItem extends Sprite implements Disposeable
   {
      
      private var _back:DisplayObject;
      
      private var _textField:FilterFrameText;
      
      private var _count:int;
      
      private var _selected:Boolean = false;
      
      private var _received:Boolean = false;
      
      public function NavigItem(count:int)
      {
         super();
         this._count = count;
         mouseChildren = false;
         buttonMode = true;
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.NavigBack");
         scaleY = 0.9;
         this._back.scaleX = 0.9;
         DisplayUtils.setFrame(this._back,1);
         addChildAt(this._back,0);
         this._textField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.AwardCountField");
         this._textField.text = this._count.toString() + LanguageMgr.GetTranslation("tank.calendar.award.NagivCount");
         addChild(this._textField);
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         if(this._selected)
         {
            this._textField.setFrame(2);
            DisplayUtils.setFrame(this._back,2);
         }
         else if(!this._received)
         {
            this._textField.setFrame(1);
            DisplayUtils.setFrame(this._back,1);
         }
      }
      
      public function get received() : Boolean
      {
         return this._received;
      }
      
      public function set received(value:Boolean) : void
      {
         if(this._received == value)
         {
            return;
         }
         this._received = value;
         mouseEnabled = !this._received;
         if(this._received)
         {
            DisplayUtils.setFrame(this._back,3);
         }
         else if(this._selected)
         {
            DisplayUtils.setFrame(this._back,2);
         }
         else
         {
            DisplayUtils.setFrame(this._back,1);
         }
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._textField);
         this._textField = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

