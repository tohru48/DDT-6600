// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ConsortiaScorpionBoss
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
  public class ConsortiaScorpionBoss : ABrain
  {
    private int m_attackTurn = 0;
    public int currentCount = 0;
    public int Dander = 0;
    private PhysicalObj moive;
    private Player target = (Player) null;

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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 857 && allFightPlayer.X < 1440)
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
        this.Moving();
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
      this.Body.PlayMovie("beatA", 1000, 0);
      this.target = this.Game.FindRandomPlayer();
      this.Body.CurrentDamagePlus = 308f;
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 3300, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.CreateEffect), 3300);
      this.Body.CallFuction(new LivingCallBack(this.Out), 4600);
    }

    private void AllAttack()
    {
      this.ChangeDirection(3);
      this.Body.PlayMovie("beatA", 1000, 0);
      this.target = this.Game.FindRandomPlayer();
      this.Body.CurrentDamagePlus = 3.8f;
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 3300, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.CreateEffect), 3300);
      this.Body.CallFuction(new LivingCallBack(this.Out), 4600);
    }

    public void CreateEffect()
    {
      if (this.target == null)
        return;
      this.moive = this.target.X >= 1000 ? (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.target.X, this.target.Y, "effect", "asset.game.eight.xiezi", "beatB", 1, 0) : (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.target.X, this.target.Y, "effect", "asset.game.eight.xiezi", "beatA", 1, 0);
    }

    private void Out()
    {
      ((PVEGame) this.Game).SendGameFocus((Physics) this.Body, 1000, 2000);
      this.Body.PlayMovie("in", 1000, 0);
      if (this.moive == null)
        return;
      this.Game.RemovePhysicalObj(this.moive, true);
      this.moive = (PhysicalObj) null;
    }

    private void Moving()
    {
      this.ChangeDirection(3);
      int x = this.Game.Random.Next(990, 1300);
      int direction = this.Body.Direction;
      this.Body.MoveTo(x, this.Body.Y, "walk", 1000, "", ((SimpleBoss) this.Body).NpcInfo.speed);
      this.Body.ChangeDirection(this.Game.FindlivingbyDir(this.Body), 3000);
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
