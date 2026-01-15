// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.WCH14203
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness.Managers;
using Game.Logic;
using Game.Logic.Actions;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class WCH14203 : AMissionControl
  {
    private SimpleNpc npc = (SimpleNpc) null;
    private SimpleNpc goal = (SimpleNpc) null;
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleNpc arbiNpc = (SimpleNpc) null;
    private int npcID = 14108;
    private int bossID = 14109;
    private int goalID = 14106;
    private int arbiID = 14107;
    private int needGoal = 8;
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
        this.arbiID
      };
      int[] npcIds2 = npcIds1;
      this.Game.LoadResources(npcIds1);
      this.Game.AddLoadingFile(1, "bombs/110.swf", "tank.resource.bombs.Bomb110");
      this.Game.AddLoadingFile(2, "image/game/effect/0/294b.swf", "asset.game.zero.294b");
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.SetMap(1407);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.AddAction((IAction) new CallFunctionAction(new LivingCallBack(this.AddArbiNpc), 2000));
    }

    private void AddArbiNpc()
    {
      LivingConfig config1 = this.Game.BaseLivingConfig();
      config1.IsHelper = true;
      config1.HasTurn = false;
      this.arbiNpc = this.Game.CreateNpc(this.arbiID, 785, 261, 1, 1, config1);
      this.Game.SendGameFocus((Physics) this.arbiNpc, 0, 100);
      this.arbiNpc.SetRelateDemagemRect(0, 0, 0, 0);
      LivingConfig config2 = this.Game.BaseLivingConfig();
      config2.HasTurn = false;
      config2.IsGoal = true;
      this.goal = this.Game.CreateNpc(this.goalID, 1469, 860, 1, -1, config2);
      this.goal.SetRelateDemagemRect(-56, -110, 110, 110);
      this.Game.AddAction((IAction) new CallFunctionAction(new LivingCallBack(this.AddBoss), 2000));
    }

    private void AddBoss()
    {
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsShield = true;
      config.KeepLife = true;
      this.boss = this.Game.CreateBoss(this.bossID, 1223, 861, -1, 1, "", config);
      this.Game.SendGameFocus((Physics) this.boss, 0, 1000);
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      this.boss.PlayMovie("standB", 2000, 0);
      this.Game.AddAction((IAction) new CallFunctionAction(new LivingCallBack(this.ProtectGoal), 3000));
    }

    private void ProtectGoal()
    {
      this.goal.PlayMovie("beatA", 1000, 0);
      this.Game.AddAction((IAction) new CallFunctionAction(new LivingCallBack(this.AddNpc), 1000));
      this.boss.AddDelay(2500);
    }

    private void AddNpc()
    {
      this.Game.SendGameFocus((Physics) this.arbiNpc, 0, 1000);
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsFly = true;
      int x = this.Game.Random.Next(225, 1115);
      int y = this.Game.Random.Next(113, 354);
      for (int index = 0; index < 10; ++index)
      {
        this.someNpc.Add(this.Game.CreateNpc(this.npcID, x, y, 0, -1, config));
        x = this.Game.Random.Next(225, 1115);
        y = this.Game.Random.Next(113, 354);
      }
    }

    public override void OnStartMovie()
    {
      base.OnStartMovie();
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer != null && allFightPlayer.IsLiving)
        {
          ItemInfo fromTemplate = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(10471), 1, 101);
          allFightPlayer.PlayerDetail.AddTemplate(fromTemplate, eBageType.FightBag, 1, eGameView.OtherTypeGet);
        }
      }
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.boss.State == 1)
        this.goal.PlayMovie("beatB", 1000, 0);
      if (!this.Game.IsGoal || this.boss.Blood != 1)
        return;
      this.Game.AddAction((IAction) new CallFunctionAction(new LivingCallBack(this.Goal), 1000));
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (!this.Game.CanBeginNextProtect || this.boss.Blood != this.boss.NpcInfo.Blood)
        return;
      this.Game.PveGameDelay = 0;
      this.ProtectGoal();
      this.Game.CanBeginNextProtect = false;
    }

    public override void OnShooted()
    {
      base.OnShooted();
      if (!this.Game.IsGoal || this.boss.State != 1)
        return;
      ++this.Game.TotalGoal;
    }

    private void Goal()
    {
      this.Game.SendGameFocus((Physics) this.arbiNpc, 0, 2000);
      this.arbiNpc.Say(string.Format("Vào, tỉ số là {0}-0", (object) this.Game.TotalGoal), 1, 100);
      this.Game.IsGoal = false;
    }

    public override bool CanGameOver()
    {
      return this.needGoal <= this.Game.TotalGoal || this.Game.IsMissBall;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.Game.TotalGoal;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.needGoal <= this.Game.TotalGoal && !this.Game.IsMissBall)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer?.PlayerDetail.ClearFightBag();
    }
  }
}
