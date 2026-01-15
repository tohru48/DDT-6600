package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestCondition;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class QuestInfoPanelView extends Sprite
   {
      
      private const CONDITION_HEIGHT:int = 32;
      
      private const CONDITION_Y:int = 0;
      
      private const PADDING_Y:int = 8;
      
      private var _info:QuestInfo;
      
      private var gotoCMoive:TextButton;
      
      private var container:VBox;
      
      private var panel:ScrollPanel;
      
      private var _extraFrame:Sprite;
      
      private var _items:Vector.<QuestInfoItemView>;
      
      private var _starLevel:int;
      
      private var _complete:Boolean;
      
      private var _isImprove:Boolean;
      
      private var _lastId:int;
      
      private var _regressFlag:Boolean = false;
      
      public function QuestInfoPanelView()
      {
         super();
         this._items = new Vector.<QuestInfoItemView>();
         this._isImprove = false;
         this.initView();
      }
      
      private function initView() : void
      {
         this.container = ComponentFactory.Instance.creatComponentByStylename("quest.questinfoPanelView.vbox");
         this.panel = ComponentFactory.Instance.creatComponentByStylename("core.quest.QuestInfoPanel");
         this.panel.setView(this.container);
         addChild(this.panel);
      }
      
      public function clearItems() : void
      {
         var item:QuestInfoItemView = null;
         for each(item in this._items)
         {
            item.dispose();
         }
      }
      
      public function set info(value:QuestInfo) : void
      {
         var temp:QuestItemReward = null;
         var item:QuestInfoItemView = null;
         var cond:QuestCondition = null;
         var tinfo:InventoryItemInfo = null;
         var necessaryTarget:QuestinfoTargetItemView = null;
         var notNecessaryTarget:QuestinfoTargetItemView = null;
         var necessaryAward:QuestinfoAwardItemView = null;
         var optionalAward:QuestinfoAwardItemView = null;
         TaskManager.itemAwardSelected = 0;
         this._isImprove = false;
         this._info = value;
         if(this._starLevel != this._info.QuestLevel)
         {
            this._starLevel = this._info.QuestLevel;
            if(this._lastId == this._info.QuestID)
            {
               this._isImprove = true;
            }
         }
         this._lastId = this._info.QuestID;
         this._complete = this._info.isCompleted;
         this.clearItems();
         this._items = new Vector.<QuestInfoItemView>();
         var hasNeccesaryTarget:Boolean = false;
         var hasNotNeccessaryTarget:Boolean = false;
         var hasNecessaryAward:Boolean = false;
         var hasOptionalAward:Boolean = false;
         for(var i:int = 0; Boolean(this._info._conditions[i]); i++)
         {
            cond = this._info._conditions[i];
            if(!cond.isOpitional)
            {
               hasNeccesaryTarget = true;
            }
            else
            {
               hasNotNeccessaryTarget = true;
            }
         }
         if(!hasNecessaryAward)
         {
            hasNecessaryAward = this.info.hasOtherAward();
         }
         for each(temp in this._info.itemRewards)
         {
            tinfo = new InventoryItemInfo();
            tinfo.TemplateID = temp.itemID;
            ItemManager.fill(tinfo);
            if(!(0 != tinfo.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != tinfo.NeedSex))
            {
               if(temp.isOptional == 0)
               {
                  hasNecessaryAward = true;
               }
               else if(temp.isOptional == 1)
               {
                  hasOptionalAward = true;
               }
            }
         }
         if(hasNeccesaryTarget)
         {
            necessaryTarget = new QuestinfoTargetItemView(false);
            necessaryTarget.isImprove = this._isImprove;
            if(this.regressFlag)
            {
               necessaryTarget.setStarVipHide();
            }
            this._items.push(necessaryTarget);
         }
         if(hasNotNeccessaryTarget)
         {
            notNecessaryTarget = new QuestinfoTargetItemView(true);
            if(this.regressFlag)
            {
               notNecessaryTarget.setStarVipHide();
            }
            this._items.push(notNecessaryTarget);
         }
         if(hasNecessaryAward)
         {
            necessaryAward = new QuestinfoAwardItemView(false);
            necessaryAward.isReward = true;
            this._items.push(necessaryAward);
         }
         if(hasOptionalAward)
         {
            optionalAward = new QuestinfoAwardItemView(true);
            TaskManager.itemAwardSelected = -1;
            this._items.push(optionalAward);
         }
         var descriptionItem:QuestinfoDescriptionItemView = new QuestinfoDescriptionItemView();
         this._items.push(descriptionItem);
         for each(item in this._items)
         {
            item.info = this._info;
            this.container.addChild(item);
         }
         if(this.info.QuestID == TaskManager.GUIDE_QUEST_ID)
         {
            this.canGotoConsortia(true);
         }
         else
         {
            this.canGotoConsortia(false);
         }
         this.panel.invalidateViewport();
         visible = true;
      }
      
      private function __onGoToConsortia(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.gotoCMoive.removeEventListener(MouseEvent.CLICK,this.__onGoToConsortia);
         StateManager.setState(StateType.CONSORTIA);
      }
      
      private function getSexByInt(Sex:Boolean) : int
      {
         return Sex ? 1 : 2;
      }
      
      public function canGotoConsortia(value:Boolean) : void
      {
         if(value)
         {
            if(this.gotoCMoive == null)
            {
               this.gotoCMoive = ComponentFactory.Instance.creatComponentByStylename("core.quest.GoToConsortiaBtn");
               this.gotoCMoive.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.GoToConsortia");
               this.gotoCMoive.addEventListener(MouseEvent.CLICK,this.__onGoToConsortia);
               addChild(this.gotoCMoive);
            }
         }
         else if(Boolean(this.gotoCMoive))
         {
            this.gotoCMoive.removeEventListener(MouseEvent.CLICK,this.__onGoToConsortia);
            removeChild(this.gotoCMoive);
            this.gotoCMoive = null;
         }
      }
      
      public function get info() : QuestInfo
      {
         return this._info;
      }
      
      public function dispose() : void
      {
         this._info = null;
         if(Boolean(this.gotoCMoive))
         {
            this.gotoCMoive.dispose();
            this.gotoCMoive = null;
         }
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(Boolean(this._items[i]))
            {
               this._items[i].dispose();
               this._items[i] = null;
            }
         }
         this._items.length = 0;
         if(Boolean(this.container))
         {
            this.container.dispose();
            this.container = null;
         }
         if(Boolean(this.panel))
         {
            this.panel.dispose();
            this.panel = null;
         }
      }
      
      public function get regressFlag() : Boolean
      {
         return this._regressFlag;
      }
      
      public function set regressFlag(value:Boolean) : void
      {
         this._regressFlag = value;
      }
   }
}

