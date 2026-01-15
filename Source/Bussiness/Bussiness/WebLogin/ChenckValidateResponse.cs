// Decompiled with JetBrains decompiler
// Type: Bussiness.WebLogin.ChenckValidateResponse
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.ServiceModel;

#nullable disable
namespace Bussiness.WebLogin
{
  [EditorBrowsable(EditorBrowsableState.Advanced)]
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [MessageContract(IsWrapped = false)]
  [DebuggerStepThrough]
  public class ChenckValidateResponse
  {
    [MessageBodyMember(Name = "ChenckValidateResponse", Namespace = "dandantang", Order = 0)]
    public ChenckValidateResponseBody Body;

    public ChenckValidateResponse()
    {
    }

    public ChenckValidateResponse(ChenckValidateResponseBody Body) => this.Body = Body;
  }
}
