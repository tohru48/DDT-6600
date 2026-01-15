// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.RSS2
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class RSS2 : AMissionControl
  {
    private SimpleBoss m_king = (SimpleBoss) null;
    private SimpleBoss boss = (SimpleBoss) null;
    private int bossID = 70016;
    private int npcID = 24030;
    private int bossID2 = 70017;
    private int dieRedCount = 0;
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
        this.bossID,
        this.bossID2,
        this.npcID
      };
      int[] npcIds2 = new int[2]
      {
        this.bossID,
        this.bossID2
      };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/51.swf", "tank.resource.bombs.Bomb51");
      this.Game.AddLoadingFile(1, "bombs/99.swf", "tank.resource.bombs.Bomb99");
      this.Game.AddLoadingFile(2, "image/game/effect/10/jianyu.swf", "asset.game.ten.jianyu");
      this.Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.canbaoAsset");
      this.Game.SetMap(11008);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(700, 450, "font", "game.asset.living.canbaoAsset", "out", 1, 1);
      this.boss = this.Game.CreateBoss(this.bossID2, 899, 600, -1, 1, "");
      this.boss.FallFrom(this.boss.X, this.boss.Y, (string) null, 0, 0, 30);
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      this.m_king = this.Game.CreateBoss(this.bossID, 500, 600, -1, 1, "");
      this.m_king.FallFrom(this.m_king.X, this.m_king.Y, (string) null, 0, 0, 30);
      this.m_king.SetRelateDemagemRect(this.m_king.NpcInfo.X, this.m_king.NpcInfo.Y, this.m_king.NpcInfo.Width, this.m_king.NpcInfo.Height);
      this.m_moive.PlayMovie("in", 6000, 0);
      this.m_front.PlayMovie("in", 6100, 0);
      this.m_moive.PlayMovie("out", 10000, 1000);
      this.m_front.PlayMovie("out", 9900, 0);
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
      base.CanGameOver();
      this.dieRedCount = 0;
      if (!this.m_king.IsLiving || !this.boss.IsLiving)
        ++this.dieRedCount;
      if (this.m_king == null || this.m_king.IsLiving || this.boss == null || this.boss.IsLiving)
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
      if (this.m_king != null && !this.m_king.IsLiving && this.boss != null && !this.boss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
