package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   
   public class AwardsGoodsList extends Sprite implements Disposeable
   {
      
      private var _goodsList:Array;
      
      private var _list:SimpleTileList;
      
      private var panel:ScrollPanel;
      
      private var _cells:Array;
      
      public function AwardsGoodsList()
      {
         super();
         this.initList();
      }
      
      protected function initList() : void
      {
         this._list = new SimpleTileList(2);
         this._list.vSpace = 6;
         this._list.hSpace = 110;
         this.panel = ComponentFactory.Instance.creat("TimeBoxScrollpanel");
         addChild(this.panel);
      }
      
      public function show(goodsList:Array) : void
      {
         var _itemTempleteInfo:ItemTemplateInfo = null;
         var _count:int = 0;
         var info:InventoryItemInfo = null;
         var cell:BoxAwardsCell = null;
         var boxGoodsInfo:BoxGoodsTempInfo = null;
         this._goodsList = goodsList;
         this._cells = new Array();
         this._list.beginChanges();
         for(var i:int = 0; i < this._goodsList.length; i++)
         {
            _count = 0;
            if(this._goodsList[i] is InventoryItemInfo)
            {
               info = this._goodsList[i];
               info.IsJudge = true;
            }
            else if(this._goodsList[i] is BoxGoodsTempInfo)
            {
               boxGoodsInfo = this._goodsList[i] as BoxGoodsTempInfo;
               info = this.getTemplateInfo(boxGoodsInfo.TemplateId) as InventoryItemInfo;
               info.IsBinds = boxGoodsInfo.IsBind;
               info.LuckCompose = boxGoodsInfo.LuckCompose;
               info.DefendCompose = boxGoodsInfo.DefendCompose;
               info.AttackCompose = boxGoodsInfo.AttackCompose;
               info.AgilityCompose = boxGoodsInfo.AgilityCompose;
               info.StrengthenLevel = boxGoodsInfo.StrengthenLevel;
               info.ValidDate = boxGoodsInfo.ItemValid;
               info.IsJudge = true;
               info.Count = boxGoodsInfo.ItemCount;
            }
            else if(this._goodsList[i] is ItemTemplateInfo)
            {
               _itemTempleteInfo = this._goodsList[i] as ItemTemplateInfo;
            }
            else
            {
               _itemTempleteInfo = this._goodsList[i].info;
               _count = int(this._goodsList[i].count);
            }
            if(info != null)
            {
               _itemTempleteInfo = info;
            }
            cell = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
            cell.info = _itemTempleteInfo;
            if(_itemTempleteInfo.hasOwnProperty("Count"))
            {
               cell.count = _itemTempleteInfo["Count"];
            }
            else if(_count > 0)
            {
               cell.count = _count;
            }
            else
            {
               cell.count = 1;
            }
            this._list.addChild(cell);
            this._cells.push(cell);
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = this._goodsList.length > 6 ? ScrollPanel.ON : ScrollPanel.OFF;
         this.panel.commitChanges();
      }
      
      public function showForVipAward(infoList:Array) : void
      {
         var i:int = 0;
         var cell:BoxAwardsCell = null;
         this._goodsList = infoList;
         this._cells = new Array();
         this._list.dispose();
         this._list = new SimpleTileList(3);
         this._list.vSpace = 6;
         this._list.hSpace = 110;
         this._list.beginChanges();
         for(i = 0; i < this._goodsList.length; i++)
         {
            cell = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
            cell.mouseChildren = false;
            cell.mouseEnabled = false;
            if(Boolean(this._goodsList[i]))
            {
               cell.info = ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[i]).TemplateId);
               cell.count = 1;
               cell.itemName = ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[i]).TemplateId).Name + "X" + String(BoxGoodsTempInfo(this._goodsList[i]).ItemCount);
               this._list.addChild(cell);
               this._cells.push(cell);
            }
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.width = 500;
         this.panel.height = 178;
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.OFF;
         this.panel.commitChanges();
      }
      
      private function getTemplateInfo(id:int) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = id;
         ItemManager.fill(itemInfo);
         return itemInfo;
      }
      
      public function dispose() : void
      {
         var cell:BoxAwardsCell = null;
         for each(cell in this._cells)
         {
            cell.dispose();
         }
         this._cells.splice(0,this._cells.length);
         this._cells = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this.panel))
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

