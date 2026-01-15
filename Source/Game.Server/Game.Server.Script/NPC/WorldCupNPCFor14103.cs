// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.WorldCupNPCFor14103
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class WorldCupNPCFor14103 : ABrain
  {
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
      this.Body.MoveTo(this.Game.Random.Next(1410, 1700), this.Body.Y, "walk", 1000, "", 3, new LivingCallBack(this.PersonalAttack));
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void PersonalAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 1.3f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 109, 1000, 10000, 1, 3f, 1600))
        this.Body.PlayMovie("beatA", 1100, 0);
    }
  }
}
