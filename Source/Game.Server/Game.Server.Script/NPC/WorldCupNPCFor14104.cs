// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.WorldCupNPCFor14104
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class WorldCupNPCFor14104 : ABrain
  {
    protected SimpleNpc m_targer;
    private PhysicalObj moive;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      if (this.Body.IsFrost)
        return;
      this.m_targer = this.Game.FindHelper();
      this.RunToGoal();
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void RunToGoal()
    {
      if (this.m_targer == null || this.Body.Y <= this.m_targer.X)
        return;
      this.MoveToGoal(this.m_targer);
    }

    public void MoveToGoal(SimpleNpc player)
    {
      int num1 = (int) this.m_targer.Distance(this.Body.X, this.Body.Y);
      int num2 = this.Game.Random.Next(((SimpleNpc) this.Body).NpcInfo.MoveMin, ((SimpleNpc) this.Body).NpcInfo.MoveMax);
      if (num1 <= 97)
        return;
      int num3 = num1 <= ((SimpleNpc) this.Body).NpcInfo.MoveMax ? num1 - 90 : num2;
      if (this.Body.Y < 420)
      {
        if (this.Body.X + num3 > 200)
          this.Body.MoveTo(300, this.Body.Y, "walk", 1200, "", 7, new LivingCallBack(this.Shoot));
      }
      else if (player.X > this.Body.X)
        this.Body.MoveTo(this.Body.X + num3, this.Body.Y, "walk", 1200, "", 7, new LivingCallBack(this.Shoot));
      else
        this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "walk", 1200, "", 7, new LivingCallBack(this.Shoot));
    }

    private void Shoot()
    {
      if ((int) this.m_targer.Distance(this.Body.X, this.Body.Y) >= 300)
        return;
      ((PVEGame) this.Game).SendGameFocus((Physics) this.Body, 0, 100);
      this.Body.PlayMovie("beatA", 1500, 0);
      this.Body.CallFuction(new LivingCallBack(this.Goal), 2000);
    }

    private void Goal()
    {
      if (this.m_targer == null)
        return;
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.m_targer.X, this.m_targer.Y, "moive", "game.living.Living371", "stand", 1, 1);
      this.moive.PlayMovie("walk", 1000, 0);
      ((PVEGame) this.Game).IsMissBall = true;
    }
  }
}
