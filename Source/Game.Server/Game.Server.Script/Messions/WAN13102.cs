// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.WAN13102
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class WAN13102 : AMissionControl
  {
    private SimpleBoss m_king = (SimpleBoss) null;
    private int bossID = 13105;
    private int npcID = 13103;
    private int npcID2 = 13104;
    private int npcID3 = 3312;
    private int kill = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private PhysicalObj front;
    private SimpleBoss boss = (SimpleBoss) null;

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
      int[] npcIds1 = new int[4]
      {
        this.bossID,
        this.npcID,
        this.npcID2,
        this.npcID3
      };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/55.swf", "tank.resource.bombs.Bomb55");
      this.Game.AddLoadingFile(2, "image/game/effect/10/jitan.swf", "asset.game.ten.jitan");
      this.Game.AddLoadingFile(2, "image/game/living/living035.swf", "game.living.Living035");
      this.Game.AddLoadingFile(2, "image/game/living/living126.swf", "game.living.Living126");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.ClanLeaderAsset");
      this.Game.SetMap(1215);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "13002";
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(950, 750, "font", "game.asset.living.ClanLeaderAsset", "out", 1, 1);
      this.front = this.Game.CreatePhysicalObj(609, 1023, "font", "game.living.Living035", "", 1, 0);
      this.front = this.Game.CreatePhysicalObj(1604, 1023, "font", "game.living.Living035", "", 1, 0);
      this.m_king = this.Game.CreateBoss(this.bossID, 1100, 1000, -1, 1, "");
      this.m_king.SetRelateDemagemRect(this.m_king.NpcInfo.X, this.m_king.NpcInfo.Y, this.m_king.NpcInfo.Width, this.m_king.NpcInfo.Height);
      this.m_king.Say(LanguageMgr.GetTranslation("Sự dận dữ của thần linh sẻ tiêu diệt các ngươi !"), 0, 200, 0);
      this.m_moive.PlayMovie("in", 6000, 0);
      this.m_front.PlayMovie("in", 6100, 0);
      this.m_moive.PlayMovie("out", 10000, 1000);
      this.m_front.PlayMovie("out", 9900, 0);
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
      if (this.m_king == null || this.m_king.IsLiving)
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
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
