package quest
{
   public class QuestDescTextAnalyz
   {
      
      public function QuestDescTextAnalyz()
      {
         super();
      }
      
      public static function start(str:String) : String
      {
         var newstr:String = str;
         var regArr:Array = new Array(/cr>|cg>|cb>/gi,/<cr/gi,/<cg/gi,/<cb/gi,/【/gi,/】/gi);
         var strArr:Array = new Array("</font><font>","</font><font COLOR=\'#FF0000\'>","</font><font COLOR=\'#00FF00\'>","</font><font COLOR=\'#0000FF\'>","</font><a href=\'http://blog.163.com/redirect.html\'><font COLOR=\'#00FF00\'><u>","</u></font></a><font>");
         for(var i:int = 0; i < regArr.length; i++)
         {
            newstr = newstr.replace(regArr[i],strArr[i]);
         }
         return "<font>" + newstr + "</font>";
      }
   }
}

