// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.WaitLivingAttackingAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class WaitLivingAttackingAction : BaseAction
  {
    private TurnedLiving turnedLiving_0;
    private int int_0;

    public WaitLivingAttackingAction(TurnedLiving living, int turnIndex, int delay)
      : base(delay)
    {
      this.turnedLiving_0 = living;
      this.int_0 = turnIndex;
      living.EndAttacking += new LivingEventHandle(this.method_0);
    }

    private void method_0(Living living_0)
    {
      living_0.EndAttacking -= new LivingEventHandle(this.method_0);
      this.Finish(TickHelper.GetTickCount());
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      this.Finish(tick);
      if (game.TurnIndex != this.int_0 || !this.turnedLiving_0.IsAttacking)
        return;
      this.turnedLiving_0.StopAttacking();
      game.method_6((Living) this.turnedLiving_0, 0);
      game.CheckState(0);
    }
  }
}
