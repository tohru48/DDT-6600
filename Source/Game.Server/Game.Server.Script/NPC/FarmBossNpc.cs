// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FarmBossNpc
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
  public class FarmBossNpc : ABrain
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 919)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(765, this.Game.Map.Info.ForegroundWidth + 1000);
      else if (this.m_attackTurn == 0)
      {
        this.PersonalAttack();
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
      this.Body.PlayMovie("beatB", 1000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void AttackC()
    {
      this.Body.PlayMovie("beatC", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.Health), 2500);
    }

    private void Health()
    {
      switch ((this.Body as SimpleBoss).NpcInfo.ID)
      {
        case 50101:
          this.Body.AddBlood(5000);
          break;
        case 50102:
          this.Body.AddBlood(15000);
          break;
        case 50103:
          this.Body.AddBlood(20000);
          break;
        case 50104:
          this.Body.AddBlood(25000);
          break;
        case 50105:
          this.Body.AddBlood(30000);
          break;
      }
    }

    private void AttackB()
    {
      this.Body.PlayMovie("beatB", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.GoShootB), 2000);
    }

    private void GoShootB()
    {
      this.target = this.Game.FindRandomPlayer();
      if (this.target == null)
        return;
      ((PVEGame) this.Game).SendGameFocus((Physics) this.target, 0, 1000);
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.target.X, this.target.Y, "moive", "asset.game.fifteen.380b", "out", 1, 1);
      this.Body.CallFuction(new LivingCallBack(this.GoOutB), 1500);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 1500);
    }

    private void GoOutB()
    {
      if (this.moive == null)
        return;
      this.Game.RemovePhysicalObj(this.moive, true);
      this.moive = (PhysicalObj) null;
    }

    private void PersonalAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 0.8f;
      this.Game.Random.Next(randomPlayer.X - 10, randomPlayer.X + 10);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, (int) sbyte.MaxValue, 1000, 10000, 1, 3f, 2550))
        this.Body.PlayMovie("beatA", 1700, 0);
    }

    private void RangeAttacking()
    {
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 0, (List<Player>) null);
    }
  }
}
