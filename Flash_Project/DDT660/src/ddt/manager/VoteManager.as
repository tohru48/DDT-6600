package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.analyze.VoteInfoAnalyzer;
   import ddt.data.analyze.VoteSubmitResultAnalyzer;
   import ddt.data.vote.VoteQuestionInfo;
   import ddt.view.vote.VoteView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   
   public class VoteManager extends EventDispatcher
   {
      
      private static var vote:VoteManager;
      
      public static var LOAD_COMPLETED:String = "loadCompleted";
      
      public var loadOver:Boolean = false;
      
      public var showVote:Boolean = true;
      
      public var count:int = 0;
      
      public var questionLength:int = 0;
      
      public var awardDic:Dictionary;
      
      private var voteView:VoteView;
      
      private var list:Dictionary;
      
      private var firstQuestionID:String;
      
      private var completeMessage:String;
      
      private var minGrade:int;
      
      private var maxGrade:int;
      
      private var voteId:String;
      
      private var allAnswer:String = "";
      
      private var answerArr:Array = new Array();
      
      private var isVoteComplete:Boolean;
      
      private var nowVoteQuestionInfo:VoteQuestionInfo;
      
      public function VoteManager()
      {
         super();
      }
      
      public static function get Instance() : VoteManager
      {
         if(vote == null)
         {
            vote = new VoteManager();
         }
         return vote;
      }
      
      public function loadCompleted(analyzer:VoteInfoAnalyzer) : void
      {
         this.loadOver = true;
         this.list = analyzer.list;
         this.voteId = analyzer.voteId;
         this.firstQuestionID = analyzer.firstQuestionID;
         this.completeMessage = analyzer.completeMessage;
         this.minGrade = analyzer.minGrade;
         this.maxGrade = analyzer.maxGrade;
         this.questionLength = analyzer.questionLength;
         this.awardDic = analyzer.awardDic;
         dispatchEvent(new Event(LOAD_COMPLETED));
      }
      
      public function openVote() : void
      {
         var id:String = null;
         if(PlayerManager.Instance.Self.Grade < this.minGrade || PlayerManager.Instance.Self.Grade > this.maxGrade)
         {
            return;
         }
         this.voteView = ComponentFactory.Instance.creatComponentByStylename("vote.VoteView");
         this.voteView.addEventListener(VoteView.OK_CLICK,this.__chosed);
         this.voteView.addEventListener(VoteView.VOTEVIEW_CLOSE,this.__voteViewCLose);
         if(SharedManager.Instance.voteData["userId"] == PlayerManager.Instance.Self.ID)
         {
            id = SharedManager.Instance.voteData["voteId"];
            if(this.voteId == id)
            {
               this.count = SharedManager.Instance.voteData["voteProgress"] - 1;
               this.nextQuetion(SharedManager.Instance.voteData["voteQuestionID"]);
               this.answerArr = SharedManager.Instance.voteData["voteAnswer"];
            }
            else
            {
               this.nextQuetion(this.firstQuestionID);
            }
         }
         else
         {
            this.nextQuetion(this.firstQuestionID);
         }
      }
      
      private function __chosed(e:Event) : void
      {
         this.answerArr.push(this.voteView.selectAnswer);
         this.nextQuetion(this.nowVoteQuestionInfo.nextQuestionID);
      }
      
      private function nextQuetion(questionID:String) : void
      {
         ++this.count;
         if(questionID != "0")
         {
            this.voteView.visible = false;
            this.nowVoteQuestionInfo = this.list[questionID];
            this.voteView.info = this.nowVoteQuestionInfo;
            this.voteView.visible = true;
            LayerManager.Instance.addToLayer(this.voteView,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            this.closeVote();
         }
      }
      
      public function closeVote() : void
      {
         this.loadOver = false;
         this.showVote = false;
         this.voteView.removeEventListener(VoteView.OK_CLICK,this.__chosed);
         this.voteView.dispose();
         this.sendToServer();
      }
      
      private function sendToServer() : void
      {
         var args:URLVariables = null;
         var loader:BaseLoader = null;
         for(var i:int = 0; i < this.answerArr.length; i++)
         {
            args = new URLVariables();
            args["userId"] = PlayerManager.Instance.Self.ID;
            args["voteId"] = this.voteId;
            args["answerContent"] = this.answerArr[i];
            args["rnd"] = Math.random();
            loader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("VoteSubmitResult.ashx"),BaseLoader.REQUEST_LOADER,args,URLRequestMethod.POST);
            loader.analyzer = new VoteSubmitResultAnalyzer(this.getResult);
            LoadResourceManager.Instance.startLoad(loader);
         }
      }
      
      private function getResult(analyzer:VoteSubmitResultAnalyzer) : void
      {
         if(this.isVoteComplete)
         {
            return;
         }
         if(analyzer.result == 1)
         {
            MessageTipManager.getInstance().show(this.completeMessage);
         }
         else
         {
            MessageTipManager.getInstance().show("投票失败!");
         }
         this.isVoteComplete = true;
      }
      
      private function __voteViewCLose(e:Event) : void
      {
         this.voteView = null;
         this.loadOver = false;
         this.showVote = false;
         SharedManager.Instance.voteData["voteId"] = this.voteId;
         SharedManager.Instance.voteData["voteAnswer"] = this.answerArr;
         SharedManager.Instance.voteData["voteProgress"] = this.count;
         SharedManager.Instance.voteData["voteQuestionID"] = this.nowVoteQuestionInfo.questionID;
         SharedManager.Instance.voteData["userId"] = PlayerManager.Instance.Self.ID;
         SharedManager.Instance.save();
      }
   }
}

