package yyvip.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class YYVipLevelAwardItemCell extends Sprite implements Disposeable
   {
      
      private var _itemCell:BagCell;
      
      private var _itemCountTxt:FilterFrameText;
      
      public function YYVipLevelAwardItemCell(info:Object)
      {
         super();
         this._itemCell = new BagCell(1,null,true,null,false);
         this._itemCell.setBgVisible(false);
         this._itemCell.info = info.itemInfo;
         this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("yyvip.levelAwardCell.tipTxt");
         this._itemCountTxt.text = "X " + info.itemCount;
         PositionUtils.setPos(this._itemCountTxt,"yyvip.levelAwardCell.itemCellCountTxtPos");
         addChild(this._itemCell);
         addChild(this._itemCountTxt);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._itemCell = null;
         this._itemCountTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

