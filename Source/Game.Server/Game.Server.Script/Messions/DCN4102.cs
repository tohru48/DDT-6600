// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.DCN4102
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class DCN4102 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleBoss m_king = (SimpleBoss) null;
    private int bossID = 4105;
    private int bossID2 = 4106;
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
      int[] npcIds1 = new int[2]
      {
        this.bossID,
        this.bossID2
      };
      int[] npcIds2 = new int[2]
      {
        this.bossID,
        this.bossID2
      };
      this.Game.AddLoadingFile(2, "image/game/effect/4/feather.swf", "asset.game.4.feather");
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.SetMap(1143);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.boss = this.Game.CreateBoss(this.bossID2, 1380, 900, -1, 1, "");
      this.boss.FallFromTo(this.boss.X, this.boss.Y, (string) null, 0, 0, 2000, (LivingCallBack) null);
      this.boss.SetRelateDemagemRect(-41, -100, 83, 70);
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsFly = true;
      this.m_king = this.Game.CreateBoss(this.bossID, 189, 520, -1, 0, "", config);
      this.m_king.SetRelateDemagemRect(-41, -100, 50, 70);
    }

    public override void OnNewTurnStarted()
    {
    }

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
      if (this.m_king != null && !this.m_king.IsLiving)
      {
        ++this.kill;
        return true;
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
      if (this.m_king != null && !this.m_king.IsLiving)
      {
        this.boss.PlayMovie("die", 1000, 1000);
        this.Game.IsWin = true;
      }
      if (this.boss != null && !this.boss.IsLiving)
      {
        this.m_king.PlayMovie("die", 1000, 1000);
        this.Game.IsWin = true;
      }
      else
        this.Game.IsWin = false;
    }

    public override void OnShooted() => base.OnShooted();
  }
}
