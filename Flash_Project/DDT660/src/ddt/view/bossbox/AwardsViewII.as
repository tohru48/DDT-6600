package ddt.view.bossbox
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mainbutton.MainButtnController;
   
   public class AwardsViewII extends Frame
   {
      
      public static const HAVEBTNCLICK:String = "_haveBtnClick";
      
      private var _timeTypeTxt:FilterFrameText;
      
      private var _goodsList:Array;
      
      private var _boxType:int;
      
      private var _button:TextButton;
      
      private var list:AwardsGoodsList;
      
      private var GoodsBG:ScaleBitmapImage;
      
      public function AwardsViewII()
      {
         super();
         this.initII();
         this.initEvent();
      }
      
      private function initII() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
         this.GoodsBG = ComponentFactory.Instance.creat("bossbox.scale9GoodsImageII");
         addToContent(this.GoodsBG);
         var bit:Bitmap = ComponentFactory.Instance.creatBitmap("asset.vip.monyBG");
         addToContent(bit);
         this._timeTypeTxt = ComponentFactory.Instance.creat("bossbox.awardsTitleTxt");
         this._timeTypeTxt.text = LanguageMgr.GetTranslation("ddt.vip.awardsTitleTxt");
         addToContent(this._timeTypeTxt);
         this._button = ComponentFactory.Instance.creat("bossbox.BoxGetButtonII");
         this._button.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._button);
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._button.enable = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._button.addEventListener(MouseEvent.CLICK,this._click);
      }
      
      private function _click(evt:MouseEvent) : void
      {
         var boxGoodItem:BoxGoodsTempInfo = null;
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var vRewardBindBid:int = 0;
         for each(boxGoodItem in this._goodsList)
         {
            if(boxGoodItem.TemplateId == -300)
            {
               vRewardBindBid = boxGoodItem.ItemCount;
               break;
            }
         }
         if(vRewardBindBid + PlayerManager.Instance.Self.BandMoney > ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel))
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.BindBid.tip"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"),false,false,true,1);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         else
         {
            PlayerManager.Instance.Self.canTakeVipReward = false;
            MainButtnController.instance.dispatchEvent(new Event(MainButtnController.ICONCLOSE));
            dispatchEvent(new Event(AwardsView.HAVEBTNCLICK));
         }
      }
      
      private function __onResponse(pEvent:FrameEvent) : void
      {
         pEvent.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(pEvent.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            PlayerManager.Instance.Self.canTakeVipReward = false;
            MainButtnController.instance.dispatchEvent(new Event(MainButtnController.ICONCLOSE));
            dispatchEvent(new Event(AwardsView.HAVEBTNCLICK));
         }
         ObjectUtils.disposeObject(pEvent.currentTarget);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      public function set boxType(value:int) : void
      {
         this._boxType = value + 1;
      }
      
      public function get boxType() : int
      {
         return this._boxType;
      }
      
      public function set goodsList(templateIds:Array) : void
      {
         this._goodsList = templateIds;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.show(this._goodsList);
         addChild(this.list);
      }
      
      public function set vipAwardGoodsList(templateIds:Array) : void
      {
         this._goodsList = templateIds;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.showForVipAward(this._goodsList);
         addChild(this.list);
      }
      
      public function set fightLibAwardGoodList(templateids:Array) : void
      {
         this.goodsList = templateids;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.show(this._goodsList);
         addChild(this.list);
      }
      
      public function setCheck() : void
      {
         closeButton.visible = true;
         this._button.enable = false;
         this._timeTypeTxt.visible = false;
         var txt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("bossbox.TheNextTimeText");
         addToContent(txt);
         txt.text = LanguageMgr.GetTranslation("ddt.view.bossbox.AwardsView.TheNextTimeText",this.updateTime());
      }
      
      private function updateTime() : String
      {
         var _timeSum:Number = BossBoxManager.instance.delaySumTime * 1000 + TimeManager.Instance.Now().time;
         var date:Date = new Date(_timeSum);
         var _hours:int = date.hours;
         var _minute:int = date.minutes;
         var str:String = "";
         if(_hours < 10)
         {
            str += "0" + _hours;
         }
         else
         {
            str += _hours;
         }
         str += ":";
         if(_minute < 10)
         {
            str += "0" + _minute;
         }
         else
         {
            str += _minute;
         }
         return str + ":";
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(Boolean(this._timeTypeTxt))
         {
            ObjectUtils.disposeObject(this._timeTypeTxt);
         }
         this._timeTypeTxt = null;
         if(Boolean(this._button))
         {
            this._button.removeEventListener(MouseEvent.CLICK,this._click);
            ObjectUtils.disposeObject(this._button);
         }
         this._button = null;
         if(Boolean(this.list))
         {
            ObjectUtils.disposeObject(this.list);
         }
         this.list = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

