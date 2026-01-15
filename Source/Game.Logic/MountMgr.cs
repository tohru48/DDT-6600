// Decompiled with JetBrains decompiler
// Type: Game.Logic.MountMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public class MountMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, MountSkillElementTemplateInfo> dictionary_0;
    private static Dictionary<int, MountSkillGetTemplateInfo> dictionary_1;
    private static Dictionary<int, MountSkillTemplateInfo> dictionary_2;
    private static Dictionary<int, MountTemplateInfo> dictionary_3;
    private static Dictionary<int, MountDrawTemplateInfo> dictionary_4;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool Init()
    {
      bool flag;
      try
      {
        MountMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = MountMgr.ReLoad();
      }
      catch (Exception ex)
      {
        if (MountMgr.ilog_0.IsErrorEnabled)
          MountMgr.ilog_0.Error((object) "PetInfoMgr", ex);
        flag = false;
      }
      return flag;
    }

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, MountSkillElementTemplateInfo> SkillElement = new Dictionary<int, MountSkillElementTemplateInfo>();
        Dictionary<int, MountSkillGetTemplateInfo> Skill = new Dictionary<int, MountSkillGetTemplateInfo>();
        Dictionary<int, MountSkillTemplateInfo> SkillTemplate = new Dictionary<int, MountSkillTemplateInfo>();
        Dictionary<int, MountTemplateInfo> TemplateId = new Dictionary<int, MountTemplateInfo>();
        MountDrawTemplateInfo[] MountDrawTemplate = MountMgr.LoadMountDrawTemplateDb();
        Dictionary<int, MountDrawTemplateInfo> dictionary = MountMgr.LoadMountDrawTemplates(MountDrawTemplate);
        if (MountDrawTemplate.Length > 0)
          Interlocked.Exchange<Dictionary<int, MountDrawTemplateInfo>>(ref MountMgr.dictionary_4, dictionary);
        if (MountMgr.smethod_0(SkillElement, Skill, SkillTemplate, TemplateId))
        {
          try
          {
            MountMgr.dictionary_0 = SkillElement;
            MountMgr.dictionary_1 = Skill;
            MountMgr.dictionary_2 = SkillTemplate;
            MountMgr.dictionary_3 = TemplateId;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (MountMgr.ilog_0.IsErrorEnabled)
          MountMgr.ilog_0.Error((object) "PetMgr", ex);
      }
      return false;
    }

    public static MountDrawTemplateInfo[] LoadMountDrawTemplateDb()
    {
      MountDrawTemplateInfo[] mountDrawTemplate;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        mountDrawTemplate = produceBussiness.GetAllMountDrawTemplate();
      return mountDrawTemplate;
    }

    public static Dictionary<int, MountDrawTemplateInfo> LoadMountDrawTemplates(
      MountDrawTemplateInfo[] MountDrawTemplate)
    {
      Dictionary<int, MountDrawTemplateInfo> dictionary = new Dictionary<int, MountDrawTemplateInfo>();
      for (int index = 0; index < MountDrawTemplate.Length; ++index)
      {
        MountDrawTemplateInfo drawTemplateInfo = MountDrawTemplate[index];
        if (!dictionary.Keys.Contains<int>(drawTemplateInfo.ID))
          dictionary.Add(drawTemplateInfo.ID, drawTemplateInfo);
      }
      return dictionary;
    }

    public static MountDrawTemplateInfo FindMountDrawInfo(int ID)
    {
      return MountMgr.dictionary_4.ContainsKey(ID) ? MountMgr.dictionary_4[ID] : (MountDrawTemplateInfo) null;
    }

    public static MountDrawTemplateInfo FindMountDrawByTemplate(int templateID)
    {
      foreach (MountDrawTemplateInfo mountDrawByTemplate in MountMgr.dictionary_4.Values)
      {
        if (mountDrawByTemplate.TemplateId == templateID)
          return mountDrawByTemplate;
      }
      return (MountDrawTemplateInfo) null;
    }

    private static bool smethod_0(
      Dictionary<int, MountSkillElementTemplateInfo> SkillElement,
      Dictionary<int, MountSkillGetTemplateInfo> Skill,
      Dictionary<int, MountSkillTemplateInfo> SkillTemplate,
      Dictionary<int, MountTemplateInfo> TemplateId)
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        MountSkillElementTemplateInfo[] elementTemplateInfo1 = produceBussiness.GetAllMountSkillElementTemplateInfo();
        MountSkillGetTemplateInfo[] skillGetTemplateInfo1 = produceBussiness.GetAllMountSkillGetTemplateInfo();
        MountSkillTemplateInfo[] skillTemplateInfo1 = produceBussiness.GetAllMountSkillTemplateInfo();
        MountTemplateInfo[] mountTemplateInfo1 = produceBussiness.GetAllMountTemplateInfo();
        foreach (MountSkillElementTemplateInfo elementTemplateInfo2 in elementTemplateInfo1)
        {
          if (!SkillElement.ContainsKey(elementTemplateInfo2.ID))
            SkillElement.Add(elementTemplateInfo2.ID, elementTemplateInfo2);
        }
        foreach (MountSkillGetTemplateInfo skillGetTemplateInfo2 in skillGetTemplateInfo1)
        {
          if (!Skill.ContainsKey(skillGetTemplateInfo2.ID))
            Skill.Add(skillGetTemplateInfo2.ID, skillGetTemplateInfo2);
        }
        foreach (MountSkillTemplateInfo skillTemplateInfo2 in skillTemplateInfo1)
        {
          if (!SkillTemplate.ContainsKey(skillTemplateInfo2.ID))
            SkillTemplate.Add(skillTemplateInfo2.ID, skillTemplateInfo2);
        }
        foreach (MountTemplateInfo mountTemplateInfo2 in mountTemplateInfo1)
        {
          if (!TemplateId.ContainsKey(mountTemplateInfo2.Grade))
            TemplateId.Add(mountTemplateInfo2.Grade, mountTemplateInfo2);
        }
      }
      return true;
    }

    public static MountSkillElementTemplateInfo FindMountSkillElement(int SkillID)
    {
      if (MountMgr.dictionary_0 == null)
        MountMgr.Init();
      return MountMgr.dictionary_0.ContainsKey(SkillID) ? MountMgr.dictionary_0[SkillID] : (MountSkillElementTemplateInfo) null;
    }

    public static List<MountSkillElementTemplateInfo> GameNeedMountSkill()
    {
      if (MountMgr.dictionary_0 == null)
        MountMgr.Init();
      List<MountSkillElementTemplateInfo> elementTemplateInfoList = new List<MountSkillElementTemplateInfo>();
      Dictionary<string, MountSkillElementTemplateInfo> dictionary = new Dictionary<string, MountSkillElementTemplateInfo>();
      foreach (MountSkillElementTemplateInfo elementTemplateInfo in MountMgr.dictionary_0.Values)
      {
        if (!dictionary.Keys.Contains<string>(elementTemplateInfo.EffectPic) && !string.IsNullOrEmpty(elementTemplateInfo.EffectPic))
        {
          elementTemplateInfoList.Add(elementTemplateInfo);
          dictionary.Add(elementTemplateInfo.EffectPic, elementTemplateInfo);
        }
      }
      return elementTemplateInfoList;
    }

    public static MountSkillGetTemplateInfo FindMountSkillGetTemplate(int SkillID)
    {
      if (MountMgr.dictionary_1 == null)
        MountMgr.Init();
      foreach (MountSkillGetTemplateInfo skillGetTemplate in MountMgr.dictionary_1.Values)
      {
        if (skillGetTemplate.SkillID == SkillID)
          return skillGetTemplate;
      }
      return (MountSkillGetTemplateInfo) null;
    }

    public static MountSkillGetTemplateInfo[] GetSkillGetTemplates(int SkillID)
    {
      MountSkillGetTemplateInfo info = MountMgr.FindMountSkillGetTemplate(SkillID);
      return info == null ? (MountSkillGetTemplateInfo[]) null : Enumerable.Where<MountSkillGetTemplateInfo>((IEnumerable<MountSkillGetTemplateInfo>) MountMgr.dictionary_1.Values, (Func<MountSkillGetTemplateInfo, bool>) (s => s.Type == info.Type)).ToArray<MountSkillGetTemplateInfo>();
    }

    public static MountSkillTemplateInfo GetMountSkillTemplate(int ID)
    {
      if (MountMgr.dictionary_2 == null)
        MountMgr.Init();
      return MountMgr.dictionary_2.ContainsKey(ID) ? MountMgr.dictionary_2[ID] : (MountSkillTemplateInfo) null;
    }

    public static MountTemplateInfo GetMountTemplate(int Grade)
    {
      if (MountMgr.dictionary_3 == null)
        MountMgr.Init();
      return MountMgr.dictionary_3.ContainsKey(Grade) ? MountMgr.dictionary_3[Grade] : (MountTemplateInfo) null;
    }
  }
}
