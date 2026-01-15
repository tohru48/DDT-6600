// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.DCH4203
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class DCH4203 : AMissionControl
  {
    private PhysicalObj m_kingMoive;
    private PhysicalObj m_kingFront;
    private SimpleBoss m_king = (SimpleBoss) null;
    private SimpleBoss m_secondKing = (SimpleBoss) null;
    private PhysicalObj[] m_leftWall = (PhysicalObj[]) null;
    private PhysicalObj[] m_rightWall = (PhysicalObj[]) null;
    private int m_kill = 0;
    private int m_state = 4208;
    private int turn = 0;
    private int firstBossID = 4208;
    private int secondBossID = 4209;
    private int npcID = 4207;
    private int direction;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1150)
        return 3;
      if (score > 925)
        return 2;
      return score > 700 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.emozhanshiAsset");
      this.Game.AddLoadingFile(2, "image/game/effect/4/power.swf", "game.crazytank.assetmap.Buff_powup");
      this.Game.AddLoadingFile(2, "image/game/effect/4/blade.swf", "asset.game.4.blade");
      this.Game.AddLoadingFile(2, "image/game/living/living141.swf", "game.living.Living141");
      this.Game.LoadResources(new int[3]
      {
        this.firstBossID,
        this.secondBossID,
        this.npcID
      });
      this.Game.LoadNpcGameOverResources(new int[1]
      {
        this.firstBossID
      });
      this.Game.SetMap(1144);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_kingMoive = (PhysicalObj) this.Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_kingFront = (PhysicalObj) this.Game.Createlayer(720, 495, "font", "game.asset.living.boguoKingAsset", "out", 1, 1);
      this.m_king = this.Game.CreateBoss(this.m_state, 1200, 790, -1, 1, "");
      this.m_king.FallFromTo(this.m_king.X, this.m_king.Y, (string) null, 0, 0, 2000, (LivingCallBack) null);
      this.m_king.SetRelateDemagemRect(-41, -187, 83, 140);
      this.m_king.AddDelay(10);
      this.m_king.Say(LanguageMgr.GetTranslation("Nơi cái xấu nắm giữ các ngươi chỉ có thể chết !"), 0, 200, 0);
      this.m_king.PlayMovie("in", 0, 2300);
      this.m_kingFront.PlayMovie("in", 9000, 0);
      this.m_kingMoive.PlayMovie("out", 13000, 0);
      this.m_kingFront.PlayMovie("out", 13400, 0);
      this.turn = this.Game.TurnIndex;
      this.Game.BossCardCount = 1;
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex <= this.turn + 1)
        return;
      if (this.m_kingMoive != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingMoive, true);
        this.m_kingMoive = (PhysicalObj) null;
      }
      if (this.m_kingFront != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingFront, true);
        this.m_kingFront = (PhysicalObj) null;
      }
    }

    public override bool CanGameOver()
    {
      base.CanGameOver();
      if (!this.m_king.IsLiving && this.m_state == this.firstBossID)
        ++this.m_state;
      if (this.m_state == this.secondBossID && this.m_secondKing == null)
      {
        this.m_secondKing = this.Game.CreateBoss(this.m_state, this.m_king.X, this.m_king.Y, this.m_king.Direction, 2, "");
        this.Game.RemoveLiving(this.m_king.Id);
        if (this.m_secondKing.Direction == 1)
          this.m_secondKing.SetRelateDemagemRect(-41, -187, 83, 140);
        this.m_secondKing.SetRelateDemagemRect(-41, -187, 83, 140);
        this.m_secondKing.Say(LanguageMgr.GetTranslation("Chống cự chỉ là vô nghĩa !"), 0, 3000);
        List<Player> allFightPlayers = this.Game.GetAllFightPlayers();
        Player randomPlayer = this.Game.FindRandomPlayer();
        int num = 0;
        if (randomPlayer != null)
          num = randomPlayer.Delay;
        foreach (Player player in allFightPlayers)
        {
          if (player.Delay < num)
            num = player.Delay;
        }
        this.m_secondKing.AddDelay(num - 2000);
        this.turn = this.Game.TurnIndex;
      }
      if (this.m_secondKing == null || this.m_secondKing.IsLiving)
        return false;
      this.direction = this.m_secondKing.Direction;
      ++this.m_kill;
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.m_kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.m_state == this.secondBossID && !this.m_secondKing.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      this.m_leftWall = this.Game.FindPhysicalObjByName("wallLeft");
      this.m_rightWall = this.Game.FindPhysicalObjByName("wallRight");
      for (int index = 0; index < this.m_leftWall.Length; ++index)
        this.Game.RemovePhysicalObj(this.m_leftWall[index], true);
      for (int index = 0; index < this.m_rightWall.Length; ++index)
        this.Game.RemovePhysicalObj(this.m_rightWall[index], true);
    }
  }
}
