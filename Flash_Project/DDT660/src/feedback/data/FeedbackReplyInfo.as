package feedback.data
{
   public class FeedbackReplyInfo
   {
      
      private var _questionId:String;
      
      private var _questionTitle:String;
      
      private var _occurrenceDate:String;
      
      private var _questionContent:String;
      
      private var _replyId:int;
      
      private var _nickName:String;
      
      private var _replyDate:Date;
      
      private var _replyContent:String;
      
      private var _stopReply:String;
      
      public function FeedbackReplyInfo()
      {
         super();
      }
      
      public function get questionId() : String
      {
         return this._questionId;
      }
      
      public function set questionId(value:String) : void
      {
         this._questionId = value;
      }
      
      public function get replyId() : int
      {
         return this._replyId;
      }
      
      public function set replyId(value:int) : void
      {
         this._replyId = value;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
      
      public function set nickName(value:String) : void
      {
         this._nickName = value;
      }
      
      public function get replyDate() : Date
      {
         return this._replyDate;
      }
      
      public function set replyDate(value:Date) : void
      {
         this._replyDate = value;
      }
      
      public function get replyContent() : String
      {
         return this._replyContent;
      }
      
      public function set replyContent(value:String) : void
      {
         this._replyContent = value;
      }
      
      public function get stopReply() : String
      {
         return this._stopReply;
      }
      
      public function set stopReply(value:String) : void
      {
         this._stopReply = value;
      }
      
      public function get questionTitle() : String
      {
         return this._questionTitle;
      }
      
      public function set questionTitle(value:String) : void
      {
         this._questionTitle = value;
      }
      
      public function get occurrenceDate() : String
      {
         return this._occurrenceDate;
      }
      
      public function set occurrenceDate(value:String) : void
      {
         this._occurrenceDate = value;
      }
      
      public function get questionContent() : String
      {
         return this._questionContent;
      }
      
      public function set questionContent(value:String) : void
      {
         this._questionContent = value;
      }
   }
}

