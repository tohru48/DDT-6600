// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FourNormalShortNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FourNormalShortNpc : ABrain
  {
    public int attackingTurn = 1;
    public int orchinIndex = 1;
    public int currentCount = 0;
    public int Dander = 0;
    protected List<Living> m_livings;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
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
        if (flag)
          return;
        if (this.attackingTurn == 1)
          this.MoveToPlayer();
        else if (this.attackingTurn == 2)
          this.MoveToPlayer();
        else if (this.attackingTurn == 3)
        {
          this.MoveToPlayer();
        }
        else
        {
          this.MoveToPlayer();
          this.attackingTurn = 0;
        }
        ++this.attackingTurn;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void MoveToPlayer()
    {
      this.Body.MoveTo(this.Game.Random.Next(370, 650), this.Body.Y, "walk", 2000, "", 4);
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.PlayMovie("beat", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }
  }
}
