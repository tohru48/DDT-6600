// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.QX70001
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.Actions;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class QX70001 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleBoss lastBoss = (SimpleBoss) null;
    private SimpleNpc npc = (SimpleNpc) null;
    private LivingConfig config;
    private int bossID = 0;
    private int m_state = 0;
    private int kill = 0;
    private int[] resources = new int[10]
    {
      70001,
      70002,
      70003,
      70006,
      70007,
      70008,
      70009,
      70010,
      70011,
      70099
    };

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1750)
        return 3;
      if (score > 1675)
        return 2;
      return score > 1600 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.LoadResources(this.resources);
      this.Game.LoadNpcGameOverResources(this.resources);
      this.Game.SetMap(1311);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.AddAction((IAction) new CallFunctionAction(new LivingCallBack(this.AddNpc), 2000));
      this.config = this.Game.BaseLivingConfig();
      this.config.IsFly = true;
    }

    private void AddNpc()
    {
      this.config.HasTurn = false;
      this.npc = this.Game.CreateNpc(this.resources[9], 220, 630, 0, 1, this.config);
      this.Game.SendGameFocus((Physics) this.npc, 0, 1000);
      this.npc.SetRelateDemagemRect(0, 0, 0, 0);
      this.npc.CallFuction(new LivingCallBack(this.AddBoss), 3000);
    }

    private void AddBoss()
    {
      this.m_state = this.resources[this.bossID];
      this.config.HasTurn = true;
      this.boss = this.Game.CreateBoss(this.m_state, 1120, 763, -1, 1, "", this.config);
      this.Game.SendGameFocus((Physics) this.boss, 0, 1000);
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      ++this.bossID;
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    private int MinDelay()
    {
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
      return num;
    }

    private void AddNextBoss()
    {
      this.Game.RemoveLiving(this.boss.Id);
      this.m_state = this.resources[this.bossID];
      this.config.IsFly = this.bossID <= 2 || this.bossID >= 8;
      this.boss = this.Game.CreateBoss(this.m_state, this.boss.X, this.boss.Y, this.boss.Direction, 1, "", this.config);
      if (this.boss.Direction == 1)
        this.boss.SetRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      this.boss.AddDelay(this.MinDelay() - 2000);
      ++this.bossID;
    }

    private void AddLastBoss()
    {
      this.Game.RemoveLiving(this.boss.Id);
      this.m_state = this.resources[this.bossID];
      this.lastBoss = this.Game.CreateBoss(this.m_state, this.boss.X, this.boss.Y, this.boss.Direction, 1, "");
      if (this.lastBoss.Direction == 1)
      {
        this.lastBoss.SetRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
        this.lastBoss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      }
      this.lastBoss.AddDelay(this.MinDelay() - 2000);
    }

    public override bool CanGameOver()
    {
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      if (!this.boss.IsLiving && this.bossID < 8)
      {
        this.UpdateAward(this.boss.NpcInfo.DropId, this.boss.IsLiving);
        this.AddNextBoss();
      }
      if (this.m_state == this.resources[7] && !this.boss.IsLiving && this.lastBoss == null)
      {
        this.UpdateAward(this.boss.NpcInfo.DropId, this.boss.IsLiving);
        this.AddLastBoss();
      }
      if (this.lastBoss == null || this.lastBoss.IsLiving)
        return false;
      this.UpdateAward(this.lastBoss.NpcInfo.DropId, this.lastBoss.IsLiving);
      ++this.kill;
      return true;
    }

    private void UpdateAward(int dropID, bool IsLiving)
    {
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer.PlayerDetail.UpdatePveResult("qx", dropID, IsLiving);
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.lastBoss != null && !this.lastBoss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
