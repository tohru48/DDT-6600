package ddt.view.academyCommon.recommend
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import im.IMController;
   import vip.VipController;
   
   public class RecommendPlayerCellView extends Sprite implements Disposeable, ITipedDisplay
   {
      
      protected var _cellBg:Bitmap;
      
      protected var _nameTxt:FilterFrameText;
      
      protected var _vipName:GradientText;
      
      protected var _guildTxt:FilterFrameText;
      
      protected var _masterHonor:ScaleFrameImage;
      
      protected var _masterHonorText:GradientText;
      
      protected var _levelIcon:LevelIcon;
      
      protected var _vipIcon:VipLevelIcon;
      
      protected var _marriedIcon:MarriedIcon;
      
      protected var _badge:Badge;
      
      protected var _player:RoomCharacter;
      
      protected var _characteContainer:Sprite;
      
      protected var _iconContainer:VBox;
      
      protected var _recommendBtn:TextButton;
      
      protected var _info:AcademyPlayerInfo;
      
      protected var _isSelect:Boolean;
      
      protected var _tipStyle:String;
      
      protected var _tipDirctions:String;
      
      protected var _tipData:Object;
      
      protected var _tipGapH:int;
      
      protected var _tipGapV:int;
      
      protected var _chat:BaseButton;
      
      public function RecommendPlayerCellView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._cellBg = ComponentFactory.Instance.creatBitmap("academyCommon.cellViewPlayerBg");
         addChild(this._cellBg);
         this._characteContainer = new Sprite();
         addChild(this._characteContainer);
         this._masterHonor = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.masterHonor");
         this._masterHonor.visible = false;
         addChild(this._masterHonor);
         this._guildTxt = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.guildTxt");
         addChild(this._guildTxt);
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.RecommendPlayerCellView.iconContainer");
         addChild(this._iconContainer);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("academy.RecommendPlayerCellView.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         addChild(this._levelIcon);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.nameTxt");
         this._chat = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.masterChat");
         addChild(this._chat);
         this._tipStyle = "ddt.view.tips.OneLineTip";
         this._tipDirctions = "0,4,5";
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipData = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.RecommendPlayerCellView.tips");
         ShowTipManager.Instance.addTip(this);
         this.initRecommendBtn();
      }
      
      protected function initRecommendBtn() : void
      {
         this._recommendBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.master");
         this._recommendBtn.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.RecommendPlayerCellView.master");
         addChild(this._recommendBtn);
      }
      
      protected function initEvent() : void
      {
         this._recommendBtn.addEventListener(MouseEvent.CLICK,this.__recommendBtn);
         this._chat.addEventListener(MouseEvent.CLICK,this.__chatHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__onOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
         this._characteContainer.addEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      protected function __chatHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.alertPrivateFrame(this._info.info.ID);
      }
      
      private function __onClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerInfoViewControl.viewByID(this.info.info.ID,PlayerManager.Instance.Self.ZoneID);
      }
      
      private function __onOut(event:MouseEvent) : void
      {
         if(this._isSelect)
         {
         }
      }
      
      private function __onOver(event:MouseEvent) : void
      {
         if(this._isSelect)
         {
         }
      }
      
      public function set isSelect(value:Boolean) : void
      {
         this._isSelect = value;
         if(this._isSelect)
         {
         }
      }
      
      public function get isSelect() : Boolean
      {
         return this._isSelect;
      }
      
      private function createCharacter() : void
      {
         this._player = CharactoryFactory.createCharacter(this._info.info,"room") as RoomCharacter;
         this._player.showGun = true;
         this._player.show(true,-1);
         PositionUtils.setPos(this._player,"academy.RecommendPlayerCellView.playerPos");
         this._characteContainer.addChild(this._player as DisplayObject);
      }
      
      protected function __recommendBtn(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!AcademyManager.Instance.compareState(this._info.info,PlayerManager.Instance.Self))
         {
            return;
         }
         if(AcademyManager.Instance.isFreezes(true))
         {
            AcademyFrameManager.Instance.showAcademyRequestMasterFrame(this._info.info);
         }
      }
      
      private function __characterComplete(event:Event) : void
      {
         this._player.removeEventListener(Event.COMPLETE,this.__characterComplete);
         PositionUtils.setPos(this._player,"academy.RecommendPlayerCellView.playerPos");
         this._characteContainer.addChild(this._player as DisplayObject);
      }
      
      private function update() : void
      {
         var player:PlayerInfo = this._info.info;
         this._nameTxt.text = player.NickName;
         this.checkVip(player);
         this._guildTxt.text = player.ConsortiaName;
         var masterLevel:int = AcademyManager.Instance.getMasterHonorLevel(player.graduatesCount);
         if(masterLevel != 0)
         {
            this._masterHonor.visible = true;
            this._masterHonor.setFrame(masterLevel);
         }
         else
         {
            this._masterHonor.visible = false;
         }
         this.createCharacter();
         this.updateIcon();
      }
      
      protected function checkVip(player:PlayerInfo) : void
      {
         if(player.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(142,player.typeVIP);
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this._nameTxt.text;
            addChild(this._vipName);
         }
         addChild(this._nameTxt);
         PositionUtils.adaptNameStyle(player,this._nameTxt,this._vipName);
      }
      
      protected function updateIcon() : void
      {
         var player:PlayerInfo = this._info.info;
         this._levelIcon.setInfo(player.Grade,player.Repute,player.WinCount,player.TotalCount,player.FightPower,player.Offer,true,false);
         if(player.IsVIP)
         {
            if(this._vipIcon == null)
            {
               this._vipIcon = ComponentFactory.Instance.creatCustomObject("academy.RecommendPlayerCellView.VipIcon");
               this._vipIcon.setInfo(player);
               this._iconContainer.addChild(this._vipIcon);
            }
         }
         else if(Boolean(this._vipIcon))
         {
            this._vipIcon.dispose();
            this._vipIcon = null;
         }
         if(player.SpouseID > 0)
         {
            if(this._marriedIcon == null)
            {
               this._marriedIcon = ComponentFactory.Instance.creatCustomObject("academy.RecommendPlayerCellView.MarriedIcon");
               this._iconContainer.addChild(this._marriedIcon);
            }
            this._marriedIcon.tipData = {
               "nickName":player.SpouseName,
               "gender":player.Sex
            };
         }
         else
         {
            if(this._marriedIcon != null)
            {
               this._marriedIcon.dispose();
            }
            this._marriedIcon = null;
         }
         if(player.badgeID > 0)
         {
            if(this._badge == null)
            {
               this._badge = new Badge();
               this._badge.showTip = true;
               this._badge.badgeID = player.badgeID;
               this._badge.tipData = player.ConsortiaName;
               this._iconContainer.addChild(this._badge);
            }
         }
         else
         {
            ObjectUtils.disposeObject(this._badge);
            this._badge = null;
         }
      }
      
      public function set info(value:AcademyPlayerInfo) : void
      {
         this._info = value;
         this.update();
      }
      
      public function get info() : AcademyPlayerInfo
      {
         return this._info;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value;
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
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
         if(Boolean(this._cellBg))
         {
            ObjectUtils.disposeObject(this._cellBg);
            this._cellBg = null;
         }
         if(Boolean(this._recommendBtn))
         {
            this._recommendBtn.removeEventListener(MouseEvent.CLICK,this.__recommendBtn);
            ObjectUtils.disposeObject(this._recommendBtn);
            this._recommendBtn = null;
         }
         if(Boolean(this._masterHonor))
         {
            ObjectUtils.disposeObject(this._masterHonor);
            this._masterHonor = null;
         }
         if(Boolean(this._chat))
         {
            this._chat.removeEventListener(MouseEvent.CLICK,this.__chatHandler);
            ObjectUtils.disposeObject(this._chat);
            this._chat = null;
         }
         if(Boolean(this._nameTxt))
         {
            this._nameTxt.dispose();
            this._nameTxt = null;
         }
         if(Boolean(this._guildTxt))
         {
            this._guildTxt.dispose();
            this._guildTxt = null;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(Boolean(this._player))
         {
            this._player.dispose();
            this._player = null;
         }
         if(Boolean(this._characteContainer) && Boolean(this._characteContainer.parent))
         {
            this._characteContainer.removeEventListener(MouseEvent.CLICK,this.__onClick);
            this._characteContainer.parent.removeChild(this._characteContainer);
            this._characteContainer = null;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(Boolean(this._vipIcon))
         {
            this._vipIcon.dispose();
            this._vipIcon = null;
         }
         if(Boolean(this._marriedIcon))
         {
            ObjectUtils.disposeObject(this._marriedIcon);
         }
         this._marriedIcon = null;
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         ObjectUtils.disposeObject(this._iconContainer);
         this._iconContainer = null;
         ShowTipManager.Instance.removeTip(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

