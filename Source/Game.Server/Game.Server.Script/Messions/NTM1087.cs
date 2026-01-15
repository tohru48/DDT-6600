// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.NTM1087
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class NTM1087 : AMissionControl
  {
    private int mapId = 2012;
    private SimpleBoss m_boss;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private int bossID = 23003;
    private int redNpcID = 23001;
    private int blueNpcID = 23002;
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
      int[] npcIds = new int[3]
      {
        this.redNpcID,
        this.blueNpcID,
        this.bossID
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(this.mapId);
    }

    public override void OnStartGame() => this.CreateNpc();

    public override void OnNewTurnStarted()
    {
    }

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

    public void CreateBoss()
    {
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(200, 470, "font", "game.asset.living.boguoLeaderAsset", "out", 1, 0);
      this.m_boss = this.Game.CreateBoss(this.bossID, 260, 560, 1, 1, "");
      this.m_boss.FallFrom(260, 620, "fall", 0, 2, 1000);
      this.m_boss.SetRelateDemagemRect(this.m_boss.NpcInfo.X, this.m_boss.NpcInfo.Y, this.m_boss.NpcInfo.Width, this.m_boss.NpcInfo.Height);
      this.m_boss.Say("Loài người kia，đến được đây quả nhiên có chút bản lĩnh！", 0, 3000);
      this.m_moive.PlayMovie("in", 6000, 0);
      this.m_front.PlayMovie("in", 6000, 0);
      this.m_moive.PlayMovie("out", 9000, 0);
      this.m_front.PlayMovie("out", 9000, 0);
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

    private void CreateNpc()
    {
      int[,] numArray = new int[5, 2]
      {
        {
          260,
          620
        },
        {
          312,
          625
        },
        {
          350,
          621
        },
        {
          285,
          620
        },
        {
          331,
          625
        }
      };
      for (int index = 0; index <= 2; ++index)
        this.simpleNpcList.Add(this.Game.CreateNpc(this.redNpcID, numArray[index, 0], numArray[index, 1], 1, 1));
      for (int index = 3; index <= 4; ++index)
        this.simpleNpcList.Add(this.Game.CreateNpc(this.blueNpcID, numArray[index, 0], numArray[index, 1], 1, 1));
    }
  }
}
