// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.RemovePlayerAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class RemovePlayerAction : IAction
  {
    private bool bool_0;
    private Player player_0;

    public RemovePlayerAction(Player player)
    {
      this.player_0 = player;
      this.bool_0 = false;
    }

    public void Execute(BaseGame game, long tick)
    {
      this.player_0.DeadLink();
      this.bool_0 = true;
    }

    public bool IsFinished(long tick) => this.bool_0;
  }
}
