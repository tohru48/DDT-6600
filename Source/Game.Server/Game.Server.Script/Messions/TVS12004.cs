// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.TVS12004
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class TVS12004 : AMissionControl
  {
    private int InSet = 0;
    private int bossID = 12014;
    private int bossID2 = 12015;
    private int bossID3 = 12016;
    private int npcID = 12017;
    private int npcID2 = 12018;
    private int npcID3 = 12020;
    private SimpleBoss m_boss;
    private SimpleBoss boss;
    private SimpleBoss king;
    private SimpleNpc npc;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      return score > 825 ? 2 : (score > 725 ? 1 : 0);
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
      this.Game.AddLoadingFile(2, "image/game/effect/9/daodan.swf", "asset.game.nine.daodan");
      this.Game.AddLoadingFile(2, "image/game/effect/9/diancipao.swf", "asset.game.nine.diancipao");
      this.Game.AddLoadingFile(2, "image/game/effect/9/fengyin.swf", "asset.game.nine.fengyin");
      this.Game.AddLoadingFile(2, "image/game/effect/9/siwang.swf", "asset.game.nine.siwang");
      this.Game.AddLoadingFile(2, "image/game/effect/9/shexian.swf", "asset.game.nine.shexian");
      this.Game.AddLoadingFile(2, "image/game/effect/9/biaoji.swf", "asset.game.nine.biaoji");
      int[] npcIds = new int[7]
      {
        this.bossID,
        this.bossID2,
        this.bossID3,
        this.npcID,
        this.npcID2,
        this.npcID3,
        12319
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1210);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.boss = this.Game.CreateBoss(this.bossID, 1000, 400, -1, 1, "");
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      this.boss.PlayMovie("", 4000, 4000);
    }

    public void CreateBoss()
    {
      this.Game.ClearAllChild();
      this.InSet = 1;
      this.m_boss = this.Game.CreateBoss(this.bossID2, this.boss.X, this.boss.Y, this.boss.Direction, 1, "");
      this.m_boss.SetRelateDemagemRect(this.m_boss.NpcInfo.X, this.m_boss.NpcInfo.Y, this.m_boss.NpcInfo.Width, this.m_boss.NpcInfo.Height);
      this.m_boss.PlayMovie("", 6000, 0);
    }

    public void CreateKing()
    {
      this.Game.ClearAllChild();
      this.InSet = 2;
      this.king = this.Game.CreateBoss(this.bossID3, this.m_boss.X, this.m_boss.Y, this.m_boss.Direction, 1, "");
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(this.king.X - 475, this.king.Y - 100, "font", "game.asset.living.fengkuangAsset", "out", 1, 0);
      this.king.SetRelateDemagemRect(this.king.NpcInfo.X, this.king.NpcInfo.Y, this.king.NpcInfo.Width, this.king.NpcInfo.Height);
      this.m_moive.PlayMovie("in", 4000, 0);
      this.m_front.PlayMovie("in", 4000, 0);
      this.m_moive.PlayMovie("out", 7000, 0);
      this.king.PlayMovie("", 8000, 0);
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      base.CanGameOver();
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      if (this.boss != null && !this.boss.IsLiving && this.InSet == 0)
        this.CreateBoss();
      if (this.m_boss != null && !this.m_boss.IsLiving && this.InSet == 1)
        this.CreateKing();
      return this.king != null && !this.king.IsLiving && this.InSet == 2;
    }

    public override int UpdateUIData() => base.UpdateUIData();

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (!this.king.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
