package eliteGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.DDT;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import eliteGame.EliteGameController;
   import eliteGame.EliteGameEvent;
   import eliteGame.info.EliteGameAllScoreRankInfo;
   import eliteGame.info.EliteGameScroeRankInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EliteGameScoreRankView extends Sprite implements Disposeable
   {
      
      private static var type30_40:int = 0;
      
      private static var type41_50:int = 1;
      
      private var _between30_40:SelectedCheckButton;
      
      private var _between41_50:SelectedCheckButton;
      
      private var _betweenBtnGroup:SelectedButtonGroup;
      
      private var _bg1:ScaleBitmapImage;
      
      private var _lingBg:ScaleFrameImage;
      
      private var _rankText:FilterFrameText;
      
      private var _nameText:FilterFrameText;
      
      private var _scoreText:FilterFrameText;
      
      private var _myRank:FilterFrameText;
      
      private var _myScore:FilterFrameText;
      
      private var _titleline1:ScaleBitmapImage;
      
      private var _titleline2:ScaleBitmapImage;
      
      private var _rankScoreBg:ScaleBitmapImage;
      
      private var _myRankTextBg:Scale9CornerImage;
      
      private var _myScoreTextBg:Scale9CornerImage;
      
      private var _myRankText:FilterFrameText;
      
      private var _myScoreText:FilterFrameText;
      
      private var _nextPage:SimpleBitmapButton;
      
      private var _prePage:SimpleBitmapButton;
      
      private var _pageTextBG:Scale9CornerImage;
      
      private var _pageText:FilterFrameText;
      
      private var _updateTimeText:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _vboxBg:VBox;
      
      private var _items:Vector.<EliteGameScoreRankItem>;
      
      private var _allInfo:EliteGameAllScoreRankInfo;
      
      private var _list:Vector.<EliteGameScroeRankInfo>;
      
      private var _totalPage:int = 1;
      
      private var _currentPage:int;
      
      public function EliteGameScoreRankView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function set currentPage(value:int) : void
      {
         this._currentPage = value;
         this._pageText.text = this._currentPage.toString();
         if(this._currentPage == 1)
         {
            this._prePage.enable = false;
         }
         else
         {
            this._prePage.enable = true;
         }
         if(this._currentPage == this._totalPage)
         {
            this._nextPage.enable = false;
         }
         else
         {
            this._nextPage.enable = true;
         }
      }
      
      private function initView() : void
      {
         this._between30_40 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.between30_40Btn");
         this._between41_50 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.between41_50Btn");
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.bg1");
         this._rankText = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRank.rankText");
         this._rankText.text = LanguageMgr.GetTranslation("repute");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRank.nameText");
         this._nameText.text = LanguageMgr.GetTranslation("itemview.listname");
         this._scoreText = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRank.scoreText");
         this._scoreText.text = LanguageMgr.GetTranslation("tank.gameover.takecard.score");
         this._titleline1 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankview.formIineBig1");
         this._titleline2 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankview.formIineBig2");
         this._myRank = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRank.myRank");
         this._myRank.text = LanguageMgr.GetTranslation("eliteGame.myrank.text");
         this._myScore = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRank.scoretitle");
         this._myScore.text = LanguageMgr.GetTranslation("tank.gameover.takecard.score");
         this._rankScoreBg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.rankScoreBg");
         this._myRankTextBg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.myRankTextBG");
         this._myScoreTextBg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.myScoreTextBG");
         this._myRankText = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.rankAndScoreTxt");
         this._myScoreText = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.rankAndScoreTxt");
         this._nextPage = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.nextBtn");
         this._prePage = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.preBtn");
         this._pageTextBG = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.pageTextBG");
         this._pageText = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.pageText");
         this._updateTimeText = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.updateTimeTxt");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreItem.vbox");
         this._vboxBg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreItemBg.vbox");
         addChild(this._between30_40);
         addChild(this._between41_50);
         addChild(this._bg1);
         addChild(this._rankText);
         addChild(this._nameText);
         addChild(this._scoreText);
         addChild(this._titleline1);
         addChild(this._titleline2);
         addChild(this._rankScoreBg);
         addChild(this._myRank);
         addChild(this._myScore);
         addChild(this._myRankTextBg);
         addChild(this._myScoreTextBg);
         addChild(this._myRankText);
         addChild(this._myScoreText);
         addChild(this._nextPage);
         addChild(this._prePage);
         addChild(this._pageTextBG);
         addChild(this._pageText);
         addChild(this._updateTimeText);
         addChild(this._vboxBg);
         this.initVboxBg();
         addChild(this._vbox);
         this._betweenBtnGroup = new SelectedButtonGroup();
         this._betweenBtnGroup.addSelectItem(this._between30_40);
         this._betweenBtnGroup.addSelectItem(this._between41_50);
         if(PlayerManager.Instance.Self.Grade >= 41 && PlayerManager.Instance.Self.Grade <= DDT.THE_HIGHEST_LV)
         {
            this._betweenBtnGroup.selectIndex = 1;
         }
         else
         {
            this._betweenBtnGroup.selectIndex = 0;
         }
         PositionUtils.setPos(this._myRankText,"eliteGame.scoreRank.myRankText.pos");
         PositionUtils.setPos(this._myScoreText,"eliteGame.scoreRank.myScoreText.pos");
         this._myRankText.text = EliteGameController.Instance.Model.selfRank.toString();
         this._myScoreText.text = EliteGameController.Instance.Model.selfScore.toString();
         this._allInfo = EliteGameController.Instance.Model.scoreRankInfo;
         this.currentPage = 1;
         if(Boolean(this._allInfo))
         {
            this._updateTimeText.text = LanguageMgr.GetTranslation("tank.tofflist.view.lastUpdateTime") + this._allInfo.lassUpdateTime;
         }
         this.showType(this._betweenBtnGroup.selectIndex);
      }
      
      private function initVboxBg() : void
      {
         for(var m:int = 0; m < 8; m++)
         {
            if(Boolean(m & 1))
            {
               this._lingBg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.lineBg");
               this._lingBg.setFrame(2);
               this._vboxBg.addChild(this._lingBg);
            }
            else
            {
               this._lingBg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.lineBg");
               this._lingBg.setFrame(1);
               this._vboxBg.addChild(this._lingBg);
            }
         }
      }
      
      private function initEvent() : void
      {
         this._prePage.addEventListener(MouseEvent.CLICK,this.__prePageHandler);
         this._nextPage.addEventListener(MouseEvent.CLICK,this.__nextPagehandler);
         this._betweenBtnGroup.addEventListener(Event.CHANGE,this.__betweenChangeHandler);
         EliteGameController.Instance.Model.addEventListener(EliteGameEvent.SCORERANK_DATAREADY,this.__dataReady);
         EliteGameController.Instance.Model.addEventListener(EliteGameEvent.SELF_RANK_SCORE_READY,this.__selfRankReady);
      }
      
      private function removeEvent() : void
      {
         this._prePage.removeEventListener(MouseEvent.CLICK,this.__prePageHandler);
         this._nextPage.removeEventListener(MouseEvent.CLICK,this.__nextPagehandler);
         this._betweenBtnGroup.removeEventListener(Event.CHANGE,this.__betweenChangeHandler);
         EliteGameController.Instance.Model.removeEventListener(EliteGameEvent.SCORERANK_DATAREADY,this.__dataReady);
         EliteGameController.Instance.Model.removeEventListener(EliteGameEvent.SELF_RANK_SCORE_READY,this.__selfRankReady);
      }
      
      private function __selfRankReady(event:EliteGameEvent) : void
      {
         this._myRankText.text = EliteGameController.Instance.Model.selfRank.toString();
         this._myScoreText.text = EliteGameController.Instance.Model.selfScore.toString();
      }
      
      private function __prePageHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setPage(this.currentPage - 1);
      }
      
      private function __nextPagehandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setPage(this.currentPage + 1);
      }
      
      protected function __dataReady(event:Event) : void
      {
         this._allInfo = EliteGameController.Instance.Model.scoreRankInfo;
         this._updateTimeText.text = LanguageMgr.GetTranslation("tank.tofflist.view.lastUpdateTime") + this._allInfo.lassUpdateTime;
         this.showType(this._betweenBtnGroup.selectIndex);
      }
      
      protected function __betweenChangeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.showType(this._betweenBtnGroup.selectIndex);
      }
      
      private function showType(type:int) : void
      {
         switch(type)
         {
            case type30_40:
               if(Boolean(this._allInfo))
               {
                  this.setTypeData(this._allInfo.rank30_40);
               }
               break;
            case type41_50:
               if(Boolean(this._allInfo))
               {
                  this.setTypeData(this._allInfo.rank41_50);
               }
         }
         this.setPage(1);
      }
      
      private function setTypeData(list:Vector.<EliteGameScroeRankInfo>) : void
      {
         this._list = list;
         this._totalPage = Math.ceil(this._list.length / 8) == 0 ? 1 : int(Math.ceil(this._list.length / 8));
      }
      
      private function setPage(value:int) : void
      {
         var begain:int = 0;
         var end:int = 0;
         this.currentPage = value;
         if(Boolean(this._list))
         {
            begain = (value - 1) * 8;
            end = value * 8 > this._list.length ? int(this._list.length) : value * 8;
            this.setPageData(this._list.slice(begain,end));
         }
      }
      
      private function setPageData(data:Vector.<EliteGameScroeRankInfo>) : void
      {
         var item:EliteGameScoreRankItem = null;
         this.clearItems();
         this._items = new Vector.<EliteGameScoreRankItem>();
         for(var i:int = 0; i < data.length; i++)
         {
            item = new EliteGameScoreRankItem();
            item.info = data[i];
            this._vbox.addChild(item);
            this._items.push(item);
         }
      }
      
      private function clearItems() : void
      {
         var j:int = 0;
         if(Boolean(this._items) && this._items.length != 0)
         {
            for(j = 0; j < this._items.length; j++)
            {
               ObjectUtils.disposeObject(this._items[j]);
               this._items[j] = null;
            }
         }
         this._items = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._between30_40))
         {
            ObjectUtils.disposeObject(this._between30_40);
         }
         this._between30_40 = null;
         if(Boolean(this._between41_50))
         {
            ObjectUtils.disposeObject(this._between41_50);
         }
         this._between41_50 = null;
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(Boolean(this._rankText))
         {
            ObjectUtils.disposeObject(this._rankText);
         }
         this._rankText = null;
         if(Boolean(this._nameText))
         {
            ObjectUtils.disposeObject(this._nameText);
         }
         this._nameText = null;
         if(Boolean(this._scoreText))
         {
            ObjectUtils.disposeObject(this._scoreText);
         }
         this._scoreText = null;
         if(Boolean(this._titleline1))
         {
            ObjectUtils.disposeObject(this._titleline1);
         }
         this._titleline1 = null;
         if(Boolean(this._titleline2))
         {
            ObjectUtils.disposeObject(this._titleline2);
         }
         this._titleline2 = null;
         if(Boolean(this._myRank))
         {
            ObjectUtils.disposeObject(this._myRank);
         }
         this._myRank = null;
         if(Boolean(this._myScore))
         {
            ObjectUtils.disposeObject(this._myScore);
         }
         this._myScore = null;
         if(Boolean(this._rankScoreBg))
         {
            ObjectUtils.disposeObject(this._rankScoreBg);
         }
         this._rankScoreBg = null;
         if(Boolean(this._myRankTextBg))
         {
            ObjectUtils.disposeObject(this._myRankTextBg);
         }
         this._myRankTextBg = null;
         if(Boolean(this._myScoreTextBg))
         {
            ObjectUtils.disposeObject(this._myScoreTextBg);
         }
         this._myScoreTextBg = null;
         if(Boolean(this._myRankText))
         {
            ObjectUtils.disposeObject(this._myRankText);
         }
         this._myRankText = null;
         if(Boolean(this._myScoreText))
         {
            ObjectUtils.disposeObject(this._myScoreText);
         }
         this._myScoreText = null;
         if(Boolean(this._nextPage))
         {
            ObjectUtils.disposeObject(this._nextPage);
         }
         this._nextPage = null;
         if(Boolean(this._prePage))
         {
            ObjectUtils.disposeObject(this._prePage);
         }
         this._prePage = null;
         if(Boolean(this._pageTextBG))
         {
            ObjectUtils.disposeObject(this._pageTextBG);
         }
         this._pageTextBG = null;
         if(Boolean(this._pageText))
         {
            ObjectUtils.disposeObject(this._pageText);
         }
         this._pageText = null;
         if(Boolean(this._updateTimeText))
         {
            ObjectUtils.disposeObject(this._updateTimeText);
         }
         this._updateTimeText = null;
         this.clearItems();
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._vboxBg))
         {
            ObjectUtils.disposeObject(this._vboxBg);
         }
         this._vbox = null;
         this._allInfo = null;
         this._list = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

