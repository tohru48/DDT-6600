// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.CryptBoss2
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
  public class CryptBoss2 : ABrain
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
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > this.Body.X - 150 && allFightPlayer.X < this.Body.X + 150)
          flag = true;
      }
      if (flag)
        this.KillAttack(this.Body.X - 150, this.Body.X + 150);
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
      else
      {
        this.AttackC();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 1000f;
      this.Body.PlayMovie("beatC", 1000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void AttackA()
    {
      this.Body.PlayMovie("beatA", 3000, 0);
      this.Body.CallFuction(new LivingCallBack(this.GoShootA), 4000);
    }

    private void GoShootA()
    {
      this.target = this.Game.FindRandomPlayer();
      if (this.target == null)
        return;
      ((PVEGame) this.Game).SendGameFocus((Physics) this.target, 0, 1000);
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.target.X, this.target.Y, "moive", "asset.game.eleven.055a", "out", 1, 1);
      this.Body.CallFuction(new LivingCallBack(this.GoOutA), 2000);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 1000);
    }

    private void GoOutA()
    {
      if (this.moive == null)
        return;
      this.Game.RemovePhysicalObj(this.moive, true);
      this.moive = (PhysicalObj) null;
    }

    private void AttackC()
    {
      Player nearestPlayer = this.Game.FindNearestPlayer(0, 1500);
      if (nearestPlayer == null)
        return;
      this.Body.MoveTo(nearestPlayer.X + 110, nearestPlayer.Y, "fly", 1000, "", 18, new LivingCallBack(this.NextAttackC));
    }

    private void NextAttackC()
    {
      this.Body.CurrentDamagePlus = 0.7f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("beatC", 2500, 0);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttackingC), 3700);
    }

    private void RangeAttackingC()
    {
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 0, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.Comback), 1500);
    }

    private void AttackB()
    {
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.CallFuction(new LivingCallBack(this.GoShootB), 4000);
    }

    private void GoShootB()
    {
      this.target = this.Game.FindRandomPlayer();
      if (this.target == null)
        return;
      ((PVEGame) this.Game).SendGameFocus((Physics) this.target, 0, 1000);
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.target.X, this.target.Y, "moive", "asset.game.eleven.055b", "out", 1, 1);
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

    private void Comback()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.MoveTo(796, 361, "fly", 1000, "", 18, new LivingCallBack(this.ChangeDirection));
    }

    private void ChangeDirection() => this.Body.Direction = this.Game.FindlivingbyDir(this.Body);

    private void RangeAttacking()
    {
      this.Body.CurrentDamagePlus = 0.9f;
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 0, (List<Player>) null);
    }
  }
}
