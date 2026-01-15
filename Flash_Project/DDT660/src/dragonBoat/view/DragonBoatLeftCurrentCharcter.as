package dragonBoat.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.common.LevelIcon;
   import dragonBoat.DragonBoatManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import vip.VipController;
   
   public class DragonBoatLeftCurrentCharcter extends Sprite implements Disposeable
   {
      
      private var _playerBg:Bitmap;
      
      private var _headerBg:Bitmap;
      
      private var _playerHeaderShine:MovieClip;
      
      private var _playerHeaderNo1:Bitmap;
      
      private var _palyerSprite:Sprite;
      
      private var _player:ICharacter;
      
      private var _info:PlayerInfo;
      
      private var _name:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _levelIcon:LevelIcon;
      
      private var _playerBottomText:FilterFrameText;
      
      public function DragonBoatLeftCurrentCharcter()
      {
         super();
         if(DragonBoatManager.instance.activeInfo.ActiveID == 1)
         {
            this._playerBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.playerBg");
         }
         else
         {
            this._playerBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.playerBg2");
         }
         addChild(this._playerBg);
         this._palyerSprite = new Sprite();
         addChild(this._palyerSprite);
         this._playerHeaderShine = ComponentFactory.Instance.creat("asset.dragonBoat.mainFrame.playerHeaderShine");
         PositionUtils.setPos(this._playerHeaderShine,"drgonBoat.playerHeaderShinePos");
         addChild(this._playerHeaderShine);
         this._headerBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.playerHeaderBg");
         addChild(this._headerBg);
         this._playerHeaderNo1 = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.playerHeaderNo1");
         addChild(this._playerHeaderNo1);
         this._name = ComponentFactory.Instance.creat("asset.dragonboatLeftPlayer.Name");
         addChild(this._name);
         this._levelIcon = new LevelIcon();
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         PositionUtils.setPos(this._levelIcon,"asset.dragonboatLeftPlayerLevelIconPos");
         addChild(this._levelIcon);
         this._playerBottomText = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.playerBottomTxt");
         this._playerBottomText.visible = false;
         addChild(this._playerBottomText);
      }
      
      public function updateInfo($info:PlayerInfo) : void
      {
         if(Boolean($info))
         {
            this._info = $info;
            this.refreshCharater();
            ObjectUtils.disposeObject(this._vipName);
            if(this._info.IsVIP)
            {
               this._vipName = VipController.instance.getVipNameTxt(120,this._info.typeVIP);
               this._vipName.text = this._info.NickName;
               this._vipName.x = this._name.x + (this._name.width - this._vipName.textWidth) / 2;
               this._vipName.y = this._name.y;
               addChild(this._vipName);
            }
            this._name.text = this._info.NickName;
            PositionUtils.adaptNameStyle(this._info,this._name,this._vipName);
            this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
            this._playerBottomText.text = LanguageMgr.GetTranslation("ddt.dragonBoat.playerBottomTxt",this._info.NickName);
         }
      }
      
      private function refreshCharater() : void
      {
         if(Boolean(this._player))
         {
            this._player.dispose();
            this._player = null;
         }
         if(Boolean(this._info))
         {
            this._player = CharactoryFactory.createCharacter(this._info,"room");
            this._player.show(false,-1);
            this._player.showGun = false;
            this._player.setShowLight(true);
            PositionUtils.setPos(this._player,"drgonBoat.playerPos");
            this._palyerSprite.addChild(this._player as DisplayObject);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._player))
         {
            this._player.dispose();
         }
         this._player = null;
         if(Boolean(this._playerBg))
         {
            ObjectUtils.disposeObject(this._playerBg);
            this._playerBg = null;
         }
         if(Boolean(this._playerHeaderShine))
         {
            ObjectUtils.disposeObject(this._playerHeaderShine);
            this._playerHeaderShine = null;
         }
         if(Boolean(this._palyerSprite))
         {
            ObjectUtils.disposeObject(this._palyerSprite);
            this._palyerSprite = null;
         }
         if(Boolean(this._headerBg))
         {
            ObjectUtils.disposeObject(this._headerBg);
            this._headerBg = null;
         }
         if(Boolean(this._playerHeaderNo1))
         {
            ObjectUtils.disposeObject(this._playerHeaderNo1);
            this._playerHeaderNo1 = null;
         }
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
         }
         this._vipName = null;
         if(Boolean(this._name))
         {
            this._name.dispose();
            this._name = null;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

