package league.view
{
   import battleGroud.BattleGroudManager;
   import battleGroud.data.BatlleData;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import league.manager.LeagueManager;
   
   public class LeagueShopFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _moneyCountTxt:FilterFrameText;
      
      private var _pageTxt:FilterFrameText;
      
      private var _foreBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _shopCellList:Vector.<LeagueShopCell>;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _goodsInfoList:Vector.<ShopItemInfo>;
      
      public function LeagueShopFrame()
      {
         var tmpData:BatlleData = null;
         super();
         this._goodsInfoList = ShopManager.Instance.getValidGoodByType(ShopType.LEAGUE_SHOP_TYPE);
         var tmpLen:int = int(this._goodsInfoList.length);
         this._totlePage = Math.ceil(tmpLen / 4);
         this._currentPage = 1;
         if(Boolean(BattleGroudManager.Instance.orderdata))
         {
            tmpData = BattleGroudManager.Instance.getBattleDataByPrestige(BattleGroudManager.Instance.orderdata.totalPrestige);
            LeagueManager.instance.militaryRank = tmpData.Level;
         }
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmpCell:LeagueShopCell = null;
         titleText = LanguageMgr.GetTranslation("tank.menu.MatchesTxt");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.leagueShopFrame.bg");
         this._moneyCountTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopFrame.moneyCountTxt");
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopFrame.pageTxt");
         this._foreBtn = ComponentFactory.Instance.creatComponentByStylename("leagueShopFrame.foreBtn");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("leagueShopFrame.nextBtn");
         addToContent(this._bg);
         addToContent(this._moneyCountTxt);
         addToContent(this._pageTxt);
         addToContent(this._foreBtn);
         addToContent(this._nextBtn);
         this._shopCellList = new Vector.<LeagueShopCell>(4);
         for(i = 0; i < 4; i++)
         {
            tmpCell = new LeagueShopCell();
            tmpCell.x = 14 + i % 2 * (tmpCell.width + 3);
            tmpCell.y = 263 + int(i / 2) * (tmpCell.height + 2);
            addToContent(tmpCell);
            this._shopCellList[i] = tmpCell;
         }
         this.refreshView();
         this.refreshMoneyTxt();
      }
      
      private function refreshView() : void
      {
         var i:int = 0;
         var tmpTag:int = 0;
         this._pageTxt.text = this._currentPage + "/" + this._totlePage;
         var startIndex:int = (this._currentPage - 1) * 4;
         var tmpCount:int = int(this._goodsInfoList.length);
         for(i = 0; i < 4; i++)
         {
            tmpTag = startIndex + i;
            if(tmpTag >= tmpCount)
            {
               this._shopCellList[i].visible = false;
            }
            else
            {
               this._shopCellList[i].visible = true;
               this._shopCellList[i].refreshShow(this._goodsInfoList[tmpTag]);
            }
         }
      }
      
      private function refreshMoneyTxt() : void
      {
         this._moneyCountTxt.text = PlayerManager.Instance.Self.leagueMoney.toString();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._foreBtn.addEventListener(MouseEvent.CLICK,this.changePageHandler,false,0,true);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.changePageHandler,false,0,true);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.propertyChangeHandler);
      }
      
      private function propertyChangeHandler(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["leagueMoney"]))
         {
            this.refreshMoneyTxt();
         }
      }
      
      private function changePageHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var tmp:SimpleBitmapButton = event.currentTarget as SimpleBitmapButton;
         switch(tmp)
         {
            case this._foreBtn:
               if(this._currentPage <= 1)
               {
                  this._currentPage = this._totlePage;
               }
               else
               {
                  --this._currentPage;
               }
               break;
            case this._nextBtn:
               if(this._currentPage >= this._totlePage)
               {
                  this._currentPage = 1;
               }
               else
               {
                  ++this._currentPage;
               }
         }
         this.refreshView();
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._foreBtn.removeEventListener(MouseEvent.CLICK,this.changePageHandler);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.changePageHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.propertyChangeHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._moneyCountTxt = null;
         this._pageTxt = null;
         this._foreBtn = null;
         this._nextBtn = null;
         this._shopCellList = null;
         this._goodsInfoList = null;
         LeagueManager.instance.militaryRank = -1;
      }
   }
}

