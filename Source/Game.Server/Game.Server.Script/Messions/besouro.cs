// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.besouro
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class besouro : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private int npcID = 2104;
    private int bossID = 71009;
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
      int[] npcIds1 = new int[2]{ this.bossID, this.npcID };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/bomb/blastOut/blastOut51.swf", "shootMovie51");
      this.Game.AddLoadingFile(2, "image/bomb/bullet/bullet51.swf", "bullet51");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.AntQueenAsset");
      this.Game.SetMap(70003);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "2102";
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(1131, 150, "font", "game.asset.living.AntQueenAsset", "out", 1, 1);
      this.boss = this.Game.CreateBoss(this.bossID, 1316, 380, -1, 1, "");
      this.boss.SetRelateDemagemRect(-42, -200, 84, 194);
      this.boss.Say(LanguageMgr.GetTranslation("GameServerScript.AI.Messions.DCNM2102.msg1"), 0, 200, 0);
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
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
