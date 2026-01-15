// Decompiled with JetBrains decompiler
// Type: Game.Logic.Cmd.TakeCardCommand
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Cmd
{
  [GameCommand(98, "翻牌")]
  public class TakeCardCommand : ICommandHandler
  {
    public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
    {
      int index = (int) packet.ReadByte();
      if (index >= 0 && index <= game.Cards.Length)
        game.TakeCard(player, index);
      else
        game.TakeCard(player);
    }
  }
}
