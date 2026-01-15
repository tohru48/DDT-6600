package dragonBoat.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import vip.VipController;
   
   public class DragonBoatSelfRankItem extends Sprite implements Disposeable, IListCell
   {
      
      private var _data:Object;
      
      private var _rankIconList:Vector.<Bitmap>;
      
      private var _rankTxt:FilterFrameText;
      
      private var _nameTxt:GradientText;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _awardHbox:Sprite;
      
      private var _awardList:Vector.<BagCell>;
      
      private var _awardHboxPos:Point;
      
      public function DragonBoatSelfRankItem()
      {
         var rankIcon:Bitmap = null;
         super();
         this._awardList = new Vector.<BagCell>();
         this._rankIconList = new Vector.<Bitmap>(3);
         for(var i:int = 0; i < 3; i++)
         {
            rankIcon = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.cellRankth" + (i + 1));
            addChild(rankIcon);
            this._rankIconList[i] = rankIcon;
         }
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.cell.rankTxt");
         this._nameTxt = VipController.instance.getVipNameTxt(130,1);
         var textFormat:TextFormat = new TextFormat();
         textFormat.align = "center";
         textFormat.bold = true;
         this._nameTxt.textField.defaultTextFormat = textFormat;
         this._nameTxt.textSize = 14;
         PositionUtils.setPos(this._nameTxt,"dragonBoat.mainFrame.cell.nameTxtPos");
         addChild(this._nameTxt);
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.cell.scoreTxt");
         this._awardHboxPos = ComponentFactory.Instance.creatCustomObject("dragonBoat.shopFrame.cellAwardSelfPos");
         this._awardHbox = new Sprite();
         this._awardHbox.y = this._awardHboxPos.y;
         addChild(this._rankTxt);
         addChild(this._nameTxt);
         addChild(this._scoreTxt);
         addChild(this._awardHbox);
      }
      
      private function clearAwardCell() : void
      {
         var _bagCell:BagCell = null;
         for each(_bagCell in this._awardList)
         {
            _bagCell.info = null;
         }
      }
      
      private function updateAwardCell($index:int, $info:ItemTemplateInfo) : void
      {
         var _awardCell:BagCell = null;
         _awardCell = null;
         if($index > this._awardList.length - 1)
         {
            _awardCell = new BagCell(1,$info,true,null,false);
            _awardCell.tipGapH = 0;
            _awardCell.tipGapV = 0;
            _awardCell.scaleX = 0.6;
            _awardCell.scaleY = 0.6;
         }
         else
         {
            _awardCell = this._awardList[$index];
         }
         _awardCell.info = $info;
         _awardCell.x = this._awardHbox.width + 5;
         this._awardHbox.addChild(_awardCell);
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(value:*) : void
      {
         var _itemInfo:InventoryItemInfo = null;
         this._data = value;
         var rank:int = int(this._data.rank);
         this.setRankIconVisible(rank);
         if(rank >= 1 && rank <= 3)
         {
            this._rankTxt.visible = false;
         }
         else
         {
            this._rankTxt.text = rank + "th";
            this._rankTxt.visible = true;
         }
         this._nameTxt.text = this._data.name;
         this._scoreTxt.text = this._data.score;
         if(Boolean(this._awardHbox))
         {
            while(this._awardHbox.numChildren > 0)
            {
               this._awardHbox.removeChild(this._awardHbox.getChildAt(0));
            }
         }
         this.clearAwardCell();
         for(var i:int = 0; i < this._data.itemInfoArr.length; i++)
         {
            _itemInfo = this._data.itemInfoArr[i] as InventoryItemInfo;
            this.updateAwardCell(i,_itemInfo);
         }
         this._awardHbox.x = this._awardHboxPos.x + (120 - this._awardHbox.width) / 2;
      }
      
      private function setRankIconVisible(rank:int) : void
      {
         var len:int = int(this._rankIconList.length);
         for(var i:int = 1; i <= len; i++)
         {
            if(rank == i)
            {
               this._rankIconList[i - 1].visible = true;
            }
            else
            {
               this._rankIconList[i - 1].visible = false;
            }
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._awardHbox))
         {
            ObjectUtils.disposeAllChildren(this._awardHbox);
            this._awardHbox = null;
         }
         this._awardHboxPos = null;
         this._awardList = null;
         ObjectUtils.disposeAllChildren(this);
         this._data = null;
         this._rankIconList = null;
         this._rankTxt = null;
         this._nameTxt = null;
         this._scoreTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

