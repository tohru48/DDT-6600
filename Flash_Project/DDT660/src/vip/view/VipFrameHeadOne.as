package vip.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class VipFrameHeadOne extends Sprite implements Disposeable
   {
      
      private var _topBG:ScaleBitmapImage;
      
      private var _buyPackageBtn:BaseButton;
      
      private var _dueDataWord:FilterFrameText;
      
      private var _dueData:FilterFrameText;
      
      private var _buyPackageTxt:FilterFrameText;
      
      private var _buyPackageTxt1:FilterFrameText;
      
      private var _price:int = 6680;
      
      public function VipFrameHeadOne()
      {
         super();
         this._init();
         this.addEvent();
      }
      
      private function _init() : void
      {
         this._topBG = ComponentFactory.Instance.creatComponentByStylename("VIPFrame.topBG1");
         this._buyPackageBtn = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageBtn");
         this._buyPackageTxt = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageTxt");
         this._buyPackageTxt.text = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.text");
         this._buyPackageTxt1 = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageTxt");
         PositionUtils.setPos(this._buyPackageTxt1,"buyPackagePos");
         this._buyPackageTxt1.text = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.text1");
         this._dueDataWord = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.dueDateFontTxt");
         this._dueDataWord.text = LanguageMgr.GetTranslation("ddt.vip.dueDateFontTxt");
         PositionUtils.setPos(this._dueDataWord,"dueDataWordTxtPos");
         this._dueData = ComponentFactory.Instance.creat("VipStatusView.dueDate");
         PositionUtils.setPos(this._dueData,"dueDataTxtPos");
         addChild(this._topBG);
         addChild(this._buyPackageBtn);
         addChild(this._buyPackageTxt);
         addChild(this._buyPackageTxt1);
         addChild(this._dueDataWord);
         addChild(this._dueData);
         this.upView();
      }
      
      private function addEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._buyPackageBtn.addEventListener(MouseEvent.CLICK,this.__onBuyClick);
      }
      
      private function __onBuyClick(event:MouseEvent) : void
      {
         var alert1:BaseAlerFrame = null;
         event.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < this._price)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.vip.view.buyVipGift"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         alert1.mouseEnabled = false;
         alert1.addEventListener(FrameEvent.RESPONSE,this._responseI);
      }
      
      private function _responseI(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dobuy();
         }
         ObjectUtils.disposeObject(event.target);
      }
      
      private function dobuy() : void
      {
         var items:Array = new Array();
         var types:Array = new Array();
         var colors:Array = new Array();
         var dresses:Array = new Array();
         var places:Array = new Array();
         var goodsTypes:Array = [];
         var _info:ItemTemplateInfo = ItemManager.Instance.getTemplateById(EquipType.VIP_GIFT_BAG);
         items.push(_info.TemplateID);
         types.push("1");
         colors.push("");
         dresses.push("");
         places.push("");
         goodsTypes.push("1");
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,null,0,goodsTypes);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._buyPackageBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyClick);
      }
      
      private function __propertyChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["isVip"]) || Boolean(event.changedProperties["VipExpireDay"]) || Boolean(event.changedProperties["VIPNextLevelDaysNeeded"]))
         {
            this.upView();
         }
      }
      
      private function upView() : void
      {
         var date:Date = PlayerManager.Instance.Self.VIPExpireDay as Date;
         this._dueData.text = date.fullYear + "-" + (date.month + 1) + "-" + date.date;
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._dueData.text = "";
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._topBG))
         {
            ObjectUtils.disposeObject(this._topBG);
         }
         this._topBG = null;
         if(Boolean(this._buyPackageTxt))
         {
            ObjectUtils.disposeObject(this._buyPackageTxt);
         }
         this._buyPackageTxt = null;
         if(Boolean(this._buyPackageTxt1))
         {
            ObjectUtils.disposeObject(this._buyPackageTxt1);
         }
         this._buyPackageTxt1 = null;
      }
   }
}

