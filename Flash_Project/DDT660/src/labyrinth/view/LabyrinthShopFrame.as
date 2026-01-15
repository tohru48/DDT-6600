package labyrinth.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class LabyrinthShopFrame extends BaseAlerFrame
   {
      
      public static const SHOP_ITEM_NUM:uint = 8;
      
      public static var CURRENT_MONEY_TYPE:int = 1;
      
      private var CURRENT_PAGE:int = 1;
      
      private var _goodItems:Vector.<LabyrinthShopItem>;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _rightItemLightMc:MovieClip;
      
      protected var _goodItemContainerBg:Image;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _currentPageInput:Scale9CornerImage;
      
      private var _navigationBarContainer:Sprite;
      
      private var _coinNumBG:Scale9CornerImage;
      
      private var _coinText:FilterFrameText;
      
      private var _coinNumText:FilterFrameText;
      
      private var _lable:FilterFrameText;
      
      private var othertitleText:FilterFrameText;
      
      public function LabyrinthShopFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         var title:String = null;
         var descript:String = null;
         var coinTxt:String = null;
         var coinNum:String = null;
         var i:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;
         super.init();
         if(BuriedManager.Instance.isOpening)
         {
            title = LanguageMgr.GetTranslation("buried.alertInfo.shopTitle");
            descript = LanguageMgr.GetTranslation("buried.alertInfo.ligthStoneOver.text2");
            coinTxt = LanguageMgr.GetTranslation("buried.alertInfo.LabyrinthShopFrame.text1");
            coinNum = BuriedManager.Instance.getBuriedStoneNum();
         }
         else
         {
            title = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthShopFrame.title");
            descript = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthShopFrame.text2");
            coinTxt = LanguageMgr.GetTranslation("dt.labyrinth.LabyrinthShopFrame.text1");
            coinNum = PlayerManager.Instance.Self.hardCurrency.toString();
         }
         var alerInfo:AlertInfo = new AlertInfo(title,"",LanguageMgr.GetTranslation("tank.calendar.Activity.BackButtonText"),false);
         info = alerInfo;
         this.othertitleText = ComponentFactory.Instance.creatComponentByStylename("FrameTitleTextStyle");
         this.othertitleText.text = title;
         PositionUtils.setPos(this.othertitleText,"dt.labyrinth.LabyrinthFrame.newtitlePos");
         this._goodItems = new Vector.<LabyrinthShopItem>();
         this._rightItemLightMc = ComponentFactory.Instance.creatCustomObject("labyrinth.LabyrinthShopFrame.RightItemLightMc");
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("labyrinth.LabyrinthShopFrame.GoodItemContainerAll");
         this._goodItemContainerBg = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthShopFrame.GoodItemContainerBg");
         this._navigationBarContainer = ComponentFactory.Instance.creatCustomObject("labyrinth.LabyrinthShopFrame.navigationBarContainer");
         this._prePageBtn = UICreatShortcut.creatAndAdd("ddtshop.BtnPrePage",this._navigationBarContainer);
         this._nextPageBtn = UICreatShortcut.creatAndAdd("ddtshop.BtnNextPage",this._navigationBarContainer);
         this._currentPageInput = UICreatShortcut.creatAndAdd("ddtshop.CurrentPageInput",this._navigationBarContainer);
         this._currentPageTxt = UICreatShortcut.creatAndAdd("ddtshop.CurrentPage",this._navigationBarContainer);
         this._coinNumBG = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthShopFrame.coinBG");
         this._coinText = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthShopFrame.coinText");
         this._coinText.text = coinTxt;
         this._coinNumText = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthShopFrame.coinNumText");
         this._coinNumText.text = coinNum;
         this._lable = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthShopFrame.lable");
         this._lable.text = descript;
         addToContent(this.othertitleText);
         addToContent(this._goodItemContainerBg);
         addToContent(this._goodItemContainerAll);
         addToContent(this._navigationBarContainer);
         addToContent(this._coinNumBG);
         addToContent(this._coinText);
         addToContent(this._coinNumText);
         addToContent(this._lable);
         for(i = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i] = ComponentFactory.Instance.creatCustomObject("labyrinth.view.labyrinthShopItem");
            dx = this._goodItems[i].width;
            dy = this._goodItems[i].height;
            dx *= int(i % 2);
            dy *= int(i / 2);
            this._goodItems[i].x = dx;
            this._goodItems[i].y = dy + i / 2 * 2;
            this._goodItemContainerAll.addChild(this._goodItems[i]);
            this._goodItems[i].setItemLight(this._rightItemLightMc);
         }
         this.loadList();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.UpDate_Stone_Count,this.upDateStoneHander);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onUpdate);
      }
      
      private function upDateStoneHander(e:BuriedEvent) : void
      {
         if(BuriedManager.Instance.isOpening)
         {
            this._coinNumText.text = BuriedManager.Instance.getBuriedStoneNum();
         }
      }
      
      public function removeEvent() : void
      {
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.UpDate_Stone_Count,this.upDateStoneHander);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onUpdate);
      }
      
      protected function __onUpdate(event:PlayerPropertyEvent) : void
      {
         if(event.changedProperties["hardCurrency"] == true)
         {
            this._coinNumText.text = PlayerManager.Instance.Self.hardCurrency.toString();
         }
      }
      
      private function clearitems() : void
      {
         for(var i:int = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i].shopItemInfo = null;
         }
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),this.CURRENT_PAGE));
      }
      
      public function setList(list:Vector.<ShopItemInfo>) : void
      {
         this.clearitems();
         for(var i:int = 0; i < SHOP_ITEM_NUM; i++)
         {
            this._goodItems[i].selected = false;
            if(!list)
            {
               break;
            }
            if(i < list.length && Boolean(list[i]))
            {
               this._goodItems[i].shopItemInfo = list[i];
            }
         }
         this._currentPageTxt.text = this.CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType());
      }
      
      private function __pageBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ShopManager.Instance.getResultPages(this.getType()) == 0)
         {
            return;
         }
         switch(evt.currentTarget)
         {
            case this._firstPage:
               if(this.CURRENT_PAGE != 1)
               {
                  this.CURRENT_PAGE = 1;
               }
               break;
            case this._prePageBtn:
               if(this.CURRENT_PAGE == 1)
               {
                  this.CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType()) + 1;
               }
               --this.CURRENT_PAGE;
               break;
            case this._nextPageBtn:
               if(this.CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType()))
               {
                  this.CURRENT_PAGE = 0;
               }
               ++this.CURRENT_PAGE;
               break;
            case this._endPageBtn:
               if(this.CURRENT_PAGE != ShopManager.Instance.getResultPages(this.getType()))
               {
                  this.CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType());
               }
         }
         this.loadList();
      }
      
      public function getType() : int
      {
         return 94;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function disposeItems() : void
      {
         for(var i:int = 0; i < this._goodItems.length; i++)
         {
            ObjectUtils.disposeObject(this._goodItems[i]);
            this._goodItems[i] = null;
         }
         this._goodItems = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
         ObjectUtils.disposeObject(this._rightItemLightMc);
         this._rightItemLightMc = null;
         ObjectUtils.disposeObject(this._goodItemContainerBg);
         this._goodItemContainerBg = null;
         ObjectUtils.disposeObject(this._firstPage);
         this._firstPage = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._endPageBtn);
         this._endPageBtn = null;
         ObjectUtils.disposeObject(this._currentPageTxt);
         this._currentPageTxt = null;
         ObjectUtils.disposeObject(this._currentPageInput);
         this._currentPageInput = null;
         ObjectUtils.disposeObject(this._navigationBarContainer);
         this._navigationBarContainer = null;
         ObjectUtils.disposeObject(this._coinNumBG);
         this._coinNumBG = null;
         ObjectUtils.disposeObject(this._coinText);
         this._coinText = null;
         ObjectUtils.disposeObject(this._coinNumText);
         this._coinNumText = null;
         ObjectUtils.disposeObject(this._lable);
         this._lable = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

