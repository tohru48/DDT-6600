// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SeizeNpcAi
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class SeizeNpcAi : ABrain
  {
    private int m_attackTurn = 0;
    private int currentCount = 0;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking() => base.OnStartAttacking();

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
    }

    private void AllAttack()
    {
    }

    private void PersonalAttack()
    {
    }

    private void Summon()
    {
    }

    private void NextAttack()
    {
    }

    private void ChangeDirection(int count)
    {
    }

    public void CreateChild()
    {
    }
  }
}
