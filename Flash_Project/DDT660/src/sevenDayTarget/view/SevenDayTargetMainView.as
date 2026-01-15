package sevenDayTarget.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import sevenDayTarget.controller.SevenDayTargetManager;
   import sevenDayTarget.model.NewTargetQuestionInfo;
   
   public class SevenDayTargetMainView extends Frame
   {
      
      private var _topBg:Bitmap;
      
      private var _downBg:Bitmap;
      
      private var grayFilter:ColorMatrixFilter;
      
      private var lightFilter:ColorMatrixFilter;
      
      private var dayArray:Array;
      
      private var _rewardList:SimpleTileList;
      
      private var _rewardArray:Array;
      
      private var _finishBnt:BaseButton;
      
      private var _todayQuestInfo:NewTargetQuestionInfo;
      
      private var conditionSp1:SevenDayTargetConditionCell;
      
      private var conditionSp2:SevenDayTargetConditionCell;
      
      private var conditionSp3:SevenDayTargetConditionCell;
      
      private var _helpBnt:BaseButton;
      
      private var _downBack:ScaleBitmapImage;
      
      public function SevenDayTargetMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get todayQuestInfo() : NewTargetQuestionInfo
      {
         return this._todayQuestInfo;
      }
      
      private function initView() : void
      {
         this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[SevenDayTargetManager.Instance.today - 1];
         this._downBack = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.scale9cornerImageTree");
         addChild(this._downBack);
         this.createDayClicker();
         this.initDayView();
         this.initTargetView();
         this.initRewardView();
         this.changeDaysText();
         this.addHelpBnt();
      }
      
      private function addHelpBnt() : void
      {
         this._helpBnt = ComponentFactory.Instance.creatComponentByStylename("sevenDayTarget.helpBnt");
         addToContent(this._helpBnt);
         this._helpBnt.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
      }
      
      protected function __onHelpClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpView:SevenDayTargetHelpFrame = ComponentFactory.Instance.creat("sevenDayTarget.helpView");
         LayerManager.Instance.addToLayer(helpView,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initDayView() : void
      {
         var todayMC:MovieClip = null;
         var dayBg:SevenDayTargetDayButton = null;
         this.grayFilter = ComponentFactory.Instance.model.getSet("grayFilter");
         this.lightFilter = ComponentFactory.Instance.model.getSet("lightFilter");
         this.dayArray = new Array();
         titleText = LanguageMgr.GetTranslation("ddt.sevenDayTarget.title");
         this._topBg = ComponentFactory.Instance.creat("sevenDayTarget.topBg");
         addToContent(this._topBg);
         this._downBg = ComponentFactory.Instance.creat("sevenDayTarget.downBg");
         addToContent(this._downBg);
         todayMC = ComponentFactory.Instance.creat("sevenDayTarget.todayMC");
         todayMC.mouseEnabled = false;
         todayMC.mouseChildren = false;
         var today:int = SevenDayTargetManager.Instance.today;
         for(var i:int = 1; i <= 7; i++)
         {
            dayBg = ComponentFactory.Instance.creatComponentByStylename("sevenDayTarget.view.dayButton" + i);
            dayBg.name = "day" + i;
            addToContent(dayBg);
            if(i == today)
            {
               PositionUtils.setPos(todayMC,"sevenDayTarget.todayMCPos" + i);
            }
            this.dayArray.push(dayBg);
            dayBg.addEventListener(MouseEvent.CLICK,this.__dayClick);
         }
         addToContent(todayMC);
      }
      
      private function initTargetView() : void
      {
         if(Boolean(this.conditionSp1))
         {
            this.conditionSp1.dispose();
            this.conditionSp1 = null;
         }
         if(Boolean(this.conditionSp2))
         {
            this.conditionSp2.dispose();
            this.conditionSp2 = null;
         }
         if(Boolean(this.conditionSp3))
         {
            this.conditionSp3.dispose();
            this.conditionSp3 = null;
         }
         var today:int = SevenDayTargetManager.Instance.today;
         var canClickLink:Boolean = today >= this._todayQuestInfo.Period ? true : false;
         this.conditionSp1 = new SevenDayTargetConditionCell(this._todayQuestInfo);
         this.conditionSp1.setView(this._todayQuestInfo.condition1Title,this._todayQuestInfo.condition1Complete,canClickLink);
         PositionUtils.setPos(this.conditionSp1,"sevenDayTarget.view.conditionPos1");
         addToContent(this.conditionSp1);
         this.conditionSp2 = new SevenDayTargetConditionCell(this._todayQuestInfo);
         this.conditionSp2.setView(this._todayQuestInfo.condition2Title,this._todayQuestInfo.condition2Complete,canClickLink);
         PositionUtils.setPos(this.conditionSp2,"sevenDayTarget.view.conditionPos2");
         addToContent(this.conditionSp2);
         this.conditionSp3 = new SevenDayTargetConditionCell(this._todayQuestInfo);
         this.conditionSp3.setView(this._todayQuestInfo.condition3Title,this._todayQuestInfo.condition3Complete,canClickLink);
         PositionUtils.setPos(this.conditionSp3,"sevenDayTarget.view.conditionPos3");
         addToContent(this.conditionSp3);
      }
      
      private function initRewardView() : void
      {
         var cell:SevenDayTargetRewardCell = null;
         var temp:InventoryItemInfo = null;
         var info:ItemTemplateInfo = null;
         if(Boolean(this._rewardList))
         {
            this._rewardList.dispose();
            this._rewardList = null;
         }
         if(Boolean(this._finishBnt))
         {
            this._finishBnt.dispose();
            this._finishBnt = null;
         }
         this._rewardList = ComponentFactory.Instance.creat("sevenDayTarget.simpleTileList.rewardList",[2]);
         addToContent(this._rewardList);
         this._rewardArray = this._todayQuestInfo.rewardList;
         for(var i:int = 0; i < this._rewardArray.length; i++)
         {
            cell = new SevenDayTargetRewardCell();
            temp = this._rewardArray[i] as InventoryItemInfo;
            info = ItemManager.Instance.getTemplateById(temp.ItemID);
            cell.info = info;
            cell.itemName = info.Name;
            cell.itemNum = temp.Count + "";
            this._rewardList.addChild(cell);
         }
         this._finishBnt = ComponentFactory.Instance.creat("sevenDayTarget.view.getAwardBtn");
         addToContent(this._finishBnt);
         this._finishBnt.addEventListener(MouseEvent.CLICK,this.__getReward);
         if(this._todayQuestInfo.iscomplete && this._todayQuestInfo.getedReward)
         {
            this._finishBnt.enable = false;
         }
         if(this._todayQuestInfo.iscomplete && !this._todayQuestInfo.getedReward)
         {
            this._finishBnt.enable = true;
         }
         if(!this._todayQuestInfo.iscomplete)
         {
            this._finishBnt.enable = false;
         }
      }
      
      private function __getReward(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._finishBnt.enable = false;
         var questionId:int = this._todayQuestInfo.questId;
         SocketManager.Instance.out.sevenDayTarget_getReward(questionId);
      }
      
      private function createDayClicker() : void
      {
         var sp:Sprite = null;
         for(var i:int = 1; i < 8; i++)
         {
            sp = new Sprite();
            sp.buttonMode = true;
            sp.graphics.beginFill(255);
            sp.graphics.drawRect(0,0,90,200);
            sp.graphics.endFill();
            addToContent(sp);
            sp.name = "day" + i;
            PositionUtils.setPos(sp,"sevenDayTarget.dayClicker" + i);
            sp.addEventListener(MouseEvent.CLICK,this.__dayClick);
            sp.alpha = 1;
         }
      }
      
      private function __dayClick(e:MouseEvent) : void
      {
         var sp:Sprite = e.currentTarget as Sprite;
         if(sp.name == "day1")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[0];
         }
         else if(sp.name == "day2")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[1];
         }
         else if(sp.name == "day3")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[2];
         }
         else if(sp.name == "day4")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[3];
         }
         else if(sp.name == "day5")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[4];
         }
         else if(sp.name == "day6")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[5];
         }
         else if(sp.name == "day7")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[6];
         }
         this.updateTargetView();
         this.updateRewardView();
      }
      
      public function updateTargetView() : void
      {
         this.initTargetView();
      }
      
      public function updateRewardView() : void
      {
         this.initRewardView();
      }
      
      private function changeDaysText() : void
      {
         var dayBitmap:SevenDayTargetDayButton = null;
         var today:int = SevenDayTargetManager.Instance.today;
         for(var i:int = 0; i < today; i++)
         {
            dayBitmap = this.dayArray[i];
            dayBitmap.enable = true;
         }
         for(var j:int = today; j < this.dayArray.length; j++)
         {
            dayBitmap = this.dayArray[j];
            dayBitmap.enable = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._finishBnt.removeEventListener(MouseEvent.CLICK,this.__getReward);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SevenDayTargetManager.Instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._topBg))
         {
            this._topBg.bitmapData.dispose();
            this._topBg = null;
         }
         if(Boolean(this._downBack))
         {
            this._downBack.dispose();
            this._downBack = null;
         }
         if(Boolean(this.conditionSp1))
         {
            this.conditionSp1.dispose();
            this.conditionSp1 = null;
         }
         if(Boolean(this.conditionSp2))
         {
            this.conditionSp2.dispose();
            this.conditionSp2 = null;
         }
         if(Boolean(this.conditionSp3))
         {
            this.conditionSp3.dispose();
            this.conditionSp3 = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
   }
}

