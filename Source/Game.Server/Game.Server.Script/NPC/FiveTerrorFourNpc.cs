// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FiveTerrorFourNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FiveTerrorFourNpc : ABrain
  {
    protected Player m_targer;

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
      this.m_targer = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      this.Beating();
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void MoveToPlayer(Player player)
    {
      int num1 = (int) player.Distance(this.Body.X, this.Body.Y);
      int num2 = this.Game.Random.Next(((SimpleNpc) this.Body).NpcInfo.MoveMin, ((SimpleNpc) this.Body).NpcInfo.MoveMax);
      if (num1 <= 97)
        return;
      int num3 = num1 <= ((SimpleNpc) this.Body).NpcInfo.MoveMax ? num1 - 90 : num2;
      if (player.Y < 420 && player.X < 210)
      {
        if (this.Body.Y > 420)
        {
          if (this.Body.X - num3 < 50)
            this.Body.MoveTo(25, this.Body.Y, "fly", 1200, "", 3, new LivingCallBack(this.MoveBeat));
          else
            this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "fly", 1200, "", 3, new LivingCallBack(this.MoveBeat));
        }
        else if (player.X > this.Body.X)
          this.Body.MoveTo(this.Body.X + num3, this.Body.Y, "fly", 1200, "", 3, new LivingCallBack(this.MoveBeat));
        else
          this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "fly", 1200, "", 3, new LivingCallBack(this.MoveBeat));
      }
      else if (this.Body.Y < 420)
      {
        if (this.Body.X + num3 > 200)
          this.Body.MoveTo(200, this.Body.Y, "fly", 1200, "", 3, new LivingCallBack(this.MoveBeat));
      }
      else if (player.X > this.Body.X)
        this.Body.MoveTo(this.Body.X + num3, this.Body.Y, "fly", 1200, "", 3, new LivingCallBack(this.MoveBeat));
      else
        this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "fly", 1200, "", 3, new LivingCallBack(this.MoveBeat));
    }

    public void MoveBeat() => this.Body.Beat((Living) this.m_targer, "beatA", 100, 0, 0, 1, 1);

    public void Beating()
    {
      if (this.m_targer == null || this.Body.Beat((Living) this.m_targer, "beatA", 100, 0, 0, 1, 1))
        return;
      this.MoveToPlayer(this.m_targer);
    }
  }
}
