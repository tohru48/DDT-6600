// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SimpleNpcFor40060
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class SimpleNpcFor40060 : ABrain
  {
    protected Player m_targer;
    private int m_attackTurn = 0;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 0.5f;
      this.m_body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      if (this.m_attackTurn == 0)
      {
        this.MoveBeat();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Move();
        ++this.m_attackTurn;
      }
      else
      {
        this.MoveBeat();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void Move()
    {
      this.Body.MoveTo(this.Game.Random.Next(225, 1115), this.Game.Random.Next(113, 354), "fly", 500, "", 12, (LivingCallBack) null);
    }

    private void MoveBeat()
    {
      this.Body.MoveTo(this.Game.Random.Next(225, 1115), this.Game.Random.Next(113, 354), "fly", 500, "", 12, new LivingCallBack(this.Beating));
    }

    public void Beating()
    {
      this.Body.PlayMovie("beatA", 2000, 0);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 3000);
    }

    private void RangeAttacking()
    {
      this.Body.RangeAttacking(0, this.Body.Game.Map.Info.ForegroundWidth + 1, "cry", 1000, (List<Player>) null);
    }
  }
}
