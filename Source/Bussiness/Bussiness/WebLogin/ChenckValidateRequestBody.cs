// Decompiled with JetBrains decompiler
// Type: Bussiness.WebLogin.ChenckValidateRequestBody
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
  public class ChenckValidateRequestBody
  {
    [DataMember(EmitDefaultValue = false, Order = 0)]
    public string applicationname;
    [DataMember(EmitDefaultValue = false, Order = 1)]
    public string username;
    [DataMember(EmitDefaultValue = false, Order = 2)]
    public string password;

    public ChenckValidateRequestBody()
    {
    }

    public ChenckValidateRequestBody(string applicationname, string username, string password)
    {
      this.applicationname = applicationname;
      this.username = username;
      this.password = password;
    }
  }
}
