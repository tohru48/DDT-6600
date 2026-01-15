// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.TVS12003
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class TVS12003 : AMissionControl
  {
    private int bossID = 12010;
    private SimpleBoss m_boss;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1540)
        return 3;
      return score > 1410 ? 2 : (score > 1285 ? 1 : 0);
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
      this.Game.AddLoadingFile(2, "image/game/effect/9/duqidd.swf", "asset.game.nine.duqidd");
      this.Game.LoadResources(new int[1]{ this.bossID });
      this.Game.LoadNpcGameOverResources(new int[1]
      {
        this.bossID
      });
      this.Game.SetMap(1209);
    }

    public override void OnStartGame()
    {
      this.m_boss = this.Game.CreateBoss(this.bossID, 770, 700, -1, 1, "");
      this.m_boss.SetRelateDemagemRect(-21, -87, 100, 79);
      this.m_boss.PlayMovie("born", 0, 6000);
      base.OnStartGame();
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      base.CanGameOver();
      return !this.m_boss.IsLiving;
    }

    public override int UpdateUIData()
    {
      if (this.m_boss == null)
        return 0;
      return !this.m_boss.IsLiving ? 1 : base.UpdateUIData();
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (!this.m_boss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
