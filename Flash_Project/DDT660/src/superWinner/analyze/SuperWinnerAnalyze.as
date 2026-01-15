package superWinner.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import superWinner.data.SuperWinnerAwardsMode;
   
   public class SuperWinnerAnalyze extends DataAnalyzer
   {
      
      private var _awardsArr:Vector.<Object> = new Vector.<Object>();
      
      public function SuperWinnerAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var vec:Vector.<SuperWinnerAwardsMode> = null;
         var tpXml:XML = null;
         var index:uint = 0;
         var mode:SuperWinnerAwardsMode = null;
         var xml:XML = new XML(data);
         var xmllist:XMLList = xml..Item;
         for(var ii:int = 0; ii < 6; ii++)
         {
            vec = new Vector.<SuperWinnerAwardsMode>();
            this._awardsArr.push(vec);
         }
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            tpXml = xmllist[i];
            index = tpXml.@rank - 1;
            mode = new SuperWinnerAwardsMode();
            mode.type = tpXml.@rank;
            mode.goodId = tpXml.@template;
            mode.count = tpXml.@count;
            (this._awardsArr[5 - index] as Vector.<SuperWinnerAwardsMode>).push(mode);
         }
         onAnalyzeComplete();
      }
      
      public function get awards() : Vector.<Object>
      {
         return this._awardsArr;
      }
   }
}

