package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.vote.VoteQuestionInfo;
   import ddt.view.vote.VoteInfo;
   import flash.utils.Dictionary;
   
   public class VoteInfoAnalyzer extends DataAnalyzer
   {
      
      public var firstQuestionID:String;
      
      public var completeMessage:String;
      
      public var questionLength:int;
      
      public var list:Dictionary;
      
      public var voteId:String;
      
      public var minGrade:int;
      
      public var maxGrade:int;
      
      private var _award:String;
      
      private var _awardDic:Dictionary;
      
      public function VoteInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      public function get awardDic() : Dictionary
      {
         var temp:Array = null;
         if(this._award == "")
         {
            return null;
         }
         var awardArr:Array = this._award.split(",");
         for(var i:int = 0; i < awardArr.length; i++)
         {
            temp = awardArr[i].split("|");
            if(Boolean(temp))
            {
               this._awardDic[temp[0]] = temp[1];
            }
         }
         return this._awardDic;
      }
      
      override public function analyze(data:*) : void
      {
         var info:VoteQuestionInfo = null;
         var answerList:XMLList = null;
         var j:int = 0;
         var voteInfo:VoteInfo = null;
         this._awardDic = new Dictionary();
         this.list = new Dictionary();
         var xml:XML = new XML(data);
         this.voteId = xml.@voteId;
         this.firstQuestionID = xml.@firstQuestionID;
         this.completeMessage = xml.@completeMessage;
         this.minGrade = xml.@minGrade;
         this.maxGrade = xml.@maxGrade;
         this._award = xml.@award;
         var itemList:XMLList = xml..item;
         this.questionLength = itemList.length();
         for(var i:int = 0; i < itemList.length(); i++)
         {
            info = new VoteQuestionInfo();
            info.questionID = itemList[i].@id;
            info.multiple = itemList[i].@multiple == "true" ? true : false;
            info.otherSelect = itemList[i].@otherSelect == "true" ? true : false;
            info.question = itemList[i].@question;
            info.nextQuestionID = itemList[i].@nextQuestionID;
            info.questionType = itemList[i].@questionType;
            answerList = itemList[i]..answer;
            info.answerLength = answerList.length();
            for(j = 0; j < answerList.length(); j++)
            {
               voteInfo = new VoteInfo();
               voteInfo.answerId = answerList[j].@id;
               voteInfo.answer = answerList[j].@value;
               info.answer.push(voteInfo);
            }
            this.list[info.questionID] = info;
         }
         onAnalyzeComplete();
      }
   }
}

