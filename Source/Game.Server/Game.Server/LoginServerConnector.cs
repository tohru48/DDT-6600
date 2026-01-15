using System;
using System.Collections.Generic;
using System.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Bussiness.Protocol;
using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.Rooms;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server
{
	public class LoginServerConnector : BaseConnector
	{
		private static readonly ILog ilog_2;

		private int int_1;

		private string string_0;

		private Timer timer_1;

		private int int_2;

		protected override void OnDisconnect()
		{
			base.OnDisconnect();
		}

		public override void OnRecvPacket(GSPacketIn pkg)
		{
			ThreadPool.QueueUserWorkItem(AsynProcessPacket, pkg);
		}

		protected void AsynProcessPacket(object state)
		{
			try
			{
				GSPacketIn gSPacketIn = state as GSPacketIn;
				switch (gSPacketIn.Code)
				{
				case 0:
					HandleRSAKey(gSPacketIn);
					break;
				case 2:
					HandleKitoffPlayer(gSPacketIn);
					break;
				case 3:
					HandleAllowUserLogin(gSPacketIn);
					break;
				case 4:
					HandleUserOffline(gSPacketIn);
					break;
				case 5:
					HandleUserOnline(gSPacketIn);
					break;
				case 7:
					HandleASSState(gSPacketIn);
					break;
				case 8:
					HandleConfigState(gSPacketIn);
					break;
				case 9:
					HandleChargeMoney(gSPacketIn);
					break;
				case 10:
					HandleSystemNotice(gSPacketIn);
					break;
				case 13:
					HandleUpdatePlayerMarriedState(gSPacketIn);
					break;
				case 14:
					HandleMarryRoomInfoToPlayer(gSPacketIn);
					break;
				case 15:
					HandleShutdown(gSPacketIn);
					break;
				case 19:
					HandleChatConsortia(gSPacketIn);
					break;
				case 37:
					HandleChatPersonal(gSPacketIn);
					break;
				case 38:
					HandleSysMess(gSPacketIn);
					break;
				case 72:
				case 73:
					HandleBigBugle(gSPacketIn);
					break;
				case 79:
					HandleWorldBossUpdateBlood(gSPacketIn);
					break;
				case 80:
					HandleWorldBossUpdate(gSPacketIn);
					break;
				case 81:
					HandleWorldBossRank(gSPacketIn);
					break;
				case 82:
					HandleWorldBossFightOver(gSPacketIn);
					break;
				case 83:
					HandleWorldBossRoomClose(gSPacketIn);
					break;
				case 85:
					HandleWorldBossPrivateInfo(gSPacketIn);
					break;
				case 87:
					HandleLeagueOpenClose(gSPacketIn);
					break;
				case 88:
					HandleBattleGoundOpenClose(gSPacketIn);
					break;
				case 89:
					HandleFightFootballTime(gSPacketIn);
					break;
				case 90:
					HandleEventRank(gSPacketIn);
					break;
				case 91:
					HandleWorldEvent(gSPacketIn);
					break;
				case 117:
					HandleMailResponse(gSPacketIn);
					break;
				case 107:
					HandleChatAreaPersonal(gSPacketIn);
					break;
				case 128:
					HandleConsortiaResponse(gSPacketIn);
					break;
				case 130:
					HandleConsortiaCreate(gSPacketIn);
					break;
				case 158:
					HandleConsortiaFight(gSPacketIn);
					break;
				case 160:
					HandleFriend(gSPacketIn);
					break;
				case 177:
					HandleRate(gSPacketIn);
					break;
				case 178:
					HandleMacroDrop(gSPacketIn);
					break;
				case 180:
					HandleConsortiaBossInfo(gSPacketIn);
					break;
				case 243:
					HandleRemote(gSPacketIn);
					break;
				case 189:
					HandleEnterModeGetPoint(gSPacketIn);
					break;
				case 185:
					HandleConsortiaBossSendAward(gSPacketIn);
					break;
				}
			}
			catch (Exception exception)
			{
				GameServer.log.Error("AsynProcessPacket", exception);
			}
		}

		public void HandleEnterModeGetPoint(GSPacketIn pkg)
		{
			int playerId = pkg.ReadInt();
			GamePlayer playerById = WorldMgr.GetPlayerById(playerId);
			if (playerById != null)
			{
				playerById.Actives.Info.EntertamentPoint = pkg.ReadInt();
			}
		}

		public void HandleRemote(GSPacketIn pkg)
		{
			if (!GameProperties.RemoteEnable)
			{
				return;
			}
			using RemoteBussiness remoteBussiness = new RemoteBussiness();
			int num = pkg.ReadInt();
			string text = pkg.ReadString();
			RemoteServerInfo singleServer = remoteBussiness.GetSingleServer(num);
			string text2;
			if (singleServer != null && singleServer.ZoneID == GameServer.Instance.Configuration.AreaId && (text2 = text) != null)
			{
				if (!(text2 == "Close"))
				{
					if (text2 == "Shutdown")
					{
						int_2 = 6;
						timer_1 = new Timer(method_4, null, 0, 60000);
					}
				}
				else
				{
					remoteBussiness.UpdateServer(num, 0, "Stopped");
					GameServer.Instance.Stop();
				}
			}
			if (singleServer == null && num == -1)
			{
				method_3(text);
			}
		}

		private void method_3(string string_1)
		{
			switch (string_1)
			{
			case "ball":
				if (BallMgr.ReLoad())
				{
					Console.WriteLine("Ball info is Reload!");
				}
				else
				{
					Console.WriteLine("Ball info is Error!");
				}
				break;
			case "map":
				if (MapMgr.ReLoadMap())
				{
					Console.WriteLine("Map info is Reload!");
				}
				else
				{
					Console.WriteLine("Map info is Error!");
				}
				break;
			case "mapserver":
				if (MapMgr.ReLoadMapServer())
				{
					Console.WriteLine("mapserver info is Reload!");
				}
				else
				{
					Console.WriteLine("mapserver info is Error!");
				}
				break;
			case "prop":
				if (PropItemMgr.Reload())
				{
					Console.WriteLine("prop info is Reload!");
				}
				else
				{
					Console.WriteLine("prop info is Error!");
				}
				break;
			case "item":
				if (ItemMgr.ReLoad())
				{
					Console.WriteLine("item info is Reload!");
				}
				else
				{
					Console.WriteLine("item info is Error!");
				}
				break;
			case "shop":
				if (ShopMgr.ReLoad())
				{
					Console.WriteLine("shop info is Reload!");
				}
				else
				{
					Console.WriteLine("shop info is Error!");
				}
				break;
			case "quest":
				if (QuestMgr.ReLoad())
				{
					Console.WriteLine("quest info is Reload!");
				}
				else
				{
					Console.WriteLine("quest info is Error!");
				}
				break;
			case "fusion":
				if (FusionMgr.ReLoad())
				{
					Console.WriteLine("fusion info is Reload!");
				}
				else
				{
					Console.WriteLine("fusion info is Error!");
				}
				break;
			case "consortia":
				if (ConsortiaMgr.ReLoad())
				{
					Console.WriteLine("consortiaMgr info is Reload!");
				}
				else
				{
					Console.WriteLine("consortiaMgr info is Error!");
				}
				break;
			case "rate":
				if (RateMgr.ReLoad())
				{
					Console.WriteLine("Rate Rate is Reload!");
				}
				else
				{
					Console.WriteLine("Rate Rate is Error!");
				}
				break;
			case "npc":
				if (NPCInfoMgr.ReLoad())
				{
					Console.WriteLine("NPCInfo is Reload!");
				}
				else
				{
					Console.WriteLine("NPCInfo is Error!");
				}
				break;
			case "fight":
				if (FightRateMgr.ReLoad())
				{
					Console.WriteLine("FightRateMgr is Reload!");
				}
				else
				{
					Console.WriteLine("FightRateMgr is Error!");
				}
				break;
			case "dailyaward":
				if (AwardMgr.ReLoad())
				{
					Console.WriteLine("dailyaward is Reload!");
				}
				else
				{
					Console.WriteLine("dailyaward is Error!");
				}
				break;
			case "language":
				if (LanguageMgr.Reload(""))
				{
					Console.WriteLine("language is Reload!");
				}
				else
				{
					Console.WriteLine("language is Error!");
				}
				break;
			}
		}

		private void method_4(object object_0)
		{
			int_2--;
			string text = $"Server will shutdown after {int_2} mins!";
			Console.WriteLine(text);
			string message = string.Format("{0}{1}{2}", LanguageMgr.GetTranslation("Game.Service.actions.ShutDown1"), int_2, LanguageMgr.GetTranslation("Game.Service.actions.ShutDown2"));
			GameClient[] allClients = GameServer.Instance.GetAllClients();
			GameClient[] array = allClients;
			foreach (GameClient gameClient in array)
			{
				if (gameClient.Out != null)
				{
					gameClient.Out.SendMessage(eMessageType.Normal, message);
				}
			}
			using RemoteBussiness remoteBussiness = new RemoteBussiness();
			if (int_2 == 0)
			{
				timer_1.Dispose();
				timer_1 = null;
				remoteBussiness.UpdateServer(GameServer.Instance.Configuration.Port, 0, "Stopped");
				GameServer.Instance.Stop();
				Console.WriteLine("Server has stopped!");
			}
			else
			{
				remoteBussiness.UpdateServer(GameServer.Instance.Configuration.Port, 5, text);
			}
		}

		public void HandleWorldEvent(GSPacketIn pkg)
		{
			byte b = pkg.ReadByte();
			byte b2 = b;
			if (b2 == 2 && pkg.ReadInt() == 1)
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
				ActiveSystemMgr.AddOrUpdateLanternriddles(lanternriddlesInfo.PlayerID, lanternriddlesInfo);
			}
		}

		public GSPacketIn SendGetLightriddleInfo(int playerID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(91);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(playerID);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendLightriddleInfo(LanternriddlesInfo Lanternriddles)
		{
			if (Lanternriddles != null)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(91);
				gSPacketIn.WriteByte(1);
				gSPacketIn.WriteInt(Lanternriddles.PlayerID);
				gSPacketIn.WriteInt(Lanternriddles.QuestionIndex);
				gSPacketIn.WriteInt(Lanternriddles.QuestionView);
				gSPacketIn.WriteDateTime(Lanternriddles.EndDate);
				gSPacketIn.WriteInt(Lanternriddles.DoubleFreeCount);
				gSPacketIn.WriteInt(Lanternriddles.DoublePrice);
				gSPacketIn.WriteInt(Lanternriddles.HitFreeCount);
				gSPacketIn.WriteInt(Lanternriddles.HitPrice);
				gSPacketIn.WriteInt(Lanternriddles.MyInteger);
				gSPacketIn.WriteInt(Lanternriddles.QuestionNum);
				gSPacketIn.WriteInt(Lanternriddles.Option);
				gSPacketIn.WriteBoolean(Lanternriddles.IsHint);
				gSPacketIn.WriteBoolean(Lanternriddles.IsDouble);
				SendTCP(gSPacketIn);
			}
		}

		public GSPacketIn SendLightriddleRank(string Nickname, int PlayeID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(90);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteString(Nickname);
			gSPacketIn.WriteInt(PlayeID);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendLightriddleUpateRank(int Integer, PlayerInfo player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(90);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteString(player.NickName);
			gSPacketIn.WriteInt(player.typeVIP);
			gSPacketIn.WriteInt(Integer);
			gSPacketIn.WriteInt(player.ID);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendLuckStarRewardRecord(int PlayerID, string nickName, int TemplateID, int Count, int isVip)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(90);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(PlayerID);
			gSPacketIn.WriteString(nickName);
			gSPacketIn.WriteInt(TemplateID);
			gSPacketIn.WriteInt(Count);
			gSPacketIn.WriteInt(isVip);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendHalloweenRank(int PlayerID, string nickName, int useNum, int isVip)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(90);
			gSPacketIn.WriteByte(5);
			gSPacketIn.WriteInt(PlayerID);
			gSPacketIn.WriteString(nickName);
			gSPacketIn.WriteInt(useNum);
			gSPacketIn.WriteInt(isVip);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void HandleEventRank(GSPacketIn pkg)
		{
			switch (pkg.ReadByte())
			{
			case 5:
				ActiveSystemMgr.ReloadHalloweenRank();
				break;
			case 1:
			{
				List<RankingLightriddleInfo> list = new List<RankingLightriddleInfo>();
				int num = pkg.ReadInt();
				for (int i = 0; i < num; i++)
				{
					list.Add(new RankingLightriddleInfo
					{
						Rank = pkg.ReadInt(),
						NickName = pkg.ReadString(),
						TypeVIP = pkg.ReadByte(),
						Integer = pkg.ReadInt()
					});
				}
				int myRank = pkg.ReadInt();
				int playerId = pkg.ReadInt();
				WorldMgr.GetPlayerById(playerId)?.Actives.SendLightriddleRank(myRank, list);
				break;
			}
			}
		}

		public void HandleConsortiaBossSendAward(GSPacketIn pkg)
		{
			int num = pkg.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int consortiaId = pkg.ReadInt();
				ConsortiaBossMgr.SendConsortiaAward(consortiaId);
			}
		}

		public void HandleConsortiaBossInfo(GSPacketIn pkg)
		{
			ConsortiaInfo consortiaInfo = new ConsortiaInfo();
			consortiaInfo.ConsortiaID = pkg.ReadInt();
			consortiaInfo.ChairmanID = pkg.ReadInt();
			consortiaInfo.bossState = pkg.ReadByte();
			consortiaInfo.endTime = pkg.ReadDateTime();
			consortiaInfo.extendAvailableNum = pkg.ReadInt();
			consortiaInfo.callBossLevel = pkg.ReadInt();
			consortiaInfo.Level = pkg.ReadInt();
			consortiaInfo.SmithLevel = pkg.ReadInt();
			consortiaInfo.StoreLevel = pkg.ReadInt();
			consortiaInfo.SkillLevel = pkg.ReadInt();
			consortiaInfo.Riches = pkg.ReadInt();
			consortiaInfo.LastOpenBoss = pkg.ReadDateTime();
			consortiaInfo.MaxBlood = pkg.ReadLong();
			consortiaInfo.TotalAllMemberDame = pkg.ReadLong();
			consortiaInfo.IsBossDie = pkg.ReadBoolean();
			consortiaInfo.RankList = new Dictionary<string, RankingPersonInfo>();
			int num = pkg.ReadInt();
			for (int i = 0; i < num; i++)
			{
				RankingPersonInfo rankingPersonInfo = new RankingPersonInfo();
				rankingPersonInfo.Name = pkg.ReadString();
				rankingPersonInfo.ID = pkg.ReadInt();
				rankingPersonInfo.TotalDamage = pkg.ReadInt();
				rankingPersonInfo.Honor = pkg.ReadInt();
				rankingPersonInfo.Damage = pkg.ReadInt();
				consortiaInfo.RankList.Add(rankingPersonInfo.Name, rankingPersonInfo);
			}
			switch (pkg.ReadByte())
			{
			case 180:
				SendToAllConsortiaMember(consortiaInfo, -1);
				break;
			case 181:
			case 185:
			case 186:
				break;
			case 182:
				HandleConsortiaBossExtendAvailable(consortiaInfo);
				break;
			case 183:
				HandleConsortiaBossCreateBoss(consortiaInfo);
				break;
			case 184:
				HandleConsortiaBossReload(consortiaInfo);
				break;
			case 187:
				HandleConsortiaBossClose(consortiaInfo);
				break;
			case 188:
				HandleConsortiaBossDie(consortiaInfo);
				break;
			}
		}

		public void HandleConsortiaBossExtendAvailable(ConsortiaInfo consortia)
		{
			SendToAllConsortiaMember(consortia, 3);
		}

		public void HandleConsortiaBossReload(ConsortiaInfo consortia)
		{
			SendToAllConsortiaMember(consortia, -1);
		}

		public void HandleConsortiaBossCreateBoss(ConsortiaInfo consortia)
		{
			SendToAllConsortiaMember(consortia, 0);
		}

		public void HandleConsortiaBossClose(ConsortiaInfo consortia)
		{
			SendToAllConsortiaMember(consortia, 1);
		}

		public void HandleConsortiaBossDie(ConsortiaInfo consortia)
		{
			SendToAllConsortiaMember(consortia, 2);
		}

		public void SendToAllConsortiaMember(ConsortiaInfo consortia, int type)
		{
			if (!ConsortiaBossMgr.AddConsortia(consortia.ConsortiaID, consortia))
			{
				ConsortiaBossMgr.UpdateConsortia(consortia);
			}
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == consortia.ConsortiaID)
				{
					gamePlayer.SendConsortiaBossInfo(consortia);
					switch (type)
					{
					case 0:
						gamePlayer.SendConsortiaBossOpenClose(0);
						break;
					case 1:
						gamePlayer.SendConsortiaBossOpenClose(1);
						break;
					case 2:
						gamePlayer.SendConsortiaBossOpenClose(2);
						break;
					case 3:
						gamePlayer.SendConsortiaBossOpenClose(3);
						break;
					}
				}
			}
		}

		protected void HandleRSAKey(GSPacketIn packet)
		{
			RSAParameters parameters = new RSAParameters
			{
				Modulus = packet.ReadBytes(128),
				Exponent = packet.ReadBytes()
			};
			RSACryptoServiceProvider rSACryptoServiceProvider = new RSACryptoServiceProvider();
			rSACryptoServiceProvider.ImportParameters(parameters);
			SendRSALogin(rSACryptoServiceProvider, string_0);
			SendListenIPPort(IPAddress.Parse(GameServer.Instance.Configuration.Ip), GameServer.Instance.Configuration.Port);
		}

		protected void HandleKitoffPlayer(object stateInfo)
		{
			try
			{
				GSPacketIn gSPacketIn = (GSPacketIn)stateInfo;
				int num = gSPacketIn.ReadInt();
				GamePlayer playerById = WorldMgr.GetPlayerById(num);
				if (playerById != null)
				{
					string msg = gSPacketIn.ReadString();
					playerById.Out.SendKitoff(msg);
					playerById.Client.Disconnect();
				}
				else
				{
					SendUserOffline(num, 0);
				}
			}
			catch (Exception exception)
			{
				GameServer.log.Error("HandleKitoffPlayer", exception);
			}
		}

		protected void HandleAllowUserLogin(object stateInfo)
		{
			try
			{
				GSPacketIn gSPacketIn = (GSPacketIn)stateInfo;
				int num = gSPacketIn.ReadInt();
				if (!gSPacketIn.ReadBoolean())
				{
					return;
				}
				GamePlayer gamePlayer = LoginMgr.LoginClient(num);
				if (gamePlayer != null)
				{
					if (gamePlayer.Login())
					{
						SendUserOnline(num, gamePlayer.PlayerCharacter.ConsortiaID);
						WorldMgr.OnPlayerOnline(num, gamePlayer.PlayerCharacter.ConsortiaID);
					}
					else
					{
						gamePlayer.Client.Disconnect();
						SendUserOffline(num, 0);
					}
				}
				else
				{
					SendUserOffline(num, 0);
				}
			}
			catch (Exception exception)
			{
				GameServer.log.Error("HandleAllowUserLogin", exception);
			}
		}

		protected void HandleUserOffline(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int num2 = packet.ReadInt();
				int consortiaID = packet.ReadInt();
				if (LoginMgr.ContainsUser(num2))
				{
					SendAllowUserLogin(num2);
				}
				WorldMgr.OnPlayerOffline(num2, consortiaID);
			}
		}

		protected void HandleUserOnline(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int num2 = packet.ReadInt();
				int consortiaID = packet.ReadInt();
				LoginMgr.ClearLoginPlayer(num2);
				GamePlayer playerById = WorldMgr.GetPlayerById(num2);
				if (playerById != null)
				{
					GameServer.log.Error("Player hang in server!!!");
					playerById.Out.SendKitoff(LanguageMgr.GetTranslation("Game.Server.LoginNext"));
					playerById.Client.Disconnect();
				}
				WorldMgr.OnPlayerOnline(num2, consortiaID);
			}
		}

		protected void HandleChatPersonal(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			string text = packet.ReadString();
			string text2 = packet.ReadString();
			string msg = packet.ReadString();
			bool isAutoReply = packet.ReadBoolean();
			GamePlayer clientByPlayerNickName = WorldMgr.GetClientByPlayerNickName(text);
			GamePlayer clientByPlayerNickName2 = WorldMgr.GetClientByPlayerNickName(text2);
			if (clientByPlayerNickName != null)
			{
				int ıD = clientByPlayerNickName2.PlayerCharacter.ID;
				if (!clientByPlayerNickName.IsBlackFriend(ıD))
				{
					num = clientByPlayerNickName.PlayerCharacter.ID;
					clientByPlayerNickName.SendPrivateChat(num, text, text2, msg, isAutoReply);
				}
			}
		}

		protected void HandleChatAreaPersonal(GSPacketIn packet)
		{
			int zoneId = packet.ReadInt();
			string msg = packet.ReadString();
			string nickName = packet.ReadString();
			string sender = packet.ReadString();
			AreaConfigInfo areaConfigInfo = WorldMgr.FindAreaConfig(zoneId);
			if (areaConfigInfo != null)
			{
				WorldMgr.GetClientByPlayerNickName(nickName)?.SendAreaPrivateChat(sender, areaConfigInfo.AreaName, msg, areaConfigInfo.AreaID);
			}
		}

		protected void HandleBigBugle(GSPacketIn packet)
		{
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer.Out.SendTCP(packet);
			}
		}

		public void HandleFriend(GSPacketIn pkg)
		{
			switch (pkg.ReadByte())
			{
			case 165:
				HandleFriendState(pkg);
				break;
			case 166:
				HandleFirendResponse(pkg);
				break;
			}
		}

		public void HandleFriendState(GSPacketIn pkg)
		{
			WorldMgr.ChangePlayerState(pkg.ClientID, pkg.ReadInt(), pkg.ReadInt());
		}

		public void HandleFirendResponse(GSPacketIn packet)
		{
			int playerId = packet.ReadInt();
			WorldMgr.GetPlayerById(playerId)?.Out.SendTCP(packet);
		}

		public void HandleMailResponse(GSPacketIn packet)
		{
			int playerId = packet.ReadInt();
			WorldMgr.GetPlayerById(playerId)?.Out.SendTCP(packet);
		}

		public void HandleReload(GSPacketIn packet)
		{
			eReloadType eReloadType = (eReloadType)packet.ReadInt();
			bool val = false;
			switch (eReloadType)
			{
			case eReloadType.ball:
				val = BallMgr.ReLoad();
				break;
			case eReloadType.map:
				val = MapMgr.ReLoadMap();
				break;
			case eReloadType.mapserver:
				val = MapMgr.ReLoadMapServer();
				break;
			case eReloadType.item:
				val = ItemMgr.ReLoad();
				break;
			case eReloadType.quest:
				val = QuestMgr.ReLoad();
				break;
			case eReloadType.fusion:
				val = FusionMgr.ReLoad();
				break;
			case eReloadType.server:
				GameServer.Instance.Configuration.Refresh();
				break;
			case eReloadType.rate:
				val = RateMgr.ReLoad();
				break;
			case eReloadType.consortia:
				val = ConsortiaMgr.ReLoad();
				break;
			case eReloadType.shop:
				val = ShopMgr.ReLoad();
				break;
			case eReloadType.fight:
				val = FightRateMgr.ReLoad();
				break;
			case eReloadType.dailyaward:
				val = AwardMgr.ReLoad();
				break;
			case eReloadType.language:
				val = LanguageMgr.Reload("");
				break;
			}
			packet.WriteInt(GameServer.Instance.Configuration.ServerID);
			packet.WriteBoolean(val);
			SendTCP(packet);
		}

		public void HandleChargeMoney(GSPacketIn packet)
		{
			int clientID = packet.ClientID;
			WorldMgr.GetPlayerById(clientID)?.ChargeToUser();
		}

		public void HandleSystemNotice(GSPacketIn packet)
		{
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer.Out.SendTCP(packet);
			}
		}

		public void HandleASSState(GSPacketIn packet)
		{
			bool result;
			Class12.smethod_0(result = packet.ReadBoolean());
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer.Out.SendAASControl(result, gamePlayer.Boolean_0, gamePlayer.IsMinor);
			}
		}

		public void HandleConfigState(GSPacketIn packet)
		{
			bool result = packet.ReadBoolean();
			AwardMgr.DailyAwardState = packet.ReadBoolean();
			Class12.smethod_0(result);
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				gamePlayer.Out.SendAASControl(result, gamePlayer.Boolean_0, gamePlayer.IsMinor);
			}
		}

		public void HandleSysMess(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = num;
			if (num2 == 1)
			{
				int playerId = packet.ReadInt();
				string text = packet.ReadString();
				WorldMgr.GetPlayerById(playerId)?.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("LoginServerConnector.HandleSysMess.Msg1", text));
			}
		}

		protected void HandleChatConsortia(GSPacketIn packet)
		{
			packet.ReadByte();
			packet.ReadBoolean();
			packet.ReadString();
			packet.ReadString();
			int num = packet.ReadInt();
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		protected void HandleConsortiaResponse(GSPacketIn packet)
		{
			switch (packet.ReadByte())
			{
			case 1:
				HandleConsortiaUserPass(packet);
				break;
			case 2:
				HandleConsortiaDelete(packet);
				break;
			case 3:
				HandleConsortiaUserDelete(packet);
				break;
			case 4:
				HandleConsortiaUserInvite(packet);
				break;
			case 5:
				HandleConsortiaBanChat(packet);
				break;
			case 6:
				HandleConsortiaUpGrade(packet);
				break;
			case 7:
				HandleConsortiaAlly(packet);
				break;
			case 8:
				HandleConsortiaDuty(packet);
				break;
			case 9:
				HandleConsortiaRichesOffer(packet);
				break;
			case 10:
				HandleConsortiaShopUpGrade(packet);
				break;
			case 11:
				HandleConsortiaSmithUpGrade(packet);
				break;
			case 12:
				HandleConsortiaStoreUpGrade(packet);
				break;
			}
		}

		public void HandleConsortiaFight(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			packet.ReadInt();
			string message = packet.ReadString();
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num)
				{
					gamePlayer.Out.SendMessage(eMessageType.ChatNormal, message);
				}
			}
		}

		public void HandleConsortiaCreate(GSPacketIn packet)
		{
			int consortiaID = packet.ReadInt();
			packet.ReadInt();
			ConsortiaMgr.AddConsortia(consortiaID);
		}

		public void HandleConsortiaUserPass(GSPacketIn packet)
		{
			packet.ReadInt();
			packet.ReadBoolean();
			int num = packet.ReadInt();
			string consortiaName = packet.ReadString();
			int num2 = packet.ReadInt();
			packet.ReadString();
			packet.ReadInt();
			packet.ReadString();
			packet.ReadInt();
			string dutyName = packet.ReadString();
			packet.ReadInt();
			packet.ReadInt();
			packet.ReadInt();
			packet.ReadDateTime();
			packet.ReadInt();
			int dutyLevel = packet.ReadInt();
			packet.ReadInt();
			packet.ReadBoolean();
			int right = packet.ReadInt();
			packet.ReadInt();
			packet.ReadInt();
			packet.ReadInt();
			int consortiaRepute = packet.ReadInt();
			packet.ReadString();
			packet.ReadInt();
			packet.ReadInt();
			packet.ReadString();
			packet.ReadInt();
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ID == num2)
				{
					gamePlayer.BeginChanges();
					gamePlayer.PlayerCharacter.ConsortiaID = num;
					gamePlayer.PlayerCharacter.ConsortiaName = consortiaName;
					gamePlayer.PlayerCharacter.DutyName = dutyName;
					gamePlayer.PlayerCharacter.DutyLevel = dutyLevel;
					gamePlayer.PlayerCharacter.Right = right;
					gamePlayer.PlayerCharacter.ConsortiaRepute = consortiaRepute;
					ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(num);
					if (consortiaInfo != null)
					{
						gamePlayer.PlayerCharacter.ConsortiaLevel = consortiaInfo.Level;
					}
					gamePlayer.CommitChanges();
				}
				if (gamePlayer.PlayerCharacter.ConsortiaID == num)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleConsortiaDelete(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num)
				{
					gamePlayer.ClearConsortia();
					gamePlayer.AddRobRiches(-gamePlayer.PlayerCharacter.RichesRob);
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleConsortiaUserDelete(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num2 || gamePlayer.PlayerCharacter.ID == num)
				{
					if (gamePlayer.PlayerCharacter.ID == num)
					{
						gamePlayer.ClearConsortia();
					}
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleConsortiaUserInvite(GSPacketIn packet)
		{
			packet.ReadInt();
			int num = packet.ReadInt();
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ID == num)
				{
					gamePlayer.Out.SendTCP(packet);
					break;
				}
			}
		}

		public void HandleConsortiaBanChat(GSPacketIn packet)
		{
			bool ısBanChat = packet.ReadBoolean();
			int num = packet.ReadInt();
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ID == num)
				{
					gamePlayer.PlayerCharacter.IsBanChat = ısBanChat;
					gamePlayer.Out.SendTCP(packet);
					break;
				}
			}
		}

		public void HandleConsortiaUpGrade(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			packet.ReadString();
			int consortiaLevel = packet.ReadInt();
			ConsortiaMgr.ConsortiaUpGrade(num, consortiaLevel);
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num)
				{
					gamePlayer.PlayerCharacter.ConsortiaLevel = consortiaLevel;
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleConsortiaStoreUpGrade(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			packet.ReadString();
			int storeLevel = packet.ReadInt();
			ConsortiaMgr.ConsortiaStoreUpGrade(num, storeLevel);
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num)
				{
					gamePlayer.PlayerCharacter.StoreLevel = storeLevel;
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleConsortiaShopUpGrade(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			packet.ReadString();
			int shopLevel = packet.ReadInt();
			ConsortiaMgr.ConsortiaShopUpGrade(num, shopLevel);
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num)
				{
					gamePlayer.PlayerCharacter.ShopLevel = shopLevel;
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleConsortiaSmithUpGrade(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			packet.ReadString();
			int smithLevel = packet.ReadInt();
			ConsortiaMgr.ConsortiaSmithUpGrade(num, smithLevel);
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num)
				{
					gamePlayer.PlayerCharacter.SmithLevel = smithLevel;
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleConsortiaAlly(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			int state = packet.ReadInt();
			ConsortiaMgr.UpdateConsortiaAlly(num, num2, state);
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num || gamePlayer.PlayerCharacter.ConsortiaID == num2)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleConsortiaDuty(GSPacketIn packet)
		{
			int num = packet.ReadByte();
			int num2 = packet.ReadInt();
			int num3 = packet.ReadInt();
			packet.ReadString();
			int num4 = packet.ReadInt();
			string dutyName = packet.ReadString();
			int right = packet.ReadInt();
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num2)
				{
					if (num == 2 && gamePlayer.PlayerCharacter.DutyLevel == num4)
					{
						gamePlayer.PlayerCharacter.DutyName = dutyName;
					}
					else if (gamePlayer.PlayerCharacter.ID == num3 && (num == 5 || num == 6 || num == 7 || num == 8 || num == 9))
					{
						gamePlayer.PlayerCharacter.DutyLevel = num4;
						gamePlayer.PlayerCharacter.DutyName = dutyName;
						gamePlayer.PlayerCharacter.Right = right;
					}
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleRate(GSPacketIn packet)
		{
			RateMgr.ReLoad();
		}

		public void HandleConsortiaRichesOffer(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			GamePlayer[] array = allPlayers;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer.PlayerCharacter.ConsortiaID == num)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
		}

		public void HandleUpdatePlayerMarriedState(GSPacketIn packet)
		{
			int playerId = packet.ReadInt();
			GamePlayer playerById = WorldMgr.GetPlayerById(playerId);
			if (playerById != null)
			{
				playerById.LoadMarryProp();
				playerById.LoadMarryMessage();
				playerById.QuestInventory.ClearMarryQuest();
			}
		}

		public void HandleMarryRoomInfoToPlayer(GSPacketIn packet)
		{
			int num = packet.ReadInt();
			GamePlayer playerById = WorldMgr.GetPlayerById(num);
			if (playerById != null)
			{
				packet.Code = 252;
				packet.ClientID = num;
				playerById.Out.SendTCP(packet);
			}
		}

		public void HandleWorldBossUpdate(GSPacketIn pkg)
		{
			RoomMgr.WorldBossRoom.UpdateWorldBoss(pkg);
		}

		public void HandleWorldBossUpdateBlood(GSPacketIn pkg)
		{
			RoomMgr.WorldBossRoom.SendUpdateBlood(pkg);
		}

		public void HandleWorldBossRank(GSPacketIn pkg)
		{
			RoomMgr.WorldBossRoom.UpdateWorldBossRankCrosszone(pkg);
		}

		public void HandleWorldBossPrivateInfo(GSPacketIn pkg)
		{
			string name = pkg.ReadString();
			int damage = pkg.ReadInt();
			int honor = pkg.ReadInt();
			RoomMgr.WorldBossRoom.SendPrivateInfo(name, damage, honor);
		}

		public void HandleWorldBossFightOver(GSPacketIn pkg)
		{
			RoomMgr.WorldBossRoom.SendFightOver();
		}

		public void HandleBattleGoundOpenClose(GSPacketIn pkg)
		{
			ActiveSystemMgr.UpdateIsBattleGoundOpen(pkg.ReadBoolean());
		}

		public void HandleFightFootballTime(GSPacketIn pkg)
		{
			ActiveSystemMgr.UpdateIsFightFootballTime(pkg.ReadBoolean());
		}

		public void HandleLeagueOpenClose(GSPacketIn pkg)
		{
			ActiveSystemMgr.UpdateIsLeagueOpen(pkg.ReadBoolean());
		}

		public void HandleWorldBossRoomClose(GSPacketIn pkg)
		{
			if (pkg.ReadByte() == 0)
			{
				RoomMgr.WorldBossRoom.SendRoomClose();
			}
			else
			{
				RoomMgr.WorldBossRoom.WorldBossClose();
			}
		}

		public void HandleShutdown(GSPacketIn pkg)
		{
			GameServer.Instance.Shutdown();
		}

		public void HandleMacroDrop(GSPacketIn pkg)
		{
			Dictionary<int, MacroDropInfo> dictionary = new Dictionary<int, MacroDropInfo>();
			int num = pkg.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int key = pkg.ReadInt();
				int dropCount = pkg.ReadInt();
				int maxDropCount = pkg.ReadInt();
				MacroDropInfo value = new MacroDropInfo(dropCount, maxDropCount);
				dictionary.Add(key, value);
			}
			MacroDropMgr.UpdateDropInfo(dictionary);
		}

		public void SendRSALogin(RSACryptoServiceProvider rsa, string key)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(1);
			gSPacketIn.Write(rsa.Encrypt(Encoding.UTF8.GetBytes(key), fOAEP: false));
			SendTCP(gSPacketIn);
		}

		public void SendListenIPPort(IPAddress ip, int port)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(240);
			gSPacketIn.Write(ip.GetAddressBytes());
			gSPacketIn.WriteInt(port);
			SendTCP(gSPacketIn);
		}

		public void SendPingCenter()
		{
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			int val = ((allPlayers != null) ? allPlayers.Length : 0);
			GSPacketIn gSPacketIn = new GSPacketIn(12);
			gSPacketIn.WriteInt(val);
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendUserOnline(Dictionary<int, int> users)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(5);
			gSPacketIn.WriteInt(users.Count);
			foreach (KeyValuePair<int, int> user in users)
			{
				gSPacketIn.WriteInt(user.Key);
				gSPacketIn.WriteInt(user.Value);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUserOnline(int playerid, int consortiaID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(5);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(playerid);
			gSPacketIn.WriteInt(consortiaID);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUserOffline(int playerid, int consortiaID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(4);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(playerid);
			gSPacketIn.WriteInt(consortiaID);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendAllowUserLogin(int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(3);
			gSPacketIn.WriteInt(playerid);
			SendTCP(gSPacketIn);
		}

		public void SendMailResponse(int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(117);
			gSPacketIn.WriteInt(playerid);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaUserPass(int playerid, string playerName, ConsortiaUserInfo info, bool isInvite, int consortiaRepute, string loginName, int fightpower, int Offer)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128, playerid);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(info.ID);
			gSPacketIn.WriteBoolean(isInvite);
			gSPacketIn.WriteInt(info.ConsortiaID);
			gSPacketIn.WriteString(info.ConsortiaName);
			gSPacketIn.WriteInt(info.UserID);
			gSPacketIn.WriteString(info.UserName);
			gSPacketIn.WriteInt(playerid);
			gSPacketIn.WriteString(playerName);
			gSPacketIn.WriteInt(info.DutyID);
			gSPacketIn.WriteString(info.DutyName);
			gSPacketIn.WriteInt(info.Offer);
			gSPacketIn.WriteInt(info.RichesOffer);
			gSPacketIn.WriteInt(info.RichesRob);
			gSPacketIn.WriteDateTime(info.LastDate);
			gSPacketIn.WriteInt(info.Grade);
			gSPacketIn.WriteInt(info.Level);
			gSPacketIn.WriteInt(info.State);
			gSPacketIn.WriteBoolean(info.Sex);
			gSPacketIn.WriteInt(info.Right);
			gSPacketIn.WriteInt(info.Win);
			gSPacketIn.WriteInt(info.Total);
			gSPacketIn.WriteInt(info.Escape);
			gSPacketIn.WriteInt(consortiaRepute);
			gSPacketIn.WriteString(loginName);
			gSPacketIn.WriteInt(fightpower);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString("Honor");
			gSPacketIn.WriteInt(info.RichesOffer);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaDelete(int consortiaID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(consortiaID);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaUserDelete(int playerid, int consortiaID, bool isKick, string nickName, string kickName)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(playerid);
			gSPacketIn.WriteInt(consortiaID);
			gSPacketIn.WriteBoolean(isKick);
			gSPacketIn.WriteString(nickName);
			gSPacketIn.WriteString(kickName);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaInvite(int ID, int playerid, string playerName, int inviteID, string intviteName, string consortiaName, int consortiaID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(ID);
			gSPacketIn.WriteInt(playerid);
			gSPacketIn.WriteString(playerName);
			gSPacketIn.WriteInt(inviteID);
			gSPacketIn.WriteString(intviteName);
			gSPacketIn.WriteInt(consortiaID);
			gSPacketIn.WriteString(consortiaName);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaBanChat(int playerid, string playerName, int handleID, string handleName, bool isBan)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(5);
			gSPacketIn.WriteBoolean(isBan);
			gSPacketIn.WriteInt(playerid);
			gSPacketIn.WriteString(playerName);
			gSPacketIn.WriteInt(handleID);
			gSPacketIn.WriteString(handleName);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaFight(int consortiaID, int riches, string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(158);
			gSPacketIn.WriteInt(consortiaID);
			gSPacketIn.WriteInt(riches);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaOffer(int consortiaID, int offer, int riches)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(156);
			gSPacketIn.WriteInt(consortiaID);
			gSPacketIn.WriteInt(offer);
			gSPacketIn.WriteInt(riches);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaCreate(int consortiaID, int offer, string consotiaName)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(130);
			gSPacketIn.WriteInt(consortiaID);
			gSPacketIn.WriteInt(offer);
			gSPacketIn.WriteString(consotiaName);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaUpGrade(ConsortiaInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(6);
			gSPacketIn.WriteInt(info.ConsortiaID);
			gSPacketIn.WriteString(info.ConsortiaName);
			gSPacketIn.WriteInt(info.Level);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaShopUpGrade(ConsortiaInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(10);
			gSPacketIn.WriteInt(info.ConsortiaID);
			gSPacketIn.WriteString(info.ConsortiaName);
			gSPacketIn.WriteInt(info.ShopLevel);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaSmithUpGrade(ConsortiaInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(11);
			gSPacketIn.WriteInt(info.ConsortiaID);
			gSPacketIn.WriteString(info.ConsortiaName);
			gSPacketIn.WriteInt(info.SmithLevel);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaStoreUpGrade(ConsortiaInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(12);
			gSPacketIn.WriteInt(info.ConsortiaID);
			gSPacketIn.WriteString(info.ConsortiaName);
			gSPacketIn.WriteInt(info.StoreLevel);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaKillUpGrade(ConsortiaInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(13);
			gSPacketIn.WriteInt(info.ConsortiaID);
			gSPacketIn.WriteString(info.ConsortiaName);
			gSPacketIn.WriteInt(info.SkillLevel);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaAlly(int consortiaID1, int consortiaID2, int state)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteInt(consortiaID1);
			gSPacketIn.WriteInt(consortiaID2);
			gSPacketIn.WriteInt(state);
			SendTCP(gSPacketIn);
			ConsortiaMgr.UpdateConsortiaAlly(consortiaID1, consortiaID2, state);
		}

		public void SendConsortiaDuty(ConsortiaDutyInfo info, int updateType, int consortiaID)
		{
			SendConsortiaDuty(info, updateType, consortiaID, 0, "", 0, "");
		}

		public void SendConsortiaDuty(ConsortiaDutyInfo info, int updateType, int consortiaID, int playerID, string playerName, int handleID, string handleName)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(8);
			gSPacketIn.WriteByte((byte)updateType);
			gSPacketIn.WriteInt(consortiaID);
			gSPacketIn.WriteInt(playerID);
			gSPacketIn.WriteString(playerName);
			gSPacketIn.WriteInt(info.Level);
			gSPacketIn.WriteString(info.DutyName);
			gSPacketIn.WriteInt(info.Right);
			gSPacketIn.WriteInt(handleID);
			gSPacketIn.WriteString(handleName);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaRichesOffer(int consortiaID, int playerID, string playerName, int riches)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(128);
			gSPacketIn.WriteByte(9);
			gSPacketIn.WriteInt(consortiaID);
			gSPacketIn.WriteInt(playerID);
			gSPacketIn.WriteString(playerName);
			gSPacketIn.WriteInt(riches);
			SendTCP(gSPacketIn);
		}

		public void SendUpdatePlayerMarriedStates(int playerId)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(13);
			gSPacketIn.WriteInt(playerId);
			SendTCP(gSPacketIn);
		}

		public void SendMarryRoomDisposeToPlayer(int roomId)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(241);
			gSPacketIn.WriteInt(roomId);
			SendTCP(gSPacketIn);
		}

		public void SendMarryRoomInfoToPlayer(int playerId, bool state, MarryRoomInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(14);
			gSPacketIn.WriteInt(playerId);
			gSPacketIn.WriteBoolean(state);
			if (state)
			{
				gSPacketIn.WriteInt(info.ID);
				gSPacketIn.WriteString(info.Name);
				gSPacketIn.WriteInt(info.MapIndex);
				gSPacketIn.WriteInt(info.AvailTime);
				gSPacketIn.WriteInt(info.PlayerID);
				gSPacketIn.WriteInt(info.GroomID);
				gSPacketIn.WriteInt(info.BrideID);
				gSPacketIn.WriteDateTime(info.BeginTime);
				gSPacketIn.WriteBoolean(info.IsGunsaluteUsed);
			}
			SendTCP(gSPacketIn);
		}

		public void SendShutdown(bool isStoping)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(15);
			gSPacketIn.WriteInt(int_1);
			gSPacketIn.WriteBoolean(isStoping);
			SendTCP(gSPacketIn);
		}

		public void SendPacket(GSPacketIn packet)
		{
			SendTCP(packet);
		}

		public LoginServerConnector(string ip, int port, int serverid, string name, byte[] readBuffer, byte[] sendBuffer)
			: base(ip, port, autoReconnect: true, readBuffer, sendBuffer)
		{
			int_1 = serverid;
			string_0 = $"{serverid},{name}";
			base.Strict = true;
		}

		static LoginServerConnector()
		{
			ilog_2 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
