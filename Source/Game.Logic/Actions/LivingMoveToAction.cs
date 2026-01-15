// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingMoveToAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;
using System.Collections.Generic;
using System.Drawing;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingMoveToAction : BaseAction
  {
    private Living living_0;
    private List<Point> list_0;
    private string string_0;
    private bool bool_0;
    private string string_1;
    private int int_0;
    private int int_1;
    private LivingCallBack livingCallBack_0;
    private int int_2;

    public LivingMoveToAction(
      Living living,
      List<Point> path,
      string action,
      int delay,
      int speed,
      string sAction,
      LivingCallBack callback,
      int delayCallback)
      : base(delay, 0)
    {
      this.living_0 = living;
      this.list_0 = path;
      this.string_0 = action;
      this.string_1 = sAction;
      this.bool_0 = false;
      this.int_0 = 0;
      this.livingCallBack_0 = callback;
      this.int_1 = speed;
      this.int_2 = delayCallback;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      if (!this.bool_0)
      {
        this.bool_0 = true;
        game.vAwYovJgkr(this.living_0, this.living_0.X, this.living_0.Y, this.list_0[this.list_0.Count - 1].X, this.list_0[this.list_0.Count - 1].Y, this.string_0, this.int_1, this.string_1);
      }
      ++this.int_0;
      if (this.int_0 < this.list_0.Count)
        return;
      Point point = this.list_0[this.int_0 - 1];
      this.living_0.Direction = point.X <= this.living_0.X ? -1 : 1;
      Living living0 = this.living_0;
      point = this.list_0[this.int_0 - 1];
      int x = point.X;
      point = this.list_0[this.int_0 - 1];
      int y = point.Y;
      living0.SetXY(x, y);
      if (this.livingCallBack_0 != null)
        this.living_0.CallFuction(this.livingCallBack_0, this.int_2);
      this.Finish(tick);
    }
  }
}
