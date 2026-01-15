package bombKing.view
{
   import bombKing.components.BKingRankItem;
   import bombKing.data.BKingRankInfo;
   import bombKing.event.BombKingEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   
   public class BombKingRankFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _menu:HBox;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _front100Btn:SelectedTextButton;
      
      private var _front16Btn:SelectedTextButton;
      
      private var _listBg:Bitmap;
      
      private var _topTxt:FilterFrameText;
      
      private var _pageBg:Scale9CornerImage;
      
      private var _pageTxt:FilterFrameText;
      
      private var _prevBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _bottomBg:MovieClip;
      
      private var _myRankImg:Bitmap;
      
      private var _bottomTxt:FilterFrameText;
      
      private var _myRank:FilterFrameText;
      
      private var _myScore:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _itemList:Vector.<BKingRankItem>;
      
      private var _currentIndex:int;
      
      private var _curPage:int;
      
      private var _totalPage:int;
      
      public function BombKingRankFrame()
      {
         super();
         this._itemList = new Vector.<BKingRankItem>();
         this.initView();
         this.initEvents();
         SocketManager.Instance.out.updateBombKingRank(2,1);
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("bombKing.rankFrame.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankFrame.bg");
         addToContent(this._bg);
         this._menu = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankFrame.hBox");
         addToContent(this._menu);
         this._front100Btn = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankFrame.front100Btn");
         this._menu.addChild(this._front100Btn);
         this._front100Btn.text = "Top100";
         this._front16Btn = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankFrame.front16Btn");
         this._menu.addChild(this._front16Btn);
         this._front16Btn.text = "Top16";
         this._listBg = ComponentFactory.Instance.creat("bombKing.rankFrame.listBg");
         addToContent(this._listBg);
         this._topTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankFrame.topTxt");
         addToContent(this._topTxt);
         this._topTxt.text = LanguageMgr.GetTranslation("bombKing.rankFrame.topTxt");
         this._pageBg = ComponentFactory.Instance.creatComponentByStylename("bombKing.PageCountBg");
         addToContent(this._pageBg);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.pageTxt");
         addToContent(this._pageTxt);
         this._pageTxt.text = "1/4";
         this._prevBtn = ComponentFactory.Instance.creatComponentByStylename("bombKing.prevBtn");
         addToContent(this._prevBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("bombKing.nextBtn");
         addToContent(this._nextBtn);
         this._bottomBg = ClassUtils.CreatInstance("bombKing.rankFrame.bottomBg");
         this._bottomBg.gotoAndStop(1);
         this._bottomBg.x = 11;
         this._bottomBg.y = 404;
         addToContent(this._bottomBg);
         this._bottomTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankFrame.bottomTxt");
         addToContent(this._bottomTxt);
         this._bottomTxt.text = LanguageMgr.GetTranslation("bombKing.rankFrame.bottomTxt");
         this._myRankImg = ComponentFactory.Instance.creat("bombKing.myRankAsset");
         addToContent(this._myRankImg);
         this._myRank = ComponentFactory.Instance.creatComponentByStylename("bombKing.myRankTxt");
         this._myRank.text = "10";
         addToContent(this._myRank);
         this._myScore = ComponentFactory.Instance.creatComponentByStylename("bombKing.myScoreTxt");
         this._myScore.text = "7981516";
         addToContent(this._myScore);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("bombKing.vBox");
         addToContent(this._vbox);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._front100Btn);
         this._btnGroup.addSelectItem(this._front16Btn);
         this._btnGroup.selectIndex = 1;
         this._currentIndex = 1;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._prevBtn.addEventListener(MouseEvent.CLICK,this.__prevBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         SocketManager.Instance.addEventListener(BombKingEvent.RANK_BY_PAGE,this.__updateRank);
      }
      
      protected function __updateRank(event:BombKingEvent) : void
      {
         var info:BKingRankInfo = null;
         var item:BKingRankItem = null;
         var pkg:PackageIn = event.pkg;
         this._currentIndex = pkg.readInt();
         this._btnGroup.selectIndex = this._currentIndex;
         this._totalPage = pkg.readInt();
         this._curPage = pkg.readInt();
         this._curPage = this._totalPage <= 0 ? 0 : this._curPage;
         this._pageTxt.text = this._curPage + "/" + this._totalPage;
         this.clearItems();
         var count:int = pkg.readInt();
         for(var i:int = 0; i <= count - 1; i++)
         {
            info = new BKingRankInfo();
            info.place = pkg.readInt();
            info.userId = pkg.readInt();
            info.areaId = pkg.readInt();
            info.name = pkg.readUTF();
            info.areaName = pkg.readUTF();
            info.vipType = pkg.readInt();
            info.vipLvl = pkg.readInt();
            info.num = pkg.readInt();
            item = new BKingRankItem();
            item.info = info;
            this._itemList.push(item);
            this._vbox.addChild(item);
         }
         var rank:int = pkg.readInt();
         if(rank <= 0)
         {
            this._myRank.text = LanguageMgr.GetTranslation("bombKing.outOfRank2");
         }
         else
         {
            this._myRank.text = rank.toString();
         }
         this._myScore.text = pkg.readInt().toString();
      }
      
      protected function __changeHandler(event:Event) : void
      {
         if(this._btnGroup.selectIndex == this._currentIndex)
         {
            return;
         }
         SoundManager.instance.play("008");
         this._currentIndex = this._btnGroup.selectIndex;
         SocketManager.Instance.out.updateBombKingRank(this._currentIndex,1);
      }
      
      protected function __prevBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._curPage <= 1)
         {
            return;
         }
         SocketManager.Instance.out.updateBombKingRank(this._currentIndex,this._curPage - 1);
      }
      
      protected function __nextBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._curPage >= this._totalPage)
         {
            return;
         }
         SocketManager.Instance.out.updateBombKingRank(this._currentIndex,this._curPage + 1);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function clearItems() : void
      {
         for(var i:int = 0; i <= this._itemList.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._itemList[i]);
            this._itemList[i] = null;
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         }
         if(Boolean(this._prevBtn))
         {
            this._prevBtn.removeEventListener(MouseEvent.CLICK,this.__prevBtnClick);
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         }
         SocketManager.Instance.removeEventListener(BombKingEvent.RANK_BY_PAGE,this.__updateRank);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearItems();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._menu);
         this._menu = null;
         ObjectUtils.disposeObject(this._front100Btn);
         this._front100Btn = null;
         ObjectUtils.disposeObject(this._front16Btn);
         this._front16Btn = null;
         ObjectUtils.disposeObject(this._listBg);
         this._listBg = null;
         ObjectUtils.disposeObject(this._topTxt);
         this._topTxt = null;
         ObjectUtils.disposeObject(this._pageBg);
         this._pageBg = null;
         ObjectUtils.disposeObject(this._pageTxt);
         this._pageTxt = null;
         ObjectUtils.disposeObject(this._prevBtn);
         this._prevBtn = null;
         ObjectUtils.disposeObject(this._nextBtn);
         this._nextBtn = null;
         ObjectUtils.disposeObject(this._bottomBg);
         this._bottomBg = null;
         ObjectUtils.disposeObject(this._myRankImg);
         this._myRankImg = null;
         ObjectUtils.disposeObject(this._myRank);
         this._myRank = null;
         ObjectUtils.disposeObject(this._myScore);
         this._myScore = null;
         ObjectUtils.disposeObject(this._bottomTxt);
         this._bottomBg = null;
         super.dispose();
      }
   }
}

