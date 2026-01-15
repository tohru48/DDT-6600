package latentEnergy
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   
   public class LatentEnergyPreTip extends GoodTip
   {
      
      private var _rightArrow:Bitmap;
      
      private var _laterGoodTip:GoodTip;
      
      public function LatentEnergyPreTip()
      {
         super();
      }
      
      override public function set tipData(data:Object) : void
      {
         super.tipData = data;
         if(!data)
         {
            return;
         }
         var tGoodTipInfo:GoodTipInfo = this.getPreGoodTipInfo(data as GoodTipInfo);
         if(!tGoodTipInfo)
         {
            return;
         }
         if(!this._rightArrow)
         {
            this._rightArrow = ComponentFactory.Instance.creatBitmap("asset.latentEnergy.rightArrows");
            this._rightArrow.x = this.width - 10;
            this._rightArrow.y = (this.height - this._rightArrow.height) / 2;
         }
         if(!this._laterGoodTip)
         {
            this._laterGoodTip = new GoodTip();
            this._laterGoodTip.x = _tipbackgound.x + _tipbackgound.width + 35;
         }
         addChild(this._laterGoodTip);
         this._laterGoodTip.tipData = tGoodTipInfo;
         addChild(this._rightArrow);
         _width = this._laterGoodTip.x + this._laterGoodTip.width;
         _height = this._laterGoodTip.height;
      }
      
      protected function getPreGoodTipInfo(goodTipInfo:GoodTipInfo) : GoodTipInfo
      {
         var tmpDate:Date = null;
         var itemInfo:InventoryItemInfo = goodTipInfo.itemInfo as InventoryItemInfo;
         var tGoodTipInfo:GoodTipInfo = new GoodTipInfo();
         var tInfo:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(tInfo,itemInfo);
         tInfo.gemstoneList = itemInfo.gemstoneList;
         tInfo.IsBinds = true;
         var tmpItemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(goodTipInfo.latentEnergyItemId);
         if(!tmpItemInfo)
         {
            return null;
         }
         var valueStr:String = tmpItemInfo.Property3;
         tInfo.latentEnergyCurStr = valueStr + "," + valueStr + "," + valueStr + "," + valueStr;
         if(itemInfo.isHasLatentEnergy)
         {
            tInfo.latentEnergyEndTime = itemInfo.latentEnergyEndTime;
         }
         else
         {
            tmpDate = new Date(TimeManager.Instance.Now().getTime() + int(tmpItemInfo.Property4) * TimeManager.DAY_TICKS - TimeManager.HOUR_TICKS);
            tInfo.latentEnergyEndTime = tmpDate;
         }
         tGoodTipInfo.itemInfo = tInfo;
         return tGoodTipInfo;
      }
   }
}

