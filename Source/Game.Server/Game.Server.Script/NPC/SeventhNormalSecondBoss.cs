// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SeventhNormalSecondBoss
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
  public class SeventhNormalSecondBoss : ABrain
  {
    private int m_attackTurn = 0;
    private bool IsEixt = false;
    protected Player m_targer;
    private PhysicalObj moive;
    private PhysicalObj m_effect = (PhysicalObj) null;
    private static string[] AllAttackChat = new string[1]
    {
      "Cận thận cái đầu !!"
    };
    private static string[] ShootChat = new string[2]
    {
      "Thịt đè người !",
      "Cảm nhận sức mạnh của ta !"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "Đến nộp mạng à ?? Sức mạnh tối cao!!..."
    };

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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 350)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, 350);
      else if (this.m_attackTurn == 0)
      {
        if (this.IsEixt)
        {
          this.Game.RemovePhysicalObj(this.m_effect, true);
          this.IsEixt = false;
        }
        this.AttackingB();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.AttackingA();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.AttackingC();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.AttackingD();
        ++this.m_attackTurn;
      }
      else
      {
        this.AttackingC();
        this.m_attackTurn = 0;
      }
    }

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, SeventhNormalSecondBoss.KillAttackChat.Length);
      this.Body.Say(SeventhNormalSecondBoss.KillAttackChat[index], 1, 0);
      this.Body.PlayMovie("skill", 1900, 0);
      this.Body.RangeAttacking(0, 350, "cry", 4000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.GoKillAttack), 4000);
    }

    private void GoKillAttack()
    {
      this.Body.CurrentDamagePlus *= 10f;
      this.m_targer = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      this.m_effect = ((PVEGame) this.Game).CreatePhysicalObj(this.m_targer.X, this.m_targer.Y, "skill", "asset.game.seven.jinqucd", "1", 1, 0);
    }

    private void AttackingB()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.MoveTo(randomPlayer.X - 150, randomPlayer.Y, "run", 1000, "", 18, new LivingCallBack(this.NextAttackB));
    }

    private void NextAttackB()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("beatB", 500, 0);
      this.Body.RangeAttacking(this.Body.X, this.Body.X + 170, "cry", 2500, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.Comback), 3000);
    }

    private void Comback()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.MoveTo(181, this.Body.Y, "run", 1000, "", 18, new LivingCallBack(this.ChangeDirection));
    }

    private void ChangeDirection() => this.Body.Direction = this.Game.FindlivingbyDir(this.Body);

    private void AttackingA()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.MoveTo(randomPlayer.X - 150, randomPlayer.Y, "run", 1000, "", 18, new LivingCallBack(this.NextAttackA));
    }

    private void NextAttackA()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("beatA", 500, 0);
      this.Body.RangeAttacking(this.Body.X, this.Body.X + 170, "cry", 2500, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.Comback), 3000);
    }

    private void AttackingC()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null || !this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 83, 1000, 10000, 2, 1f, 3300))
        return;
      this.Body.PlayMovie("beatC", 1500, 0);
    }

    private void AttackingD()
    {
      this.Body.MoveTo(1477, this.Body.Y, "run", 1000, "", 18, new LivingCallBack(this.PersonalAttack));
    }

    private void PersonalAttack()
    {
      this.Body.Direction = -this.Body.Direction;
      this.Body.PlayMovie("beatD", 500, 8100);
      this.Body.CallFuction(new LivingCallBack(this.GoMovie), 6100);
    }

    private void GoMovie()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      int x = randomPlayer.X;
      this.Body.RangeAttacking(x - 200, x + 200, "cry", 1000, (List<Player>) null);
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(x, randomPlayer.Y, "moive", "asset.game.seven.choud", "out", 1, 0);
      this.Body.CallFuction(new LivingCallBack(this.GoAttacking), 2000);
    }

    private void GoAttacking()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (!this.IsEixt && randomPlayer != null)
      {
        this.m_effect = ((PVEGame) this.Game).CreatePhysicalObj(randomPlayer.X, randomPlayer.Y, "effect", "asset.game.seven.du", "1", 1, 0);
        this.IsEixt = true;
        foreach (Player allLivingPlayer in this.Game.GetAllLivingPlayers())
        {
          int num = 140;
          if (allLivingPlayer.X > randomPlayer.X - num && allLivingPlayer.X < randomPlayer.X + num)
            allLivingPlayer.AddEffect((AbstractEffect) new ContinueReduceBlood(2, 500, (Living) allLivingPlayer), 0);
        }
      }
      this.Body.CallFuction(new LivingCallBack(this.Comback), 1000);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
