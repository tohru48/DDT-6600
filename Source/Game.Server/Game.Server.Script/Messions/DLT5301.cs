// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.DLT5301
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class DLT5301 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleBoss m_boss = (SimpleBoss) null;
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();
    private int bossID2 = 5302;
    private int bossID = 5301;
    private int kill = 0;
    private PhysicalObj moive;
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
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/game/effect/5/minigun.swf", "asset.game.4.minigun");
      this.Game.AddLoadingFile(2, "image/game/effect/5/jinqud.swf", "asset.game.4.jinqud");
      this.Game.AddLoadingFile(2, "image/game/effect/5/zap.swf", "asset.game.4.zap");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.gebulinzhihuiguanAsset");
      this.Game.AddLoadingFile(1, "bombs/56.swf", "tank.resource.bombs.Bomb56");
      this.Game.AddLoadingFile(1, "bombs/72.swf", "tank.resource.bombs.Bomb72");
      this.Game.SetMap(1151);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(1131, 650, "font", "game.asset.living.gebulinzhihuiguanAsset", "out", 1, 1);
      this.moive = (PhysicalObj) this.Game.Createlayer(1567, 810, "moive", "asset.game.4.jinqud", "out", 1, 0);
      this.m_boss = this.Game.CreateBoss(this.bossID2, 190, 365, 1, 1, "");
      this.boss = this.Game.CreateBoss(this.bossID, 1477, 768, -1, 0, "");
      this.boss.SetRelateDemagemRect(-21, -79, 120, 80);
      this.m_boss.SetRelateDemagemRect(-42, -200, 84, 104);
      this.boss.PlayMovie("in", 0, 2000);
      this.m_boss.PlayMovie("in", 4000, 2000);
      this.m_boss.PlayMovie("in", 0, 2000);
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
      this.m_boss = this.Game.CreateBoss(this.bossID2, 185, 370, 1, 10, "cryA");
      this.m_boss.PlayMovie("in", 4000, 4000);
      this.boss.SetXY(1477, 758);
      this.boss.PlayMovie("fallingA", 100, 1000);
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
      if (!this.boss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public override void OnShooted()
    {
      if (!this.boss.IsLiving)
        return;
      if (this.boss.Y == 659)
      {
        this.boss.SetXY(1477, 659);
        this.boss.SetXY(1477, 759);
        this.boss.CallFuction(new LivingCallBack(this.kill1), 100);
        this.boss.FallCount = 1;
      }
      else if (this.boss.Y == 559)
      {
        this.boss.SetXY(1477, 559);
        this.boss.SetXY(1477, 759);
        this.boss.CallFuction(new LivingCallBack(this.kill2), 100);
        this.boss.FallCount = 2;
      }
      else if (this.boss.Y == 459)
      {
        this.boss.SetXY(1477, 459);
        this.boss.SetXY(1477, 759);
        this.boss.CallFuction(new LivingCallBack(this.kill3), 100);
        this.boss.FallCount = 3;
      }
      else if (this.boss.Y == 359)
      {
        this.boss.SetXY(1477, 359);
        this.boss.SetXY(1477, 759);
        this.boss.CallFuction(new LivingCallBack(this.kill4), 100);
        this.boss.FallCount = 4;
      }
      else
      {
        if (this.boss.Y != 259)
          return;
        this.boss.SetXY(1477, 259);
        this.boss.SetXY(1477, 759);
        this.boss.CallFuction(new LivingCallBack(this.kill5), 100);
        this.boss.FallCount = 5;
      }
    }

    private void kill1() => this.boss.SetXY(1477, 659);

    private void kill2() => this.boss.SetXY(1477, 559);

    private void kill3() => this.boss.SetXY(1477, 459);

    private void kill4() => this.boss.SetXY(1477, 359);

    private void kill5() => this.boss.SetXY(1477, 259);
  }
}
