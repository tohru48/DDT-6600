// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.borboleta2
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
  public class borboleta2 : AMissionControl
  {
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();
    private int dieRedCount = 0;
    private int[] npcIDs = new int[2]{ 128913, 128913 };
    private int[] birthX = new int[10]
    {
      52,
      115,
      183,
      253,
      320,
      1206,
      1275,
      1342,
      1410,
      1475
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
      int[] npcIds1 = new int[2]
      {
        this.npcIDs[0],
        this.npcIDs[1]
      };
      int[] npcIds2 = new int[4]
      {
        this.npcIDs[1],
        this.npcIDs[0],
        this.npcIDs[0],
        this.npcIDs[0]
      };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.SetMap(1113);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "2001";
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 52, 800, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 80, 800, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 110, 800, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 140, 800, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 180, 800, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 2120, 800, 1, -1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 2150, 800, 1, -1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 2170, 800, 1, -1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 2185, 800, 1, -1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[this.Game.Random.Next(0, this.npcIDs.Length)], 2205, 800, 1, -1));
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.PveGameDelay = 0;
      if (this.Game.TurnIndex <= 1 || this.Game.CurrentPlayer.Delay <= this.Game.PveGameDelay || this.Game.GetLivedLivings().Count >= 10)
        return;
      for (int index = 0; index < 10 - this.Game.GetLivedLivings().Count && this.someNpc.Count != this.Game.MissionInfo.TotalCount; ++index)
      {
        int x = this.birthX[this.Game.Random.Next(0, this.birthX.Length)];
        int num = -1;
        if (x <= 320)
          num = 1;
        if (this.Game.Random.Next(0, this.npcIDs.Length) == 1 && this.GetNpcCountByID(this.npcIDs[1]) < 10)
          this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[1], x, 506, 1, 1));
        else
          this.someNpc.Add(this.Game.CreateNpc(this.npcIDs[0], x, 506, 1, 1));
      }
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      bool flag = true;
      base.CanGameOver();
      this.dieRedCount = 0;
      foreach (Physics physics in this.someNpc)
      {
        if (physics.IsLiving)
          flag = false;
        else
          ++this.dieRedCount;
      }
      if (!flag || this.dieRedCount != this.Game.MissionInfo.TotalCount)
        return false;
      this.Game.IsWin = true;
      return true;
    }

    public override int UpdateUIData() => this.Game.TotalKillCount;

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.Game.GetLivedLivings().Count == 0)
      {
        this.Game.IsWin = true;
        this.Game.SendLoadResource(new List<LoadingFileInfo>()
        {
          new LoadingFileInfo(2, "image/map/2/show2", "")
        });
      }
      else
        this.Game.IsWin = false;
    }

    protected int GetNpcCountByID(int Id)
    {
      int npcCountById = 0;
      foreach (SimpleNpc simpleNpc in this.someNpc)
      {
        if (simpleNpc.NpcInfo.ID == Id)
          ++npcCountById;
      }
      return npcCountById;
    }
  }
}
