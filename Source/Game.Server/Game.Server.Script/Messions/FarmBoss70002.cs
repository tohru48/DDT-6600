// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.FarmBoss70002
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class FarmBoss70002 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private int bossID = 50101;
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
      if (this.Game.loadBossID > this.bossID)
        this.bossID = this.Game.loadBossID;
      int[] npcIds1 = new int[1]{ this.bossID };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/127.swf", "tank.resource.bombs.Bomb127");
      this.Game.AddLoadingFile(2, "image/game/effect/15/380b.swf", "asset.game.fifteen.380b");
      this.Game.SetMap(70002);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.boss = this.Game.CreateBoss(this.bossID, 969, 526, -1, 1, "");
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      Console.WriteLine(this.boss.NpcInfo.Name);
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      if (this.Game.GetAllFightPlayers().Count < 2)
        return true;
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
