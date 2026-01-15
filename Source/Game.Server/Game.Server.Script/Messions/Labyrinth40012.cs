// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.Labyrinth40012
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class Labyrinth40012 : AMissionControl
  {
    private SimpleBoss boss1 = (SimpleBoss) null;
    private SimpleBoss boss2 = (SimpleBoss) null;
    private int kill = 0;
    private int bossID1 = 40015;
    private int bossID2 = 40016;

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
        this.bossID1,
        this.bossID2
      };
      int[] npcIds2 = new int[2]
      {
        this.bossID1,
        this.bossID2
      };
      this.Game.AddLoadingFile(2, "image/game/effect/4/feather.swf", "asset.game.4.feather");
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.SetMap(1236);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsFly = true;
      this.boss1 = this.Game.CreateBoss(this.bossID2, 1200, 900, -1, 1, "");
      this.boss1.FallFromTo(this.boss1.X, this.boss1.Y, (string) null, 0, 0, 2000, (LivingCallBack) null);
      this.boss1.SetRelateDemagemRect(this.boss1.NpcInfo.X, this.boss1.NpcInfo.Y, this.boss1.NpcInfo.Width, this.boss1.NpcInfo.Height);
      this.boss2 = this.Game.CreateBoss(this.bossID1, 1389, 620, -1, 0, "", config);
      this.boss2.SetRelateDemagemRect(this.boss2.NpcInfo.X, this.boss2.NpcInfo.Y, this.boss2.NpcInfo.Width, this.boss2.NpcInfo.Height);
    }

    public override void OnNewTurnStarted()
    {
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      if (this.boss1 != null && !this.boss1.IsLiving && this.boss2 != null && !this.boss2.IsLiving)
      {
        if (this.Game.CanEnterGate)
          return true;
        ++this.kill;
        this.Game.CanShowBigBox = true;
      }
      return false;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOverMovie()
    {
      base.OnGameOverMovie();
      if (this.boss1 != null && !this.boss1.IsLiving && this.boss2 != null && !this.boss2.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public override void OnGameOver() => base.OnGameOver();
  }
}
