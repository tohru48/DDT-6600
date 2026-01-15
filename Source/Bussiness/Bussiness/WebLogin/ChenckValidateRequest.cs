// Decompiled with JetBrains decompiler
// Type: Bussiness.WebLogin.ChenckValidateRequest
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
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [MessageContract(IsWrapped = false)]
  [EditorBrowsable(EditorBrowsableState.Advanced)]
  [DebuggerStepThrough]
  public class ChenckValidateRequest
  {
    [MessageBodyMember(Name = "ChenckValidate", Namespace = "dandantang", Order = 0)]
    public ChenckValidateRequestBody Body;

    public ChenckValidateRequest()
    {
    }

    public ChenckValidateRequest(ChenckValidateRequestBody Body) => this.Body = Body;
  }
}
