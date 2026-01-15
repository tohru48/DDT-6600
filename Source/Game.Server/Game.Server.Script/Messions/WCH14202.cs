// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.WCH14202
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.Actions;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class WCH14202 : AMissionControl
  {
    private SimpleNpc goal = (SimpleNpc) null;
    private SimpleBoss boss = (SimpleBoss) null;
    private int npcID = 14103;
    private int chillID = 14104;
    private int bossID = 14105;
    private int goalID = 14106;
    private int kill = 0;
    private int[] birthX = new int[3]{ 1650, 1590, 1530 };
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();

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
        this.goalID,
        this.chillID
      };
      int[] npcIds2 = npcIds1;
      this.Game.LoadResources(npcIds1);
      this.Game.AddLoadingFile(1, "bombs/109.swf", "tank.resource.bombs.Bomb109");
      this.Game.AddLoadingFile(1, "bombs/14005.swf", "tank.resource.bombs.Bomb14005");
      this.Game.AddLoadingFile(2, "image/game/living/living371.swf", "game.living.Living371");
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.SetMap(1406);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.AddAction((IAction) new CallFunctionAction(new LivingCallBack(this.AddBoss), 2000));
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsHelper = true;
      config.HasTurn = false;
      this.goal = this.Game.CreateNpc(this.goalID, 117, 720, 1, 1, config);
      this.Game.SendGameFocus((Physics) this.goal, 0, 1000);
    }

    private void AddBoss()
    {
      this.boss = this.Game.CreateBoss(this.bossID, 1816, 861, -1, 1, "");
      this.Game.SendGameFocus((Physics) this.boss, 0, 1000);
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      this.Game.AddAction((IAction) new CallFunctionAction(new LivingCallBack(this.AddNpc), 3000));
    }

    private void AddNpc()
    {
      for (int index = 0; index < this.birthX.Length; ++index)
        this.someNpc.Add(this.Game.CreateNpc(this.npcID, this.birthX[index], 790, 1, -1));
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      int num = 0;
      foreach (Physics physics in this.someNpc)
      {
        if (!physics.IsLiving)
          ++num;
      }
      if (this.someNpc.Count - num >= 3)
        return;
      for (int index = 0; index < num; ++index)
        this.someNpc.Add(this.Game.CreateNpc(this.npcID, this.birthX[this.Game.Random.Next(this.birthX.Length)], 790, 1, -1));
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1 || this.Game.IsMissBall)
        return true;
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
      if (this.boss != null && !this.boss.IsLiving && !this.Game.IsMissBall)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
