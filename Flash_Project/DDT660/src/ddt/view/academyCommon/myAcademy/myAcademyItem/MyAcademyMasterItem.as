package ddt.view.academyCommon.myAcademy.myAcademyItem
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import email.manager.MailManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import im.IMController;
   import im.IMEvent;
   import vip.VipController;
   
   public class MyAcademyMasterItem extends Sprite implements Disposeable
   {
      
      protected var _nameTxt:FilterFrameText;
      
      protected var _vipName:GradientText;
      
      protected var _offLineText:FilterFrameText;
      
      protected var _removeBtn:TextButton;
      
      protected var _itemBG:ScaleFrameImage;
      
      protected var _line11:ScaleBitmapImage;
      
      protected var _line22:ScaleBitmapImage;
      
      protected var _line33:ScaleBitmapImage;
      
      protected var _line44:ScaleBitmapImage;
      
      protected var _levelIcon:LevelIcon;
      
      protected var _sexIcon:SexIcon;
      
      protected var _info:PlayerInfo;
      
      protected var _isSelect:Boolean;
      
      protected var _addFriend:TextButton;
      
      protected var _emailBtn:TextButton;
      
      protected var _removeGold:int;
      
      public function MyAcademyMasterItem()
      {
         super();
         this.init();
         this.initEvent();
         this.initComponent();
      }
      
      public function set info(value:PlayerInfo) : void
      {
         this._info = value;
         this.updateComponent();
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      protected function init() : void
      {
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.itemBG");
         this._itemBG.setFrame(1);
         addChild(this._itemBG);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.nameTxt");
         this._offLineText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.offLineText");
         addChild(this._offLineText);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("academyCommon.myAcademy.MyAcademyMasterItem.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = new SexIcon();
         this._sexIcon.visible = false;
         addChild(this._sexIcon);
         this._removeBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.removeBtn");
         this._removeBtn.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.itemtitle.removeBtnText");
         addChild(this._removeBtn);
         this._addFriend = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.addFriendBtn");
         this._addFriend.text = LanguageMgr.GetTranslation("civil.leftview.addName");
         this._addFriend.visible = false;
         addChild(this._addFriend);
         this._emailBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.emailBtn");
         this._emailBtn.text = LanguageMgr.GetTranslation("itemview.emailText");
         addChild(this._emailBtn);
         this._line11 = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyItem.formIine11");
         addChild(this._line11);
         this._line22 = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyItem.formIine22");
         addChild(this._line22);
         this._line33 = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyItem.formIine33");
         addChild(this._line33);
         this._line44 = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyItem.formIine44");
         addChild(this._line44);
      }
      
      protected function initEvent() : void
      {
         this._itemBG.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
         this._removeBtn.addEventListener(MouseEvent.CLICK,this.__removeClick);
         this._addFriend.addEventListener(MouseEvent.CLICK,this.__addFriendClick);
         this._emailBtn.addEventListener(MouseEvent.CLICK,this.__emailBtnClick);
         PlayerManager.Instance.addEventListener(IMEvent.ADDNEW_FRIEND,this.__addFriend);
      }
      
      private function __addFriend(event:IMEvent) : void
      {
         if(Boolean(this._info) && (event.data as PlayerInfo).ID == this._info.ID)
         {
            this._addFriend.enable = false;
         }
      }
      
      private function __emailBtnClick(event:MouseEvent) : void
      {
         MailManager.Instance.showWriting(this._info.NickName);
      }
      
      private function __addFriendClick(event:MouseEvent) : void
      {
         IMController.Instance.addFriend(this._info.NickName);
      }
      
      protected function __removeClick(event:MouseEvent) : void
      {
         var baseAlerFrame:BaseAlerFrame = null;
         var alerFrame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
         if(!this.getTimerOvertop())
         {
            alertInfo.data = LanguageMgr.GetTranslation("ddt.view.academyCommon.myAcademy.MyAcademyApprenticeItem.remove",this._info.NickName);
            baseAlerFrame = AlertManager.Instance.alert("academySimpleAlert",alertInfo,LayerManager.ALPHA_BLOCKGOUND);
            baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         }
         else
         {
            alertInfo.data = LanguageMgr.GetTranslation("ddt.view.academyCommon.myAcademy.MyAcademyApprenticeItem.removeII",this._info.NickName);
            alerFrame = AlertManager.Instance.alert("academySimpleAlert",alertInfo,LayerManager.ALPHA_BLOCKGOUND);
            alerFrame.addEventListener(FrameEvent.RESPONSE,this.__alerFrameEvent);
         }
      }
      
      protected function __alerFrameEvent(event:FrameEvent) : void
      {
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (event.currentTarget as BaseAlerFrame).dispose();
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submit();
         }
      }
      
      protected function __frameEvent(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (event.currentTarget as BaseAlerFrame).dispose();
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.Gold >= 10000)
               {
                  this.submit();
               }
               else
               {
                  alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  alert.moveEnable = false;
                  alert.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
               }
         }
      }
      
      protected function __quickBuyResponse(event:FrameEvent) : void
      {
         var quickBuy:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         frame.dispose();
         if(Boolean(frame.parent))
         {
            frame.parent.removeChild(frame);
         }
         frame = null;
         if(event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            quickBuy = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            quickBuy.itemID = EquipType.GOLD_BOX;
            quickBuy.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(quickBuy,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function submit() : void
      {
         SocketManager.Instance.out.sendAcademyFireMaster(this._info.ID);
      }
      
      private function __onMouseClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerTipManager.show(this._info,this._itemBG.localToGlobal(new Point(0,0)).y);
      }
      
      protected function initComponent() : void
      {
         this._removeGold = 10000;
         this._sexIcon.visible = false;
      }
      
      protected function updateComponent() : void
      {
         this._nameTxt.text = this._info.NickName;
         if(this._nameTxt.text.length > 7)
         {
            this._nameTxt.text = this._nameTxt.text.substr(0,6) + "...";
         }
         if(this._info.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(141,this._info.typeVIP);
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this._nameTxt.text;
            addChild(this._vipName);
            addChild(this._nameTxt);
            PositionUtils.adaptNameStyle(this._info,this._nameTxt,this._vipName);
         }
         else
         {
            addChild(this._nameTxt);
            DisplayUtils.removeDisplay(this._vipName);
         }
         if(this._info.playerState.StateID != PlayerState.OFFLINE)
         {
            this._offLineText.text = LanguageMgr.GetTranslation("tank.view.im.IMFriendList.online");
         }
         else
         {
            this._offLineText.text = this._info.getLastDate().toString() + LanguageMgr.GetTranslation("hours");
         }
         this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
         this._sexIcon.setSex(this._info.Sex);
         if(IMController.Instance.isFriend(this._info.NickName))
         {
            this._addFriend.enable = false;
         }
         else
         {
            this._addFriend.enable = true;
         }
      }
      
      protected function getTimerOvertop() : Boolean
      {
         if(this._info.playerState.StateID != PlayerState.OFFLINE)
         {
            return false;
         }
         var now:Date = TimeManager.Instance.Now();
         var last:Date = this._info.lastDate;
         var ovaertop:Number = (now.valueOf() - last.valueOf()) / 3600000;
         return ovaertop > 72 ? true : false;
      }
      
      public function set isSelect(value:Boolean) : void
      {
      }
      
      public function get isSelect() : Boolean
      {
         return this._isSelect;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._itemBG))
         {
            this._itemBG.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         }
         if(Boolean(this._removeBtn))
         {
            this._removeBtn.removeEventListener(MouseEvent.CLICK,this.__removeClick);
         }
         if(Boolean(this._addFriend))
         {
            this._addFriend.removeEventListener(MouseEvent.CLICK,this.__addFriendClick);
         }
         if(Boolean(this._emailBtn))
         {
            this._emailBtn.removeEventListener(MouseEvent.CLICK,this.__emailBtnClick);
         }
         PlayerManager.Instance.removeEventListener(IMEvent.ADDNEW_FRIEND,this.__addFriend);
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
         }
         if(Boolean(this._offLineText))
         {
            ObjectUtils.disposeObject(this._offLineText);
            this._offLineText = null;
         }
         if(Boolean(this._removeBtn))
         {
            ObjectUtils.disposeObject(this._removeBtn);
            this._removeBtn = null;
         }
         if(Boolean(this._itemBG))
         {
            ObjectUtils.disposeObject(this._itemBG);
            this._itemBG = null;
         }
         if(Boolean(this._line11))
         {
            ObjectUtils.disposeObject(this._line11);
            this._line11 = null;
         }
         if(Boolean(this._line22))
         {
            ObjectUtils.disposeObject(this._line22);
            this._line22 = null;
         }
         if(Boolean(this._line33))
         {
            ObjectUtils.disposeObject(this._line33);
            this._line33 = null;
         }
         if(Boolean(this._line44))
         {
            ObjectUtils.disposeObject(this._line44);
            this._line44 = null;
         }
         if(Boolean(this._levelIcon))
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(Boolean(this._sexIcon))
         {
            ObjectUtils.disposeObject(this._sexIcon);
            this._sexIcon = null;
         }
         if(Boolean(this._addFriend))
         {
            ObjectUtils.disposeObject(this._addFriend);
            this._addFriend = null;
         }
         if(Boolean(this._emailBtn))
         {
            ObjectUtils.disposeObject(this._emailBtn);
            this._emailBtn = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

