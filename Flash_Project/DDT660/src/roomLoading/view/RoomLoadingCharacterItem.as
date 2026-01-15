package roomLoading.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.academyCommon.academyIcon.AcademyIcon;
   import ddt.view.character.BaseLayer;
   import ddt.view.common.DailyLeagueLevel;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import vip.VipController;
   
   public class RoomLoadingCharacterItem extends Sprite implements Disposeable
   {
      
      public static const LOADING_FINISHED:String = "loadingFinished";
      
      protected var _info:RoomPlayer;
      
      protected var _nameTxt:FilterFrameText;
      
      protected var _vipName:GradientText;
      
      public var _perecentageTxt:FilterFrameText;
      
      protected var _okTxt:Bitmap;
      
      protected var _levelIcon:LevelIcon;
      
      protected var _legaueLevel:DailyLeagueLevel;
      
      protected var _vipIcon:VipLevelIcon;
      
      protected var _marriedIcon:MarriedIcon;
      
      protected var _academyIcon:AcademyIcon;
      
      protected var _badge:Badge;
      
      protected var _iconContainer:VBox;
      
      protected var _iconPos:Point;
      
      protected var _loadingArr:Array;
      
      protected var _weapon:DisplayObject;
      
      protected var _displayMc:MovieClip;
      
      protected var _index:int = 1;
      
      protected var _animationFinish:Boolean = false;
      
      public function RoomLoadingCharacterItem($info:RoomPlayer)
      {
         super();
         this._info = $info;
         this.init();
      }
      
      protected function init() : void
      {
         if(this._info.team == RoomPlayer.BLUE_TEAM)
         {
            this._perecentageTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemPercentageBlueTxt");
         }
         else
         {
            this._perecentageTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemPercentageRedTxt");
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
         this._nameTxt.text = this._info.playerInfo.NickName;
         this._perecentageTxt.text = "0%";
         if(RoomManager.Instance.current.type != RoomInfo.FIGHTFOOTBALLTIME_ROOM)
         {
            this._info.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
         }
         this._displayMc = ComponentFactory.Instance.creat("asset.roomloading.displayMC");
         this._displayMc.addEventListener("appeared",this.__onAppeared);
         addChild(this._displayMc);
         this._displayMc.scaleX = this._info.team == RoomPlayer.BLUE_TEAM ? 1 : -1;
         this._displayMc["character"].addChild(this._info.character);
         this._info.character.stopAnimation();
         this._info.character.setShowLight(false);
         addChild(this._perecentageTxt);
         if(this._info.playerInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width,this._info.playerInfo.typeVIP);
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this._nameTxt.text;
            addChild(this._vipName);
         }
         else
         {
            addChild(this._nameTxt);
         }
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.roomLoadingPlayerItem.iconContainer");
         this.initIcons();
      }
      
      protected function __onAppeared(event:Event) : void
      {
         this._animationFinish = true;
      }
      
      public function get isAnimationFinished() : Boolean
      {
         return this._animationFinish;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(val:int) : void
      {
         this._index = val;
      }
      
      public function get displayMc() : DisplayObject
      {
         return this._displayMc;
      }
      
      public function appear(no:String) : void
      {
         this._displayMc.gotoAndPlay("appear" + no);
      }
      
      public function disappear(no:String) : void
      {
         this._displayMc.gotoAndPlay("disappear" + no);
      }
      
      public function addWeapon(small:Boolean, dir:int) : void
      {
         if(Boolean(this._weapon))
         {
            ObjectUtils.disposeObject(this._weapon);
         }
         var weaponItem:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._info.playerInfo.WeaponID);
         var url:String = PathManager.solveGoodsPath(weaponItem.CategoryID,weaponItem.Pic,this._info.playerInfo.Sex == 1,BaseLayer.SHOW,"A","1",weaponItem.Level);
         var smallRect:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.smallWeaponSize");
         var bigRect:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.bigWeaponSize");
         this._weapon = new BitmapLoaderProxy(url,small ? smallRect : bigRect);
         this._weapon.scaleX = dir;
         var team:String = this._info.team == RoomPlayer.BLUE_TEAM ? "blueTeam" : "redTeam";
         if(!small)
         {
            PositionUtils.setPos(this._weapon,"asset.roomLoadingPlayerItem." + team + ".bigWeaponPos");
         }
         else
         {
            PositionUtils.setPos(this._weapon,"asset.roomLoadingPlayerItem." + team + ".smallWeaponPos");
         }
         this._displayMc["character"].addChild(this._weapon);
      }
      
      protected function __onProgress(event:RoomPlayerEvent) : void
      {
         var pos:Point = null;
         this._perecentageTxt.text = String(int(this._info.progress)) + "%";
         if(this._info.progress > 99)
         {
            this._okTxt = ComponentFactory.Instance.creatBitmap("asset.roomLoading.LoadingOK");
            pos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.LoadingOKStartPos");
            TweenMax.from(this._okTxt,0.5,{
               "alpha":0,
               "scaleX":2,
               "scaleY":2,
               "x":pos.x,
               "y":pos.y,
               "ease":Quint.easeIn,
               "onStart":this.finishTxt
            });
            addChild(this._okTxt);
            if(RoomManager.Instance.current.type != RoomInfo.FIGHTFOOTBALLTIME_ROOM)
            {
               this._info.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
            }
            dispatchEvent(new Event(LOADING_FINISHED));
         }
      }
      
      protected function finishTxt() : void
      {
         this._perecentageTxt.text = "100%";
         this.removeTxt();
      }
      
      protected function removeTxt() : void
      {
         if(Boolean(this._perecentageTxt))
         {
            this._perecentageTxt.parent.removeChild(this._perecentageTxt);
         }
      }
      
      protected function initIcons() : void
      {
         this._iconPos = ComponentFactory.Instance.creatCustomObject("roomLoading.CharacterItemIconStartPos");
         if(!this._info.playerInfo.IsVIP)
         {
            this._iconPos = ComponentFactory.Instance.creatCustomObject("roomLoading.CharacterItemIconStartPos2");
         }
         this._levelIcon = new LevelIcon();
         this._levelIcon.setInfo(this._info.playerInfo.Grade,this._info.playerInfo.Repute,this._info.playerInfo.WinCount,this._info.playerInfo.TotalCount,this._info.playerInfo.FightPower,this._info.playerInfo.Offer,true,true,this._info.team);
         PositionUtils.setPos(this._levelIcon,this._iconPos);
         addChild(this._levelIcon);
         this._iconPos.y += 30;
         this._iconPos.x += 3;
         this._vipIcon = new VipLevelIcon();
         if(this._info.playerInfo.ID == PlayerManager.Instance.Self.ID || this._info.playerInfo.IsVIP)
         {
            this._vipIcon = new VipLevelIcon();
            this._vipIcon.setInfo(this._info.playerInfo);
            this._vipIcon.filters = !this._info.playerInfo.IsVIP ? ComponentFactory.Instance.creatFilters("grayFilter") : null;
            this._iconContainer.addChild(this._vipIcon);
         }
         this._marriedIcon = new MarriedIcon();
         if(this._info.playerInfo.SpouseID > 0)
         {
            this._marriedIcon = ComponentFactory.Instance.creatCustomObject("roomLoading.CharacterMarriedIcon");
            this._marriedIcon.tipData = {
               "nickName":this._info.playerInfo.SpouseName,
               "gender":this._info.playerInfo.Sex
            };
            this._iconContainer.addChild(this._marriedIcon);
            this._iconPos.y += 30;
         }
         if(this._info.playerInfo.shouldShowAcademyIcon())
         {
            this._academyIcon = ComponentFactory.Instance.creatCustomObject("roomLoading.CharacterAcademyIcon");
            this._academyIcon.tipData = this._info.playerInfo;
            this._iconContainer.addChild(this._academyIcon);
         }
         if(this._info.playerInfo.ConsortiaID > 0 && this._info.playerInfo.badgeID > 0)
         {
            this._badge = new Badge();
            this._badge.badgeID = this._info.playerInfo.badgeID;
            this._badge.showTip = true;
            this._badge.tipData = this._info.playerInfo.ConsortiaName;
            this._iconContainer.addChild(this._badge);
         }
      }
      
      public function get info() : RoomPlayer
      {
         return this._info;
      }
      
      public function dispose() : void
      {
         if(RoomManager.Instance.current.type != RoomInfo.FIGHTFOOTBALLTIME_ROOM)
         {
            this._info.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
         }
         if(Boolean(this._info.character) && Boolean(this._info.character.parent))
         {
            this._info.character.parent.removeChild(this._info.character);
         }
         TweenMax.killTweensOf(this._okTxt);
         ObjectUtils.disposeObject(this._nameTxt);
         ObjectUtils.disposeObject(this._vipName);
         ObjectUtils.disposeObject(this._perecentageTxt);
         ObjectUtils.disposeObject(this._okTxt);
         ObjectUtils.disposeObject(this._levelIcon);
         if(Boolean(this._legaueLevel))
         {
            ObjectUtils.disposeObject(this._legaueLevel);
            ShowTipManager.Instance.removeTip(this._legaueLevel);
         }
         ObjectUtils.disposeObject(this._vipIcon);
         ObjectUtils.disposeObject(this._marriedIcon);
         ObjectUtils.disposeObject(this._academyIcon);
         ObjectUtils.disposeObject(this._badge);
         ObjectUtils.disposeObject(this._iconContainer);
         if(Boolean(this._displayMc))
         {
            this._displayMc.removeEventListener("appeared",this.__onAppeared);
         }
         ObjectUtils.disposeObject(this._displayMc);
         this._displayMc = null;
         this._info = null;
         this._nameTxt = null;
         this._vipName = null;
         this._perecentageTxt = null;
         this._okTxt = null;
         this._levelIcon = null;
         this._legaueLevel = null;
         this._vipIcon = null;
         this._marriedIcon = null;
         this._academyIcon = null;
         this._iconPos = null;
         this._loadingArr = null;
         this._badge = null;
         this._iconContainer = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function removePerecentageTxt() : void
      {
         if(Boolean(this._perecentageTxt))
         {
            ObjectUtils.disposeObject(this._perecentageTxt);
         }
         this._perecentageTxt = null;
      }
   }
}

