// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingRotateTurnAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingRotateTurnAction : BaseAction
  {
    private Player player_0;
    private int int_0;
    private int int_1;
    private string string_0;

    public LivingRotateTurnAction(
      Player player,
      int rotation,
      int speed,
      string endPlay,
      int delay)
      : base(0, delay)
    {
      this.player_0 = player;
      this.int_0 = rotation;
      this.int_1 = speed;
      this.string_0 = endPlay;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      game.method_37(this.player_0, this.int_0, this.int_1, this.string_0);
      this.Finish(tick);
    }
  }
}
