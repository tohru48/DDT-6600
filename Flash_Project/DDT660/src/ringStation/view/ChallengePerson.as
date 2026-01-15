package ringStation.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import ringStation.RingStationManager;
   import vip.VipController;
   
   public class ChallengePerson extends Sprite
   {
      
      private var _bg:Bitmap;
      
      private var _waiting:Bitmap;
      
      private var _levelIcon:LevelIcon;
      
      private var _nickNameText:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _rank:FilterFrameText;
      
      private var _player:ICharacter;
      
      private var _challengeBtn:MovieImage;
      
      private var _playerInfo:PlayerInfo;
      
      private var _clickDate:Number = 0;
      
      private var _signBG:Bitmap;
      
      private var _signBG2:Bitmap;
      
      private var _signText:FilterFrameText;
      
      private var _maskSprite:Sprite;
      
      private var _playerSprite:Sprite;
      
      public function ChallengePerson()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("ringStation.view.challengeBg");
         addChild(this._bg);
         this._levelIcon = new LevelIcon();
         PositionUtils.setPos(this._levelIcon,"ringStation.view.player.levelPos");
         addChild(this._levelIcon);
         this._playerSprite = new Sprite();
         addChild(this._playerSprite);
         this._signBG2 = ComponentFactory.Instance.creat("ringStation.view.challengeSingBG");
         this._signBG2.y = 27;
         this._signBG2.alpha = 0.5;
         addChild(this._signBG2);
         this._nickNameText = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.person.nickNameText");
         addChild(this._nickNameText);
         this._rank = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.person.rank");
         this._challengeBtn = ComponentFactory.Instance.creat("ringStation.view.player.challengeBtn");
         this._challengeBtn.buttonMode = true;
         this._challengeBtn.visible = false;
      }
      
      private function addSignCell() : void
      {
         this._signBG = ComponentFactory.Instance.creat("ringStation.view.challengeSingBG");
         this._signBG.alpha = 0.5;
         this._signText = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.signText2");
         this._signText.text = LanguageMgr.GetTranslation("ringstation.view.signNormal");
         addChild(this._signBG);
         addChild(this._signText);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         this._challengeBtn.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
      }
      
      public function setWaiting() : void
      {
         this._waiting = ComponentFactory.Instance.creat("ringStation.view.player.waiting");
         addChild(this._waiting);
      }
      
      public function updatePerson(personInfo:PlayerInfo) : void
      {
         this._playerInfo = personInfo;
         this._levelIcon.setInfo(personInfo.Grade,personInfo.Repute,personInfo.WinCount,personInfo.TotalCount,personInfo.FightPower,personInfo.Offer,true,false);
         this._nickNameText.htmlText = "<u><a href=\'event:marrytype:2541\'>" + personInfo.NickName + "</a></u>";
         if(personInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(104,personInfo.typeVIP);
            this._vipName.textSize = 16;
            this._vipName.x = this._nickNameText.x;
            this._vipName.y = this._nickNameText.y - 2;
            this._vipName.htmlText = "<u><a href=\'event:marrytype:2541\'>" + personInfo.NickName + "</a></u>";
            addChild(this._vipName);
         }
         PositionUtils.adaptNameStyle(personInfo,this._nickNameText,this._vipName);
         this._player = CharactoryFactory.createCharacter(personInfo,"room");
         this._player.showGun = true;
         this._player.show();
         this._player.setShowLight(true);
         PositionUtils.setPos(this._player,"ringStation.view.player.playerPos");
         this._playerSprite.addChild(this._player as DisplayObject);
         this._maskSprite = new Sprite();
         this._maskSprite.graphics.beginFill(16777215,1);
         this._maskSprite.graphics.drawRect(6,27,166,170);
         this._maskSprite.graphics.endFill();
         this._player.mask = this._maskSprite;
         addChild(this._maskSprite);
         addChild(this._challengeBtn);
         if(personInfo.Rank == 0)
         {
            this._rank.text = LanguageMgr.GetTranslation("ringStation.view.person.noRank");
         }
         else
         {
            this._rank.text = LanguageMgr.GetTranslation("ringStation.view.person.rankText",personInfo.Rank);
         }
         addChild(this._rank);
         this.addSignCell();
         var nomal:String = LanguageMgr.GetTranslation("ringstation.view.signNormal");
         if(personInfo.signMsg == "" || personInfo.signMsg == nomal)
         {
            this._signText.text = LanguageMgr.GetTranslation("ringstation.view.signNormal");
         }
         else
         {
            this._signText.text = personInfo.signMsg;
            if(this._signText.text.length > 15)
            {
               this._signText.text = this._signText.text.substr(0,15) + "...";
            }
         }
      }
      
      protected function __onMouseClick(event:MouseEvent) : void
      {
         if(new Date().time - this._clickDate > 1000)
         {
            this._clickDate = new Date().time;
            SoundManager.instance.playButtonSound();
            RingStationManager.challenge = true;
            SocketManager.Instance.out.sendRingStationChallenge(this._playerInfo.ID,this._playerInfo.Rank);
         }
      }
      
      protected function __onMouseOver(event:MouseEvent) : void
      {
         this._challengeBtn.visible = true;
      }
      
      protected function __onMouseOut(event:MouseEvent) : void
      {
         this._challengeBtn.visible = false;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         this._challengeBtn.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._waiting))
         {
            this._waiting.bitmapData.dispose();
            this._waiting = null;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
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
         if(Boolean(this._rank))
         {
            this._rank.dispose();
            this._rank = null;
         }
         if(Boolean(this._player))
         {
            this._player.dispose();
            this._player = null;
         }
         if(Boolean(this._challengeBtn))
         {
            this._challengeBtn.dispose();
            this._challengeBtn = null;
         }
         if(Boolean(this._playerSprite))
         {
            ObjectUtils.disposeAllChildren(this._playerSprite);
            ObjectUtils.disposeObject(this._playerSprite);
            this._playerSprite = null;
         }
         if(Boolean(this._signBG))
         {
            this._signBG.bitmapData.dispose();
            this._signBG = null;
         }
         if(Boolean(this._signBG2))
         {
            this._signBG2.bitmapData.dispose();
            this._signBG2 = null;
         }
         if(Boolean(this._signText))
         {
            this._signText.dispose();
            this._signText = null;
         }
      }
   }
}

