package fightFootballTime.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.GameManager;
   import game.model.LocalPlayer;
   import game.view.experience.ExpLeftView;
   
   public class FightFootballTimeExpLeftView extends ExpLeftView implements Disposeable
   {
      
      private var resultIcon:MovieClip;
      
      private var overInfoBg:Bitmap;
      
      private var myScoreBg:Bitmap;
      
      private var scoreInfoBg:Bitmap;
      
      private var exptxt:Bitmap;
      
      private var totaltxt:Bitmap;
      
      private var goldtxt:Bitmap;
      
      private var jiahao:Bitmap;
      
      private var fenge:Bitmap;
      
      private var fenge2:Bitmap;
      
      private var stateIcon:MovieClip;
      
      private var charater:MovieClip;
      
      private var scoretxt:GradientText;
      
      private var finalexptxt:GradientText;
      
      private var finalscore:int;
      
      private var finalexp:int;
      
      private var scoreBg:Bitmap;
      
      private var expBg:Bitmap;
      
      private var redTeamIcon:MovieClip;
      
      private var blueTeamIcon:MovieClip;
      
      private var redScore:FilterFrameText;
      
      private var blueScore:FilterFrameText;
      
      private var bifen:Bitmap;
      
      private var door1:MovieClip;
      
      private var door2:MovieClip;
      
      private var door3:MovieClip;
      
      private var door4:MovieClip;
      
      private var door5:MovieClip;
      
      private var time1:MovieClip;
      
      private var time2:MovieClip;
      
      private var time3:MovieClip;
      
      private var time4:MovieClip;
      
      private var time5:MovieClip;
      
      private var doorScore1:int = 0;
      
      private var doorScore2:int = 0;
      
      private var doorScore3:int = 0;
      
      private var doorScore4:int = 0;
      
      private var doorScore5:int = 0;
      
      private var upView:Sprite;
      
      private var downView:Sprite;
      
      public function FightFootballTimeExpLeftView()
      {
         super();
      }
      
      override protected function init() : void
      {
         var self:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         var scoreArr:Array = self.selfInfo.scoreArr;
         this.getStateIcon();
         this.getUpView();
         this.getDownView();
         this.getScore(GameManager.Instance.Current.redScore,GameManager.Instance.Current.blueScore);
         this.getDoor(scoreArr);
         var totalScore:int = 0;
         for(var i:int = 0; i < scoreArr.length; i++)
         {
            totalScore += scoreArr[i];
         }
         var totalExp:int = totalScore * 50;
         this.getScoreAndExp(totalScore,totalExp);
         addChild(this.stateIcon);
      }
      
      private function getCharater(team:int, sex:int) : void
      {
         if(team == 0 && sex == 0)
         {
            this.charater.gotoAndStop("blue_boy");
            this.charater.scaleX = -1;
            PositionUtils.setPos(this.charater,"fightFootballTime.expView.charaterpos");
         }
         else if(team == 0 && sex == 1)
         {
            this.charater.gotoAndStop("blue_girl");
            this.charater.scaleX = -1;
            PositionUtils.setPos(this.charater,"fightFootballTime.expView.charaterpos");
         }
         else if(team == 1 && sex == 0)
         {
            this.charater.gotoAndStop("red_boy");
            this.charater.scaleX = -1;
            PositionUtils.setPos(this.charater,"fightFootballTime.expView.charaterpos");
         }
         else if(team == 1 && sex == 1)
         {
            this.charater.gotoAndStop("red_gril");
            this.charater.scaleX = -1;
            PositionUtils.setPos(this.charater,"fightFootballTime.expView.charaterpos");
         }
      }
      
      private function getScore(red:int, blue:int) : void
      {
         this.redTeamIcon = ComponentFactory.Instance.creat("fightFootballTime.expView.teamIcon");
         this.blueTeamIcon = ComponentFactory.Instance.creat("fightFootballTime.expView.teamIcon");
         this.redTeamIcon.gotoAndStop("red_small");
         this.blueTeamIcon.gotoAndStop("blue_small");
         this.redScore = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.expView.RedScoreTxt");
         this.blueScore = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.expView.BlueScoreTxt");
         this.bifen = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.bihao");
         var team:int = GameManager.Instance.Current.selfGamePlayer.team;
         if(team == 1)
         {
            PositionUtils.setPos(this.blueTeamIcon,"fightFootballTime.expView.redTeamIconpos1");
            PositionUtils.setPos(this.redTeamIcon,"fightFootballTime.expView.blueTeamIconpos1");
            PositionUtils.setPos(this.blueScore,"fightFootballTime.expView.redScorepos1");
            PositionUtils.setPos(this.redScore,"fightFootballTime.expView.blueScorepos1");
            PositionUtils.setPos(this.bifen,"fightFootballTime.expView.bihaopos1");
         }
         else if(team == 2)
         {
            PositionUtils.setPos(this.redTeamIcon,"fightFootballTime.expView.redTeamIconpos1");
            PositionUtils.setPos(this.blueTeamIcon,"fightFootballTime.expView.blueTeamIconpos1");
            PositionUtils.setPos(this.redScore,"fightFootballTime.expView.redScorepos1");
            PositionUtils.setPos(this.blueScore,"fightFootballTime.expView.blueScorepos1");
            PositionUtils.setPos(this.bifen,"fightFootballTime.expView.bihaopos1");
         }
         this.redScore.text = red + "";
         this.blueScore.text = blue + "";
         this.upView.addChild(this.redTeamIcon);
         this.upView.addChild(this.blueTeamIcon);
         this.upView.addChild(this.redScore);
         this.upView.addChild(this.blueScore);
         this.upView.addChild(this.bifen);
      }
      
      private function getDoor(scoreList:Array) : void
      {
         var noScore:Bitmap = null;
         this.door1 = ComponentFactory.Instance.creat("fightFootballTime.expView.door");
         this.door2 = ComponentFactory.Instance.creat("fightFootballTime.expView.door");
         this.door3 = ComponentFactory.Instance.creat("fightFootballTime.expView.door");
         this.door4 = ComponentFactory.Instance.creat("fightFootballTime.expView.door");
         this.door5 = ComponentFactory.Instance.creat("fightFootballTime.expView.door");
         this.time1 = ComponentFactory.Instance.creat("fightFootballTime.expView.cishu");
         this.time2 = ComponentFactory.Instance.creat("fightFootballTime.expView.cishu");
         this.time3 = ComponentFactory.Instance.creat("fightFootballTime.expView.cishu");
         this.time4 = ComponentFactory.Instance.creat("fightFootballTime.expView.cishu");
         this.time5 = ComponentFactory.Instance.creat("fightFootballTime.expView.cishu");
         this.door1.gotoAndStop(1);
         this.door2.gotoAndStop(2);
         this.door3.gotoAndStop(3);
         this.door4.gotoAndStop(4);
         this.door5.gotoAndStop(5);
         PositionUtils.setPos(this.door1,"fightFootballTime.expView.doorpos1");
         PositionUtils.setPos(this.door2,"fightFootballTime.expView.doorpos2");
         PositionUtils.setPos(this.door3,"fightFootballTime.expView.doorpos3");
         PositionUtils.setPos(this.door4,"fightFootballTime.expView.doorpos4");
         PositionUtils.setPos(this.door5,"fightFootballTime.expView.doorpos5");
         for(var i:int = 0; i < scoreList.length; i++)
         {
            if(scoreList[i] != 0)
            {
               if(scoreList[i] == 1)
               {
                  ++this.doorScore1;
               }
               else if(scoreList[i] == 2)
               {
                  ++this.doorScore2;
               }
               else if(scoreList[i] == 3)
               {
                  ++this.doorScore3;
               }
               else if(scoreList[i] == 4)
               {
                  ++this.doorScore4;
               }
               else if(scoreList[i] == 5)
               {
                  ++this.doorScore5;
               }
            }
         }
         this.time1.gotoAndStop(this.doorScore1 + 1);
         this.time2.gotoAndStop(this.doorScore2 + 1);
         this.time3.gotoAndStop(this.doorScore3 + 1);
         this.time4.gotoAndStop(this.doorScore4 + 1);
         this.time5.gotoAndStop(this.doorScore5 + 1);
         PositionUtils.setPos(this.time1,"fightFootballTime.expView.timepos1");
         PositionUtils.setPos(this.time2,"fightFootballTime.expView.timepos2");
         PositionUtils.setPos(this.time3,"fightFootballTime.expView.timepos3");
         PositionUtils.setPos(this.time4,"fightFootballTime.expView.timepos4");
         PositionUtils.setPos(this.time5,"fightFootballTime.expView.timepos5");
         if(this.doorScore1 == 0 && this.doorScore2 == 0 && this.doorScore3 == 0 && this.doorScore4 == 0 && this.doorScore5 == 0)
         {
            noScore = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.noScoreTxt");
            this.upView.addChild(noScore);
         }
         else
         {
            this.upView.addChild(this.door1);
            this.upView.addChild(this.door2);
            this.upView.addChild(this.door3);
            this.upView.addChild(this.door4);
            this.upView.addChild(this.door5);
            this.upView.addChild(this.time1);
            this.upView.addChild(this.time2);
            this.upView.addChild(this.time3);
            this.upView.addChild(this.time4);
            this.upView.addChild(this.time5);
         }
      }
      
      private function getUpView() : void
      {
         this.upView = new Sprite();
         this.myScoreBg = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.myScoreBg");
         this.scoreInfoBg = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.scoreInfoBg");
         this.fenge = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.fenge");
         this.fenge2 = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.fenge");
         PositionUtils.setPos(this.fenge2,"fightFootballTime.expView.fengepos");
         this.charater = ComponentFactory.Instance.creat("fightFootballTime.expView.charater");
         var team:int = GameManager.Instance.Current.selfGamePlayer.team;
         var sex:int = GameManager.Instance.Current.selfGamePlayer.playerInfo.SexByInt;
         this.getCharater(team - 1,sex - 1);
         this.upView.addChild(this.scoreInfoBg);
         this.upView.addChild(this.myScoreBg);
         this.upView.addChild(this.fenge);
         this.upView.addChild(this.fenge2);
         this.upView.addChild(this.charater);
         addChild(this.upView);
         this.upView.alpha = 0;
         this.upView.x = -100;
         TweenLite.to(this.upView,1,{
            "x":0,
            "alpha":1
         });
      }
      
      private function getScoreAndExp(score:int, exp:int) : void
      {
         this.finalscore = score;
         this.finalexp = exp;
         this.scoretxt = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.expView.finalScoreTxt");
         this.finalexptxt = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.expView.finalScoreTxt");
         PositionUtils.setPos(this.scoretxt,"fightFootballTime.expView.scoretxtpos");
         PositionUtils.setPos(this.finalexptxt,"fightFootballTime.expView.exptxtpos");
         this.scoretxt.text = 0 + "";
         this.finalexptxt.text = 0 + "";
         this.downView.addChild(this.scoretxt);
         this.downView.addChild(this.finalexptxt);
         var timer:Timer = new Timer(1,0);
         timer.addEventListener(TimerEvent.TIMER,this._increaceScore);
         timer.start();
      }
      
      private function _increaceScore(e:TimerEvent) : void
      {
         var timer:Timer = e.currentTarget as Timer;
         var count:int = timer.currentCount * 10;
         if(count < this.finalscore)
         {
            this.scoretxt.text = count + "";
         }
         else
         {
            this.scoretxt.text = this.finalscore + "";
         }
         if(count < this.finalexp)
         {
            this.finalexptxt.text = count + "";
         }
         else
         {
            this.finalexptxt.text = this.finalexp + "";
         }
         if(this.finalexptxt.text == this.finalexp + "" && this.scoretxt.text == this.finalscore + "")
         {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,this._increaceScore);
            timer = null;
         }
      }
      
      private function getDownView() : void
      {
         this.downView = new Sprite();
         this.overInfoBg = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.overInfoBg");
         this.totaltxt = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.totaltxt");
         this.goldtxt = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.goldtxt");
         this.exptxt = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.exptxt");
         this.jiahao = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.jiahao");
         this.scoreBg = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.scoreTxtBg");
         this.expBg = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.expTxtBg");
         this.downView.addChild(this.overInfoBg);
         this.downView.addChild(this.totaltxt);
         this.downView.addChild(this.goldtxt);
         this.downView.addChild(this.exptxt);
         this.downView.addChild(this.jiahao);
         this.downView.addChild(this.scoreBg);
         this.downView.addChild(this.expBg);
         addChild(this.downView);
         this.downView.alpha = 0;
         this.downView.x = -100;
         TweenLite.to(this.downView,1.5,{
            "x":0,
            "alpha":1
         });
      }
      
      private function getStateIcon() : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.isWin)
         {
            this.stateIcon = ComponentFactory.Instance.creat("fightFootballTime.expView.stateIconWin");
            PositionUtils.setPos(this.stateIcon,"fightFootballTime.expView.stateIconWinpos");
         }
         else if(!GameManager.Instance.Current.selfGamePlayer.isWin)
         {
            if(GameManager.Instance.Current.redScore == GameManager.Instance.Current.blueScore && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
            {
               this.stateIcon = ComponentFactory.Instance.creat("fightFootballTime.expView.stateIconPing");
               PositionUtils.setPos(this.stateIcon,"fightFootballTime.expView.stateIconPingpos");
            }
            else
            {
               this.stateIcon = ComponentFactory.Instance.creat("fightFootballTime.expView.stateIconFail");
               PositionUtils.setPos(this.stateIcon,"fightFootballTime.expView.stateIconFailpos");
            }
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.resultIcon))
         {
            ObjectUtils.disposeObject(this.resultIcon);
         }
         this.resultIcon = null;
         if(Boolean(this.overInfoBg))
         {
            ObjectUtils.disposeObject(this.overInfoBg);
         }
         this.overInfoBg = null;
         if(Boolean(this.myScoreBg))
         {
            ObjectUtils.disposeObject(this.myScoreBg);
         }
         this.myScoreBg = null;
         if(Boolean(this.scoreInfoBg))
         {
            ObjectUtils.disposeObject(this.scoreInfoBg);
         }
         this.scoreInfoBg = null;
         if(Boolean(this.exptxt))
         {
            ObjectUtils.disposeObject(this.exptxt);
         }
         this.exptxt = null;
         if(Boolean(this.totaltxt))
         {
            ObjectUtils.disposeObject(this.totaltxt);
         }
         this.totaltxt = null;
         if(Boolean(this.goldtxt))
         {
            ObjectUtils.disposeObject(this.goldtxt);
         }
         this.goldtxt = null;
         if(Boolean(this.jiahao))
         {
            ObjectUtils.disposeObject(this.jiahao);
         }
         this.jiahao = null;
         if(Boolean(this.fenge))
         {
            ObjectUtils.disposeObject(this.fenge);
         }
         this.fenge = null;
         if(Boolean(this.fenge2))
         {
            ObjectUtils.disposeObject(this.fenge2);
         }
         this.fenge2 = null;
         if(Boolean(this.stateIcon))
         {
            ObjectUtils.disposeObject(this.stateIcon);
         }
         this.stateIcon = null;
         if(Boolean(this.charater))
         {
            ObjectUtils.disposeObject(this.charater);
         }
         this.charater = null;
         if(Boolean(this.scoretxt))
         {
            ObjectUtils.disposeObject(this.scoretxt);
         }
         this.scoretxt = null;
         if(Boolean(this.finalexptxt))
         {
            ObjectUtils.disposeObject(this.finalexptxt);
         }
         this.finalexptxt = null;
         if(Boolean(this.scoreBg))
         {
            ObjectUtils.disposeObject(this.scoreBg);
         }
         this.scoreBg = null;
         if(Boolean(this.expBg))
         {
            ObjectUtils.disposeObject(this.expBg);
         }
         this.expBg = null;
         if(Boolean(this.redTeamIcon))
         {
            ObjectUtils.disposeObject(this.redTeamIcon);
         }
         this.redTeamIcon = null;
         if(Boolean(this.blueTeamIcon))
         {
            ObjectUtils.disposeObject(this.blueTeamIcon);
         }
         this.blueTeamIcon = null;
         if(Boolean(this.redScore))
         {
            ObjectUtils.disposeObject(this.redScore);
         }
         this.redScore = null;
         if(Boolean(this.blueScore))
         {
            ObjectUtils.disposeObject(this.blueScore);
         }
         this.blueScore = null;
         if(Boolean(this.bifen))
         {
            ObjectUtils.disposeObject(this.bifen);
         }
         this.bifen = null;
         if(Boolean(this.door1))
         {
            ObjectUtils.disposeObject(this.door1);
         }
         this.door1 = null;
         if(Boolean(this.door2))
         {
            ObjectUtils.disposeObject(this.door2);
         }
         this.door2 = null;
         if(Boolean(this.time1))
         {
            ObjectUtils.disposeObject(this.time1);
         }
         this.time1 = null;
         if(Boolean(this.time2))
         {
            ObjectUtils.disposeObject(this.time2);
         }
         this.time2 = null;
         if(Boolean(this.upView))
         {
            ObjectUtils.disposeObject(this.upView);
         }
         this.upView = null;
         if(Boolean(this.downView))
         {
            ObjectUtils.disposeObject(this.downView);
         }
         this.downView = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

