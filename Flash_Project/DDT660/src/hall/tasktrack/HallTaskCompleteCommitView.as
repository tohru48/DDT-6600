package hall.tasktrack
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import trainer.data.Step;
   import tryonSystem.TryonSystemController;
   
   public class HallTaskCompleteCommitView extends Sprite implements Disposeable
   {
      
      private var _commitBtnTxt:FilterFrameText;
      
      private var _questInfo:QuestInfo;
      
      private var _questId:int;
      
      private var _timeOutId:int;
      
      public function HallTaskCompleteCommitView(questId:int)
      {
         super();
         this._questId = questId;
         this._questInfo = TaskManager.instance.getQuestByID(this._questId);
         this.initView();
         this._timeOutId = setTimeout(this.dispose,5500);
      }
      
      private function initView() : void
      {
         var bg:MovieClip = null;
         var contentTxt:FilterFrameText = null;
         bg = ComponentFactory.Instance.creat("asset.hall.taskComplete.commitView.bg");
         contentTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskCompleteCommitView.contentTxt");
         contentTxt.text = this.getTypeStr(this._questInfo) + LanguageMgr.GetTranslation("hall.taskCompleteCommit.contentTxt",this._questInfo.Title);
         this._commitBtnTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskCompleteCommitView.commitBtnTxt");
         this._commitBtnTxt.htmlText = "<u><a href=\"event:1\">" + LanguageMgr.GetTranslation("hall.taskCompleteCommit.commitTxt") + "</a></u>";
         this._commitBtnTxt.addEventListener(TextEvent.LINK,this.textClickHandler);
         this._commitBtnTxt.mouseEnabled = true;
         this._commitBtnTxt.selectable = false;
         addChild(bg);
         addChild(contentTxt);
         addChild(this._commitBtnTxt);
      }
      
      private function textClickHandler(event:TextEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._questInfo.RewardBindMoney != 0 && this._questInfo.RewardBindMoney + PlayerManager.Instance.Self.BandMoney > ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel))
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.BindBid.tip"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"),false,false,true,1);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         else
         {
            this.finishQuest();
         }
      }
      
      private function __onResponse(pEvent:FrameEvent) : void
      {
         pEvent.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(pEvent.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.finishQuest();
         }
         ObjectUtils.disposeObject(pEvent.currentTarget);
      }
      
      private function finishQuest() : void
      {
         var temp:QuestItemReward = null;
         var info:InventoryItemInfo = null;
         var items:Array = [];
         for each(temp in this._questInfo.itemRewards)
         {
            info = new InventoryItemInfo();
            info.TemplateID = temp.itemID;
            ItemManager.fill(info);
            info.ValidDate = temp.ValidateTime;
            info.TemplateID = temp.itemID;
            info.IsJudge = true;
            info.IsBinds = temp.isBind;
            info.AttackCompose = temp.AttackCompose;
            info.DefendCompose = temp.DefendCompose;
            info.AgilityCompose = temp.AgilityCompose;
            info.LuckCompose = temp.LuckCompose;
            info.StrengthenLevel = temp.StrengthenLevel;
            info.Count = temp.count[this._questInfo.QuestLevel - 1];
            if(!(0 != info.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != info.NeedSex))
            {
               if(temp.isOptional == 1)
               {
                  items.push(info);
               }
            }
         }
         if(items.length > 0)
         {
            HallTaskTrackManager.instance.moduleLoad(this.showSelectedAwardFrame,[items]);
         }
         else
         {
            TaskManager.instance.sendQuestFinish(this._questInfo.QuestID);
            if(TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(318)) && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(319)))
            {
               SocketManager.Instance.out.syncWeakStep(Step.ACHIVED_THREE_QUEST);
            }
         }
         clearTimeout(this._timeOutId);
         this._questInfo = null;
         this.dispose();
      }
      
      private function showSelectedAwardFrame(items:Array) : void
      {
         TryonSystemController.Instance.show(items,this.chooseReward,null);
      }
      
      private function chooseReward(item:ItemTemplateInfo) : void
      {
         SocketManager.Instance.out.sendQuestFinish(this._questId,item.TemplateID);
      }
      
      private function getSexByInt(Sex:Boolean) : int
      {
         if(Sex)
         {
            return 1;
         }
         return 2;
      }
      
      private function getTypeStr(questInfo:QuestInfo) : String
      {
         var tmp:String = "";
         switch(questInfo.Type)
         {
            case 0:
               tmp = LanguageMgr.GetTranslation("tank.view.quest.bubble.TankLink");
               break;
            case 1:
            case 6:
               tmp = LanguageMgr.GetTranslation("tank.view.quest.bubble.BranchLine");
               break;
            case 2:
               tmp = LanguageMgr.GetTranslation("tank.view.quest.bubble.Daily");
               break;
            case 3:
               tmp = LanguageMgr.GetTranslation("tank.view.quest.bubble.Act");
               break;
            case 10:
               tmp = LanguageMgr.GetTranslation("tank.view.quest.bubble.buried");
         }
         return tmp;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._commitBtnTxt))
         {
            this._commitBtnTxt.removeEventListener(TextEvent.LINK,this.textClickHandler);
         }
         ObjectUtils.disposeAllChildren(this);
         this._commitBtnTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

