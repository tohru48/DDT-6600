// Decompiled with JetBrains decompiler
// Type: Game.Logic.Cmd.FireCommand
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Cmd
{
  [GameCommand(2, "用户开炮")]
  public class FireCommand : ICommandHandler
  {
    public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
    {
      if (!player.IsAttacking)
        return;
      int x = packet.ReadInt();
      int y = packet.ReadInt();
      if (player.CheckShootPoint(x, y))
      {
        int force = packet.ReadInt();
        int angle = packet.ReadInt();
        player.Shoot(x, y, force, angle);
      }
    }
  }
}
