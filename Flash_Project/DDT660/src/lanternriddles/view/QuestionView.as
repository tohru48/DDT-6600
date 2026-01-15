package lanternriddles.view
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import lanternriddles.LanternRiddlesManager;
   import lanternriddles.data.LanternInfo;
   import road7th.comm.PackageIn;
   
   public class QuestionView extends Sprite
   {
      
      private static var SELECT_NUM:int = 4;
      
      private var _questionTitle:FilterFrameText;
      
      private var _questionCount:FilterFrameText;
      
      private var _cdTime:FilterFrameText;
      
      private var _question:FilterFrameText;
      
      private var _question2:FilterFrameText;
      
      private var _selectVec:Vector.<MovieImage>;
      
      private var _grayFilters:Array;
      
      private var _countDownTime:Number;
      
      private var _timer:Timer;
      
      private var _count:int;
      
      private var _info:LanternInfo;
      
      private var _resultMovie:MovieImage;
      
      public function QuestionView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._selectVec = new Vector.<MovieImage>();
         this._grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
      }
      
      private function initView() : void
      {
         var select:MovieImage = null;
         var i:int = 0;
         this._questionTitle = ComponentFactory.Instance.creatComponentByStylename("lantern.view.questionTitle");
         this._questionTitle.text = LanguageMgr.GetTranslation("lanternRiddles.view.questionTitleText");
         addChild(this._questionTitle);
         this._questionCount = ComponentFactory.Instance.creatComponentByStylename("lantern.view.questionCount");
         addChild(this._questionCount);
         this._cdTime = ComponentFactory.Instance.creatComponentByStylename("lantern.view.questionCDTime");
         this._cdTime.text = LanguageMgr.GetTranslation("lanternRiddles.view.cdTime",9);
         addChild(this._cdTime);
         this._question = ComponentFactory.Instance.creatComponentByStylename("lantern.view.question");
         addChild(this._question);
         this._question2 = ComponentFactory.Instance.creatComponentByStylename("lantern.view.question2");
         addChild(this._question2);
         for(i = 0; i < SELECT_NUM; i++)
         {
            select = ComponentFactory.Instance.creatComponentByStylename("lantern.view.selectMovie");
            select.buttonMode = true;
            select.movie.gotoAndStop(1);
            select.addEventListener(MouseEvent.CLICK,this.__onSelectClick);
            PositionUtils.setPos(select,"lantern.view.selectPos" + i);
            addChild(select);
            this._selectVec.push(select);
         }
      }
      
      private function initEvent() : void
      {
         LanternRiddlesManager.instance.addEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_ANSWERRESULT,this.__onAnswerResult);
      }
      
      protected function __onAnswerResult(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var correct:Boolean = pkg.readBoolean();
         var hitFlag:Boolean = pkg.readBoolean();
         var option:int = pkg.readInt();
         var msg:String = pkg.readUTF();
         if(hitFlag)
         {
            this.setAnswerFlag(option);
         }
         if(correct)
         {
            this._resultMovie = ComponentFactory.Instance.creat("lantern.view.correctMovie");
         }
         else
         {
            this._resultMovie = ComponentFactory.Instance.creat("lantern.view.errorMovie");
         }
         LayerManager.Instance.addToLayer(this._resultMovie,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         this._resultMovie.movie["result"]["awardText"].autoSize = TextFieldAutoSize.CENTER;
         this._resultMovie.movie["result"]["awardText"].text = msg;
         this._resultMovie.x = (StageReferance.stage.stageWidth - this._resultMovie.width) / 2;
         this._resultMovie.y = 290;
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      protected function __onEnterFrame(event:Event) : void
      {
         if(this._resultMovie && this._resultMovie.parent && this._resultMovie.movie.currentFrame == 40)
         {
            this._resultMovie.parent.removeChild(this._resultMovie);
            this._resultMovie.dispose();
            this._resultMovie = null;
            removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         }
      }
      
      public function set info(info:LanternInfo) : void
      {
         this._info = info;
         this.setQuestionCount(this._info.QuestionIndex);
         this.setQuestionInfo(info);
         this.setCDTime(this._info.EndDate);
         this.setAnswerFlag(this._info.Option);
      }
      
      private function setQuestionCount(index:int) : void
      {
         this._questionCount.text = index.toString() + "/" + this._count.toString();
      }
      
      private function setQuestionInfo(info:LanternInfo) : void
      {
         this._question.text = info.QuestionContent;
         this._question2.text = LanguageMgr.GetTranslation("lanternRiddles.view.questionText","\n",info.Option1,info.Option2,info.Option3,info.Option4);
      }
      
      private function setCDTime(date:Date) : void
      {
         this._countDownTime = date.time - TimeManager.Instance.Now().time;
         if(this._countDownTime > 0)
         {
            this._countDownTime /= 1000;
            this._cdTime.visible = true;
            this._cdTime.text = LanguageMgr.GetTranslation("lanternRiddles.view.cdTime",this.transSecond(this._countDownTime));
            if(!this._timer)
            {
               this._timer = new Timer(1000);
               this._timer.addEventListener(TimerEvent.TIMER,this.__onTimer);
            }
            this._timer.start();
         }
         else
         {
            this._cdTime.visible = false;
            if(Boolean(this._timer))
            {
               this._timer.stop();
               this._timer.reset();
            }
         }
      }
      
      protected function __onTimer(event:TimerEvent) : void
      {
         --this._countDownTime;
         if(this._countDownTime < 0)
         {
            this._timer.stop();
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer = null;
         }
         else if(Boolean(this._cdTime))
         {
            this._cdTime.text = LanguageMgr.GetTranslation("lanternRiddles.view.cdTime",this.transSecond(this._countDownTime));
         }
      }
      
      private function transSecond(num:Number) : String
      {
         return String("0" + Math.floor(num % 60)).substr(-2);
      }
      
      protected function __onSelectClick(event:MouseEvent) : void
      {
         var i:int = 0;
         SoundManager.instance.playButtonSound();
         var select:MovieImage = event.currentTarget as MovieImage;
         for(i = 0; i < this._selectVec.length; i++)
         {
            if(select == this._selectVec[i])
            {
               this._selectVec[i].movie.gotoAndStop(2);
               this._info.Option = i + 1;
               SocketManager.Instance.out.sendLanternRiddlesAnswer(this._info.QuestionID,this._info.QuestionIndex,this._info.Option);
            }
            this._selectVec[i].filters = this._grayFilters;
            this._selectVec[i].removeEventListener(MouseEvent.CLICK,this.__onSelectClick);
         }
      }
      
      private function setAnswerFlag(option:int) : void
      {
         if(option > 0)
         {
            this.setSelectBtnEnable(false);
            this._selectVec[option - 1].movie.gotoAndStop(2);
         }
      }
      
      public function setSelectBtnEnable(flag:Boolean) : void
      {
         for(var i:int = 0; i < this._selectVec.length; i++)
         {
            this._selectVec[i].movie.gotoAndStop(1);
            if(flag)
            {
               this._selectVec[i].filters = null;
               this._selectVec[i].addEventListener(MouseEvent.CLICK,this.__onSelectClick);
            }
            else
            {
               this._selectVec[i].filters = this._grayFilters;
               this._selectVec[i].removeEventListener(MouseEvent.CLICK,this.__onSelectClick);
            }
         }
      }
      
      private function removeEvent() : void
      {
         LanternRiddlesManager.instance.removeEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_ANSWERRESULT,this.__onAnswerResult);
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         this.removeEvent();
         if(Boolean(this._questionTitle))
         {
            this._questionTitle.dispose();
            this._questionTitle = null;
         }
         if(Boolean(this._questionCount))
         {
            this._questionCount.dispose();
            this._questionCount = null;
         }
         if(Boolean(this._question))
         {
            this._question.dispose();
            this._question = null;
         }
         if(Boolean(this._question2))
         {
            this._question2.dispose();
            this._question2 = null;
         }
         if(Boolean(this._cdTime))
         {
            this._cdTime.dispose();
            this._cdTime = null;
         }
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer = null;
         }
         if(Boolean(this._selectVec))
         {
            for(i = 0; i < this._selectVec.length; i++)
            {
               this._selectVec[i].removeEventListener(MouseEvent.CLICK,this.__onSelectClick);
               this._selectVec[i].dispose();
               this._selectVec[i] = null;
            }
            this._selectVec.length = 0;
            this._selectVec = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function set count(value:int) : void
      {
         this._count = value;
      }
      
      public function get info() : LanternInfo
      {
         return this._info;
      }
      
      public function get countDownTime() : Number
      {
         return this._countDownTime;
      }
   }
}

