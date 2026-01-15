// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.AC1243
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class AC1243 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private int bossID = 1243;
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
      int[] npcIds1 = new int[1]{ this.bossID };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/56.swf", "tank.resource.bombs.Bomb56");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/effect/5/guang.swf", "asset.game.4.guang");
      this.Game.AddLoadingFile(2, "image/game/effect/5/tang.swf", "asset.game.4.tang");
      this.Game.AddLoadingFile(2, "image/game/effect/5/ruodian.swf", "asset.game.4.ruodian");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.xieyanjulongAsset");
      this.Game.SetMap(1243);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsFly = true;
      config.IsWorldBoss = true;
      this.boss = this.Game.CreateBoss(this.bossID, 1170, 370, -1, 0, "", config);
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
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
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer.PlayerDetail.UpdatePveResult("worldboss", allFightPlayer.TotalDameLiving, this.Game.IsWin);
    }
  }
}
