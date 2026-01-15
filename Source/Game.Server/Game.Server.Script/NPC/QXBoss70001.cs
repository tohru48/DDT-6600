// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.QXBoss70001
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
  public class QXBoss70001 : ABrain
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 919)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(919, this.Game.Map.Info.ForegroundWidth + 1000);
      else if (this.m_attackTurn == 0)
      {
        this.AttackA();
        ++this.m_attackTurn;
      }
      else
      {
        this.AttackB();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 1000f;
      this.Body.PlayMovie("beatA", 1000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 3000, (List<Player>) null);
    }

    private void AttackA()
    {
      this.Body.CurrentDamagePlus = 1.5f;
      this.Body.PlayMovie("beatA", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 3000);
    }

    private void AttackB()
    {
      this.Body.PlayMovie("beatB", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.AddEffect), 3000);
    }

    private void AddEffect()
    {
      ((PVEGame) this.Game).SendGameFocus((Physics) this.Body, 0, 1000);
      foreach (Player allLivingPlayer in this.Game.GetAllLivingPlayers())
      {
        int blood = allLivingPlayer.MaxBlood * 10 / 100;
        allLivingPlayer.AddEffect((AbstractEffect) new ContinueReduceBlood(2, blood, (Living) allLivingPlayer), 0);
      }
    }

    private void RangeAttacking()
    {
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 0, (List<Player>) null);
    }
  }
}
