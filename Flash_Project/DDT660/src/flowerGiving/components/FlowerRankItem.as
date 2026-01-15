package flowerGiving.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import flowerGiving.data.FlowerRankInfo;
   import vip.VipController;
   import wonderfulActivity.data.GiftRewardInfo;
   
   public class FlowerRankItem extends Sprite implements Disposeable
   {
      
      private var _sprite:Sprite;
      
      private var _backOverBit:Bitmap;
      
      private var _topThreeIcon:ScaleFrameImage;
      
      private var _placeTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _numTxt:FilterFrameText;
      
      private var _baseIcon:Image;
      
      private var _superIcon:Image;
      
      private var _info:FlowerRankInfo;
      
      private var _baseTip:GoodTipInfo;
      
      private var _superTip:GoodTipInfo;
      
      public function FlowerRankItem()
      {
         super();
         this.initData();
         this.initView();
         this.addEvents();
      }
      
      private function initData() : void
      {
         this._baseTip = new GoodTipInfo();
         var info:ItemTemplateInfo = new ItemTemplateInfo();
         info.Quality = 4;
         info.CategoryID = 11;
         info.Name = LanguageMgr.GetTranslation("tank.flowerGiving.rankViewItemBaseGift");
         info.Description = "";
         this._baseTip.itemInfo = info;
         this._superTip = new GoodTipInfo();
         var info2:ItemTemplateInfo = new ItemTemplateInfo();
         info2.Quality = 4;
         info2.CategoryID = 11;
         info2.Name = LanguageMgr.GetTranslation("tank.flowerGiving.rankViewItemSuperGift");
         info2.Description = "";
         this._superTip.itemInfo = info2;
      }
      
      private function initView() : void
      {
         this._backOverBit = ComponentFactory.Instance.creat("flowerGiving.rankView.mouseOver");
         this._backOverBit.visible = false;
         this._sprite = new Sprite();
         this._sprite.graphics.beginFill(0,0);
         this._sprite.graphics.drawRect(0,0,this._backOverBit.width,this._backOverBit.height);
         this._sprite.graphics.endFill();
         this._sprite.x = this._backOverBit.x;
         this._sprite.y = this._backOverBit.y;
         addChild(this._sprite);
         this._topThreeIcon = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.topThree");
         addChild(this._topThreeIcon);
         this._topThreeIcon.visible = false;
         this._placeTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.rankVeiw.placeTxt");
         this._placeTxt.text = "4th";
         addChild(this._placeTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.rankVeiw.nameTxt");
         this._nameTxt.text = "";
         addChild(this._nameTxt);
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.rankVeiw.numTxt");
         this._numTxt.text = "10000";
         addChild(this._numTxt);
         this._baseIcon = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.rewardSmallIcon");
         PositionUtils.setPos(this._baseIcon,"flowerGiving.baseIconPos");
         this._baseIcon.tipStyle = "core.GoodsTip";
         this._baseIcon.tipDirctions = "1,3";
         this._baseIcon.tipData = this._baseTip;
         addChild(this._baseIcon);
         this._superIcon = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.rewardSmallIcon");
         PositionUtils.setPos(this._superIcon,"flowerGiving.superIconPos");
         this._superIcon.tipStyle = "core.GoodsTip";
         this._superIcon.tipDirctions = "1,3";
         this._superIcon.tipData = this._superTip;
         addChild(this._superIcon);
         addChild(this._backOverBit);
      }
      
      private function addEvents() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__onOverHanlder);
         addEventListener(MouseEvent.ROLL_OUT,this.__onOutHandler);
      }
      
      protected function __onOutHandler(event:MouseEvent) : void
      {
         this._backOverBit.visible = false;
      }
      
      protected function __onOverHanlder(event:MouseEvent) : void
      {
         this._backOverBit.visible = true;
      }
      
      public function set info(info:FlowerRankInfo) : void
      {
         this._info = info;
         this.setRankNum(this._info.place);
         this.addNickName();
         this._numTxt.text = this._info.num + "";
         this.addTips();
      }
      
      private function addNickName() : void
      {
         var textFormat:TextFormat = null;
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
            this._vipName = null;
         }
         this._nameTxt.visible = !this._info.isVIP;
         if(this._info.isVIP)
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
            this._vipName.text = this._info.name;
            addChild(this._vipName);
         }
         else
         {
            this._nameTxt.text = this._info.name;
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
      
      private function addTips() : void
      {
         var rewardInfo:GiftRewardInfo = null;
         var item:InventoryItemInfo = null;
         this._baseTip.itemInfo.Description = "";
         this._superTip.itemInfo.Description = "";
         for(var i:int = 0; i <= this._info.rewardVec.length - 1; i++)
         {
            rewardInfo = this._info.rewardVec[i];
            item = new InventoryItemInfo();
            item.TemplateID = rewardInfo.templateId;
            ItemManager.fill(item);
            if(rewardInfo.rewardType == 0)
            {
               if(this._baseTip.itemInfo.Description != "")
               {
                  this._baseTip.itemInfo.Description += "、";
               }
               this._baseTip.itemInfo.Description += item.Name + "x" + rewardInfo.count;
               this._baseIcon.tipData = this._baseTip;
            }
            else
            {
               if(this._superTip.itemInfo.Description != "")
               {
                  this._superTip.itemInfo.Description += "、";
               }
               this._superTip.itemInfo.Description += item.Name + "x" + rewardInfo.count;
               this._superIcon.tipData = this._superTip;
            }
         }
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__onOverHanlder);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onOutHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._sprite);
         this._sprite = null;
         ObjectUtils.disposeObject(this._backOverBit);
         this._backOverBit = null;
         ObjectUtils.disposeObject(this._placeTxt);
         this._placeTxt = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._numTxt);
         this._numTxt = null;
         ObjectUtils.disposeObject(this._topThreeIcon);
         this._topThreeIcon = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._baseIcon);
         this._baseIcon = null;
         ObjectUtils.disposeObject(this._superIcon);
         this._superIcon = null;
      }
   }
}

