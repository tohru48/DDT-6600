// Decompiled with JetBrains decompiler
// Type: Bussiness.WebLogin.PassPortSoap
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System.CodeDom.Compiler;
using System.ServiceModel;

#nullable disable
namespace Bussiness.WebLogin
{
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [ServiceContract(Namespace = "dandantang", ConfigurationName = "WebLogin.PassPortSoap")]
  public interface PassPortSoap
  {
    [OperationContract(Action = "dandantang/ChenckValidate", ReplyAction = "*")]
    ChenckValidateResponse ChenckValidate(ChenckValidateRequest request);

    [OperationContract(Action = "dandantang/Get_UserSex", ReplyAction = "*")]
    Get_UserSexResponse Get_UserSex(Get_UserSexRequest request);
  }
}
