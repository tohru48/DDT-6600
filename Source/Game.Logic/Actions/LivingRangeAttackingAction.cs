// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingRangeAttackingAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;
using System.Drawing;

#nullable disable
namespace Game.Logic.Actions
{
  public class LivingRangeAttackingAction : BaseAction
  {
    private Living living_0;
    private List<Player> list_0;
    private int int_0;
    private int int_1;
    private string string_0;

    public LivingRangeAttackingAction(
      Living living,
      int fx,
      int tx,
      string action,
      int delay,
      List<Player> players)
      : base(delay, 1000)
    {
      this.living_0 = living;
      this.list_0 = players;
      this.int_0 = fx;
      this.int_1 = tx;
      this.string_0 = action;
    }

    private int method_0(Living living_1)
    {
      double baseDamage = this.living_0.BaseDamage;
      double num1 = living_1.BaseGuard;
      double num2 = living_1.Defence + living_1.MagicDefence;
      double num3 = this.living_0.Attack + this.living_0.MagicAttack;
      if (living_1.AddArmor && (living_1 as Player).DeputyWeapon != null)
      {
        int num4 = (living_1 as Player).DeputyWeapon.Template.Property7 + (int) Math.Pow(1.1, (double) (living_1 as Player).DeputyWeapon.StrengthenLevel);
        num1 += (double) num4;
        num2 += (double) num4;
      }
      if (this.living_0.IgnoreArmor)
      {
        num1 = 0.0;
        num2 = 0.0;
      }
      float currentDamagePlus = this.living_0.CurrentDamagePlus;
      float currentShootMinus = this.living_0.CurrentShootMinus;
      double num5 = 0.95 * (num1 - (double) (3 * this.living_0.Grade)) / (500.0 + num1 - (double) (3 * this.living_0.Grade));
      double num6 = num2 - this.living_0.Lucky >= 0.0 ? 0.95 * (num2 - this.living_0.Lucky) / (600.0 + num2 - this.living_0.Lucky) : 0.0;
      double num7 = baseDamage * (1.0 + num3 * 0.001) * (1.0 - (num5 + num6 - num5 * num6)) * (double) currentDamagePlus * (double) currentShootMinus;
      Rectangle directDemageRect = living_1.GetDirectDemageRect();
      double num8 = Math.Sqrt((double) ((directDemageRect.X - this.living_0.X) * (directDemageRect.X - this.living_0.X) + (directDemageRect.Y - this.living_0.Y) * (directDemageRect.Y - this.living_0.Y)));
      double num9 = num7 * (1.0 - num8 / (double) Math.Abs(this.int_1 - this.int_0) / 4.0);
      return num9 < 0.0 ? 1 : (int) num9;
    }

    private int method_1(Living living_1, int int_2)
    {
      double lucky = this.living_0.Lucky;
      Random random = new Random();
      if (75000.0 * lucky / (lucky + 800.0) <= (double) random.Next(100000))
        return 0;
      int num = living_1.ReduceCritFisrtGem + living_1.ReduceCritSecondGem;
      return (int) ((0.5 + lucky * 0.0003) * (double) int_2) * (100 - num) / 100;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, this.living_0.Id);
      pkg.Parameter1 = this.living_0.Id;
      pkg.WriteByte((byte) 61);
      List<Living> players = game.Map.FindPlayers(this.int_0, this.int_1, this.list_0);
      int count = players.Count;
      foreach (Living living in players)
      {
        if (this.living_0.IsFriendly(living))
          --count;
      }
      pkg.WriteInt(count);
      this.living_0.SyncAtTime = false;
      try
      {
        foreach (Living living in players)
        {
          living.SyncAtTime = false;
          if (!this.living_0.IsFriendly(living))
          {
            int val1 = 0;
            living.IsFrost = false;
            living.IsHide = false;
            game.method_30(living);
            game.method_32(living);
            int damageAmount = this.method_0(living);
            int criticalAmount = this.method_1(living, damageAmount);
            int val2 = 0;
            if (living.TakeDamage(this.living_0, ref damageAmount, ref criticalAmount, "范围攻击"))
            {
              val2 = damageAmount + criticalAmount;
              if (living is Player)
                val1 = (living as Player).Dander;
            }
            pkg.WriteInt(living.Id);
            pkg.WriteInt(val2);
            pkg.WriteInt(living.Blood);
            pkg.WriteInt(val1);
            pkg.WriteInt(1);
          }
        }
        game.SendToAll(pkg);
        this.Finish(tick);
      }
      finally
      {
        this.living_0.SyncAtTime = true;
        foreach (Living living in players)
          living.SyncAtTime = true;
      }
    }
  }
}
