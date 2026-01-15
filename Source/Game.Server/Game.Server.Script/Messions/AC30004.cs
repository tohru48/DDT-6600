// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.AC30004
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class AC30004 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private int bossID = 30004;
    private int kill = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;

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
      this.Game.AddLoadingFile(2, "image/game/effect/0/294b.swf", "asset.game.zero.294b");
      this.Game.AddLoadingFile(1, "bombs/24.swf", "tank.resource.bombs.Bomb24");
      this.Game.AddLoadingFile(1, "bombs/25.swf", "tank.resource.bombs.Bomb25");
      this.Game.SetMap(1303);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsFly = false;
      config.IsWorldBoss = true;
      this.boss = this.Game.CreateBoss(this.bossID, 1379, 681, -1, 1, "", config);
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      this.boss.Say(LanguageMgr.GetTranslation("GameServerScript.AI.Messions.DCSM2002.msg1"), 0, 200, 0);
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer.ChangeSpecialBall = 25;
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnShooted() => base.OnShooted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex <= 1)
        return;
      if (this.m_moive != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive, true);
        this.m_moive = (PhysicalObj) null;
      }
      if (this.m_front != null)
      {
        this.Game.RemovePhysicalObj(this.m_front, true);
        this.m_front = (PhysicalObj) null;
      }
    }

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
      {
        this.Game.IsWin = true;
      }
      else
      {
        this.Game.IsWin = false;
        this.Game.IsKillWorldBoss = false;
      }
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer.PlayerDetail.UpdatePveResult("worldboss", allFightPlayer.TotalDameLiving, this.Game.IsWin);
    }
  }
}
