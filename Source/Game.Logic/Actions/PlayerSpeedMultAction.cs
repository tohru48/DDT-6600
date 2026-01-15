// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.PlayerSpeedMultAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Maths;
using Game.Logic.Phy.Object;
using System.Drawing;

#nullable disable
namespace Game.Logic.Actions
{
  public class PlayerSpeedMultAction : BaseAction
  {
    private Point point_0;
    private Player player_0;
    private Point point_1;
    private bool bool_0;

    public PlayerSpeedMultAction(Player player, Point target, int delay)
      : base(0, delay)
    {
      this.player_0 = player;
      this.point_0 = target;
      this.point_1 = new Point(target.X - this.player_0.X, target.Y - this.player_0.Y);
      this.point_1.Normalize(20);
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      if (!this.bool_0)
      {
        this.bool_0 = true;
        this.player_0.SpeedMultX(18);
        game.method_21(this.player_0, 4, this.point_0.X, this.point_0.Y, this.point_1.X > 0 ? (byte) 1 : byte.MaxValue, this.player_0.IsLiving);
      }
      if (this.point_0.Distance(this.player_0.X, this.player_0.Y) > 20.0)
      {
        this.player_0.SetXY(this.player_0.X + this.point_1.X, this.player_0.Y + this.point_1.Y);
      }
      else
      {
        this.player_0.SetXY(this.point_0.X, this.point_0.Y);
        this.Finish(tick);
      }
    }
  }
}
