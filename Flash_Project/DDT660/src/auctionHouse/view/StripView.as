package auctionHouse.view
{
   import auctionHouse.AuctionState;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   [Event(name="selectStrip",type="auctionHouse.event.AuctionHouseEvent")]
   public class StripView extends BaseStripView implements IListCell
   {
      
      private var _seller:FilterFrameText;
      
      private var _lef:Sprite;
      
      private var _curPrice:StripCurPriceView;
      
      private var _vieTip:StripTip;
      
      private var _lefTip:StripTip;
      
      public function StripView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._seller = ComponentFactory.Instance.creat("auctionHouse.BaseStripSeller");
         addChild(this._seller);
         var _vie:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.StripIocnAsset");
         this._vieTip = ComponentFactory.Instance.creat("auctionHouse.view.StripIocn");
         this._vieTip.setView(_vie);
         this._vieTip.tipData = LanguageMgr.GetTranslation("tank.auctionHouse.view.auctioned");
         addChildAt(this._vieTip,getChildIndex(_leftTime) + 1);
         this._vieTip.visible = false;
         this._lef = this.drawRect(_leftTime.textWidth,_leftTime.textHeight);
         this._lef.alpha = 0;
         this._lefTip = ComponentFactory.Instance.creat("auctionHouse.view.StripLeftTime");
         this._lefTip.setView(this._lef);
         addChild(this._lefTip);
         this._curPrice = ComponentFactory.Instance.creat("auctionHouse.view.StripCurPriceView");
         addChild(this._curPrice);
         buttonMode = true;
      }
      
      private function drawRect(w:Number, h:Number) : Sprite
      {
         var sprite:Sprite = new Sprite();
         sprite.graphics.beginFill(16777215);
         sprite.graphics.drawRect(0,0,w,h);
         sprite.graphics.endFill();
         return sprite;
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
         isSelect = isSelected;
      }
      
      public function getCellValue() : *
      {
         return _info;
      }
      
      public function setCellValue(value:*) : void
      {
         info = value;
      }
      
      override protected function updateInfo() : void
      {
         var newStr:String = null;
         super.updateInfo();
         var str:String = (_info.Price / _info.BagItemInfo.Count).toString();
         var arr:Array = str.split(".");
         if(Boolean(arr[1]))
         {
            newStr = arr[0] + "." + arr[1].charAt(0);
         }
         else
         {
            newStr = str;
         }
         if(AuctionState.CURRENTSTATE == AuctionState.SELL)
         {
            if(_info.BuyerName == "")
            {
               this._seller.text = newStr;
            }
            else
            {
               this._seller.text = newStr;
            }
         }
         else
         {
            this._seller.text = newStr;
            this._vieTip.visible = _info.BuyerName != "";
         }
         this._lef.width = this._lefTip.width = _leftTime.textWidth;
         this._lef.height = this._lefTip.height = _leftTime.textHeight;
         this._curPrice.info = _info;
         ShowTipManager.Instance.removeCurrentTip();
         this._lefTip.tipData = _info.getSithTimeDescription();
         this.mouseEnabled = true;
      }
      
      override internal function clearSelectStrip() : void
      {
         super.clearSelectStrip();
         this._seller.text = "";
         if(Boolean(this._curPrice) && Boolean(this._curPrice.parent))
         {
            this._curPrice.parent.removeChild(this._curPrice);
         }
         if(Boolean(this._vieTip) && Boolean(this._vieTip.parent))
         {
            this._vieTip.parent.removeChild(this._vieTip);
         }
         this.mouseEnabled = false;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._seller))
         {
            ObjectUtils.disposeObject(this._seller);
         }
         this._seller = null;
         if(Boolean(this._vieTip))
         {
            ObjectUtils.disposeObject(this._vieTip);
         }
         this._vieTip = null;
         if(Boolean(this._lef))
         {
            ObjectUtils.disposeObject(this._lef);
         }
         this._lef = null;
         if(Boolean(this._curPrice))
         {
            ObjectUtils.disposeObject(this._curPrice);
         }
         this._curPrice = null;
         if(Boolean(this._lefTip))
         {
            ObjectUtils.disposeObject(this._lefTip);
         }
         this._lefTip = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

