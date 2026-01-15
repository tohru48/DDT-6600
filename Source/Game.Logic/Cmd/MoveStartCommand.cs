// Decompiled with JetBrains decompiler
// Type: Game.Logic.Cmd.MoveStartCommand
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Cmd
{
  [GameCommand(9, "开始移动")]
  public class MoveStartCommand : ICommandHandler
  {
    public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
    {
      if (!player.IsAttacking)
        return;
      packet.ReadBoolean();
      byte int_4 = packet.ReadByte();
      int num1 = packet.ReadInt();
      int num2 = packet.ReadInt();
      byte byte_0 = packet.ReadByte();
      bool bool_0 = packet.ReadBoolean();
      int num3 = (int) packet.ReadShort();
      int turnIndex = game.TurnIndex;
      game.method_22(player, (int) int_4, num1, num2, byte_0);
      switch (int_4)
      {
        case 0:
        case 1:
          player.SetXY(num1, num2);
          player.StartFalling(true);
          if (player.Y - num2 > 1 || player.IsLiving != bool_0)
            game.method_21(player, 3, player.X, player.Y, byte_0, bool_0);
          break;
      }
    }
  }
}
