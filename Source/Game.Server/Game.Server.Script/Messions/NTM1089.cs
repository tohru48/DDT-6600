// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.NTM1089
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class NTM1089 : AMissionControl
  {
    private int mapId = 1129;
    private int dieCount = 0;
    private int[] birthX = new int[4]{ 52, 115, 1155, 1106 };
    private int[] birthY = new int[4]{ 388, 392, 399, 387 };
    private int npcID = 25001;
    private int bossID = 25002;
    private SimpleBoss m_boss;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();

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
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.shikongAsset");
      int[] npcIds = new int[2]{ this.npcID, this.bossID };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(this.mapId);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      int y = this.birthX[0];
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 52, y, 1, -1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 100, y, 1, -1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 1120, y, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 1155, y, 1, 1));
    }

    public void CreateBoss()
    {
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(200, 200, "font", "game.asset.living.shikongAsset", "out", 1, 0);
      this.m_boss = this.Game.CreateBoss(this.bossID, 160, 330, 1, 1, "");
      this.m_boss.SetRelateDemagemRect(this.m_boss.NpcInfo.X, this.m_boss.NpcInfo.Y, this.m_boss.NpcInfo.Width, this.m_boss.NpcInfo.Height);
      this.m_moive.PlayMovie("in", 6000, 0);
      this.m_front.PlayMovie("in", 6000, 0);
      this.m_moive.PlayMovie("out", 9000, 0);
    }

    public override void OnNewTurnStarted()
    {
      if (this.Game.TurnIndex <= 1 || this.m_boss != null || this.Game.GetLivedLivings().Count >= 4)
        return;
      for (int index = 0; index < 4 - this.Game.GetLivedLivings().Count && this.someNpc.Count != 8; ++index)
      {
        int x = this.birthX[this.Game.Random.Next(0, this.birthX.Length)];
        int direction = 1;
        if (x < 200)
          direction = -1;
        this.someNpc.Add(this.Game.CreateNpc(this.npcID, x, this.birthY[0], 1, direction));
      }
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      bool flag = true;
      base.CanGameOver();
      this.dieCount = 0;
      foreach (Physics physics in this.someNpc)
      {
        if (physics.IsLiving)
          flag = false;
        else
          ++this.dieCount;
      }
      if (flag && this.dieCount == 8 && this.m_boss == null)
        this.CreateBoss();
      return this.m_boss != null && !this.m_boss.IsLiving;
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
      if (this.m_boss == null)
        return;
      if (!this.m_boss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
