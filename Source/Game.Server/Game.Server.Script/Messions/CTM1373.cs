// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CTM1373
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CTM1373 : AMissionControl
  {
    private SimpleBoss m_boss;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private int bossID = 1303;
    private int npcID = 1309;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1540)
        return 3;
      if (score > 1410)
        return 2;
      return score > 1285 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(2, "image/bomb/blastout/blastout61.swf", "bullet61");
      this.Game.AddLoadingFile(2, "image/bomb/bullet/bullet61.swf", "bullet61");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
      this.Game.LoadResources(new int[2]
      {
        this.bossID,
        this.npcID
      });
      this.Game.LoadNpcGameOverResources(new int[1]
      {
        this.bossID
      });
      this.Game.SetMap(1073);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "1373";
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(680, 330, "font", "game.asset.living.boguoLeaderAsset", "out", 1, 1);
      this.m_boss = this.Game.CreateBoss(this.bossID, 770, -1500, -1, 1, "");
      this.m_boss.FallFrom(770, 301, "fall", 0, 2, 1000);
      this.m_boss.SetRelateDemagemRect(34, -35, 11, 18);
      this.m_boss.AddDelay(10);
      this.m_boss.Say(LanguageMgr.GetTranslation("GameServerScript.AI.Messions.CHM1373.msg2"), 0, 6000);
      this.m_boss.PlayMovie("call", 5900, 0);
      this.m_moive.PlayMovie("in", 9000, 0);
      this.m_boss.PlayMovie("weakness", 10000, 5000);
      this.m_front.PlayMovie("in", 9000, 0);
      this.m_moive.PlayMovie("out", 15000, 0);
      this.Game.BossCardCount = 1;
      base.OnStartGame();
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

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
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      base.CanGameOver();
      return !this.m_boss.IsLiving;
    }

    public override int UpdateUIData()
    {
      if (this.m_boss == null)
        return 0;
      return !this.m_boss.IsLiving ? 1 : base.UpdateUIData();
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
