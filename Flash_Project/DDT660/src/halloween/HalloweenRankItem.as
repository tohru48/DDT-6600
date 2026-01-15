package halloween
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import halloween.info.HalloweenRankInfo;
   import vip.VipController;
   
   public class HalloweenRankItem extends Sprite implements Disposeable
   {
      
      private var _index:int;
      
      private var _bg:Bitmap;
      
      private var indexStr:String;
      
      private var _rank:ScaleFrameImage;
      
      private var _rankTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _numTxt:FilterFrameText;
      
      private var _info:HalloweenRankInfo;
      
      public function HalloweenRankItem(index:int, info:HalloweenRankInfo)
      {
         super();
         this._index = index;
         this._info = info;
         this.initView();
      }
      
      private function initView() : void
      {
         var textFormat:TextFormat = null;
         if(this._index % 2 == 0)
         {
            this._bg = ComponentFactory.Instance.creat("asset.halloween.rank.darkLine");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creat("asset.halloween.rank.lightLine");
         }
         this._rank = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.topThreeRank");
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.rank.numTxt");
         this._numTxt.text = this._info.num;
         switch(this._index)
         {
            case 1:
            case 2:
            case 3:
               this._rank.setFrame(this._index);
               this._rank.visible = true;
               break;
            default:
               this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.rank.itemTxt");
               this._rank.visible = false;
               this.indexStr = String(this._index) + "th";
               this._rankTxt.text = this.indexStr;
         }
         if(this._info.isvip)
         {
            this._vipName = VipController.instance.getVipNameTxt(1,1);
            textFormat = new TextFormat();
            textFormat.align = "center";
            textFormat.bold = true;
            this._vipName.textField.defaultTextFormat = textFormat;
            this._vipName.textSize = 16;
            this._vipName.textField.width = 130;
            this._vipName.x = 72;
            this._vipName.y = 7;
            this._vipName.text = this._info.name;
         }
         else
         {
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.rank.nameTxt");
            this._nameTxt.text = this._info.name;
         }
         addChild(this._bg);
         addChild(this._rank);
         if(Boolean(this._rankTxt))
         {
            addChild(this._rankTxt);
         }
         addChild(this._numTxt);
         if(Boolean(this._vipName))
         {
            addChild(this._vipName);
         }
         if(Boolean(this._nameTxt))
         {
            addChild(this._nameTxt);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._rank);
         this._rank = null;
         ObjectUtils.disposeObject(this._numTxt);
         this._numTxt = null;
         if(Boolean(this._rankTxt))
         {
            ObjectUtils.disposeObject(this._rankTxt);
            this._rankTxt = null;
         }
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
         }
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
         }
      }
   }
}

