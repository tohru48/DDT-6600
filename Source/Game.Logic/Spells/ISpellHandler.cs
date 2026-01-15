// Decompiled with JetBrains decompiler
// Type: Game.Logic.Spells.ISpellHandler
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

#nullable disable
namespace Game.Logic.Spells
{
  public interface ISpellHandler
  {
    void Execute(BaseGame game, Player player, ItemTemplateInfo item);
  }
}
