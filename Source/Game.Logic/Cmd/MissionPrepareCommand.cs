// Decompiled with JetBrains decompiler
// Type: Game.Logic.Cmd.MissionPrepareCommand
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Cmd
{
  [GameCommand(116, "关卡准备")]
  public class MissionPrepareCommand : ICommandHandler
  {
    public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
    {
      if (game.GameState != eGameState.SessionPrepared && game.GameState != eGameState.GameOver)
        return;
      bool flag = packet.ReadBoolean();
      if (player.Ready != flag)
      {
        player.Ready = flag;
        game.SendToAll(packet);
      }
    }
  }
}
