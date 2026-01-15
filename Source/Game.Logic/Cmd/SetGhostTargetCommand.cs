// Decompiled with JetBrains decompiler
// Type: Game.Logic.Cmd.SetGhostTargetCommand
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Cmd
{
  [GameCommand(54, "设置鬼魂目标")]
  public class SetGhostTargetCommand : ICommandHandler
  {
    public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
    {
      if (player.IsLiving)
        return;
      player.TargetPoint.X = packet.ReadInt();
      player.TargetPoint.Y = packet.ReadInt();
    }
  }
}
