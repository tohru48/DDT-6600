// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirdHardBloomNpcS
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirdHardBloomNpcS : ABrain
  {
    private Player m_target = (Player) null;
    private int m_targetDis = 0;
    private int attackingTurn = 1;
    private int IsEixt = 0;

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
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.m_target = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      this.m_targetDis = (int) this.m_target.Distance(this.Body.X, this.Body.Y);
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
        {
          if (this.m_targetDis < 100)
          {
            foreach (Living allLivingPlayer in this.Game.GetAllLivingPlayers())
              allLivingPlayer.AddBlood(700);
            this.Body.PlayMovie("renew", 700, 400);
          }
          else
            this.MoveToPlayer(this.m_target);
        }
        else if (this.attackingTurn == 2)
        {
          if (this.m_targetDis < 100)
          {
            foreach (Living allLivingPlayer in this.Game.GetAllLivingPlayers())
              allLivingPlayer.AddBlood(700);
            this.Body.PlayMovie("renew", 700, 400);
          }
          else
            this.MoveToPlayer(this.m_target);
        }
        else if (this.attackingTurn == 3)
        {
          if (this.m_targetDis < 100)
          {
            foreach (Living allLivingPlayer in this.Game.GetAllLivingPlayers())
              allLivingPlayer.AddBlood(700);
            this.Body.PlayMovie("renew", 700, 400);
          }
          else
            this.MoveToPlayer(this.m_target);
        }
        else if (this.attackingTurn == 4)
        {
          if (this.m_targetDis < 100)
          {
            foreach (Living allLivingPlayer in this.Game.GetAllLivingPlayers())
              allLivingPlayer.AddBlood(700);
            this.Body.PlayMovie("renew", 700, 400);
          }
          else
            this.MoveToPlayer(this.m_target);
        }
        else if (this.attackingTurn == 5)
        {
          this.Body.PlayMovie("die", 700, 400);
          this.Body.CallFuction(new LivingCallBack(this.MoveTo), 1500);
        }
        else
          this.attackingTurn = 1;
        ++this.attackingTurn;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void KillAttack(int fx, int mx)
    {
    }

    public void MoveToPlayer(Player player)
    {
      this.Body.Say("Đến gần tui sẻ hồi máu cho!", 0, 2000);
    }

    public void MoveTo()
    {
      if (this.IsEixt == 1)
      {
        this.Body.JumpToSpeed(478, 560, "born", 0, 0, 36, (LivingCallBack) null);
        this.IsEixt = 0;
      }
      else
      {
        this.Body.JumpToSpeed(1000, 560, "born", 0, 0, 36, (LivingCallBack) null);
        this.IsEixt = 1;
      }
    }

    public void Beat()
    {
      if (this.m_targetDis >= 100)
        return;
      foreach (Living allLivingPlayer in this.Game.GetAllLivingPlayers())
        allLivingPlayer.AddBlood(700);
      this.Body.PlayMovie("renew", 700, 400);
    }
  }
}
