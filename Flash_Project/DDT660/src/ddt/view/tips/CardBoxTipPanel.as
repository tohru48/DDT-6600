package ddt.view.tips
{
   import cardSystem.CardControl;
   import cardSystem.data.SetsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.AddPublicInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.AddPublicTipManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   
   public class CardBoxTipPanel extends BaseTip implements ITip, Disposeable
   {
      
      public static const THISWIDTH:int = 300;
      
      private var _cardName:FilterFrameText;
      
      private var _cardTypeBit:Bitmap;
      
      private var _cardType:FilterFrameText;
      
      private var _cardSetsBit:Bitmap;
      
      private var _cardSets:FilterFrameText;
      
      private var _cardDescript:FilterFrameText;
      
      private var _bg:ScaleBitmapImage;
      
      private var _band:ScaleFrameImage;
      
      private var _rule:ScaleBitmapImage;
      
      private var _validity:FilterFrameText;
      
      private var _templateInfo:ItemTemplateInfo;
      
      private var _addPublicTip:FilterFrameText;
      
      private var isShowed:Boolean = false;
      
      public function CardBoxTipPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._cardName = ComponentFactory.Instance.creatComponentByStylename("CardBoxTipPanel.name");
         this._cardTypeBit = ComponentFactory.Instance.creatBitmap("asset.core.tip.GoodsType");
         PositionUtils.setPos(this._cardTypeBit,"CardBoxTipPanel.typePos");
         this._cardType = ComponentFactory.Instance.creatComponentByStylename("CardBoxTipPanel.cardType");
         this._cardSetsBit = ComponentFactory.Instance.creatBitmap("asset.core.tip.cardsTipPanel.sets");
         PositionUtils.setPos(this._cardSetsBit,"CardBoxTipPanel.setsBitPos");
         this._cardSets = ComponentFactory.Instance.creatComponentByStylename("CardBoxTipPanel.cardSets");
         this._cardDescript = ComponentFactory.Instance.creatComponentByStylename("CardBoxTipPanel.descrip");
         this._band = ComponentFactory.Instance.creatComponentByStylename("tipPanel.band");
         this._rule = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         PositionUtils.setPos(this._rule,"CardBoxTipPanel.rulePos");
         this._rule.width = 160;
         this._validity = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         this._validity.x = 10;
         this._addPublicTip = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipTypeTxt2");
         super.init();
         super.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._cardName);
         addChild(this._cardTypeBit);
         addChild(this._cardType);
         addChild(this._cardSetsBit);
         addChild(this._cardSets);
         addChild(this._cardDescript);
         addChild(this._band);
         addChild(this._rule);
         addChild(this._validity);
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      private function createAddPublicTip() : void
      {
         if(AddPublicTipManager.Instance.type == 0)
         {
            return;
         }
         if(this._templateInfo == null)
         {
            return;
         }
         var tempInfo:AddPublicInfo = AddPublicTipManager.Instance.getAddPublicTipInfoByID(this._templateInfo.TemplateID,AddPublicTipManager.Instance.type);
         if(tempInfo == null)
         {
            return;
         }
         var qualityArr:Array = ["极低","低","普通","高","极高"];
         this._addPublicTip.text = "概率：" + qualityArr[tempInfo.rate - 1];
         PositionUtils.setPos(this._addPublicTip,"core.addPublicTipPos2");
         addChild(this._addPublicTip);
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(data:Object) : void
      {
         if(data is ShopItemInfo)
         {
            this._templateInfo = data.TemplateInfo as ItemTemplateInfo;
            this.visible = true;
            _tipData = this._templateInfo;
            this.showTip();
         }
         else if(Boolean(data))
         {
            this._templateInfo = data as ItemTemplateInfo;
            this.visible = true;
            _tipData = this._templateInfo;
            this.showTip();
         }
         else
         {
            this.visible = false;
            _tipData = null;
         }
      }
      
      private function showTip() : void
      {
         if(this._templateInfo is InventoryItemInfo)
         {
            this._band.visible = true;
            this._band.setFrame((this._templateInfo as InventoryItemInfo).IsBinds ? 1 : 2);
         }
         else
         {
            this._band.visible = false;
         }
         this._cardName.text = this._templateInfo.Name;
         this._cardName.textColor = QualityType.QUALITY_COLOR[4];
         this._cardType.text = CardsTipPanel.CARDTYPE[int(this._templateInfo.Property6)] + "(" + CardsTipPanel.CARDTYPE_VICE_MAIN[int(this._templateInfo.Property8)] + ")";
         var setsInfoVec:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         var len:int = int(setsInfoVec.length);
         var setsName:String = "";
         for(var n:int = 0; n < len; n++)
         {
            if(setsInfoVec[n].ID == this._templateInfo.Property7)
            {
               setsName = setsInfoVec[n].name;
               break;
            }
         }
         this._cardSets.text = setsName;
         if(this._templateInfo.TemplateID == 20150 || this._templateInfo.TemplateID == 201266)
         {
            this._cardType.visible = false;
            this._cardSets.visible = false;
            this._cardTypeBit.visible = false;
            this._cardSetsBit.visible = false;
            this._band.y = 11;
            this._band.x = 97;
            this._rule.y = 40;
            this._cardDescript.y = 48;
            this._validity.visible = false;
            this._cardDescript.text = this._templateInfo.Description;
            this.upBackground();
         }
         else
         {
            this._band.y = 35;
            this._band.x = this._cardType.x + this._cardType.width + 10;
            this._rule.y = 90;
            this._cardDescript.y = 98;
            this._cardType.visible = true;
            this._cardSets.visible = true;
            this._cardTypeBit.visible = true;
            this._cardSetsBit.visible = true;
            this._validity.visible = true;
            this._cardDescript.text = this._templateInfo.Description;
            this._validity.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
            this._validity.textColor = 16776960;
            this._validity.y = this._cardDescript.y + this._cardDescript.textHeight + 10;
            this.upBackground();
         }
         if(PathManager.add_public_tip)
         {
            this.createAddPublicTip();
         }
      }
      
      private function upBackground() : void
      {
         this._bg.width = THISWIDTH > this._band.x + this._band.width ? THISWIDTH + 30 : this._band.x + this._band.width + 30;
         if(this._templateInfo.TemplateID == 20150 || this._templateInfo.TemplateID == 201266)
         {
            this._bg.height = this._cardDescript.y + this._validity.textHeight + 10;
         }
         else
         {
            this._bg.height = this._validity.y + this._validity.textHeight + 10;
         }
         this.updateWH();
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         this._templateInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._cardName = null;
         this._cardTypeBit = null;
         this._cardType = null;
         this._cardSetsBit = null;
         this._cardSets = null;
         this._cardDescript = null;
         this._bg = null;
         this._band = null;
         this._rule = null;
         this._validity = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

