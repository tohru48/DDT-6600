// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.NewTrainingBoss21002
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class NewTrainingBoss21002 : ABrain
  {
    private int m_attackTurn = 0;
    public int currentCount = 0;
    public int Dander = 0;

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
      if (this.m_attackTurn == 0)
        ++this.m_attackTurn;
      else
        this.PersonalAttack();
    }

    private void PersonalAttack() => this.NextAttack();

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void NextAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.SetRect(0, 0, 0, 0);
      if (randomPlayer.X > this.Body.Y)
        this.Body.ChangeDirection(1, 500);
      else
        this.Body.ChangeDirection(-1, 500);
      this.Body.CurrentDamagePlus = 0.8f;
      if (randomPlayer == null || !this.Body.ShootPoint(this.Game.Random.Next(randomPlayer.X - 50, randomPlayer.X + 50), randomPlayer.Y, ((SimpleBoss) this.Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 1f, 2200))
        return;
      this.Body.PlayMovie("beat", 1700, 0);
    }
  }
}
