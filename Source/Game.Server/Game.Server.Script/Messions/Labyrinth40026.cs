// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.Labyrinth40026
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
  public class Labyrinth40026 : AMissionControl
  {
    private int bossID = 40039;
    private int bossID2 = 40040;
    private int bossID3 = 40038;
    private int npcIDl = 40044;
    private int npcIDr = 40043;
    private int npcID2 = 40045;
    private int npcID3 = 40046;
    private SimpleBoss boss;
    private SimpleBoss boss2;
    private SimpleBoss boss3;
    private int kill = 0;
    private int m_state = 40041;
    private int turn = 0;

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
      int[] npcIds = new int[7]
      {
        this.bossID,
        this.bossID2,
        this.bossID3,
        this.npcIDl,
        this.npcIDr,
        this.npcID2,
        this.npcID3
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.AddLoadingFile(2, "image/bomb/blastOut/blastOut51.swf", "bullet51");
      this.Game.AddLoadingFile(2, "image/bomb/bullet/bullet51.swf", "bullet51");
      this.Game.SetMap(1280);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsFly = true;
      this.boss = this.Game.CreateBoss(this.bossID, 1316, 444, -1, 1, "", config);
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
    }

    public override void OnNewTurnStarted()
    {
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      if (!this.boss.IsLiving && this.boss2 == null)
      {
        LivingConfig config = this.Game.BaseLivingConfig();
        config.IsFly = true;
        this.boss2 = this.Game.CreateBoss(this.bossID2, this.boss.X, this.boss.Y, this.boss.Direction, 2, "", config);
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
      if (this.boss2 != null && !this.boss2.IsLiving && this.boss3 == null)
      {
        LivingConfig config = this.Game.BaseLivingConfig();
        config.IsFly = true;
        this.boss3 = this.Game.CreateBoss(this.bossID3, this.boss.X, this.boss.Y, this.boss.Direction, 2, "", config);
        this.Game.RemoveLiving(this.boss2.Id);
        if (this.boss3.Direction == 1)
          this.boss3.SetRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
        this.boss3.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
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
        this.boss3.AddDelay(num - 2000);
        this.turn = this.Game.TurnIndex;
      }
      if (this.boss3 != null && !this.boss3.IsLiving)
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
      if (this.boss3 != null && !this.boss3.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public override void OnGameOver() => base.OnGameOver();
  }
}
