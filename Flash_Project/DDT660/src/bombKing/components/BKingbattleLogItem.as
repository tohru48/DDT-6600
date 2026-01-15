package bombKing.components
{
   import bombKing.BombKingManager;
   import bombKing.data.BKingLogInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   
   public class BKingbattleLogItem extends Sprite implements Disposeable
   {
      
      private var _infoTxt:FilterFrameText;
      
      private var _logTxt:FilterFrameText;
      
      private var _info:BKingLogInfo;
      
      public function BKingbattleLogItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._infoTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.Log.infoTxt");
         addChild(this._infoTxt);
         this._infoTxt.htmlText = LanguageMgr.GetTranslation("bombKing.log.infoTxt","冠军赛","今晚吃什么","铁板牛肉行不行");
         this._logTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.Log.logTxt");
         addChild(this._logTxt);
         var str:String = LanguageMgr.GetTranslation("bombKing.log.logTxt","test");
         this._logTxt.htmlText = str;
         this._logTxt.mouseEnabled = true;
         this._logTxt.setFocus();
      }
      
      private function initEvents() : void
      {
         this._logTxt.addEventListener(TextEvent.LINK,this.__linkHandler);
      }
      
      protected function __linkHandler(event:TextEvent) : void
      {
         if(BombKingManager.instance.status != 2)
         {
            BombKingManager.instance.ReportID = this._info.reportId;
            SocketManager.Instance.out.sendNewHallBattle();
            BombKingManager.instance.Recording = true;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bombKing.cancelFirst"));
         }
      }
      
      public function get info() : BKingLogInfo
      {
         return this._info;
      }
      
      public function set info(info:BKingLogInfo) : void
      {
         if(this._info == info)
         {
            return;
         }
         this._info = info;
         var arr:Array = this.getResultStr(this._info.result);
         this._infoTxt.htmlText = LanguageMgr.GetTranslation("bombKing.log.infoTxt",this.getTitle(info.stage),info.name + arr[0],info.fightName + arr[1]);
         this._logTxt.htmlText = LanguageMgr.GetTranslation("bombKing.log.logTxt",info.reportId);
      }
      
      private function getTitle(stage:int) : String
      {
         switch(stage)
         {
            case 1:
               return LanguageMgr.GetTranslation("bombKing.log.stage1");
            case 2:
               return LanguageMgr.GetTranslation("bombKing.log.stage2");
            case 3:
               return LanguageMgr.GetTranslation("bombKing.log.stage3");
            case 4:
               return LanguageMgr.GetTranslation("bombKing.log.stage4");
            case 5:
               return LanguageMgr.GetTranslation("bombKing.log.stage5");
            case 6:
               return LanguageMgr.GetTranslation("bombKing.log.stage6");
            case 7:
               return LanguageMgr.GetTranslation("bombKing.log.stage7");
            default:
               return "";
         }
      }
      
      private function getResultStr(result:Boolean) : Array
      {
         if(result)
         {
            return [LanguageMgr.GetTranslation("bombKing.win"),LanguageMgr.GetTranslation("bombKing.lose")];
         }
         return [LanguageMgr.GetTranslation("bombKing.lose"),LanguageMgr.GetTranslation("bombKing.win")];
      }
      
      private function removeEvents() : void
      {
         this._logTxt.removeEventListener(TextEvent.LINK,this.__linkHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._infoTxt);
         this._infoTxt = null;
         ObjectUtils.disposeObject(this._logTxt);
         this._logTxt = null;
      }
   }
}

