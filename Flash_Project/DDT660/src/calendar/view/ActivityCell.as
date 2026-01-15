package calendar.view
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ActivityCell extends Sprite implements Disposeable
   {
      
      private var _back:DisplayObject;
      
      private var _icon:DisplayObject;
      
      private var _titleField:FilterFrameText;
      
      private var _info:ActiveEventsInfo;
      
      private var _quanMC:MovieClip;
      
      private var _selected:Boolean = false;
      
      public function ActivityCell(info:ActiveEventsInfo)
      {
         super();
         this._info = info;
         buttonMode = true;
         this.configUI();
         this.addEvent();
      }
      
      public function get info() : ActiveEventsInfo
      {
         return this._info;
      }
      
      private function addEvent() : void
      {
      }
      
      private function __detailClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CalendarManager.getInstance().setState(this._info);
      }
      
      private function removeEvent() : void
      {
      }
      
      private function configUI() : void
      {
         var tempIndex:int = 0;
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellBg");
         DisplayUtils.setFrame(this._back,this._selected ? 2 : 1);
         addChild(this._back);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleText");
         this._titleField.htmlText = "<b>·</b> " + this._info.Title;
         if(this._titleField.textWidth > 90)
         {
            tempIndex = this._titleField.getCharIndexAtPoint(this._titleField.x + 86,this._titleField.y + 2);
            if(tempIndex != -1)
            {
               this._titleField.htmlText = "<b>·</b> " + this._info.Title.substring(0,tempIndex) + "...";
            }
         }
         addChild(this._titleField);
         if(!this._quanMC)
         {
            this._quanMC = ClassUtils.CreatInstance("asset.ddtActivity.MC");
            this._quanMC.mouseChildren = false;
            this._quanMC.mouseEnabled = false;
            this._quanMC.gotoAndPlay(1);
            this._quanMC.x = -5;
         }
         if(this._info.Type == 2)
         {
            this._quanMC.visible = true;
         }
         else
         {
            this._quanMC.visible = false;
         }
         this._icon = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleIcon");
         DisplayUtils.setFrame(this._icon,this.getActivityDispType(this._info.IconID));
         addChild(this._icon);
         addChild(this._quanMC);
      }
      
      private function getActivityDispType(pIconID:int) : int
      {
         var result:int = 0;
         switch(pIconID)
         {
            case 1:
               result = 1;
               break;
            case 2:
               result = 2;
               break;
            case 3:
               result = 3;
               break;
            case 4:
               result = 4;
               break;
            case 5:
               result = 5;
               break;
            case 6:
               result = 6;
               break;
            default:
               result = 5;
         }
         return result;
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
         DisplayUtils.setFrame(this._back,this._selected ? 2 : 1);
         DisplayUtils.setFrame(this._titleField,this._selected ? 2 : 1);
      }
      
      public function openCell() : void
      {
         this.__detailClick(null);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._titleField);
         this._titleField = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         if(Boolean(this._quanMC))
         {
            ObjectUtils.disposeObject(this._quanMC);
         }
         this._quanMC = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

