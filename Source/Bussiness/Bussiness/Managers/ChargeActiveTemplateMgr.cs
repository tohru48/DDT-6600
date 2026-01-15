// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ChargeActiveTemplateMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Bussiness.Managers
{
  public class ChargeActiveTemplateMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, ChargeActiveTemplateInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        ChargeActiveTemplateInfo[] ChargeActiveTemplate = ChargeActiveTemplateMgr.LoadChargeActiveTemplateDb();
        Dictionary<int, ChargeActiveTemplateInfo> dictionary = ChargeActiveTemplateMgr.LoadChargeActiveTemplates(ChargeActiveTemplate);
        if (ChargeActiveTemplate.Length > 0)
          Interlocked.Exchange<Dictionary<int, ChargeActiveTemplateInfo>>(ref ChargeActiveTemplateMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (ChargeActiveTemplateMgr.ilog_0.IsErrorEnabled)
          ChargeActiveTemplateMgr.ilog_0.Error((object) "ReLoad ChargeActiveTemplate", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => ChargeActiveTemplateMgr.ReLoad();

    public static ChargeActiveTemplateInfo[] LoadChargeActiveTemplateDb()
    {
      ChargeActiveTemplateInfo[] chargeActiveTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        chargeActiveTemplate = produceBussiness.GetAllChargeActiveTemplate();
      return chargeActiveTemplate;
    }

    public static Dictionary<int, ChargeActiveTemplateInfo> LoadChargeActiveTemplates(
      ChargeActiveTemplateInfo[] ChargeActiveTemplate)
    {
      Dictionary<int, ChargeActiveTemplateInfo> dictionary = new Dictionary<int, ChargeActiveTemplateInfo>();
      for (int index = 0; index < ChargeActiveTemplate.Length; ++index)
      {
        ChargeActiveTemplateInfo activeTemplateInfo = ChargeActiveTemplate[index];
        if (!dictionary.Keys.Contains<int>(activeTemplateInfo.ID))
          dictionary.Add(activeTemplateInfo.ID, activeTemplateInfo);
      }
      return dictionary;
    }

    public static ChargeActiveTemplateInfo FindChargeActiveTemplate(int ID)
    {
      return ChargeActiveTemplateMgr.dictionary_0.ContainsKey(ID) ? ChargeActiveTemplateMgr.dictionary_0[ID] : (ChargeActiveTemplateInfo) null;
    }
  }
}
