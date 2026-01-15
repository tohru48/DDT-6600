// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.UsersPetinfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System.Collections.Generic;

#nullable disable
namespace SqlDataProvider.Data
{
  public class UsersPetinfo : DataObject
  {
    private string string_0;
    private string string_1;
    private int int_0;
    private int int_1;
    private int int_2;
    private string string_2;
    private int int_3;
    private int int_4;
    private int int_5;
    private int int_6;
    private int hYldFqboy8;
    private int int_7;
    private int int_8;
    private int int_9;
    private int int_10;
    private int int_11;
    private int int_12;
    private int LtGdmiqDsw;
    private int int_13;
    private int int_14;
    private int int_15;
    private int int_16;
    private int int_17;
    private int int_18;
    private int int_19;
    private int int_20;
    private bool bool_0;
    private int int_21;
    private int int_22;
    private bool bool_1;
    private List<ItemInfo> list_0;

    public string SkillEquip
    {
      get => this.string_0;
      set
      {
        this.string_0 = value;
        this._isDirty = true;
      }
    }

    public string Skill
    {
      get => this.string_1;
      set
      {
        this.string_1 = value;
        this._isDirty = true;
      }
    }

    public int ID
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public int PetID
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }

    public int TemplateID
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public string Name
    {
      get => this.string_2;
      set
      {
        this.string_2 = value;
        this._isDirty = true;
      }
    }

    public int UserID
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public int Attack
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public int Defence
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public int Luck
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public int Agility
    {
      get => this.hYldFqboy8;
      set
      {
        this.hYldFqboy8 = value;
        this._isDirty = true;
      }
    }

    public int Blood
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public int Damage
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public int Guard
    {
      get => this.int_9;
      set
      {
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public int AttackGrow
    {
      get => this.int_10;
      set
      {
        this.int_10 = value;
        this._isDirty = true;
      }
    }

    public int DefenceGrow
    {
      get => this.int_11;
      set
      {
        this.int_11 = value;
        this._isDirty = true;
      }
    }

    public int LuckGrow
    {
      get => this.int_12;
      set
      {
        this.int_12 = value;
        this._isDirty = true;
      }
    }

    public int AgilityGrow
    {
      get => this.LtGdmiqDsw;
      set
      {
        this.LtGdmiqDsw = value;
        this._isDirty = true;
      }
    }

    public int BloodGrow
    {
      get => this.int_13;
      set
      {
        this.int_13 = value;
        this._isDirty = true;
      }
    }

    public int DamageGrow
    {
      get => this.int_14;
      set
      {
        this.int_14 = value;
        this._isDirty = true;
      }
    }

    public int GuardGrow
    {
      get => this.int_15;
      set
      {
        this.int_15 = value;
        this._isDirty = true;
      }
    }

    public int Level
    {
      get => this.int_16;
      set
      {
        this.int_16 = value;
        this._isDirty = true;
      }
    }

    public int GP
    {
      get => this.int_17;
      set
      {
        this.int_17 = value;
        this._isDirty = true;
      }
    }

    public int MaxGP
    {
      get => this.int_18;
      set
      {
        this.int_18 = value;
        this._isDirty = true;
      }
    }

    public int Hunger
    {
      get => this.int_19;
      set
      {
        this.int_19 = value;
        this._isDirty = true;
      }
    }

    public int PetHappyStar => this.method_0();

    public int MP
    {
      get => this.int_20;
      set
      {
        this.int_20 = value;
        this._isDirty = true;
      }
    }

    public bool IsEquip
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public int Place
    {
      get => this.int_21;
      set
      {
        this.int_21 = value;
        this._isDirty = true;
      }
    }

    public int currentStarExp
    {
      get => this.int_22;
      set
      {
        this.int_22 = value;
        this._isDirty = true;
      }
    }

    public bool IsExit
    {
      get => this.bool_1;
      set
      {
        this.bool_1 = value;
        this._isDirty = true;
      }
    }

    public List<ItemInfo> PetEquip
    {
      get => this.list_0;
      set => this.list_0 = value;
    }

    public int TotalAttack
    {
      get
      {
        int num = 0;
        int index = 0;
        if (this.list_0 != null)
        {
          for (; index < this.list_0.Count; ++index)
          {
            ItemTemplateInfo template = this.list_0[index].Template;
            if (template != null)
              num += template.Attack;
          }
        }
        return this.int_4 - this.method_1(this.int_4) + num;
      }
    }

    public int TotalDefence
    {
      get
      {
        int num = 0;
        int index = 0;
        if (this.list_0 != null)
        {
          for (; index < this.list_0.Count; ++index)
          {
            ItemTemplateInfo template = this.list_0[index].Template;
            if (template != null)
              num += template.Defence;
          }
        }
        return this.int_5 - this.method_1(this.int_5) + num;
      }
    }

    public int TotalLuck
    {
      get
      {
        int num = 0;
        int index = 0;
        if (this.list_0 != null)
        {
          for (; index < this.list_0.Count; ++index)
          {
            ItemTemplateInfo template = this.list_0[index].Template;
            if (template != null)
              num += template.Luck;
          }
        }
        return this.int_6 - this.method_1(this.int_6) + num;
      }
    }

    public int TotalAgility
    {
      get
      {
        int num = 0;
        int index = 0;
        if (this.list_0 != null)
        {
          for (; index < this.list_0.Count; ++index)
          {
            ItemTemplateInfo template = this.list_0[index].Template;
            if (template != null)
              num += template.Agility;
          }
        }
        return this.hYldFqboy8 - this.method_1(this.hYldFqboy8) + num;
      }
    }

    public int TotalBlood => this.int_7 - this.method_1(this.int_7);

    public int TotalDamage => this.int_8 - this.method_1(this.int_8);

    public int TotalGuard => this.int_9 - this.method_1(this.int_9);

    public List<string> GetSkill()
    {
      List<string> skill = new List<string>();
      string string1 = this.string_1;
      char[] chArray = new char[1]{ '|' };
      foreach (string str in string1.Split(chArray))
        skill.Add(str);
      return skill;
    }

    public List<string> GetSkillEquip()
    {
      List<string> skillEquip = new List<string>();
      string string0 = this.string_0;
      char[] chArray = new char[1]{ '|' };
      foreach (string str in string0.Split(chArray))
        skillEquip.Add(str);
      return skillEquip;
    }

    private int method_0()
    {
      double num1 = (double) this.int_19 / 10000.0 * 100.0;
      int num2 = 0;
      if (num1 >= 80.0)
        num2 = 3;
      if (num1 < 80.0 && num1 >= 60.0)
        num2 = 2;
      if (num1 < 60.0 && num1 > 0.0)
        num2 = 1;
      return num2;
    }

    private int method_1(int int_23)
    {
      if (this.method_0() == 2)
        return int_23 * 20 / 100;
      return this.method_0() == 1 ? int_23 * 40 / 100 : 0;
    }
  }
}
