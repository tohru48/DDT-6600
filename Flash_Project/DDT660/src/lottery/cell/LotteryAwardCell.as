package lottery.cell
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import fightLib.view.AwardCell;
   import flash.display.Sprite;
   
   public class LotteryAwardCell extends Sprite implements Disposeable
   {
      
      private var _awardCell:AwardCell;
      
      private var _buffCell:LotteryBuffCell;
      
      public function LotteryAwardCell()
      {
         super();
      }
      
      private function initCell() : void
      {
         this._awardCell = new AwardCell();
         addChild(this._awardCell);
         this._buffCell = new LotteryBuffCell();
         addChild(this._buffCell);
      }
      
      public function setTemplateId(TemplateId:int, args:Object = null) : void
      {
         var info:ItemTemplateInfo = ItemManager.Instance.getTemplateById(TemplateId);
         if(this.isBuffTemplateId(TemplateId))
         {
            this._buffCell.info = info;
         }
      }
      
      private function isBuffTemplateId(TemplateId:int) : Boolean
      {
         return TemplateId == EquipType.PREVENT_KICK || TemplateId == EquipType.DOUBLE_GESTE_CARD || TemplateId == EquipType.DOUBLE_EXP_CARD || TemplateId == EquipType.FREE_PROP_CARD;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._awardCell))
         {
            ObjectUtils.disposeObject(this._awardCell);
         }
         this._awardCell = null;
         if(Boolean(this._buffCell))
         {
            ObjectUtils.disposeObject(this._buffCell);
         }
         this._buffCell = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

