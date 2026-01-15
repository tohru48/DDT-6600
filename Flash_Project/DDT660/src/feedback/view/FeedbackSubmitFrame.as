package feedback.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import feedback.FeedbackManager;
   import feedback.data.FeedbackInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import road7th.utils.DateUtils;
   
   public class FeedbackSubmitFrame extends BaseAlerFrame
   {
      
      private var _box:Sprite;
      
      private var _dayCombox:ComboBox;
      
      private var _dayTextImg:FilterFrameText;
      
      private var _feedbackSp:Disposeable;
      
      private var _monthCombox:ComboBox;
      
      private var _monthTextImg:FilterFrameText;
      
      private var _occurrenceTimeTextImg:FilterFrameText;
      
      private var _problemCombox:ComboBox;
      
      private var _problemTitleAsterisk:Bitmap;
      
      private var _problemTitleInput:TextInput;
      
      private var _problemTitleTextImg:FilterFrameText;
      
      private var _problemTypesAsterisk:Bitmap;
      
      private var _problemTypesTextImg:FilterFrameText;
      
      private var _yearCombox:ComboBox;
      
      private var _yearTextImg:FilterFrameText;
      
      private var _feedbackBg:ScaleBitmapImage;
      
      public function FeedbackSubmitFrame()
      {
         super();
         this._init();
      }
      
      public function get problemCombox() : ComboBox
      {
         return this._problemCombox;
      }
      
      public function get problemTitleInput() : TextInput
      {
         return this._problemTitleInput;
      }
      
      override public function dispose() : void
      {
         this.remvoeEvent();
         if(Boolean(this._feedbackSp))
         {
            this._feedbackSp.dispose();
         }
         ObjectUtils.disposeAllChildren(this._box);
         ObjectUtils.disposeObject(this._box);
         this._box = null;
         ObjectUtils.disposeAllChildren(this._feedbackSp as Sprite);
         this._feedbackSp = null;
         ObjectUtils.disposeAllChildren(this);
         this._problemTypesTextImg = null;
         this._problemCombox = null;
         this._problemTitleTextImg = null;
         this._problemTypesAsterisk = null;
         this._problemTitleInput = null;
         this._problemTitleAsterisk = null;
         this._occurrenceTimeTextImg = null;
         this._yearCombox = null;
         this._yearTextImg = null;
         this._monthCombox = null;
         this._monthTextImg = null;
         this._dayCombox = null;
         this._dayTextImg = null;
         this._feedbackBg = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get feedbackInfo() : FeedbackInfo
      {
         FeedbackManager.instance.feedbackInfo.user_id = PlayerManager.Instance.Self.ID;
         FeedbackManager.instance.feedbackInfo.user_name = PlayerManager.Instance.Self.LoginName;
         FeedbackManager.instance.feedbackInfo.user_nick_name = PlayerManager.Instance.Self.NickName;
         if(Boolean(this._problemCombox))
         {
            FeedbackManager.instance.feedbackInfo.question_type = this._problemCombox.currentSelectedIndex + 1;
            FeedbackManager.instance.feedbackInfo.question_title = this._problemTitleInput.text;
            FeedbackManager.instance.feedbackInfo.occurrence_date = this._yearCombox.textField.text + "-" + this._monthCombox.textField.text + "-" + this._dayCombox.textField.text;
         }
         return FeedbackManager.instance.feedbackInfo;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               FeedbackManager.instance.closeFrame();
         }
      }
      
      private function __problemComboxChanged(event:Event) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._feedbackSp))
         {
            this._feedbackSp["setFeedbackInfo"]();
            this._feedbackSp.dispose();
         }
         this._feedbackSp = this.getFeedbackSp(this._problemCombox.currentSelectedIndex);
         if(Boolean(this._feedbackSp))
         {
            addToContent(this._box);
            addToContent(this._feedbackSp as Sprite);
            this.fixFeedBackTopImg(this._problemCombox.currentSelectedIndex);
         }
      }
      
      private function fixFeedBackTopImg($type:int) : void
      {
         switch($type)
         {
            case 0:
            case 5:
            case 6:
            case 9:
               this._feedbackBg.height = 120;
               break;
            case 1:
               this._feedbackBg.height = 158;
               break;
            case 3:
               this._feedbackBg.height = 196;
               break;
            case 4:
               this._feedbackBg.height = 120;
               break;
            case 2:
               this._feedbackBg.height = 190;
               break;
            case 8:
               this._feedbackBg.height = 188;
               break;
            case 7:
               this._feedbackBg.height = 203;
               break;
            default:
               this._feedbackBg.height = 120;
         }
      }
      
      private function _init() : void
      {
         var rec:Rectangle = null;
         var i:uint = 0;
         titleText = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitFrame.title");
         this._feedbackSp = this.getFeedbackSp(0);
         addToContent(this._feedbackSp as Sprite);
         this._box = new Sprite();
         addToContent(this._box);
         this._problemTypesTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.typeText");
         this._problemTypesTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.problemTypesTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTypesTextImg,rec);
         this._box.addChildAt(this._problemTypesTextImg,0);
         this._problemCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.comboxRec");
         ObjectUtils.copyPropertyByRectangle(this._problemCombox,rec);
         this._problemCombox.beginChanges();
         this._problemCombox.selctedPropName = "text";
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text0"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text1"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text2"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text3"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text4"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text5"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text6"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text7"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text8"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text9"));
         this._problemCombox.commitChanges();
         this._problemCombox.textField.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.comBoxText");
         this._box.addChildAt(this._problemCombox,0);
         this._problemTypesAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.problemTypesAsteriskTextRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTypesAsterisk,rec);
         this._box.addChildAt(this._problemTypesAsterisk,0);
         this._problemTitleTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.titleText");
         this._problemTitleTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text1");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleTextImg,rec);
         this._box.addChildAt(this._problemTitleTextImg,0);
         this._problemTitleInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleInputRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleInput,rec);
         this._box.addChildAt(this._problemTitleInput,0);
         this._problemTitleAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleAsteriskTextRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleAsterisk,rec);
         this._box.addChildAt(this._problemTitleAsterisk,0);
         this._occurrenceTimeTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.timerText");
         this._occurrenceTimeTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text2");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.occurrenceTimeTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._occurrenceTimeTextImg,rec);
         this._box.addChildAt(this._occurrenceTimeTextImg,0);
         this._yearCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox2");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.yearComboxRec");
         ObjectUtils.copyPropertyByRectangle(this._yearCombox,rec);
         this._yearCombox.beginChanges();
         var year:Number = Number(new Date().getFullYear());
         this._yearCombox.textField.text = String(year);
         this._yearCombox.snapItemHeight = true;
         this._yearCombox.selctedPropName = "text";
         for(i = year; i >= year - 2; i--)
         {
            this._yearCombox.listPanel.vectorListModel.append(i);
         }
         this._yearCombox.commitChanges();
         this._box.addChildAt(this._yearCombox,0);
         this._yearTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.yearText");
         this._yearTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text3");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.yearTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._yearTextImg,rec);
         this._box.addChildAt(this._yearTextImg,0);
         this._monthCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox3");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.monthComboxRec");
         ObjectUtils.copyPropertyByRectangle(this._monthCombox,rec);
         this._monthCombox.beginChanges();
         var month:Number = new Date().getMonth() + 1;
         this._monthCombox.textField.text = String(month);
         this._monthCombox.selctedPropName = "text";
         for(i = 1; i <= 12; i++)
         {
            this._monthCombox.listPanel.vectorListModel.append(i);
         }
         this._monthCombox.commitChanges();
         this._box.addChildAt(this._monthCombox,0);
         this._monthTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.monthText");
         this._monthTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text4");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.monthTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._monthTextImg,rec);
         this._box.addChildAt(this._monthTextImg,0);
         this._dayCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox4");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.dayComboxRec");
         ObjectUtils.copyPropertyByRectangle(this._dayCombox,rec);
         this._dayCombox.beginChanges();
         var day:Number = Number(new Date().getDate());
         this._dayCombox.textField.text = String(day);
         this._dayCombox.selctedPropName = "text";
         var dayTotal:Number = DateUtils.getDays(year,month);
         for(i = 1; i <= dayTotal; i++)
         {
            this._dayCombox.listPanel.vectorListModel.append(i);
         }
         this._dayCombox.commitChanges();
         this._box.addChildAt(this._dayCombox,0);
         this._dayTextImg = ComponentFactory.Instance.creatComponentByStylename("ddtfeedback.dayText");
         this._dayTextImg.text = LanguageMgr.GetTranslation("feedback.view.Feedback.text5");
         rec = ComponentFactory.Instance.creatCustomObject("feedback.dayTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._dayTextImg,rec);
         this._box.addChildAt(this._dayTextImg,0);
         this._feedbackBg = ComponentFactory.Instance.creatComponentByStylename("feedback.textBgImg_style1");
         this._box.addChildAt(this._feedbackBg,0);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._problemCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this.__problemComboxChanged);
         this._yearCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this._dateChanged);
         this._monthCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this._dateChanged);
         this._dayCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this.__comboxClick);
         this._problemCombox.addEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._yearCombox.addEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._monthCombox.addEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._dayCombox.addEventListener(MouseEvent.CLICK,this.__comboxClick);
      }
      
      private function __comboxClick(event:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function _dateChanged(event:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         this._dayCombox.textField.text = "1";
         var dayTotal:Number = DateUtils.getDays(Number(this._yearCombox.textField.text),Number(this._monthCombox.textField.text));
         this._dayCombox.listPanel.vectorListModel.clear();
         this._dayCombox.beginChanges();
         for(var i:uint = 1; i <= dayTotal; i++)
         {
            this._dayCombox.listPanel.vectorListModel.append(i);
         }
         this._dayCombox.commitChanges();
      }
      
      private function getFeedbackSp($type:int) : Disposeable
      {
         var sp:Disposeable = null;
         switch($type)
         {
            case 0:
            case 5:
            case 6:
            case 9:
               sp = new FeedbackConsultingSp();
               this.height = 450;
               this.y = 75;
               break;
            case 1:
               sp = new FeedbackProblemsSp();
               this.height = 450;
               this.y = 75;
               break;
            case 3:
               sp = new FeedbackPropsDisappearSp();
               this.height = 450;
               this.y = 75;
               break;
            case 4:
               sp = new FeedbackStealHandSp();
               PositionUtils.setPos(sp,"feedback.FeedbackStealHandSp.pos");
               this.height += 40;
               this.y = 55;
               break;
            case 2:
               sp = new FeedbackPrepaidCardSp();
               this.height = 450;
               this.y = 75;
               break;
            case 8:
               sp = new FeedbackReportSp();
               this.height = 450;
               this.y = 75;
               break;
            case 7:
               sp = new FeedbackComplaintSp();
               this.height = 450;
               this.y = 75;
         }
         sp["submitFrame"] = this;
         return sp;
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._problemCombox.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__problemComboxChanged);
         this._yearCombox.removeEventListener(InteractiveEvent.STATE_CHANGED,this._dateChanged);
         this._monthCombox.removeEventListener(InteractiveEvent.STATE_CHANGED,this._dateChanged);
         this._dayCombox.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__comboxClick);
         this._problemCombox.removeEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._yearCombox.removeEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._monthCombox.removeEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._dayCombox.removeEventListener(MouseEvent.CLICK,this.__comboxClick);
      }
   }
}

