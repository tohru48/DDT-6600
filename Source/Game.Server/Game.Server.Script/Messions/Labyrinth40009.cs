// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.Labyrinth40009
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class Labyrinth40009 : AMissionControl
  {
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();
    private int kill = 0;
    private int npcID1 = 40010;
    private int npcID2 = 40011;
    private int[] birthX = new int[8]
    {
      1110,
      1090,
      1060,
      1040,
      1020,
      1000,
      1050,
      1310
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
      int[] npcIds1 = new int[2]{ this.npcID1, this.npcID2 };
      int[] npcIds2 = new int[2]{ this.npcID1, this.npcID2 };
      this.Game.AddLoadingFile(1, "bombs/58.swf", "tank.resource.bombs.Bomb58");
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.SetMap(1222);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      for (int index = 0; index < this.birthX.Length; ++index)
      {
        if (index < 6)
        {
          this.someNpc.Add(this.Game.CreateNpc(this.npcID1, this.birthX[index], 430, 1, -1));
        }
        else
        {
          this.someNpc.Add(this.Game.CreateNpc(this.npcID2, this.birthX[index], 430, 1, -1));
          this.someNpc.Add(this.Game.CreateNpc(this.npcID2, this.birthX[index] + 10, 430, 1, -1));
        }
      }
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
