// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.MagicItemTemplateMgr
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
  public class MagicItemTemplateMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, MagicItemTemplateInfo> dictionary_0 = new Dictionary<int, MagicItemTemplateInfo>();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        MagicItemTemplateInfo[] MagicItemTemplate = MagicItemTemplateMgr.LoadMagicItemTemplateDb();
        Dictionary<int, MagicItemTemplateInfo> dictionary = MagicItemTemplateMgr.LoadMagicItemTemplates(MagicItemTemplate);
        if (MagicItemTemplate.Length > 0)
          Interlocked.Exchange<Dictionary<int, MagicItemTemplateInfo>>(ref MagicItemTemplateMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (MagicItemTemplateMgr.ilog_0.IsErrorEnabled)
          MagicItemTemplateMgr.ilog_0.Error((object) "ReLoad MagicItemTemplate", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => MagicItemTemplateMgr.ReLoad();

    public static MagicItemTemplateInfo[] LoadMagicItemTemplateDb()
    {
      MagicItemTemplateInfo[] magicItemTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        magicItemTemplate = produceBussiness.GetAllMagicItemTemplate();
      return magicItemTemplate;
    }

    public static Dictionary<int, MagicItemTemplateInfo> LoadMagicItemTemplates(
      MagicItemTemplateInfo[] MagicItemTemplate)
    {
      Dictionary<int, MagicItemTemplateInfo> dictionary = new Dictionary<int, MagicItemTemplateInfo>();
      for (int index = 0; index < MagicItemTemplate.Length; ++index)
      {
        MagicItemTemplateInfo itemTemplateInfo = MagicItemTemplate[index];
        if (!dictionary.Keys.Contains<int>(itemTemplateInfo.Lv))
          dictionary.Add(itemTemplateInfo.Lv, itemTemplateInfo);
      }
      return dictionary;
    }

    public static MagicItemTemplateInfo FindMagicItemTemplate(int ID)
    {
      return MagicItemTemplateMgr.dictionary_0.ContainsKey(ID) ? MagicItemTemplateMgr.dictionary_0[ID] : (MagicItemTemplateInfo) null;
    }
  }
}
