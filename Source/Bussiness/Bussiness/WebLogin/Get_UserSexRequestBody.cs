// Decompiled with JetBrains decompiler
// Type: Bussiness.WebLogin.Get_UserSexRequestBody
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
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [EditorBrowsable(EditorBrowsableState.Advanced)]
  [DebuggerStepThrough]
  public class Get_UserSexRequestBody
  {
    [DataMember(EmitDefaultValue = false, Order = 0)]
    public string applicationname;
    [DataMember(EmitDefaultValue = false, Order = 1)]
    public string username;

    public Get_UserSexRequestBody()
    {
    }

    public Get_UserSexRequestBody(string applicationname, string username)
    {
      this.applicationname = applicationname;
      this.username = username;
    }
  }
}
