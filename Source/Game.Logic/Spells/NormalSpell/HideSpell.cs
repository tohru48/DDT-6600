// Decompiled with JetBrains decompiler
// Type: Game.Logic.Spells.NormalSpell.HideSpell
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

#nullable disable
namespace Game.Logic.Spells.NormalSpell
{
  [SpellAttibute(3)]
  public class HideSpell : ISpellHandler
  {
    public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
    {
      switch (item.Property2)
      {
        case 0:
          if (player.IsLiving)
          {
            new HideEffect(item.Property3).Start((Living) player);
            break;
          }
          if (game.CurrentLiving == null || !(game.CurrentLiving is Player) || game.CurrentLiving.Team != player.Team)
            break;
          new HideEffect(item.Property3).Start((Living) game.CurrentLiving);
          break;
        case 1:
          using (List<Player>.Enumerator enumerator = player.Game.GetAllFightPlayers().GetEnumerator())
          {
            while (enumerator.MoveNext())
            {
              Player current = enumerator.Current;
              if (current.IsLiving && current.Team == player.Team)
                new HideEffect(item.Property3).Start((Living) current);
            }
            break;
          }
      }
    }
  }
}
