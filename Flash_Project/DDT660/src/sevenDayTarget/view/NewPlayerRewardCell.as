package sevenDayTarget.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class NewPlayerRewardCell extends Sprite
   {
      
      protected var _itemNum:FilterFrameText;
      
      private var cell:BaseCell;
      
      public function NewPlayerRewardCell()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this.cell = new BaseCell(ComponentFactory.Instance.creat("newPlayerReward.rewardItemBg"));
         this._itemNum = ComponentFactory.Instance.creat("BoxVipTips.ItemName3");
         PositionUtils.setPos(this.cell,"sevenDayTarget.itemAwardCellPos");
         PositionUtils.setPos(this._itemNum,"sevenDayTarget.itemAwardNumPos");
         addChild(this.cell);
         addChild(this._itemNum);
      }
      
      public function set info(value:ItemTemplateInfo) : void
      {
         this.cell.info = value;
      }
      
      public function set itemNum(name:String) : void
      {
         this._itemNum.text = name;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._itemNum))
         {
            ObjectUtils.disposeObject(this._itemNum);
         }
         this._itemNum = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

