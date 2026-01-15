// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.WorldEventMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

#nullable disable
namespace Bussiness.Managers
{
  public class WorldEventMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, LuckyStartToptenAwardInfo> dictionary_0;
    private static Dictionary<int, LuckyStartToptenAwardInfo> dictionary_1;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, LuckyStartToptenAwardInfo> luckyStarts = new Dictionary<int, LuckyStartToptenAwardInfo>();
        Dictionary<int, LuckyStartToptenAwardInfo> lanternriddles = new Dictionary<int, LuckyStartToptenAwardInfo>();
        if (WorldEventMgr.LoadData(luckyStarts, lanternriddles))
        {
          try
          {
            WorldEventMgr.dictionary_0 = luckyStarts;
            WorldEventMgr.dictionary_1 = lanternriddles;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (WorldEventMgr.ilog_0.IsErrorEnabled)
          WorldEventMgr.ilog_0.Error((object) nameof (ReLoad), ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        WorldEventMgr.dictionary_0 = new Dictionary<int, LuckyStartToptenAwardInfo>();
        WorldEventMgr.dictionary_1 = new Dictionary<int, LuckyStartToptenAwardInfo>();
        flag = WorldEventMgr.LoadData(WorldEventMgr.dictionary_0, WorldEventMgr.dictionary_1);
      }
      catch (Exception ex)
      {
        if (WorldEventMgr.ilog_0.IsErrorEnabled)
          WorldEventMgr.ilog_0.Error((object) nameof (Init), ex);
        flag = false;
      }
      return flag;
    }

    public static bool LoadData(
      Dictionary<int, LuckyStartToptenAwardInfo> luckyStarts,
      Dictionary<int, LuckyStartToptenAwardInfo> lanternriddles)
    {
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (LuckyStartToptenAwardInfo startToptenAwardInfo in playerBussiness.GetAllLuckyStartToptenAward())
        {
          if (!luckyStarts.Keys.Contains<int>(startToptenAwardInfo.ID))
            luckyStarts.Add(startToptenAwardInfo.ID, startToptenAwardInfo);
        }
        foreach (LuckyStartToptenAwardInfo startToptenAwardInfo in playerBussiness.GetAllLanternriddlesTopTenAward())
        {
          if (!lanternriddles.Keys.Contains<int>(startToptenAwardInfo.ID))
            lanternriddles.Add(startToptenAwardInfo.ID, startToptenAwardInfo);
        }
      }
      return true;
    }

    public static List<LuckyStartToptenAwardInfo> GetLuckyStartToptenAward()
    {
      List<LuckyStartToptenAwardInfo> startToptenAward = new List<LuckyStartToptenAwardInfo>();
      foreach (LuckyStartToptenAwardInfo startToptenAwardInfo in WorldEventMgr.dictionary_0.Values)
        startToptenAward.Add(startToptenAwardInfo);
      return startToptenAward;
    }

    public static List<LuckyStartToptenAwardInfo> GetLuckyStartAwardByRank(int rank)
    {
      int num = 0;
      switch (rank)
      {
        case 1:
          num = 11;
          break;
        case 2:
          num = 12;
          break;
        case 3:
          num = 13;
          break;
        case 4:
        case 5:
          num = 14;
          break;
        case 6:
        case 7:
          num = 15;
          break;
        case 8:
        case 9:
        case 10:
          num = 16;
          break;
      }
      List<LuckyStartToptenAwardInfo> startAwardByRank = new List<LuckyStartToptenAwardInfo>();
      foreach (LuckyStartToptenAwardInfo startToptenAwardInfo in WorldEventMgr.dictionary_0.Values)
      {
        if (startToptenAwardInfo.Type == num)
          startAwardByRank.Add(startToptenAwardInfo);
      }
      return startAwardByRank;
    }

    public static List<LuckyStartToptenAwardInfo> GetLanternriddlesAwardByRank(int rank)
    {
      List<LuckyStartToptenAwardInfo> lanternriddlesAwardByRank = new List<LuckyStartToptenAwardInfo>();
      foreach (LuckyStartToptenAwardInfo startToptenAwardInfo in WorldEventMgr.dictionary_1.Values)
      {
        if (startToptenAwardInfo.Type == rank)
          lanternriddlesAwardByRank.Add(startToptenAwardInfo);
      }
      return lanternriddlesAwardByRank;
    }

    public static bool SendItemsToMail(int[] int_0, string userInfo, string title)
    {
      bool mail;
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        PlayerInfo singleByUserName = playerBussiness.GetUserSingleByUserName(userInfo);
        if (singleByUserName == null)
        {
          mail = false;
        }
        else
        {
          List<SqlDataProvider.Data.ItemInfo> infos = new List<SqlDataProvider.Data.ItemInfo>();
          for (int index = 0; index < int_0.Length; ++index)
          {
            ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(int_0[index]);
            if (itemTemplate != null)
            {
              SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(itemTemplate, 1, 102);
              fromTemplate.Count = itemTemplate.MaxCount;
              fromTemplate.ValidDate = 0;
              fromTemplate.IsBinds = true;
              infos.Add(fromTemplate);
            }
          }
          mail = WorldEventMgr.SendItemsToMail(infos, singleByUserName.ID, singleByUserName.NickName, title, 83);
        }
      }
      return mail;
    }

    public static bool SendItemsToMail(int[] int_0, string userInfo, string title, int type)
    {
      bool mail;
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        PlayerInfo singleByUserName = playerBussiness.GetUserSingleByUserName(userInfo);
        if (singleByUserName == null)
        {
          mail = false;
        }
        else
        {
          List<SqlDataProvider.Data.ItemInfo> infos = new List<SqlDataProvider.Data.ItemInfo>();
          for (int index = 0; index < int_0.Length; ++index)
          {
            ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(int_0[index]);
            if (itemTemplate != null)
            {
              SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(itemTemplate, 1, 102);
              fromTemplate.Count = itemTemplate.MaxCount;
              fromTemplate.ValidDate = 0;
              fromTemplate.IsBinds = true;
              infos.Add(fromTemplate);
            }
          }
          mail = WorldEventMgr.SendItemsToMail(infos, singleByUserName.ID, singleByUserName.NickName, title, type);
        }
      }
      return mail;
    }

    public static bool SendItemToMail(SqlDataProvider.Data.ItemInfo info, int PlayerId, string Nickname, string title)
    {
      return WorldEventMgr.SendItemsToMail(new List<SqlDataProvider.Data.ItemInfo>()
      {
        info
      }, PlayerId, Nickname, title, 83);
    }

    public static bool SendItemsToMail(
      List<SqlDataProvider.Data.ItemInfo> infos,
      int PlayerId,
      string Nickname,
      string title)
    {
      return WorldEventMgr.SendItemsToMail(infos, PlayerId, Nickname, title, 83);
    }

    public static bool SendItemsToMail(
      List<SqlDataProvider.Data.ItemInfo> infos,
      int PlayerId,
      string Nickname,
      string title,
      int type)
    {
      bool mail1 = false;
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        List<SqlDataProvider.Data.ItemInfo> itemInfoList = new List<SqlDataProvider.Data.ItemInfo>();
        foreach (SqlDataProvider.Data.ItemInfo info in infos)
        {
          if (info.Template.MaxCount == 1)
          {
            for (int index = 0; index < info.Count; ++index)
            {
              SqlDataProvider.Data.ItemInfo itemInfo = SqlDataProvider.Data.ItemInfo.CloneFromTemplate(info.Template, info);
              itemInfo.Count = 1;
              itemInfoList.Add(itemInfo);
            }
          }
          else
            itemInfoList.Add(info);
        }
        for (int index1 = 0; index1 < itemInfoList.Count; index1 += 5)
        {
          MailInfo mail2 = new MailInfo()
          {
            Title = title,
            Gold = 0,
            IsExist = true,
            Money = 0,
            Receiver = Nickname,
            ReceiverID = PlayerId,
            Sender = LanguageMgr.GetTranslation("SystermSender.Msg"),
            SenderID = 0,
            Type = type,
            GiftToken = 0
          };
          StringBuilder stringBuilder1 = new StringBuilder();
          StringBuilder stringBuilder2 = new StringBuilder();
          stringBuilder1.Append(LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.AnnexRemark"));
          int index2 = index1;
          int itemId;
          if (itemInfoList.Count > index2)
          {
            SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index2];
            if (itemInfo.ItemID == 0)
              playerBussiness.AddGoods(itemInfo);
            MailInfo mailInfo = mail2;
            itemId = itemInfo.ItemID;
            string str = itemId.ToString();
            mailInfo.Annex1 = str;
            mail2.String_0 = itemInfo.Template.Name;
            stringBuilder1.Append("1、" + mail2.String_0 + "x" + (object) itemInfo.Count + ";");
            stringBuilder2.Append("1、" + mail2.String_0 + "x" + (object) itemInfo.Count + ";");
          }
          int index3 = index1 + 1;
          if (itemInfoList.Count > index3)
          {
            SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index3];
            if (itemInfo.ItemID == 0)
              playerBussiness.AddGoods(itemInfo);
            MailInfo mailInfo = mail2;
            itemId = itemInfo.ItemID;
            string str = itemId.ToString();
            mailInfo.Annex2 = str;
            mail2.String_1 = itemInfo.Template.Name;
            stringBuilder1.Append("2、" + mail2.String_1 + "x" + (object) itemInfo.Count + ";");
            stringBuilder2.Append("2、" + mail2.String_1 + "x" + (object) itemInfo.Count + ";");
          }
          int index4 = index1 + 2;
          if (itemInfoList.Count > index4)
          {
            SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index4];
            if (itemInfo.ItemID == 0)
              playerBussiness.AddGoods(itemInfo);
            MailInfo mailInfo = mail2;
            itemId = itemInfo.ItemID;
            string str = itemId.ToString();
            mailInfo.Annex3 = str;
            mail2.String_2 = itemInfo.Template.Name;
            stringBuilder1.Append("3、" + mail2.String_2 + "x" + (object) itemInfo.Count + ";");
            stringBuilder2.Append("3、" + mail2.String_2 + "x" + (object) itemInfo.Count + ";");
          }
          int index5 = index1 + 3;
          if (itemInfoList.Count > index5)
          {
            SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index5];
            if (itemInfo.ItemID == 0)
              playerBussiness.AddGoods(itemInfo);
            MailInfo mailInfo = mail2;
            itemId = itemInfo.ItemID;
            string str = itemId.ToString();
            mailInfo.Annex4 = str;
            mail2.String_3 = itemInfo.Template.Name;
            stringBuilder1.Append("4、" + mail2.String_3 + "x" + (object) itemInfo.Count + ";");
            stringBuilder2.Append("4、" + mail2.String_3 + "x" + (object) itemInfo.Count + ";");
          }
          int index6 = index1 + 4;
          if (itemInfoList.Count > index6)
          {
            SqlDataProvider.Data.ItemInfo itemInfo = itemInfoList[index6];
            if (itemInfo.ItemID == 0)
              playerBussiness.AddGoods(itemInfo);
            MailInfo mailInfo = mail2;
            itemId = itemInfo.ItemID;
            string str = itemId.ToString();
            mailInfo.Annex5 = str;
            mail2.String_4 = itemInfo.Template.Name;
            stringBuilder1.Append("5、" + mail2.String_4 + "x" + (object) itemInfo.Count + ";");
            stringBuilder2.Append("5、" + mail2.String_4 + "x" + (object) itemInfo.Count + ";");
          }
          mail2.AnnexRemark = stringBuilder1.ToString();
          mail2.Content = stringBuilder2.ToString();
          mail1 = playerBussiness.SendMail(mail2);
        }
      }
      return mail1;
    }
  }
}
