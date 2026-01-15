// Decompiled with JetBrains decompiler
// Type: Class8
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using Game.Logic.Spells;
using SqlDataProvider.Data;

#nullable disable
[SpellAttibute(30)]
internal class Class8 : ISpellHandler
{
  public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
  {
    if (player.IsLiving)
    {
      new SealEffect(item.Property3).Start((Living) player);
    }
    else
    {
      if (game.CurrentLiving == null || !(game.CurrentLiving is Player) || game.CurrentLiving.Team != player.Team)
        return;
      new SealEffect(item.Property3).Start((Living) game.CurrentLiving);
    }
  }
}
