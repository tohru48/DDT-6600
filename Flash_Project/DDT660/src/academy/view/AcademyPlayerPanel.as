package academy.view
{
   import academy.AcademyController;
   import academy.AcademyEvent;
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
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
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import im.IMController;
   import vip.VipController;
   
   public class AcademyPlayerPanel extends Sprite implements Disposeable
   {
      
      private var _academyTitle:Bitmap;
      
      private var _data:Bitmap;
      
      private var _online:Bitmap;
      
      private var _courtshipBtn:TextButton;
      
      private var _talkBtn:TextButton;
      
      private var _equipBtn:TextButton;
      
      private var _addBtn:TextButton;
      
      private var _requestMasterBtn:SimpleBitmapButton;
      
      private var _requestApprenticeBtn:SimpleBitmapButton;
      
      private var _leftBg:Scale9CornerImage;
      
      private var _textLableBg:ScaleFrameImage;
      
      private var _playerNameTxt:FilterFrameText;
      
      private var _guildNameTxt:FilterFrameText;
      
      private var _graduatesCountTxt:FilterFrameText;
      
      private var _honourOfMasterTxt:FilterFrameText;
      
      private var _fightPowerTxt:FilterFrameText;
      
      private var _winProbabilityTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _bg:MovieClip;
      
      private var _introductionTxt:TextArea;
      
      private var _levelIcon:LevelIcon;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _marriedIcon:MarriedIcon;
      
      private var _info:AcademyPlayerInfo;
      
      private var _controller:AcademyController;
      
      private var _player:RoomCharacter;
      
      private var _characteContainer:Sprite;
      
      public function AcademyPlayerPanel(controller:AcademyController)
      {
         super();
         this._controller = controller;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._academyTitle = ComponentFactory.Instance.creatBitmap("asset.ddtacademy.academyTitleAsset");
         addChild(this._academyTitle);
         this._leftBg = ComponentFactory.Instance.creatComponentByStylename("asset.AcademyPlayerPanel.leftBg");
         addChild(this._leftBg);
         this._bg = ClassUtils.CreatInstance("asset.ddtacademy.academyleftBg2") as MovieClip;
         PositionUtils.setPos(this._bg,"ddtacademy.academyleftBg2Pos");
         addChild(this._bg);
         this._textLableBg = ComponentFactory.Instance.creat("academy.ddtAcademyPlayerPanel.textLableBg");
         this._textLableBg.setFrame(1);
         addChild(this._textLableBg);
         this._data = ComponentFactory.Instance.creatBitmap("asset.ddtacademy.dataImage");
         addChild(this._data);
         this._talkBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyPlayerPanel.talkBtn");
         this._talkBtn.text = LanguageMgr.GetTranslation("civil.leftview.talkName");
         addChild(this._talkBtn);
         this._equipBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyPlayerPanel.equipBtn");
         this._equipBtn.text = LanguageMgr.GetTranslation("civil.leftview.equipName");
         addChild(this._equipBtn);
         this._addBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyPlayerPanel.addBtn");
         this._addBtn.text = LanguageMgr.GetTranslation("civil.leftview.addName");
         addChild(this._addBtn);
         this._requestMasterBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyPlayerPanel.requestMasterBtn");
         addChild(this._requestMasterBtn);
         this._requestApprenticeBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyPlayerPanel.requestApprenticeBtn");
         addChild(this._requestApprenticeBtn);
         this._playerNameTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyPlayerPanel.PlayerNameII");
         this._guildNameTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyPlayerPanel.guildName");
         addChild(this._guildNameTxt);
         this._graduatesCountTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyPlayerPanel.repute");
         addChild(this._graduatesCountTxt);
         this._winProbabilityTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyPlayerPanel.winProbabilityTxt");
         addChild(this._winProbabilityTxt);
         this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyPlayerPanel.fightPowerTxt");
         addChild(this._fightPowerTxt);
         this._honourOfMasterTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyPlayerPanel.honourOfMasterTxt");
         addChild(this._honourOfMasterTxt);
         this._courtshipBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyPlayerPanel.courtshipBtn");
         this._courtshipBtn.text = LanguageMgr.GetTranslation("civil.leftview.courtshipName");
         if(PathManager.solveChurchEnable())
         {
            addChild(this._courtshipBtn);
         }
         else
         {
            this._equipBtn.y = this._courtshipBtn.y;
            this._addBtn.x = this._equipBtn.x;
         }
         this._online = ComponentFactory.Instance.creatBitmap("asset.academy.online");
         this._introductionTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyPlayerPanel.IntroductionText");
         this._characteContainer = new Sprite();
         addChild(this._characteContainer);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("academy.AcademyPlayerPanel.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         addChild(this._levelIcon);
      }
      
      private function initEvent() : void
      {
         this._controller.addEventListener(AcademyEvent.ACADEMY_PLAYER_CHANGE,this.__playerChange);
         this._courtshipBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._talkBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._equipBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._addBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._requestMasterBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._requestApprenticeBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._controller.removeEventListener(AcademyEvent.ACADEMY_PLAYER_CHANGE,this.__playerChange);
         this._courtshipBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._talkBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._equipBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._requestMasterBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._requestApprenticeBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
      }
      
      private function __onBtnClick(event:MouseEvent) : void
      {
         if(this._info == null)
         {
            return;
         }
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._courtshipBtn:
               ChurchManager.instance.sendValidateMarry(this._info.info);
               break;
            case this._talkBtn:
               ChatManager.Instance.privateChatTo(this._info.info.NickName);
               break;
            case this._equipBtn:
               PlayerInfoViewControl.viewByID(this._info.info.ID,PlayerManager.Instance.Self.ZoneID);
               break;
            case this._addBtn:
               IMController.Instance.addFriend(this._info.info.NickName);
               break;
            case this._requestMasterBtn:
               if(AcademyManager.Instance.compareState(this._info.info,PlayerManager.Instance.Self))
               {
                  AcademyFrameManager.Instance.showAcademyRequestMasterFrame(this._info.info);
               }
               break;
            case this._requestApprenticeBtn:
               if(PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.APPRENTICE_STATE && AcademyManager.Instance.compareState(this._info.info,PlayerManager.Instance.Self))
               {
                  AcademyFrameManager.Instance.showAcademyRequestApprenticeFrame(this._info.info);
               }
         }
      }
      
      private function __playerChange(event:AcademyEvent) : void
      {
         this._info = this._controller.model.info;
         this.update();
      }
      
      private function createCharacter() : void
      {
         if(Boolean(this._player))
         {
            this._player.dispose();
            this._player = null;
         }
         this._player = CharactoryFactory.createCharacter(this._info.info,"room") as RoomCharacter;
         this._player.addEventListener(Event.COMPLETE,this.__characterComplete);
         this._player.show(true,-1);
      }
      
      private function update() : void
      {
         if(this._controller.model.state)
         {
            this._requestApprenticeBtn.visible = true;
            this._requestMasterBtn.visible = false;
         }
         else
         {
            this._requestApprenticeBtn.visible = false;
            this._requestMasterBtn.visible = true;
         }
         if(Boolean(this._info))
         {
            this._courtshipBtn.enable = this._talkBtn.enable = this._equipBtn.enable = this._addBtn.enable = this._requestMasterBtn.enable = this._requestApprenticeBtn.enable = this._characteContainer.visible = true;
            if(Boolean(this._levelIcon))
            {
               this._levelIcon.visible = true;
            }
            if(Boolean(this._vipIcon))
            {
               this._vipIcon.visible = true;
            }
            if(Boolean(this._marriedIcon))
            {
               this._marriedIcon.visible = true;
            }
            this._courtshipBtn.enable = this.getCourtshipBtnEnable();
            var player:PlayerInfo = this._info.info;
            this._playerNameTxt.text = player.NickName;
            this._guildNameTxt.text = Boolean(player.ConsortiaName) ? player.ConsortiaName : "";
            this._graduatesCountTxt.text = String(player.graduatesCount);
            var rate:Number = player.TotalCount > 0 ? player.WinCount / player.TotalCount * 100 : 0;
            this._winProbabilityTxt.text = String(rate.toFixed(2)) + "%";
            this._fightPowerTxt.text = String(player.FightPower);
            this._honourOfMasterTxt.text = player.honourOfMaster;
            this._introductionTxt.text = this._info.Introduction;
            this._online.visible = player.playerState.StateID == PlayerState.ONLINE ? true : false;
            this._equipBtn.enable = this._info.IsPublishEquip;
            if(player.playerState.StateID == PlayerState.ONLINE)
            {
               this._talkBtn.enable = true;
            }
            else
            {
               this._talkBtn.enable = false;
            }
            if(player.IsVIP)
            {
               ObjectUtils.disposeObject(this._vipName);
               this._vipName = VipController.instance.getVipNameTxt(157,player.typeVIP);
               this._vipName.textSize = 16;
               this._vipName.x = this._playerNameTxt.x;
               this._vipName.y = this._playerNameTxt.y;
               this._vipName.text = this._playerNameTxt.text;
               addChild(this._vipName);
               DisplayUtils.removeDisplay(this._playerNameTxt);
            }
            else
            {
               addChild(this._playerNameTxt);
               DisplayUtils.removeDisplay(this._vipName);
            }
            this.createCharacter();
            this.updateIcon();
            this.updateTextPos();
            return;
         }
         this._courtshipBtn.enable = this._talkBtn.enable = this._equipBtn.enable = this._addBtn.enable = this._requestMasterBtn.enable = this._requestApprenticeBtn.enable = this._online.visible = this._characteContainer.visible = false;
         this._playerNameTxt.text = "";
         this._guildNameTxt.text = "";
         this._graduatesCountTxt.text = "";
         this._winProbabilityTxt.text = "";
         this._fightPowerTxt.text = "";
         this._honourOfMasterTxt.text = "";
         this._introductionTxt.text = "";
         if(Boolean(this._vipName))
         {
            this._vipName.visible = false;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.visible = false;
         }
         if(Boolean(this._vipIcon))
         {
            this._vipIcon.visible = false;
         }
         if(Boolean(this._marriedIcon))
         {
            this._marriedIcon.visible = false;
         }
      }
      
      private function updateTextPos() : void
      {
         if(PlayerManager.Instance.Self.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
         {
            this._textLableBg.setFrame(2);
            this._fightPowerTxt.visible = true;
            this._winProbabilityTxt.visible = true;
            this._guildNameTxt.visible = true;
            this._graduatesCountTxt.visible = false;
            this._honourOfMasterTxt.visible = false;
            PositionUtils.setPos(this._fightPowerTxt,"academy.view.AcademyView.text1pos");
            PositionUtils.setPos(this._winProbabilityTxt,"academy.view.AcademyView.text2pos");
            PositionUtils.setPos(this._guildNameTxt,"academy.view.AcademyView.text3pos");
         }
         else
         {
            this._textLableBg.setFrame(1);
            this._fightPowerTxt.visible = true;
            this._winProbabilityTxt.visible = true;
            this._guildNameTxt.visible = true;
            this._graduatesCountTxt.visible = true;
            this._honourOfMasterTxt.visible = true;
            PositionUtils.setPos(this._textLableBg,"academy.view.AcademyView.textLablepos");
            PositionUtils.setPos(this._fightPowerTxt,"academy.view.AcademyView.text4pos");
            PositionUtils.setPos(this._winProbabilityTxt,"academy.view.AcademyView.text5pos");
            PositionUtils.setPos(this._guildNameTxt,"academy.view.AcademyView.text6pos");
         }
      }
      
      private function getCourtshipBtnEnable() : Boolean
      {
         var selfInfo:SelfInfo = PlayerManager.Instance.Self;
         if(this._info && this._info.info && (selfInfo.SpouseID <= 0 && this._info.info.SpouseID <= 0 && this._info.info.Sex != selfInfo.Sex) && this._info.info.playerState.StateID == PlayerState.ONLINE)
         {
            return true;
         }
         return false;
      }
      
      private function updateIcon() : void
      {
         var player:PlayerInfo = this._info.info;
         this._levelIcon.setInfo(player.Grade,player.Repute,player.WinCount,player.TotalCount,player.FightPower,player.Offer,true,false);
         this._levelIcon.visible = true;
         if(this._vipIcon == null && player.IsVIP)
         {
            this._vipIcon = ComponentFactory.Instance.creatCustomObject("academy.playerPanel.VipIcon");
            addChild(this._vipIcon);
            this._vipIcon.setInfo(player);
         }
         else if(Boolean(this._vipIcon) && !player.IsVIP)
         {
            this._vipIcon.dispose();
            this._vipIcon = null;
         }
         if(player.SpouseID > 0)
         {
            if(this._marriedIcon == null)
            {
               this._marriedIcon = ComponentFactory.Instance.creatCustomObject("academy.playerPanel.MarriedIcon");
            }
            this._marriedIcon.tipData = {
               "nickName":player.SpouseName,
               "gender":player.Sex
            };
            addChild(this._marriedIcon);
         }
         else if(Boolean(this._marriedIcon))
         {
            this._marriedIcon.dispose();
            this._marriedIcon = null;
         }
         if(Boolean(this._vipIcon))
         {
            if(Boolean(this._marriedIcon))
            {
               this._marriedIcon.y = this._vipIcon.y + this._vipIcon.height + 3;
            }
         }
         else if(Boolean(this._marriedIcon))
         {
            this._marriedIcon.y = this._levelIcon.y + 38;
         }
      }
      
      private function __characterComplete(event:Event) : void
      {
         this._player.removeEventListener(Event.COMPLETE,this.__characterComplete);
         PositionUtils.setPos(this._player,"academy.view.AcademyPlayerPanel.playerPos");
         this._characteContainer.addChild(this._player as DisplayObject);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._player))
         {
            this._player.dispose();
            this._player = null;
         }
         if(Boolean(this._leftBg))
         {
            ObjectUtils.disposeObject(this._leftBg);
            this._leftBg = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._data))
         {
            ObjectUtils.disposeObject(this._data);
            this._data = null;
         }
         if(Boolean(this._online))
         {
            ObjectUtils.disposeObject(this._online);
            this._online = null;
         }
         if(Boolean(this._academyTitle) && Boolean(this._academyTitle.bitmapData))
         {
            this._academyTitle.bitmapData.dispose();
            this._academyTitle = null;
         }
         if(Boolean(this._textLableBg))
         {
            ObjectUtils.disposeObject(this._textLableBg);
            this._textLableBg = null;
         }
         if(Boolean(this._courtshipBtn))
         {
            ObjectUtils.disposeObject(this._courtshipBtn);
            this._courtshipBtn = null;
         }
         if(Boolean(this._talkBtn))
         {
            ObjectUtils.disposeObject(this._talkBtn);
            this._talkBtn = null;
         }
         if(Boolean(this._equipBtn))
         {
            ObjectUtils.disposeObject(this._equipBtn);
            this._equipBtn = null;
         }
         if(Boolean(this._addBtn))
         {
            ObjectUtils.disposeObject(this._addBtn);
            this._addBtn = null;
         }
         if(Boolean(this._requestMasterBtn))
         {
            ObjectUtils.disposeObject(this._requestMasterBtn);
            this._requestMasterBtn = null;
         }
         if(Boolean(this._requestApprenticeBtn))
         {
            ObjectUtils.disposeObject(this._requestApprenticeBtn);
            this._requestApprenticeBtn = null;
         }
         if(Boolean(this._playerNameTxt))
         {
            ObjectUtils.disposeObject(this._playerNameTxt);
            this._playerNameTxt = null;
         }
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
         }
         if(Boolean(this._guildNameTxt))
         {
            ObjectUtils.disposeObject(this._guildNameTxt);
            this._guildNameTxt = null;
         }
         if(Boolean(this._graduatesCountTxt))
         {
            ObjectUtils.disposeObject(this._graduatesCountTxt);
            this._graduatesCountTxt = null;
         }
         if(Boolean(this._honourOfMasterTxt))
         {
            ObjectUtils.disposeObject(this._honourOfMasterTxt);
            this._honourOfMasterTxt = null;
         }
         if(Boolean(this._fightPowerTxt))
         {
            ObjectUtils.disposeObject(this._fightPowerTxt);
            this._fightPowerTxt = null;
         }
         if(Boolean(this._winProbabilityTxt))
         {
            ObjectUtils.disposeObject(this._winProbabilityTxt);
            this._winProbabilityTxt = null;
         }
         if(Boolean(this._introductionTxt))
         {
            ObjectUtils.disposeObject(this._introductionTxt);
            this._introductionTxt = null;
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
            this._marriedIcon.dispose();
            this._marriedIcon = null;
         }
         if(Boolean(this._player))
         {
            this._player.dispose();
            this._player = null;
         }
         if(Boolean(this._characteContainer) && Boolean(this._characteContainer.parent))
         {
            this._characteContainer.parent.removeChild(this._characteContainer);
            this._characteContainer = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

