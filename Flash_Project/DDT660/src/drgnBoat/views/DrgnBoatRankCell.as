package drgnBoat.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import drgnBoat.DrgnBoatManager;
   import flash.display.Sprite;
   
   public class DrgnBoatRankCell extends Sprite implements Disposeable
   {
      
      private var _rankTxt:FilterFrameText;
      
      private var _nameTxt1:FilterFrameText;
      
      private var _nameTxt2:FilterFrameText;
      
      private var _rateTxt:FilterFrameText;
      
      public function DrgnBoatRankCell(index:int)
      {
         super();
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.rankView.cellTxt");
         this._rankTxt.text = (index + 1).toString();
         this._nameTxt1 = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.rankView.cellTxt");
         this._nameTxt1.text = "-------";
         PositionUtils.setPos(this._nameTxt1,"drgnBoat.rankView.cellNameTxtPos");
         this._nameTxt2 = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.rankView.cellNameTxt");
         this._nameTxt2.visible = false;
         this._rateTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.rankView.cellTxt");
         this._rateTxt.text = String(1 + DrgnBoatManager.instance.rankAddInfo[index] / 100);
         PositionUtils.setPos(this._rateTxt,"drgnBoat.rankView.cellRateTxtPos");
         addChild(this._rankTxt);
         addChild(this._nameTxt1);
         addChild(this._nameTxt2);
         addChild(this._rateTxt);
      }
      
      public function setName(name:String, carType:int, isSelf:Boolean) : void
      {
         this._nameTxt2.text = name;
         if(carType == 3)
         {
            this._nameTxt2.textColor = 710173;
         }
         else if(isSelf)
         {
            this._nameTxt2.textColor = 52479;
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
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

