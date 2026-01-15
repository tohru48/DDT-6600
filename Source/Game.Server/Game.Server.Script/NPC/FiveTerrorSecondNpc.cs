// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FiveTerrorSecondNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FiveTerrorSecondNpc : ABrain
  {
    private Player m_target = (Player) null;
    private int m_targetDis = 0;

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
      this.m_target = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      this.m_targetDis = (int) this.m_target.Distance(this.Body.X, this.Body.Y);
      if (this.m_targetDis < 50)
      {
        this.Body.PlayMovie("beat", 100, 0);
        this.Body.RangeAttacking(this.Body.X - 100, this.Body.X + 100, "cry", 1500, (List<Player>) null);
      }
      else
        this.MoveToPlayer(this.m_target);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void MoveToPlayer(Player player)
    {
      int num = this.Game.Random.Next(((SimpleNpc) this.Body).NpcInfo.MoveMin, ((SimpleNpc) this.Body).NpcInfo.MoveMax);
      if (player.X > this.Body.X)
        this.Body.MoveTo(this.Body.X + num, this.Body.Y, "walk", 2000, "", 3, new LivingCallBack(this.Beat));
      else
        this.Body.MoveTo(this.Body.X - num, this.Body.Y, "walk", 2000, "", 3, new LivingCallBack(this.Beat));
    }

    public void Beat()
    {
      if (this.m_targetDis >= 50)
        return;
      this.Body.PlayMovie("beatA", 100, 0);
      this.Body.RangeAttacking(this.Body.X - 100, this.Body.X + 100, "cry", 1500, (List<Player>) null);
    }
  }
}
