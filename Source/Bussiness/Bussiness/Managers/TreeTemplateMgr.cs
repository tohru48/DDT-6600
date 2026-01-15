// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.TreeTemplateMgr
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
  public class TreeTemplateMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, TreeTemplateInfo> dictionary_0 = new Dictionary<int, TreeTemplateInfo>();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        TreeTemplateInfo[] TreeTemplate = TreeTemplateMgr.LoadTreeTemplateDb();
        Dictionary<int, TreeTemplateInfo> dictionary = TreeTemplateMgr.LoadTreeTemplates(TreeTemplate);
        if (TreeTemplate.Length > 0)
          Interlocked.Exchange<Dictionary<int, TreeTemplateInfo>>(ref TreeTemplateMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (TreeTemplateMgr.ilog_0.IsErrorEnabled)
          TreeTemplateMgr.ilog_0.Error((object) "ReLoad TreeTemplate", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => TreeTemplateMgr.ReLoad();

    public static TreeTemplateInfo[] LoadTreeTemplateDb()
    {
      TreeTemplateInfo[] allTreeTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allTreeTemplate = produceBussiness.GetAllTreeTemplate();
      return allTreeTemplate;
    }

    public static Dictionary<int, TreeTemplateInfo> LoadTreeTemplates(
      TreeTemplateInfo[] TreeTemplate)
    {
      Dictionary<int, TreeTemplateInfo> dictionary = new Dictionary<int, TreeTemplateInfo>();
      for (int index = 0; index < TreeTemplate.Length; ++index)
      {
        TreeTemplateInfo treeTemplateInfo = TreeTemplate[index];
        if (!dictionary.Keys.Contains<int>(treeTemplateInfo.Level))
          dictionary.Add(treeTemplateInfo.Level, treeTemplateInfo);
      }
      return dictionary;
    }

    public static TreeTemplateInfo FindTreeTemplate(int level)
    {
      return TreeTemplateMgr.dictionary_0.ContainsKey(level) ? TreeTemplateMgr.dictionary_0[level] : (TreeTemplateInfo) null;
    }

    public static TreeTemplateInfo FindNextTreeTemplate(int level)
    {
      TreeTemplateInfo nextTreeTemplate = TreeTemplateMgr.dictionary_0[level];
      if (nextTreeTemplate == null)
      {
        level = TreeTemplateMgr.dictionary_0.Count - 1;
        nextTreeTemplate = TreeTemplateMgr.dictionary_0[level];
      }
      return nextTreeTemplate;
    }

    public static int MaxTreeTemplate() => TreeTemplateMgr.dictionary_0.Count;
  }
}
