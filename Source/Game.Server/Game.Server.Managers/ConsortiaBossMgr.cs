using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class ConsortiaBossMgr
	{
		private static readonly ILog ilog_0;

		private static Dictionary<int, ConsortiaInfo> dictionary_0;

		public static bool AddConsortia(ConsortiaInfo consortia)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(180);
			gSPacketIn.WriteInt(consortia.ConsortiaID);
			gSPacketIn.WriteInt(consortia.ChairmanID);
			gSPacketIn.WriteByte((byte)consortia.bossState);
			gSPacketIn.WriteDateTime(consortia.endTime);
			gSPacketIn.WriteInt(consortia.extendAvailableNum);
			gSPacketIn.WriteInt(consortia.callBossLevel);
			gSPacketIn.WriteInt(consortia.Level);
			gSPacketIn.WriteInt(consortia.SmithLevel);
			gSPacketIn.WriteInt(consortia.StoreLevel);
			gSPacketIn.WriteInt(consortia.SkillLevel);
			gSPacketIn.WriteInt(consortia.Riches);
			gSPacketIn.WriteDateTime(consortia.LastOpenBoss);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
			return true;
		}

		public static void UpdateRank(int consortiaId, int damage, int richer, int honor, string Nickname, int userID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(181);
			gSPacketIn.WriteInt(consortiaId);
			gSPacketIn.WriteInt(damage);
			gSPacketIn.WriteInt(richer);
			gSPacketIn.WriteInt(honor);
			gSPacketIn.WriteString(Nickname);
			gSPacketIn.WriteInt(userID);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public static void UpdateBlood(int consortiaId, int damage)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(186);
			gSPacketIn.WriteInt(consortiaId);
			gSPacketIn.WriteInt(damage);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public static void reload(int consortiaId)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(184);
			gSPacketIn.WriteInt(consortiaId);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public static void ExtendAvailable(int consortiaId, int riches)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(182);
			gSPacketIn.WriteInt(consortiaId);
			gSPacketIn.WriteInt(riches);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public static void CreateBoss(ConsortiaInfo consortia, int npcId)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(183);
			gSPacketIn.WriteInt(consortia.ConsortiaID);
			gSPacketIn.WriteByte((byte)consortia.bossState);
			gSPacketIn.WriteDateTime(consortia.endTime);
			gSPacketIn.WriteDateTime(consortia.LastOpenBoss);
			int val = 15000000;
			NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcId);
			if (npcInfoById != null)
			{
				val = npcInfoById.Blood;
			}
			gSPacketIn.WriteInt(val);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public static bool GetConsortiaExit(int consortiaId)
		{
			return dictionary_0.ContainsKey(consortiaId);
		}

		public static ConsortiaInfo GetConsortiaById(int consortiaId)
		{
			ConsortiaInfo result = null;
			if (dictionary_0.ContainsKey(consortiaId))
			{
				result = dictionary_0[consortiaId];
			}
			return result;
		}

		public static void SendConsortiaAward(int consortiaId)
		{
			if (!dictionary_0.ContainsKey(consortiaId))
			{
				return;
			}
			ConsortiaInfo consortiaInfo = dictionary_0[consortiaId];
			int num = 50000 + consortiaInfo.callBossLevel;
			List<ItemInfo> info = null;
			DropInventory.CopyAllDrop(num, ref info);
			int riches = 0;
			if (consortiaInfo.RankList == null)
			{
				return;
			}
			foreach (RankingPersonInfo value in consortiaInfo.RankList.Values)
			{
				if (consortiaInfo.IsBossDie)
				{
					string title = "Phần thưởng tham gia Boss Guild";
					if (info != null)
					{
						WorldEventMgr.SendItemsToMail(info, value.UserID, value.Name, title);
					}
					else
					{
						Console.WriteLine("Boss Guild award error dropID {0} ", num);
					}
				}
				riches += value.Damage;
			}
			using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
			consortiaBussiness.ConsortiaRichAdd(consortiaId, ref riches, 5, "Boss Guild");
		}

		public static bool UpdateConsortia(ConsortiaInfo info)
		{
			int consortiaID = info.ConsortiaID;
			if (dictionary_0.ContainsKey(consortiaID))
			{
				dictionary_0[consortiaID] = info;
			}
			return true;
		}

		public static bool AddConsortia(int consortiaId, ConsortiaInfo consortia)
		{
			if (dictionary_0.ContainsKey(consortiaId))
			{
				return false;
			}
			dictionary_0.Add(consortiaId, consortia);
			return true;
		}

		public static long GetConsortiaBossTotalDame(int consortiaId)
		{
			if (dictionary_0.ContainsKey(consortiaId))
			{
				long num = dictionary_0[consortiaId].TotalAllMemberDame;
				long maxBlood = dictionary_0[consortiaId].MaxBlood;
				if (num > maxBlood)
				{
					num = maxBlood - 1000;
				}
				return num;
			}
			return 0L;
		}

		static ConsortiaBossMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			dictionary_0 = new Dictionary<int, ConsortiaInfo>();
		}
	}
}
