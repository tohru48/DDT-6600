// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.GiftInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Collections.Generic;

#nullable disable
namespace SqlDataProvider.Data
{
  public class GiftInfo : DataObject
  {
    private DateTime dateTime_0;
    private int int_0;
    private int int_1;
    private Dictionary<string, object> dictionary_0;
    private ItemTemplateInfo itemTemplateInfo_0;
    private int int_2;
    private int int_3;

    public DateTime AddDate
    {
      get => this.dateTime_0;
      set
      {
        if (this.dateTime_0 == value)
          return;
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public int Count
    {
      get => this.int_0;
      set
      {
        if (this.int_0 == value)
          return;
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public int ItemID
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }

    public Dictionary<string, object> TempInfo => this.dictionary_0;

    public ItemTemplateInfo Template => this.itemTemplateInfo_0;

    public int TemplateID
    {
      get => this.int_2;
      set
      {
        if (this.int_2 == value)
          return;
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int UserID
    {
      get => this.int_3;
      set
      {
        if (this.int_3 == value)
          return;
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    internal GiftInfo(ItemTemplateInfo template)
    {
      this.dictionary_0 = new Dictionary<string, object>();
      this.itemTemplateInfo_0 = template;
      if (this.itemTemplateInfo_0 != null)
        this.int_2 = this.itemTemplateInfo_0.TemplateID;
      if (this.dictionary_0 != null)
        return;
      this.dictionary_0 = new Dictionary<string, object>();
    }

    public bool CanStackedTo(GiftInfo to)
    {
      return this.int_2 == to.TemplateID && this.Template.MaxCount > 1;
    }

    public static GiftInfo CreateFromTemplate(ItemTemplateInfo template, int count)
    {
      GiftInfo fromTemplate = template != null ? new GiftInfo(template) : throw new ArgumentNullException(nameof (template));
      fromTemplate.TemplateID = template.TemplateID;
      fromTemplate.IsDirty = false;
      fromTemplate.AddDate = DateTime.Now;
      fromTemplate.Count = count;
      return fromTemplate;
    }

    public static GiftInfo CreateWithoutInit(ItemTemplateInfo template) => new GiftInfo(template);
  }
}
