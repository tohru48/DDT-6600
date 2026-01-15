// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CTM1378
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CTM1378 : AMissionControl
  {
    private SimpleBoss m_king = (SimpleBoss) null;
    private int m_kill = 0;
    private int bossID = 1308;
    private int npcID = 1311;
    private PhysicalObj m_kingMoive;
    private PhysicalObj m_front;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1330)
        return 3;
      if (score > 1150)
        return 2;
      return score > 970 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds1 = new int[2]{ this.npcID, this.bossID };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.ZhenBombKingAsset");
      this.Game.SetMap(1084);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_king = this.Game.CreateBoss(this.bossID, 888, 590, -1, 0, "");
      this.m_kingMoive = (PhysicalObj) this.Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(710, 380, "font", "game.asset.living.ZhenBombKingAsset", "out", 1, 1);
      this.m_king.FallFrom(888, 590, "fall", 0, 2, 1000);
      this.m_king.SetRelateDemagemRect(-41, -187, 83, 140);
      this.m_kingMoive.PlayMovie("in", 1000, 0);
      this.m_front.PlayMovie("in", 2000, 2000);
      this.m_king.AddDelay(16);
      this.Game.BossCardCount = 1;
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.m_king.State != 0)
        return;
      this.m_king.SetRelateDemagemRect(-41, -187, 83, 140);
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.m_kingMoive != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingMoive, true);
        this.m_kingMoive = (PhysicalObj) null;
      }
      if (this.m_front == null)
        return;
      this.Game.RemovePhysicalObj(this.m_front, true);
      this.m_front = (PhysicalObj) null;
    }

    public override bool CanGameOver()
    {
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      if (this.m_king.IsLiving)
        return false;
      ++this.m_kill;
      this.m_king.PlayMovie("die", 0, 200);
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.m_kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      bool flag = true;
      foreach (Physics allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving)
          flag = false;
      }
      if (!this.m_king.IsLiving && !flag)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
