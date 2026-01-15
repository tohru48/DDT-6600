// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.Labyrinth40013
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class Labyrinth40013 : AMissionControl
  {
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();
    private int kill = 0;
    private int npcIDs = 40017;
    private int[] birthX = new int[10]
    {
      1310,
      1290,
      1260,
      1240,
      1220,
      1100,
      1180,
      1160,
      1140,
      1120
    };

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
      int[] npcIds1 = new int[1]{ this.npcIDs };
      int[] npcIds2 = new int[1]{ this.npcIDs };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.SetMap(1238);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      for (int index = 0; index < this.birthX.Length; ++index)
        this.someNpc.Add(this.Game.CreateNpc(this.npcIDs, this.birthX[index], 700, 1, -1));
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      bool flag = true;
      base.CanGameOver();
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      this.kill = 0;
      foreach (Physics physics in this.someNpc)
      {
        if (physics.IsLiving)
          flag = false;
        else
          ++this.kill;
      }
      if (flag && this.kill == this.Game.MissionInfo.TotalCount)
        this.Game.CreateGate(true);
      return flag;
    }

    public override int UpdateUIData() => this.Game.TotalKillCount;

    public override void OnGameOverMovie()
    {
      base.OnGameOverMovie();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public override void OnGameOver() => base.OnGameOver();
  }
}
