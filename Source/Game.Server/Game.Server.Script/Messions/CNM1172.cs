// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CNM1172
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CNM1172 : AMissionControl
  {
    private List<SimpleNpc> redNpc = new List<SimpleNpc>();
    private List<SimpleNpc> blueNpc = new List<SimpleNpc>();
    private int redCount = 0;
    private int blueCount = 0;
    private int redTotalCount = 0;
    private int blueTotalCount = 0;
    private int dieRedCount = 0;
    private int dieBlueCount = 0;
    private int redNpcID = 1101;
    private int blueNpcID = 1102;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 930)
        return 3;
      if (score > 850)
        return 2;
      return score > 775 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds = new int[2]
      {
        this.redNpcID,
        this.blueNpcID
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1072);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "1172";
      for (int index = 0; index < 4; ++index)
      {
        ++this.redTotalCount;
        if (index < 1)
          this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 900 + (index + 1) * 100, 505, 1, 1));
        else if (index < 3)
          this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 920 + (index + 1) * 100, 505, 1, 1));
        else
          this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 1000 + (index + 1) * 100, 515, 1, 1));
      }
      ++this.blueTotalCount;
      this.blueNpc.Add(this.Game.CreateNpc(this.blueNpcID, 1467, 495, 1, 1));
    }

    public override void OnNewTurnStarted()
    {
      this.redCount = this.redTotalCount - this.dieRedCount;
      this.blueCount = this.blueTotalCount - this.dieBlueCount;
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.PveGameDelay = 0;
      if (this.Game.TurnIndex <= 1 || this.Game.CurrentPlayer.Delay <= this.Game.PveGameDelay || this.blueCount == 1 && this.redCount == 4)
        return;
      if (this.redTotalCount < 4 && this.blueTotalCount < 1)
      {
        for (int index = 0; index < 4; ++index)
        {
          ++this.redTotalCount;
          if (index < 1)
            this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 900 + (index + 1) * 100, 505, 1, 1));
          else if (index < 3)
            this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 920 + (index + 1) * 100, 505, 1, 1));
          else
            this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 1000 + (index + 1) * 100, 515, 1, 1));
        }
        ++this.blueTotalCount;
        this.blueNpc.Add(this.Game.CreateNpc(this.blueNpcID, 1467, 495, 1, 1));
      }
      else if (this.redCount < 4)
      {
        if (4 - this.redCount >= 1)
        {
          for (int index = 0; index < 4; ++index)
          {
            if (this.redTotalCount < 12 && this.redCount != 4)
            {
              ++this.redTotalCount;
              if (index < 1)
                this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 900 + (index + 1) * 100, 505, 1, 1));
              else if (index < 3)
                this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 920 + (index + 1) * 100, 505, 1, 1));
              else
                this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 1000 + (index + 1) * 100, 515, 1, 1));
            }
          }
        }
        else if (4 - this.redCount > 0)
        {
          for (int index = 0; index < 4 - this.redCount; ++index)
          {
            if (this.redTotalCount < 12 && this.redCount != 4)
            {
              ++this.redTotalCount;
              if (index < 1)
                this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 900 + (index + 1) * 100, 505, 1, 1));
              else if (index < 3)
                this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 920 + (index + 1) * 100, 505, 1, 1));
              else
                this.redNpc.Add(this.Game.CreateNpc(this.redNpcID, 1000 + (index + 1) * 100, 515, 1, 1));
            }
          }
        }
        if (this.blueCount < 1 && this.blueTotalCount < 3)
        {
          ++this.blueTotalCount;
          this.blueNpc.Add(this.Game.CreateNpc(this.blueNpcID, 1467, 495, 1, 1));
        }
      }
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      bool flag = true;
      this.dieRedCount = 0;
      this.dieBlueCount = 0;
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      foreach (Physics physics in this.redNpc)
      {
        if (physics.IsLiving)
          flag = false;
        else
          ++this.dieRedCount;
      }
      foreach (Physics physics in this.blueNpc)
      {
        if (physics.IsLiving)
          flag = false;
        else
          ++this.dieBlueCount;
      }
      if (flag && this.redTotalCount + this.blueTotalCount == 15)
      {
        this.Game.IsWin = true;
        return true;
      }
      return this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.Game.TotalKillCount;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
