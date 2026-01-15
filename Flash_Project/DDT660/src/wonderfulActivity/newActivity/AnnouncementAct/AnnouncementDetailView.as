package wonderfulActivity.newActivity.AnnouncementAct
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class AnnouncementDetailView extends Sprite implements Disposeable
   {
      
      private var _timeField:FilterFrameText;
      
      private var _awardField:FilterFrameText;
      
      private var _contentField:FilterFrameText;
      
      private var _timeTitle:FilterFrameText;
      
      private var _awardTitle:FilterFrameText;
      
      private var _contentTitle:FilterFrameText;
      
      private var _timeWidth:int;
      
      private var _awardWidth:int;
      
      private var _contentWidth:int;
      
      private var _time:DisplayObject;
      
      private var _award:DisplayObject;
      
      private var _content:DisplayObject;
      
      private var _input:DisplayObject;
      
      private var _lines:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private var _hasKey:int;
      
      private var _activityInfo:GmActivityInfo;
      
      public function AnnouncementDetailView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._timeTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.TimeFieldTitle");
         this._timeTitle.text = LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.TimeFieldTitle");
         addChild(this._timeTitle);
         this._awardTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.AwardFieldTitle");
         this._awardTitle.text = LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.AwardFieldTitle");
         addChild(this._awardTitle);
         this._contentTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.ContentFieldTitle");
         this._contentTitle.text = LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.ContentFieldTitle");
         addChild(this._contentTitle);
         this._timeField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.TimeField");
         this._timeWidth = this._timeField.width;
         addChild(this._timeField);
         this._awardField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.AwardField");
         this._awardWidth = this._awardField.width;
         addChild(this._awardField);
         this._contentField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.StateContentField");
         this._contentWidth = this._contentField.width;
         addChild(this._contentField);
         var line:DisplayObject = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(line,"ddtcalendar.ActivityState.LinePos" + this._lines.length);
         this._lines.push(line);
         addChild(line);
         line = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(line,"ddtcalendar.ActivityState.LinePos" + this._lines.length);
         this._lines.push(line);
         addChild(line);
         this._time = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.TimeIcon");
         addChild(this._time);
         this._award = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.AwardIcon");
         addChild(this._award);
         this._content = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.ContentIcon");
         addChild(this._content);
      }
      
      public function setData(activityInfo:GmActivityInfo) : void
      {
         if(!activityInfo)
         {
            return;
         }
         this._activityInfo = activityInfo;
         this._awardField.y = this._award.y + this._award.height - 4;
         this._awardField.autoSize = "none";
         this._awardField.width = this._awardWidth;
         this._awardField.text = this._activityInfo.rewardDesc;
         this._awardField.autoSize = "left";
         this._awardTitle.x = this._award.x + this._award.width + 4;
         this._awardTitle.y = this._award.y;
         this._lines[0].y = this._awardField.y + this._awardField.height + 8;
         this._content.y = this._lines[0].y + this._lines[0].height + 4;
         this._contentField.y = this._content.y + this._content.height - 8;
         this._contentField.autoSize = "none";
         this._contentField.width = this._contentWidth;
         this._contentField.htmlText = this._activityInfo.desc;
         this._contentField.autoSize = "left";
         this._contentField.mouseEnabled = true;
         this._contentField.selectable = false;
         this._contentTitle.x = this._content.x + this._content.width + 4;
         this._contentTitle.y = this._content.y;
         this._lines[1].y = this._contentField.y + this._contentField.height + 8;
         this._timeField.y = this._lines[1].y + this._lines[1].height + 8;
         this._timeField.autoSize = "none";
         this._timeField.width = this._timeWidth;
         var timeArr:Array = [this._activityInfo.beginTime.split(" ")[0],this._activityInfo.endTime.split(" ")[0]];
         this._timeField.text = timeArr[0] + "-" + timeArr[1];
         this._timeField.autoSize = "left";
         this._time.y = this._timeField.y - 2;
         this._timeTitle.x = this._time.x + this._time.width + 4;
         this._timeTitle.y = this._time.y;
      }
      
      override public function get height() : Number
      {
         var h:int = 0;
         return int(this._timeField.y + this._timeField.height + 10);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._timeField);
         this._timeField = null;
         ObjectUtils.disposeObject(this._awardField);
         this._awardField = null;
         ObjectUtils.disposeObject(this._contentField);
         this._contentField = null;
         ObjectUtils.disposeObject(this._time);
         this._time = null;
         ObjectUtils.disposeObject(this._award);
         this._award = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._timeTitle);
         this._timeTitle = null;
         ObjectUtils.disposeObject(this._awardTitle);
         this._awardTitle = null;
         ObjectUtils.disposeObject(this._contentTitle);
         this._contentTitle = null;
         var line:DisplayObject = this._lines.shift();
         while(line != null)
         {
            ObjectUtils.disposeObject(line);
            line = null;
            line = this._lines.shift();
         }
         this._lines = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

