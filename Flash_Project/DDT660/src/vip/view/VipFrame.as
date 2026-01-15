package vip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Point;
   import vip.VipController;
   
   public class VipFrame extends Frame
   {
      
      public static const SELF_VIEW:int = 0;
      
      public static const OTHER_VIEW:int = 1;
      
      private var _hBox:HBox;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _giveYourselfOpenBtn:SelectedTextButton;
      
      private var _giveOthersOpenedBtn:SelectedTextButton;
      
      private var _vipSp:Disposeable;
      
      private var _head:VipFrameHead;
      
      private var _discountIcon:ScaleLeftRightImage;
      
      private var _discountTxt:FilterFrameText;
      
      private var discountCode:int = 0;
      
      private var _discountIconII:ScaleLeftRightImage;
      
      private var _discountIconIII:ScaleLeftRightImage;
      
      private var _discountTxtII:FilterFrameText;
      
      private var _discountTxtIII:FilterFrameText;
      
      public function VipFrame()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         if(PathManager.vipDiscountEnable)
         {
            this.discountCode = 1;
         }
         else
         {
            this.discountCode = 0;
         }
         titleText = LanguageMgr.GetTranslation("ddt.vip.vipFrame.title");
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("ddtvip.btnHbox");
         this._giveYourselfOpenBtn = ComponentFactory.Instance.creatComponentByStylename("vip.giveYourselfOpenBtn");
         this._giveYourselfOpenBtn.text = LanguageMgr.GetTranslation("ddt.vip.table.openSelf");
         this._giveOthersOpenedBtn = ComponentFactory.Instance.creatComponentByStylename("vip.giveOthersOpenedBtn");
         this._giveOthersOpenedBtn.text = LanguageMgr.GetTranslation("ddt.vip.table.openother");
         this._head = new VipFrameHead();
         addToContent(this._head);
         addToContent(this._hBox);
         this._hBox.addChild(this._giveYourselfOpenBtn);
         this._hBox.addChild(this._giveOthersOpenedBtn);
         this._selectedButtonGroup = new SelectedButtonGroup(false,1);
         this._selectedButtonGroup.addSelectItem(this._giveYourselfOpenBtn);
         this._selectedButtonGroup.addSelectItem(this._giveOthersOpenedBtn);
         this._selectedButtonGroup.selectIndex = 0;
         this.updateView(SELF_VIEW);
         this._discountIcon = ComponentFactory.Instance.creatComponentByStylename("ddtvip.discount.image");
         addToContent(this._discountIcon);
         this._discountIconII = ComponentFactory.Instance.creatComponentByStylename("ddtvip.discount.image");
         addToContent(this._discountIconII);
         PositionUtils.setPos(this._discountIconII,"ddtvip.discount.image.threeMonthPos");
         this._discountIconIII = ComponentFactory.Instance.creatComponentByStylename("ddtvip.discount.image");
         addToContent(this._discountIconIII);
         PositionUtils.setPos(this._discountIconIII,"ddtvip.discount.image.oneMonthPos");
         this._discountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtvip.discount.imageTxt");
         addToContent(this._discountTxt);
         this._discountTxt.x = this._discountIcon.x + 1;
         this._discountTxt.y = this._discountIcon.y + 2;
         this._discountTxt.width = this._discountIcon.width;
         this._discountTxtII = ComponentFactory.Instance.creatComponentByStylename("ddtvip.discount.imageTxt");
         addToContent(this._discountTxtII);
         this._discountTxtII.x = this._discountIconII.x + 1;
         this._discountTxtII.y = this._discountIconII.y + 2;
         this._discountTxtII.width = this._discountIconII.width;
         this._discountTxtIII = ComponentFactory.Instance.creatComponentByStylename("ddtvip.discount.imageTxt");
         addToContent(this._discountTxtIII);
         this._discountTxtIII.x = this._discountIconIII.x + 1;
         this._discountTxtIII.y = this._discountIconIII.y + 2;
         this._discountTxtIII.width = this._discountIconIII.width;
         this._discountTxtIII.text = "";
         if(Number(PlayerManager.Instance.vipDiscountArr[2]) > 0)
         {
            this._discountTxt.text = LanguageMgr.GetTranslation("ddt.vipView.discountIconTxt",Number(PlayerManager.Instance.vipDiscountArr[2]));
         }
         else
         {
            this._discountTxt.text = LanguageMgr.GetTranslation("ddt.vipView.discountIconTxt",8.8);
         }
         if(Number(PlayerManager.Instance.vipDiscountArr[1]) > 0)
         {
            this._discountTxtII.text = LanguageMgr.GetTranslation("ddt.vipView.discountIconTxt",Number(PlayerManager.Instance.vipDiscountArr[1]));
            this._discountIconII.visible = true;
         }
         else
         {
            this._discountTxtII.text = "";
            this._discountIconII.visible = false;
         }
         if(Number(PlayerManager.Instance.vipDiscountArr[0]) > 0)
         {
            this._discountTxtIII.text = LanguageMgr.GetTranslation("ddt.vipView.discountIconTxt",Number(PlayerManager.Instance.vipDiscountArr[0]));
            this._discountIconIII.visible = true;
         }
         else
         {
            this._discountTxtIII.text = "";
            this._discountIconIII.visible = false;
         }
      }
      
      private function updateView(index:int) : void
      {
         var point:Point = null;
         if(Boolean(this._vipSp))
         {
            this._vipSp.dispose();
         }
         this._vipSp = null;
         switch(index)
         {
            case SELF_VIEW:
               this._selectedButtonGroup.selectIndex = 0;
               this._vipSp = new GiveYourselfOpenView(this.discountCode);
               break;
            case OTHER_VIEW:
               this._selectedButtonGroup.selectIndex = 1;
               this._vipSp = new GiveOthersOpenedView(false,this.discountCode);
         }
         point = ComponentFactory.Instance.creatCustomObject("vip.GiveYourselfOpenViewPos");
         DisplayObject(this._vipSp).x = point.x;
         DisplayObject(this._vipSp).y = point.y;
         addToContent(DisplayObject(this._vipSp));
         DisplayObject(this._vipSp).parent.setChildIndex(DisplayObject(this._vipSp),0);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._selectedButtonGroup.addEventListener(Event.CHANGE,this.__selectedButtonGroupChange);
      }
      
      private function __selectedButtonGroupChange(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateView(this._selectedButtonGroup.selectIndex);
         this._hBox.arrange();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(Boolean(this._selectedButtonGroup))
         {
            this._selectedButtonGroup.removeEventListener(Event.CHANGE,this.__selectedButtonGroupChange);
         }
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               VipController.instance.hide();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._selectedButtonGroup))
         {
            this._selectedButtonGroup.dispose();
         }
         this._selectedButtonGroup = null;
         if(Boolean(this._giveYourselfOpenBtn))
         {
            ObjectUtils.disposeObject(this._giveYourselfOpenBtn);
         }
         this._giveYourselfOpenBtn = null;
         if(Boolean(this._giveOthersOpenedBtn))
         {
            ObjectUtils.disposeObject(this._giveOthersOpenedBtn);
         }
         this._giveOthersOpenedBtn = null;
         if(Boolean(this._discountIcon))
         {
            ObjectUtils.disposeObject(this._discountIcon);
         }
         this._discountIcon = null;
         if(Boolean(this._discountTxt))
         {
            ObjectUtils.disposeObject(this._discountTxt);
         }
         this._discountTxt = null;
         if(Boolean(this._discountTxtII))
         {
            ObjectUtils.disposeObject(this._discountTxtII);
         }
         this._discountTxtII = null;
         if(Boolean(this._discountTxtIII))
         {
            ObjectUtils.disposeObject(this._discountTxtIII);
         }
         this._discountTxtIII = null;
         if(Boolean(this._discountIconII))
         {
            ObjectUtils.disposeObject(this._discountIconII);
         }
         this._discountIconII = null;
         if(Boolean(this._discountIconIII))
         {
            ObjectUtils.disposeObject(this._discountIconIII);
         }
         this._discountIconIII = null;
         if(Boolean(this._head))
         {
            this._head.dispose();
            this._head = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

