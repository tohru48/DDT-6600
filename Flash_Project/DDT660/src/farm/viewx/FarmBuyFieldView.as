package farm.viewx
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class FarmBuyFieldView extends Sprite implements Disposeable
   {
      
      private var _bg1:MutipleImage;
      
      private var _bg2:ScaleBitmapImage;
      
      private var _titleBg:Bitmap;
      
      private var _title:FilterFrameText;
      
      private var _close:SimpleBitmapButton;
      
      private var _cancel:TextButton;
      
      private var _ok:TextButton;
      
      private var _timeTitle:FilterFrameText;
      
      private var _bg3:Scale9CornerImage;
      
      private var _week:SelectedCheckButton;
      
      private var _month:SelectedCheckButton;
      
      private var _all:SelectedCheckButton;
      
      private var _bg4:Bitmap;
      
      private var _needTxt:FilterFrameText;
      
      private var _discountTxt:FilterFrameText;
      
      private var _money:FilterFrameText;
      
      private var _group:SelectedButtonGroup;
      
      private var _fieldId:int;
      
      private var _moneyNum:int;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      private var _isBand:Boolean;
      
      public function FarmBuyFieldView(fieldid:int)
      {
         super();
         this._fieldId = fieldid;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("farm.buyFieldView.bg");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("farm.buyFieldView.bg2");
         this._titleBg = ComponentFactory.Instance.creatBitmap("assets.farm.titleSmall");
         PositionUtils.setPos(this._titleBg,"farm.buyView.titlePos");
         this._title = ComponentFactory.Instance.creatComponentByStylename("farm.buyFieldView.titleText");
         this._title.text = LanguageMgr.GetTranslation("ddt.farm.spreadTitle");
         this._close = ComponentFactory.Instance.creatComponentByStylename("farm.closeBtn");
         PositionUtils.setPos(this._close,"farm.buyView.closePos");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("farm.buyFieldView.cancel");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._ok = ComponentFactory.Instance.creatComponentByStylename("farm.buyFieldView.ok");
         this._ok.text = LanguageMgr.GetTranslation("ok");
         this._timeTitle = ComponentFactory.Instance.creatComponentByStylename("farm.buyview.timeTitle");
         this._timeTitle.text = LanguageMgr.GetTranslation("ddt.farm.spreadTime");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("farm.buyview.bg3");
         this._week = ComponentFactory.Instance.creatComponentByStylename("farm.buyview.week");
         this._week.text = LanguageMgr.GetTranslation("ddt.farm.spreadTime1");
         this._month = ComponentFactory.Instance.creatComponentByStylename("farm.buyview.month");
         this._month.text = LanguageMgr.GetTranslation("ddt.farm.spreadTime2");
         this._all = ComponentFactory.Instance.creatComponentByStylename("farm.buyview.all");
         this._all.text = LanguageMgr.GetTranslation("ddt.farm.spreadTime3");
         this._bg4 = ComponentFactory.Instance.creatBitmap("asset.spread.showFeeBg");
         PositionUtils.setPos(this._bg4,"farm.buyView.bg4Pos");
         this._needTxt = ComponentFactory.Instance.creatComponentByStylename("farm.buyview.needText");
         this._needTxt.text = LanguageMgr.GetTranslation("ddt.farm.spread.payMoney");
         this._money = ComponentFactory.Instance.creatComponentByStylename("farm.buyview.money");
         this._discountTxt = ComponentFactory.Instance.creatComponentByStylename("farm.buyview.discountText");
         this._group = new SelectedButtonGroup();
         this._group.addSelectItem(this._week);
         this._group.addSelectItem(this._month);
         this._group.selectIndex = 1;
         this._all.selected = false;
         if(this.getallField().length <= 1)
         {
            this._all.visible = false;
            this._discountTxt.visible = false;
         }
         addChild(this._bg1);
         addChild(this._bg2);
         addChild(this._titleBg);
         addChild(this._title);
         addChild(this._close);
         addChild(this._cancel);
         addChild(this._ok);
         addChild(this._bg3);
         addChild(this._week);
         addChild(this._month);
         addChild(this._all);
         addChild(this._bg4);
         addChild(this._needTxt);
         addChild(this._discountTxt);
         addChild(this._money);
         addChild(this._timeTitle);
         this._isBand = false;
         this.upMoney();
      }
      
      private function addEvent() : void
      {
         this._close.addEventListener(MouseEvent.CLICK,this.__close);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__close);
         this._ok.addEventListener(MouseEvent.CLICK,this.__ok);
         this._group.addEventListener(Event.CHANGE,this.__changeHandler);
         this._all.addEventListener(Event.SELECT,this.__all);
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
      }
      
      private function removeEvent() : void
      {
         this._close.removeEventListener(MouseEvent.CLICK,this.__close);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__close);
         this._ok.removeEventListener(MouseEvent.CLICK,this.__ok);
         this._all.removeEventListener(Event.SELECT,this.__all);
         this._group.removeEventListener(Event.CHANGE,this.__changeHandler);
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
      }
      
      protected function __onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this.dispose();
            event.stopImmediatePropagation();
         }
      }
      
      private function upMoney() : void
      {
         if(this._all.selected)
         {
            this._moneyNum = this._group.selectIndex == 0 ? int(this.getallField().length * FarmModelController.instance.model.payFieldMoneyToWeek) : int(this.getallField().length * FarmModelController.instance.model.payFieldMoneyToMonth);
            if(FarmModelController.instance.model.payFieldDiscount != 100)
            {
               this._moneyNum = Math.floor(this._moneyNum * FarmModelController.instance.model.payFieldDiscount / 100);
            }
         }
         else
         {
            this._moneyNum = this._group.selectIndex == 0 ? FarmModelController.instance.model.payFieldMoneyToWeek : FarmModelController.instance.model.payFieldMoneyToMonth;
         }
         if(FarmModelController.instance.model.payFieldDiscount != 100)
         {
            this._discountTxt.text = LanguageMgr.GetTranslation("ddt.farm.spread.discount",FarmModelController.instance.model.payFieldDiscount / 10);
         }
         else
         {
            this._discountTxt.text = "";
         }
         this._money.text = LanguageMgr.GetTranslation("ddt.farm.spread.Money",this._moneyNum);
      }
      
      protected function __all(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.upMoney();
      }
      
      private function __changeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.upMoney();
      }
      
      protected function __ok(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._isBand && PlayerManager.Instance.Self.BandMoney < this._moneyNum)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"));
            return;
         }
         if(!this._isBand && PlayerManager.Instance.Self.Money < this._moneyNum)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         var arr:Array = new Array();
         if(this._all.selected)
         {
            arr = this.getallField();
         }
         else
         {
            arr.push(this._fieldId);
         }
         var paytime:int = this._group.selectIndex == 0 ? FarmModelController.instance.model.payFieldTimeToWeek : FarmModelController.instance.model.payFieldTimeToMonth;
         FarmModelController.instance.payField(arr,paytime,this._isBand);
         this.dispose();
      }
      
      private function __moneyConfirmHandler(evt:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         this._moneyConfirm.dispose();
         this._moneyConfirm = null;
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
      }
      
      private function getallField() : Array
      {
         var arr:Array = arr = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
         for(var i:int = 0; i < FarmModelController.instance.model.fieldsInfo.length; i++)
         {
            if(FarmModelController.instance.model.fieldsInfo[i].isDig)
            {
               arr.splice(arr.indexOf(i),1);
            }
         }
         return arr;
      }
      
      protected function __close(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         this._bg2 = null;
         if(Boolean(this._titleBg))
         {
            ObjectUtils.disposeObject(this._titleBg);
         }
         this._titleBg = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._close))
         {
            ObjectUtils.disposeObject(this._close);
         }
         this._close = null;
         if(Boolean(this._cancel))
         {
            ObjectUtils.disposeObject(this._cancel);
         }
         this._cancel = null;
         if(Boolean(this._ok))
         {
            ObjectUtils.disposeObject(this._ok);
         }
         this._ok = null;
         if(Boolean(this._timeTitle))
         {
            ObjectUtils.disposeObject(this._timeTitle);
         }
         this._timeTitle = null;
         if(Boolean(this._bg3))
         {
            ObjectUtils.disposeObject(this._bg3);
         }
         this._bg3 = null;
         if(Boolean(this._week))
         {
            ObjectUtils.disposeObject(this._week);
         }
         this._week = null;
         if(Boolean(this._month))
         {
            ObjectUtils.disposeObject(this._month);
         }
         this._month = null;
         if(Boolean(this._all))
         {
            ObjectUtils.disposeObject(this._all);
         }
         this._all = null;
         if(Boolean(this._bg4))
         {
            ObjectUtils.disposeObject(this._bg4);
         }
         this._bg4 = null;
         if(Boolean(this._needTxt))
         {
            ObjectUtils.disposeObject(this._needTxt);
         }
         this._needTxt = null;
         if(Boolean(this._money))
         {
            ObjectUtils.disposeObject(this._money);
         }
         this._money = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

