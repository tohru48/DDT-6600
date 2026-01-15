package labyrinth.view
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import labyrinth.LabyrinthManager;
   import labyrinth.data.CleanOutInfo;
   
   public class CleanOutContentItem extends Sprite implements IListCell
   {
      
      private var _expNum:FilterFrameText;
      
      private var _floorNumContent:FilterFrameText;
      
      private var _info:CleanOutInfo;
      
      public function CleanOutContentItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._expNum = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.CleanOutContentItem.expNum","",this);
         this._floorNumContent = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.CleanOutContentItem.floorNumContent","",this);
         var currentFloor:int = LabyrinthManager.Instance.model.currentFloor == 0 ? LabyrinthManager.Instance.model.currentFloor + 1 : LabyrinthManager.Instance.model.currentFloor;
         this._floorNumContent.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutItem.ValueTextII",currentFloor);
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
      }
      
      protected function __updateInfo(event:Event) : void
      {
         this.updateItem();
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(value:*) : void
      {
         this._info = value as CleanOutInfo;
         this.updateItem();
      }
      
      private function updateItem() : void
      {
         var currentFloor:int = 0;
         if(!this._info)
         {
            currentFloor = LabyrinthManager.Instance.model.currentFloor == 0 ? LabyrinthManager.Instance.model.currentFloor + 1 : LabyrinthManager.Instance.model.currentFloor;
            this._floorNumContent.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutItem.ValueTextII",currentFloor);
            this._expNum.text = "";
            return;
         }
         this._expNum.text = LanguageMgr.GetTranslation("tank.fightLib.FightLibAwardView.exp") + this._info.exp.toString();
         this._floorNumContent.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutItem.ValueText",this._info.FamRaidLevel);
         var goodsName:String = "";
         for(var i:int = 0; i < this._info.TemplateIDs.length; i++)
         {
            goodsName += "," + ItemManager.Instance.getTemplateById(this._info.TemplateIDs[i]["TemplateID"]).Name;
            if(this._info.TemplateIDs[i]["num"] != 0)
            {
               goodsName += "x" + this._info.TemplateIDs[i]["num"].toString();
            }
         }
         if(this._info.HardCurrency > 0)
         {
            goodsName += LanguageMgr.GetTranslation("dt.labyrinth.CleanOutContentItem.HardCurrency",this._info.HardCurrency);
         }
         this._expNum.text += goodsName;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
         ObjectUtils.disposeObject(this._expNum);
         this._expNum = null;
         ObjectUtils.disposeObject(this._floorNumContent);
         this._floorNumContent = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

