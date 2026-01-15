package consortionBattle.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.event.ConsBatEvent;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class ConsBatChatView extends Sprite implements Disposeable
   {
      
      private var _cellList:Array;
      
      private var _dataList:Array = [];
      
      public function ConsBatChatView()
      {
         super();
         this.y = 116;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var cell:ConsBatChatViewCell = null;
         this._cellList = [];
         for(var i:int = 0; i < 3; i++)
         {
            cell = new ConsBatChatViewCell();
            cell.index = i;
            cell.addEventListener(ConsBatChatViewCell.GUARD_COMPLETE,this.guardCompleteHandler,false,0,true);
            cell.addEventListener(ConsBatChatViewCell.DISAPPEAR_COMPLETE,this.disappearCompleteHandler,false,0,true);
            addChild(cell);
            this._cellList.push(cell);
         }
      }
      
      private function guardCompleteHandler(event:Event) : void
      {
         if(!this._dataList || this._dataList.length <= 0)
         {
            return;
         }
         var cell:ConsBatChatViewCell = event.target as ConsBatChatViewCell;
         this.changeCellIndex(cell);
         cell.setText(this.getTxtStr(this._dataList.splice(0,1)[0]));
      }
      
      private function disappearCompleteHandler(event:Event) : void
      {
         var cell:ConsBatChatViewCell = event.target as ConsBatChatViewCell;
         this.changeCellIndex(cell);
         if(Boolean(this._dataList) && this._dataList.length > 0)
         {
            cell.setText(this.getTxtStr(this._dataList.splice(0,1)[0]));
         }
      }
      
      private function changeCellIndex(cell:ConsBatChatViewCell) : void
      {
         if(cell.index == 0)
         {
            (this._cellList[1] as ConsBatChatViewCell).index = 0;
            (this._cellList[2] as ConsBatChatViewCell).index = 1;
         }
         else if(cell.index == 1)
         {
            (this._cellList[2] as ConsBatChatViewCell).index = 1;
         }
         cell.index = 2;
         this._cellList.sortOn("index",Array.NUMERIC);
      }
      
      private function getTxtStr(data:Object) : String
      {
         var tmp:String = null;
         if(data.type == 1)
         {
            if(data.winningStreak == 3)
            {
               tmp = LanguageMgr.GetTranslation("ddt.consortiaBattle.chatPrompt.threeWinningStreakTxt",data.winner);
            }
            else if(data.winningStreak == 6)
            {
               tmp = LanguageMgr.GetTranslation("ddt.consortiaBattle.chatPrompt.sixWinningStreakTxt",data.winner);
            }
            else if(data.winningStreak >= 10)
            {
               tmp = LanguageMgr.GetTranslation("ddt.consortiaBattle.chatPrompt.tenWinningStreakTxt",data.winner);
            }
         }
         else
         {
            tmp = LanguageMgr.GetTranslation("ddt.consortiaBattle.chatPrompt.terminatorTxt",data.winner,data.loser,data.winningStreak);
         }
         return tmp;
      }
      
      private function initEvent() : void
      {
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.BROADCAST,this.getMessageHandler);
      }
      
      private function getMessageHandler(event:ConsBatEvent) : void
      {
         var pkg:PackageIn = event.data as PackageIn;
         var tmpData:Object = {};
         tmpData.type = pkg.readByte();
         if(tmpData.type == 1)
         {
            tmpData.winningStreak = pkg.readInt();
            tmpData.winner = pkg.readUTF();
         }
         else
         {
            tmpData.winningStreak = pkg.readInt();
            tmpData.loser = pkg.readUTF();
            tmpData.winner = pkg.readUTF();
         }
         this._dataList.push(tmpData);
         this.setCellTxt();
      }
      
      private function setCellTxt() : void
      {
         var len:int = int(this._cellList.length);
         for(var i:int = 0; i < len; )
         {
            if(!(this._cellList[i] as ConsBatChatViewCell).isActive)
            {
               this._cellList[i].setText(this.getTxtStr(this._dataList.splice(0,1)[0]));
               break;
            }
            i++;
         }
         if(i >= len)
         {
            if(!(this._cellList[0] as ConsBatChatViewCell).isGuard)
            {
               this._cellList[0].setText(this.getTxtStr(this._dataList.splice(0,1)[0]));
               this.changeCellIndex(this._cellList[0] as ConsBatChatViewCell);
            }
         }
      }
      
      public function dispose() : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.BROADCAST,this.getMessageHandler);
         for(var i:int = 0; i < 3; i++)
         {
            this._cellList[i].removeEventListener(ConsBatChatViewCell.GUARD_COMPLETE,this.guardCompleteHandler);
            this._cellList[i].removeEventListener(ConsBatChatViewCell.DISAPPEAR_COMPLETE,this.disappearCompleteHandler);
         }
         ObjectUtils.disposeAllChildren(this);
         this._cellList = null;
         this._dataList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

