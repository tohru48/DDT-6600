package dragonBoat.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import dragonBoat.DragonBoatManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DragonBoatShopFrame extends BaseAlerFrame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _coinText:FilterFrameText;
      
      private var _coinNumBG:Scale9CornerImage;
      
      private var _coinNumText:FilterFrameText;
      
      private var _lable:FilterFrameText;
      
      private var _pageBg:Scale9CornerImage;
      
      private var _pageTxt:FilterFrameText;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _shopCellList:Vector.<DragonBoatShopCell>;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _goodsInfoList:Vector.<ShopItemInfo>;
      
      public function DragonBoatShopFrame()
      {
         super();
         this._goodsInfoList = ShopManager.Instance.getValidGoodByType(ShopType.DRAGON_BOAT_TYPE);
         var tmpLen:int = int(this._goodsInfoList.length);
         this._totlePage = Math.ceil(tmpLen / 8);
         this._currentPage = 1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmpCell:DragonBoatShopCell = null;
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.dragonBoat.shopTitleTxt"),"",LanguageMgr.GetTranslation("tank.calendar.Activity.BackButtonText"),false);
         alertInfo.moveEnable = false;
         alertInfo.autoDispose = false;
         alertInfo.sound = "008";
         info = alertInfo;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.bg");
         this._coinText = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.coinTxt");
         this._coinText.text = LanguageMgr.GetTranslation("ddt.dragonBoat.shopCoinTxt");
         this._coinNumBG = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.coinBg");
         this._coinNumText = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.coinNumTxt");
         this._lable = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.labelTxt");
         this._lable.text = LanguageMgr.GetTranslation("ddt.dragonBoat.shopPromptTxt");
         this._pageBg = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.pageBg");
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.coinNumTxt");
         PositionUtils.setPos(this._pageTxt,"dragonBoat.shopFrame.pageTxtPos");
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.preBtn");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.shopFrame.nextBtn");
         addToContent(this._bg);
         addToContent(this._coinText);
         addToContent(this._coinNumBG);
         addToContent(this._coinNumText);
         addToContent(this._lable);
         addToContent(this._pageBg);
         addToContent(this._pageTxt);
         addToContent(this._preBtn);
         addToContent(this._nextBtn);
         this._shopCellList = new Vector.<DragonBoatShopCell>(8);
         for(i = 0; i < 8; i++)
         {
            tmpCell = new DragonBoatShopCell();
            tmpCell.x = 10 + i % 2 * (tmpCell.width + 6);
            tmpCell.y = 15 + int(i / 2) * (tmpCell.height + 5);
            addToContent(tmpCell);
            this._shopCellList[i] = tmpCell;
         }
         this.refreshView();
      }
      
      private function refreshShopView() : void
      {
         var tmpTag:int = 0;
         this._pageTxt.text = this._currentPage + "/" + this._totlePage;
         var startIndex:int = (this._currentPage - 1) * 8;
         var tmpCount:int = int(this._goodsInfoList.length);
         for(var i:int = 0; i < 8; i++)
         {
            tmpTag = startIndex + i;
            if(tmpTag >= tmpCount)
            {
               this._shopCellList[i].refreshShow(null);
            }
            else
            {
               this._shopCellList[i].refreshShow(this._goodsInfoList[tmpTag]);
            }
         }
      }
      
      private function refreshView(event:Event = null) : void
      {
         this.refreshShopView();
         this.refreshMoneyTxt();
      }
      
      private function refreshMoneyTxt() : void
      {
         this._coinNumText.text = DragonBoatManager.instance.useableScore.toString();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.changePageHandler,false,0,true);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.changePageHandler,false,0,true);
         DragonBoatManager.instance.addEventListener(DragonBoatManager.BUILD_OR_DECORATE_UPDATE,this.refreshView);
      }
      
      private function changePageHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var tmp:SimpleBitmapButton = event.currentTarget as SimpleBitmapButton;
         switch(tmp)
         {
            case this._preBtn:
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
         this.refreshShopView();
      }
      
      private function responseHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHandler);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.changePageHandler);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.changePageHandler);
         DragonBoatManager.instance.removeEventListener(DragonBoatManager.BUILD_OR_DECORATE_UPDATE,this.refreshView);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._goodsInfoList = null;
         this._shopCellList = null;
         this._bg = null;
         this._coinText = null;
         this._coinNumBG = null;
         this._coinNumText = null;
         this._lable = null;
         this._pageBg = null;
         this._pageTxt = null;
         this._preBtn = null;
         this._nextBtn = null;
      }
   }
}

