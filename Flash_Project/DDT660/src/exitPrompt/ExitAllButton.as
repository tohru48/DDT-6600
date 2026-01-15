package exitPrompt
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ExitAllButton extends Component
   {
      
      public static const CHANGE:String = "change";
      
      private var _dayMissionBt:ExitButtonItem;
      
      private var _dayMissionSprite:MissionSprite;
      
      private var _actMissionBt:ExitButtonItem;
      
      private var _actMissionSprite:MissionSprite;
      
      private var _emailMissionBt:ExitButtonItem;
      
      private var _bullet1:Bitmap;
      
      private var _bullet2:Bitmap;
      
      private var _bullet3:Bitmap;
      
      private var _viewArr:Array;
      
      private var _model:ExitPromptModel;
      
      private var _dayMissionInfoText:FilterFrameText;
      
      private var _actMissionInfoText:FilterFrameText;
      
      private var _emailMissionInfoText:FilterFrameText;
      
      private var _btNumBg0:ScaleFrameImage;
      
      private var _btNumBg1:ScaleFrameImage;
      
      public var interval:int;
      
      public function ExitAllButton()
      {
         super();
      }
      
      public function start() : void
      {
         this._viewArr = new Array();
         this._model = new ExitPromptModel();
         this._dayMissionBt = ComponentFactory.Instance.creat("ExitPromptFrame.dayMissionFontBt");
         this._bullet1 = ComponentFactory.Instance.creat("asset.core.quest.QuestConditionBGHighlight1");
         this._dayMissionInfoText = ComponentFactory.Instance.creat("ExitPromptFrame.BtInfoText");
         this._dayMissionBt.addChild(this._bullet1);
         this._dayMissionBt.addChild(this._dayMissionInfoText);
         this._btNumBg0 = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.BtInfoImg");
         this._btNumBg0.setFrame(1);
         this._dayMissionBt.addChild(this._btNumBg0);
         this._dayMissionSprite = new MissionSprite(this._model.list0Arr);
         this._dayMissionSprite.visible = false;
         this._actMissionBt = ComponentFactory.Instance.creat("ExitPromptFrame.actMissionFontBt");
         this._bullet2 = ComponentFactory.Instance.creat("asset.core.quest.QuestConditionBGHighlight2");
         this._actMissionBt.addChild(this._bullet2);
         this._actMissionInfoText = ComponentFactory.Instance.creat("ExitPromptFrame.BtInfoText");
         this._actMissionBt.addChild(this._actMissionInfoText);
         this._actMissionSprite = new MissionSprite(this._model.list1Arr);
         this._actMissionSprite.visible = false;
         this._btNumBg1 = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.BtInfoImg");
         this._btNumBg1.setFrame(1);
         this._actMissionBt.addChild(this._btNumBg1);
         this._emailMissionBt = ComponentFactory.Instance.creat("ExitPromptFrame.emailMissionFontBt");
         this._bullet3 = ComponentFactory.Instance.creat("asset.core.quest.QuestConditionBGHighlight3");
         this._emailMissionBt.addChild(this._bullet3);
         this._emailMissionInfoText = ComponentFactory.Instance.creat("ExitPromptFrame.BtInfoText");
         this._emailMissionBt.addChild(this._emailMissionInfoText);
         addChild(this._dayMissionSprite);
         addChild(this._actMissionSprite);
         addChild(this._dayMissionBt);
         addChild(this._actMissionBt);
         addChild(this._emailMissionBt);
         this._viewArr.push(this._dayMissionBt);
         this._viewArr.push(this._dayMissionSprite);
         this._viewArr.push(this._actMissionBt);
         this._viewArr.push(this._actMissionSprite);
         this._viewArr.push(this._emailMissionBt);
         this._addEvt();
         this._order();
         if(this._model.list0Arr.length > 0)
         {
            this._dayMissionInfoText.htmlText = this._textAnalyz0(LanguageMgr.GetTranslation("ddt.exitPrompt.btInfoTextI"),this._model.list0Arr.length);
         }
         else
         {
            this._btNumBg0.visible = false;
            this._dayMissionInfoText.htmlText = LanguageMgr.GetTranslation("ddt.exitPrompt.btInfoTextII");
         }
         if(this._model.list1Arr.length > 0)
         {
            this._actMissionInfoText.htmlText = this._textAnalyz0(LanguageMgr.GetTranslation("ddt.exitPrompt.btInfoTextI"),this._model.list1Arr.length);
         }
         else
         {
            this._btNumBg1.visible = false;
            this._actMissionInfoText.htmlText = LanguageMgr.GetTranslation("ddt.exitPrompt.btInfoTextII");
         }
         if(this._model.list2Num > 0)
         {
            this._emailMissionInfoText.htmlText = this._textAnalyz0(LanguageMgr.GetTranslation("ddt.exitPrompt.btInfoTextIII"),this._model.list2Num);
         }
         else
         {
            this._emailMissionInfoText.htmlText = LanguageMgr.GetTranslation("ddt.exitPrompt.btInfoTextIV");
         }
         if(this._emailMissionInfoText.numLines == 1)
         {
            this._emailMissionInfoText.y = 19;
         }
      }
      
      public function get needScorllBar() : Boolean
      {
         var boo:Boolean = true;
         if(this._model.list0Arr.length + this._model.list1Arr.length == 0)
         {
            boo = false;
         }
         return boo;
      }
      
      private function _order() : void
      {
         for(var i:int = 1; i < this._viewArr.length; i++)
         {
            if(this._viewArr[i - 1].visible == false || this._viewArr[i - 1].height == 0)
            {
               this._viewArr[i].y = this._viewArr[i - 2].y + this._viewArr[i - 2].height + this.interval;
            }
            else if(this._viewArr[i - 1] is MissionSprite)
            {
               this._viewArr[i].y = this._viewArr[i - 1].y + this._viewArr[i - 1].height + MissionSprite(this._viewArr[i - 1]).BG_Y + this.interval;
            }
            else
            {
               this._viewArr[i].y = this._viewArr[i - 1].y + this._viewArr[i - 1].height + this.interval;
            }
         }
         this.dispatchEvent(new Event(CHANGE));
      }
      
      override public function get height() : Number
      {
         return this._viewArr[this._viewArr.length - 1].y + this._viewArr[this._viewArr.length - 1].height;
      }
      
      private function _addEvt() : void
      {
         this._dayMissionBt.addEventListener(MouseEvent.CLICK,this._clickDayBt);
         this._actMissionBt.addEventListener(MouseEvent.CLICK,this._clickActBt);
      }
      
      private function _clickDayBt(e:MouseEvent = null) : void
      {
         if(e != null)
         {
            SoundManager.instance.play("008");
         }
         if(this._dayMissionSprite.content.length == 0)
         {
            return;
         }
         if(this._dayMissionSprite.visible == false)
         {
            this._btNumBg0.setFrame(2);
            this._dayMissionSprite.visible = true;
         }
         else
         {
            this._btNumBg0.setFrame(1);
            this._dayMissionSprite.visible = false;
         }
         this._order();
      }
      
      private function _clickActBt(e:MouseEvent = null) : void
      {
         if(e != null)
         {
            SoundManager.instance.play("008");
         }
         if(this._actMissionSprite.content.length == 0)
         {
            return;
         }
         if(this._actMissionSprite.visible == false)
         {
            this._btNumBg1.setFrame(2);
            this._actMissionSprite.visible = true;
         }
         else
         {
            this._btNumBg1.setFrame(1);
            this._actMissionSprite.visible = false;
         }
         this._order();
      }
      
      private function _textAnalyz0(str:String, num:int) : String
      {
         return str.replace(/r/g," " + String(num) + " ");
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._dayMissionBt))
         {
            ObjectUtils.disposeObject(this._dayMissionBt);
         }
         if(Boolean(this._dayMissionSprite))
         {
            ObjectUtils.disposeObject(this._dayMissionSprite);
         }
         if(Boolean(this._actMissionBt))
         {
            ObjectUtils.disposeObject(this._actMissionBt);
         }
         if(Boolean(this._actMissionSprite))
         {
            ObjectUtils.disposeObject(this._actMissionSprite);
         }
         if(Boolean(this._emailMissionBt))
         {
            ObjectUtils.disposeObject(this._emailMissionBt);
         }
         if(Boolean(this._dayMissionInfoText))
         {
            ObjectUtils.disposeObject(this._dayMissionInfoText);
         }
         if(Boolean(this._actMissionInfoText))
         {
            ObjectUtils.disposeObject(this._actMissionInfoText);
         }
         if(Boolean(this._emailMissionInfoText))
         {
            ObjectUtils.disposeObject(this._emailMissionInfoText);
         }
         if(Boolean(this._bullet1))
         {
            ObjectUtils.disposeObject(this._bullet1);
         }
         if(Boolean(this._bullet2))
         {
            ObjectUtils.disposeObject(this._bullet2);
         }
         if(Boolean(this._bullet3))
         {
            ObjectUtils.disposeObject(this._bullet3);
         }
         if(Boolean(this._btNumBg0))
         {
            ObjectUtils.disposeObject(this._btNumBg0);
         }
         if(Boolean(this._btNumBg1))
         {
            ObjectUtils.disposeObject(this._btNumBg1);
         }
         this._dayMissionBt = null;
         this._dayMissionSprite = null;
         this._actMissionBt = null;
         this._actMissionSprite = null;
         this._emailMissionBt = null;
         this._dayMissionInfoText = null;
         this._actMissionInfoText = null;
         this._emailMissionInfoText = null;
         this._bullet1 = null;
         this._bullet2 = null;
         this._bullet3 = null;
         this._btNumBg0 = null;
         this._btNumBg1 = null;
      }
   }
}

