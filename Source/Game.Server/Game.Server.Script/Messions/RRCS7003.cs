// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.RRCS7003
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class RRCS7003 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();
    private int npcID = 7021;
    private int npcID2 = 7022;
    private int bossID = 7023;
    private int kill = 0;
    private int count = 0;
    private int TotalCount = 0;
    private int dieCount = 0;

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
        this.npcID,
        this.npcID2
      };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/game/effect/7/cao.swf", "asset.game.seven.cao");
      this.Game.AddLoadingFile(2, "image/game/effect/7/jinquhd.swf", "asset.game.seven.jinquhd");
      this.Game.SetMap(1163);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "7003";
      this.boss = this.Game.CreateBoss(this.bossID, 275, 950, 1, 2, "");
      this.boss.FallFrom(338, 950, "", 0, 0, 1000);
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      for (int index = 0; index < 2; ++index)
      {
        ++this.TotalCount;
        this.someNpc.Add(this.Game.CreateNpc(this.npcID, 700, 900, 1, 1));
      }
    }

    public override void OnNewTurnStarted()
    {
      this.count = this.TotalCount - this.dieCount;
      if (this.Game.TurnIndex <= 1)
        return;
      if (this.TotalCount < 2)
      {
        for (int index = 0; index < 2; ++index)
        {
          ++this.TotalCount;
          this.someNpc.Add(this.Game.CreateNpc(this.npcID, 700, 900, 1, 1));
        }
      }
      else if (this.count < 2 && 2 - this.count >= 0)
      {
        for (int index = 0; index < 3; ++index)
        {
          ++this.TotalCount;
          this.someNpc.Add(this.Game.CreateNpc(this.npcID, 700, 900, 1, 1));
        }
      }
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      this.dieCount = 0;
      foreach (Physics physics in this.someNpc)
      {
        if (!physics.IsLiving)
          ++this.dieCount;
      }
      if (this.boss == null || this.boss.IsLiving)
        return false;
      ++this.kill;
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.boss != null && !this.boss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
