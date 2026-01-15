package hall.hallInfo.playerInfo
{
   import bagAndInfo.energyData.EnergyData;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import vip.VipController;
   
   public class PlayerHead extends Sprite
   {
      
      private static var HeadWidth:int = 120;
      
      private static var HeadHeight:int = 103;
      
      private var _headLoader:SceneCharacterLoaderHead;
      
      private var _headBitmap:Bitmap;
      
      private var _levelIcon:LevelIcon;
      
      private var _selfInfo:SelfInfo;
      
      private var _energyProgress:EnergyProgress;
      
      private var _energyAddBtn:SimpleBitmapButton;
      
      private var _energyData:EnergyData;
      
      private var _nickNameText:FilterFrameText;
      
      private var _vipName:GradientText;
      
      public function PlayerHead()
      {
         super();
         this._selfInfo = PlayerManager.Instance.Self;
         this.initView();
         this.loadHead();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._energyAddBtn.addEventListener(MouseEvent.CLICK,this.__addEnergyHandler);
         this._selfInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onUpdateGrade);
         PlayerManager.Instance.addEventListener(PlayerManager.UPDATEENERGY,this.__updateEnergy);
      }
      
      protected function __onUpdateGrade(event:PlayerPropertyEvent) : void
      {
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.setInfo(this._selfInfo.Grade,this._selfInfo.Repute,this._selfInfo.WinCount,this._selfInfo.TotalCount,this._selfInfo.FightPower,this._selfInfo.Offer,true,false);
         }
      }
      
      public function loadHead() : void
      {
         if(Boolean(this._headLoader))
         {
            this._headLoader.dispose();
            this._headLoader = null;
         }
         this._headLoader = new SceneCharacterLoaderHead(PlayerManager.Instance.Self);
         this._headLoader.load(this.headLoaderCallBack);
      }
      
      private function initView() : void
      {
         this._levelIcon = new LevelIcon();
         this._levelIcon.setInfo(this._selfInfo.Grade,this._selfInfo.Repute,this._selfInfo.WinCount,this._selfInfo.TotalCount,this._selfInfo.FightPower,this._selfInfo.Offer,true,false);
         PositionUtils.setPos(this._levelIcon,"hall.playerInfoview.levelIconPos");
         addChild(this._levelIcon);
         this._energyAddBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.energyAddBtn");
         this._energyAddBtn.tipData = LanguageMgr.GetTranslation("tank.view.energy.addtip");
         if(!ServerConfigManager.instance.isMissionEnergyEnable)
         {
            this._energyAddBtn.visible = false;
         }
         this._nickNameText = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.nickNameText");
         this._nickNameText.text = this._selfInfo.NickName;
         addChild(this._nickNameText);
         if(this._selfInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(104,this._selfInfo.typeVIP);
            this._vipName.textSize = 16;
            this._vipName.x = this._nickNameText.x;
            this._vipName.y = this._nickNameText.y - 2;
            this._vipName.text = this._selfInfo.NickName;
            addChild(this._vipName);
         }
         PositionUtils.adaptNameStyle(this._selfInfo,this._nickNameText,this._vipName);
      }
      
      private function __updateEnergy(e:Event) : void
      {
         if(this._energyProgress != null)
         {
         }
      }
      
      protected function __addEnergyHandler(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._energyData = PlayerManager.Instance.energyData[PlayerManager.Instance.Self.buyEnergyCount + 1];
         if(!this._energyData)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.energy.cannotbuyEnergy"));
            return;
         }
         var alertAsk:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.view.energy.buyEnergy",this._energyData.Money,this._energyData.Energy),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,AlertManager.SELECTBTN);
         alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
      }
      
      protected function __alertBuyEnergy(event:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
                  ObjectUtils.disposeObject(event.currentTarget);
                  return;
               }
               if(PlayerManager.Instance.Self.energy < 300 && PlayerManager.Instance.Self.energy > 250)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.energy.energyEnough"));
                  frame.dispose();
                  return;
               }
               if(frame.isBand)
               {
                  if(!this.checkMoney(true))
                  {
                     frame.dispose();
                     alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                     alertFrame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                     return;
                  }
               }
               else if(!this.checkMoney(false))
               {
                  frame.dispose();
                  alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               SocketManager.Instance.out.sendBuyEnergy(frame.isBand);
               break;
         }
         frame.dispose();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function onResponseHander(e:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.checkMoney(false))
            {
               alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            SocketManager.Instance.out.sendBuyEnergy(false);
         }
         e.currentTarget.dispose();
      }
      
      private function checkMoney(isBand:Boolean) : Boolean
      {
         if(isBand)
         {
            if(PlayerManager.Instance.Self.BandMoney < this._energyData.Money)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < this._energyData.Money)
         {
            return false;
         }
         return true;
      }
      
      private function headLoaderCallBack(headLoader:SceneCharacterLoaderHead, isAllLoadSucceed:Boolean = true) : void
      {
         var rectangle:Rectangle = null;
         var headBmp:BitmapData = null;
         if(Boolean(headLoader))
         {
            if(!this._headBitmap)
            {
               this._headBitmap = new Bitmap();
            }
            rectangle = new Rectangle(0,0,HeadWidth,HeadHeight);
            headBmp = new BitmapData(HeadWidth,HeadHeight,true,0);
            headBmp.copyPixels(headLoader.getContent()[0] as BitmapData,rectangle,new Point(0,0));
            this._headBitmap.bitmapData = headBmp;
            headLoader.dispose();
            this._headBitmap.rotationY = 180;
            addChildAt(this._headBitmap,0);
         }
      }
      
      private function removeEvent() : void
      {
         this._energyAddBtn.removeEventListener(MouseEvent.CLICK,this.__addEnergyHandler);
         this._selfInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onUpdateGrade);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._headLoader))
         {
            this._headLoader.dispose();
            this._headLoader = null;
         }
         if(Boolean(this._headBitmap))
         {
            this._headBitmap.bitmapData.dispose();
            this._headBitmap = null;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(Boolean(this._energyProgress))
         {
            this._energyProgress.dispose();
            this._energyProgress = null;
         }
         if(Boolean(this._energyAddBtn))
         {
            this._energyAddBtn.dispose();
            this._energyAddBtn = null;
         }
         if(Boolean(this._nickNameText))
         {
            this._nickNameText.dispose();
            this._nickNameText = null;
         }
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
            this._vipName = null;
         }
      }
   }
}

