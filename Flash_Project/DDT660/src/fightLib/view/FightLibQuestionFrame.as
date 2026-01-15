package fightLib.view
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.FightLibManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class FightLibQuestionFrame extends Frame
   {
      
      private static const MarkRate:int = 1000;
      
      private var _reAnswerBtn:TextButton;
      
      private var _rightBottomBg:ScaleBitmapImage;
      
      private var _viewTutorialBtn:TextButton;
      
      private var _answerBtn1:BaseButton;
      
      private var _answerBtn2:BaseButton;
      
      private var _answerBtn3:BaseButton;
      
      private var _hasAnswered:int;
      
      private var _needAnswer:int;
      
      private var _totalQuestion:int;
      
      private var _question:String;
      
      private var _answer1:String;
      
      private var _answer2:String;
      
      private var _answer3:String;
      
      private var _timeLimit:int;
      
      private var _questionInfoField:FilterFrameText;
      
      private var _questionField:FilterFrameText;
      
      private var _timeField:FilterFrameText;
      
      private var _answerBack:MutipleImage;
      
      private var _answerField1:FilterFrameText;
      
      private var _answerField2:FilterFrameText;
      
      private var _answerField3:FilterFrameText;
      
      private var _answerPosField1:FilterFrameText;
      
      private var _answerPosField2:FilterFrameText;
      
      private var _answerPosField3:FilterFrameText;
      
      private var _markStart:Boolean = false;
      
      private var _elapsed:int = 0;
      
      private var _markBlank:int = 0;
      
      private var _startTime:int = 0;
      
      public function FightLibQuestionFrame(id:int, title:String = "", hasAnswered:int = 0, needAnswer:int = 0, totalQuestion:int = 0, question:String = "", answer1:String = "", answer2:String = "", answer3:String = "", timeLimit:int = 30)
      {
         super();
         _id = id;
         titleText = title;
         this._hasAnswered = hasAnswered;
         this._needAnswer = needAnswer;
         this._totalQuestion = totalQuestion;
         this._question = question;
         this._answer1 = answer1;
         this._answer2 = answer2;
         this._answer3 = answer3;
         this._timeLimit = timeLimit + 1;
         this.updateInfo();
      }
      
      private function updateInfo() : void
      {
         var postion:Point = null;
         this._questionInfoField.text = LanguageMgr.GetTranslation("tank.fightLib.questionInfo",this._totalQuestion,this._needAnswer,this._hasAnswered,this._totalQuestion - id);
         this._questionField.text = this._question;
         this._answerField1.text = this._answer1;
         this._answerField2.text = this._answer2;
         this._answerField3.text = this._answer3;
         postion = ComponentFactory.Instance.creatCustomObject("fightLib.Question.Time.TopRight");
         this._timeField.text = String(this._timeLimit) + LanguageMgr.GetTranslation("second");
         this._timeField.x = postion.x - this._timeField.width;
         this._timeField.y = postion.y;
      }
      
      private function configUI() : void
      {
         this._answerBack = ComponentFactory.Instance.creatComponentByStylename("tank.view.fightLib.AnswerBack");
         _container.addChild(this._answerBack);
         this._rightBottomBg = ComponentFactory.Instance.creatComponentByStylename("fightlib.questFrame.rightBottomBgImg");
         _container.addChild(this._rightBottomBg);
         this._questionInfoField = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.InfoField");
         _container.addChild(this._questionInfoField);
         this._questionField = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.QuestionField");
         _container.addChild(this._questionField);
         this._timeField = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.TimeField");
         _container.addChild(this._timeField);
         this._reAnswerBtn = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.ReAnswerButton");
         this._reAnswerBtn.text = LanguageMgr.GetTranslation("tank.fightLib.FightLibQuestionFrame.reAnswer");
         _container.addChild(this._reAnswerBtn);
         this._viewTutorialBtn = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.ViewTutorialButton");
         this._viewTutorialBtn.text = LanguageMgr.GetTranslation("tank.fightLib.FightLibQuestionFrame.viewTutorial");
         _container.addChild(this._viewTutorialBtn);
         this._answerBtn1 = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.Answer1");
         _container.addChild(this._answerBtn1);
         this._answerPosField1 = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.Answer.PositionField");
         this._answerPosField1.text = "A";
         this._answerBtn1.addChild(this._answerPosField1);
         this._answerField1 = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.AnswerField");
         this._answerBtn1.addChild(this._answerField1);
         this._answerBtn2 = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.Answer2");
         _container.addChild(this._answerBtn2);
         this._answerPosField2 = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.Answer.PositionField");
         this._answerPosField2.text = "B";
         this._answerBtn2.addChild(this._answerPosField2);
         this._answerField2 = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.AnswerField");
         this._answerBtn2.addChild(this._answerField2);
         this._answerBtn3 = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.Answer3");
         _container.addChild(this._answerBtn3);
         this._answerPosField3 = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.Answer.PositionField");
         this._answerPosField3.text = "C";
         this._answerBtn3.addChild(this._answerPosField3);
         this._answerField3 = ComponentFactory.Instance.creatComponentByStylename("fightLib.Question.AnswerField");
         this._answerBtn3.addChild(this._answerField3);
      }
      
      override protected function init() : void
      {
         super.init();
         this.configUI();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addedToStage);
         this._answerBtn1.addEventListener(MouseEvent.CLICK,this.__selectAnswer);
         this._answerBtn2.addEventListener(MouseEvent.CLICK,this.__selectAnswer);
         this._answerBtn3.addEventListener(MouseEvent.CLICK,this.__selectAnswer);
         this._reAnswerBtn.addEventListener(MouseEvent.CLICK,this.__reAnswer);
         this._viewTutorialBtn.addEventListener(MouseEvent.CLICK,this.__viewTutorial);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addedToStage);
         if(Boolean(this._answerBtn1))
         {
            this._answerBtn1.removeEventListener(MouseEvent.CLICK,this.__selectAnswer);
         }
         if(Boolean(this._answerBtn2))
         {
            this._answerBtn2.removeEventListener(MouseEvent.CLICK,this.__selectAnswer);
         }
         if(Boolean(this._answerBtn3))
         {
            this._answerBtn3.removeEventListener(MouseEvent.CLICK,this.__selectAnswer);
         }
         if(Boolean(this._reAnswerBtn))
         {
            this._reAnswerBtn.removeEventListener(MouseEvent.CLICK,this.__reAnswer);
         }
         if(Boolean(this._viewTutorialBtn))
         {
            this._viewTutorialBtn.removeEventListener(MouseEvent.CLICK,this.__viewTutorial);
         }
      }
      
      private function __addedToStage(evt:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addedToStage);
         this.startupMark();
      }
      
      private function startupMark() : void
      {
         if(!this._markStart)
         {
            this._startTime = getTimer();
            this._elapsed = 0;
            this._markBlank = 0;
            StageReferance.stage.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this._markStart = true;
         }
      }
      
      private function shutdownMark() : void
      {
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         this._markStart = false;
      }
      
      private function __enterFrame(evt:Event) : void
      {
         var now:int = getTimer();
         var markRate:int = now - this._elapsed;
         this._elapsed = now - this._startTime;
         if(this._elapsed >= this._timeLimit * 1000)
         {
            this.shutdownMark();
            this.markComplete();
         }
         else
         {
            this._markBlank += markRate;
            if(this._markBlank >= MarkRate)
            {
               if(Boolean(this._timeField))
               {
                  this._timeField.text = String(int(this._timeLimit - this._elapsed / 1000)) + LanguageMgr.GetTranslation("second");
               }
               this._markBlank = 0;
            }
         }
      }
      
      private function markComplete() : void
      {
         GameInSocketOut.sendFightLibAnswer(_id,-1);
         GameInSocketOut.sendGameSkipNext(int(this._elapsed / 1000));
         this.close();
      }
      
      private function __selectAnswer(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._answerBtn1.enable = this._answerBtn2.enable = this._answerBtn3.enable = false;
         if(evt.currentTarget == this._answerBtn1)
         {
            GameInSocketOut.sendFightLibAnswer(_id,0);
         }
         else if(evt.currentTarget == this._answerBtn2)
         {
            GameInSocketOut.sendFightLibAnswer(_id,1);
         }
         else
         {
            GameInSocketOut.sendFightLibAnswer(_id,2);
         }
         GameInSocketOut.sendGameSkipNext(int(this._elapsed / 1000));
         this.close();
      }
      
      private function __reAnswer(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendFightLibReanswer();
         --FightLibManager.Instance.reAnswerNum;
      }
      
      private function __viewTutorial(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FightLibManager.Instance.script.restart();
         GameInSocketOut.sendClientScriptStart();
         this.close();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._rightBottomBg);
         this._rightBottomBg = null;
         if(Boolean(this._reAnswerBtn))
         {
            this._reAnswerBtn.dispose();
            this._reAnswerBtn = null;
         }
         if(Boolean(this._viewTutorialBtn))
         {
            this._viewTutorialBtn.dispose();
            this._viewTutorialBtn = null;
         }
         if(Boolean(this._answerField1))
         {
            ObjectUtils.disposeObject(this._answerField1);
         }
         this._answerField1 = null;
         if(Boolean(this._answerField2))
         {
            ObjectUtils.disposeObject(this._answerField2);
         }
         this._answerField2 = null;
         if(Boolean(this._answerField3))
         {
            ObjectUtils.disposeObject(this._answerField3);
         }
         this._answerField3 = null;
         if(Boolean(this._answerPosField1))
         {
            ObjectUtils.disposeObject(this._answerPosField1);
         }
         this._answerPosField1 = null;
         if(Boolean(this._answerPosField2))
         {
            ObjectUtils.disposeObject(this._answerPosField2);
         }
         this._answerPosField2 = null;
         if(Boolean(this._answerPosField3))
         {
            ObjectUtils.disposeObject(this._answerPosField3);
         }
         this._answerPosField3 = null;
         if(Boolean(this._answerBack))
         {
            ObjectUtils.disposeObject(this._answerBack);
         }
         this._answerBack = null;
         if(Boolean(this._timeField))
         {
            ObjectUtils.disposeObject(this._timeField);
         }
         this._timeField = null;
         super.dispose();
      }
      
      public function close() : void
      {
         if(this._markStart)
         {
            this.shutdownMark();
         }
         ObjectUtils.disposeObject(this);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,true);
      }
   }
}

