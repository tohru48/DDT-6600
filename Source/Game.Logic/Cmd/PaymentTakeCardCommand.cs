// Decompiled with JetBrains decompiler
// Type: Game.Logic.Cmd.PaymentTakeCardCommand
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Cmd
{
  [GameCommand(114, "付费翻牌")]
  public class PaymentTakeCardCommand : ICommandHandler
  {
    public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
    {
      if (player.HasPaymentTakeCard)
        return;
      if (player.PlayerDetail.RemoveMoney(500) > 0)
      {
        int index = (int) packet.ReadByte();
        ++player.CanTakeOut;
        player.FinishTakeCard = false;
        player.HasPaymentTakeCard = true;
        player.PlayerDetail.LogAddMoney(AddMoneyType.Game, AddMoneyType.Game_PaymentTakeCard, player.PlayerDetail.PlayerCharacter.ID, 100, player.PlayerDetail.PlayerCharacter.Money);
        if (index >= 0 && index <= game.Cards.Length)
          game.TakeCard(player, index);
        else
          game.TakeCard(player);
      }
      else
        player.PlayerDetail.SendInsufficientMoney(1);
    }
  }
}
