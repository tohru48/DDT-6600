package ringStation.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import labyrinth.data.RankingInfo;
   
   public class ArmoryListItem extends Sprite implements Disposeable, IListCell
   {
      
      private var _itemBG:ScaleFrameImage;
      
      private var _ranking:FilterFrameText;
      
      private var _name:FilterFrameText;
      
      private var _fighting:FilterFrameText;
      
      private var _levelIcon:LevelIcon;
      
      private var _info:RankingInfo;
      
      public function ArmoryListItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.armory.List.itemBG");
         addChild(this._itemBG);
         this._ranking = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.armory.List.text1");
         addChild(this._ranking);
         this._name = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.armory.List.text2");
         addChild(this._name);
         this._fighting = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.armory.List.text3");
         addChild(this._fighting);
         this._levelIcon = new LevelIcon();
         PositionUtils.setPos(this._levelIcon,"ringStation.view.armory.listItem.levelPos");
         addChild(this._levelIcon);
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
         this._ranking.text = (index + 1).toString();
         if(index % 2 != 0)
         {
            this._itemBG.setFrame(2);
         }
         else
         {
            this._itemBG.setFrame(1);
         }
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(value:*) : void
      {
         this._info = value as RankingInfo;
         this._name.text = this._info.PlayerName.toString();
         this._levelIcon.setInfo(this._info.FamLevel,0,0,0,0,0,false,false);
         this._fighting.text = this._info.Fighting.toString();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._itemBG))
         {
            ObjectUtils.disposeObject(this._itemBG);
         }
         this._itemBG = null;
         if(Boolean(this._ranking))
         {
            ObjectUtils.disposeObject(this._ranking);
         }
         this._ranking = null;
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._levelIcon))
         {
            ObjectUtils.disposeObject(this._levelIcon);
         }
         this._levelIcon = null;
         if(Boolean(this._fighting))
         {
            ObjectUtils.disposeObject(this._fighting);
         }
         this._fighting = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

