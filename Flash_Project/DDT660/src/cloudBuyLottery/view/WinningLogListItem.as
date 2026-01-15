package cloudBuyLottery.view
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import shop.view.ShopItemCell;
   
   public class WinningLogListItem extends Sprite implements Disposeable
   {
      
      private var _itemCell:ShopItemCell;
      
      private var _shopItemInfo:WinningLogItemInfo;
      
      private var _itemID:int;
      
      private var _bg:Bitmap;
      
      private var _cellImg:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _txt:FilterFrameText;
      
      public function WinningLogListItem()
      {
         super();
      }
      
      public function initView(name:String, index:int = 0) : void
      {
         if(++index % 2 == 0)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.IndividualLottery.cellBg");
            addChild(this._bg);
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("WinningLogListItem.nameTxt");
         this._nameTxt.text = name;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("WinningLogListItem.txt");
         this._txt.text = LanguageMgr.GetTranslation("WinningLogListItem.txt.LG");
         this._cellImg = ComponentFactory.Instance.creatBitmap("asset.IndividualLottery.goodsCell");
         this._itemCell = this.creatItemCell();
         this._itemCell.buttonMode = true;
         this._itemCell.cellSize = 46;
         PositionUtils.setPos(this._itemCell,"WinningLogListItem.cellPos");
         addChild(this._cellImg);
         addChild(this._itemCell);
         addChild(this._nameTxt);
         addChild(this._txt);
      }
      
      protected function creatItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,46,46);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      public function set shopItemInfo(value:WinningLogItemInfo) : void
      {
         var tInfo:InventoryItemInfo = null;
         if(Boolean(this._shopItemInfo))
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         this._shopItemInfo = value;
         if(Boolean(this._shopItemInfo))
         {
            tInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(tInfo,this._shopItemInfo.TemplateInfo);
            tInfo.ValidDate = this._shopItemInfo.validate;
            tInfo.StrengthenLevel = this._shopItemInfo.property[0];
            tInfo.AttackCompose = this._shopItemInfo.property[1];
            tInfo.DefendCompose = this._shopItemInfo.property[2];
            tInfo.LuckCompose = this._shopItemInfo.property[3];
            tInfo.AgilityCompose = this._shopItemInfo.property[4];
            tInfo.IsBinds = true;
            this._itemID = this._shopItemInfo.TemplateID;
            this._itemCell.info = tInfo;
            this._itemCell.buttonMode = true;
            this._shopItemInfo.addEventListener(Event.CHANGE,this.__updateShopItem);
         }
         else
         {
            this._itemCell.info = null;
            this._itemCell.buttonMode = false;
         }
      }
      
      private function __updateShopItem(event:Event) : void
      {
         this._itemCell.info = this._shopItemInfo.TemplateInfo;
      }
      
      public function get itemID() : int
      {
         return this._itemID;
      }
      
      public function set itemID(value:int) : void
      {
         this._itemID = value;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         this._shopItemInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

