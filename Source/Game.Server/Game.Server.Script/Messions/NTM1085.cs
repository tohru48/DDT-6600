// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.NTM1085
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class NTM1085 : AMissionControl
  {
    private int mapId = 2013;
    private SimpleBoss m_boss;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private int bossID = 21002;
    private int blueNpcID = 21001;
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
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
      this.Game.AddLoadingFile(2, "image/bomb/blastout/blastout61.swf", "bullet61");
      this.Game.AddLoadingFile(2, "image/bomb/bullet/bullet61.swf", "bullet61");
      int[] npcIds = new int[2]
      {
        this.bossID,
        this.blueNpcID
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(this.mapId);
    }

    public override void OnStartGame() => this.CreateNpc();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      foreach (Physics simpleNpc in this.simpleNpcList)
      {
        if (simpleNpc.IsLiving)
          return false;
      }
      if (this.m_boss != null && !this.m_boss.IsLiving)
        return true;
      if (this.m_boss == null)
        this.CreateBoss();
      return false;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.Game.TotalKillCount;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public void CreateBoss()
    {
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(730, 510, "font", "game.asset.living.boguoLeaderAsset", "out", 1, 0);
      this.m_boss = this.Game.CreateBoss(this.bossID, 850, 360, -1, 1, "");
      this.m_boss.FallFrom(850, 410, "fall", 0, 2, 1000);
      this.m_boss.SetRelateDemagemRect(this.m_boss.NpcInfo.X, this.m_boss.NpcInfo.Y, this.m_boss.NpcInfo.Width, this.m_boss.NpcInfo.Height);
      this.m_boss.Say("Loài người kia，gặp phải ta là hên rồi！", 0, 6000);
      this.m_moive.PlayMovie("in", 9000, 0);
      this.m_front.PlayMovie("in", 9000, 0);
      this.m_moive.PlayMovie("out", 15000, 0);
    }

    private void CreateNpc()
    {
      this.simpleNpcList.Add(this.Game.CreateNpc(this.blueNpcID, 775, 553, 1, 1));
    }
  }
}
