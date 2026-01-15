package ddt.view.academyCommon.recommend
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import flash.events.MouseEvent;
   
   public class AcademyMasterMainFrame extends AcademyApprenticeMainFrame implements Disposeable
   {
      
      public function AcademyMasterMainFrame()
      {
         super();
      }
      
      override protected function initContent() : void
      {
         _alertInfo = new AlertInfo();
         _alertInfo.bottomGap = 11;
         _alertInfo.customPos = ComponentFactory.Instance.creatCustomObject("academyCommon.myAcademy.gotoMainlPos");
         info = _alertInfo;
         info.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.AcademyMasterMainFrame.title");
         _treeImage = ComponentFactory.Instance.creatComponentByStylename("AcademyApprenticeMainFrame.scale9cornerImageTree");
         addToContent(_treeImage);
         _treeImage2 = ComponentFactory.Instance.creatComponentByStylename("AcademyApprenticeMainFrame.scale9cornerImageTree2");
         addToContent(_treeImage2);
         _recommendTitle = ComponentFactory.Instance.creatBitmap("asset.academy.recommendTitleAssetII");
         addToContent(_recommendTitle);
         _titleBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame.titleBtn");
         _titleBtn.text = LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree");
         addToContent(_titleBtn);
         _playerContainer = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame.playerContainer");
         addToContent(_playerContainer);
         _checkBoxBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.checkBoxBtn");
         _checkBoxBtn.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.checkBoxBtnInfo");
         if(!SharedManager.Instance.isRecommend)
         {
            addToContent(_checkBoxBtn);
         }
      }
      
      override protected function initPlayerContainer() : void
      {
         var item:RecommendMasterPlayerCellView = null;
         _items = [];
         for(var i:int = 0; i < MAX_ITEM; i++)
         {
            item = new RecommendMasterPlayerCellView();
            item.addEventListener(MouseEvent.CLICK,__itemClick);
            _playerContainer.addChild(item);
            _items.push(item);
         }
         _players = AcademyManager.Instance.recommendPlayers;
         updateItem();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

