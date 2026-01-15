package store.newFusion.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import store.newFusion.data.FusionNewVo;
   
   public class FusionNewMaterialCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _tipTxt:FilterFrameText;
      
      private var _itemCell:BagCell;
      
      private var _itemCountTxt:FilterFrameText;
      
      private var _index:int;
      
      private var _data:FusionNewVo;
      
      private var _needCount:int;
      
      public function FusionNewMaterialCell(index:int)
      {
         super();
         this._index = index;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtstore.GoodPanel");
         PositionUtils.setPos(this._bg,"store.newFusion.rightView.materialBgPos");
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.GoodCellText");
         PositionUtils.setPos(this._tipTxt,"store.newFusion.rightView.materialTipTxtPos");
         this._tipTxt.text = LanguageMgr.GetTranslation("ddt.store.newFusion.rightView.cellTipTxt");
         this._itemCell = new BagCell(1,null,true,null,false);
         this._itemCell.setBgVisible(false);
         PositionUtils.setPos(this._itemCell,"store.newFusion.rightView.materialItemCellPos");
         this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.rightView.cellCountTxt");
         addChild(this._bg);
         addChild(this._tipTxt);
         addChild(this._itemCell);
         addChild(this._itemCountTxt);
      }
      
      public function refreshView(data:FusionNewVo) : void
      {
         this._data = data;
         var itemInfo:ItemTemplateInfo = Boolean(this._data) ? this._data.getItemInfoByIndex(this._index) : null;
         if(!itemInfo)
         {
            this._itemCell.visible = false;
            this._itemCountTxt.visible = false;
         }
         else
         {
            this._itemCell.visible = true;
            this._itemCell.info = itemInfo;
            this._itemCell.x = 20;
            this._itemCell.y = 20;
            this._itemCountTxt.visible = true;
            this._needCount = this._data.getItemNeedCount(this._index);
            this._itemCountTxt.text = this._data.getItemHadCount(this._index) + "/" + this._needCount;
         }
      }
      
      public function refreshCount() : void
      {
         if(Boolean(this._data))
         {
            this._itemCountTxt.text = this._data.getItemHadCount(this._index) + "/" + this._needCount;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._tipTxt = null;
         this._itemCell = null;
         this._itemCountTxt = null;
         this._data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

