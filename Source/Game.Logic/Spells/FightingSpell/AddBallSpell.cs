// Decompiled with JetBrains decompiler
// Type: Game.Logic.Spells.FightingSpell.AddBallSpell
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

#nullable disable
namespace Game.Logic.Spells.FightingSpell
{
  [SpellAttibute(15)]
  public class AddBallSpell : ISpellHandler
  {
    public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
    {
      if (player.IsSpecialSkill)
        return;
      if (!player.IsLiving)
      {
        if (game.CurrentLiving == null || !(game.CurrentLiving is Player) || game.CurrentLiving.Team != player.Team)
          return;
        if (((game.CurrentLiving as Player).CurrentBall.ID == 3 || (game.CurrentLiving as Player).CurrentBall.ID == 5 || (game.CurrentLiving as Player).CurrentBall.ID == 1) && item.TemplateID == 10003)
        {
          (game.CurrentLiving as Player).BallCount = 1;
        }
        else
        {
          game.CurrentLiving.CurrentDamagePlus *= 0.5f;
          (game.CurrentLiving as Player).BallCount = item.Property2;
        }
      }
      else if ((player.CurrentBall.ID == 3 || player.CurrentBall.ID == 5 || player.CurrentBall.ID == 1) && item.TemplateID == 10003)
      {
        player.BallCount = 1;
      }
      else
      {
        player.CurrentDamagePlus *= 0.5f;
        player.BallCount = item.Property2;
      }
    }
  }
}
