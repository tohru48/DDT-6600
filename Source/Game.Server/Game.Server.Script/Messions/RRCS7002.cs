// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.RRCS7002
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class RRCS7002 : AMissionControl
  {
    private List<SimpleBoss> someBoss = new List<SimpleBoss>();
    private int bossID = 7011;
    private int bossID2 = 7011;
    private int bossID3 = 7011;
    private int kill = 0;

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
      int[] npcIds1 = new int[3]
      {
        this.bossID,
        this.bossID2,
        this.bossID3
      };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/84.swf", "tank.resource.bombs.Bomb84");
      this.Game.AddLoadingFile(2, "image/game/effect/7/cao.swf", "asset.game.seven.cao");
      this.Game.SetMap(1162);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "7002";
      this.someBoss.Add(this.Game.CreateBoss(this.bossID, 1565, 787, -1, 1, "standA"));
      this.someBoss.Add(this.Game.CreateBoss(this.bossID, 1583, 495, -1, 1, "standA"));
      this.someBoss.Add(this.Game.CreateBoss(this.bossID, 1643, 236, -1, 1, "standA"));
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      bool flag = true;
      base.CanGameOver();
      this.kill = 0;
      foreach (Physics physics in this.someBoss)
      {
        if (physics.IsLiving)
          flag = false;
        else
          ++this.kill;
      }
      return flag && this.kill == this.Game.MissionInfo.TotalCount;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
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
