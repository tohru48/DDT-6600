// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.UKSHM14302
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class UKSHM14302 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleBoss m_king = (SimpleBoss) null;
    private int bossID = 14304;
    private int bossID2 = 14303;
    private int npcID = 14305;
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
      int[] npcIds1 = new int[3]
      {
        this.bossID2,
        this.bossID,
        this.npcID
      };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/game/effect/5/zap.swf", "asset.game.4.zap");
      this.Game.AddLoadingFile(2, "image/game/effect/5/heip.swf", "asset.game.4.heip");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.dadangAsset");
      this.Game.SetMap(11006);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(950, 650, "font", "game.asset.living.dadangAsset", "out", 1, 1);
      this.boss = this.Game.CreateBoss(this.bossID, 1135, 650, -1, 1, "");
      this.m_king = this.Game.CreateBoss(this.bossID2, 1151, 809, -1, 1, "");
      this.m_king.FallFrom(1390, 1000, "fall", 0, 0, 1000, (LivingCallBack) null);
      this.boss.SetRelateDemagemRect(-75, -159, 89, 165);
      this.m_king.SetRelateDemagemRect(-75, -159, 89, 165);
    }

    public override void OnNewTurnStarted()
    {
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex > 1)
      {
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
      if (this.Game.TurnIndex <= 1 || this.boss.IsLiving)
        return;
      this.Game.RemoveLiving(this.boss.Id);
    }

    public override bool CanGameOver()
    {
      if (this.m_king == null || this.m_king.IsLiving)
        return false;
      ++this.kill;
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.Game.TotalKillCount;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.m_king != null && !this.m_king.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
