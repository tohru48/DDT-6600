package sevenDayTarget.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class SevenDayTargetRewardCell extends Sprite
   {
      
      protected var _itemName:FilterFrameText;
      
      protected var _itemNum:FilterFrameText;
      
      private var cell:BaseCell;
      
      public function SevenDayTargetRewardCell()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this.cell = new BaseCell(ComponentFactory.Instance.creat("asset.awardSystem.roulette.SelectCellBGAsset"));
         this._itemName = ComponentFactory.Instance.creat("BoxVipTips.ItemName");
         this._itemNum = ComponentFactory.Instance.creat("BoxVipTips.ItemName2");
         PositionUtils.setPos(this.cell,"sevenDayTarget.itemAwardCellPos");
         PositionUtils.setPos(this._itemName,"sevenDayTarget.itemAwardNamePos");
         PositionUtils.setPos(this._itemNum,"sevenDayTarget.itemAwardNumPos");
         addChild(this.cell);
         addChild(this._itemName);
         addChild(this._itemNum);
      }
      
      public function set itemNum(name:String) : void
      {
         this._itemNum.text = name;
      }
      
      public function set itemName(name:String) : void
      {
         this._itemName.text = name;
      }
      
      public function set info(value:ItemTemplateInfo) : void
      {
         this.cell.info = value;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._itemName))
         {
            ObjectUtils.disposeObject(this._itemName);
         }
         this._itemName = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

