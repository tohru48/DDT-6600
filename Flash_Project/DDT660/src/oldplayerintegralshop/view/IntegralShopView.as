package oldplayerintegralshop.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import oldplayerintegralshop.IntegralShopManager;
   import road7th.comm.PackageIn;
   
   public class IntegralShopView extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _infoText:FilterFrameText;
      
      private var _callText:FilterFrameText;
      
      private var _pageTxt:FilterFrameText;
      
      private var _integralNum:FilterFrameText;
      
      private var _foreBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _shopCellList:Vector.<IntegralShopCell>;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _goodsInfoList:Vector.<ShopItemInfo>;
      
      public function IntegralShopView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.sendUpdateIntegral();
      }
      
      private function initData() : void
      {
         this._goodsInfoList = ShopManager.Instance.getValidGoodByType(ShopType.REGRESS_SHOP);
         var tmpLen:int = int(this._goodsInfoList.length);
         this._totlePage = Math.ceil(tmpLen / 4);
         this._currentPage = 1;
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmpCell:IntegralShopCell = null;
         titleText = LanguageMgr.GetTranslation("IMView.integralShop.TitleText");
         this._bg = ComponentFactory.Instance.creat("asset.integralShopView.viewBg");
         addToContent(this._bg);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("integralShopView.infoText");
         this._infoText.text = LanguageMgr.GetTranslation("integralShopView.info.Text");
         addToContent(this._infoText);
         this._callText = ComponentFactory.Instance.creatComponentByStylename("integralShopView.call");
         this._callText.text = LanguageMgr.GetTranslation("integralShopView.callText");
         addToContent(this._callText);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("integralShopView.pageTxt");
         addToContent(this._pageTxt);
         this._integralNum = ComponentFactory.Instance.creatComponentByStylename("integralShopView.integralNum");
         this._integralNum.text = "0";
         addToContent(this._integralNum);
         this._foreBtn = ComponentFactory.Instance.creatComponentByStylename("integralShopView.foreBtn");
         addToContent(this._foreBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("integralShopView.nextBtn");
         addToContent(this._nextBtn);
         this._shopCellList = new Vector.<IntegralShopCell>(4);
         for(i = 0; i < 4; i++)
         {
            tmpCell = new IntegralShopCell();
            tmpCell.x = 16 + i % 2 * (tmpCell.width + 3);
            tmpCell.y = 227 + int(i / 2) * (tmpCell.height + 2);
            addToContent(tmpCell);
            this._shopCellList[i] = tmpCell;
         }
         this.refreshView();
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
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._foreBtn.addEventListener(MouseEvent.CLICK,this.__changePageHandler);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__changePageHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_UPDATE_INTEGRAL,this.__onUpdateIntegral);
      }
      
      protected function __onUpdateIntegral(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         pkg.readInt();
         IntegralShopManager.instance.integralNum = pkg.readInt();
         this._integralNum.text = String(IntegralShopManager.instance.integralNum);
      }
      
      private function __changePageHandler(event:MouseEvent) : void
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
      
      protected function __onAlertResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.playButtonSound();
               alert.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._foreBtn.removeEventListener(MouseEvent.CLICK,this.__changePageHandler);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__changePageHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REGRESS_UPDATE_INTEGRAL,this.__onUpdateIntegral);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               IntegralShopManager.instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._infoText))
         {
            this._infoText.dispose();
            this._infoText = null;
         }
         if(Boolean(this._callText))
         {
            this._callText.dispose();
            this._callText = null;
         }
         if(Boolean(this._pageTxt))
         {
            this._pageTxt.dispose();
            this._pageTxt = null;
         }
         if(Boolean(this._integralNum))
         {
            this._integralNum.dispose();
            this._integralNum = null;
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         if(Boolean(this._foreBtn))
         {
            this._foreBtn.dispose();
            this._foreBtn = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

