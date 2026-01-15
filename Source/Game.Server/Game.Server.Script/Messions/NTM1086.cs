// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.NTM1086
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class NTM1086 : AMissionControl
  {
    private int mapId = 1015;
    private SimpleBoss m_boss;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private int bossID = 22001;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      if (score > 825)
        return 2;
      return score > 725 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.qiheibojueAsset");
      this.Game.AddLoadingFile(2, "image/bomb/blastout/blastout86.swf", "bullet86");
      this.Game.AddLoadingFile(2, "image/bomb/bullet/bullet86.swf", "bullet86");
      int[] npcIds = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(this.mapId);
    }

    public override void OnStartGame()
    {
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(680, 330, "font", "game.asset.living.qiheibojueAsset", "out", 1, 0);
      this.m_boss = this.Game.CreateBoss(this.bossID, 750, 420, -1, 1, "");
      this.m_boss.FallFrom(750, 520, "fall", 0, 2, 1000);
      this.m_boss.SetRelateDemagemRect(this.m_boss.NpcInfo.X, this.m_boss.NpcInfo.Y, this.m_boss.NpcInfo.Width, this.m_boss.NpcInfo.Height);
      this.m_boss.Say("Đến đúng lúc lắm，ta đang chán đây！", 0, 4000);
      this.m_moive.PlayMovie("in", 6000, 0);
      this.m_front.PlayMovie("in", 6000, 0);
      this.m_moive.PlayMovie("out", 9000, 0);
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex <= 1)
        return;
      if (this.m_moive == null)
        ;
      if (this.m_front != null)
      {
        this.Game.RemovePhysicalObj(this.m_front, true);
        this.m_front = (PhysicalObj) null;
      }
    }

    public override bool CanGameOver() => this.m_boss != null && !this.m_boss.IsLiving;

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.Game.TotalKillCount;
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
