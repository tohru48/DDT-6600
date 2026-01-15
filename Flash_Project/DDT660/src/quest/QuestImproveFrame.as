package quest
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedManager;
   import flash.display.Sprite;
   
   public class QuestImproveFrame extends BaseAlerFrame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _textFieldStyle:String;
      
      protected var _textField:FilterFrameText;
      
      private var _contian:Sprite;
      
      private var _questInfo:QuestInfo;
      
      private var _isOptional:Boolean;
      
      private var _list:SimpleTileList;
      
      private var _items:Vector.<QuestRewardCell>;
      
      private var _spand:int;
      
      private var _first:Boolean;
      
      public function QuestImproveFrame()
      {
         super();
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"));
         alertInfo.submitLabel = LanguageMgr.GetTranslation("ok");
         alertInfo.moveEnable = false;
         info = alertInfo;
         this._first = true;
         this._items = new Vector.<QuestRewardCell>();
         addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         this.initView();
      }
      
      public function set spand(value:int) : void
      {
         this._spand = value;
         this._textField.htmlText = LanguageMgr.GetTranslation("tank.manager.TaskManager.improveText",this._spand);
      }
      
      public function set isOptional(value:Boolean) : void
      {
         this._isOptional = value;
      }
      
      private function initView() : void
      {
         this._contian = new Sprite();
         this._contian.y = 40;
         addToContent(this._contian);
         this._textField = ComponentFactory.Instance.creat("core.quest.QuestSpandText");
         addToContent(this._textField);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.questBack.bg");
         this._contian.addChild(this._bg);
         this._list = new SimpleTileList(2);
         if(!this._isOptional)
         {
            PositionUtils.setPos(this._list,"quest.awardPanel.listposr");
         }
         else
         {
            PositionUtils.setPos(this._list,"quest.awardPanel.listposr1");
         }
         this._contian.addChild(this._list);
      }
      
      public function set questInfo(value:QuestInfo) : void
      {
         var temp:QuestItemReward = null;
         var tinfo:InventoryItemInfo = null;
         var level:int = 0;
         var item:QuestRewardCell = null;
         this._questInfo = value;
         for each(temp in this._questInfo.itemRewards)
         {
            tinfo = new InventoryItemInfo();
            tinfo.TemplateID = temp.itemID;
            ItemManager.fill(tinfo);
            tinfo.ValidDate = temp.ValidateTime;
            tinfo.IsJudge = true;
            tinfo.IsBinds = temp.isBind;
            tinfo.AttackCompose = temp.AttackCompose;
            tinfo.DefendCompose = temp.DefendCompose;
            tinfo.AgilityCompose = temp.AgilityCompose;
            tinfo.LuckCompose = temp.LuckCompose;
            tinfo.StrengthenLevel = temp.StrengthenLevel;
            if(EquipType.isMagicStone(tinfo.CategoryID))
            {
               tinfo.Level = tinfo.StrengthenLevel;
               tinfo.Attack = tinfo.AttackCompose;
               tinfo.Defence = tinfo.DefendCompose;
               tinfo.Agility = tinfo.AgilityCompose;
               tinfo.Luck = tinfo.LuckCompose;
               tinfo.MagicAttack = temp.MagicAttack;
               tinfo.MagicDefence = temp.MagicDefence;
            }
            if(this._questInfo.QuestLevel > 4)
            {
               level = 4;
            }
            else
            {
               level = this._questInfo.QuestLevel;
            }
            tinfo.Count = temp.count[level];
            if(!(0 != tinfo.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != tinfo.NeedSex))
            {
               if(temp.isOptional == this._isOptional)
               {
                  item = new QuestRewardCell();
                  item.info = tinfo;
                  if(Boolean(temp.isOptional))
                  {
                     item.canBeSelected();
                  }
                  this._list.addChild(item);
                  this._items.push(item);
               }
            }
         }
         if(this._isOptional)
         {
            return;
         }
         if(!this._questInfo.hasOtherAward())
         {
            this._list.y = 5;
         }
         var index:int = 0;
         if(this._questInfo.RewardGP > 0)
         {
            this.addReward("exp",this._questInfo.RewardGP,index);
            index++;
         }
         if(this._questInfo.RewardGold > 0)
         {
            this.addReward("gold",this._questInfo.RewardGold,index);
            index++;
         }
         if(this._questInfo.RewardMoney > 0)
         {
            this.addReward("coin",this._questInfo.RewardMoney,index);
            index++;
         }
         if(this._questInfo.RewardOffer > 0)
         {
            this.addReward("honor",this._questInfo.RewardOffer,index);
            index++;
         }
         if(this._questInfo.RewardRiches > 0)
         {
            this.addReward("rich",this._questInfo.RewardRiches,index);
            index++;
         }
         if(this._questInfo.RewardBindMoney > 0)
         {
            this.addReward("bindMoney",this._questInfo.RewardBindMoney,index);
            index++;
         }
         if(this._questInfo.Rank != "")
         {
            this.addReward("rank",0,index,true,this._questInfo.Rank);
            index++;
         }
         this._textField.x = (this._contian.width - this._textField.width) / 2;
         this._bg.height = this._contian.height + 12;
         height = 150 + this._contian.height;
      }
      
      private function getSexByInt(Sex:Boolean) : int
      {
         return Sex ? 1 : 2;
      }
      
      private function addReward(reward:String, count:int, index:int, isRank:Boolean = false, rank:String = "") : void
      {
         var rewardMC:FilterFrameText = null;
         var quantityTxt:FilterFrameText = null;
         rewardMC = ComponentFactory.Instance.creat("core.quest.MCQuestRewardImprove");
         if(index > 2)
         {
            rewardMC.y += 20;
            if(this._first)
            {
               this._list.y += 20;
               this._first = false;
            }
         }
         quantityTxt = ComponentFactory.Instance.creat("core.quest.QuestItemRewardQuantity");
         switch(reward)
         {
            case "exp":
               rewardMC.text = LanguageMgr.GetTranslation("exp");
               break;
            case "gold":
               rewardMC.text = LanguageMgr.GetTranslation("gold");
               break;
            case "coin":
               rewardMC.text = LanguageMgr.GetTranslation("money");
               break;
            case "rich":
               rewardMC.text = LanguageMgr.GetTranslation("consortia.Money");
               break;
            case "honor":
               rewardMC.text = StringUtils.trim(LanguageMgr.GetTranslation("gongxun"));
               break;
            case "bindMoney":
               rewardMC.text = LanguageMgr.GetTranslation("ddtMoney");
               break;
            case "rank":
               rewardMC.text = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameII");
         }
         rewardMC.x = index % 3 * 90 + 18;
         quantityTxt.x = rewardMC.x + rewardMC.textWidth + 5;
         quantityTxt.y = rewardMC.y;
         if(isRank)
         {
            quantityTxt.text = rank;
         }
         else
         {
            quantityTxt.text = String(count);
         }
         this._contian.addChild(rewardMC);
         this._contian.addChild(quantityTxt);
      }
      
      private function __confirmResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(BuriedManager.Instance.checkMoney(false,this._spand))
               {
                  return;
               }
               SocketManager.Instance.out.sendImproveQuest(this._questInfo.id,false);
               break;
         }
         removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         this.dispose();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         ObjectUtils.disposeObject(this._textField);
         this._textField = null;
         if(Boolean(this._contian))
         {
            ObjectUtils.disposeObject(this._contian);
         }
         this._contian = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         super.dispose();
      }
   }
}

