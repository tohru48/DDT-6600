// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.furiaselvagem3NORMAL
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class furiaselvagem3NORMAL : AMissionControl
  {
    private List<SimpleBoss> someBoss = new List<SimpleBoss>();
    private int bossID = 284175;
    private int bossID2 = 284176;
    private int npcID = 13312;
    private int kill = 0;
    private int m_kill = 0;
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
      int[] npcIds1 = new int[3]
      {
        this.bossID2,
        this.bossID,
        this.npcID
      };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.canbaoAsset");
      this.Game.SetMap(1318);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(1000, 600, "font", "game.asset.living.canbaoAsset", "out", 1, 1);
      SimpleBoss boss1 = this.Game.CreateBoss(this.bossID, 319, 275, 1, 1, "");
      boss1.SetRelateDemagemRect(boss1.NpcInfo.X, boss1.NpcInfo.Y, boss1.NpcInfo.Width, boss1.NpcInfo.Height);
      this.someBoss.Add(boss1);
      SimpleBoss boss2 = this.Game.CreateBoss(this.bossID2, 1482, 400, -1, 1, "");
      boss2.SetRelateDemagemRect(boss2.NpcInfo.X, boss2.NpcInfo.Y, boss2.NpcInfo.Width, boss2.NpcInfo.Height);
      this.someBoss.Add(boss2);
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
      this.kill = 0;
      bool flag = true;
      base.CanGameOver();
      foreach (Physics physics in this.someBoss)
      {
        if (physics.IsLiving)
          flag = false;
        else
          ++this.kill;
      }
      return flag && this.kill == this.Game.MissionInfo.TotalCount;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
