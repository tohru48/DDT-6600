package game.view.playerThumbnail
{
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.BitmapManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.LevelTipInfo;
   import ddt.view.tips.MarriedTip;
   import ddt.view.tips.PetTip;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import game.GameManager;
   import game.model.Player;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   [Event(name="playerThumbnailEvent",type="flash.events.Event")]
   public class PlayerThumbnail extends Sprite implements Disposeable, ITipedDisplay
   {
      
      private var _info:Player;
      
      private var _headFigure:HeadFigure;
      
      private var _blood:BloodItem;
      
      private var _bg:Bitmap;
      
      private var _fore:Bitmap;
      
      private var _shiner:IEffect;
      
      private var _selectShiner:IEffect;
      
      private var _digitalbg:Bitmap;
      
      private var _smallPlayerFP:FilterFrameText;
      
      private var lightingFilter:BitmapFilter;
      
      private var _marryTip:MarriedTip;
      
      private var _dirct:int;
      
      private var _vip:DisplayObject;
      
      private var _bitmapMgr:BitmapManager;
      
      private var _routeBtn:BaseButton;
      
      private var _effectTarget:Shape;
      
      private var _petTip:PetTip;
      
      private var _isShowTip:Boolean;
      
      private var _hpPercentTxt:FilterFrameText;
      
      private var _trusteeshipIcon:ScaleBitmapImage;
      
      private var _waitingIcon:Bitmap;
      
      private var _actionIcon:Bitmap;
      
      private var _levelTipInfo:LevelTipInfo;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      public function PlayerThumbnail(info:Player, dirct:int, showTip:Boolean = true)
      {
         super();
         this._info = info;
         this._dirct = dirct;
         this._isShowTip = showTip;
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back");
         addChild(this._bg);
         this._effectTarget = new Shape();
         addChild(this._effectTarget);
         PositionUtils.setPos(this._effectTarget,"asset.game.smallplayer.effectPos");
         this._headFigure = new HeadFigure(36,36,this._info);
         this._headFigure.y = 3;
         addChild(this._headFigure);
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._blood = new BloodItem(this._info.blood,this._info.maxBlood,this._info.team);
         }
         else
         {
            this._blood = new BloodItem(this._info.blood,this._info.maxBlood);
         }
         this._blood.y = 43;
         addChild(this._blood);
         this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
         this._fore.y = 1;
         this._fore.x = 1;
         addChild(this._fore);
         this._digitalbg = ComponentFactory.Instance.creatBitmap("asset.game.digitalbg");
         this._digitalbg.visible = false;
         addChild(this._digitalbg);
         PositionUtils.setPos(this._digitalbg,"asset.game.smallplayer.digitalbgPos");
         this._smallPlayerFP = ComponentFactory.Instance.creatComponentByStylename("wishView.smallplayerFightPower");
         this._smallPlayerFP.visible = false;
         addChild(this._smallPlayerFP);
         this._routeBtn = ComponentFactory.Instance.creatComponentByStylename("core.thumbnail.selectBtn");
         this._routeBtn.visible = false;
         addChild(this._routeBtn);
         if(this._info.playerInfo.IsVIP)
         {
            this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
            this._vip = this._bitmapMgr.creatBitmapShape("asset.game.smallplayer.vip");
            addChild(this._vip);
         }
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
         {
            this._hpPercentTxt = ComponentFactory.Instance.creatComponentByStylename("game.view.thumbnail.hpPercentTxt");
            this._hpPercentTxt.text = int((this._info.blood < 0 ? 0 : this._info.blood) * 100 / this._info.maxBlood) + "%";
            addChild(this._hpPercentTxt);
         }
         if(this._dirct == -1)
         {
            this._headFigure.scaleX = -this._headFigure.scaleX;
            this._headFigure.x = 42;
            if(Boolean(this._vip))
            {
               PositionUtils.setPos(this._vip,"asset.game.smallplayer.vipPos1");
            }
         }
         else
         {
            this._headFigure.x = 4;
            if(Boolean(this._vip))
            {
               PositionUtils.setPos(this._vip,"asset.game.smallplayer.vipPos2");
            }
         }
         this._shiner = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this,"asset.gameII.thumbnailShineAsset");
         this._selectShiner = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._effectTarget,"asset.gameIII.thumbnailShineSelect");
         if(Boolean(this._info.playerInfo.SpouseName))
         {
            this._marryTip = new MarriedTip();
            this._marryTip.tipData = {
               "nickName":this._info.playerInfo.SpouseName,
               "gender":this._info.playerInfo.Sex
            };
         }
         var currentPet:PetInfo = this._info.playerInfo.currentPet;
         if(Boolean(currentPet))
         {
            this._petTip = ComponentFactory.Instance.creatComponentByStylename("core.PetTip");
            this._petTip.tipData = {
               "petName":currentPet.Name,
               "petLevel":currentPet.Level,
               "petIconUrl":PetBagController.instance().getPicStrByLv(currentPet)
            };
         }
         this._trusteeshipIcon = ComponentFactory.Instance.creatComponentByStylename("game.smallplayer.trusteeship");
         this._waitingIcon = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.waitingStatus");
         this._waitingIcon.visible = false;
         this._actionIcon = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.actionStatus");
         this._actionIcon.visible = false;
         addChild(this._waitingIcon);
         addChild(this._actionIcon);
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            this.__fightStatusChange(null);
         }
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM)
         {
            this.__fightStatusChange(null);
         }
         this.createLevelTip();
         buttonMode = true;
         this.setUpLintingFilter();
      }
      
      public function get info() : PlayerInfo
      {
         return this._info.playerInfo;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      private function createLevelTip() : void
      {
         if(this._isShowTip)
         {
            this.tipStyle = "core.SmallPlayerTips";
            this.tipDirctions = "7";
            this.tipGapV = 10;
            this.tipGapH = 10;
         }
         var info:LevelTipInfo = new LevelTipInfo();
         info.enableTip = true;
         info.Battle = this._info.playerInfo.FightPower;
         info.Level = this._info.playerInfo.Grade;
         info.Repute = this._info.playerInfo.Repute;
         info.Total = this._info.playerInfo.TotalCount;
         info.Win = this._info.playerInfo.WinCount;
         info.exploit = this._info.playerInfo.Offer;
         info.team = this._info.team;
         info.nickName = this._info.playerInfo.NickName;
         this.tipData = info;
         ShowTipManager.Instance.addTip(this);
      }
      
      protected function overHandler(evt:MouseEvent) : void
      {
         var tip:ITip = null;
         var tip2:ITip = null;
         this.filters = [this.lightingFilter];
         if(Boolean(this._marryTip) && this._isShowTip)
         {
            this._marryTip.visible = true;
            LayerManager.Instance.addToLayer(this._marryTip,LayerManager.GAME_DYNAMIC_LAYER);
            tip = ShowTipManager.Instance.getTipInstanceByStylename(this.tipStyle);
            this._marryTip.x = tip.x;
            this._marryTip.y = tip.y + tip.height;
         }
         if(Boolean(this._petTip) && this._isShowTip)
         {
            this._petTip.visible = true;
            LayerManager.Instance.addToLayer(this._petTip,LayerManager.GAME_DYNAMIC_LAYER);
            tip2 = ShowTipManager.Instance.getTipInstanceByStylename(this.tipStyle);
            this._petTip.x = tip2.x + tip2.width;
            this._petTip.y = tip2.y;
         }
      }
      
      protected function outHandler(evt:MouseEvent) : void
      {
         this.filters = null;
         if(Boolean(this._marryTip) && this._isShowTip)
         {
            this._marryTip.visible = false;
         }
         if(Boolean(this._petTip) && this._isShowTip)
         {
            this._petTip.visible = false;
         }
      }
      
      protected function clickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.removeTipTemp();
         dispatchEvent(new Event("playerThumbnailEvent"));
      }
      
      private function removeTipTemp() : void
      {
         if(Boolean(this._marryTip))
         {
            this._marryTip.visible = false;
         }
         if(Boolean(this._petTip))
         {
            this._petTip.visible = false;
         }
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      public function recoverTip() : void
      {
         SoundManager.instance.play("008");
         ShowTipManager.Instance.addTip(this);
         addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      private function initEvents() : void
      {
         this._info.addEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
         this._info.addEventListener(LivingEvent.DIE,this.__die);
         this._info.addEventListener(LivingEvent.REVIVE,this.__revive);
         this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__shineChange);
         this._info.addEventListener(LivingEvent.FIGHTPOWER_CHANGE,this.__setSmallFP);
         this._info.addEventListener(LivingEvent.WISHSELECT_CHANGE,this.__setShiner);
         this._info.playerInfo.addEventListener(GameEvent.TRUSTEESHIP_CHANGE,this.__trusteeshipChange);
         this._info.playerInfo.addEventListener(GameEvent.FIGHT_STATUS_CHANGE,this.__fightStatusChange);
         this._routeBtn.addEventListener(MouseEvent.CLICK,this.__routeLine);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         if(!(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM))
         {
            addEventListener(MouseEvent.CLICK,this.clickHandler);
         }
      }
      
      private function __playerChange(e:CrazyTankSocketEvent) : void
      {
         this._routeBtn.visible = false;
         this._smallPlayerFP.visible = false;
         this._digitalbg.visible = false;
         this._selectShiner.stop();
      }
      
      private function __routeLine(event:MouseEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.WISH_SELECT,this._info.LivingID));
      }
      
      private function setUpLintingFilter() : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([1,0,0,0,25]);
         matrix = matrix.concat([0,1,0,0,25]);
         matrix = matrix.concat([0,0,1,0,25]);
         matrix = matrix.concat([0,0,0,1,0]);
         this.lightingFilter = new ColorMatrixFilter(matrix);
      }
      
      private function __setSmallFP(event:LivingEvent) : void
      {
         this._routeBtn.visible = true;
         if(this._info.fightPower < 100 && this._info.fightPower > 0)
         {
            this._smallPlayerFP.text = String(this._info.fightPower);
            this._digitalbg.visible = true;
            this._smallPlayerFP.visible = true;
         }
         else
         {
            this._smallPlayerFP.text = "";
            this._digitalbg.visible = false;
            this._smallPlayerFP.visible = false;
         }
      }
      
      private function __setShiner(event:LivingEvent) : void
      {
         if(this._info.currentSelectId == this._info.LivingID)
         {
            this._selectShiner.play();
         }
         else
         {
            this._selectShiner.stop();
         }
      }
      
      private function __shineChange(evt:LivingEvent) : void
      {
         if(Boolean(this._info) && this._info.isAttacking)
         {
            this._shiner.play();
         }
         else
         {
            this._shiner.stop();
         }
      }
      
      private function __trusteeshipChange(event:GameEvent) : void
      {
         if(this._trusteeshipIcon == null)
         {
            return;
         }
         var flag:Boolean = event.data as Boolean;
         if(flag)
         {
            addChild(this._trusteeshipIcon);
         }
         else if(this.contains(this._trusteeshipIcon))
         {
            removeChild(this._trusteeshipIcon);
         }
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            this.__fightStatusChange(null);
         }
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM)
         {
            this.__fightStatusChange(null);
         }
      }
      
      private function __fightStatusChange(event:GameEvent) : void
      {
         if(!this._waitingIcon || !this._actionIcon)
         {
            return;
         }
         if(this._info.playerInfo.isTrusteeship)
         {
            this._waitingIcon.visible = false;
            this._actionIcon.visible = false;
         }
         else if(this._info.playerInfo.fightStatus == 0)
         {
            this._waitingIcon.visible = true;
            this._actionIcon.visible = false;
         }
         else
         {
            this._waitingIcon.visible = false;
            this._actionIcon.visible = true;
         }
      }
      
      override public function set x(value:Number) : void
      {
         super.x = value;
         this.__shineChange(null);
      }
      
      override public function set y(value:Number) : void
      {
         super.y = value;
         this.__shineChange(null);
      }
      
      private function __die(evt:LivingEvent) : void
      {
         if(Boolean(this._headFigure))
         {
            this._headFigure.gray();
         }
         if(Boolean(this._blood) && Boolean(this._blood.parent))
         {
            this._blood.parent.removeChild(this._blood);
         }
         if(Boolean(this._waitingIcon))
         {
            this._waitingIcon.alpha = 0;
         }
         if(Boolean(this._actionIcon))
         {
            this._actionIcon.alpha = 0;
         }
      }
      
      private function __revive(evt:LivingEvent) : void
      {
         if(Boolean(this._headFigure))
         {
            this._headFigure.reset();
         }
         if(Boolean(this._blood))
         {
            addChild(this._blood);
         }
         if(Boolean(this._waitingIcon))
         {
            this._waitingIcon.alpha = 1;
         }
         if(Boolean(this._actionIcon))
         {
            this._actionIcon.alpha = 1;
         }
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._info))
         {
            this._info.removeEventListener(LivingEvent.FIGHTPOWER_CHANGE,this.__setSmallFP);
            this._info.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
            this._info.removeEventListener(LivingEvent.DIE,this.__die);
            this._info.removeEventListener(LivingEvent.REVIVE,this.__revive);
            this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__shineChange);
            this._info.removeEventListener(LivingEvent.WISHSELECT_CHANGE,this.__setShiner);
            this._info.playerInfo.removeEventListener(GameEvent.TRUSTEESHIP_CHANGE,this.__trusteeshipChange);
            this._info.playerInfo.removeEventListener(GameEvent.FIGHT_STATUS_CHANGE,this.__fightStatusChange);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this._routeBtn.removeEventListener(MouseEvent.CLICK,this.__routeLine);
      }
      
      private function __updateBlood(evt:LivingEvent) : void
      {
         this._blood.setProgress(this._info.blood,this._info.maxBlood);
         if(Boolean(this._hpPercentTxt))
         {
            this._hpPercentTxt.text = int((this._info.blood < 0 ? 0 : this._info.blood) * 100 / this._info.maxBlood) + "%";
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ShowTipManager.Instance.removeTip(this);
         if(Boolean(this._marryTip) && Boolean(this._marryTip.parent))
         {
            this._marryTip.parent.removeChild(this._marryTip);
         }
         this._marryTip = null;
         ObjectUtils.disposeObject(this._petTip);
         this._petTip = null;
         EffectManager.Instance.removeEffect(this._shiner);
         this._shiner = null;
         EffectManager.Instance.removeEffect(this._selectShiner);
         this._selectShiner = null;
         if(Boolean(this._headFigure))
         {
            this._headFigure.dispose();
         }
         this._headFigure = null;
         if(Boolean(this._blood))
         {
            this._blood.dispose();
         }
         this._blood = null;
         if(Boolean(this._trusteeshipIcon))
         {
            ObjectUtils.disposeObject(this._trusteeshipIcon);
         }
         this._trusteeshipIcon = null;
         ObjectUtils.disposeObject(this._effectTarget);
         this._effectTarget = null;
         ObjectUtils.disposeObject(this._vip);
         this._vip = null;
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         ObjectUtils.disposeObject(this._hpPercentTxt);
         this._hpPercentTxt = null;
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         if(Boolean(this._fore))
         {
            ObjectUtils.disposeObject(this._fore);
            this._fore = null;
         }
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return this._levelTipInfo;
      }
      
      public function set tipData(value:Object) : void
      {
         this._levelTipInfo = value as LevelTipInfo;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirctions = value;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

