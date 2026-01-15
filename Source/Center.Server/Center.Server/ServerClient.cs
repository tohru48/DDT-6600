using Bussiness;
using Bussiness.Protocol;
using Center.Server.Managers;
using Game.Base;
using Game.Base.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Security.Cryptography;
using System.Text;
namespace Center.Server
{
	public class ServerClient : BaseClient
	{
		private static readonly ILog ilog_1;
		private System.Security.Cryptography.RSACryptoServiceProvider rsacryptoServiceProvider_0;
		private CenterServer centerServer_0;
		public bool NeedSyncMacroDrop;
		public ServerInfo Info
		{
			get;
			set;
		}
		protected override void OnConnect()
		{
			base.OnConnect();
			this.rsacryptoServiceProvider_0 = new System.Security.Cryptography.RSACryptoServiceProvider();
			System.Security.Cryptography.RSAParameters rSAParameters = this.rsacryptoServiceProvider_0.ExportParameters(false);
			this.method_6(rSAParameters.Modulus, rSAParameters.Exponent);
		}
		protected override void OnDisconnect()
		{
			base.OnDisconnect();
			this.rsacryptoServiceProvider_0 = null;
			System.Collections.Generic.List<Player> serverPlayers = LoginMgr.GetServerPlayers(this);
			LoginMgr.RemovePlayer(serverPlayers);
			this.SendUserOffline(serverPlayers);
			if (this.Info != null)
			{
				this.Info.State = 1;
				this.Info.Online = 0;
				this.Info = null;
			}
		}
		public override void OnRecvPacket(GSPacketIn pkg)
		{
			short code = pkg.Code;
			if (code <= 91)
			{
				if (code <= 37)
				{
					switch (code)
					{
					case 1:
						this.HandleLogin(pkg);
						return;
					case 2:
					case 7:
					case 8:
					case 9:
					case 16:
					case 17:
					case 18:
						break;
					case 3:
						this.method_2(pkg);
						return;
					case 4:
						this.method_4(pkg);
						return;
					case 5:
						this.method_3(pkg);
						return;
					case 6:
						this.HandleQuestUserState(pkg);
						return;
					case 10:
						this.HandkeItemStrengthen(pkg);
						return;
					case 11:
						this.HandleReload(pkg);
						return;
					case 12:
						this.HandlePing(pkg);
						return;
					case 13:
						this.HandleUpdatePlayerState(pkg);
						return;
					case 14:
						this.HandleMarryRoomInfoToPlayer(pkg);
						return;
					case 15:
						this.HandleShutdown(pkg);
						return;
					case 19:
						this.HandleChatScene(pkg);
						return;
					default:
						if (code != 37)
						{
							return;
						}
						this.HandleChatPersonal(pkg);
						return;
					}
				}
				else
				{
					if (code == 72)
					{
						this.HandleBigBugle(pkg);
						return;
					}
					switch (code)
					{
					case 81:
						this.HandleWorldBossRank(pkg, true);
						return;
					case 82:
						this.HandleWorldBossFightOver(pkg);
						return;
					case 83:
						this.HandleWorldBossRoomClose(pkg);
						return;
					case 84:
						this.HandleWorldBossUpdateBlood(pkg);
						return;
					case 85:
						this.HandleWorldBossPrivateInfo(pkg);
						return;
					case 86:
						this.HandleWorldBossRank(pkg, false);
						return;
					case 87:
					case 88:
					case 89:
						break;
					case 90:
						this.HandleEventRank(pkg);
						return;
					case 91:
						this.HandleWorldEvent(pkg);
						return;
					default:
						return;
					}
				}
			}
			else if (code <= 130)
			{
				if (code == 117)
				{
					this.HandleMailResponse(pkg);
					return;
				}
				switch (code)
				{
				case 128:
					this.HandleConsortiaResponse(pkg);
					return;
				case 129:
					break;
				case 130:
					this.HandleConsortiaCreate(pkg);
					return;
				default:
					return;
				}
			}
			else
			{
				switch (code)
				{
				case 156:
					this.HandleConsortiaOffer(pkg);
					return;
				case 157:
				case 159:
					break;
				case 158:
					this.HandleConsortiaFight(pkg);
					return;
				case 160:
					this.HandleFriend(pkg);
					return;
				default:
					switch (code)
					{
					case 178:
						this.HandleMacroDrop(pkg);
						return;
					case 179:
					case 185:
					case 187:
					case 188:
						break;
					case 180:
						this.HandleRecvConsortiaBossAdd(pkg);
						return;
					case 181:
						this.HandleRecvConsortiaBossUpdateRank(pkg);
						return;
					case 182:
						this.HandleRecvConsortiaBossExtendAvailable(pkg);
						return;
					case 183:
						this.HandleRecvConsortiaBossCreate(pkg);
						return;
					case 184:
						this.HandleRecvConsortiaBossReload(pkg);
						return;
					case 186:
						this.HandleRecvConsortiaBossUpdateBlood(pkg);
						return;
					case 189:
						this.HandleEnterModeGetPoint(pkg);
						return;
					case 190:
						this.HandleEnterModeUpdatePoint(pkg);
						break;
					default:
						if (code != 240)
						{
							return;
						}
						this.HandleIPAndPort(pkg);
						return;
					}
					break;
				}
			}
		}
		public void HandleEnterModeGetPoint(GSPacketIn pkg)
		{
			int id = pkg.ReadInt();
			int point = pkg.ReadInt();
			GSPacketIn gSPacketIn = EntertamentModeMgr.SendGetPoint(id, point);
			this.SendTCP(gSPacketIn);
		}
		public void HandleEnterModeUpdatePoint(GSPacketIn pkg)
		{
			int id = pkg.ReadInt();
			int point = pkg.ReadInt();
			EntertamentModeMgr.UpdatePoint(id, point);
		}
		public void HandleWorldEvent(GSPacketIn pkg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(91);
			switch (pkg.ReadByte())
			{
			case 1:
			{
				LanternriddlesInfo lanternriddlesInfo = new LanternriddlesInfo();
				lanternriddlesInfo.PlayerID = pkg.ReadInt();
				lanternriddlesInfo.QuestionIndex = pkg.ReadInt();
				lanternriddlesInfo.QuestionView = pkg.ReadInt();
				lanternriddlesInfo.EndDate = pkg.ReadDateTime();
				lanternriddlesInfo.DoubleFreeCount = pkg.ReadInt();
				lanternriddlesInfo.DoublePrice = pkg.ReadInt();
				lanternriddlesInfo.HitFreeCount = pkg.ReadInt();
				lanternriddlesInfo.HitPrice = pkg.ReadInt();
				lanternriddlesInfo.MyInteger = pkg.ReadInt();
				lanternriddlesInfo.QuestionNum = pkg.ReadInt();
				lanternriddlesInfo.Option = pkg.ReadInt();
				lanternriddlesInfo.IsHint = pkg.ReadBoolean();
				lanternriddlesInfo.IsDouble = pkg.ReadBoolean();
				WorldMgr.AddOrUpdateLanternriddles(lanternriddlesInfo.PlayerID, lanternriddlesInfo);
				return;
			}
			case 2:
			{
				int playerID = pkg.ReadInt();
				LanternriddlesInfo lanternriddles = WorldMgr.GetLanternriddles(playerID);
				gSPacketIn.WriteByte(2);
				if (lanternriddles == null)
				{
					gSPacketIn.WriteInt(0);
				}
				else
				{
					gSPacketIn.WriteInt(1);
					gSPacketIn.WriteInt(lanternriddles.PlayerID);
					gSPacketIn.WriteInt(lanternriddles.QuestionIndex);
					gSPacketIn.WriteInt(lanternriddles.QuestionView);
					gSPacketIn.WriteDateTime(lanternriddles.EndDate);
					gSPacketIn.WriteInt(lanternriddles.DoubleFreeCount);
					gSPacketIn.WriteInt(lanternriddles.DoublePrice);
					gSPacketIn.WriteInt(lanternriddles.HitFreeCount);
					gSPacketIn.WriteInt(lanternriddles.HitPrice);
					gSPacketIn.WriteInt(lanternriddles.MyInteger);
					gSPacketIn.WriteInt(lanternriddles.QuestionNum);
					gSPacketIn.WriteInt(lanternriddles.Option);
					gSPacketIn.WriteBoolean(lanternriddles.IsHint);
					gSPacketIn.WriteBoolean(lanternriddles.IsDouble);
				}
				this.centerServer_0.method_4(gSPacketIn);
				return;
			}
			default:
				return;
			}
		}
		public void HandleEventRank(GSPacketIn pkg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(90);
			switch (pkg.ReadByte())
			{
			case 1:
			{
				RankingLightriddleInfo rankingLightriddleInfo = null;
				string a = pkg.ReadString();
				int num = pkg.ReadInt();
				gSPacketIn.WriteByte(1);
				System.Collections.Generic.List<RankingLightriddleInfo> list = WorldMgr.SelectTopEight();
				gSPacketIn.WriteInt(list.Count);
				foreach (RankingLightriddleInfo current in list)
				{
					gSPacketIn.WriteInt(current.Rank);
					gSPacketIn.WriteString(current.NickName);
					gSPacketIn.WriteByte((byte)current.TypeVIP);
					gSPacketIn.WriteInt(current.Integer);
					if (a == current.NickName)
					{
						rankingLightriddleInfo = current;
					}
				}
				if (rankingLightriddleInfo == null)
				{
					gSPacketIn.WriteInt(0);
				}
				else
				{
					gSPacketIn.WriteInt(rankingLightriddleInfo.Rank);
				}
				gSPacketIn.WriteInt(num);
				this.centerServer_0.method_4(gSPacketIn);
				return;
			}
			case 2:
			{
				string nickName = pkg.ReadString();
				int typeVip = pkg.ReadInt();
				int integer = pkg.ReadInt();
				int playerId = pkg.ReadInt();
				WorldMgr.UpdateLightriddleRank(integer, typeVip, nickName, playerId);
				return;
			}
			case 3:
				break;
			case 4:
			{
				int playerID = pkg.ReadInt();
				string nickName2 = pkg.ReadString();
				int templateID = pkg.ReadInt();
				int count = pkg.ReadInt();
				int isVip = pkg.ReadInt();
				WorldMgr.UpdateLuckStarRewardRecord(playerID, nickName2, templateID, count, isVip);
				return;
			}
			case 5:
			{
				int iD = pkg.ReadInt();
				string nickName3 = pkg.ReadString();
				int useNum = pkg.ReadInt();
				int isVip2 = pkg.ReadInt();
				WorldMgr.UpdateHalloweenRank(iD, nickName3, useNum, isVip2);
				break;
			}
			default:
				return;
			}
		}
		public void HandleRecvConsortiaBossUpdateBlood(GSPacketIn pkg)
		{
			int consortiaId = pkg.ReadInt();
			int damage = pkg.ReadInt();
			ConsortiaBossMgr.UpdateBlood(consortiaId, damage);
		}
		public void HandleRecvConsortiaBossUpdateRank(GSPacketIn pkg)
		{
			int consortiaId = pkg.ReadInt();
			int damage = pkg.ReadInt();
			int richer = pkg.ReadInt();
			int honor = pkg.ReadInt();
			string nickName = pkg.ReadString();
			int userID = pkg.ReadInt();
			ConsortiaBossMgr.UpdateRank(consortiaId, damage, richer, honor, nickName, userID);
		}
		public void HandleRecvConsortiaBossExtendAvailable(GSPacketIn pkg)
		{
			int consortiaId = pkg.ReadInt();
			int riches = pkg.ReadInt();
			if (ConsortiaBossMgr.ExtendAvailable(consortiaId, riches))
			{
				ConsortiaInfo consortiaById = ConsortiaBossMgr.GetConsortiaById(consortiaId);
				if (consortiaById != null)
				{
					this.HandleSendConsortiaBossInfo(consortiaById, 182);
					return;
				}
			}
			else
			{
				ConsortiaInfo consortiaById2 = ConsortiaBossMgr.GetConsortiaById(consortiaId);
				if (consortiaById2 != null)
				{
					this.HandleSendConsortiaBossInfo(consortiaById2, 184);
				}
			}
		}
		public void HandleRecvConsortiaBossReload(GSPacketIn pkg)
		{
			ConsortiaInfo consortiaById = ConsortiaBossMgr.GetConsortiaById(pkg.ReadInt());
			if (consortiaById != null)
			{
				if (consortiaById.bossState == 2 && consortiaById.SendToClient)
				{
					if (consortiaById.IsBossDie)
					{
						this.HandleSendConsortiaBossInfo(consortiaById, 188);
					}
					else
					{
						this.HandleSendConsortiaBossInfo(consortiaById, 187);
					}
					ConsortiaBossMgr.UpdateSendToClient(consortiaById.ConsortiaID);
					return;
				}
				this.HandleSendConsortiaBossInfo(consortiaById, 184);
			}
		}
		public void HandleRecvConsortiaBossCreate(GSPacketIn pkg)
		{
			int consortiaId = pkg.ReadInt();
			byte bossState = pkg.ReadByte();
			System.DateTime endTime = pkg.ReadDateTime();
			System.DateTime lastOpenBoss = pkg.ReadDateTime();
			long maxBlood = (long)pkg.ReadInt();
			if (ConsortiaBossMgr.UpdateConsortia(consortiaId, (int)bossState, endTime, lastOpenBoss, maxBlood))
			{
				ConsortiaInfo consortiaById = ConsortiaBossMgr.GetConsortiaById(consortiaId);
				if (consortiaById != null)
				{
					this.HandleSendConsortiaBossInfo(consortiaById, 183);
				}
			}
		}
		public void HandleRecvConsortiaBossAdd(GSPacketIn pkg)
		{
			ConsortiaInfo consortiaInfo = new ConsortiaInfo();
			consortiaInfo.ConsortiaID = pkg.ReadInt();
			consortiaInfo.ChairmanID = pkg.ReadInt();
			consortiaInfo.bossState = (int)pkg.ReadByte();
			consortiaInfo.endTime = pkg.ReadDateTime();
			consortiaInfo.extendAvailableNum = pkg.ReadInt();
			consortiaInfo.callBossLevel = pkg.ReadInt();
			consortiaInfo.Level = pkg.ReadInt();
			consortiaInfo.SmithLevel = pkg.ReadInt();
			consortiaInfo.StoreLevel = pkg.ReadInt();
			consortiaInfo.SkillLevel = pkg.ReadInt();
			consortiaInfo.Riches = pkg.ReadInt();
			consortiaInfo.LastOpenBoss = pkg.ReadDateTime();
			if (!ConsortiaBossMgr.AddConsortia(consortiaInfo.ConsortiaID, consortiaInfo))
			{
				consortiaInfo = ConsortiaBossMgr.GetConsortiaById(consortiaInfo.ConsortiaID);
			}
			this.HandleSendConsortiaBossInfo(consortiaInfo, 180);
		}
		public void HandleSendConsortiaBossInfo(ConsortiaInfo consortia, byte code)
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
			gSPacketIn.WriteLong(consortia.MaxBlood);
			gSPacketIn.WriteLong(consortia.TotalAllMemberDame);
			gSPacketIn.WriteBoolean(consortia.IsBossDie);
			System.Collections.Generic.List<RankingPersonInfo> list = ConsortiaBossMgr.SelectRank(consortia.ConsortiaID);
			gSPacketIn.WriteInt(list.Count);
			int num = 1;
			foreach (RankingPersonInfo current in list)
			{
				gSPacketIn.WriteString(current.Name);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(current.TotalDamage);
				gSPacketIn.WriteInt(current.Honor);
				gSPacketIn.WriteInt(current.Damage);
				num++;
			}
			gSPacketIn.WriteByte(code);
			this.centerServer_0.method_4(gSPacketIn);
		}
		public void HandleLogin(GSPacketIn pkg)
		{
			byte[] rgb = pkg.ReadBytes();
			string[] array = System.Text.Encoding.UTF8.GetString(this.rsacryptoServiceProvider_0.Decrypt(rgb, false)).Split(new char[]
			{
				','
			});
			if (array.Length == 2)
			{
				this.rsacryptoServiceProvider_0 = null;
				int num = int.Parse(array[0]);
				this.Info = ServerMgr.GetServerInfo(num);
				if (this.Info != null)
				{
					if (this.Info.State == 1)
					{
						base.Strict = (false);
						CenterServer.Instance.SendConfigState();
						CenterServer.Instance.SendUpdateWorldEvent();
						this.Info.Online = 0;
						this.Info.State = 2;
						return;
					}
				}
				ServerClient.ilog_1.ErrorFormat("Error Login Packet from {0} want to login serverid:{1}", base.TcpEndpoint, num);
				this.Disconnect();
				return;
			}
			ServerClient.ilog_1.ErrorFormat("Error Login Packet from {0}", base.TcpEndpoint);
			this.Disconnect();
		}
		public void HandleIPAndPort(GSPacketIn pkg)
		{
		}
		private void method_2(GSPacketIn gspacketIn_0)
		{
			int num = gspacketIn_0.ReadInt();
			if (LoginMgr.TryLoginPlayer(num, this))
			{
				this.SendAllowUserLogin(num, true);
				return;
			}
			this.SendAllowUserLogin(num, false);
		}
		private void method_3(GSPacketIn gspacketIn_0)
		{
			int num = gspacketIn_0.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int id = gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				LoginMgr.PlayerLogined(id, this);
			}
			this.centerServer_0.method_5(gspacketIn_0, this);
		}
		private void method_4(GSPacketIn gspacketIn_0)
		{
			new System.Collections.Generic.List<int>();
			int num = gspacketIn_0.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int id = gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				LoginMgr.PlayerLoginOut(id, this);
			}
			this.centerServer_0.method_4(gspacketIn_0);
		}
		private void method_5(GSPacketIn gspacketIn_0, int int_1)
		{
			ServerClient serverClient = LoginMgr.GetServerClient(int_1);
			if (serverClient != null)
			{
				serverClient.SendTCP(gspacketIn_0);
			}
		}
		public void HandleUserPublicMsg(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg, this);
		}
		public void HandleQuestUserState(GSPacketIn pkg)
		{
			int num = pkg.ReadInt();
			if (LoginMgr.GetServerClient(num) == null)
			{
				this.SendUserState(num, false);
				return;
			}
			this.SendUserState(num, true);
		}
		public void HandlePing(GSPacketIn pkg)
		{
			this.Info.Online = pkg.ReadInt();
			this.Info.State = ServerMgr.GetState(this.Info.Online, this.Info.Total);
		}
		public void HandleChatPersonal(GSPacketIn pkg)
		{
			this.centerServer_0.method_4(pkg);
		}
		public void HandleBigBugle(GSPacketIn pkg)
		{
			this.centerServer_0.method_4(pkg);
		}
		public void HandleFriend(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg, this);
		}
		public void HandleFriendState(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg, this);
		}
		public void HandleFirendResponse(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg, this);
		}
		public void HandleMailResponse(GSPacketIn pkg)
		{
			int int_ = pkg.ReadInt();
			this.method_5(pkg, int_);
		}
		public void HandleReload(GSPacketIn pkg)
		{
			eReloadType eReloadType = (eReloadType)pkg.ReadInt();
			int num = pkg.ReadInt();
			bool flag = pkg.ReadBoolean();
			System.Console.WriteLine(string.Concat(new object[]
			{
				num,
				" ",
				eReloadType.ToString(),
				" is reload ",
				flag ? "succeed!" : "fail"
			}));
		}
		public void HandleChatScene(GSPacketIn pkg)
		{
			byte b = pkg.ReadByte();
			byte b2 = b;
			if (b2 != 3)
			{
				return;
			}
			this.HandleChatConsortia(pkg);
		}
		public void HandleChatConsortia(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg, this);
		}
		public void HandleConsortiaResponse(GSPacketIn pkg)
		{
			switch (pkg.ReadByte())
			{
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
			case 10:
				this.centerServer_0.method_5(pkg, null);
				return;
			}
		}
		public void HandleConsortiaOffer(GSPacketIn pkg)
		{
			pkg.ReadInt();
			pkg.ReadInt();
			pkg.ReadInt();
		}
		public void HandleBuyBadge(GSPacketIn pkg)
		{
			pkg.ReadInt();
			this.centerServer_0.method_5(pkg, null);
		}
		public void HandleConsortiaCreate(GSPacketIn pkg)
		{
			pkg.ReadInt();
			pkg.ReadInt();
			this.centerServer_0.method_5(pkg, null);
		}
		public void HandleConsortiaUpGrade(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg, this);
		}
		public void HandleConsortiaFight(GSPacketIn pkg)
		{
			this.centerServer_0.method_4(pkg);
		}
		public void HandkeItemStrengthen(GSPacketIn pkg)
		{
			this.centerServer_0.method_5(pkg, this);
		}
		public void HandleUpdatePlayerState(GSPacketIn pkg)
		{
			int playerId = pkg.ReadInt();
			Player player = LoginMgr.GetPlayer(playerId);
			if (player != null && player.CurrentServer != null)
			{
				player.CurrentServer.SendTCP(pkg);
			}
		}
		public void HandleMarryRoomInfoToPlayer(GSPacketIn pkg)
		{
			int playerId = pkg.ReadInt();
			Player player = LoginMgr.GetPlayer(playerId);
			if (player != null && player.CurrentServer != null)
			{
				player.CurrentServer.SendTCP(pkg);
			}
		}
		public void HandleShutdown(GSPacketIn pkg)
		{
			int num = pkg.ReadInt();
			if (pkg.ReadBoolean())
			{
				System.Console.WriteLine(num + "  begin stoping !");
				return;
			}
			System.Console.WriteLine(num + "  is stoped !");
		}
		public void HandleWorldBossUpdateBlood(GSPacketIn pkg)
		{
			int num = pkg.ReadInt();
			if (num > 0)
			{
				WorldMgr.ReduceBlood(num);
			}
			this.centerServer_0.SendUpdateWorldBlood();
		}
		public void HandleWorldBossFightOver(GSPacketIn pkg)
		{
			WorldMgr.WorldBossFightOver();
			this.centerServer_0.SendWorldBossFightOver();
		}
		public void HandleWorldBossRoomClose(GSPacketIn pkg)
		{
			WorldMgr.WorldBossRoomClose();
			this.centerServer_0.SendRoomClose(0);
		}
		public void HandleWorldBossRank(GSPacketIn pkg, bool update)
		{
			if (update)
			{
				int damage = pkg.ReadInt();
				int honor = pkg.ReadInt();
				string nickName = pkg.ReadString();
				WorldMgr.UpdateRank(damage, honor, nickName);
			}
			this.centerServer_0.SendUpdateRank(false);
		}
		public void HandleWorldBossPrivateInfo(GSPacketIn pkg)
		{
			string name = pkg.ReadString();
			this.centerServer_0.SendPrivateInfo(name);
		}
		public void HandleMacroDrop(GSPacketIn pkg)
		{
			System.Collections.Generic.Dictionary<int, int> dictionary = new System.Collections.Generic.Dictionary<int, int>();
			int num = pkg.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int key = pkg.ReadInt();
				int value = pkg.ReadInt();
				dictionary.Add(key, value);
			}
			MacroDropMgr.DropNotice(dictionary);
			this.NeedSyncMacroDrop = true;
		}
		public void method_6(byte[] m, byte[] e)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(0);
			gSPacketIn.Write(m);
			gSPacketIn.Write(e);
			this.SendTCP(gSPacketIn);
		}
		public void SendAllowUserLogin(int playerid, bool allow)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(3);
			gSPacketIn.WriteInt(playerid);
			gSPacketIn.WriteBoolean(allow);
			this.SendTCP(gSPacketIn);
		}
		public void SendKitoffUser(int playerid)
		{
			this.SendKitoffUser(playerid, LanguageMgr.GetTranslation("Center.Server.SendKitoffUser", new object[0]));
		}
		public void SendKitoffUser(int playerid, string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(2);
			gSPacketIn.WriteInt(playerid);
			gSPacketIn.WriteString(msg);
			this.SendTCP(gSPacketIn);
		}
		public void SendUserOffline(System.Collections.Generic.List<Player> users)
		{
			for (int i = 0; i < users.Count; i += 100)
			{
				int num = (i + 100 > users.Count) ? (users.Count - i) : 100;
				GSPacketIn gSPacketIn = new GSPacketIn(4);
				gSPacketIn.WriteInt(num);
				for (int j = i; j < i + num; j++)
				{
					gSPacketIn.WriteInt(users[j].Id);
					gSPacketIn.WriteInt(0);
				}
				this.SendTCP(gSPacketIn);
				this.centerServer_0.method_5(gSPacketIn, this);
			}
		}
		public void SendUserState(int player, bool state)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(6, player);
			gSPacketIn.WriteBoolean(state);
			this.SendTCP(gSPacketIn);
		}
		public void SendChargeMoney(int player, string chargeID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(9, player);
			gSPacketIn.WriteString(chargeID);
			this.SendTCP(gSPacketIn);
		}
		public void SendASS(bool state)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(7);
			gSPacketIn.WriteBoolean(state);
			this.SendTCP(gSPacketIn);
		}
		public ServerClient(CenterServer svr) : base(new byte[8192], new byte[8192])
		{
			
			
			this.centerServer_0 = svr;
		}
		static ServerClient()
		{
			
			ServerClient.ilog_1 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
