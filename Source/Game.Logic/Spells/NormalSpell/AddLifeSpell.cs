// Decompiled with JetBrains decompiler
// Type: Game.Logic.Spells.NormalSpell.AddLifeSpell
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

#nullable disable
namespace Game.Logic.Spells.NormalSpell
{
  [SpellAttibute(1)]
  public class AddLifeSpell : ISpellHandler
  {
    public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
    {
      switch (item.Property2)
      {
        case 0:
          int property3 = item.Property3;
          if (player.IsLiving)
          {
            if (player.FightBuffers.ConsortionAddSpellCount > 0)
              property3 += player.FightBuffers.ConsortionAddSpellCount;
            player.AddBlood(property3);
            break;
          }
          if (game.CurrentLiving == null || !(game.CurrentLiving is Player) || game.CurrentLiving.Team != player.Team)
            break;
          game.CurrentLiving.AddBlood(property3);
          break;
        case 1:
          using (List<Player>.Enumerator enumerator = player.Game.GetAllFightPlayers().GetEnumerator())
          {
            while (enumerator.MoveNext())
            {
              Player current = enumerator.Current;
              if (current.IsLiving && current.Team == player.Team)
                current.AddBlood(item.Property3);
            }
            break;
          }
      }
    }
  }
}
