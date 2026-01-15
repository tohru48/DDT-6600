using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using log4net;

namespace Game.Server.RingStation.Battle
{
	public class RingStationFightConnector : BaseConnector
	{
		private static readonly ILog ilog_2;

		private RingStationBattleServer ringStationBattleServer_0;

		private string string_0;

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
				case 19:
					method_8(gSPacketIn);
					break;
				case 32:
					HandleSendToPlayer(gSPacketIn);
					break;
				case 33:
					method_30(gSPacketIn);
					break;
				case 34:
					method_29(gSPacketIn);
					break;
				case 35:
					method_28(gSPacketIn);
					break;
				case 36:
					method_26(gSPacketIn);
					break;
				case 38:
					method_25(gSPacketIn);
					break;
				case 39:
					method_17(gSPacketIn);
					break;
				case 40:
					method_9(gSPacketIn);
					break;
				case 41:
					method_10(gSPacketIn);
					break;
				case 42:
					method_11(gSPacketIn);
					break;
				case 43:
					method_12(gSPacketIn);
					break;
				case 44:
					method_13(gSPacketIn);
					break;
				case 45:
					method_14(gSPacketIn);
					break;
				case 48:
					method_16(gSPacketIn);
					break;
				case 49:
					method_24(gSPacketIn);
					break;
				case 50:
					method_15(gSPacketIn);
					break;
				case 52:
					method_3(gSPacketIn);
					break;
				case 53:
					method_6(gSPacketIn);
					break;
				case 65:
					HandleRoomRemove(gSPacketIn);
					break;
				case 66:
					HandleStartGame(gSPacketIn);
					break;
				case 67:
					HandleSendToRoom(gSPacketIn);
					break;
				case 68:
					HandleStopGame(gSPacketIn);
					break;
				case 69:
					method_5(gSPacketIn);
					break;
				case 70:
					method_4(gSPacketIn);
					break;
				case 73:
					method_22(gSPacketIn);
					break;
				case 74:
					method_18(gSPacketIn);
					break;
				case 75:
					method_21(gSPacketIn);
					break;
				case 76:
					method_23(gSPacketIn);
					break;
				case 77:
					HandleFindConsortiaAlly(gSPacketIn);
					break;
				case 84:
					method_20(gSPacketIn);
					break;
				case 85:
					method_19(gSPacketIn);
					break;
				case 86:
					method_7(gSPacketIn);
					break;
				case 0:
					HandleRSAKey(gSPacketIn);
					break;
				}
			}
			catch (Exception value)
			{
				Console.WriteLine(value);
			}
		}

		private void method_3(GSPacketIn gspacketIn_0)
		{
		}

		private void method_4(GSPacketIn gspacketIn_0)
		{
		}

		private void method_5(GSPacketIn gspacketIn_0)
		{
		}

		private void method_6(GSPacketIn gspacketIn_0)
		{
		}

		private void method_7(GSPacketIn gspacketIn_0)
		{
		}

		public void SendKitOffPlayer(int playerid)
		{
		}

		private void method_8(GSPacketIn gspacketIn_0)
		{
		}

		public void HandleFindConsortiaAlly(GSPacketIn pkg)
		{
		}

		private void method_9(GSPacketIn gspacketIn_0)
		{
		}

		private void method_10(GSPacketIn gspacketIn_0)
		{
		}

		private void method_11(GSPacketIn gspacketIn_0)
		{
		}

		private void method_12(GSPacketIn gspacketIn_0)
		{
		}

		private void method_13(GSPacketIn gspacketIn_0)
		{
		}

		private void method_14(GSPacketIn gspacketIn_0)
		{
		}

		private void method_15(GSPacketIn gspacketIn_0)
		{
		}

		private void method_16(GSPacketIn gspacketIn_0)
		{
		}

		private void method_17(GSPacketIn gspacketIn_0)
		{
		}

		private void method_18(GSPacketIn gspacketIn_0)
		{
		}

		private void method_19(GSPacketIn gspacketIn_0)
		{
		}

		private void method_20(GSPacketIn gspacketIn_0)
		{
		}

		private void method_21(GSPacketIn gspacketIn_0)
		{
		}

		private void method_22(GSPacketIn gspacketIn_0)
		{
		}

		private void method_23(GSPacketIn gspacketIn_0)
		{
		}

		private void method_24(GSPacketIn gspacketIn_0)
		{
		}

		private void method_25(GSPacketIn gspacketIn_0)
		{
		}

		private void method_26(GSPacketIn gspacketIn_0)
		{
		}

		private void method_27(int int_1, int int_2, int int_3, bool bool_4)
		{
		}

		public void SendPlayerDisconnet(int gameId, int playerId, int roomid)
		{
		}

		private void method_28(GSPacketIn gspacketIn_0)
		{
		}

		private void method_29(GSPacketIn gspacketIn_0)
		{
		}

		public void SendRSALogin(RSACryptoServiceProvider rsa, string key)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(1);
			gSPacketIn.Write(rsa.Encrypt(Encoding.UTF8.GetBytes(key), fOAEP: false));
			SendTCP(gSPacketIn);
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
		}

		public RingStationFightConnector(RingStationBattleServer server, string ip, int port, string key)
			: base(ip, port, autoReconnect: true, new byte[8192], new byte[8192])
		{
			ringStationBattleServer_0 = server;
			string_0 = key;
			base.Strict = true;
		}

		public void SendAddRoom(BaseRoomRingStation room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(64);
			gSPacketIn.WriteInt(room.RoomId);
			gSPacketIn.WriteInt(room.PickUpNpcId);
			gSPacketIn.WriteBoolean(room.IsAutoBot);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteBoolean(room.IsFreedom);
			gSPacketIn.WriteInt(room.RoomType);
			gSPacketIn.WriteInt(room.GameType);
			gSPacketIn.WriteInt(room.GuildId);
			List<RingStationGamePlayer> list = room.method_0();
			gSPacketIn.WriteInt(list.Count);
			foreach (RingStationGamePlayer item in list)
			{
				gSPacketIn.WriteInt(GameServer.Instance.Configuration.AreaId);
				gSPacketIn.WriteString(GameServer.Instance.Configuration.AreaName);
				gSPacketIn.WriteInt(item.ID);
				gSPacketIn.WriteString(item.NickName);
				gSPacketIn.WriteBoolean(item.Sex);
				gSPacketIn.WriteByte(item.typeVIP);
				gSPacketIn.WriteInt(item.VIPLevel);
				gSPacketIn.WriteInt(item.Hide);
				gSPacketIn.WriteString(item.Style);
				gSPacketIn.WriteString(item.Style);
				gSPacketIn.WriteString(item.Style);
				gSPacketIn.WriteString(item.Colors);
				gSPacketIn.WriteString(item.Skin);
				gSPacketIn.WriteInt(item.Offer);
				gSPacketIn.WriteInt(item.GP);
				gSPacketIn.WriteInt(item.Grade);
				gSPacketIn.WriteInt(item.Repute);
				gSPacketIn.WriteInt(item.ConsortiaID);
				gSPacketIn.WriteString(item.ConsortiaName);
				gSPacketIn.WriteInt(item.ConsortiaLevel);
				gSPacketIn.WriteInt(item.ConsortiaRepute);
				gSPacketIn.WriteInt(item.badgeID);
				gSPacketIn.WriteString(item.WeaklessGuildProgressStr);
				gSPacketIn.WriteString(item.Honor);
				gSPacketIn.WriteInt(item.Attack);
				gSPacketIn.WriteInt(item.Defence);
				gSPacketIn.WriteInt(item.Agility);
				gSPacketIn.WriteInt(item.Luck);
				gSPacketIn.WriteInt(item.hp);
				gSPacketIn.WriteInt(item.FightPower);
				gSPacketIn.WriteBoolean(val: false);
				gSPacketIn.WriteDouble(item.BaseAttack);
				gSPacketIn.WriteDouble(item.BaseDefence);
				gSPacketIn.WriteDouble(item.BaseAgility);
				gSPacketIn.WriteDouble(item.BaseBlood);
				gSPacketIn.WriteInt(item.TemplateID);
				gSPacketIn.WriteInt(item.StrengthLevel);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteBoolean(item.CanUserProp);
				gSPacketIn.WriteInt(item.SecondWeapon);
				gSPacketIn.WriteInt(item.StrengthLevel);
				gSPacketIn.WriteInt(item.Healstone);
				gSPacketIn.WriteInt(item.HealstoneCount);
				gSPacketIn.WriteDouble(item.Double_0);
				gSPacketIn.WriteDouble(item.GMExperienceRate);
				gSPacketIn.WriteDouble(item.AuncherExperienceRate);
				gSPacketIn.WriteInt(GameServer.Instance.Configuration.ServerID);
				gSPacketIn.WriteBoolean(val: false);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteString("0.0.0.0");
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
			}
			SendTCP(gSPacketIn);
		}

		public void SendRemoveRoom(BaseRoomRingStation room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(65);
			gSPacketIn.Parameter1 = room.RoomId;
			SendTCP(gSPacketIn);
		}

		public void SendToGame(int gameId, GSPacketIn pkg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(2, gameId);
			gSPacketIn.WritePacket(pkg);
			SendTCP(gSPacketIn);
		}

		protected void HandleRoomRemove(GSPacketIn packet)
		{
			ringStationBattleServer_0.RemoveRoomImp(packet.ClientID);
		}

		protected void HandleStartGame(GSPacketIn pkg)
		{
			ProxyRingStationGame game = new ProxyRingStationGame(pkg.Parameter2, this, (eRoomType)pkg.ReadInt(), (eGameType)pkg.ReadInt(), pkg.ReadInt());
			ringStationBattleServer_0.StartGame(pkg.Parameter1, game);
		}

		protected void HandleStopGame(GSPacketIn pkg)
		{
			int parameter = pkg.Parameter1;
			int parameter2 = pkg.Parameter2;
			ringStationBattleServer_0.StopGame(parameter, parameter2);
		}

		protected void HandleSendToRoom(GSPacketIn pkg)
		{
			int clientID = pkg.ClientID;
			GSPacketIn pkg2 = pkg.ReadPacket();
			ringStationBattleServer_0.SendToRoom(clientID, pkg2, pkg.Parameter1, pkg.Parameter2);
		}

		protected void HandleSendToPlayer(GSPacketIn pkg)
		{
		}

		private void method_30(GSPacketIn gspacketIn_0)
		{
			ringStationBattleServer_0.UpdatePlayerGameId(gspacketIn_0.Parameter1, gspacketIn_0.Parameter2);
		}

		public void SendChangeGameType()
		{
		}

		public void SendChatMessage()
		{
		}

		public void SendFightNotice()
		{
		}

		public void SendFindConsortiaAlly(int state, int gameid)
		{
		}

		static RingStationFightConnector()
		{
			ilog_2 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
