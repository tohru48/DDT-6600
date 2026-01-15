// Decompiled with JetBrains decompiler
// Type: Game.Logic.Cmd.PropUseCommand
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;
using System.Linq;

#nullable disable
namespace Game.Logic.Cmd
{
  [GameCommand(32, "使用道具")]
  public class PropUseCommand : ICommandHandler
  {
    public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
    {
      if (game.GameState != eGameState.Playing || player.GetSealState())
        return;
      int bag = (int) packet.ReadByte();
      int place = packet.ReadInt();
      int templateId = packet.ReadInt();
      ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(templateId);
      if (bag == 3 && player.PlayerDetail.PlayerCharacter.IsAutoBot)
      {
        player.UseItem(itemTemplate);
        switch (templateId)
        {
          case 10001:
            if (player.Prop >= templateId * 2)
              break;
            player.Prop += templateId;
            break;
          case 10004:
            if (player.Prop >= templateId * 2)
              break;
            player.Prop += templateId;
            break;
        }
      }
      else
      {
        int[] source = new int[8]
        {
          10001,
          10002,
          10003,
          10004,
          10005,
          10006,
          10007,
          10008
        };
        if (player.CanUseItem(itemTemplate))
        {
          if (player.PlayerDetail.UsePropItem((AbstractGame) game, bag, place, templateId, player.IsLiving))
          {
            if (!player.UseItem(itemTemplate))
              BaseGame.log.Error((object) "Using prop error");
          }
          else if (bag == 1 && ((IEnumerable<int>) source).Contains<int>(templateId))
          {
            player.UseItem(itemTemplate);
            switch (templateId)
            {
              case 10001:
                if (player.Prop < templateId * 2)
                {
                  player.Prop += templateId;
                  break;
                }
                break;
              case 10004:
                if (player.Prop < templateId * 2)
                {
                  player.Prop += templateId;
                  break;
                }
                break;
            }
          }
        }
      }
    }
  }
}
