package wonderfulActivity.items
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class LimitActView extends Sprite implements Disposeable
   {
      
      private var _info:ActiveEventsInfo;
      
      private var _time:Bitmap;
      
      private var _award:Bitmap;
      
      private var _content:Bitmap;
      
      private var _input:Bitmap;
      
      private var _titleBack:Bitmap;
      
      private var _inputField:TextInput;
      
      private var _timeTitle:FilterFrameText;
      
      private var _awardTitle:FilterFrameText;
      
      private var _contentTitle:FilterFrameText;
      
      private var _timeField:FilterFrameText;
      
      private var _timeWidth:int;
      
      private var _back:MutipleImage;
      
      private var _titleField:FilterFrameText;
      
      private var _line1:Bitmap;
      
      private var _line2:Bitmap;
      
      private var _line3:Bitmap;
      
      private var _awardField:FilterFrameText;
      
      private var _awardWidth:int;
      
      private var _contentField:FilterFrameText;
      
      private var _contentWidth:int;
      
      public function LimitActView(info:ActiveEventsInfo)
      {
         this._info = info;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._award = ComponentFactory.Instance.creatBitmap("asset.wonderful.ActivityState.AwardIcon");
         this._award.x = 30;
         this._award.y = 3;
         addChild(this._award);
         this._awardTitle = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.AwardFieldTitle");
         this._awardTitle.text = LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.AwardFieldTitle");
         this._awardTitle.x = this._award.x + this._award.width + 10;
         this._awardTitle.y = this._award.y;
         addChild(this._awardTitle);
         this._awardField = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.AwardField");
         this._awardWidth = this._awardField.width;
         this._awardField.x = this._awardTitle.x;
         this._awardField.y = this._awardTitle.y + this._awardTitle.height + 5;
         this._awardField.autoSize = "none";
         this._awardField.width = this._awardWidth;
         this._awardField.autoSize = "left";
         this._awardField.htmlText = this._info.AwardContent;
         this._awardField.mouseEnabled = true;
         this._awardField.selectable = false;
         addChild(this._awardField);
         this._line1 = ComponentFactory.Instance.creat("asset.wonderful.ActivityState.SeparatorLine");
         this._line1.x = 10;
         this._line1.y = this._awardField.y + this._awardField.height + 5;
         addChild(this._line1);
         this._content = ComponentFactory.Instance.creatBitmap("asset.wonderful.ActivityState.ContentIcon");
         this._content.x = 30;
         this._content.y = this._line1.y + this._line1.height + 10;
         addChild(this._content);
         this._contentTitle = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.ContentFieldTitle");
         this._contentTitle.text = LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.ContentFieldTitle");
         this._contentTitle.x = this._content.x + this._content.width + 10;
         this._contentTitle.y = this._content.y;
         addChild(this._contentTitle);
         this._contentField = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.StateContentField");
         this._contentWidth = this._contentField.width;
         this._contentField.x = this._contentTitle.x;
         this._contentField.y = this._contentTitle.y + this._contentTitle.height + 5;
         this._contentField.autoSize = "none";
         this._contentField.width = this._contentWidth;
         this._contentField.autoSize = "left";
         this._contentField.htmlText = this._info.Content;
         this._contentField.mouseEnabled = true;
         this._contentField.selectable = false;
         addChild(this._contentField);
         this._line2 = ComponentFactory.Instance.creat("asset.wonderful.ActivityState.SeparatorLine");
         if(this._info.HasKey == 1)
         {
            this._input = ComponentFactory.Instance.creatBitmap("aaset.wonderful.ActivityState.Pwd");
            this._input.x = this._contentTitle.x;
            this._input.y = this._contentField.y + this._contentField.height + 10;
            addChild(this._input);
            this._inputField = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.InputField");
            this._inputField.x = this._input.x + this._input.width + 5;
            this._inputField.y = this._input.y - 5;
            addChild(this._inputField);
            this._line2.x = this._line1.x;
            this._line2.y = this._inputField.y + this._inputField.height + 5;
         }
         else
         {
            this._line2.x = this._line1.x;
            this._line2.y = this._contentField.y + this._contentField.height + 5;
         }
         addChild(this._line2);
         this._time = ComponentFactory.Instance.creatBitmap("asset.wonderful.ActivityState.TimeIcon");
         this._time.x = 30;
         this._time.y = this._line2.y + this._line2.height + 10;
         addChild(this._time);
         this._timeTitle = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.TimeFieldTitle");
         this._timeTitle.x = this._time.x + this._time.width + 10;
         this._timeTitle.y = this._time.y;
         this._timeTitle.text = LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.TimeFieldTitle");
         addChild(this._timeTitle);
         this._timeField = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.TimeField");
         this._timeWidth = this._timeField.width;
         this._timeField.x = this._timeTitle.x;
         this._timeField.y = this._timeTitle.y + this._timeTitle.height + 5;
         this._timeField.autoSize = "none";
         this._timeField.width = this._timeWidth;
         this._timeField.text = this._info.activeTime();
         addChild(this._timeField);
         this._line3 = ComponentFactory.Instance.creat("asset.wonderful.ActivityState.SeparatorLine");
         this._line3.x = this._line1.x;
         this._line3.y = this._timeField.y + this._timeField.height + 5;
         addChild(this._line3);
      }
      
      public function getInputField() : TextInput
      {
         return this._inputField;
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

