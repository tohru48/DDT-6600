// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.NTM1088
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class NTM1088 : AMissionControl
  {
    private int mapId = 1132;
    private bool isAddBlood = true;
    private int redNpcID = 24001;
    private SimpleBoss m_boss;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private int bossID = 24002;
    private PhysicalObj m_effect;
    private List<SimpleNpc> simpleNpcList = new List<SimpleNpc>();

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
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.jianjiaoAsset");
      this.Game.AddLoadingFile(2, "image/bomb/blastout/blastout96.swf", "bullet96");
      this.Game.AddLoadingFile(2, "image/bomb/bullet/bullet96.swf", "bullet96");
      this.Game.AddLoadingFile(2, "image/game/effect/0/guangquan.swf", "asset.game.0.guangquan");
      int[] npcIds = new int[2]
      {
        this.redNpcID,
        this.bossID
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(this.mapId);
    }

    public override void OnStartGame()
    {
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(25, 265, "font", "game.asset.living.jianjiaoAsset", "out", 1, 0);
      this.m_boss = this.Game.CreateBoss(this.bossID, 100, 320, 1, 1, "");
      this.m_boss.FallFrom(100, 520, "fall", 0, 2, 1000);
      this.m_boss.SetRelateDemagemRect(this.m_boss.NpcInfo.X, this.m_boss.NpcInfo.Y, this.m_boss.NpcInfo.Width, this.m_boss.NpcInfo.Height);
      this.m_boss.Say("Bay ra ngoài đi，núp trong đóa ko thịt được ta đâu！", 0, 3000);
      this.m_moive.PlayMovie("in", 4000, 0);
      this.m_front.PlayMovie("in", 4000, 0);
      this.m_moive.PlayMovie("out", 7000, 0);
      this.m_front.PlayMovie("out", 7000, 0);
    }

    public override void OnNewTurnStarted()
    {
      if (this.m_effect != null)
        return;
      this.m_effect = (PhysicalObj) this.Game.Createlayer(1150, 544, "moive", "asset.game.0.guangquan", "in", 1, 0);
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer.X > 1050)
      {
        this.m_effect.PlayMovie("standA", 1000, 0);
        if (!this.isAddBlood)
          return;
        randomPlayer.AddBlood(2000);
        this.isAddBlood = false;
      }
      else
        this.m_effect.PlayMovie("standB", 1000, 0);
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

    private void CreateNpc()
    {
      this.simpleNpcList.Add(this.Game.CreateNpc(this.redNpcID, 1110, 520, 1, 1));
    }
  }
}
