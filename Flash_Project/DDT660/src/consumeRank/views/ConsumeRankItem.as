package consumeRank.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consumeRank.data.ConsumeRankVo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import vip.VipController;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.items.PrizeListItem;
   
   public class ConsumeRankItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _topThreeIcon:ScaleFrameImage;
      
      private var _placeTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _numTxt:FilterFrameText;
      
      private var _prizeHBox:HBox;
      
      private var index:int;
      
      private var vo:ConsumeRankVo;
      
      public function ConsumeRankItem(index:int)
      {
         super();
         this.index = index;
         this.initView();
      }
      
      private function initView() : void
      {
         switch(this.index % 2)
         {
            case 0:
               this._bg = ComponentFactory.Instance.creat("wonderfulactivity.itemBg0");
               break;
            case 1:
               this._bg = ComponentFactory.Instance.creat("wonderfulactivity.itemBg1");
         }
         addChild(this._bg);
         this._topThreeIcon = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.topThree");
         addChild(this._topThreeIcon);
         this._topThreeIcon.visible = false;
         this._placeTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.placeTxt");
         this._placeTxt.text = "4th";
         addChild(this._placeTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.nameTxt");
         this._nameTxt.text = "小妹也带刀";
         addChild(this._nameTxt);
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.numTxt");
         this._numTxt.text = "10000";
         addChild(this._numTxt);
         this._prizeHBox = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.hbox");
         addChild(this._prizeHBox);
      }
      
      public function setData(vo:ConsumeRankVo, giftInfo:GiftBagInfo) : void
      {
         var gift:GiftRewardInfo = null;
         var prizeItem:PrizeListItem = null;
         this.vo = vo;
         this.setRankNum(this.index + 1);
         this.addNickName();
         this._numTxt.text = vo.consume.toString();
         if(!giftInfo)
         {
            return;
         }
         var rewardArr:Vector.<GiftRewardInfo> = giftInfo.giftRewardArr;
         for(var i:int = 0; i <= rewardArr.length - 1; i++)
         {
            gift = rewardArr[i];
            prizeItem = new PrizeListItem();
            prizeItem.initView(i);
            prizeItem.setCellData(gift);
            this._prizeHBox.addChild(prizeItem);
         }
      }
      
      private function setRankNum(num:int) : void
      {
         if(num <= 3)
         {
            this._placeTxt.visible = false;
            this._topThreeIcon.visible = true;
            this._topThreeIcon.setFrame(num);
         }
         else
         {
            this._placeTxt.visible = true;
            this._topThreeIcon.visible = false;
            this._placeTxt.text = num + "th";
         }
      }
      
      private function addNickName() : void
      {
         var textFormat:TextFormat = null;
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
            this._vipName = null;
         }
         this._nameTxt.visible = !this.vo.isVIP;
         if(this.vo.isVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(1,1);
            textFormat = new TextFormat();
            textFormat.align = "center";
            textFormat.bold = true;
            this._vipName.textField.defaultTextFormat = textFormat;
            this._vipName.textSize = 16;
            this._vipName.textField.width = this._nameTxt.width;
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this.vo.name;
            addChild(this._vipName);
         }
         else
         {
            this._nameTxt.text = this.vo.name;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
      }
   }
}

