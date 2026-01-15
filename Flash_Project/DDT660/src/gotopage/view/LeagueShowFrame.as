package gotopage.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.DailyLeagueManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.DailyLeagueLevel;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class LeagueShowFrame extends Frame
   {
      
      private var _leftBack:MutipleImage;
      
      private var _leagueRank:DailyLeagueLevel;
      
      private var _leagueTitle:FilterFrameText;
      
      private var _todayNumberTitle:Bitmap;
      
      private var _todayNumberBg:Scale9CornerImage;
      
      private var _todayNumberField:FilterFrameText;
      
      private var _todayScoreTitle:Bitmap;
      
      private var _todayScoreBg:Scale9CornerImage;
      
      private var _todayScoreField:FilterFrameText;
      
      private var _weekRankingTitle:Bitmap;
      
      private var _weekRankingBg:Scale9CornerImage;
      
      private var _weekRankingField:FilterFrameText;
      
      private var _weekScoreTitle:Bitmap;
      
      private var _weekScoreBg:Scale9CornerImage;
      
      private var _weekScoreField:FilterFrameText;
      
      private var _lv20_29Btn:SelectedButton;
      
      private var _lv30_39Btn:SelectedButton;
      
      private var _lv40_49Btn:SelectedButton;
      
      private var _levelSelGroup:SelectedButtonGroup;
      
      private var _awardScoreBg:Scale9CornerImage;
      
      private var _scoreBtnI:SelectedTextButton;
      
      private var _scoreBtnII:SelectedTextButton;
      
      private var _scoreBtnIII:SelectedTextButton;
      
      private var _scoreBtnIV:SelectedTextButton;
      
      private var _scoreSelGroup:SelectedButtonGroup;
      
      private var _awardBox:SimpleTileList;
      
      private var _explanationPanel:ScrollPanel;
      
      private var _rightBack:MutipleImage;
      
      private var _explanationBg:ScaleBitmapImage;
      
      public function LeagueShowFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("gotopage.view.LeagueShowFrame.title");
         this._leftBack = ComponentFactory.Instance.creatComponentByStylename("leagueShow.leftBack");
         addToContent(this._leftBack);
         var score:Number = PlayerManager.Instance.Self.DailyLeagueLastScore;
         var leagueFirst:Boolean = PlayerManager.Instance.Self.DailyLeagueFirst;
         this._leagueRank = new DailyLeagueLevel();
         this._leagueRank.leagueFirst = leagueFirst;
         this._leagueRank.score = score;
         PositionUtils.setPos(this._leagueRank,"leagueShow.view.leagueRankPos");
         addToContent(this._leagueRank);
         this._leagueTitle = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.leagueTitle");
         this._leagueTitle.text = DailyLeagueManager.Instance.getLeagueLevelByScore(score,leagueFirst).Name;
         addToContent(this._leagueTitle);
         this._todayNumberTitle = ComponentFactory.Instance.creatBitmap("asset.leagueShow.todayNumberTxt");
         addToContent(this._todayNumberTitle);
         this._todayNumberBg = ComponentFactory.Instance.creatComponentByStylename("asset.leagueShow.TextFieldBg");
         addToContent(this._todayNumberBg);
         this._todayNumberBg.y = this._todayNumberTitle.y + 1;
         this._todayNumberField = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.todayNumberField");
         addToContent(this._todayNumberField);
         this._todayScoreTitle = ComponentFactory.Instance.creatBitmap("asset.leagueShow.todayScoreTxt");
         addToContent(this._todayScoreTitle);
         this._todayScoreBg = ComponentFactory.Instance.creatComponentByStylename("asset.leagueShow.TextFieldBg");
         addToContent(this._todayScoreBg);
         this._todayScoreBg.y = this._todayScoreTitle.y + 1;
         this._todayScoreField = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.todayScoreField");
         addToContent(this._todayScoreField);
         this._weekRankingTitle = ComponentFactory.Instance.creatBitmap("asset.leagueShow.weekRankingTxt");
         addToContent(this._weekRankingTitle);
         this._weekRankingBg = ComponentFactory.Instance.creatComponentByStylename("asset.leagueShow.TextFieldBg");
         addToContent(this._weekRankingBg);
         this._weekRankingBg.y = this._weekRankingTitle.y + 1;
         this._weekRankingField = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.weekRankingField");
         addToContent(this._weekRankingField);
         this._weekScoreTitle = ComponentFactory.Instance.creatBitmap("asset.leagueShow.weekScoreTxt");
         addToContent(this._weekScoreTitle);
         this._weekScoreBg = ComponentFactory.Instance.creatComponentByStylename("asset.leagueShow.TextFieldBg");
         addToContent(this._weekScoreBg);
         this._weekScoreBg.y = this._weekScoreTitle.y + 1;
         this._weekScoreField = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.weekScoreField");
         addToContent(this._weekScoreField);
         this._weekRankingField.text = String(PlayerManager.Instance.Self.matchInfo.weeklyRanking);
         this._weekScoreField.text = String(PlayerManager.Instance.Self.matchInfo.weeklyScore);
         this._todayNumberField.text = String(PlayerManager.Instance.Self.matchInfo.dailyGameCount);
         this._todayScoreField.text = String(PlayerManager.Instance.Self.matchInfo.dailyScore);
         this._rightBack = ComponentFactory.Instance.creatComponentByStylename("leagueShow.rightBack");
         addToContent(this._rightBack);
         this._explanationBg = ComponentFactory.Instance.creatComponentByStylename("leagueShow.explanationContentBg");
         addToContent(this._explanationBg);
         this._explanationPanel = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.explanationPanel");
         this._explanationPanel.setView(ClassUtils.CreatInstance("asset.leagueShow.explanationContentAsset") as MovieClip);
         addToContent(this._explanationPanel);
         this._lv20_29Btn = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.lv20_29selectBtn");
         addToContent(this._lv20_29Btn);
         this._lv20_29Btn.autoSelect = true;
         this._lv30_39Btn = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.lv30_39selectBtn");
         addToContent(this._lv30_39Btn);
         this._lv40_49Btn = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.lv40_49selectBtn");
         addToContent(this._lv40_49Btn);
         this._levelSelGroup = new SelectedButtonGroup();
         this._levelSelGroup.addSelectItem(this._lv20_29Btn);
         this._levelSelGroup.addSelectItem(this._lv30_39Btn);
         this._levelSelGroup.addSelectItem(this._lv40_49Btn);
         this._levelSelGroup.selectIndex = 0;
         this._scoreBtnI = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.awardScoreBtnI");
         this._scoreBtnII = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.awardScoreBtnII");
         this._scoreBtnIII = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.awardScoreBtnIII");
         this._scoreBtnIV = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.awardScoreBtnIV");
         addToContent(this._scoreBtnI);
         addToContent(this._scoreBtnII);
         addToContent(this._scoreBtnIII);
         addToContent(this._scoreBtnIV);
         this._scoreBtnI.text = LanguageMgr.GetTranslation("gotopage.view.LeagueShowFrame.scoreBtnText","10000");
         this._scoreBtnII.text = LanguageMgr.GetTranslation("gotopage.view.LeagueShowFrame.scoreBtnText","20000");
         this._scoreBtnIII.text = LanguageMgr.GetTranslation("gotopage.view.LeagueShowFrame.scoreBtnText","35000");
         this._scoreBtnIV.text = LanguageMgr.GetTranslation("gotopage.view.LeagueShowFrame.scoreBtnText","60000");
         this._scoreSelGroup = new SelectedButtonGroup();
         this._scoreSelGroup.addSelectItem(this._scoreBtnI);
         this._scoreSelGroup.addSelectItem(this._scoreBtnII);
         this._scoreSelGroup.addSelectItem(this._scoreBtnIII);
         this._scoreSelGroup.addSelectItem(this._scoreBtnIV);
         this._scoreSelGroup.selectIndex = 0;
         this._awardScoreBg = ComponentFactory.Instance.creatComponentByStylename("asset.leagueShow.awardScoreBg");
         addToContent(this._awardScoreBg);
         this._awardBox = ComponentFactory.Instance.creatCustomObject("leagueShow.view.awardBox",[7]);
         addToContent(this._awardBox);
         this.__onItemChanaged(null);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._levelSelGroup.addEventListener(Event.CHANGE,this.__onItemChanaged);
         this._scoreSelGroup.addEventListener(Event.CHANGE,this.__onItemChanaged);
      }
      
      private function __onResponse(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.dispose();
      }
      
      private function __onItemChanaged(event:Event) : void
      {
         if(Boolean(event))
         {
            SoundManager.instance.playButtonSound();
         }
         this._awardBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._awardBox);
         var list:Array = DailyLeagueManager.Instance.filterLeagueAwardList(this._levelSelGroup.selectIndex,this._scoreSelGroup.selectIndex);
         var count:int = Math.min(list.length,14);
         for(var i:int = 0; i < count; i++)
         {
            this._awardBox.addChild(new LeagueAwardCell(list[i]));
         }
         for(var j:int = count; j < 14; j++)
         {
            this._awardBox.addChild(new BaseCell(ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.awardcellBg")));
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._levelSelGroup.removeEventListener(Event.CHANGE,this.__onItemChanaged);
         this._scoreSelGroup.removeEventListener(Event.CHANGE,this.__onItemChanaged);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(Boolean(this._leftBack))
         {
            ObjectUtils.disposeObject(this._leftBack);
         }
         this._leftBack = null;
         if(Boolean(this._leagueRank))
         {
            ObjectUtils.disposeObject(this._leagueRank);
         }
         this._leagueRank = null;
         if(Boolean(this._leagueTitle))
         {
            ObjectUtils.disposeObject(this._leagueTitle);
         }
         this._leagueTitle = null;
         if(Boolean(this._todayNumberTitle))
         {
            ObjectUtils.disposeObject(this._todayNumberTitle);
         }
         this._todayNumberTitle = null;
         if(Boolean(this._todayNumberBg))
         {
            ObjectUtils.disposeObject(this._todayNumberBg);
         }
         this._todayNumberBg = null;
         if(Boolean(this._todayNumberField))
         {
            ObjectUtils.disposeObject(this._todayNumberField);
         }
         this._todayNumberField = null;
         if(Boolean(this._todayScoreTitle))
         {
            ObjectUtils.disposeObject(this._todayScoreTitle);
         }
         this._todayScoreTitle = null;
         if(Boolean(this._todayScoreBg))
         {
            ObjectUtils.disposeObject(this._todayScoreBg);
         }
         this._todayScoreBg = null;
         if(Boolean(this._todayScoreField))
         {
            ObjectUtils.disposeObject(this._todayScoreField);
         }
         this._todayScoreField = null;
         if(Boolean(this._weekRankingTitle))
         {
            ObjectUtils.disposeObject(this._weekRankingTitle);
         }
         this._weekRankingTitle = null;
         if(Boolean(this._weekRankingBg))
         {
            ObjectUtils.disposeObject(this._weekRankingBg);
         }
         this._weekRankingBg = null;
         if(Boolean(this._weekRankingField))
         {
            ObjectUtils.disposeObject(this._weekRankingField);
         }
         this._weekRankingField = null;
         if(Boolean(this._weekScoreTitle))
         {
            ObjectUtils.disposeObject(this._weekScoreTitle);
         }
         this._weekScoreTitle = null;
         if(Boolean(this._weekScoreBg))
         {
            ObjectUtils.disposeObject(this._weekScoreBg);
         }
         this._weekScoreBg = null;
         if(Boolean(this._weekScoreField))
         {
            ObjectUtils.disposeObject(this._weekScoreField);
         }
         this._weekScoreField = null;
         if(Boolean(this._lv20_29Btn))
         {
            ObjectUtils.disposeObject(this._lv20_29Btn);
         }
         this._lv20_29Btn = null;
         if(Boolean(this._lv30_39Btn))
         {
            ObjectUtils.disposeObject(this._lv30_39Btn);
         }
         this._lv30_39Btn = null;
         if(Boolean(this._lv40_49Btn))
         {
            ObjectUtils.disposeObject(this._lv40_49Btn);
         }
         this._lv40_49Btn = null;
         if(Boolean(this._levelSelGroup))
         {
            ObjectUtils.disposeObject(this._levelSelGroup);
         }
         this._levelSelGroup = null;
         if(Boolean(this._scoreBtnI))
         {
            ObjectUtils.disposeObject(this._scoreBtnI);
         }
         this._scoreBtnI = null;
         if(Boolean(this._scoreBtnII))
         {
            ObjectUtils.disposeObject(this._scoreBtnII);
         }
         this._scoreBtnII = null;
         if(Boolean(this._scoreBtnIII))
         {
            ObjectUtils.disposeObject(this._scoreBtnIII);
         }
         this._scoreBtnIII = null;
         if(Boolean(this._scoreBtnIV))
         {
            ObjectUtils.disposeObject(this._scoreBtnIV);
         }
         this._scoreBtnIV = null;
         if(Boolean(this._scoreSelGroup))
         {
            ObjectUtils.disposeObject(this._scoreSelGroup);
         }
         this._scoreSelGroup = null;
         if(Boolean(this._awardBox))
         {
            ObjectUtils.disposeObject(this._awardBox);
         }
         this._awardBox = null;
         if(Boolean(this._explanationPanel))
         {
            ObjectUtils.disposeObject(this._explanationPanel);
         }
         this._explanationPanel = null;
         if(Boolean(this._rightBack))
         {
            ObjectUtils.disposeObject(this._rightBack);
         }
         this._rightBack = null;
         if(Boolean(this._explanationBg))
         {
            ObjectUtils.disposeObject(this._explanationBg);
         }
         this._explanationBg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

import bagAndInfo.cell.BaseCell;
import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.text.FilterFrameText;
import com.pickgliss.utils.ObjectUtils;
import ddt.data.DailyLeagueAwardInfo;
import ddt.manager.ItemManager;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;

class LeagueAwardCell extends BaseCell
{
   
   private var _awardInfo:DailyLeagueAwardInfo;
   
   private var _countTxt:FilterFrameText;
   
   public function LeagueAwardCell(awardInfo:DailyLeagueAwardInfo)
   {
      this._awardInfo = awardInfo;
      super(ComponentFactory.Instance.creatBitmap("asset.leagueAward.cellBackAsset"),ItemManager.Instance.getTemplateById(this._awardInfo.TemplateID));
      this.initII();
   }
   
   protected function initII() : void
   {
      this._countTxt = ComponentFactory.Instance.creat("bossbox.boxCellCount");
      this._countTxt.text = String(this._awardInfo.Count);
      addChild(this._countTxt);
   }
   
   override public function dispose() : void
   {
      super.dispose();
      if(Boolean(this._countTxt))
      {
         ObjectUtils.disposeObject(this._countTxt);
      }
      this._countTxt = null;
      ObjectUtils.disposeAllChildren(this);
      if(Boolean(parent))
      {
         parent.removeChild(this);
      }
   }
}
