// Decompiled with JetBrains decompiler
// Type: Bussiness.StaticFunction
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using System;
using System.Configuration;
using System.Reflection;

#nullable disable
namespace Bussiness
{
  public class StaticFunction
  {
    protected static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

    public static bool UpdateConfig(string fileName, string name, string value)
    {
      try
      {
        System.Configuration.Configuration configuration = ConfigurationManager.OpenMappedExeConfiguration(new ExeConfigurationFileMap()
        {
          ExeConfigFilename = fileName
        }, ConfigurationUserLevel.None);
        configuration.AppSettings.Settings[name].Value = value;
        configuration.Save();
        ConfigurationManager.RefreshSection("appSettings");
        return true;
      }
      catch (Exception ex)
      {
        if (StaticFunction.log.IsErrorEnabled)
          StaticFunction.log.Error((object) nameof (UpdateConfig), ex);
      }
      return false;
    }
  }
}
