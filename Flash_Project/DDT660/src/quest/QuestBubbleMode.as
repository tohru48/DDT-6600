package quest
{
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TaskManager;
   
   public class QuestBubbleMode
   {
      
      private var _questInfoCompleteArr:Array;
      
      private var _questInfoArr:Array;
      
      private var _questInfoTxtArr:Array;
      
      private var _isShowIn:Boolean;
      
      public function QuestBubbleMode()
      {
         super();
      }
      
      public function get questsInfo() : Array
      {
         var arr:Array = [];
         this._questInfoCompleteArr = [];
         this._questInfoArr = [];
         arr = TaskManager.instance.getAvailableQuests().list;
         return this._reseachComplete(arr);
      }
      
      private function _addInfoToArr(info:QuestInfo) : void
      {
         if(info.canViewWithProgress && this._questInfoArr.length < 5 && (!this._isShowIn || this._isShowIn && info.isCompleted))
         {
            this._questInfoArr.push(info);
         }
      }
      
      private function _reseachComplete(arr:Array) : Array
      {
         this._reseachInfoForId(arr);
         return this._setTxtInArr();
      }
      
      private function _setTxtInArr() : Array
      {
         var dn:int = 0;
         var numerator:Number = NaN;
         var denominator:Number = NaN;
         var n:int = 0;
         var obj:Object = null;
         var dnumerator:int = 0;
         var ddenominator:int = 0;
         var arr:Array = new Array();
         for(var i:int = 0; i < this._questInfoArr.length; i++)
         {
            dn = 0;
            numerator = Number(QuestInfo(this._questInfoArr[i]).progress[0]);
            denominator = Number(QuestInfo(this._questInfoArr[i])._conditions[0].target);
            for(n = 1; Boolean(QuestInfo(this._questInfoArr[i])._conditions[n]); n++)
            {
               dnumerator = int(QuestInfo(this._questInfoArr[i]).progress[n]);
               ddenominator = int(QuestInfo(this._questInfoArr[i])._conditions[n].target);
               if(dnumerator != 0)
               {
                  if(dnumerator / ddenominator < numerator / denominator || numerator == 0)
                  {
                     numerator = dnumerator;
                     denominator = ddenominator;
                     dn = n;
                  }
               }
            }
            obj = new Object();
            switch(QuestInfo(this._questInfoArr[i]).Type)
            {
               case 0:
                  obj.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.TankLink");
                  break;
               case 1:
                  obj.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.BranchLine");
                  break;
               case 2:
                  obj.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.Daily");
                  break;
               case 3:
                  obj.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.Act");
                  break;
               case 4:
                  obj.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.VIP");
            }
            if(QuestInfo(this._questInfoArr[i]).isCompleted)
            {
               obj.txtI = "<font COLOR=\'#8be961\'>" + obj.txtI + "</font>";
               obj.txtII = "<font COLOR=\'#8be961\'>" + this._analysisStrIII(QuestInfo(this._questInfoArr[i])) + "</font>";
               obj.txtIII = "<font COLOR=\'#8be961\'>" + this._analysisStrIV(QuestInfo(this._questInfoArr[i])) + "</font>";
            }
            else
            {
               obj.txtII = this._analysisStrII(QuestInfo(this._questInfoArr[i])._conditions[dn].description);
               obj.txtIII = QuestInfo(this._questInfoArr[i]).conditionStatus[dn];
            }
            arr.push(obj);
         }
         return arr;
      }
      
      private function _analysisStrII(strII:String) : String
      {
         var str:String = null;
         if(strII.length <= 6)
         {
            str = strII;
         }
         else
         {
            str = strII.substr(0,6);
            str += "...";
         }
         return str;
      }
      
      private function _analysisStrIII(questInfo:QuestInfo) : String
      {
         var str:String = "";
         for(var i:int = 0; i < questInfo._conditions.length; i++)
         {
            if(questInfo.progress[i] <= 0 || questInfo.isCompleted)
            {
               return questInfo._conditions[i].description;
            }
         }
         return str;
      }
      
      private function _analysisStrIV(questInfo:QuestInfo) : String
      {
         var str:String = "";
         for(var i:int = 0; i < questInfo._conditions.length; i++)
         {
            if(questInfo.progress[i] <= 0 || questInfo.isCompleted)
            {
               return questInfo.conditionStatus[i];
            }
         }
         return str;
      }
      
      private function _reseachInfoForId(arr:Array) : void
      {
         var num:Number = NaN;
         var obj:IndexObj = null;
         var numArr:Array = [];
         var completeArray:Array = [];
         var noCompleteArray:Array = [];
         for(var i:int = 0; i < arr.length; i++)
         {
            num = QuestInfo(arr[i]).questProgressNum;
            obj = new IndexObj(i,num);
            if(QuestInfo(arr[i]).isCompleted)
            {
               completeArray.push(obj);
            }
            else
            {
               noCompleteArray.push(obj);
            }
         }
         completeArray.sortOn("progressNum",Array.NUMERIC);
         noCompleteArray.sortOn("progressNum",Array.NUMERIC);
         numArr = completeArray.concat(noCompleteArray);
         for(i = 0; i < numArr.length; i++)
         {
            this._questInfoCompleteArr.push(QuestInfo(arr[numArr[i].id]));
         }
         var n:int = 0;
         for(i = 0; i < this._questInfoCompleteArr.length; i++)
         {
            if(this._questInfoCompleteArr[i].questProgressNum != this._questInfoCompleteArr[n].questProgressNum)
            {
               this._checkInfoArr(4,n,i);
               this._checkInfoArr(3,n,i);
               this._checkInfoArr(2,n,i);
               this._checkInfoArr(0,n,i);
               this._checkInfoArr(1,n,i);
               n = i;
            }
         }
         this._checkInfoArr(4,n,this._questInfoCompleteArr.length);
         this._checkInfoArr(3,n,this._questInfoCompleteArr.length);
         this._checkInfoArr(2,n,this._questInfoCompleteArr.length);
         this._checkInfoArr(0,n,this._questInfoCompleteArr.length);
         this._checkInfoArr(1,n,this._questInfoCompleteArr.length);
      }
      
      private function _checkInfoArr(id:int, idI:int, idII:int) : void
      {
         for(var i:int = idI; i < idII; i++)
         {
            if(QuestInfo(this._questInfoCompleteArr[i]).Type == id)
            {
               this._addInfoToArr(this._questInfoCompleteArr[i]);
            }
         }
      }
      
      public function getQuestInfoById(id:int) : QuestInfo
      {
         return this._questInfoArr[id];
      }
   }
}

class IndexObj
{
   
   public var id:int;
   
   public var progressNum:Number;
   
   public function IndexObj(numI:int, numII:Number)
   {
      super();
      this.id = numI;
      this.progressNum = numII;
   }
}
