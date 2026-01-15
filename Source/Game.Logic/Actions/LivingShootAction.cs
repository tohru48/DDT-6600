// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingShootAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingShootAction : BaseAction
  {
    private Living living_0;
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int tpgMvTuxup;
    private int int_5;
    private int int_6;
    private float float_0;

    public LivingShootAction(
      Living living,
      int bombId,
      int x,
      int y,
      int force,
      int angle,
      int bombCount,
      int minTime,
      int maxTime,
      float time,
      int delay)
      : base(delay, 1000)
    {
      this.living_0 = living;
      this.int_2 = bombId;
      this.int_0 = x;
      this.int_1 = y;
      this.int_3 = force;
      this.int_4 = angle;
      this.tpgMvTuxup = bombCount;
      this.int_2 = bombId;
      this.int_5 = minTime;
      this.int_6 = maxTime;
      this.float_0 = time;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      if (this.living_0 is SimpleBoss || this.living_0 is SimpleNpc)
        this.living_0.GetShootForceAndAngle(ref this.int_0, ref this.int_1, this.int_2, this.int_5, this.int_6, this.tpgMvTuxup, this.float_0, ref this.int_3, ref this.int_4);
      this.living_0.ShootImp(this.int_2, this.int_0, this.int_1, this.int_3, this.int_4, this.tpgMvTuxup, 0);
      this.Finish(tick);
    }
  }
}
