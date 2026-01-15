// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.NTM1083
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class NTM1083 : AMissionControl
  {
    private int mapId = 2013;
    private int CaptainNpcID = 23003;
    private int blueNpcID = 21001;
    private int totalNpcCount = 3;
    private List<SimpleNpc> simpleNpcList = new List<SimpleNpc>();

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      if (score > 825)
        return 2;
      return score > 725 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds = new int[2]
      {
        this.CaptainNpcID,
        this.blueNpcID
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(this.mapId);
    }

    public override void OnStartGame() => this.CreateNpc();

    public override void OnNewTurnStarted()
    {
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      foreach (Physics simpleNpc in this.simpleNpcList)
      {
        if (simpleNpc.IsLiving)
          return false;
      }
      return this.simpleNpcList.Count == this.totalNpcCount;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.Game.TotalKillCount;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer.CanGetProp = true;
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    private void CreateNpc()
    {
      this.simpleNpcList.Add(this.Game.CreateNpc(this.blueNpcID, 775, 553, 1, 1));
    }
  }
}
