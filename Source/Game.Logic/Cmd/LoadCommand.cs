// Decompiled with JetBrains decompiler
// Type: Game.Logic.Cmd.LoadCommand
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Cmd
{
  [GameCommand(16, "游戏加载进度")]
  public class LoadCommand : ICommandHandler
  {
    public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
    {
      if (game.GameState != eGameState.Loading)
        return;
      player.LoadingProcess = packet.ReadInt();
      if (player.LoadingProcess >= 100)
        game.CheckState(0);
      GSPacketIn pkg = new GSPacketIn((short) 91);
      pkg.WriteByte((byte) 16);
      pkg.WriteInt(player.LoadingProcess);
      pkg.WriteInt(player.PlayerDetail.ZoneId);
      pkg.WriteInt(player.PlayerDetail.PlayerCharacter.ID);
      game.SendToAll(pkg);
    }
  }
}
