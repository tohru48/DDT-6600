// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CHM1271
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
  public class CHM1271 : AMissionControl
  {
    private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();
    private int redTotalCount = 0;
    private int dieRedCount = 0;
    private int redNpcID = 1201;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 600)
        return 3;
      if (score > 520)
        return 2;
      return score > 450 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds = new int[1]{ this.redNpcID };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1072);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.PveGameDelay = 0;
      for (int index = 0; index < 4; ++index)
      {
        ++this.redTotalCount;
        if (index < 1)
          this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 900 + (index + 1) * 100, 505, 1, 1));
        else if (index < 3)
          this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 920 + (index + 1) * 100, 505, 1, 1));
        else
          this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 1000 + (index + 1) * 100, 515, 1, 1));
      }
      ++this.redTotalCount;
      this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 1467, 495, 1, 1));
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.PveGameDelay = 0;
      if (this.Game.TurnIndex <= 1 || this.Game.CurrentPlayer.Delay <= this.Game.PveGameDelay)
        return;
      for (int index = 0; index < 4; ++index)
      {
        if (this.redTotalCount < 15)
        {
          ++this.redTotalCount;
          if (index < 1)
            this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 900 + (index + 1) * 100, 505, 1, 1));
          else if (index < 3)
            this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 920 + (index + 1) * 100, 505, 1, 1));
          else
            this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 1000 + (index + 1) * 100, 515, 1, 1));
        }
      }
      if (this.redTotalCount < 15)
      {
        ++this.redTotalCount;
        this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 1467, 495, 1, 1));
      }
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      bool flag = true;
      base.CanGameOver();
      this.dieRedCount = 0;
      foreach (Physics physics in this.SomeNpc)
      {
        if (physics.IsLiving)
          flag = false;
        else
          ++this.dieRedCount;
      }
      if (flag && this.dieRedCount == 15)
      {
        this.Game.IsWin = true;
        return true;
      }
      return this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1;
    }

    public override int UpdateUIData() => this.Game.TotalKillCount;

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "image/map/2", "")
      });
    }
  }
}
