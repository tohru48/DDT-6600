// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.Labyrinth40040
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class Labyrinth40040 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleBoss boss2 = (SimpleBoss) null;
    private int kill = 0;
    private int m_state = 40065;
    private int turn = 0;
    private int bossID = 40065;
    private int bossID2 = 40066;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1870)
        return 3;
      if (score > 1825)
        return 2;
      return score > 1780 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds1 = new int[2]
      {
        this.bossID,
        this.bossID2
      };
      int[] npcIds2 = new int[2]
      {
        this.bossID,
        this.bossID2
      };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.SetMap(1318);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.boss = this.Game.CreateBoss(this.bossID, 1169, 606, -1, 1, "");
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      this.boss.AddDelay(10);
      this.turn = this.Game.TurnIndex;
    }

    public override void OnNewTurnStarted()
    {
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      if (!this.boss.IsLiving && this.m_state == this.bossID)
        ++this.m_state;
      if (this.m_state == this.bossID2 && this.boss2 == null)
      {
        LivingConfig config = this.Game.BaseLivingConfig();
        config.IsFly = true;
        this.boss2 = this.Game.CreateBoss(this.m_state, this.boss.X, 606, this.boss.Direction, 2, "", config);
        this.Game.RemoveLiving(this.boss.Id);
        if (this.boss2.Direction == 1)
          this.boss2.SetRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
        this.boss2.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
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
        this.boss2.AddDelay(num - 2000);
        this.turn = this.Game.TurnIndex;
      }
      if (this.boss2 != null && !this.boss2.IsLiving)
      {
        if (this.Game.CanEnterGate)
          return true;
        ++this.kill;
        this.Game.CanShowBigBox = true;
      }
      return false;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOverMovie()
    {
      base.OnGameOverMovie();
      if (this.boss2 != null && !this.boss2.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public override void OnGameOver() => base.OnGameOver();
  }
}
