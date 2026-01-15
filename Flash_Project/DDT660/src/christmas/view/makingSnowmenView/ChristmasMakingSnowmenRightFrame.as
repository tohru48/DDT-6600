package christmas.view.makingSnowmenView
{
   import christmas.info.ChristmasSystemItemsInfo;
   import christmas.items.ChristmasListItem;
   import christmas.manager.ChristmasManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import road7th.comm.PackageIn;
   
   public class ChristmasMakingSnowmenRightFrame extends Sprite implements Disposeable
   {
      
      public static var packsReceiveOK:Boolean;
      
      public static var specialItemId:int = 201156;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Array;
      
      private var SHOP_ITEM_NUM:int = 9;
      
      private var CURRENT_PAGE:int = 1;
      
      private var _shopItemArr:Array;
      
      public function ChristmasMakingSnowmenRightFrame()
      {
         super();
         this.initView();
         this.loadList();
         this.initEvent();
      }
      
      public function get shopItemArr() : Array
      {
         return this._shopItemArr;
      }
      
      public function set itemList(value:Array) : void
      {
         this._itemList = value;
      }
      
      public function get itemList() : Array
      {
         return this._itemList;
      }
      
      private function initView() : void
      {
         var item:ChristmasListItem = null;
         var poorNum:int = 0;
         this._list = ComponentFactory.Instance.creatComponentByStylename("christmas.goodsListBox");
         this._list.spacing = 5;
         this._panel = ComponentFactory.Instance.creatComponentByStylename("christmas.right.scrollpanel");
         this._panel.x = 286;
         this._panel.y = 133;
         this._panel.width = 400;
         this._panel.height = 260;
         this._shopItemArr = new Array();
         this.SHOP_ITEM_NUM = ChristmasManager.instance.model.packsLen;
         this.itemList = new Array();
         for(var i:int = 0; i < this.SHOP_ITEM_NUM; i++)
         {
            item = ComponentFactory.Instance.creatCustomObject("christmas.view.christmasShopItem");
            this.itemList.push(item);
            this.itemList[i].initView(i);
            if(i <= this.SHOP_ITEM_NUM - 2)
            {
               if(ChristmasManager.instance.CanGetGift(i) && ChristmasManager.instance.model.count >= ChristmasManager.instance.model.snowPackNum[i])
               {
                  this.itemList[i].specialButton();
               }
            }
            else if(ChristmasManager.instance.model.lastPacks > ChristmasManager.instance.model.count)
            {
               this.itemList[i].grayButton();
            }
            else
            {
               this.itemList[i].specialButton();
               if(ChristmasManager.instance.model.count - ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 2] >= ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] * (ChristmasManager.instance.model.packsNumber + 1))
               {
                  this.itemList[i]._poorTxt.text = LanguageMgr.GetTranslation("christmas.poortTxt.OK.LG");
               }
               else
               {
                  poorNum = ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] - (ChristmasManager.instance.model.count - (ChristmasManager.instance.model.snowPackNum[ChristmasManager.instance.model.packsLen - 2] + ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] * ChristmasManager.instance.model.packsNumber));
                  this.itemList[i]._poorTxt.text = LanguageMgr.GetTranslation("christmas.list.poorTxt.LG",poorNum);
               }
            }
            this.itemList[i].initText(ChristmasManager.instance.model.snowPackNum[i],i);
            this.itemList[i].y = (this.itemList[i].height + 1) * i;
            this._shopItemArr.push(this.itemList[i]);
            this._list.addChild(this.itemList[i]);
         }
         this._panel.setView(this._list);
         addChild(this._panel);
         this._panel.invalidateViewport();
      }
      
      public function loadList() : void
      {
         this.setList(ChristmasManager.instance.model.myGiftData);
      }
      
      public function setList(list:Vector.<ChristmasSystemItemsInfo>) : void
      {
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
      
      private function initEvent() : void
      {
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.CHRISTMAS_PACKS,this.playerIsReceivePacks);
      }
      
      private function playerIsReceivePacks(event:CrazyTankSocketEvent) : void
      {
         var poorNum:int = 0;
         var pkg:PackageIn = event.pkg;
         ChristmasManager.instance.model.awardState = pkg.readInt();
         ChristmasManager.instance.model.packsNumber = pkg.readInt();
         var listItemId:int = pkg.readInt();
         for(var i:int = 0; i < this.SHOP_ITEM_NUM; i++)
         {
            if(this.itemList[i].itemID == listItemId && i < this.SHOP_ITEM_NUM - 1)
            {
               this.itemList[i].receiveOK();
               packsReceiveOK = true;
               break;
            }
            if(this.itemList[i].itemID == specialItemId && ChristmasManager.instance.model.lastPacks <= ChristmasManager.instance.model.count)
            {
               this.itemList[i].specialButton();
               if(ChristmasManager.instance.model.count - ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 2] >= ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] * (ChristmasManager.instance.model.packsNumber + 1))
               {
                  this.itemList[i]._poorTxt.text = LanguageMgr.GetTranslation("christmas.poortTxt.OK.LG");
               }
               else
               {
                  poorNum = ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] - (ChristmasManager.instance.model.count - (ChristmasManager.instance.model.snowPackNum[ChristmasManager.instance.model.packsLen - 2] + ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] * ChristmasManager.instance.model.packsNumber));
                  this.itemList[i]._poorTxt.text = LanguageMgr.GetTranslation("christmas.list.poorTxt.LG",poorNum);
               }
            }
         }
      }
      
      private function clearitems() : void
      {
         for(var i:int = 0; i < this.SHOP_ITEM_NUM; i++)
         {
            this.itemList[i].shopItemInfo = null;
         }
      }
      
      private function removeEvent() : void
      {
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.CHRISTMAS_PACKS,this.playerIsReceivePacks);
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
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         ObjectUtils.disposeAllChildren(this._list);
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeAllChildren(this._panel);
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

