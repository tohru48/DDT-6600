// Decompiled with JetBrains decompiler
// Type: Bussiness.WebLogin.PassPortSoapClient
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.ServiceModel;
using System.ServiceModel.Channels;

#nullable disable
namespace Bussiness.WebLogin
{
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [DebuggerStepThrough]
  public class PassPortSoapClient : ClientBase<PassPortSoap>, PassPortSoap
  {
    public PassPortSoapClient()
    {
    }

    public PassPortSoapClient(string endpointConfigurationName)
      : base(endpointConfigurationName)
    {
    }

    public PassPortSoapClient(string endpointConfigurationName, string remoteAddress)
      : base(endpointConfigurationName, remoteAddress)
    {
    }

    public PassPortSoapClient(string endpointConfigurationName, EndpointAddress remoteAddress)
      : base(endpointConfigurationName, remoteAddress)
    {
    }

    public PassPortSoapClient(Binding binding, EndpointAddress remoteAddress)
      : base(binding, remoteAddress)
    {
    }

    [EditorBrowsable(EditorBrowsableState.Advanced)]
    ChenckValidateResponse PassPortSoap.ChenckValidate(ChenckValidateRequest request)
    {
      return this.Channel.ChenckValidate(request);
    }

    public string ChenckValidate(string applicationname, string username, string password)
    {
      return ((PassPortSoap) this).ChenckValidate(new ChenckValidateRequest()
      {
        Body = {
          applicationname = applicationname,
          username = username,
          password = password
        }
      }).Body.ChenckValidateResult;
    }

    [EditorBrowsable(EditorBrowsableState.Advanced)]
    Get_UserSexResponse PassPortSoap.Get_UserSex(Get_UserSexRequest request)
    {
      return this.Channel.Get_UserSex(request);
    }

    public bool? Get_UserSex(string applicationname, string username)
    {
      return ((PassPortSoap) this).Get_UserSex(new Get_UserSexRequest()
      {
        Body = {
          applicationname = applicationname,
          username = username
        }
      }).Body.Get_UserSexResult;
    }
  }
}
