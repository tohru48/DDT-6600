// Decompiled with JetBrains decompiler
// Type: Bussiness.Interface.SRInterface
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using Bussiness.WebLogin;
using System;

#nullable disable
namespace Bussiness.Interface
{
  public class SRInterface : BaseInterface
  {
    public override bool GetUserSex(string name)
    {
      bool userSex;
      try
      {
        userSex = new PassPortSoapClient().Get_UserSex(string.Empty, name).Value;
      }
      catch (Exception ex)
      {
        BaseInterface.log.Error((object) "获取性别失败", ex);
        userSex = true;
      }
      return userSex;
    }
  }
}
