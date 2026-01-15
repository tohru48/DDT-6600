// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.PhysicalObj
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Actions;
using System.Collections.Generic;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class PhysicalObj : Physics
  {
    private string string_0;
    private string string_1;
    private int int_0;
    private int int_1;
    private BaseGame baseGame_0;
    private bool bool_0;
    private int int_2;
    private string string_2;
    private int int_3;
    private int int_4;
    private Dictionary<string, string> dictionary_0;

    public virtual int phyBringToFront => this.int_3;

    public virtual int Type => this.int_2;

    public int typeEffect => this.int_4;

    public string Model => this.string_0;

    public Dictionary<string, string> ActionMapping => this.dictionary_0;

    public string CurrentAction
    {
      get => this.string_1;
      set => this.string_1 = value;
    }

    public int Scale => this.int_0;

    public int Rotation => this.int_1;

    public bool CanPenetrate
    {
      get => this.bool_0;
      set => this.bool_0 = value;
    }

    public string Name => this.string_2;

    public PhysicalObj(
      int id,
      string name,
      string model,
      string defaultAction,
      int scale,
      int rotation)
      : base(id)
    {
      this.string_2 = name;
      this.string_0 = model;
      this.string_1 = defaultAction;
      this.int_0 = scale;
      this.int_1 = rotation;
      this.bool_0 = false;
      this.int_4 = 0;
      switch (name)
      {
        case "hide":
          this.int_3 = 6;
          break;
        case "top":
          this.int_3 = 1;
          break;
        default:
          this.int_3 = -1;
          break;
      }
      this.dictionary_0 = new Dictionary<string, string>();
      switch (model)
      {
        case "asset.game.transmitted":
          this.int_2 = 3;
          break;
        case "asset.game.six.ball":
          if (!this.dictionary_0.ContainsKey(defaultAction))
          {
            this.dictionary_0.Add(defaultAction, this.method_0(defaultAction));
            break;
          }
          break;
        default:
          this.int_2 = 0;
          break;
      }
    }

    private string method_0(string string_3)
    {
      switch (string_3)
      {
        case "s1":
          return "shield1";
        case "s2":
          return "shield2";
        case "s3":
          return "shield3";
        case "s4":
          return "shield4";
        case "s5":
          return "shield5";
        case "s6":
          return "shield6";
        case "s-1":
          return "shield-1";
        case "s-2":
          return "shield-2";
        case "s-3":
          return "shield-3";
        case "s-4":
          return "shield-4";
        case "s-5":
          return "shield-5";
        case "s-6":
          return "shield-6";
        case "double":
          return "shield-double";
        default:
          return string_3;
      }
    }

    public void SetGame(BaseGame game) => this.baseGame_0 = game;

    public void PlayMovie(string action, int delay, int movieTime)
    {
      if (this.baseGame_0 == null)
        return;
      this.baseGame_0.AddAction((IAction) new PhysicalObjDoAction(this, action, delay, movieTime));
    }

    public override void CollidedByObject(Physics phy)
    {
      if (this.bool_0 || !(phy is SimpleBomb))
        return;
      ((SimpleBomb) phy).Bomb();
    }
  }
}
