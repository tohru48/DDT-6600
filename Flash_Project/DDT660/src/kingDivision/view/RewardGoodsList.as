package kingDivision.view
{
   import com.pickgliss.ui.controls.container.HBox;
   import kingDivision.KingDivisionManager;
   
   public class RewardGoodsList extends HBox
   {
      
      private var _currentItem:RewardGoodsListItem;
      
      private var items:Vector.<RewardGoodsListItem>;
      
      private var _zone:int;
      
      private var _goodsArr:Array;
      
      public function RewardGoodsList()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         spacing = 3;
      }
      
      public function setGoodsListItem(index:int) : void
      {
         var i:int = 0;
         this._goodsArr = KingDivisionManager.Instance.model.getLevelGoodsItems(index);
         this.items = new Vector.<RewardGoodsListItem>(this._goodsArr.length);
         for(i = 0; i < this._goodsArr.length; i++)
         {
            this.items[i] = new RewardGoodsListItem();
            this.items[i].buttonMode = true;
            this.items[i].goodsInfo(this._goodsArr[i].TemplateID,this._goodsArr[i].AttackCompose,this._goodsArr[i].DefendCompose,this._goodsArr[i].AgilityCompose,this._goodsArr[i].LuckCompose,this._goodsArr[i].Count,this._goodsArr[i].IsBind,this._goodsArr[i].ValidDate);
            addChild(this.items[i]);
         }
      }
   }
}

