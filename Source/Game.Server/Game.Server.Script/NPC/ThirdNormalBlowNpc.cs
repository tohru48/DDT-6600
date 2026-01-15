// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirdNormalBlowNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirdNormalBlowNpc : ABrain
  {
    private int m_attackTurn = 0;
    private SimpleBoss m_king = (SimpleBoss) null;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 0)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
      {
        this.KillAttack(0, 0);
      }
      else
      {
        if (this.m_attackTurn == 0)
        {
          this.Healing();
          ++this.m_attackTurn;
        }
        if (this.m_attackTurn == 1)
        {
          this.Healing();
          ++this.m_attackTurn;
        }
        else
        {
          this.GoHealing();
          this.m_attackTurn = 0;
        }
      }
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beat", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void Healing()
    {
    }

    private void GoHealing()
    {
      this.Body.SyncAtTime = true;
      this.Body.PlayMovie("die", 1000, 4500);
      this.Body.Die(1000);
      this.Body.RangeAttacking(this.Body.X - 200, this.Body.X + 200, "cry", 1500, (List<Player>) null);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
