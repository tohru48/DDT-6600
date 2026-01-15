// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingFallingAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingFallingAction : BaseAction
  {
    private Living living_0;
    private int int_0;
    private int int_1;
    private int int_2;
    private bool bool_0;
    private string string_0;
    private int int_3;
    private LivingCallBack livingCallBack_0;

    public LivingFallingAction(
      Living living,
      int toX,
      int toY,
      int speed,
      string action,
      int delay,
      int type,
      LivingCallBack callback)
      : base(delay, 2000)
    {
      this.living_0 = living;
      this.int_0 = speed;
      this.string_0 = action;
      this.int_1 = toX;
      this.int_2 = toY;
      this.bool_0 = false;
      this.int_3 = type;
      this.livingCallBack_0 = callback;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      if (!this.bool_0)
      {
        this.bool_0 = true;
        game.method_24(this.living_0, this.int_1, this.int_2, this.int_0, this.string_0, this.int_3);
      }
      if (this.int_2 > this.living_0.Y + this.int_0)
      {
        this.living_0.SetXY(this.int_1, this.living_0.Y + this.int_0);
      }
      else
      {
        this.living_0.SetXY(this.int_1, this.int_2);
        if (game.Map.IsOutMap(this.int_1, this.int_2))
        {
          this.living_0.SyncAtTime = false;
          this.living_0.Die();
        }
        if (this.livingCallBack_0 != null)
          this.living_0.CallFuction(this.livingCallBack_0, 0);
        this.Finish(tick);
      }
    }
  }
}
