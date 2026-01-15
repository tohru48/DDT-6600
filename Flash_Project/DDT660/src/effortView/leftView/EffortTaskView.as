package effortView.leftView
{
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.events.TaskEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import quest.QuestRewardCell;
   
   public class EffortTaskView extends Sprite implements Disposeable
   {
      
      private var _rewardBtn:SimpleBitmapButton;
      
      private var _targetBg:Bitmap;
      
      private var _titleText:FilterFrameText;
      
      private var _valueText:FilterFrameText;
      
      private var _targetText:FilterFrameText;
      
      private var _RewardText:FilterFrameText;
      
      private var _cell:QuestRewardCell;
      
      private var _questInfo:QuestInfo;
      
      private var _itemTemplateinfo:ItemTemplateInfo;
      
      private var _light:IEffect;
      
      public function EffortTaskView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._rewardBtn = ComponentFactory.Instance.creat("effortView.EffortTaskView.EffortTaskViewRewardBtn");
         addChild(this._rewardBtn);
         this._targetBg = ComponentFactory.Instance.creatBitmap("asset.effort.target.bg");
         addChild(this._targetBg);
         this._titleText = ComponentFactory.Instance.creat("effortView.EffortTaskView.EffortTaskText_01");
         addChild(this._titleText);
         this._valueText = ComponentFactory.Instance.creat("effortView.EffortTaskView.EffortTaskText_02");
         addChild(this._valueText);
         this._targetText = ComponentFactory.Instance.creat("effortView.EffortTaskView.EffortTaskText_03");
         this._targetText.text = LanguageMgr.GetTranslation("tank.view.effort.EffortTaskView.target");
         addChild(this._targetText);
         this._RewardText = ComponentFactory.Instance.creat("effortView.EffortTaskView.EffortTaskText_04");
         this._RewardText.text = LanguageMgr.GetTranslation("tank.view.effort.EffortTaskView.reward");
         addChild(this._RewardText);
         var glowRec:Rectangle = ComponentFactory.Instance.creatCustomObject("ddteffort.btnGlowRec");
         this._light = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._rewardBtn,"asset.effort.light_mc",glowRec);
         this._light.play();
         this.initQuestInfo();
      }
      
      private function initQuestInfo() : void
      {
         var pos:Point = null;
         var info:InventoryItemInfo = null;
         this._questInfo = TaskManager.instance.achievementQuest;
         if(!this._questInfo)
         {
            return;
         }
         this._cell = new QuestRewardCell();
         this._cell.taskType = 1;
         this._cell.opitional = false;
         pos = ComponentFactory.Instance.creatCustomObject("effortView.EffortTaskView.CellPos");
         this._cell.x = pos.x;
         this._cell.y = pos.y;
         var tempItem:QuestItemReward = new QuestItemReward(11408,new Array(1,2,3,4,5),"","true");
         info = new InventoryItemInfo();
         info.ValidDate = tempItem.ValidateTime;
         info.TemplateID = 11408;
         info.IsJudge = true;
         info.IsBinds = tempItem.isBind;
         info.AttackCompose = tempItem.AttackCompose;
         info.DefendCompose = tempItem.DefendCompose;
         info.AgilityCompose = tempItem.AgilityCompose;
         info.LuckCompose = tempItem.LuckCompose;
         info.StrengthenLevel = tempItem.StrengthenLevel;
         if(EquipType.isMagicStone(info.CategoryID))
         {
            info.Level = info.StrengthenLevel;
            info.Attack = info.AttackCompose;
            info.Defence = info.DefendCompose;
            info.Agility = info.AgilityCompose;
            info.Luck = info.LuckCompose;
            info.MagicAttack = tempItem.MagicAttack;
            info.MagicDefence = tempItem.MagicDefence;
         }
         info.Count = tempItem.count[this._questInfo.QuestLevel - 1];
         if(tempItem.IsCount && this._questInfo.data && Boolean(this._questInfo.data.quality))
         {
            info.Count = tempItem.count[this._questInfo.QuestLevel - 1] * this._questInfo.data.quality;
         }
         ItemManager.fill(info);
         if(Boolean(info) && info.TemplateID != 0)
         {
            this._cell.visible = true;
            this._cell.info = info;
         }
         addChild(this._cell);
         this.updateText();
      }
      
      private function updateText() : void
      {
         if(!this._questInfo)
         {
            return;
         }
         this._titleText.text = this._questInfo.Detail;
         var currentValue:int = this._questInfo._conditions[0].param2 - this._questInfo.data.progress[0];
         currentValue = currentValue > this._questInfo._conditions[0].param2 ? currentValue : int(this._questInfo._conditions[0].param2);
         var value:int = this._questInfo._conditions[0].param2 - this._questInfo.data.progress[0];
         if(value < 0)
         {
            value = 0;
         }
         if(value > 5)
         {
            value = 5;
         }
         this._valueText.text = "(" + String(value) + "/" + String(this._questInfo._conditions[0].param2) + ")";
         this.btnEnable();
      }
      
      private function btnEnable() : void
      {
         if(!this._questInfo || !this._rewardBtn)
         {
            return;
         }
         if(this._questInfo.data.progress[0] <= 0)
         {
            this._rewardBtn.enable = true;
            this._light.play();
         }
         else
         {
            this._rewardBtn.enable = false;
            this._light.stop();
         }
      }
      
      private function initEvent() : void
      {
         this._rewardBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         TaskManager.instance.addEventListener(TaskEvent.CHANGED,this.__update);
      }
      
      private function __update(event:TaskEvent) : void
      {
         this.updateText();
         this.btnEnable();
      }
      
      private function __btnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._questInfo))
         {
            TaskManager.instance.requestAchievementReward();
            this.updateText();
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._rewardBtn))
         {
            this._rewardBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         TaskManager.instance.removeEventListener(TaskEvent.CHANGED,this.__update);
         if(Boolean(this._rewardBtn) && Boolean(this._rewardBtn.parent))
         {
            this._rewardBtn.parent.removeChild(this._rewardBtn);
            this._rewardBtn.dispose();
            this._rewardBtn = null;
         }
         if(Boolean(this._targetText) && Boolean(this._targetText.parent))
         {
            this._targetText.parent.removeChild(this._targetText);
            this._targetText.dispose();
            this._targetText = null;
         }
         if(Boolean(this._RewardText) && Boolean(this._RewardText.parent))
         {
            this._RewardText.parent.removeChild(this._RewardText);
            this._RewardText.dispose();
            this._RewardText = null;
         }
         if(Boolean(this._titleText) && Boolean(this._titleText.parent))
         {
            this._titleText.parent.removeChild(this._titleText);
            this._titleText.dispose();
            this._titleText = null;
         }
         if(Boolean(this._valueText) && Boolean(this._valueText.parent))
         {
            this._valueText.parent.removeChild(this._valueText);
            this._valueText.dispose();
            this._valueText = null;
         }
      }
   }
}

