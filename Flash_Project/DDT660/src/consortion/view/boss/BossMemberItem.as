package consortion.view.boss
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaBossDataVo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import vip.VipController;
   
   public class BossMemberItem extends Sprite implements Disposeable
   {
      
      private var _rankTxt:FilterFrameText;
      
      private var _rankIconList:Vector.<Bitmap>;
      
      private var _nameTxt:FilterFrameText;
      
      private var _nameFirstTxt:GradientText;
      
      private var _damageTxt:FilterFrameText;
      
      private var _contributionTxt:FilterFrameText;
      
      private var _honorTxt:FilterFrameText;
      
      public function BossMemberItem()
      {
         var rankIcon:Bitmap = null;
         super();
         this._rankIconList = new Vector.<Bitmap>(3);
         for(var i:int = 0; i < 3; i++)
         {
            rankIcon = ComponentFactory.Instance.creatBitmap("asset.consortionBossFrame.cellRankth" + (i + 1));
            addChild(rankIcon);
            this._rankIconList[i] = rankIcon;
         }
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.rankTxt");
         addChild(this._rankTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.nameTxt");
         addChild(this._nameTxt);
         this._nameFirstTxt = VipController.instance.getVipNameTxt(105,1);
         var textFormat:TextFormat = new TextFormat();
         textFormat.align = "center";
         textFormat.bold = true;
         this._nameFirstTxt.textField.defaultTextFormat = textFormat;
         this._nameFirstTxt.textSize = 14;
         this._nameFirstTxt.x = this._nameTxt.x + 2;
         this._nameFirstTxt.y = this._nameTxt.y;
         addChild(this._nameFirstTxt);
         this._damageTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.damageTxt");
         addChild(this._damageTxt);
         this._contributionTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.contributionTxt");
         addChild(this._contributionTxt);
         this._honorTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.honorTxt");
         addChild(this._honorTxt);
      }
      
      public function set info(info:ConsortiaBossDataVo) : void
      {
         if(!info)
         {
            return;
         }
         var rank:int = info.rank;
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
         if(rank == 1)
         {
            this._nameTxt.visible = false;
            this._nameFirstTxt.text = info.name;
            this._nameFirstTxt.visible = true;
         }
         else
         {
            this._nameFirstTxt.visible = false;
            this._nameTxt.text = info.name;
            this._nameTxt.visible = true;
         }
         this._damageTxt.text = info.damage.toString();
         this._contributionTxt.text = info.contribution.toString();
         this._honorTxt.text = info.honor.toString();
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
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._rankTxt = null;
         this._rankIconList = null;
         this._nameTxt = null;
         this._nameFirstTxt = null;
         this._damageTxt = null;
         this._contributionTxt = null;
         this._honorTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

