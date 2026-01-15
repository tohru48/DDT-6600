package yyvip.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class YYVipAwardCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _itemCell:BagCell;
      
      private var _countBg:Bitmap;
      
      private var _itemCountTxt:FilterFrameText;
      
      private var _itemNameTxt:FilterFrameText;
      
      public function YYVipAwardCell(info:Object)
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.yyvip.awardCell.bg");
         this._itemCell = new BagCell(1,null,true,null,false);
         this._itemCell.setBgVisible(false);
         this._itemCell.info = info.itemInfo;
         PositionUtils.setPos(this._itemCell,"yyvip.awardCell.itemCellPos");
         this._countBg = ComponentFactory.Instance.creatBitmap("asset.yyvip.awardCount.bg");
         this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("yyvip.awardCell.itemCountTxt");
         this._itemCountTxt.text = info.itemCount;
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("yyvip.awardCell.itemNameTxt");
         this._itemNameTxt.text = info.itemInfo.Name;
         addChild(this._bg);
         addChild(this._itemCell);
         addChild(this._countBg);
         addChild(this._itemCountTxt);
         addChild(this._itemNameTxt);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._itemCell = null;
         this._countBg = null;
         this._itemCountTxt = null;
         this._itemNameTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

