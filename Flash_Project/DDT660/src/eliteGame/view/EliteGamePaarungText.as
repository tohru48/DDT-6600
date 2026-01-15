package eliteGame.view
{
   import com.pickgliss.ui.text.FilterFrameText;
   
   public class EliteGamePaarungText extends FilterFrameText
   {
      
      private var _acceptRankArr:Array;
      
      public var playerId:int;
      
      public function EliteGamePaarungText()
      {
         super();
      }
      
      public function set acceptRank(value:String) : void
      {
         this._acceptRankArr = value.split(",");
      }
      
      public function canAccept(value:int) : Boolean
      {
         for(var i:int = 0; i < this._acceptRankArr.length; i++)
         {
            if(value == parseInt(this._acceptRankArr[i]))
            {
               return true;
            }
         }
         return false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

