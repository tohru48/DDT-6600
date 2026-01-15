// Decompiled with JetBrains decompiler
// Type: Game.Logic.TickHelper
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using System.Diagnostics;

#nullable disable
namespace Game.Logic
{
  public static class TickHelper
  {
    private static long long_0 = Stopwatch.Frequency / 1000L;

    public static long GetTickCount() => Stopwatch.GetTimestamp() / TickHelper.long_0;
  }
}
