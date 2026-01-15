package christmas.view.makingSnowmenView
{
   import bagAndInfo.cell.BagCell;
   import christmas.event.ChristmasRoomEvent;
   import christmas.info.ChristmasSystemItemsInfo;
   import christmas.items.ExpBar;
   import christmas.manager.ChristmasManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import org.aswing.KeyboardManager;
   
   public class ChristmasMakingSnowmenFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _bagitem:BagCell;
      
      private var _selfInfo:SelfInfo = PlayerManager.Instance.Self;
      
      private var _completeText:FilterFrameText;
      
      private var _expBar:ExpBar;
      
      private var _addSnowBnt:BaseButton;
      
      private var _addCountText:FilterFrameText;
      
      private var _activeTimeTxt:FilterFrameText;
      
      private var _conditionTxt:FilterFrameText;
      
      private var _rewardTxt:FilterFrameText;
      
      private var _mSnoRight:ChristmasMakingSnowmenRightFrame;
      
      private var _christmasSnowmenView:ChristmasSnowmenView;
      
      public function ChristmasMakingSnowmenFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initText();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("christmas.makingSnowmenTiTle");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.christmas.makingSnowmenImg");
         this._mSnoRight = ComponentFactory.Instance.creatCustomObject("christmas.makingSnowmen.mSnoRightFrame");
         this._completeText = ComponentFactory.Instance.creatComponentByStylename("christmas.makingSnowmen.completeTxt");
         this._addSnowBnt = ComponentFactory.Instance.creat("christmas.makingSnowmen.addSnowBnt");
         this._expBar = ComponentFactory.Instance.creatComponentByStylename("christmas.makingSnowmen.expBar");
         this._addCountText = ComponentFactory.Instance.creatComponentByStylename("christmas.makingSnowmen.addCountText");
         this._activeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.makingSnowmen.activeTimeTxt");
         this._conditionTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.makingSnowmen.conditionTxt");
         this._rewardTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.makingSnowmen.rewardTxt");
         this._christmasSnowmenView = ComponentFactory.Instance.creatCustomObject("christmas.Snowmen.view");
         addToContent(this._bg);
         addToContent(this._completeText);
         addToContent(this._expBar);
         addToContent(this._addSnowBnt);
         addToContent(this._addCountText);
         addToContent(this._activeTimeTxt);
         addToContent(this._conditionTxt);
         addToContent(this._rewardTxt);
         addToContent(this._christmasSnowmenView);
         addToContent(this._mSnoRight);
         this.goodsCell();
      }
      
      public function get expBar() : ExpBar
      {
         return this._expBar;
      }
      
      private function initText() : void
      {
         this._completeText.text = LanguageMgr.GetTranslation("christmas.makingSnowmen.completeTxt.LG");
         this._addCountText.text = ChristmasManager.instance.model.count + "";
         this._activeTimeTxt.text = ChristmasManager.instance.model.activityTime;
         this._conditionTxt.text = LanguageMgr.GetTranslation("christmas.makingSnowmen.conditionTxt.LG");
         this._rewardTxt.text = LanguageMgr.GetTranslation("christmas.makingSnowmen.rewardTxt.LG");
      }
      
      private function goodsCell() : void
      {
         var christmasInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(201144);
         this._bagitem = new BagCell(0,christmasInfo);
         this._bagitem.x = 30;
         this._bagitem.y = 389;
         this._bagitem.height = 41;
         this._bagitem.width = 41;
         addToContent(this._bagitem);
         this.upDatafitCount();
      }
      
      protected function updateCount(event:BagEvent) : void
      {
         this.upDatafitCount();
      }
      
      public function upDatafitCount() : void
      {
         if(!this._bagitem)
         {
            return;
         }
         var bagInfo:BagInfo = this._selfInfo.getBag(BagInfo.PROPBAG);
         var conut:int = bagInfo.getItemCountByTemplateId(201144);
         this._bagitem.setCount(conut);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._addSnowBnt.addEventListener(MouseEvent.CLICK,this.__onClickAddSnowHander);
         ChristmasManager.instance.addEventListener(ChristmasRoomEvent.SCORE_CONVERT,this.__scoreConvertEventHandler);
      }
      
      private function __onClickAddSnowHander(e:MouseEvent) : void
      {
         ChristmasManager.instance.showTransactionFrame("",this.showIsBuyFrame,null,this,true,true);
      }
      
      private function showIsBuyFrame(num:int = 1) : void
      {
         if(num <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("christmas.curInfo.notfitNum"));
            return;
         }
         if(ChristmasManager.instance.getCount() <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("christmas.curInfo.notfit"));
            return;
         }
         this.sendBuyToSnowPackDouble(num);
      }
      
      private function sendBuyToSnowPackDouble(num:int = 1) : void
      {
         var isDouble:Boolean = ChristmasManager.instance.model.isSelect;
         if(isDouble)
         {
            if(!ChristmasManager.instance.checkMoney(num * ChristmasManager.instance.model.money))
            {
               SocketManager.Instance.out.sendChristmasUpGrade(num,isDouble);
               KeyboardManager.getInstance().isStopDispatching = true;
               SoundManager.instance.play("170");
            }
            ChristmasManager.instance.model.isSelect = false;
            return;
         }
         SocketManager.Instance.out.sendChristmasUpGrade(num,isDouble);
         KeyboardManager.getInstance().isStopDispatching = true;
         SoundManager.instance.play("170");
      }
      
      private function clickCallBack(bool:Boolean) : void
      {
         ChristmasManager.instance.setRemindSnowPackDouble(bool);
      }
      
      private function __scoreConvertEventHandler(event:ChristmasRoomEvent) : void
      {
         var poorNum:int = 0;
         this._addCountText.text = ChristmasManager.instance.model.count + "";
         if(this._mSnoRight.shopItemArr == null)
         {
            return;
         }
         for(var i:int = 0; i < ChristmasManager.instance.model.packsLen - 1; i++)
         {
            if(ChristmasManager.instance.CanGetGift(i) && ChristmasManager.instance.model.count >= this._mSnoRight.shopItemArr[i].snowPackNum)
            {
               this._mSnoRight.shopItemArr[i].specialButton();
            }
         }
         if(ChristmasManager.instance.model.lastPacks > ChristmasManager.instance.model.count)
         {
            this._mSnoRight.shopItemArr[ChristmasManager.instance.model.packsLen - 1].grayButton();
         }
         else
         {
            this._mSnoRight.shopItemArr[ChristmasManager.instance.model.packsLen - 1].specialButton();
            if(ChristmasManager.instance.model.count - ChristmasManager.instance.model.snowPackNum[ChristmasManager.instance.model.packsLen - 2] >= ChristmasManager.instance.model.snowPackNum[ChristmasManager.instance.model.packsLen - 1] * (ChristmasManager.instance.model.packsNumber + 1))
            {
               this._mSnoRight.shopItemArr[ChristmasManager.instance.model.packsLen - 1]._poorTxt.text = LanguageMgr.GetTranslation("christmas.poortTxt.OK.LG");
            }
            else
            {
               poorNum = ChristmasManager.instance.model.snowPackNum[ChristmasManager.instance.model.packsLen - 1] - (ChristmasManager.instance.model.count - (ChristmasManager.instance.model.snowPackNum[ChristmasManager.instance.model.packsLen - 2] + ChristmasManager.instance.model.snowPackNum[ChristmasManager.instance.model.packsLen - 1] * ChristmasManager.instance.model.packsNumber));
               this._mSnoRight.shopItemArr[ChristmasManager.instance.model.packsLen - 1]._poorTxt.text = LanguageMgr.GetTranslation("christmas.list.poorTxt.LG",poorNum);
            }
         }
      }
      
      public function snowmenAction(info:ChristmasSystemItemsInfo) : void
      {
         this._christmasSnowmenView.upGradeAction(info);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._addSnowBnt.removeEventListener(MouseEvent.CLICK,this.__onClickAddSnowHander);
         PlayerManager.Instance.removeEventListener(BagEvent.GEMSTONE_BUG_COUNT,this.updateCount);
         ChristmasManager.instance.removeEventListener(ChristmasRoomEvent.SCORE_CONVERT,this.__scoreConvertEventHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ChristmasManager.instance.model.isSelect = false;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         if(Boolean(this._expBar))
         {
            ObjectUtils.disposeObject(this._expBar);
         }
         this._expBar = null;
         if(Boolean(this._christmasSnowmenView))
         {
            ObjectUtils.disposeObject(this._christmasSnowmenView);
         }
         this._christmasSnowmenView = null;
      }
   }
}

