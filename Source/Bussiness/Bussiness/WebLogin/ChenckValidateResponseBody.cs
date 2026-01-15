// Decompiled with JetBrains decompiler
// Type: Bussiness.WebLogin.ChenckValidateResponseBody
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.Serialization;

#nullable disable
namespace Bussiness.WebLogin
{
  [DataContract(Namespace = "dandantang")]
  [EditorBrowsable(EditorBrowsableState.Advanced)]
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [DebuggerStepThrough]
  public class ChenckValidateResponseBody
  {
    [DataMember(EmitDefaultValue = false, Order = 0)]
    public string ChenckValidateResult;

    public ChenckValidateResponseBody()
    {
    }

    public ChenckValidateResponseBody(string ChenckValidateResult)
    {
      this.ChenckValidateResult = ChenckValidateResult;
    }
  }
}
