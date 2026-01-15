// Decompiled with JetBrains decompiler
// Type: Bussiness.CenterService.ServerData
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.Serialization;
using System.Threading;

#nullable disable
namespace Bussiness.CenterService
{
  [GeneratedCode("System.Runtime.Serialization", "4.0.0.0")]
  [DataContract(Name = "ServerData", Namespace = "http://schemas.datacontract.org/2004/07/Center.Server")]
  [DebuggerStepThrough]
  [Serializable]
  public class ServerData : IExtensibleDataObject, INotifyPropertyChanged
  {
    [NonSerialized]
    private ExtensionDataObject extensionDataObject_0;
    [OptionalField]
    private int int_0;
    [OptionalField]
    private string string_0;
    [OptionalField]
    private int int_1;
    [OptionalField]
    private int int_2;
    [OptionalField]
    private string string_1;
    [OptionalField]
    private int int_3;
    [OptionalField]
    private int int_4;
    [OptionalField]
    private int int_5;
    [OptionalField]
    private int int_6;
    private PropertyChangedEventHandler propertyChangedEventHandler_0;

    public event PropertyChangedEventHandler PropertyChanged
    {
      add
      {
        PropertyChangedEventHandler changedEventHandler = this.propertyChangedEventHandler_0;
        PropertyChangedEventHandler comparand;
        do
        {
          comparand = changedEventHandler;
          changedEventHandler = Interlocked.CompareExchange<PropertyChangedEventHandler>(ref this.propertyChangedEventHandler_0, comparand + value, comparand);
        }
        while (changedEventHandler != comparand);
      }
      remove
      {
        PropertyChangedEventHandler changedEventHandler = this.propertyChangedEventHandler_0;
        PropertyChangedEventHandler comparand;
        do
        {
          comparand = changedEventHandler;
          changedEventHandler = Interlocked.CompareExchange<PropertyChangedEventHandler>(ref this.propertyChangedEventHandler_0, comparand - value, comparand);
        }
        while (changedEventHandler != comparand);
      }
    }

    [Browsable(false)]
    public ExtensionDataObject ExtensionData
    {
      get => this.extensionDataObject_0;
      set => this.extensionDataObject_0 = value;
    }

    [DataMember]
    public int Id
    {
      get => this.int_0;
      set
      {
        if (this.int_0.Equals(value))
          return;
        this.int_0 = value;
        this.RaisePropertyChanged(nameof (Id));
      }
    }

    [DataMember]
    public string Ip
    {
      get => this.string_0;
      set
      {
        if (object.ReferenceEquals((object) this.string_0, (object) value))
          return;
        this.string_0 = value;
        this.RaisePropertyChanged(nameof (Ip));
      }
    }

    [DataMember]
    public int LowestLevel
    {
      get => this.int_1;
      set
      {
        if (this.int_1.Equals(value))
          return;
        this.int_1 = value;
        this.RaisePropertyChanged(nameof (LowestLevel));
      }
    }

    [DataMember]
    public int MustLevel
    {
      get => this.int_2;
      set
      {
        if (this.int_2.Equals(value))
          return;
        this.int_2 = value;
        this.RaisePropertyChanged(nameof (MustLevel));
      }
    }

    [DataMember]
    public string Name
    {
      get => this.string_1;
      set
      {
        if (object.ReferenceEquals((object) this.string_1, (object) value))
          return;
        this.string_1 = value;
        this.RaisePropertyChanged(nameof (Name));
      }
    }

    [DataMember]
    public int Online
    {
      get => this.int_3;
      set
      {
        if (this.int_3.Equals(value))
          return;
        this.int_3 = value;
        this.RaisePropertyChanged(nameof (Online));
      }
    }

    [DataMember]
    public int Port
    {
      get => this.int_4;
      set
      {
        if (this.int_4.Equals(value))
          return;
        this.int_4 = value;
        this.RaisePropertyChanged(nameof (Port));
      }
    }

    [DataMember]
    public int State
    {
      get => this.int_5;
      set
      {
        if (this.int_5.Equals(value))
          return;
        this.int_5 = value;
        this.RaisePropertyChanged(nameof (State));
      }
    }

    [DataMember]
    public int Total
    {
      get => this.int_6;
      set
      {
        if (this.int_6.Equals(value))
          return;
        this.int_6 = value;
        this.RaisePropertyChanged(nameof (Total));
      }
    }

    protected void RaisePropertyChanged(string propertyName)
    {
      PropertyChangedEventHandler changedEventHandler0 = this.propertyChangedEventHandler_0;
      if (changedEventHandler0 == null)
        return;
      changedEventHandler0((object) this, new PropertyChangedEventArgs(propertyName));
    }
  }
}
