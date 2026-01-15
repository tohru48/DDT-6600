package cloudBuyLottery.view
{
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class TheWinningLog extends Frame
   {
      
      private var SHOP_ITEM_NUM:int = 9;
      
      private var itemList:Array;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _logArr:Array;
      
      private var _bg:Bitmap;
      
      public function TheWinningLog()
      {
         super();
         this.initView();
         this.loadList();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var item:WinningLogListItem = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.IndividualLottery.dituBG");
         addToContent(this._bg);
         _titleText = LanguageMgr.GetTranslation("TheWinningLog.titleText");
         this._list = ComponentFactory.Instance.creatComponentByStylename("TheWinningLog.goodsListBox");
         this._list.spacing = 0;
         this._panel = ComponentFactory.Instance.creatComponentByStylename("TheWinningLog.right.scrollpanel");
         this._panel.x = 0;
         this._panel.y = -4;
         this._panel.width = 210;
         this._panel.height = 465;
         this.itemList = new Array();
         this._logArr = CloudBuyLotteryManager.Instance.logArr;
         if(this._logArr != null)
         {
            this.SHOP_ITEM_NUM = this._logArr.length;
            if(this.SHOP_ITEM_NUM <= 0)
            {
               return;
            }
            for(i = 0; i < this.SHOP_ITEM_NUM; i++)
            {
               item = ComponentFactory.Instance.creatCustomObject("TheWinningLog.WinningLogListItem");
               this.itemList.push(item);
               this.itemList[i].initView(this._logArr[i].nickName,i);
               this.itemList[i].y = (this.itemList[i].height + 1) * i;
               this._list.addChild(this.itemList[i]);
            }
         }
         this._panel.setView(this._list);
         addToContent(this._panel);
         this._panel.invalidateViewport();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function loadList() : void
      {
         this.setList(CloudBuyLotteryManager.Instance.model.myGiftData);
      }
      
      private function setList(list:Vector.<WinningLogItemInfo>) : void
      {
         if(list == null)
         {
            return;
         }
         this.clearitems();
         for(var i:int = 0; i < this.SHOP_ITEM_NUM; i++)
         {
            if(!list)
            {
               break;
            }
            if(i < list.length && Boolean(list[i]))
            {
               this.itemList[i].shopItemInfo = list[i];
               this.itemList[i].itemID = list[i].TemplateID;
            }
         }
      }
      
      private function clearitems() : void
      {
         var i:int = 0;
         if(this.itemList[i] == null)
         {
            return;
         }
         for(i = 0; i < this.SHOP_ITEM_NUM; i++)
         {
            this.itemList[i].shopItemInfo = null;
         }
      }
      
      private function disposeItems() : void
      {
         var i:int = 0;
         if(Boolean(this.itemList))
         {
            for(i = 0; i < this.itemList.length; i++)
            {
               ObjectUtils.disposeObject(this.itemList[i]);
               this.itemList[i] = null;
            }
            this.itemList = null;
         }
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
         this.disposeItems();
         CloudBuyLotteryFrame.logFrameFlag = false;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

