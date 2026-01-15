package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class AuctionBuyRightView extends Sprite implements Disposeable
   {
      
      private var panel:ScrollPanel;
      
      private var _strips:Vector.<AuctionBuyStripView>;
      
      private var _selectStrip:AuctionBuyStripView;
      
      private var _list:VBox;
      
      private var _nameTxt:FilterFrameText;
      
      private var _bidNumberTxt:FilterFrameText;
      
      private var _RemainingTimeTxt:FilterFrameText;
      
      private var _bidpriceTxt:FilterFrameText;
      
      private var _statusTxt:FilterFrameText;
      
      private var _mouthfulTxt:FilterFrameText;
      
      private var _tableline:Bitmap;
      
      private var _tableline1:Bitmap;
      
      private var _tableline2:Bitmap;
      
      private var _tableline3:Bitmap;
      
      private var _tableline4:Bitmap;
      
      private var _tableline5:Bitmap;
      
      private var _talbeline6:Bitmap;
      
      public function AuctionBuyRightView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var bg:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.BuyBG");
         addChild(bg);
         var bg1:MovieImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.sellItemBG5");
         addChild(bg1);
         this._talbeline6 = ComponentFactory.Instance.creatBitmap("asset.ddtcore.TwotableLine");
         PositionUtils.setPos(this._talbeline6,"asset.ddtauction.TwotableLine.pos");
         addChild(this._talbeline6);
         this._talbeline6.width = 938;
         this._nameTxt = ComponentFactory.Instance.creat("ddtauction.nameTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
         addChild(this._nameTxt);
         this._bidNumberTxt = ComponentFactory.Instance.creat("ddtauction.bidNumerTxt");
         this._bidNumberTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.number");
         addChild(this._bidNumberTxt);
         this._bidNumberTxt.x = 275;
         this._RemainingTimeTxt = ComponentFactory.Instance.creat("ddtauction.remainingTimeTxt");
         this._RemainingTimeTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.timer");
         addChild(this._RemainingTimeTxt);
         this._RemainingTimeTxt.x = 384;
         this._bidpriceTxt = ComponentFactory.Instance.creat("ddtauction.BidPriceTxt");
         this._bidpriceTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.price");
         addChild(this._bidpriceTxt);
         this._bidpriceTxt.x = 807;
         this._statusTxt = ComponentFactory.Instance.creat("ddtauction.statusTxt");
         this._statusTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.status");
         addChild(this._statusTxt);
         this._statusTxt.x = 638;
         this._mouthfulTxt = ComponentFactory.Instance.creat("ddtauction.mouthfulTxt");
         this._mouthfulTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.mouthful");
         addChild(this._mouthfulTxt);
         this._mouthfulTxt.x = 522;
         this._tableline = ComponentFactory.Instance.creatBitmap("asset.ddtauction.tableLine");
         addChild(this._tableline);
         this._tableline.x = 264;
         this._tableline1 = ComponentFactory.Instance.creatBitmap("asset.ddtauction.tableLine");
         addChild(this._tableline1);
         this._tableline1.x = 339;
         this._tableline2 = ComponentFactory.Instance.creatBitmap("asset.ddtauction.tableLine");
         addChild(this._tableline2);
         this._tableline2.x = 501;
         this._tableline3 = ComponentFactory.Instance.creatBitmap("asset.ddtauction.tableLine");
         addChild(this._tableline3);
         this._tableline3.x = 606;
         this._tableline4 = ComponentFactory.Instance.creatBitmap("asset.ddtauction.tableLine");
         addChild(this._tableline4);
         this._tableline4.x = 739;
         this._list = new VBox();
         this._strips = new Vector.<AuctionBuyStripView>();
         this.panel = ComponentFactory.Instance.creat("auctionHouse.BrowseBuyScrollpanel");
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.setView(this._list);
         addChild(this.panel);
         this.invalidatePanel();
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      internal function addAuction(info:AuctionGoodsInfo) : void
      {
         var strip:AuctionBuyStripView = new AuctionBuyStripView();
         strip.info = info;
         strip.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
         this._strips.push(strip);
         this._list.addChild(strip);
         this.invalidatePanel();
      }
      
      private function invalidatePanel() : void
      {
         this.panel.vScrollProxy = this._list.height > this.panel.height ? ScrollPanel.ON : ScrollPanel.OFF;
         this.panel.invalidateViewport();
      }
      
      internal function clearList() : void
      {
         this._clearItems();
         this._selectStrip = null;
         this._strips = new Vector.<AuctionBuyStripView>();
      }
      
      private function _clearItems() : void
      {
         this._strips.splice(0,this._strips.length);
         this._list.disposeAllChildren();
         this._list.height = 0;
         this.invalidatePanel();
      }
      
      internal function getSelectInfo() : AuctionGoodsInfo
      {
         if(Boolean(this._selectStrip))
         {
            return this._selectStrip.info;
         }
         return null;
      }
      
      internal function deleteItem() : void
      {
         for(var i:int = 0; i < this._strips.length; i++)
         {
            if(this._selectStrip == this._strips[i])
            {
               this._selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
               this._selectStrip.dispose();
               this._strips.splice(i,1);
               this._selectStrip = null;
               break;
            }
         }
      }
      
      internal function clearSelectStrip() : void
      {
         var strip:AuctionBuyStripView = null;
         for each(strip in this._strips)
         {
            if(this._selectStrip == strip)
            {
               this._selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
               this._selectStrip.clearSelectStrip();
               this._selectStrip = null;
               break;
            }
         }
      }
      
      internal function updateAuction(info:AuctionGoodsInfo) : void
      {
         var strip:AuctionBuyStripView = null;
         for each(strip in this._strips)
         {
            if(strip.info.AuctionID == info.AuctionID)
            {
               info.BagItemInfo = strip.info.BagItemInfo;
               strip.info = info;
               break;
            }
         }
      }
      
      private function __selectStrip(event:AuctionHouseEvent) : void
      {
         if(Boolean(this._selectStrip))
         {
            this._selectStrip.isSelect = false;
         }
         var strip:AuctionBuyStripView = event.target as AuctionBuyStripView;
         strip.isSelect = true;
         this._selectStrip = strip;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      public function dispose() : void
      {
         var strip:AuctionBuyStripView = null;
         this.removeEvent();
         if(Boolean(this.panel))
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(Boolean(this._selectStrip))
         {
            ObjectUtils.disposeObject(this._selectStrip);
         }
         this._selectStrip = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         for each(strip in this._strips)
         {
            if(Boolean(strip))
            {
               ObjectUtils.disposeObject(strip);
            }
            strip = null;
         }
         this._strips = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

