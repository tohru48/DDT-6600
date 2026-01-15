package civil.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import civil.CivilController;
   import civil.CivilEvent;
   import civil.CivilModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import im.IMController;
   import vip.VipController;
   
   public class CivilLeftView extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _headBg:Bitmap;
      
      private var _SmallBg1:Bitmap;
      
      private var _SmallBg2:Bitmap;
      
      private var _Introduction:Bitmap;
      
      private var _introBg:MovieClip;
      
      private var _buttonBg:MovieClip;
      
      private var _playerName:FilterFrameText;
      
      private var _guildName:FilterFrameText;
      
      private var _repute:FilterFrameText;
      
      private var _married:FilterFrameText;
      
      private var _player:ICharacter;
      
      private var _sexBg:ScaleFrameImage;
      
      private var _vipName:GradientText;
      
      private var _introductionTxt:TextArea;
      
      private var _selfInfo:SelfInfo;
      
      private var _info:CivilPlayerInfo;
      
      private var _controller:CivilController;
      
      private var _levelIcon:LevelIcon;
      
      private var _model:CivilModel;
      
      private var _courtshipBtn:TextButton;
      
      private var _talkBtn:TextButton;
      
      private var _equipBtn:TextButton;
      
      private var _addBtn:TextButton;
      
      private var _playerNameTxt:FilterFrameText;
      
      private var _guildNameTxt:FilterFrameText;
      
      private var _reputeTxt:FilterFrameText;
      
      private var _marriedTxt:FilterFrameText;
      
      public function CivilLeftView(controller:CivilController, model:CivilModel)
      {
         this._controller = controller;
         this._model = model;
         super();
         this.init();
         this.initContent();
         this.initEvent();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._addBtn))
         {
            ObjectUtils.disposeObject(this._addBtn);
            this._addBtn = null;
         }
         if(Boolean(this._courtshipBtn))
         {
            this._courtshipBtn.dispose();
         }
         this._courtshipBtn = null;
         if(Boolean(this._equipBtn))
         {
            this._equipBtn.dispose();
         }
         this._equipBtn = null;
         if(Boolean(this._player))
         {
            this._player.dispose();
         }
         this._player = null;
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._headBg))
         {
            ObjectUtils.disposeObject(this._headBg);
            this._headBg = null;
         }
         if(Boolean(this._sexBg))
         {
            ObjectUtils.disposeObject(this._sexBg);
            this._sexBg = null;
         }
         if(Boolean(this._playerName))
         {
            ObjectUtils.disposeObject(this._playerName);
            this._playerName = null;
         }
         if(Boolean(this._guildName))
         {
            ObjectUtils.disposeObject(this._guildName);
            this._guildName = null;
         }
         if(Boolean(this._repute))
         {
            ObjectUtils.disposeObject(this._repute);
            this._repute = null;
         }
         if(Boolean(this._married))
         {
            ObjectUtils.disposeObject(this._married);
            this._married = null;
         }
         if(Boolean(this._introductionTxt))
         {
            ObjectUtils.disposeObject(this._introductionTxt);
            this._introductionTxt = null;
         }
         if(Boolean(this._talkBtn))
         {
            ObjectUtils.disposeObject(this._talkBtn);
            this._talkBtn = null;
         }
         if(Boolean(this._playerNameTxt))
         {
            ObjectUtils.disposeObject(this._playerNameTxt);
            this._playerNameTxt = null;
         }
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(Boolean(this._guildNameTxt))
         {
            ObjectUtils.disposeObject(this._guildNameTxt);
            this._guildNameTxt = null;
         }
         if(Boolean(this._reputeTxt))
         {
            ObjectUtils.disposeObject(this._reputeTxt);
            this._reputeTxt = null;
         }
         if(Boolean(this._Introduction))
         {
            ObjectUtils.disposeObject(this._Introduction);
            this._Introduction = null;
         }
         if(Boolean(this._marriedTxt))
         {
            ObjectUtils.disposeObject(this._marriedTxt);
            this._marriedTxt = null;
         }
         if(Boolean(this._buttonBg))
         {
            ObjectUtils.disposeObject(this._buttonBg);
            this._buttonBg = null;
         }
         if(Boolean(this._introBg))
         {
            ObjectUtils.disposeObject(this._introBg);
            this._introBg = null;
         }
         if(Boolean(this._SmallBg1))
         {
            ObjectUtils.disposeObject(this._SmallBg1);
            this._SmallBg1 = null;
         }
         if(Boolean(this._SmallBg2))
         {
            ObjectUtils.disposeObject(this._SmallBg2);
            this._SmallBg2 = null;
         }
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.leftView.bg");
         addChild(this._bg);
         this._sexBg = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.sexBg");
         addChild(this._sexBg);
         this._sexBg.visible = false;
         this._headBg = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.titleBgAsset");
         addChild(this._headBg);
         this._SmallBg1 = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.leftSmallBgAsset");
         PositionUtils.setPos(this._SmallBg1,"ddtcivil.leftSmallBg1");
         addChild(this._SmallBg1);
         this._SmallBg2 = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.leftSmallBgAsset");
         PositionUtils.setPos(this._SmallBg2,"ddtcivil.leftSmallBg2");
         addChild(this._SmallBg2);
         this._introBg = ClassUtils.CreatInstance("asset.ddtcivil.LeftIntroBgAsset") as MovieClip;
         PositionUtils.setPos(this._introBg,"ddtcivil.IntroBg");
         addChild(this._introBg);
         this._playerName = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.player");
         this._playerName.text = LanguageMgr.GetTranslation("civil.leftview.playerName");
         addChild(this._playerName);
         this._guildName = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.guild");
         this._guildName.text = LanguageMgr.GetTranslation("civil.leftview.guildName");
         addChild(this._guildName);
         this._repute = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.repute");
         this._repute.text = LanguageMgr.GetTranslation("civil.leftview.repute");
         addChild(this._repute);
         this._married = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.married");
         this._married.text = LanguageMgr.GetTranslation("civil.leftview.married");
         addChild(this._married);
         this._Introduction = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.introducntionAsset");
         addChild(this._Introduction);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("ddtcivil.levelIcon");
         addChild(this._levelIcon);
         this._introductionTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.IntroductionText");
         addChild(this._introductionTxt);
         this._buttonBg = ClassUtils.CreatInstance("asset.ddtcivil.leftviewButtonBgAsset") as MovieClip;
         PositionUtils.setPos(this._buttonBg,"ddtcivil.lefeBtnBg");
         addChild(this._buttonBg);
      }
      
      private function initContent() : void
      {
         this._courtshipBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.courtshipTxtBtn");
         this._talkBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.talkTxtBtn");
         this._equipBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.equipTxtBtn");
         this._addBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.addTxtBtn");
         this._playerNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.playerName");
         this._guildNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.guildName");
         this._reputeTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.reputeTxt");
         this._marriedTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.marriedTxt");
         this._equipBtn.text = LanguageMgr.GetTranslation("civil.leftview.equipName");
         this._talkBtn.text = LanguageMgr.GetTranslation("civil.leftview.talkName");
         this._addBtn.text = LanguageMgr.GetTranslation("civil.leftview.addName");
         this._courtshipBtn.text = LanguageMgr.GetTranslation("civil.leftview.courtshipName");
         addChild(this._courtshipBtn);
         addChild(this._talkBtn);
         addChild(this._equipBtn);
         addChild(this._addBtn);
         addChild(this._playerNameTxt);
         addChild(this._guildNameTxt);
         addChild(this._reputeTxt);
         addChild(this._marriedTxt);
      }
      
      private function initEvent() : void
      {
         this._courtshipBtn.addEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._talkBtn.addEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._equipBtn.addEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._addBtn.addEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._model.addEventListener(CivilEvent.SELECTED_CHANGE,this.__updateView);
      }
      
      private function removeEvent() : void
      {
         this._courtshipBtn.removeEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._talkBtn.removeEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._equipBtn.removeEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._model.removeEventListener(CivilEvent.SELECTED_CHANGE,this.__updateView);
      }
      
      private function __onButtonClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var info:CivilPlayerInfo = this._controller.currentcivilInfo;
         if(Boolean(info) && Boolean(info.info))
         {
            switch(event.currentTarget)
            {
               case this._talkBtn:
                  ChatManager.Instance.privateChatTo(info.info.NickName,info.info.ID);
                  break;
               case this._equipBtn:
                  if(info.IsPublishEquip)
                  {
                     PlayerInfoViewControl.viewByID(info.info.ID,PlayerManager.Instance.Self.ZoneID);
                  }
                  else if(info.MarryInfoID == PlayerManager.Instance.Self.MarryInfoID && PlayerManager.Instance.Self.IsPublishEquit)
                  {
                     PlayerInfoViewControl.viewByID(info.info.ID,PlayerManager.Instance.Self.ZoneID);
                  }
                  break;
               case this._addBtn:
                  IMController.Instance.addFriend(info.info.NickName);
                  break;
               case this._courtshipBtn:
                  ChurchManager.instance.sendValidateMarry(info.info);
            }
         }
      }
      
      private function __updateView(evt:CivilEvent) : void
      {
         if(Boolean(this._model.currentcivilItemInfo))
         {
            if(!this._sexBg.visible)
            {
               this._sexBg.visible = true;
            }
            this._sexBg.setFrame(this._model.sex ? 1 : 2);
            this.updatePlayerView();
         }
         else
         {
            this._levelIcon.visible = false;
            this._equipBtn.enable = false;
            this._talkBtn.enable = false;
            this._courtshipBtn.enable = false;
            this._addBtn.enable = false;
            this._sexBg.visible = false;
            this._playerNameTxt.text = "";
            if(Boolean(this._vipName))
            {
               this._vipName.text = "";
               DisplayUtils.removeDisplay(this._vipName);
            }
            this._guildNameTxt.text = "";
            this._reputeTxt.text = "";
            this._marriedTxt.text = "";
            this._introductionTxt.text = "";
         }
         this.refreshCharater();
      }
      
      private function updatePlayerView() : void
      {
         var info:CivilPlayerInfo = this._model.currentcivilItemInfo;
         var playerInfo:PlayerInfo = info.info;
         this._playerNameTxt.text = playerInfo.NickName;
         if(playerInfo.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(192,playerInfo.typeVIP);
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
         this._guildNameTxt.text = Boolean(playerInfo.ConsortiaName) ? playerInfo.ConsortiaName : "";
         this._reputeTxt.text = String(playerInfo.Repute);
         this._marriedTxt.text = playerInfo.IsMarried ? LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.married") : LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.marry");
         this._levelIcon.setInfo(playerInfo.Grade,playerInfo.Repute,playerInfo.WinCount,playerInfo.TotalCount,playerInfo.FightPower,playerInfo.Offer,true,false);
         this._levelIcon.visible = true;
         if(this._model.currentcivilItemInfo.MarryInfoID == PlayerManager.Instance.Self.MarryInfoID && PlayerManager.Instance.Self.Introduction != null)
         {
            this._introductionTxt.text = PlayerManager.Instance.Self.Introduction;
            this._equipBtn.enable = PlayerManager.Instance.Self.IsPublishEquit;
         }
         else
         {
            this._introductionTxt.text = info.Introduction;
         }
         if(this._model.currentcivilItemInfo.MarryInfoID == PlayerManager.Instance.Self.MarryInfoID || this._model.currentcivilItemInfo.info.playerState.StateID == PlayerState.OFFLINE)
         {
            this._talkBtn.enable = false;
         }
         else
         {
            this._talkBtn.enable = true;
         }
         if(info.info.ID == PlayerManager.Instance.Self.ID)
         {
            this._addBtn.enable = false;
            this._equipBtn.enable = this._model.currentcivilItemInfo.IsPublishEquip;
         }
         else
         {
            this._addBtn.enable = true;
            this._equipBtn.enable = this._model.currentcivilItemInfo.IsPublishEquip;
         }
         this._courtshipBtn.enable = this.getCourtshipBtnEnable();
      }
      
      private function getCourtshipBtnEnable() : Boolean
      {
         if(PlayerManager.Instance.Self.Sex == this._model.currentcivilItemInfo.info.Sex || PlayerManager.Instance.Self.IsMarried || this._model.currentcivilItemInfo.info.IsMarried || this._model.currentcivilItemInfo.info.playerState.StateID == PlayerState.OFFLINE)
         {
            return false;
         }
         return true;
      }
      
      private function refreshCharater() : void
      {
         var character:ICharacter = null;
         this._info = this._controller.currentcivilInfo;
         if(this._info != null)
         {
            character = this._player;
            this._player = CharactoryFactory.createCharacter(this._info.info,"room") as RoomCharacter;
            this._player.show(true,-1);
            this._player.setShowLight(true);
            PositionUtils.setPos(this._player,"civil.playerPos");
            addChild(this._player as DisplayObject);
            if(Boolean(character))
            {
               character.dispose();
            }
         }
         else if(Boolean(this._player))
         {
            this._player.dispose();
            this._player = null;
         }
      }
   }
}

