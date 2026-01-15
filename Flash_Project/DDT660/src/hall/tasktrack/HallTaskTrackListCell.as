package hall.tasktrack
{
   import bagAndInfo.BagAndInfoManager;
   import collectionTask.CollectionTaskManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.quest.QuestCondition;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import petsBag.PetsBagManager;
   import trainer.data.Step;
   import tryonSystem.TryonSystemController;
   
   public class HallTaskTrackListCell extends Sprite implements Disposeable, IListCell
   {
      
      private var _titleTxt:FilterFrameText;
      
      private var _conditionTxtList:Vector.<FilterFrameText>;
      
      private var _conditionTxtVBox:VBox;
      
      private var _info:QuestInfo;
      
      private var _typeMc:MovieClip;
      
      private var hasOptionalAward:Boolean;
      
      private var _extendUnMc:MovieClip;
      
      private var _questLinkBtn:BaseButton;
      
      public function HallTaskTrackListCell()
      {
         super();
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.cellTitleTxt");
         this._titleTxt.addEventListener(TextEvent.LINK,this.onFinishHandler,false,0,true);
         this._questLinkBtn = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.questLinkBtn");
         this._questLinkBtn.addEventListener(MouseEvent.CLICK,this.__questLinkBtnHandler);
         this._conditionTxtVBox = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.cellVBox");
         this._typeMc = ComponentFactory.Instance.creat("asset.hall.taskTrack.typeMc");
         this._typeMc.mouseEnabled = false;
         this._typeMc.mouseChildren = false;
         this._typeMc.x = 0;
         this._typeMc.y = 0;
         this._extendUnMc = ComponentFactory.Instance.creat("asset.hall.taskTrack.extendUnMC");
         this._extendUnMc.mouseEnabled = false;
         this._extendUnMc.mouseChildren = false;
         this._extendUnMc.x = 3;
         this._extendUnMc.y = 2;
         addChild(this._titleTxt);
         addChild(this._questLinkBtn);
         addChild(this._typeMc);
         addChild(this._conditionTxtVBox);
         addChild(this._extendUnMc);
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(value:*) : void
      {
         this._info = value as QuestInfo;
         this.updateViewData();
      }
      
      private function updateViewData() : void
      {
         var txt:FilterFrameText = null;
         var tmpCondition:Array = null;
         var isHasOpitional:Boolean = false;
         var qc:QuestCondition = null;
         var tmp2:FilterFrameText = null;
         var tmpHtmlText2:String = null;
         var i:int = 0;
         var cond:QuestCondition = null;
         var tmp:FilterFrameText = null;
         var tmpText:String = null;
         var tmpHtmlText:String = null;
         var temp:QuestItemReward = null;
         var tinfo:InventoryItemInfo = null;
         this._conditionTxtVBox.removeAllChild();
         for each(txt in this._conditionTxtList)
         {
            txt.removeEventListener(TextEvent.LINK,this.textClickHandler);
            ObjectUtils.disposeObject(txt);
         }
         this._conditionTxtList = new Vector.<FilterFrameText>();
         this._titleTxt.visible = false;
         this._questLinkBtn.visible = false;
         this._typeMc.visible = false;
         this._extendUnMc.visible = false;
         if(this._info.QuestID < 0)
         {
            this.mouseChildren = false;
            this.buttonMode = true;
            this._typeMc.visible = true;
            this._extendUnMc.visible = true;
            this._typeMc.gotoAndStop(Math.abs(this._info.QuestID));
            this._extendUnMc.gotoAndStop(this._info.Type);
         }
         else
         {
            this.mouseChildren = true;
            this.buttonMode = false;
            this._titleTxt.visible = true;
            this._titleTxt.htmlText = "";
            this._titleTxt.mouseEnabled = false;
            this._titleTxt.text = ">>" + this._info.Title;
            this._questLinkBtn.visible = true;
            tmpCondition = this._info._conditions;
            isHasOpitional = false;
            for each(qc in tmpCondition)
            {
               if(qc.isOpitional)
               {
                  isHasOpitional = true;
                  break;
               }
            }
            if(!this._info.isCompleted)
            {
               if(isHasOpitional)
               {
                  tmp2 = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.cellConditionTxt");
                  tmp2.mouseEnabled = true;
                  tmp2.addEventListener(TextEvent.LINK,this.textClickHandler);
                  this._conditionTxtList.push(tmp2);
                  tmpHtmlText2 = "<u><a href=\"event:-1\">" + LanguageMgr.GetTranslation("hall.taskTrack.tipTxt") + "</a></u>";
                  tmp2.htmlText = tmpHtmlText2;
                  this._conditionTxtVBox.addChild(tmp2);
               }
               else
               {
                  for(i = 0; Boolean(this._info._conditions[i]); i++)
                  {
                     cond = this._info._conditions[i];
                     if(this._info.progress[i] > 0)
                     {
                        tmp = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.cellConditionTxt");
                        tmp.addEventListener(TextEvent.LINK,this.textClickHandler);
                        this._conditionTxtList.push(tmp);
                        tmpText = cond.description + this._info.conditionStatus[i];
                        if(HallTaskTrackManager.instance.isCanTrack(this._info.MapID,this._info._conditions[i].type))
                        {
                           tmpHtmlText = "<u><a href=\"event:" + this._info._conditions[i].type + "\">" + tmpText + "</a></u>";
                           tmp.htmlText = tmpHtmlText;
                           tmp.mouseEnabled = true;
                        }
                        else
                        {
                           tmp.htmlText = tmpText;
                           tmp.mouseEnabled = false;
                        }
                        this._conditionTxtVBox.addChild(tmp);
                     }
                  }
               }
            }
            this.hasOptionalAward = false;
            if(this._conditionTxtVBox.numChildren <= 0)
            {
               this._titleTxt.text = ">>" + this._info.Title + LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.over");
               this._titleTxt.htmlText = "<a href=\"event:1\">" + this._titleTxt.text + "</a>";
               this._titleTxt.mouseEnabled = true;
               this._titleTxt.textColor = 3652688;
               this._questLinkBtn.visible = true;
               for each(temp in this._info.itemRewards)
               {
                  tinfo = new InventoryItemInfo();
                  tinfo.TemplateID = temp.itemID;
                  ItemManager.fill(tinfo);
                  if(!(0 != tinfo.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != tinfo.NeedSex))
                  {
                     if(temp.isOptional == 1)
                     {
                        this.hasOptionalAward = true;
                     }
                  }
               }
            }
         }
         if(this._info.QuestID < 0 && this._info.Type == 2)
         {
            this._info.cellHeight = this.height + 3;
         }
         else
         {
            this._info.cellHeight = this.height + 7;
         }
         this._questLinkBtn.x = this._titleTxt.x + this._titleTxt.textWidth + 2;
         this._questLinkBtn.y = this._titleTxt.y - 2;
      }
      
      private function onFinishHandler(event:TextEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._info.RewardBindMoney != 0 && this._info.RewardBindMoney + PlayerManager.Instance.Self.BandMoney > ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel))
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.BindBid.tip"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"),false,false,true,1);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         else
         {
            this.finishQuest(this._info);
         }
      }
      
      private function finishQuest(pQuestInfo:QuestInfo) : void
      {
         var items:Array = null;
         var temp:QuestItemReward = null;
         var info:InventoryItemInfo = null;
         if(Boolean(pQuestInfo) && !pQuestInfo.isCompleted)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.dropTaskIII"));
            this.setCellValue(pQuestInfo);
            return;
         }
         if(this.hasOptionalAward)
         {
            items = [];
            for each(temp in pQuestInfo.itemRewards)
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
               info.Count = temp.count[pQuestInfo.QuestLevel - 1];
               if(!(0 != info.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != info.NeedSex))
               {
                  if(temp.isOptional == 1)
                  {
                     items.push(info);
                  }
               }
            }
            HallTaskTrackManager.instance.moduleLoad(this.showSelectedAwardFrame,[items]);
         }
         else
         {
            TaskManager.instance.sendQuestFinish(this._info.QuestID);
            if(TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(318)) && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(319)))
            {
               SocketManager.Instance.out.syncWeakStep(Step.ACHIVED_THREE_QUEST);
            }
         }
      }
      
      private function showSelectedAwardFrame(items:Array) : void
      {
         TryonSystemController.Instance.show(items,this.chooseReward,null);
      }
      
      private function __onResponse(pEvent:FrameEvent) : void
      {
         pEvent.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(pEvent.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.finishQuest(this._info);
         }
         ObjectUtils.disposeObject(pEvent.currentTarget);
      }
      
      private function getSexByInt(Sex:Boolean) : int
      {
         if(Sex)
         {
            return 1;
         }
         return 2;
      }
      
      private function chooseReward(item:ItemTemplateInfo) : void
      {
         SocketManager.Instance.out.sendQuestFinish(this._info.QuestID,item.TemplateID);
      }
      
      private function textClickHandler(event:TextEvent) : void
      {
         if(this._info.MapID > 0)
         {
            TaskManager.instance.jumpToQuestByID(this._info.QuestID);
            return;
         }
         var tmp:int = int(event.text);
         switch(tmp)
         {
            case -1:
               TaskManager.instance.jumpToQuestByID(this._info.QuestID);
               break;
            case 4:
            case 5:
            case 6:
            case 22:
            case 23:
            case 24:
            case 26:
            case 31:
            case 34:
            case 36:
            case 37:
               (HallTaskTrackManager.instance.btnList[1] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 9:
               (HallTaskTrackManager.instance.btnList[10] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 10:
               StateManager.setState(StateType.SHOP);
               break;
            case 11:
               (HallTaskTrackManager.instance.btnList[10] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 13:
               (HallTaskTrackManager.instance.btnList[0] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 19:
               (HallTaskTrackManager.instance.btnList[10] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 21:
               (HallTaskTrackManager.instance.btnList[0] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 39:
               BagAndInfoManager.Instance.showBagAndInfo();
               break;
            case 50:
            case 60:
               PetsBagManager.instance.show();
               break;
            case 51:
               (HallTaskTrackManager.instance.btnList[3] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 56:
               (HallTaskTrackManager.instance.btnList[2] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 57:
               (HallTaskTrackManager.instance.btnList[2] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 58:
               (HallTaskTrackManager.instance.btnList[10] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 59:
               (HallTaskTrackManager.instance.btnList[10] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 61:
               SocketManager.Instance.out.enterBuried();
               break;
            case 64:
               CollectionTaskManager.Instance.setUp();
               break;
            case 65:
               (HallTaskTrackManager.instance.btnList[4] as BaseButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      private function refreshType() : void
      {
         switch(this._info.Type)
         {
            case 0:
               this._typeMc.gotoAndStop(1);
               break;
            case 1:
            case 6:
               this._typeMc.gotoAndStop(2);
               break;
            case 2:
               this._typeMc.gotoAndStop(3);
               break;
            case 3:
               this._typeMc.gotoAndStop(4);
               break;
            case 10:
               this._typeMc.gotoAndStop(5);
         }
      }
      
      private function __questLinkBtnHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         TaskManager.instance.jumpToQuestByID(this._info.QuestID);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         var txt:FilterFrameText = null;
         this._titleTxt.removeEventListener(TextEvent.LINK,this.onFinishHandler);
         this._questLinkBtn.removeEventListener(MouseEvent.CLICK,this.__questLinkBtnHandler);
         ObjectUtils.disposeObject(this._questLinkBtn);
         this._questLinkBtn = null;
         for each(txt in this._conditionTxtList)
         {
            txt.removeEventListener(TextEvent.LINK,this.textClickHandler);
            ObjectUtils.disposeObject(txt);
         }
         ObjectUtils.disposeAllChildren(this);
         this._titleTxt = null;
         this._conditionTxtList = null;
         this._conditionTxtVBox = null;
         this._info = null;
         this._typeMc = null;
         this._extendUnMc = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

