// Decompiled with JetBrains decompiler
// Type: Game.Logic.Cmd.GameCommandAttribute
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using System;

#nullable disable
namespace Game.Logic.Cmd
{
  public class GameCommandAttribute : Attribute
  {
    private int int_0;
    private string string_0;

    public int Code => this.int_0;

    public string Description => this.string_0;

    public GameCommandAttribute(int code, string description)
    {
      this.int_0 = code;
      this.string_0 = description;
    }
  }
}
