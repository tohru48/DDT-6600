// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SimpleBossFor40055
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class SimpleBossFor40055 : ABrain
  {
    private int m_attackTurn = 0;
    public int currentCount = 0;
    public int Dander = 0;

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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 670)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (!flag)
        ;
      if (this.m_attackTurn == 0)
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
        this.AttackD();
        ++this.m_attackTurn;
      }
      else
      {
        this.AttackE();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 1000f;
      this.Body.PlayMovie("beatA", 1000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void MoveBeatA()
    {
      this.Body.MoveTo(this.Game.Random.Next(641, 1110), 781, "walk", 500, "", 12, new LivingCallBack(this.AttackA));
    }

    private void AttackA()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("beatA", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 2000);
    }

    private void AttackB()
    {
      this.Body.CurrentDamagePlus = 0.8f;
      this.Body.PlayMovie("beatB", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 4000);
    }

    private void AttackD()
    {
      this.Body.CurrentDamagePlus = 1.1f;
      this.Body.PlayMovie("beatD", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 3500);
    }

    private void AttackE()
    {
      this.Body.CurrentDamagePlus = 1.1f;
      this.Body.PlayMovie("beatE", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 3500);
    }

    private void RangeAttacking()
    {
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 0, (List<Player>) null);
    }
  }
}
