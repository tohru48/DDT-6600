// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.AvatarColectionMgr
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
  public class AvatarColectionMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static List<ClothPropertyTemplateInfo> list_0 = new List<ClothPropertyTemplateInfo>();
    private static Dictionary<int, List<ClothGroupTemplateInfo>> dictionary_0 = new Dictionary<int, List<ClothGroupTemplateInfo>>();
    private static Dictionary<int, ClothPropertyTemplateInfo> dictionary_1 = new Dictionary<int, ClothPropertyTemplateInfo>();

    public static bool Init() => AvatarColectionMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        List<ClothPropertyTemplateInfo> tempClothPropertyTemplates = AvatarColectionMgr.LoadClothPropertyTemplateDb();
        Dictionary<int, List<ClothGroupTemplateInfo>> dictionary = AvatarColectionMgr.LoadClothGroupTemplateInfoDb(tempClothPropertyTemplates);
        if (tempClothPropertyTemplates.Count > 0)
        {
          Interlocked.Exchange<List<ClothPropertyTemplateInfo>>(ref AvatarColectionMgr.list_0, tempClothPropertyTemplates);
          Interlocked.Exchange<Dictionary<int, List<ClothGroupTemplateInfo>>>(ref AvatarColectionMgr.dictionary_0, dictionary);
        }
        return true;
      }
      catch (Exception ex)
      {
        AvatarColectionMgr.ilog_0.Error((object) nameof (AvatarColectionMgr), ex);
      }
      return false;
    }

    public static List<ClothPropertyTemplateInfo> LoadClothPropertyTemplateDb()
    {
      List<ClothPropertyTemplateInfo> list;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        ClothPropertyTemplateInfo[] propertyTemplateInfos = produceBussiness.GetAllClothPropertyTemplateInfos();
        foreach (ClothPropertyTemplateInfo propertyTemplateInfo in propertyTemplateInfos)
        {
          if (!AvatarColectionMgr.dictionary_1.ContainsKey(propertyTemplateInfo.ID))
            AvatarColectionMgr.dictionary_1.Add(propertyTemplateInfo.ID, propertyTemplateInfo);
        }
        list = propertyTemplateInfos != null ? ((IEnumerable<ClothPropertyTemplateInfo>) propertyTemplateInfos).ToList<ClothPropertyTemplateInfo>() : (List<ClothPropertyTemplateInfo>) null;
      }
      return list;
    }

    public static Dictionary<int, List<ClothGroupTemplateInfo>> LoadClothGroupTemplateInfoDb(
      List<ClothPropertyTemplateInfo> tempClothPropertyTemplates)
    {
      Dictionary<int, List<ClothGroupTemplateInfo>> dictionary = new Dictionary<int, List<ClothGroupTemplateInfo>>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        ClothGroupTemplateInfo[] groupTemplateInfos = produceBussiness.GetAllClothGroupTemplateInfos();
        foreach (ClothPropertyTemplateInfo propertyTemplate in tempClothPropertyTemplates)
        {
          ClothPropertyTemplateInfo info = propertyTemplate;
          IEnumerable<ClothGroupTemplateInfo> source = Enumerable.Where<ClothGroupTemplateInfo>((IEnumerable<ClothGroupTemplateInfo>) groupTemplateInfos, (Func<ClothGroupTemplateInfo, bool>) (s => s.ID == info.ID));
          dictionary.Add(info.ID, source.ToList<ClothGroupTemplateInfo>());
        }
      }
      return dictionary;
    }

    public static List<ClothGroupTemplateInfo> FindClothGroupTemplateInfo(int groupId)
    {
      return AvatarColectionMgr.dictionary_0.ContainsKey(groupId) ? AvatarColectionMgr.dictionary_0[groupId] : (List<ClothGroupTemplateInfo>) null;
    }

    public static ClothGroupTemplateInfo FindClothGroupTemplateInfo(
      int groupId,
      int itemId,
      int sex)
    {
      if (AvatarColectionMgr.dictionary_0.ContainsKey(groupId))
      {
        foreach (ClothGroupTemplateInfo groupTemplateInfo in AvatarColectionMgr.dictionary_0[groupId])
        {
          if (groupTemplateInfo.TemplateID == itemId && groupTemplateInfo.Sex == sex)
            return groupTemplateInfo;
        }
      }
      return (ClothGroupTemplateInfo) null;
    }

    public static void addCloth(int groupId, int itemId, int sex)
    {
      using (new ProduceBussiness())
        AvatarColectionMgr.addCloth(groupId, itemId, sex);
    }

    public static List<ClothPropertyTemplateInfo> GetClothPropertyTemplate()
    {
      return AvatarColectionMgr.list_0 != null ? AvatarColectionMgr.list_0 : (List<ClothPropertyTemplateInfo>) null;
    }

    public static ClothPropertyTemplateInfo FindClothPropertyTemplate(int dataId)
    {
      return AvatarColectionMgr.dictionary_1.ContainsKey(dataId) ? AvatarColectionMgr.dictionary_1[dataId] : (ClothPropertyTemplateInfo) null;
    }
  }
}
