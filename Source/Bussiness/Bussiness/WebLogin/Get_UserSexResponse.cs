// Decompiled with JetBrains decompiler
// Type: Bussiness.WebLogin.Get_UserSexResponse
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
  [MessageContract(IsWrapped = false)]
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [DebuggerStepThrough]
  public class Get_UserSexResponse
  {
    [MessageBodyMember(Name = "Get_UserSexResponse", Namespace = "dandantang", Order = 0)]
    public Get_UserSexResponseBody Body;

    public Get_UserSexResponse()
    {
    }

    public Get_UserSexResponse(Get_UserSexResponseBody Body) => this.Body = Body;
  }
}
