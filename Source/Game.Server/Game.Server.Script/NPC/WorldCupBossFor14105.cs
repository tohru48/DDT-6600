// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.WorldCupBossFor14105
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
  public class WorldCupBossFor14105 : ABrain
  {
    private int m_attackTurn = 0;
    public int currentCount = 0;
    public int Dander = 0;
    private int npcID = 14104;
    public List<SimpleNpc> Children = new List<SimpleNpc>();

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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1070)
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
        this.CallChild();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.AttackA();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.AttackC();
        ++this.m_attackTurn;
      }
      else
      {
        if (((SimpleBoss) this.Body).CurrentLivingNpcNum > 0)
          this.HealChild();
        else
          this.CallChild();
        this.m_attackTurn = 1;
      }
    }

    public void HealChild()
    {
      this.Body.PlayMovie("beatD", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.Heal), 1500);
    }

    public void Heal()
    {
      SimpleNpc frostChild = ((SimpleBoss) this.Body).FindFrostChild();
      if (frostChild == null || !frostChild.IsLiving)
        return;
      if (frostChild != null && frostChild.IsFrost)
      {
        ((PVEGame) this.Game).SendGameFocus((Physics) frostChild, 0, 2000);
        frostChild.IsFrost = false;
        frostChild.PlayMovie("stand", 1000, 0);
      }
      else
        frostChild.AddBlood(10000);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 1000f;
      this.Body.PlayMovie("beatD", 1000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void CallChild()
    {
      this.Body.PlayMovie("beatB", 1000, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild), 1500);
    }

    private void AttackA()
    {
      List<Player> allFightPlayers = this.Game.GetAllFightPlayers();
      this.Body.CurrentDamagePlus = 1.3f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      foreach (Player player in allFightPlayers)
      {
        if (player != null && this.Body.ShootPoint(player.X, player.Y, 14005, 1000, 10000, 1, 3f, 1550))
          this.Body.PlayMovie("beatA", 1050, 0);
      }
    }

    private void AttackC()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.MoveTo(randomPlayer.X + 220, randomPlayer.Y, "walkB", 1000, "", 22, new LivingCallBack(this.NextAttackC));
    }

    private void NextAttackC()
    {
      this.Body.CurrentDamagePlus = 1.7f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("beatC", 500, 0);
      this.Body.RangeAttacking(this.Body.X - 270, this.Body.X, "cry", 1500, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.Comback), 2000);
    }

    private void Comback()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.MoveTo(1816, this.Body.Y, "walkB", 1000, "", 22, new LivingCallBack(this.ChangeDirection));
    }

    private void ChangeDirection() => this.Body.Direction = this.Game.FindlivingbyDir(this.Body);

    private void RangeAttacking()
    {
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 0, (List<Player>) null);
    }

    public void CreateChild()
    {
      ((SimpleBoss) this.Body).CreateChild(this.npcID, 1580, 861, 60, 1, -1);
    }
  }
}
