package oldPlayerRegress.view.itemView.packs
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   
   public class PacksGiftView extends Frame
   {
      
      private var _packsGiftBgArray:Array;
      
      private var _giftContentList:Vector.<BagCell>;
      
      private var _getGiftData:Vector.<GiftData>;
      
      public function PacksGiftView(giftData:Vector.<GiftData> = null)
      {
         super();
         this.getGiftData = giftData;
         this._init();
      }
      
      private function _init() : void
      {
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._packsGiftBgArray = new Array(new ScaleBitmapImage(),new ScaleBitmapImage(),new ScaleBitmapImage(),new ScaleBitmapImage(),new ScaleBitmapImage(),new ScaleBitmapImage(),new ScaleBitmapImage(),new ScaleBitmapImage());
         this._giftContentList = new Vector.<BagCell>();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var giftCell:BagCell = null;
         for(i = 0; i < this._packsGiftBgArray.length; i++)
         {
            this._packsGiftBgArray[i] = ComponentFactory.Instance.creatComponentByStylename("regress.packstemCellBg");
            if(i > 0)
            {
               this._packsGiftBgArray[i].x = this._packsGiftBgArray[i - 1].x + this._packsGiftBgArray[i - 1].width + 8;
            }
            addChild(this._packsGiftBgArray[i]);
            giftCell = new BagCell(i);
            giftCell.x = this._packsGiftBgArray[i].x;
            giftCell.y = this._packsGiftBgArray[i].y;
            this._giftContentList.push(giftCell);
         }
         this.setGiftInfo();
      }
      
      public function setGoods(id:int) : InventoryItemInfo
      {
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = this.getGiftData[id].giftID;
         info = ItemManager.fill(info);
         info.IsBinds = true;
         return info;
      }
      
      public function setGiftInfo() : void
      {
         for(var i:int = 0; i < this._giftContentList.length; i++)
         {
            if(Boolean(this.getGiftData))
            {
               if(i < this.getGiftData.length)
               {
                  this._giftContentList[i].info = this.setGoods(i);
                  this._giftContentList[i].setCount(this.getGiftData[i].giftCount);
                  addChild(this._giftContentList[i]);
               }
            }
         }
      }
      
      public function removeGiftChild() : void
      {
         var i:int = 0;
         if(Boolean(this.getGiftData))
         {
            i = 0;
            while(i < this.getGiftData.length && i < 8)
            {
               removeChild(this._giftContentList[i]);
               i++;
            }
         }
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      override public function dispose() : void
      {
         var j:int = 0;
         super.dispose();
         this.removeEvent();
         for(var i:int = 0; i < this._packsGiftBgArray.length; i++)
         {
            this._packsGiftBgArray[i] = null;
         }
         if(Boolean(this.getGiftData))
         {
            j = 0;
            while(j < this.getGiftData.length && i < 8)
            {
               this._giftContentList[j] = null;
               j++;
            }
         }
         if(Boolean(this._getGiftData))
         {
            this._getGiftData = null;
         }
      }
      
      public function get getGiftData() : Vector.<GiftData>
      {
         return this._getGiftData;
      }
      
      public function set getGiftData(value:Vector.<GiftData>) : void
      {
         this._getGiftData = value;
      }
   }
}

