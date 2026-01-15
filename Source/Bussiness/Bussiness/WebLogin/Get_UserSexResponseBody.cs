// Decompiled with JetBrains decompiler
// Type: Bussiness.WebLogin.Get_UserSexResponseBody
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
  [DebuggerStepThrough]
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [DataContract(Namespace = "dandantang")]
  [EditorBrowsable(EditorBrowsableState.Advanced)]
  public class Get_UserSexResponseBody
  {
    [DataMember(Order = 0)]
    public bool? Get_UserSexResult;

    public Get_UserSexResponseBody()
    {
    }

    public Get_UserSexResponseBody(bool? Get_UserSexResult)
    {
      this.Get_UserSexResult = Get_UserSexResult;
    }
  }
}
