package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ConsBatScoreViewListCell extends Sprite implements Disposeable, IListCell
   {
      
      private var _data:Object;
      
      private var _nameTxt:FilterFrameText;
      
      private var _scoreTxt:FilterFrameText;
      
      public function ConsBatScoreViewListCell()
      {
         super();
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.cellTxt");
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.cellTxt");
         PositionUtils.setPos(this._scoreTxt,"consortiaBattle.scoreView.cellScoreTxtPos");
         addChild(this._nameTxt);
         addChild(this._scoreTxt);
      }
      
      private function update() : void
      {
         var tmpColor:uint = 0;
         this._nameTxt.text = this._data.rank + "." + this._data.name;
         this._scoreTxt.text = this._data.score;
         switch(this._data.rank)
         {
            case 1:
               tmpColor = 16775296;
               break;
            case 2:
               tmpColor = 967126;
               break;
            case 3:
               tmpColor = 1292038;
               break;
            default:
               tmpColor = 16777215;
         }
         this._nameTxt.textColor = tmpColor;
         this._scoreTxt.textColor = tmpColor;
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(value:*) : void
      {
         this._data = value;
         this.update();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._nameTxt = null;
         this._scoreTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

