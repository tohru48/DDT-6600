package tofflist.view
{
   import battleGroud.BattleGroudManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.club.ClubInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import horse.HorseManager;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   import tofflist.data.RankInfo;
   import tofflist.data.TofflistPlayerInfo;
   
   public class TofflistLeftInfoView extends Sprite implements Disposeable
   {
      
      private var _levelIcon:LevelIcon;
      
      private var _RankingLiftImg:ScaleFrameImage;
      
      private var _rankTitle:FilterFrameText;
      
      private var _levelTitle:FilterFrameText;
      
      private var _valueTitle:FilterFrameText;
      
      private var _titleBg:ScaleFrameImage;
      
      private var _textArr:Array;
      
      private var _updateTimeTxt:FilterFrameText;
      
      private var _tempArr:Vector.<RankInfo>;
      
      private var _levelStar:Bitmap;
      
      private var _mountsLevel:FilterFrameText;
      
      private var _bg:MovieClip;
      
      public function TofflistLeftInfoView()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function dispose() : void
      {
         var txt:FilterFrameText = null;
         this.removeEvent();
         for each(txt in this._textArr)
         {
            ObjectUtils.disposeObject(txt);
         }
         this._textArr = null;
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         ObjectUtils.disposeObject(this._levelTitle);
         this._levelTitle = null;
         ObjectUtils.disposeObject(this._valueTitle);
         this._valueTitle = null;
         ObjectUtils.disposeObject(this._rankTitle);
         this._rankTitle = null;
         ObjectUtils.disposeObject(this._mountsLevel);
         this._mountsLevel = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._updateTimeTxt);
         this._updateTimeTxt = null;
         if(Boolean(this._RankingLiftImg))
         {
            ObjectUtils.disposeObject(this._RankingLiftImg);
         }
         this._RankingLiftImg = null;
         if(Boolean(this._levelStar))
         {
            ObjectUtils.disposeObject(this._levelStar);
         }
         this._levelStar = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get updateTimeTxt() : FilterFrameText
      {
         return this._updateTimeTxt;
      }
      
      private function __tofflistTypeHandler(evt:TofflistEvent) : void
      {
         var self:SelfInfo = PlayerManager.Instance.Self;
         var consortia:ClubInfo = PlayerManager.Instance.SelfConsortia;
         this._levelStar.visible = false;
         this._levelIcon.visible = false;
         this._RankingLiftImg.visible = false;
         this._textArr[3].visible = false;
         this._bg.gotoAndStop(2);
         this._textArr[2].text = this._mountsLevel.text = "";
         this._textArr[1].visible = this._levelTitle.visible = false;
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
               this._titleBg.setFrame(1);
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.MOUNTS:
                     this._levelStar.visible = true;
                     this._valueTitle.text = LanguageMgr.GetTranslation("tofflist.mountslevel");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.MountExp;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.MountExp,TofflistModel.Instance.rankInfo.PrevMountExp);
                     }
                     this._mountsLevel.text = int(HorseManager.instance.curLevel / 10 + 1).toString() + "   " + String(HorseManager.instance.curLevel % 10);
                     break;
                  case TofflistTwoGradeMenu.BATTLE:
                     this._valueTitle.text = LanguageMgr.GetTranslation("tank.menu.FightPoweTxt");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.FightPower;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.FightPower,TofflistModel.Instance.rankInfo.PrevFightPower);
                     }
                     this._textArr[2].text = self.FightPower;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._valueTitle.text = LanguageMgr.GetTranslation("exp");
                     this._levelTitle.visible = true;
                     this._bg.gotoAndStop(1);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.GP;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.GP,TofflistModel.Instance.rankInfo.PrevGP);
                     }
                     this._textArr[2].text = self.GP;
                     this._levelIcon.setInfo(self.Grade,self.Repute,self.WinCount,self.TotalCount,self.FightPower,self.Offer,true,false);
                     this._levelIcon.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._valueTitle.text = LanguageMgr.GetTranslation("tofflist.achivepoint");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.AchievementPoint;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.AchievementPoint,TofflistModel.Instance.rankInfo.PrevAchievementPoint);
                     }
                     this._textArr[2].text = self.AchievementPoint;
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._valueTitle.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.charmNum");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.GiftGp;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.GiftGp,TofflistModel.Instance.rankInfo.PrevGiftGp);
                     }
                     this._textArr[2].text = self.charmGP;
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this._valueTitle.text = LanguageMgr.GetTranslation("tofflist.battleScore");
                     this._textArr[0].text = BattleGroudManager.Instance.orderdata.rankings;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.LeagueAddWeek,TofflistModel.Instance.rankInfo.PrevLeagueAddWeek);
                     }
                     this._textArr[2].text = BattleGroudManager.Instance.orderdata.totalPrestige;
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               this._titleBg.setFrame(1);
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.MOUNTS:
                     this._levelStar.visible = true;
                     this._valueTitle.text = LanguageMgr.GetTranslation("tofflist.mountslevel");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.MountExp;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.MountExp,TofflistModel.Instance.rankInfo.PrevMountExp);
                     }
                     this._mountsLevel.text = int(HorseManager.instance.curLevel / 10 + 1).toString() + "   " + String(HorseManager.instance.curLevel % 10);
                     break;
                  case TofflistTwoGradeMenu.BATTLE:
                     this._valueTitle.text = LanguageMgr.GetTranslation("tank.menu.FightPoweTxt");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.FightPower;
                     this._textArr[2].text = self.FightPower;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._valueTitle.text = LanguageMgr.GetTranslation("exp");
                     this._levelTitle.visible = true;
                     this._bg.gotoAndStop(1);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.GP;
                     this._textArr[2].text = self.GP;
                     this._levelIcon.setInfo(self.Grade,self.Repute,self.WinCount,self.TotalCount,self.FightPower,self.Offer,true,false);
                     this._levelIcon.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._valueTitle.text = LanguageMgr.GetTranslation("tofflist.achivepoint");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.AchievementPoint;
                     this._textArr[2].text = self.AchievementPoint;
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._valueTitle.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.charmNum");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.GiftGp;
                     this._textArr[2].text = self.charmGP;
               }
               break;
            case TofflistStairMenu.CONSORTIA:
            default:
               this._titleBg.setFrame(2);
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._valueTitle.text = LanguageMgr.GetTranslation("tank.menu.FightPoweTxt");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaFightPower;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaFightPower,TofflistModel.Instance.rankInfo.ConsortiaPrevFightPower);
                     }
                     this._textArr[2].text = self.FightPower;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._bg.gotoAndStop(1);
                     this._valueTitle.text = LanguageMgr.GetTranslation("consortia.Money");
                     this._textArr[1].visible = this._levelTitle.visible = true;
                     if(!consortia || !self.consortiaInfo.ChairmanName)
                     {
                        this.consortiaEmpty();
                     }
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaLevel;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaLevel,TofflistModel.Instance.rankInfo.ConsortiaPrevLevel);
                     }
                     this._textArr[2].text = self.consortiaInfo.Riches;
                     this._textArr[1].text = self.consortiaInfo.Level;
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this._valueTitle.text = LanguageMgr.GetTranslation("tofflist.totalasset");
                     if(!consortia || !self.consortiaInfo.ChairmanName)
                     {
                        this.consortiaEmpty();
                     }
                     else
                     {
                        this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaRiches;
                        if(TofflistModel.Instance.rankInfo != null)
                        {
                           this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaRiches,TofflistModel.Instance.rankInfo.ConsortiaPrevRiches);
                        }
                        this._textArr[2].text = self.consortiaInfo.Riches;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._valueTitle.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.charmNum");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaGiftGp;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaGiftGp,TofflistModel.Instance.rankInfo.ConsortiaPrevGiftGp);
                     }
                     this._textArr[2].text = self.consortiaInfo.CharmGP;
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               this._titleBg.setFrame(2);
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._valueTitle.text = LanguageMgr.GetTranslation("tank.menu.FightPoweTxt");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaFightPower;
                     this._textArr[2].text = self.FightPower;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._valueTitle.text = LanguageMgr.GetTranslation("consortia.Money");
                     this._textArr[1].visible = this._levelTitle.visible = true;
                     this._bg.gotoAndStop(1);
                     if(!consortia || !self.consortiaInfo.ChairmanName)
                     {
                        this.consortiaEmpty();
                     }
                     else
                     {
                        this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaLevel;
                        this._textArr[2].text = self.consortiaInfo.Riches;
                        this._textArr[1].text = self.consortiaInfo.Level;
                     }
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this._valueTitle.text = LanguageMgr.GetTranslation("tofflist.totalasset");
                     if(!consortia || !self.consortiaInfo.ChairmanName)
                     {
                        this.consortiaEmpty();
                     }
                     else
                     {
                        this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaRiches;
                        this._textArr[2].text = self.consortiaInfo.Riches;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._valueTitle.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.charmNum");
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaGiftGp;
                     this._textArr[2].text = self.charmGP;
               }
         }
         if(TofflistModel.secondMenuType != TofflistTwoGradeMenu.LEVEL)
         {
            PositionUtils.setPos(this._RankingLiftImg,"tofflist.rankImagePos1");
            PositionUtils.setPos(this._textArr[3],"tofflist.comparePos1");
            PositionUtils.setPos(this._valueTitle,"tofflist.valueTitlePos1");
            PositionUtils.setPos(this._textArr[2],"tofflist.valueTextPos1");
         }
         else
         {
            PositionUtils.setPos(this._RankingLiftImg,"tofflist.rankImagePos2");
            PositionUtils.setPos(this._textArr[3],"tofflist.comparePos2");
            PositionUtils.setPos(this._valueTitle,"tofflist.valueTitlePos2");
            PositionUtils.setPos(this._textArr[2],"tofflist.valueTextPos2");
         }
         this._textArr[3].x -= this._textArr[3].textWidth / 2;
         this._valueTitle.x -= this._valueTitle.textWidth / 2;
         this._textArr[2].x -= this._textArr[2].textWidth / 2;
      }
      
      private function getToffistPlayerInfo(id:int) : TofflistPlayerInfo
      {
         var data:TofflistPlayerInfo = null;
         var len:int = int(TofflistModel.Instance.personalMatchesWeek.list.length);
         for(var i:int = 0; i < len; i++)
         {
            data = TofflistModel.Instance.personalMatchesWeek.list[i];
            if(data.ID == id)
            {
               return data;
            }
         }
         return null;
      }
      
      private function addEvent() : void
      {
         TofflistModel.addEventListener(TofflistEvent.RANKINFO_READY,this.__rankInfoHandler);
         TofflistModel.addEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,this.__tofflistTypeHandler);
      }
      
      private function __rankInfoHandler(event:TofflistEvent) : void
      {
         this.__tofflistTypeHandler(null);
      }
      
      private function consortiaEmpty() : void
      {
         this._textArr[0].text = this._textArr[2].text = LanguageMgr.GetTranslation("tank.tofflist.view.TofflistLeftInfo.no");
      }
      
      private function onComPare(nowN:Number, PreN:Number) : void
      {
         var num:int = 0;
         this._RankingLiftImg.visible = true;
         if(TofflistModel.Instance.rankInfo != null && nowN < PreN)
         {
            this._RankingLiftImg.setFrame(1);
            num = PreN - nowN;
            this._textArr[3].text = num;
         }
         if(TofflistModel.Instance.rankInfo != null && nowN > PreN)
         {
            this._RankingLiftImg.setFrame(2);
            num = nowN - PreN;
            this._textArr[3].text = num;
         }
         if(TofflistModel.Instance.rankInfo != null && (nowN == PreN || PreN == 0))
         {
            this._RankingLiftImg.visible = false;
            this._textArr[3].text = "";
         }
         this._textArr[3].visible = this._RankingLiftImg.visible;
      }
      
      private function init() : void
      {
         this._textArr = [];
         this._bg = ClassUtils.CreatInstance("asset.tofflist.infobgAsset");
         this._bg.gotoAndStop(2);
         addChild(this._bg);
         this._titleBg = ComponentFactory.Instance.creatComponentByStylename("toffilist.lefeinfoTitleBg");
         addChild(this._titleBg);
         this._rankTitle = ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoRankTitleText");
         addChild(this._rankTitle);
         this._rankTitle.text = LanguageMgr.GetTranslation("repute");
         this._levelTitle = ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoLevelTitleText");
         addChild(this._levelTitle);
         this._levelTitle.text = LanguageMgr.GetTranslation("tank.menu.LevelTxt");
         this._valueTitle = ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoValueTitleText");
         addChild(this._valueTitle);
         this._textArr.push(addChild(ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoRankText")));
         this._textArr.push(addChild(ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoLevelText")));
         this._textArr.push(addChild(ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoValueText")));
         this._textArr.push(addChild(ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoComPareText")));
         this._updateTimeTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.updateTimeTxt");
         addChild(this._updateTimeTxt);
         this._RankingLiftImg = ComponentFactory.Instance.creatComponentByStylename("toffilist.RankingLift");
         addChild(this._RankingLiftImg);
         this._levelIcon = new LevelIcon();
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         PositionUtils.setPos(this._levelIcon,"tofflist.levelIconPos");
         addChild(this._levelIcon);
         this._levelIcon.visible = false;
         this._RankingLiftImg.visible = false;
         this._levelStar = ComponentFactory.Instance.creat("asset.Toffilist.levelStarTxtImage");
         PositionUtils.setPos(this._levelStar,"tofflist.myRank.levelStarPos");
         addChild(this._levelStar);
         this._mountsLevel = ComponentFactory.Instance.creatComponentByStylename("toffilist.mountsLevelText");
         addChild(this._mountsLevel);
      }
      
      private function removeEvent() : void
      {
         TofflistModel.removeEventListener(TofflistEvent.RANKINFO_READY,this.__rankInfoHandler);
         TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,this.__tofflistTypeHandler);
      }
   }
}

