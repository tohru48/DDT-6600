// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.TVS12001
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class TVS12001 : AMissionControl
  {
    private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();
    private SimpleNpc npc;
    private bool result = false;
    private int preKillNum = 0;
    public int turnCount;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      return score > 825 ? 2 : (score > 725 ? 1 : 0);
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds = new int[4]
      {
        12001,
        12002,
        12003,
        12004
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1207);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.PveGameDelay = 0;
      for (int index = 0; index < 4; ++index)
      {
        if (index < 1)
          this.SomeNpc.Add(this.Game.CreateNpc(12001, 1360, 700, -1, 1));
        else if (index < 3)
          this.SomeNpc.Add(this.Game.CreateNpc(12001, 1410, 700, -1, 1));
        else
          this.SomeNpc.Add(this.Game.CreateNpc(12002, 1250, 700, -1, 1));
      }
      this.npc = this.Game.CreateNpc(12004, 700, 700, -1, 0);
      this.npc.FallFrom(this.npc.X, this.npc.Y, "", 0, 0, 1200, (LivingCallBack) null);
      this.npc.SetRelateDemagemRect(-42, -200, 84, 194);
      this.turnCount = 0;
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.PveGameDelay = 0;
      if (this.Game.TurnIndex > 1 && this.Game.CurrentPlayer.Delay > this.Game.PveGameDelay)
      {
        for (int index = 0; index < 4; ++index)
        {
          if (this.turnCount < 12)
          {
            ++this.turnCount;
            if (index < 1)
              this.SomeNpc.Add(this.Game.CreateNpc(12001, 1260, 700, -1, 1));
            else if (index < 3)
              this.SomeNpc.Add(this.Game.CreateNpc(12001, 1350, 700, -1, 1));
            else
              this.SomeNpc.Add(this.Game.CreateNpc(12002, 1400, 700, -1, 1));
          }
        }
      }
      if (this.Game.TurnIndex == 2)
        ;
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      base.CanGameOver();
      if (this.Game.TurnIndex > 199)
        return true;
      this.result = false;
      foreach (Physics physics in this.SomeNpc)
      {
        if (physics.IsLiving)
          this.result = true;
      }
      return !this.result && this.SomeNpc.Count == 16 || !this.npc.IsLiving;
    }

    public override int UpdateUIData()
    {
      this.preKillNum = this.Game.TotalKillCount;
      return this.Game.TotalKillCount;
    }

    public override void OnGameOver()
    {
      if (!this.result && this.SomeNpc.Count == 16)
      {
        foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
          allFightPlayer.CanGetProp = true;
        this.Game.IsWin = true;
      }
      if (this.npc.IsLiving)
        return;
      this.Game.IsWin = false;
    }
  }
}
