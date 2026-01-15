package quest
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestImproveInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class QuestinfoAwardItemView extends QuestInfoItemView
   {
      
      private const ROW_HEIGHT:int = 24;
      
      private const ROW_X:int = 28;
      
      private const REWARDCELL_HEIGHT:int = 55;
      
      private var _isOptional:Boolean;
      
      private var _list:SimpleTileList;
      
      private var _items:Vector.<QuestRewardCell> = new Vector.<QuestRewardCell>();
      
      private var cardAsset:ScaleFrameImage;
      
      private var _improveBtn:BaseButton;
      
      private var _isReward:Boolean;
      
      private var _improveFrame:QuestImproveFrame;
      
      private var _first:Boolean = true;
      
      public function QuestinfoAwardItemView(isOptional:Boolean)
      {
         this._isOptional = isOptional;
         super();
      }
      
      public function set isReward(value:Boolean) : void
      {
         this._isReward = value;
      }
      
      override public function set info(value:QuestInfo) : void
      {
         var temp:QuestItemReward = null;
         var tinfo:InventoryItemInfo = null;
         var item:QuestRewardCell = null;
         var buffTime:int = 0;
         var valueTxt:FilterFrameText = null;
         _info = value;
         for each(temp in _info.itemRewards)
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
            tinfo.Count = temp.count[_info.QuestLevel - 1];
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
            if(!(0 != tinfo.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != tinfo.NeedSex))
            {
               if(temp.isOptional == this._isOptional)
               {
                  item = new QuestRewardCell();
                  item.info = tinfo;
                  if(Boolean(temp.isOptional))
                  {
                     item.canBeSelected();
                     item.addEventListener(RewardSelectedEvent.ITEM_SELECTED,this.__chooseItemReward);
                  }
                  this._list.addChild(item);
                  this._items.push(item);
               }
            }
         }
         _panel.invalidateViewport();
         if(this._isOptional)
         {
            return;
         }
         if(!_info.hasOtherAward())
         {
            this._list.y = 5;
         }
         var index:int = 0;
         var realnfo:QuestInfo = this.newInfo(_info,_info.QuestLevel - 2,TaskManager.instance.improve);
         if(realnfo.RewardGP > 0)
         {
            this.addReward("exp",realnfo.RewardGP,index);
            index++;
         }
         if(realnfo.RewardGold > 0)
         {
            this.addReward("gold",realnfo.RewardGold,index);
            index++;
         }
         if(realnfo.RewardMoney > 0)
         {
            this.addReward("coin",realnfo.RewardMoney,index);
            index++;
         }
         if(realnfo.RewardOffer > 0)
         {
            this.addReward("honor",realnfo.RewardOffer,index);
            index++;
         }
         if(_info.RewardRiches > 0)
         {
            this.addReward("rich",_info.RewardRiches,index);
            index++;
         }
         if(_info.RewardBindMoney > 0)
         {
            this.addReward("bandMoney",_info.RewardBindMoney,index);
            index++;
         }
         if(_info.Rank != "")
         {
            this.addReward("rank",0,index,true,_info.Rank);
            index++;
         }
         if(_info.RewardBuffID != 0)
         {
            this.cardAsset = ComponentFactory.Instance.creat("core.quest.MCQuestRewardBuff");
            addChild(this.cardAsset);
            this.cardAsset.setFrame(_info.RewardBuffID - 11994);
            buffTime = _info.RewardBuffDate;
            valueTxt = ComponentFactory.Instance.creat("core.quest.QuestItemRewardQuantity");
            addChild(valueTxt);
            valueTxt.x = this.cardAsset.x + this.cardAsset.width + 2;
            valueTxt.y = this.cardAsset.y;
            valueTxt.text = String(buffTime) + LanguageMgr.GetTranslation("hours");
         }
         if(this._isReward && this.getNeedMoney(_info) != -1)
         {
            this._improveBtn = ComponentFactory.Instance.creatComponentByStylename("quest.improve");
            if(height > 75)
            {
               this._improveBtn.y = height / 2 - 40;
            }
            else
            {
               this._improveBtn.y = 20;
            }
            _content.addChild(this._improveBtn);
            if(_info.QuestLevel >= 5)
            {
               this._improveBtn.enable = false;
            }
            this._improveBtn.addEventListener(MouseEvent.CLICK,this._activeimproveBtnClick);
         }
      }
      
      private function getNeedMoney(pInfo:QuestInfo) : int
      {
         if(pInfo.QuestLevel == 1)
         {
            return pInfo.Level2NeedMoney;
         }
         if(pInfo.QuestLevel == 2)
         {
            return pInfo.Level3NeedMoney;
         }
         if(pInfo.QuestLevel == 3)
         {
            return pInfo.Level4NeedMoney;
         }
         if(pInfo.QuestLevel == 4)
         {
            return pInfo.Level5NeedMoney;
         }
         return -1;
      }
      
      private function newInfo(pInfo:QuestInfo, level:int, info:QuestImproveInfo) : QuestInfo
      {
         var vInfo:QuestInfo = null;
         if(level > -1)
         {
            vInfo = new QuestInfo();
            vInfo.RewardMoney = Number(info.bindMoneyRate[level]) * pInfo.RewardMoney;
            vInfo.RewardGP = Number(info.expRate[level]) * pInfo.RewardGP;
            vInfo.RewardGold = Number(info.goldRate[level]) * pInfo.RewardGold;
            vInfo.RewardOffer = Number(info.exploitRate[level]) * pInfo.RewardOffer;
            return vInfo;
         }
         return pInfo;
      }
      
      private function _activeimproveBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._improveFrame = ComponentFactory.Instance.creat("quest.improveFrame");
         this._improveFrame.isOptional = this._isOptional;
         this._improveFrame.spand = this.getNeedMoney(_info);
         this._improveFrame.questInfo = this.getImproveInfo(TaskManager.instance.improve,_info.QuestLevel - 1);
         LayerManager.Instance.addToLayer(this._improveFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function getImproveInfo(info:QuestImproveInfo, level:int) : QuestInfo
      {
         var reward:QuestItemReward = null;
         var questInfo:QuestInfo = new QuestInfo();
         ObjectUtils.copyProperties(questInfo,_info);
         questInfo.data = _info.data;
         questInfo.RewardMoney *= Number(info.bindMoneyRate[level]);
         questInfo.RewardGP *= Number(info.expRate[level]);
         questInfo.RewardGold *= Number(info.goldRate[level]);
         questInfo.RewardOffer *= Number(info.exploitRate[level]);
         for each(reward in _info.itemRewards)
         {
            questInfo.addReward(reward);
         }
         return questInfo;
      }
      
      private function __chooseItemReward(evt:RewardSelectedEvent) : void
      {
         var cell:QuestRewardCell = null;
         for each(cell in this._items)
         {
            cell.selected = false;
         }
         evt.itemCell.selected = true;
      }
      
      private function getSexByInt(Sex:Boolean) : int
      {
         return Sex ? 1 : 2;
      }
      
      private function addReward(reward:String, count:int, index:int, isRank:Boolean = false, rank:String = "") : void
      {
         var rewardMC:FilterFrameText = null;
         var quantityTxt:FilterFrameText = null;
         rewardMC = ComponentFactory.Instance.creat("core.quest.MCQuestRewardType");
         if(index > 3)
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
            case "bandMoney":
               rewardMC.text = LanguageMgr.GetTranslation("ddtMoney");
               break;
            case "gift":
               rewardMC.text = LanguageMgr.GetTranslation("newDdtMoney");
               break;
            case "medal":
               rewardMC.text = LanguageMgr.GetTranslation("gift");
               break;
            case "rank":
               rewardMC.text = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameII");
         }
         rewardMC.x = index % 4 * 118 + this.ROW_X;
         quantityTxt.x = rewardMC.x + rewardMC.textWidth + 20;
         quantityTxt.y = rewardMC.y;
         if(isRank)
         {
            quantityTxt.text = rank;
         }
         else
         {
            quantityTxt.text = String(count);
         }
         _content.addChildAt(rewardMC,0);
         _content.addChildAt(quantityTxt,0);
      }
      
      override protected function initView() : void
      {
         super.initView();
         _titleImg = ComponentFactory.Instance.creatComponentByStylename("core.quest.eligiblyWord");
         _titleImg.setFrame(this._isOptional ? 1 : 2);
         addChild(_titleImg);
         this._list = new SimpleTileList(3);
         if(!this._isOptional)
         {
            PositionUtils.setPos(this._list,"quest.awardPanel.listpos");
         }
         else
         {
            PositionUtils.setPos(this._list,"quest.awardPanel.listpos1");
         }
         _content.addChild(this._list);
      }
      
      override public function dispose() : void
      {
         var item:QuestRewardCell = null;
         for each(item in this._items)
         {
            item.removeEventListener(RewardSelectedEvent.ITEM_SELECTED,this.__chooseItemReward);
            item.dispose();
         }
         this._items = null;
         ObjectUtils.disposeObject(this._list);
         if(Boolean(this._improveBtn))
         {
            ObjectUtils.disposeObject(this._improveBtn);
         }
         this._improveBtn = null;
         this._list = null;
         super.dispose();
      }
   }
}

