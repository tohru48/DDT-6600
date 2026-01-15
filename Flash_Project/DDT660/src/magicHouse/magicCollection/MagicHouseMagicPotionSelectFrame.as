package magicHouse.magicCollection
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import magicHouse.MagicHouseManager;
   
   public class MagicHouseMagicPotionSelectFrame extends Frame
   {
      
      private var _numberSelecter:NumberSelecter;
      
      private var _countTxt:FilterFrameText;
      
      private var _needPotionTipTxt:FilterFrameText;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _count:int;
      
      private var _type:int;
      
      public function MagicHouseMagicPotionSelectFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.titleText = LanguageMgr.GetTranslation("magichouse.collectionView.magicpotionsCountTitle");
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItem.upgrade.magicpotion.NumberSelecter");
         addToContent(this._numberSelecter);
         var max:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.MAGICHOUSE_MAGICPOTION);
         this._numberSelecter.valueLimit = "1," + max;
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.chargeBoxNeedMoneyText");
         PositionUtils.setPos(this._countTxt,"magicHouse.collection.selectedCountTxtPos");
         this._countTxt.text = LanguageMgr.GetTranslation("magichouse.collectionView.magicpotionsCount");
         addToContent(this._countTxt);
         this._needPotionTipTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.chargeBoxNeedMoneyText");
         PositionUtils.setPos(this._needPotionTipTxt,"magicHouse.collection.selectedNeedTxtPos");
         this._needPotionTipTxt.htmlText = LanguageMgr.GetTranslation("magichouse.collectionView.upgradeLvNeedPotions",0);
         addToContent(this._needPotionTipTxt);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         PositionUtils.setPos(this._okBtn,"magicHouse.collection.selectedOkBtnPos");
         addToContent(this._okBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         this._cancelBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         PositionUtils.setPos(this._cancelBtn,"magicHouse.collection.selectedCancekBtnPos");
         addToContent(this._cancelBtn);
      }
      
      private function _update() : void
      {
         var number:int = 0;
         var needExp:int = 0;
         var currentExp:int = 0;
         if(this._type == 1)
         {
            needExp = int(MagicHouseManager.instance.levelUpNumber[MagicHouseManager.instance.magicJuniorLv]);
            currentExp = MagicHouseManager.instance.magicJuniorExp;
         }
         else if(this._type == 2)
         {
            needExp = int(MagicHouseManager.instance.levelUpNumber[MagicHouseManager.instance.magicMidLv]);
            currentExp = MagicHouseManager.instance.magicMidExp;
         }
         else
         {
            needExp = int(MagicHouseManager.instance.levelUpNumber[MagicHouseManager.instance.magicSeniorLv]);
            currentExp = MagicHouseManager.instance.magicSeniorExp;
         }
         number = Math.ceil((needExp - currentExp) / 10);
         this._numberSelecter.currentValue = number;
         this._numberSelecter.validate();
         this._needPotionTipTxt.htmlText = LanguageMgr.GetTranslation("magichouse.collectionView.upgradeLvNeedPotions",number);
      }
      
      private function initEvent() : void
      {
         this._numberSelecter.addEventListener(Event.CHANGE,this.selectHandler);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okBtnHandler);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelBtnHandler);
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvent() : void
      {
         this._numberSelecter.removeEventListener(Event.CHANGE,this.selectHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okBtnHandler);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelBtnHandler);
      }
      
      private function selectHandler(e:Event) : void
      {
         SoundManager.instance.play("008");
         this._count = this._numberSelecter.currentValue;
      }
      
      private function __okBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.MAGICHOUSE_MAGICPOTION) > 0)
         {
            SocketManager.Instance.out.magicLibLevelUp(this._type,this._count);
            this.dispose();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionItem.magicPotionLess"));
         }
      }
      
      private function __cancelBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
         else if(e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.__okBtnHandler(null);
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(value:int) : void
      {
         this._type = value;
         this._update();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

