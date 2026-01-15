// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.MonstrousHumanoid
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class MonstrousHumanoid : ABrain
  {
    private Player m_target;

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
      base.OnStartAttacking();
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      if (this.ShootLowestBooldPlayer())
        return;
      this.RandomShootPlayer();
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private bool ShootLowestBooldPlayer()
    {
      List<Player> playerList = new List<Player>();
      foreach (Player allLivingPlayer in this.Game.GetAllLivingPlayers())
      {
        if ((double) allLivingPlayer.Blood < (double) allLivingPlayer.MaxBlood * 0.2)
          playerList.Add(allLivingPlayer);
      }
      if (playerList.Count <= 0)
        return false;
      int index = this.Game.Random.Next(0, playerList.Count);
      this.m_target = playerList[index];
      this.NpcAttack();
      return true;
    }

    private void RandomShootPlayer()
    {
      List<Player> allLivingPlayers = this.Game.GetAllLivingPlayers();
      int index = this.Game.Random.Next(0, allLivingPlayers.Count);
      this.m_target = allLivingPlayers[index];
      this.NpcAttack();
    }

    private void NpcAttack()
    {
      int num1;
      if (this.m_target.X > this.Body.X)
      {
        num1 = 1;
        this.Body.ChangeDirection(1, 0);
      }
      else
      {
        num1 = -1;
        this.Body.ChangeDirection(-1, 0);
      }
      int num2 = Math.Abs(this.m_target.X - this.Body.X);
      if (num2 < 300)
      {
        this.ShootAttack();
      }
      else
      {
        int num3 = this.Game.Random.Next(((SimpleBoss) this.Body).NpcInfo.MoveMin, ((SimpleBoss) this.Body).NpcInfo.MoveMax) * 3;
        if (num3 > num2)
          num3 = num2 - 300;
        if (!this.Body.MoveTo(this.Body.X + num3 * num1, this.m_target.Y - 20, "walk", 0, "", ((SimpleBoss) this.Body).NpcInfo.speed, new LivingCallBack(this.ShootAttack)))
          this.ShootAttack();
      }
    }

    private void ShootAttack()
    {
      int num1 = Math.Abs(this.m_target.X - this.Body.X);
      int num2 = num1 >= 200 ? (num1 >= 500 ? 50 : 30) : 10;
      if (!this.Body.ShootPoint(this.Game.Random.Next(this.m_target.X - num2, this.m_target.X + num2), this.m_target.Y, ((SimpleBoss) this.Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 2f, 1700))
        return;
      this.Body.PlayMovie("beat", 1700, 0);
    }
  }
}
