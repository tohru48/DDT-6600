// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SixNormalFirstBall
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class SixNormalFirstBall : ABrain
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 480 && allFightPlayer.X < 1000)
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
        this.PersonalAttack();
        ++this.m_attackTurn;
      }
      else
      {
        this.AllAttack();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      this.ChangeDirection(3);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("stand", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void AllAttack()
    {
      this.ChangeDirection(3);
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("stand", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 4000, (List<Player>) null);
    }

    private void PersonalAttack()
    {
      this.ChangeDirection(3);
      int x = this.Game.Random.Next(550, 1200);
      int direction = this.Body.Direction;
      this.Body.MoveTo(x, this.Body.Y, "walk", 1000, "", ((SimpleBoss) this.Body).NpcInfo.speed);
      this.Body.ChangeDirection(this.Game.FindlivingbyDir(this.Body), 9000);
    }

    private void ChangeDirection(int count)
    {
      int direction = this.Body.Direction;
      for (int index = 0; index < count; ++index)
      {
        this.Body.ChangeDirection(-direction, index * 200 + 100);
        this.Body.ChangeDirection(direction, (index + 1) * 100 + index * 200);
      }
    }
  }
}
