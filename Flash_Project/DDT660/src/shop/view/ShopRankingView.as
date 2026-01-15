package shop.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenProxy;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import shop.ShopController;
   import shop.manager.ShopBuyManager;
   import shop.manager.ShopGiftsManager;
   
   public class ShopRankingView extends Sprite implements Disposeable
   {
      
      private var _controller:ShopController;
      
      private var _shopSearchBg:Image;
      
      private var _rankingTitleBg:Bitmap;
      
      private var _rankingTitle:Bitmap;
      
      private var _rankingBackBg:Scale9CornerImage;
      
      private var _rankingFrontBg:Scale9CornerImage;
      
      private var _rankingFrontTexture:ScaleBitmapImage;
      
      private var _rankingBg:Image;
      
      private var _shopSearchBtn:TextButton;
      
      private var _shopSearchText:FilterFrameText;
      
      private var _vBox:VBox;
      
      private var _rankingItems:Vector.<ShopRankingCellItem>;
      
      private var _rankingLightMc:MovieClip;
      
      private var _separator:Vector.<Bitmap>;
      
      private var _currentShopSearchText:String;
      
      private var _currentList:Vector.<ShopItemInfo>;
      
      private var _shopPresentClearingFrame:ShopPresentClearingFrame;
      
      public function ShopRankingView()
      {
         super();
      }
      
      public function setup($controller:ShopController) : void
      {
         this._controller = $controller;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var separator:Bitmap = null;
         this._shopSearchBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchBg");
         addChild(this._shopSearchBg);
         this._rankingBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RankingViewBg");
         addChild(this._rankingBg);
         this._rankingTitleBg = ComponentFactory.Instance.creatBitmap("asset.ddtshop.RankingTitleBg");
         addChild(this._rankingTitleBg);
         this._rankingTitle = ComponentFactory.Instance.creatBitmap("asset.ddtshop.RankingTitle");
         addChild(this._rankingTitle);
         this._shopSearchBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchBtn");
         this._shopSearchBtn.text = LanguageMgr.GetTranslation("shop.ShopRankingView.SearchBtnText");
         addChild(this._shopSearchBtn);
         this._shopSearchText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchText");
         this._shopSearchText.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
         addChild(this._shopSearchText);
         this._rankingItems = new Vector.<ShopRankingCellItem>();
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RankingItemsContainer");
         addChild(this._vBox);
         this._rankingLightMc = ComponentFactory.Instance.creatCustomObject("ddtshop.RankingLightMc");
         this._separator = new Vector.<Bitmap>();
         for(var i:int = 0; i < 5; i++)
         {
            this._rankingItems[i] = ComponentFactory.Instance.creatCustomObject("ddtshop.ShopRankingCellItem");
            this._rankingItems[i].itemCellBtn.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._rankingItems[i].itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__rankingItemsMouseOver);
            this._rankingItems[i].itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__rankingItemsMouseOut);
            this._rankingItems[i].itemBg.addEventListener(MouseEvent.MOUSE_OVER,this.__rankingItemsMouseOver);
            this._rankingItems[i].itemBg.addEventListener(MouseEvent.MOUSE_OUT,this.__rankingItemsMouseOut);
            this._rankingItems[i].payPaneGivingBtn.addEventListener(MouseEvent.CLICK,this.__payPaneGivingBtnClick);
            this._rankingItems[i].payPaneBuyBtn.addEventListener(MouseEvent.CLICK,this.__payPaneBuyBtnClick);
            this._rankingItems[i].payPaneAskBtn.addEventListener(MouseEvent.CLICK,this.payPaneAskHander);
            this._vBox.addChild(this._rankingItems[i]);
            if(i != 0)
            {
               separator = ComponentFactory.Instance.creatBitmap("asset.ddtshop.RankingSeparator");
               PositionUtils.setPos(separator,ComponentFactory.Instance.creatCustomObject("ddtshop.RankingViewSeparator_" + i));
               addChild(separator);
               this._separator.push(separator);
            }
         }
         this.loadList();
      }
      
      private function addEvent() : void
      {
         this._shopSearchText.addEventListener(FocusEvent.FOCUS_IN,this.__shopSearchTextFousIn);
         this._shopSearchText.addEventListener(FocusEvent.FOCUS_OUT,this.__shopSearchTextFousOut);
         this._shopSearchText.addEventListener(KeyboardEvent.KEY_DOWN,this.__shopSearchTextKeyDown);
         this._shopSearchBtn.addEventListener(MouseEvent.CLICK,this.__shopSearchBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._shopSearchText.removeEventListener(FocusEvent.FOCUS_IN,this.__shopSearchTextFousIn);
         this._shopSearchText.removeEventListener(FocusEvent.FOCUS_OUT,this.__shopSearchTextFousOut);
         this._shopSearchText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__shopSearchTextKeyDown);
         this._shopSearchBtn.removeEventListener(MouseEvent.CLICK,this.__shopSearchBtnClick);
         for(var i:int = 0; i < 5; i++)
         {
            this._rankingItems[i].itemCellBtn.removeEventListener(MouseEvent.CLICK,this.__itemClick);
            this._rankingItems[i].itemCellBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__rankingItemsMouseOver);
            this._rankingItems[i].itemCellBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__rankingItemsMouseOut);
            this._rankingItems[i].itemBg.removeEventListener(MouseEvent.MOUSE_OVER,this.__rankingItemsMouseOver);
            this._rankingItems[i].itemBg.removeEventListener(MouseEvent.MOUSE_OUT,this.__rankingItemsMouseOut);
            this._rankingItems[i].payPaneGivingBtn.removeEventListener(MouseEvent.CLICK,this.__payPaneGivingBtnClick);
            this._rankingItems[i].payPaneBuyBtn.removeEventListener(MouseEvent.CLICK,this.__payPaneBuyBtnClick);
            this._rankingItems[i].payPaneAskBtn.removeEventListener(MouseEvent.CLICK,this.payPaneAskHander);
         }
      }
      
      private function payPaneAskHander(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         var cell:ShopRankingCellItem = e.currentTarget.parent as ShopRankingCellItem;
         var shopItemInfo:ShopItemInfo = cell.shopItemInfo;
         if(Boolean(shopItemInfo) && shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            if(shopItemInfo.isDiscount == 2 && ShopManager.Instance.getDisCountShopItemByGoodsID(shopItemInfo.GoodsID) == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.shop.discount.exit"));
               return;
            }
            ShopBuyManager.Instance.buy(shopItemInfo.GoodsID,shopItemInfo.isDiscount,3);
         }
      }
      
      private function __payPaneGivingBtnClick(event:Event) : void
      {
         var j:ISelectable = null;
         event.stopImmediatePropagation();
         var item:ShopRankingCellItem = event.currentTarget.parent as ShopRankingCellItem;
         if(Boolean(item.shopItemInfo) && item.shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(item.shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            ShopGiftsManager.Instance.buy(item.shopItemInfo.GoodsID,false,ShopCheckOutView.PRESENT);
            for each(j in this._rankingItems)
            {
               j.selected = false;
            }
            item.selected = true;
         }
      }
      
      private function __payPaneBuyBtnClick(event:Event) : void
      {
         var j:ISelectable = null;
         event.stopImmediatePropagation();
         var item:ShopRankingCellItem = event.currentTarget.parent as ShopRankingCellItem;
         if(Boolean(item.shopItemInfo) && item.shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(item.shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            ShopBuyManager.Instance.buy(item.shopItemInfo.GoodsID);
            for each(j in this._rankingItems)
            {
               j.selected = false;
            }
            item.selected = true;
         }
      }
      
      protected function __shopSearchTextKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == 13)
         {
            this.__shopSearchBtnClick();
         }
      }
      
      protected function __shopSearchTextFousIn(event:FocusEvent) : void
      {
         if(this._shopSearchText.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText"))
         {
            this._shopSearchText.text = "";
         }
      }
      
      protected function __shopSearchTextFousOut(event:FocusEvent) : void
      {
         if(this._shopSearchText.text.length == 0)
         {
            this._shopSearchText.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
         }
      }
      
      protected function __shopSearchBtnClick(event:MouseEvent = null) : void
      {
         var list:Vector.<ShopItemInfo> = null;
         SoundManager.instance.play("008");
         if(this._shopSearchText.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText") || this._shopSearchText.text.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ShopRankingView.PleaseEnterTheKeywords"));
            return;
         }
         if(this._currentShopSearchText != this._shopSearchText.text)
         {
            this._currentShopSearchText = this._shopSearchText.text;
            list = ShopManager.Instance.getDesignatedAllShopItem();
            list = ShopManager.Instance.fuzzySearch(list,this._currentShopSearchText);
            this._currentList = list;
         }
         else
         {
            list = this._currentList;
         }
         if(list.length > 0)
         {
            this._controller.rightView.searchList(list);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ShopRankingView.NoSearchResults"));
         }
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),1,5));
      }
      
      private function getType() : int
      {
         var popularityRankingType:Array = [ShopType.M_POPULARITY_RANKING,ShopType.F_POPULARITY_RANKING];
         var sex:int = this._controller.rightView.genderGroup.selectIndex;
         return int(popularityRankingType[sex]);
      }
      
      public function setList(list:Vector.<ShopItemInfo>) : void
      {
         this.clearitems();
         for(var i:int = 0; i < 5; i++)
         {
            if(i < list.length && Boolean(list[i]))
            {
               this._rankingItems[i].shopItemInfo = list[i];
            }
         }
      }
      
      private function clearitems() : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            this._rankingItems[i].shopItemInfo = null;
         }
      }
      
      private function __itemClick(evt:MouseEvent) : void
      {
         var i:ISelectable = null;
         var j:ISelectable = null;
         var isAdd:Boolean = false;
         var isColorEditorVisble:Boolean = false;
         var sexId:int = 0;
         var shopItem:ShopCarItemInfo = null;
         var item:ShopRankingCellItem = evt.currentTarget.parent as ShopRankingCellItem;
         if(!item.shopItemInfo)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(item.shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(this._controller.model.isOverCount(item.shopItemInfo))
         {
            for each(i in this._rankingItems)
            {
               i.selected = i == item;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
            return;
         }
         if(Boolean(item.shopItemInfo) && Boolean(item.shopItemInfo.TemplateInfo))
         {
            for each(j in this._rankingItems)
            {
               j.selected = j == item;
            }
            if(EquipType.dressAble(item.shopItemInfo.TemplateInfo))
            {
               sexId = item.shopItemInfo.TemplateInfo.NeedSex != 2 ? 0 : 1;
               if(item.shopItemInfo.TemplateInfo.NeedSex != 0 && this._controller.rightView.genderGroup.selectIndex != sexId)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.sexAlert"));
                  return;
               }
               this._controller.addTempEquip(item.shopItemInfo);
            }
            else
            {
               shopItem = new ShopCarItemInfo(item.shopItemInfo.GoodsID,item.shopItemInfo.TemplateID);
               ObjectUtils.copyProperties(shopItem,item.shopItemInfo);
               isAdd = this._controller.addToCar(shopItem);
            }
            isColorEditorVisble = this._controller.leftView.getColorEditorVisble();
            if(isAdd && !isColorEditorVisble)
            {
               this.addCartEffects(item.itemCell);
            }
         }
      }
      
      private function addCartEffects($item:DisplayObject) : void
      {
         var tp:TweenProxy = null;
         var timeline:TimelineLite = null;
         var tw:TweenLite = null;
         var tw1:TweenLite = null;
         if(!$item)
         {
            return;
         }
         var tempBitmapD:BitmapData = new BitmapData($item.width,$item.height,true,0);
         tempBitmapD.draw($item);
         var bitmap:Bitmap = new Bitmap(tempBitmapD,"auto",true);
         parent.addChild(bitmap);
         tp = TweenProxy.create(bitmap);
         tp.registrationX = tp.width / 2;
         tp.registrationY = tp.height / 2;
         var pos:Point = DisplayUtils.localizePoint(parent,$item);
         tp.x = pos.x + tp.width / 2;
         tp.y = pos.y + tp.height / 2;
         timeline = new TimelineLite();
         timeline.vars.onComplete = this.twComplete;
         timeline.vars.onCompleteParams = [timeline,tp,bitmap];
         tw = new TweenLite(tp,0.3,{
            "x":220,
            "y":430
         });
         tw1 = new TweenLite(tp,0.3,{
            "scaleX":0.1,
            "scaleY":0.1
         });
         timeline.append(tw);
         timeline.append(tw1,-0.2);
      }
      
      private function twComplete(timeline:TimelineLite, tp:TweenProxy, bitmap:Bitmap) : void
      {
         if(Boolean(timeline))
         {
            timeline.kill();
         }
         if(Boolean(tp))
         {
            tp.destroy();
         }
         if(Boolean(bitmap.parent))
         {
            bitmap.parent.removeChild(bitmap);
            bitmap.bitmapData.dispose();
         }
         tp = null;
         bitmap = null;
         timeline = null;
      }
      
      protected function __rankingItemsMouseOver(event:MouseEvent) : void
      {
         var item:ShopRankingCellItem = event.currentTarget.parent as ShopRankingCellItem;
         item.setItemLight(this._rankingLightMc);
         item.mouseOver();
      }
      
      protected function __rankingItemsMouseOut(event:MouseEvent) : void
      {
         var item:ShopRankingCellItem = event.currentTarget.parent as ShopRankingCellItem;
         item.mouseOut();
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         this.removeEvent();
         if(Boolean(this._separator))
         {
            for(i = 0; i < this._separator.length; i++)
            {
               if(Boolean(this._separator[i]))
               {
                  ObjectUtils.disposeObject(this._separator[i]);
               }
               this._separator[i] = null;
            }
         }
         this._separator = null;
         ObjectUtils.disposeObject(this._rankingTitleBg);
         this._rankingTitleBg = null;
         ObjectUtils.disposeObject(this._rankingTitle);
         this._rankingTitle = null;
         ObjectUtils.disposeObject(this._rankingBg);
         this._rankingBg = null;
         ObjectUtils.disposeObject(this._rankingLightMc);
         this._rankingLightMc = null;
         ObjectUtils.disposeObject(this._shopSearchBg);
         this._shopSearchBg = null;
         ObjectUtils.disposeObject(this._rankingBackBg);
         this._rankingBackBg = null;
         ObjectUtils.disposeObject(this._rankingFrontBg);
         this._rankingFrontBg = null;
         ObjectUtils.disposeObject(this._rankingBackBg);
         this._rankingBackBg = null;
         ObjectUtils.disposeObject(this._rankingFrontTexture);
         this._rankingFrontTexture = null;
         ObjectUtils.disposeObject(this._shopSearchBtn);
         this._shopSearchBtn = null;
         ObjectUtils.disposeObject(this._shopSearchText);
         this._shopSearchText = null;
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

