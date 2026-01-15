using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.CollectionTask;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.NewHall;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public sealed class WorldMgr
	{
		private static readonly ILog ilog_0;

		private static ReaderWriterLock readerWriterLock_0;

		private static Dictionary<int, GamePlayer> dictionary_0;

		private static Dictionary<int, Dictionary<int, ItemInfo>> dictionary_1;

		public static Scene _marryScene;

		private static Dictionary<int, AreaConfigInfo> dictionary_2;

		public static Scene _hotSpring;

		private static RSACryptoServiceProvider rsacryptoServiceProvider_0;

		private static NewHallRoom newHallRoom_0;

		private static CollectionTaskRoom collectionTaskRoom_0;

		private static object object_0;

		public static Scene MarryScene => _marryScene;

		public static Scene HotSpring => _hotSpring;

		public static RSACryptoServiceProvider RsaCryptor => rsacryptoServiceProvider_0;

		public static NewHallRoom NewHallRooms => newHallRoom_0;

		public static CollectionTaskRoom CollectionTaskRooms => collectionTaskRoom_0;

		public static bool Init()
		{
			bool result = false;
			try
			{
				rsacryptoServiceProvider_0 = new RSACryptoServiceProvider();
				rsacryptoServiceProvider_0.FromXmlString(GameServer.Instance.Configuration.PrivateKey);
				dictionary_0.Clear();
				using (ServiceBussiness serviceBussiness = new ServiceBussiness())
				{
					ServerInfo serviceSingle = serviceBussiness.GetServiceSingle(GameServer.Instance.Configuration.ServerID);
					if (serviceSingle != null)
					{
						_marryScene = new Scene(serviceSingle);
						_hotSpring = new Scene(serviceSingle);
						newHallRoom_0 = new NewHallRoom();
						collectionTaskRoom_0 = new CollectionTaskRoom();
						result = true;
					}
				}
				using AreaBussiness areaBussiness = new AreaBussiness();
				AreaConfigInfo[] allAreaConfig = areaBussiness.GetAllAreaConfig();
				AreaConfigInfo[] array = allAreaConfig;
				foreach (AreaConfigInfo areaConfigInfo in array)
				{
					if (!dictionary_2.ContainsKey(areaConfigInfo.AreaID))
					{
						dictionary_2.Add(areaConfigInfo.AreaID, areaConfigInfo);
					}
				}
			}
			catch (Exception exception)
			{
				ilog_0.Error("WordMgr Init", exception);
			}
			return result;
		}

		public static AreaConfigInfo FindAreaConfig(int zoneId)
		{
			readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (dictionary_2.ContainsKey(zoneId))
				{
					return dictionary_2[zoneId];
				}
			}
			finally
			{
				readerWriterLock_0.ReleaseWriterLock();
			}
			return null;
		}

		public static AreaConfigInfo[] GetAllAreaConfig()
		{
			List<AreaConfigInfo> list = new List<AreaConfigInfo>();
			foreach (AreaConfigInfo value in dictionary_2.Values)
			{
				list.Add(value);
			}
			return list.ToArray();
		}

		public static void AddItemToMailBag(int playerId, List<ItemInfo> infos)
		{
			readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (dictionary_1.ContainsKey(playerId))
				{
					Dictionary<int, ItemInfo> dictionary = dictionary_1[playerId];
					{
						foreach (ItemInfo info in infos)
						{
							if (!dictionary.ContainsKey(info.TemplateID))
							{
								dictionary.Add(info.TemplateID, info);
							}
							else
							{
								dictionary[info.TemplateID].Count += info.Count;
							}
						}
						return;
					}
				}
				Dictionary<int, ItemInfo> dictionary2 = new Dictionary<int, ItemInfo>();
				foreach (ItemInfo info2 in infos)
				{
					if (!dictionary2.ContainsKey(info2.TemplateID))
					{
						dictionary2.Add(info2.TemplateID, info2);
					}
					else
					{
						dictionary2[info2.TemplateID].Count += info2.Count;
					}
				}
				dictionary_1.Add(playerId, dictionary2);
			}
			finally
			{
				readerWriterLock_0.ReleaseWriterLock();
			}
		}

		public static Dictionary<int, Dictionary<int, ItemInfo>> GetAllBagMails()
		{
			Dictionary<int, Dictionary<int, ItemInfo>> dictionary = new Dictionary<int, Dictionary<int, ItemInfo>>();
			readerWriterLock_0.AcquireReaderLock(-1);
			try
			{
				foreach (KeyValuePair<int, Dictionary<int, ItemInfo>> item in dictionary_1)
				{
					dictionary.Add(item.Key, item.Value);
				}
			}
			finally
			{
				readerWriterLock_0.ReleaseReaderLock();
			}
			return dictionary;
		}

		public static void ScanBagMail()
		{
			Dictionary<int, Dictionary<int, ItemInfo>> allBagMails = GetAllBagMails();
			foreach (KeyValuePair<int, Dictionary<int, ItemInfo>> item in allBagMails)
			{
				if (item.Value != null)
				{
					SendItemsToMail(item.Value, item.Key);
				}
			}
		}

		public static void SendItemsToMail(Dictionary<int, ItemInfo> infos, int PlayerId)
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			List<ItemInfo> list = new List<ItemInfo>();
			foreach (ItemInfo value in infos.Values)
			{
				if (value.Template.MaxCount == 1)
				{
					for (int i = 0; i < value.Count; i++)
					{
						ItemInfo ıtemInfo = ItemInfo.CloneFromTemplate(value.Template, value);
						ıtemInfo.Count = 1;
						list.Add(ıtemInfo);
					}
				}
				else
				{
					list.Add(value);
				}
			}
			for (int j = 0; j < list.Count; j += 5)
			{
				MailInfo mailInfo = new MailInfo();
				mailInfo.Title = "Vật phẩm chuyển về từ -Túi ẩn-";
				mailInfo.Gold = 0;
				mailInfo.IsExist = true;
				mailInfo.Money = 0;
				mailInfo.Receiver = "Túi ẩn";
				mailInfo.ReceiverID = PlayerId;
				mailInfo.Sender = "Hệ thống";
				mailInfo.SenderID = 0;
				mailInfo.Type = 9;
				mailInfo.GiftToken = 0;
				MailInfo mailInfo2 = mailInfo;
				StringBuilder stringBuilder = new StringBuilder();
				StringBuilder stringBuilder2 = new StringBuilder();
				stringBuilder.Append(LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.AnnexRemark"));
				int num = j;
				if (list.Count > num)
				{
					ItemInfo ıtemInfo2 = list[num];
					if (ıtemInfo2.ItemID == 0)
					{
						playerBussiness.AddGoods(ıtemInfo2);
					}
					mailInfo2.Annex1 = ıtemInfo2.ItemID.ToString();
					mailInfo2.String_0 = ıtemInfo2.Template.Name;
					stringBuilder.Append("1、" + mailInfo2.String_0 + "x" + ıtemInfo2.Count + ";");
					stringBuilder2.Append("1、" + mailInfo2.String_0 + "x" + ıtemInfo2.Count + ";");
				}
				num = j + 1;
				if (list.Count > num)
				{
					ItemInfo ıtemInfo2 = list[num];
					if (ıtemInfo2.ItemID == 0)
					{
						playerBussiness.AddGoods(ıtemInfo2);
					}
					mailInfo2.Annex2 = ıtemInfo2.ItemID.ToString();
					mailInfo2.String_1 = ıtemInfo2.Template.Name;
					stringBuilder.Append("2、" + mailInfo2.String_1 + "x" + ıtemInfo2.Count + ";");
					stringBuilder2.Append("2、" + mailInfo2.String_1 + "x" + ıtemInfo2.Count + ";");
				}
				num = j + 2;
				if (list.Count > num)
				{
					ItemInfo ıtemInfo2 = list[num];
					if (ıtemInfo2.ItemID == 0)
					{
						playerBussiness.AddGoods(ıtemInfo2);
					}
					mailInfo2.Annex3 = ıtemInfo2.ItemID.ToString();
					mailInfo2.String_2 = ıtemInfo2.Template.Name;
					stringBuilder.Append("3、" + mailInfo2.String_2 + "x" + ıtemInfo2.Count + ";");
					stringBuilder2.Append("3、" + mailInfo2.String_2 + "x" + ıtemInfo2.Count + ";");
				}
				num = j + 3;
				if (list.Count > num)
				{
					ItemInfo ıtemInfo2 = list[num];
					if (ıtemInfo2.ItemID == 0)
					{
						playerBussiness.AddGoods(ıtemInfo2);
					}
					mailInfo2.Annex4 = ıtemInfo2.ItemID.ToString();
					mailInfo2.String_3 = ıtemInfo2.Template.Name;
					stringBuilder.Append("4、" + mailInfo2.String_3 + "x" + ıtemInfo2.Count + ";");
					stringBuilder2.Append("4、" + mailInfo2.String_3 + "x" + ıtemInfo2.Count + ";");
				}
				num = j + 4;
				if (list.Count > num)
				{
					ItemInfo ıtemInfo2 = list[num];
					if (ıtemInfo2.ItemID == 0)
					{
						playerBussiness.AddGoods(ıtemInfo2);
					}
					mailInfo2.Annex5 = ıtemInfo2.ItemID.ToString();
					mailInfo2.String_4 = ıtemInfo2.Template.Name;
					stringBuilder.Append("5、" + mailInfo2.String_4 + "x" + ıtemInfo2.Count + ";");
					stringBuilder2.Append("5、" + mailInfo2.String_4 + "x" + ıtemInfo2.Count + ";");
				}
				mailInfo2.AnnexRemark = stringBuilder.ToString();
				mailInfo2.Content = stringBuilder2.ToString();
				if (playerBussiness.SendMail(mailInfo2))
				{
					dictionary_1.Remove(PlayerId);
				}
			}
		}

		public static void SendToAll(GSPacketIn pkg)
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer.SendTCP(pkg);
			}
		}

		public static GSPacketIn SendSysNotice(eMessageType type, string msg, int ItemID, int TemplateID, string key, int zoneID)
		{
			int val = msg.IndexOf("@");
			GSPacketIn gSPacketIn = new GSPacketIn(10);
			gSPacketIn.WriteInt((int)type);
			gSPacketIn.WriteString(msg.Replace("@", ""));
			if (type == eMessageType.CROSS_NOTICE)
			{
				gSPacketIn.WriteInt(zoneID);
			}
			if (ItemID > 0)
			{
				gSPacketIn.WriteByte(1);
				gSPacketIn.WriteInt(val);
				gSPacketIn.WriteInt(TemplateID);
				gSPacketIn.WriteInt(ItemID);
				gSPacketIn.WriteString(key);
			}
			SendToAll(gSPacketIn);
			return gSPacketIn;
		}

		public static GSPacketIn SendSysNotice(string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(10);
			gSPacketIn.WriteInt(2);
			gSPacketIn.WriteString(msg);
			SendToAll(gSPacketIn);
			return gSPacketIn;
		}

		public static GSPacketIn SendCrossSysNotice(string msg, int zoneId)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(10);
			gSPacketIn.WriteInt(13);
			gSPacketIn.WriteString(msg);
			gSPacketIn.WriteInt(zoneId);
			SendToAll(gSPacketIn);
			return gSPacketIn;
		}

		public static void ChatEntertamentModeOpenOrClose()
		{
			GSPacketIn packet = new GSPacketIn(191);
			GameServer.Instance.LoginServer.SendPacket(packet);
		}

		public static void ChatEntertamentModeGetPoint(PlayerInfo p, int point)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(189);
			gSPacketIn.WriteInt(p.ID);
			gSPacketIn.WriteInt(point);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public static void ChatEntertamentModeUpdatePoint(PlayerInfo p, int point)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(190);
			gSPacketIn.WriteInt(p.ID);
			gSPacketIn.WriteInt(point);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public static List<ItemInfo> CreateRandomPropItem()
		{
			lock (object_0)
			{
				List<ItemInfo> list = new List<ItemInfo>();
				List<int> list2 = new List<int>();
				list2.Add(10455);
				list2.Add(10459);
				list2.Add(10461);
				list2.Add(10450);
				list2.Add(10451);
				list2.Add(10452);
				list2.Add(10453);
				list2.Add(10454);
				list2.Add(10456);
				list2.Add(10457);
				list2.Add(10458);
				list2.Add(10460);
				list2.Add(10462);
				list2.Add(10463);
				list2.Add(10464);
				list2.Add(10465);
				list2.Add(10466);
				list2.Add(10470);
				List<int> list3 = list2;
				Random random = new Random();
				for (int i = 0; i < 3; i++)
				{
					int index = random.Next(0, list3.Count - 1);
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(list3[index]), 1, 105);
					if (ıtemInfo != null)
					{
						list.Add(ıtemInfo);
					}
					list3.RemoveAt(index);
				}
				return list;
			}
		}

		public static ItemInfo GetRandomPropItem(List<ItemInfo> itemsNotSame)
		{
			lock (object_0)
			{
				Random random = new Random();
				List<int> list = new List<int>();
				list.Add(10455);
				list.Add(10459);
				list.Add(10461);
				list.Add(10450);
				list.Add(10451);
				list.Add(10452);
				list.Add(10453);
				list.Add(10454);
				list.Add(10456);
				list.Add(10457);
				list.Add(10458);
				list.Add(10460);
				list.Add(10462);
				list.Add(10463);
				list.Add(10464);
				list.Add(10465);
				list.Add(10466);
				list.Add(10470);
				List<int> list2 = list;
				foreach (ItemInfo item in itemsNotSame)
				{
					if (list2.Contains(item.TemplateID))
					{
						list2.Remove(item.TemplateID);
					}
				}
				int index = random.Next(0, list2.Count - 1);
				return ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(list2[index]), 1, 105);
			}
		}

		public static bool AddPlayer(int playerId, GamePlayer player)
		{
			readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				if (dictionary_0.ContainsKey(playerId))
				{
					return false;
				}
				dictionary_0.Add(playerId, player);
			}
			finally
			{
				readerWriterLock_0.ReleaseWriterLock();
			}
			return true;
		}

		public static bool RemovePlayer(int playerId)
		{
			readerWriterLock_0.AcquireWriterLock(-1);
			GamePlayer gamePlayer = null;
			try
			{
				if (dictionary_0.ContainsKey(playerId))
				{
					gamePlayer = dictionary_0[playerId];
					dictionary_0.Remove(playerId);
				}
			}
			finally
			{
				readerWriterLock_0.ReleaseWriterLock();
			}
			if (gamePlayer == null)
			{
				return false;
			}
			GameServer.Instance.LoginServer.SendUserOffline(playerId, gamePlayer.PlayerCharacter.ConsortiaID);
			return true;
		}

		public static GamePlayer GetPlayerById(int playerId)
		{
			GamePlayer result = null;
			readerWriterLock_0.AcquireReaderLock(-1);
			try
			{
				if (dictionary_0.ContainsKey(playerId))
				{
					result = dictionary_0[playerId];
				}
			}
			finally
			{
				readerWriterLock_0.ReleaseReaderLock();
			}
			return result;
		}

		public static GamePlayer GetClientByPlayerNickName(string nickName)
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.NickName == nickName)
				{
					return gamePlayer;
				}
			}
			return null;
		}

		public static GamePlayer[] GetAllPlayers()
		{
			List<GamePlayer> list = new List<GamePlayer>();
			readerWriterLock_0.AcquireReaderLock(-1);
			try
			{
				foreach (GamePlayer value in dictionary_0.Values)
				{
					if (value != null && value.PlayerCharacter != null)
					{
						list.Add(value);
					}
				}
			}
			finally
			{
				readerWriterLock_0.ReleaseReaderLock();
			}
			return list.ToArray();
		}

		public static GamePlayer[] GetAllPlayersNoGame()
		{
			List<GamePlayer> list = new List<GamePlayer>();
			readerWriterLock_0.AcquireReaderLock(-1);
			try
			{
				GamePlayer[] allPlayers = GetAllPlayers();
				foreach (GamePlayer gamePlayer in allPlayers)
				{
					if (gamePlayer.CurrentRoom == null)
					{
						list.Add(gamePlayer);
					}
				}
			}
			finally
			{
				readerWriterLock_0.ReleaseReaderLock();
			}
			return list.ToArray();
		}

		public static string GetPlayerStringByPlayerNickName(string nickName)
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.NickName == nickName)
				{
					return gamePlayer.ToString();
				}
			}
			return nickName + " is not online!";
		}

		public static string DisconnectPlayerByName(string nickName)
		{
			GamePlayer[] allPlayers = GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.NickName == nickName)
				{
					gamePlayer.Disconnect();
					return "OK";
				}
			}
			return nickName + " is not online!";
		}

		public static void OnPlayerOffline(int playerid, int consortiaID)
		{
			ChangePlayerState(playerid, 0, consortiaID);
		}

		public static void OnPlayerOnline(int playerid, int consortiaID)
		{
			ChangePlayerState(playerid, 1, consortiaID);
		}

		public static void ChangePlayerState(int playerID, int state, int consortiaID)
		{
			GSPacketIn gSPacketIn = null;
			GamePlayer[] allPlayers = GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if ((gamePlayer.Friends != null && gamePlayer.Friends.ContainsKey(playerID) && gamePlayer.Friends[playerID] == 0) || (gamePlayer.PlayerCharacter.ConsortiaID != 0 && gamePlayer.PlayerCharacter.ConsortiaID == consortiaID))
				{
					if (gSPacketIn == null)
					{
						gSPacketIn = gamePlayer.Out.SendFriendState(playerID, state, gamePlayer.PlayerCharacter.typeVIP, gamePlayer.PlayerCharacter.VIPLevel);
					}
					else
					{
						gamePlayer.SendTCP(gSPacketIn);
					}
				}
			}
		}

		static WorldMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			readerWriterLock_0 = new ReaderWriterLock();
			dictionary_0 = new Dictionary<int, GamePlayer>();
			dictionary_1 = new Dictionary<int, Dictionary<int, ItemInfo>>();
			dictionary_2 = new Dictionary<int, AreaConfigInfo>();
			object_0 = new object();
		}
	}
}
