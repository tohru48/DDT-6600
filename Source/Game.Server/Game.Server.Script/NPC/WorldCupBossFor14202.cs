// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.WorldCupBossFor14202
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class WorldCupBossFor14202 : ABrain
  {
    private int m_attackTurn = 0;
    private int ballID = 14201;
    public int currentCount = 0;
    public int Dander = 0;
    private PhysicalObj moive;
    private Living target;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
      this.Body.SetRect(((SimpleBoss) this.Body).NpcInfo.X, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
      if (this.Body.Direction == -1)
        this.Body.SetRect(((SimpleBoss) this.Body).NpcInfo.X, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
      else
        this.Body.SetRect(-((SimpleBoss) this.Body).NpcInfo.X - ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.FindBall();
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void FindBall()
    {
      List<Living> holdBall = this.Game.FindHoldBall();
      if (holdBall.Count <= 0)
        return;
      this.target = holdBall[0];
      if (this.moive != null && this.target.X < this.moive.X + 100 && this.target.X > this.moive.X - 100)
      {
        this.AttackA();
      }
      else
      {
        this.GoOut();
        int x = this.target.X;
        this.Body.MoveTo(x >= this.Body.X ? x - 160 : x + 160, this.target.Y, "walk", 500, "", 7, new LivingCallBack(this.TargetBall));
      }
    }

    private void TargetBall()
    {
      if (this.target != null)
        this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.target.X, this.target.Y, "moive", "asset.game.nine.biaoji", "out", 1, 1);
      this.Body.CallFuction(new LivingCallBack(this.AttackC), 100);
    }

    private void AttackC()
    {
      this.Body.PlayMovie("beatC", 1000, 0);
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer != null && allFightPlayer.X < this.moive.X + 100 && allFightPlayer.X > this.moive.X - 100)
        {
          int reduce = 0;
          allFightPlayer.AddEffect((AbstractEffect) new ReduceStrengthEffect(2, reduce), 0);
          allFightPlayer.LimitEnergy = true;
          allFightPlayer.TotalCureEnergy = 30;
          allFightPlayer.AddRemoveEnergy(30);
        }
      }
      if (this.m_attackTurn == 1)
        this.Body.CallFuction(new LivingCallBack(this.AttackB), 1000);
      else
        ++this.m_attackTurn;
    }

    private void AttackB()
    {
      this.Body.CurrentDamagePlus = 2.2f;
      this.Body.PlayMovie("beatB", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.MovingPlayer), 1000);
    }

    private void MovingPlayer()
    {
      foreach (Player allPlayer in this.Game.GetAllPlayers())
      {
        int x1 = allPlayer.X;
        int x2 = x1 >= this.Game.Map.Info.ForegroundWidth / 2 ? x1 - 100 : x1 + 100;
        allPlayer.StartSpeedMult(x2, allPlayer.Y);
      }
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 1000);
    }

    private void RangeAttacking()
    {
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 0, (List<Player>) null);
      this.m_attackTurn = 0;
    }

    private void AttackA()
    {
      this.Body.PlayMovie("beatA", 1500, 0);
      this.Body.CallFuction(new LivingCallBack(this.shotBall), 1500);
    }

    private void shotBall()
    {
      if (this.target == null)
        return;
      int x = this.target.X + 200 * this.Body.Direction;
      if (x > this.Game.Map.Info.ForegroundWidth)
        x = this.Game.Map.Info.ForegroundWidth;
      if (x < 1)
        x = 1;
      if (this.target is Player)
      {
        LivingConfig config = ((PVEGame) this.Game).BaseLivingConfig();
        config.IsHelper = true;
        config.HasTurn = false;
        SimpleNpc npc = ((PVEGame) this.Game).CreateNpc(this.ballID, this.target.X, this.target.Y, 1, -1, config);
        npc.MoveTo(x, npc.Y, "walk", 0, "", 3);
        this.Game.TakePassBall(-1);
      }
      else if (this.target is SimpleNpc)
        this.target.MoveTo(x, this.target.Y, "walk", 0, "", 3);
      ((PVEGame) this.Game).IsMissBall = true;
    }

    private void GoOut()
    {
      if (this.moive == null)
        return;
      this.Game.RemovePhysicalObj(this.moive, true);
      this.moive = (PhysicalObj) null;
    }
  }
}
