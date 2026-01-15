package escort.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import escort.EscortManager;
   import flash.display.Sprite;
   
   public class EscortRankCell extends Sprite implements Disposeable
   {
      
      private var _rankTxt:FilterFrameText;
      
      private var _nameTxt1:FilterFrameText;
      
      private var _nameTxt2:FilterFrameText;
      
      private var _rateTxt:FilterFrameText;
      
      private var _awardCell:BaseCell;
      
      public function EscortRankCell(index:int)
      {
         super();
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("escort.rankView.cellTxt");
         this._rankTxt.text = (index + 1).toString();
         this._nameTxt1 = ComponentFactory.Instance.creatComponentByStylename("escort.rankView.cellTxt");
         this._nameTxt1.text = "-------";
         PositionUtils.setPos(this._nameTxt1,"escort.rankView.cellNameTxtPos");
         this._nameTxt2 = ComponentFactory.Instance.creatComponentByStylename("escort.rankView.cellNameTxt");
         this._nameTxt2.visible = false;
         this._rateTxt = ComponentFactory.Instance.creatComponentByStylename("escort.rankView.cellTxt");
         this._rateTxt.text = EscortManager.instance.rankAddInfo[index] + "%";
         PositionUtils.setPos(this._rateTxt,"escort.rankView.cellRateTxtPos");
         var tmpSprite:Sprite = new Sprite();
         tmpSprite.graphics.beginFill(16711680,0);
         tmpSprite.graphics.drawRect(0,0,30,30);
         tmpSprite.graphics.endFill();
         var tmpItemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(EscortManager.instance.sprintAwardInfo[index]);
         this._awardCell = new BaseCell(tmpSprite,tmpItemInfo);
         PositionUtils.setPos(this._awardCell,"escort.rankView.cellAwardCellPos");
         addChild(this._rankTxt);
         addChild(this._nameTxt1);
         addChild(this._nameTxt2);
         addChild(this._rateTxt);
         addChild(this._awardCell);
      }
      
      public function setName(name:String, carType:int) : void
      {
         this._nameTxt2.text = name;
         if(carType == 0)
         {
            this._nameTxt2.textColor = 16777215;
         }
         else if(carType == 1)
         {
            this._nameTxt2.textColor = 710173;
         }
         else
         {
            this._nameTxt2.textColor = 16711680;
         }
         this._nameTxt2.visible = true;
         this._nameTxt1.visible = false;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._rankTxt = null;
         this._nameTxt1 = null;
         this._nameTxt2 = null;
         this._rateTxt = null;
         this._awardCell = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

