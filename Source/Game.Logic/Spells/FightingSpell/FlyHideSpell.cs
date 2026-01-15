// Decompiled with JetBrains decompiler
// Type: Game.Logic.Spells.FightingSpell.FlyHideSpell
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

#nullable disable
namespace Game.Logic.Spells.FightingSpell
{
  [SpellAttibute(80)]
  public class FlyHideSpell : ISpellHandler
  {
    public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
    {
      if (player.IsLiving)
      {
        new HideEffect(item.Property3).Start((Living) player);
        player.SetBall(3);
      }
      else
      {
        if (game.CurrentLiving == null || !(game.CurrentLiving is Player) || game.CurrentLiving.Team != player.Team)
          return;
        new HideEffect(item.Property3).Start((Living) game.CurrentLiving);
        (game.CurrentLiving as Player).SetBall(3);
      }
    }
  }
}
