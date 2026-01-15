// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.YearMonster
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class YearMonster : ABrain
  {
    private int m_attackTurn = 0;
    public int currentCount = 0;
    public int Dander = 0;
    private PhysicalObj moive;
    private Player target;

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
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1000)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, this.Game.Map.Info.ForegroundWidth + 1);
      else if (this.m_attackTurn == 0)
      {
        this.AttackA();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.AttackB();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.AttackC();
        ++this.m_attackTurn;
      }
      else
      {
        this.AttackD();
        this.target = this.Game.FindRandomPlayer();
        if (this.target != null)
          this.m_attackTurn = this.target.X >= 400 ? 1 : 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 1000f;
      this.Body.PlayMovie("beatE", 2000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 3000, (List<Player>) null);
    }

    private void AttackA()
    {
      this.Body.CurrentDamagePlus = 1.5f;
      this.Body.PlayMovie("beatA", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.MovingPlayer), 3000);
    }

    private void MovingPlayer()
    {
      foreach (Player allPlayer in this.Game.GetAllPlayers())
        allPlayer.StartSpeedMult(allPlayer.X - 200, allPlayer.Y);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 1000);
    }

    private void AttackB()
    {
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.CallFuction(new LivingCallBack(this.GoShootB), 4000);
    }

    private void AttackC()
    {
      this.Body.CurrentDamagePlus = 3.1f;
      this.Body.PlayMovie("beatC", 3000, 0);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 4500);
    }

    private void AttackD()
    {
      this.Body.PlayMovie("beatD", 3000, 0);
      this.Body.CallFuction(new LivingCallBack(this.GoShootD), 4000);
    }

    private void GoShootB()
    {
      this.Body.CurrentDamagePlus = 2.5f;
      this.target = this.Game.FindRandomPlayer();
      if (this.target == null)
        return;
      ((PVEGame) this.Game).SendGameFocus((Physics) this.target, 0, 1000);
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.target.X, this.target.Y, "moive", "asset.game.fifteen.305b", "out", 1, 1);
      this.Body.CallFuction(new LivingCallBack(this.GoOutB), 2000);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 1000);
    }

    private void GoOutB()
    {
      if (this.moive == null)
        return;
      this.Game.RemovePhysicalObj(this.moive, true);
      this.moive = (PhysicalObj) null;
    }

    private void GoShootD()
    {
      this.Body.CurrentDamagePlus = 7.5f;
      this.target = this.Game.FindRandomPlayer();
      if (this.target == null)
        return;
      ((PVEGame) this.Game).SendGameFocus((Physics) this.target, 0, 1000);
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.target.X, this.target.Y, "moive", "asset.game.fifteen.305d", "out", 1, 1);
      this.Body.CallFuction(new LivingCallBack(this.GoOutD), 2000);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 1000);
    }

    private void GoOutD()
    {
      ((PVEGame) this.Game).SendGameFocus((Physics) this.Body, 0, 1000);
      this.Body.PlayMovie("born", 1000, 0);
      if (this.moive == null)
        return;
      this.Game.RemovePhysicalObj(this.moive, true);
      this.moive = (PhysicalObj) null;
    }

    private void RangeAttacking()
    {
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 0, (List<Player>) null);
    }
  }
}
