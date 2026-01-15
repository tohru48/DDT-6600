// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.WAT13301
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class WAT13301 : AMissionControl
  {
    private List<SimpleBoss> someBoss = new List<SimpleBoss>();
    private int bossID = 13301;
    private int bossID2 = 13302;
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
      int[] npcIds1 = new int[2]
      {
        this.bossID,
        this.bossID2
      };
      int[] npcIds2 = new int[0];
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/51.swf", "tank.resource.bombs.Bomb51");
      this.Game.AddLoadingFile(1, "bombs/99.swf", "tank.resource.bombs.Bomb99");
      this.Game.AddLoadingFile(2, "image/game/effect/10/jianyu.swf", "asset.game.ten.jianyu");
      this.Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.canbaoAsset");
      this.Game.SetMap(1214);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "13301";
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(1008, 304, "font", "game.asset.living.canbaoAsset", "out", 1, 1);
      SimpleBoss boss1 = this.Game.CreateBoss(this.bossID2, 1269, 840, -1, 1, "");
      boss1.SetRelateDemagemRect(boss1.NpcInfo.X, boss1.NpcInfo.Y, boss1.NpcInfo.Width, boss1.NpcInfo.Height);
      this.someBoss.Add(boss1);
      SimpleBoss boss2 = this.Game.CreateBoss(this.bossID, 1269, 180, -1, 1, "");
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
      if (this.kill == this.Game.MissionInfo.TotalCount)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
