package sevenDouble.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import sevenDouble.SevenDoubleManager;
   
   public class SevenDoubleRankCell extends Sprite implements Disposeable
   {
      
      private var _rankTxt:FilterFrameText;
      
      private var _nameTxt1:FilterFrameText;
      
      private var _nameTxt2:FilterFrameText;
      
      private var _rateTxt:FilterFrameText;
      
      private var _awardCell:BaseCell;
      
      public function SevenDoubleRankCell(index:int)
      {
         super();
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.rankView.cellTxt");
         this._rankTxt.text = (index + 1).toString();
         this._nameTxt1 = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.rankView.cellTxt");
         PositionUtils.setPos(this._nameTxt1,"sevenDouble.rankView.cellNameTxtPos");
         this._nameTxt2 = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.rankView.cellNameTxt");
         this._nameTxt2.visible = false;
         this._rateTxt = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.rankView.cellTxt");
         this._rateTxt.text = SevenDoubleManager.instance.rankAddInfo[index] + "%";
         PositionUtils.setPos(this._rateTxt,"sevenDouble.rankView.cellRateTxtPos");
         var tmpSprite:Sprite = new Sprite();
         tmpSprite.graphics.beginFill(16711680,0);
         tmpSprite.graphics.drawRect(0,0,30,30);
         tmpSprite.graphics.endFill();
         var tmpItemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(SevenDoubleManager.instance.sprintAwardInfo[index]);
         this._awardCell = new BaseCell(tmpSprite,tmpItemInfo);
         PositionUtils.setPos(this._awardCell,"sevenDouble.rankView.cellAwardCellPos");
         addChild(this._rankTxt);
         addChild(this._nameTxt1);
         addChild(this._nameTxt2);
         addChild(this._rateTxt);
         addChild(this._awardCell);
      }
      
      public function setName(name:String, carType:int) : void
      {
         this._nameTxt2.text = name;
         if(name.length > 10)
         {
            this._nameTxt2.text = name.substr(0,9);
         }
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

