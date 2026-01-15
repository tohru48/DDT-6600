package tofflist.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaApplyInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   import vip.VipController;
   
   public class TofflistLeftCurrentCharcter extends Sprite implements Disposeable
   {
      
      private var _AchievementImg:Bitmap;
      
      private var _EXPImg:Bitmap;
      
      private var _LnTAImg:Bitmap;
      
      private var _NO1Mc:MovieClip;
      
      private var _chairmanNameTxt:FilterFrameText;
      
      private var _chairmanNameTxt2:FilterFrameText;
      
      private var _consortiaName:FilterFrameText;
      
      private var _exploitImg:Bitmap;
      
      private var _fightingImg:Bitmap;
      
      private var _mountsImg:Bitmap;
      
      private var _guildImg:Bitmap;
      
      private var _info:PlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _lookEquip_btn:TextButton;
      
      private var _applyJoinBtn:TextButton;
      
      private var _nameTxt:FilterFrameText;
      
      private var _player:ICharacter;
      
      private var _rankNumber:Sprite;
      
      private var _text1:FilterFrameText;
      
      private var _textBg:Scale9CornerImage;
      
      private var _wealthImg:Bitmap;
      
      private var _vipName:GradientText;
      
      private var _chairmanVipName:GradientText;
      
      private var _scoreImg:Bitmap;
      
      private var _charmvalueImg:Bitmap;
      
      private var _levelStar:Bitmap;
      
      private var _mountsLevel:FilterFrameText;
      
      public function TofflistLeftCurrentCharcter()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._player))
         {
            this._player.dispose();
         }
         this._player = null;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._AchievementImg = null;
         this._EXPImg = null;
         this._LnTAImg = null;
         this._NO1Mc = null;
         this._chairmanNameTxt2 = null;
         this._exploitImg = null;
         this._fightingImg = null;
         this._mountsImg = null;
         this._guildImg = null;
         this._levelIcon = null;
         this._lookEquip_btn = null;
         this._applyJoinBtn = null;
         this._nameTxt = null;
         this._rankNumber = null;
         this._text1 = null;
         this._textBg = null;
         this._wealthImg = null;
         this._vipName = null;
         this._chairmanVipName = null;
         this._charmvalueImg = null;
         this._levelStar = null;
         this._mountsLevel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function NO1Effect() : void
      {
         if(TofflistModel.currentIndex == 1)
         {
            this._NO1Mc.visible = true;
            this._NO1Mc.gotoAndPlay(1);
         }
         else
         {
            this._NO1Mc.visible = false;
            this._NO1Mc.gotoAndStop(1);
         }
      }
      
      private function __lookBtnClick(evt:Event) : void
      {
         SoundManager.instance.play("008");
         if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL && Boolean(this._info))
         {
            PlayerInfoViewControl.viewByID(this._info.ID);
         }
      }
      
      private function __upCurrentPlayerHandler(evt:TofflistEvent) : void
      {
         this._info = TofflistModel.currentPlayerInfo;
         this.upView();
      }
      
      private function addEvent() : void
      {
         TofflistModel.addEventListener(TofflistEvent.TOFFLIST_CURRENT_PLAYER,this.__upCurrentPlayerHandler);
         this._lookEquip_btn.addEventListener(MouseEvent.CLICK,this.__lookBtnClick);
         this._applyJoinBtn.addEventListener(MouseEvent.CLICK,this.onApplyJoinClubBtnClick);
      }
      
      private function onApplyJoinClubBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(TofflistModel.currentConsortiaInfo))
         {
            if(PlayerManager.Instance.Self.Grade < 17)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.notInvite"));
               return;
            }
            if(!TofflistModel.currentConsortiaInfo.OpenApply)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.applyJoinClickHandler"));
               return;
            }
            this._applyJoinBtn.enable = false;
            SocketManager.Instance.out.sendConsortiaTryIn(TofflistModel.currentConsortiaInfo.ConsortiaID);
         }
      }
      
      private function getRank(rankNumber:int) : void
      {
         var bmp:Bitmap = null;
         var point:Point = null;
         if(!this._rankNumber)
         {
            this._rankNumber = new Sprite();
         }
         while(this._rankNumber.numChildren != 0)
         {
            this._rankNumber.removeChildAt(0);
         }
         var strNumber:String = rankNumber.toString();
         var len:int = strNumber.length;
         for(var i:int = 0; i < len; i++)
         {
            bmp = this.getRankBitmap(int(strNumber.substr(i,1)));
            bmp.x = i * 30;
            this._rankNumber.addChild(bmp);
         }
         switch(rankNumber)
         {
            case 1:
               bmp = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankSt");
               bmp.x = 25;
               bmp.y = 2;
               this._rankNumber.addChild(bmp);
               break;
            case 2:
               bmp = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNd");
               bmp.x = 34;
               bmp.y = 2;
               this._rankNumber.addChild(bmp);
               break;
            case 3:
               bmp = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankRd");
               bmp.x = 30;
               bmp.y = 2;
               this._rankNumber.addChild(bmp);
               break;
            default:
               bmp = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankTh");
               bmp.x = len * 30;
               bmp.y = 2;
               this._rankNumber.addChild(bmp);
         }
         addChild(this._rankNumber);
         point = ComponentFactory.Instance.creat("tofflist.rankPos");
         this._rankNumber.x = point.x;
         this._rankNumber.y = point.y;
      }
      
      private function getRankBitmap(rankCell:int) : Bitmap
      {
         var bmp:Bitmap = null;
         return ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum" + rankCell);
      }
      
      private function init() : void
      {
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("toffilist.textBg");
         addChild(this._textBg);
         this._fightingImg = ComponentFactory.Instance.creat("asset.Toffilist.fightingImgAsset1_1");
         addChild(this._fightingImg);
         this._mountsImg = ComponentFactory.Instance.creat("asset.Toffilist.mountsImgAsset1_1");
         addChild(this._mountsImg);
         this._exploitImg = ComponentFactory.Instance.creat("asset.Toffilist.exploitImgAsset1_1");
         addChild(this._exploitImg);
         this._EXPImg = ComponentFactory.Instance.creat("asset.Toffilist.EXPImgAsset1_1");
         addChild(this._EXPImg);
         this._wealthImg = ComponentFactory.Instance.creat("asset.Toffilist.wealthImgAsset1_1");
         addChild(this._wealthImg);
         this._LnTAImg = ComponentFactory.Instance.creat("asset.Toffilist.LnTAImgAsset1_1");
         addChild(this._LnTAImg);
         this._AchievementImg = ComponentFactory.Instance.creat("asset.Toffilist.AchievementImgAsset1_1");
         addChild(this._AchievementImg);
         this._charmvalueImg = ComponentFactory.Instance.creat("asset.Toffilist.charmvalueImgAsset1_1");
         addChild(this._charmvalueImg);
         this._guildImg = ComponentFactory.Instance.creat("asset.Toffilist.guildImgAsset");
         addChild(this._guildImg);
         this._scoreImg = ComponentFactory.Instance.creatBitmap("asset.Toffilist.scoreAsset1");
         addChild(this._scoreImg);
         this._text1 = ComponentFactory.Instance.creatComponentByStylename("toffilist.text1");
         addChild(this._text1);
         this._consortiaName = ComponentFactory.Instance.creatComponentByStylename("toffilist.consortiaName");
         addChild(this._consortiaName);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.nameTxt");
         this._chairmanNameTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.chairmanNameTxt");
         addChild(this._chairmanNameTxt);
         this._chairmanNameTxt2 = ComponentFactory.Instance.creatComponentByStylename("toffilist.chairmanNameTxt2");
         this._lookEquip_btn = ComponentFactory.Instance.creatComponentByStylename("toffilist.lookEquip_btn");
         this._lookEquip_btn.text = LanguageMgr.GetTranslation("civil.leftview.equipName");
         addChild(this._lookEquip_btn);
         this._applyJoinBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.applyJoinClub_btn");
         this._applyJoinBtn.text = LanguageMgr.GetTranslation("tofflist.joinconsortia");
         addChild(this._applyJoinBtn);
         this._applyJoinBtn.visible = false;
         this._NO1Mc = ComponentFactory.Instance.creat("asset.NO1McAsset");
         PositionUtils.setPos(this._NO1Mc,"tofflist.NO1McAssetPos");
         this._NO1Mc.gotoAndStop(1);
         this._NO1Mc.visible = false;
         addChild(this._NO1Mc);
         this._levelStar = ComponentFactory.Instance.creat("asset.Toffilist.levelStarTxtImage");
         PositionUtils.setPos(this._levelStar,"tofflist.leftview.levelStarPos");
         addChild(this._levelStar);
         this._mountsLevel = ComponentFactory.Instance.creatComponentByStylename("toffilist.mountsLevelText");
         PositionUtils.setPos(this._mountsLevel,"tofflist.leftview.MountsLevelPos");
         addChild(this._mountsLevel);
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
            PositionUtils.setPos(this._player,"tofflist.playerPos");
            addChild(this._player as DisplayObject);
         }
      }
      
      private function removeEvent() : void
      {
         TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_CURRENT_PLAYER,this.__upCurrentPlayerHandler);
         this._lookEquip_btn.removeEventListener(MouseEvent.CLICK,this.__lookBtnClick);
         this._applyJoinBtn.removeEventListener(MouseEvent.CLICK,this.onApplyJoinClubBtnClick);
      }
      
      private function upLevelIcon() : void
      {
         if(Boolean(this._levelIcon))
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(Boolean(this._info))
         {
            this._levelIcon = new LevelIcon();
            this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
            addChild(this._levelIcon);
         }
      }
      
      private function upStyle() : void
      {
         this._text1.text = "";
         this._consortiaName.text = "";
         this._nameTxt.text = "";
         this._chairmanNameTxt.text = "";
         this._chairmanNameTxt2.text = "";
         this._mountsLevel.text = "";
         this._levelStar.visible = false;
         DisplayUtils.removeDisplay(this._vipName);
         DisplayUtils.removeDisplay(this._chairmanVipName);
         if(!this._info)
         {
            if(Boolean(this._rankNumber))
            {
               ObjectUtils.disposeObject(this._rankNumber);
               this._rankNumber = null;
            }
            if(Boolean(this._levelIcon))
            {
               ObjectUtils.disposeObject(this._levelIcon);
               this._levelIcon = null;
            }
            return;
         }
         if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL || TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
         {
            this.upLevelIcon();
            this._nameTxt.text = this._info.NickName;
            this._nameTxt.x = (500 - this._nameTxt.textWidth) / 2;
            if(this._info.IsVIP)
            {
               if(Boolean(this._vipName))
               {
                  ObjectUtils.disposeObject(this._vipName);
               }
               this._vipName = VipController.instance.getVipNameTxt(390 - this._nameTxt.x,this._info.typeVIP);
               this._vipName.textSize = 18;
               this._vipName.x = this._nameTxt.x;
               this._vipName.y = this._nameTxt.y;
               this._vipName.text = this._nameTxt.text;
               addChild(this._vipName);
               DisplayUtils.removeDisplay(this._nameTxt);
               addChild(this._applyJoinBtn);
            }
            else
            {
               addChild(this._nameTxt);
               DisplayUtils.removeDisplay(this._vipName);
            }
            this._levelIcon.x = this._nameTxt.x - (this._levelIcon.width + 5);
            this._levelIcon.y = this._nameTxt.y - 5;
         }
         else
         {
            if(Boolean(this._levelIcon))
            {
               this._levelIcon.visible = false;
            }
            this._chairmanNameTxt.text = LanguageMgr.GetTranslation("tank.tofflist.view.TofflistLeftCurrentCharcter.cdr");
            this._chairmanNameTxt2.text = this._info.NickName;
            this._chairmanNameTxt2.x = 200;
            this._chairmanNameTxt.x = 142;
            if(this._info.IsVIP)
            {
               if(Boolean(this._chairmanVipName))
               {
                  ObjectUtils.disposeObject(this._chairmanVipName);
               }
               this._chairmanVipName = VipController.instance.getVipNameTxt(165,this._info.typeVIP);
               this._chairmanVipName.textSize = 18;
               this._chairmanVipName.x = this._chairmanNameTxt2.x;
               this._chairmanVipName.y = this._chairmanNameTxt2.y;
               this._chairmanVipName.text = this._chairmanNameTxt2.text;
               addChild(this._chairmanVipName);
               DisplayUtils.removeDisplay(this._chairmanNameTxt2);
               addChild(this._applyJoinBtn);
            }
            else
            {
               addChild(this._chairmanNameTxt2);
               DisplayUtils.removeDisplay(this._chairmanVipName);
            }
         }
         if(TofflistModel.secondMenuType != TofflistTwoGradeMenu.MOUNTS)
         {
            this._text1.text = String(TofflistModel.currentText);
         }
         else
         {
            this._levelStar.visible = true;
            this._mountsLevel.text = TofflistModel.mountsLevelInfo;
         }
         this._consortiaName.text = String(TofflistModel.currentPlayerInfo.ConsortiaName);
         this.getRank(TofflistModel.currentIndex);
      }
      
      private function upView() : void
      {
         this._fightingImg.visible = false;
         this._mountsImg.visible = false;
         this._AchievementImg.visible = false;
         this._LnTAImg.visible = false;
         this._wealthImg.visible = false;
         this._EXPImg.visible = false;
         this._exploitImg.visible = false;
         this._charmvalueImg.visible = false;
         this._scoreImg.visible = false;
         this.refreshCharater();
         this.upStyle();
         this.NO1Effect();
         if(Boolean(this._info) && TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL)
         {
            this._lookEquip_btn.enable = true;
         }
         else
         {
            this._lookEquip_btn.enable = false;
         }
         this.refreshApplyJoinClubBtn();
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._fightingImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._EXPImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.GESTE:
                     this._exploitImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._AchievementImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._charmvalueImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this._scoreImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.MOUNTS:
                     this._mountsImg.visible = true;
               }
               break;
            case TofflistStairMenu.CONSORTIA:
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._fightingImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._EXPImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this._LnTAImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.GESTE:
                     this._exploitImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._charmvalueImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._AchievementImg.visible = true;
               }
         }
      }
      
      private function refreshApplyJoinClubBtn() : void
      {
         var consortiaID:int = 0;
         if(Boolean(TofflistModel.currentConsortiaInfo))
         {
            consortiaID = TofflistModel.currentConsortiaInfo.ConsortiaID;
         }
         if(this._info && TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA && PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            this._applyJoinBtn.visible = true;
         }
         else
         {
            this._applyJoinBtn.visible = false;
         }
         if(consortiaID == 0 || !this.hasApplyJoinClub(consortiaID))
         {
            this._applyJoinBtn.enable = true;
         }
         else
         {
            this._applyJoinBtn.enable = false;
         }
      }
      
      private function hasApplyJoinClub(consortiaID:int = 0) : Boolean
      {
         var item:ConsortiaApplyInfo = null;
         var i:int = 0;
         var arr:Vector.<ConsortiaApplyInfo> = TofflistModel.Instance.myConsortiaAuditingApplyData;
         if(Boolean(arr))
         {
            for(i = 0; i < arr.length; i++)
            {
               item = arr[i];
               if(item.ConsortiaID == consortiaID)
               {
                  return true;
               }
            }
         }
         return false;
      }
   }
}

