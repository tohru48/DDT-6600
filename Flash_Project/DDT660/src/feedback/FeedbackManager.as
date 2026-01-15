package feedback
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.MD5;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.DailyButtunBar;
   import feedback.analyze.LoadFeedbackReplyAnalyzer;
   import feedback.data.FeedbackInfo;
   import feedback.data.FeedbackReplyInfo;
   import feedback.view.FeedbackReplyFrame;
   import feedback.view.FeedbackSubmitFrame;
   import flash.events.EventDispatcher;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.DateUtils;
   
   public class FeedbackManager extends EventDispatcher
   {
      
      private static var _instance:FeedbackManager;
      
      private var _feedbackInfo:FeedbackInfo;
      
      private var _feedbackTime:Date;
      
      private var _currentTime:Date;
      
      private var _currentOpenInt:int;
      
      private var _feedbackReplyData:DictionaryData;
      
      private var _isReply:Boolean;
      
      private var _feedbackSubmitFrame:FeedbackSubmitFrame;
      
      private var _feedbackReplyFrame:FeedbackReplyFrame;
      
      private var _isSubmitTime:Boolean;
      
      private var _removeFeedbackInfoId:String;
      
      public function FeedbackManager()
      {
         super();
      }
      
      public static function get instance() : FeedbackManager
      {
         if(_instance == null)
         {
            _instance = new FeedbackManager();
         }
         return _instance;
      }
      
      public function get feedbackInfo() : FeedbackInfo
      {
         if(!this._feedbackInfo)
         {
            this._feedbackInfo = new FeedbackInfo();
         }
         return this._feedbackInfo;
      }
      
      public function get feedbackReplyData() : DictionaryData
      {
         return this._feedbackReplyData;
      }
      
      public function set feedbackReplyData(value:DictionaryData) : void
      {
         if(Boolean(this._feedbackReplyData))
         {
            this._feedbackReplyData.removeEventListener(DictionaryEvent.ADD,this.feedbackReplyDataAdd);
            this._feedbackReplyData.removeEventListener(DictionaryEvent.REMOVE,this.feedbackReplyDataRemove);
         }
         this._feedbackReplyData = value;
         this._feedbackReplyData.addEventListener(DictionaryEvent.ADD,this.feedbackReplyDataAdd);
         this._feedbackReplyData.addEventListener(DictionaryEvent.REMOVE,this.feedbackReplyDataRemove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FEEDBACK_REPLY,this.feedbackReplyBySocket);
         this.checkFeedbackReplyData();
      }
      
      public function setupFeedbackData(analyzer:LoadFeedbackReplyAnalyzer) : void
      {
         if(PathManager.solveFeedbackEnable())
         {
            this.feedbackReplyData = analyzer.listData;
         }
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["userid"] = PlayerManager.Instance.Self.ID;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("AdvanceQuestTime.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __loaderComplete(event:LoaderEvent) : void
      {
         event.currentTarget.removeEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
         if(event.loader.content == 0)
         {
            return;
         }
         var tempTime:Array = String(event.loader.content).split(",");
         if(Boolean(tempTime[0]))
         {
            if(tempTime[0] == 0)
            {
               this._feedbackTime = null;
            }
            else
            {
               this._feedbackTime = DateUtils.getDateByStr(tempTime[0]);
            }
         }
         if(Boolean(tempTime[1]))
         {
            this._currentTime = DateUtils.getDateByStr(tempTime[1]);
         }
         if(Boolean(tempTime[2]))
         {
            this._currentOpenInt = Number(tempTime[2]);
         }
      }
      
      private function feedbackReplyBySocket(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var feedbackReplyInfo:FeedbackReplyInfo = new FeedbackReplyInfo();
         feedbackReplyInfo.questionId = pkg.readUTF();
         feedbackReplyInfo.replyId = pkg.readInt();
         feedbackReplyInfo.occurrenceDate = pkg.readUTF();
         feedbackReplyInfo.questionTitle = pkg.readUTF();
         feedbackReplyInfo.questionContent = pkg.readUTF();
         feedbackReplyInfo.replyContent = pkg.readUTF();
         feedbackReplyInfo.stopReply = pkg.readUTF();
         this._feedbackReplyData.add(feedbackReplyInfo.questionId + "_" + feedbackReplyInfo.replyId,feedbackReplyInfo);
         this.stopReplyEvt(feedbackReplyInfo.stopReply);
      }
      
      private function stopReplyEvt(str:String) : void
      {
         var obj:Object = new Object();
         obj.stopReply = str;
         var feedEvt:FeedbackEvent = new FeedbackEvent(FeedbackEvent.FEEDBACK_StopReply,obj);
         dispatchEvent(feedEvt);
      }
      
      private function feedbackReplyDataAdd(event:DictionaryEvent) : void
      {
         this.checkFeedbackReplyData();
      }
      
      private function feedbackReplyDataRemove(event:DictionaryEvent) : void
      {
         this.checkFeedbackReplyData();
      }
      
      private function checkFeedbackReplyData() : void
      {
         if(this._feedbackReplyData.length <= 0)
         {
            this._isReply = false;
            DailyButtunBar.Insance.setComplainGlow(false);
         }
         else
         {
            this._isReply = true;
            DailyButtunBar.Insance.setComplainGlow(true);
         }
      }
      
      public function examineTime() : Boolean
      {
         var timeTime:Date = TimeManager.Instance.Now();
         if(!this._feedbackTime)
         {
            return true;
         }
         if(timeTime.time - this._feedbackTime.time >= 1000 * 60 * 35)
         {
            return true;
         }
         return false;
      }
      
      public function show() : void
      {
         if(!this._isReply)
         {
            if(this._currentOpenInt >= 5)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.MaxReferTimes"));
               return;
            }
            if(!this._currentTime && !this._feedbackTime)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseStateCreator.LoadingTip"));
               return;
            }
            if(this.examineTime())
            {
               this.openFeedbackSubmitView();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.SystemsAnalysis"));
            }
         }
         else
         {
            this.openFeedbackReplyView();
         }
      }
      
      private function openFeedbackSubmitView() : void
      {
         if(!this._feedbackSubmitFrame)
         {
            this._feedbackSubmitFrame = ComponentFactory.Instance.creatComponentByStylename("feedback.feedbackSubmitFrame");
            this._feedbackSubmitFrame.show();
            return;
         }
         this.closeFrame();
      }
      
      private function openFeedbackReplyView() : void
      {
         if(!this._feedbackReplyFrame)
         {
            this._feedbackReplyFrame = ComponentFactory.Instance.creatComponentByStylename("feedback.feedbackReplyFrame");
            this._feedbackReplyFrame.show();
            this._feedbackReplyFrame.setup(this._feedbackReplyData.list[0] as FeedbackReplyInfo);
            return;
         }
         this.closeFrame();
      }
      
      public function closeFrame() : void
      {
         this._feedbackInfo = null;
         if(Boolean(this._feedbackSubmitFrame))
         {
            this._feedbackSubmitFrame.dispose();
            this._feedbackSubmitFrame = null;
         }
         if(Boolean(this._feedbackReplyFrame))
         {
            this._feedbackReplyFrame.dispose();
            this._feedbackReplyFrame = null;
         }
      }
      
      public function quickReport(channel:String, name:String, message:String) : void
      {
         var feedbackInfo:FeedbackInfo = new FeedbackInfo();
         feedbackInfo.question_title = LanguageMgr.GetTranslation("quickReport.complain.lan");
         feedbackInfo.question_content = "[" + channel + "]" + "[" + name + "]:" + message;
         feedbackInfo.occurrence_date = DateUtils.dateFormat(new Date());
         feedbackInfo.question_type = 9;
         feedbackInfo.report_url = name;
         feedbackInfo.report_user_name = name;
         FeedbackManager.instance.submitFeedbackInfo(feedbackInfo);
      }
      
      public function submitFeedbackInfo($feedbackInfo:FeedbackInfo) : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args.user_id = PlayerManager.Instance.Self.ID.toString();
         args.user_name = PlayerManager.Instance.Self.LoginName;
         args.user_nick_name = PlayerManager.Instance.Self.NickName;
         args.question_title = $feedbackInfo.question_title;
         args.question_content = $feedbackInfo.question_content;
         args.occurrence_date = $feedbackInfo.occurrence_date;
         args.question_type = $feedbackInfo.question_type.toString();
         args.goods_get_method = $feedbackInfo.goods_get_method;
         args.goods_get_date = $feedbackInfo.goods_get_date;
         args.charge_order_id = $feedbackInfo.charge_order_id;
         args.charge_method = $feedbackInfo.charge_method;
         args.charge_moneys = $feedbackInfo.charge_moneys.toString();
         args.activity_is_error = $feedbackInfo.activity_is_error.toString();
         args.activity_name = $feedbackInfo.activity_name;
         args.report_user_name = $feedbackInfo.report_user_name;
         args.report_url = $feedbackInfo.report_url;
         args.user_full_name = $feedbackInfo.user_full_name;
         args.user_phone = $feedbackInfo.user_phone;
         args.complaints_title = $feedbackInfo.complaints_title;
         args.complaints_source = $feedbackInfo.complaints_source;
         args.token = MD5.hash(PlayerManager.Instance.Self.ID.toString() + PlayerManager.Instance.Self.ZoneID.toString() + "3kjf2jfwj93pj22jfsl11jjoe12oij");
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("AdvanceQuestion.ashx"),BaseLoader.REQUEST_LOADER,args,URLRequestMethod.POST);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadFreeBackComplete);
         LoadResourceManager.Instance.startLoad(loader);
         this.closeFrame();
         this._isSubmitTime = true;
      }
      
      public function continueSubmit(questionId:String, replyId:int, questionContent:String) : void
      {
         this._removeFeedbackInfoId = questionId + "_" + replyId;
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args.pass = MD5.hash(PlayerManager.Instance.Self.ID + "3kjf2jfwj93pj22jfsl11jjoe12oij");
         args.userid = PlayerManager.Instance.Self.ID;
         args.nick_name = PlayerManager.Instance.Self.NickName;
         args.question_id = questionId;
         args.reply_id = replyId;
         args.reply_content = questionContent;
         args.token = MD5.hash(questionId.toString() + "3kjf2jfwj93pj22jfsl11jjoe12oij");
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("AdvanceReply.ashx"),BaseLoader.REQUEST_LOADER,args,URLRequestMethod.POST);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadFreeBackComplete);
         LoadResourceManager.Instance.startLoad(loader);
         this.closeFrame();
      }
      
      public function delPosts(questionId:String, replyId:int, appraisalGrade:int, AppraisalContent:String) : void
      {
         this._removeFeedbackInfoId = questionId + "_" + replyId;
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args.pass = MD5.hash(PlayerManager.Instance.Self.ID + "3kjf2jfwj93pj22jfsl11jjoe12oij");
         args.userid = PlayerManager.Instance.Self.ID;
         args.nick_name = PlayerManager.Instance.Self.NickName;
         args.question_id = questionId;
         args.reply_id = replyId;
         args.appraisal_grade = appraisalGrade;
         args.appraisal_content = AppraisalContent;
         args.token = MD5.hash(questionId.toString() + appraisalGrade + "3kjf2jfwj93pj22jfsl11jjoe12oij");
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("AdvanceQuestionAppraisal.ashx"),BaseLoader.REQUEST_LOADER,args,URLRequestMethod.POST);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadFreeBackComplete);
         LoadResourceManager.Instance.startLoad(loader);
         this.closeFrame();
      }
      
      private function __onLoadFreeBackComplete(event:LoaderEvent) : void
      {
         if(event.loader.content == 1)
         {
            if(this._isSubmitTime)
            {
               this._feedbackTime = TimeManager.Instance.Now();
               ++this._currentOpenInt;
            }
            if(Boolean(this._removeFeedbackInfoId))
            {
               this._feedbackReplyData.remove(this._removeFeedbackInfoId);
               this._removeFeedbackInfoId = null;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.ThankReferQuestion"));
         }
         else if(event.loader.content == -1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.MaxReferTimes"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.SystemBusy"));
         }
         this._isSubmitTime = false;
      }
   }
}

