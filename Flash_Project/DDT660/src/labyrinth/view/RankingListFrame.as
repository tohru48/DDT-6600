package labyrinth.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.events.Event;
   import labyrinth.LabyrinthManager;
   
   public class RankingListFrame extends BaseAlerFrame
   {
      
      private var _bg:Bitmap;
      
      private var _rankingTitle:FilterFrameText;
      
      private var _rankingTitleI:FilterFrameText;
      
      private var _rankingTitleII:FilterFrameText;
      
      private var _list:ListPanel;
      
      public function RankingListFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var alerInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.labyrinth.RankingListFrame.title"));
         info = alerInfo;
         this._bg = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.RankingListFrame.BG");
         addToContent(this._bg);
         this._rankingTitle = ComponentFactory.Instance.creatComponentByStylename("labyrinth.rankingListFrame.titleText");
         this._rankingTitle.text = LanguageMgr.GetTranslation("labyrinth.rankingListFrame.titleText");
         addToContent(this._rankingTitle);
         this._rankingTitleI = ComponentFactory.Instance.creatComponentByStylename("labyrinth.rankingListFrame.titleTextI");
         this._rankingTitleI.text = LanguageMgr.GetTranslation("labyrinth.rankingListFrame.titleTextI");
         addToContent(this._rankingTitleI);
         this._rankingTitleII = ComponentFactory.Instance.creatComponentByStylename("labyrinth.rankingListFrame.titleTextII");
         this._rankingTitleII.text = LanguageMgr.GetTranslation("labyrinth.rankingListFrame.titleTextII");
         addToContent(this._rankingTitleII);
         this._list = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.RankingListFrame.List");
         addToContent(this._list);
         this.initEvent();
         var list:Array = LabyrinthManager.Instance.model.rankingList;
         this._list.vectorListModel.appendAll(list);
         LabyrinthManager.Instance.loadRankingList();
      }
      
      private function initEvent() : void
      {
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.RANKING_LOAD_COMPLETE,this.__updateList);
      }
      
      protected function __updateList(event:Event) : void
      {
         var list:Array = LabyrinthManager.Instance.model.rankingList;
         this._list.vectorListModel.appendAll(list);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.RANKING_LOAD_COMPLETE,this.__updateList);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._rankingTitle);
         this._rankingTitle = null;
         ObjectUtils.disposeObject(this._rankingTitleI);
         this._rankingTitleI = null;
         ObjectUtils.disposeObject(this._rankingTitleII);
         this._rankingTitleII = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         super.dispose();
      }
   }
}

