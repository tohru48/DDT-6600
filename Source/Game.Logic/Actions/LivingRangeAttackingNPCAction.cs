// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.LivingRangeAttackingNPCAction
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
  public class LivingRangeAttackingNPCAction : BaseAction
  {
    private Living living_0;
    private List<Living> list_0;
    private string string_0;

    public LivingRangeAttackingNPCAction(
      Living living,
      string action,
      int delay,
      List<Living> livings)
      : base(delay, 1000)
    {
      this.living_0 = living;
      this.list_0 = livings;
      this.string_0 = action;
    }

    private int method_0(Living living_1)
    {
      double baseDamage = this.living_0.BaseDamage;
      double baseGuard = living_1.BaseGuard;
      double defence = living_1.Defence;
      double attack = this.living_0.Attack;
      float currentDamagePlus = this.living_0.CurrentDamagePlus;
      float currentShootMinus = this.living_0.CurrentShootMinus;
      double num1 = 0.95 * (baseGuard - (double) (3 * this.living_0.Grade)) / (500.0 + baseGuard - (double) (3 * this.living_0.Grade));
      double num2 = defence - this.living_0.Lucky >= 0.0 ? 0.95 * (defence - this.living_0.Lucky) / (600.0 + defence - this.living_0.Lucky) : 0.0;
      double num3 = baseDamage * (1.0 + attack * 0.001) * (1.0 - (num1 + num2 - num1 * num2)) * (double) currentDamagePlus * (double) currentShootMinus;
      Rectangle directDemageRect = living_1.GetDirectDemageRect();
      Math.Sqrt((double) ((directDemageRect.X - this.living_0.X) * (directDemageRect.X - this.living_0.X) + (directDemageRect.Y - this.living_0.Y) * (directDemageRect.Y - this.living_0.Y)));
      return num3 < 0.0 ? 1 : (int) num3;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      GSPacketIn pkg = new GSPacketIn((short) 91, this.living_0.Id);
      pkg.Parameter1 = this.living_0.Id;
      pkg.WriteByte((byte) 61);
      int count = this.list_0.Count;
      pkg.WriteInt(count);
      foreach (Living living in this.list_0)
      {
        if (living is SimpleNpc && this.string_0 != "movie")
          game.method_27(living, this.string_0);
        int damageAmount = this.method_0(living);
        int criticalAmount = 0;
        int val = 0;
        if (living.TakeDamage(this.living_0, ref damageAmount, ref criticalAmount, "范围攻击"))
          val = damageAmount + criticalAmount;
        pkg.WriteInt(living.Id);
        pkg.WriteInt(val);
        pkg.WriteInt(living.Blood);
        pkg.WriteInt(0);
        pkg.WriteInt(1);
      }
      game.SendToAll(pkg);
      this.Finish(tick);
    }
  }
}
