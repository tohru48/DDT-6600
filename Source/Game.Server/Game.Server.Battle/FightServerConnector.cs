using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using Bussiness.Managers;
using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Object;
using Game.Logic.Protocol;
using Game.Server.Buffer;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.RingStation;
using Game.Server.Rooms;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Battle
{
	public class FightServerConnector : BaseConnector
	{
		private static readonly ILog ilog_2;

		private BattleServer battleServer_0;

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
				int code = gSPacketIn.Code;
				switch (code)
				{
				case 19:
					method_5(gSPacketIn);
					break;
				case 32:
					HandleSendToPlayer(gSPacketIn);
					break;
				case 33:
					method_33(gSPacketIn);
					break;
				case 34:
					method_31(gSPacketIn);
					break;
				case 35:
					method_30(gSPacketIn);
					break;
				case 36:
					method_28(gSPacketIn);
					break;
				case 38:
					method_27(gSPacketIn);
					break;
				case 39:
					method_15(gSPacketIn);
					break;
				case 40:
					method_6(gSPacketIn);
					break;
				case 41:
					method_7(gSPacketIn);
					break;
				case 42:
					method_8(gSPacketIn);
					break;
				case 43:
					method_9(gSPacketIn);
					break;
				case 44:
					method_10(gSPacketIn);
					break;
				case 45:
					method_11(gSPacketIn);
					break;
				case 48:
					method_13(gSPacketIn);
					break;
				case 49:
					method_26(gSPacketIn);
					break;
				case 50:
					method_12(gSPacketIn);
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
				case 73:
					method_19(gSPacketIn);
					break;
				case 74:
					method_16(gSPacketIn);
					break;
				case 75:
					method_18(gSPacketIn);
					break;
				case 76:
					method_20(gSPacketIn);
					break;
				case 77:
					HandleFindConsortiaAlly(gSPacketIn);
					break;
				case 84:
					method_21(gSPacketIn);
					break;
				case 85:
					method_22(gSPacketIn);
					break;
				case 86:
					method_24(gSPacketIn);
					break;
				case 87:
					method_25(gSPacketIn);
					break;
				case 88:
					method_32(gSPacketIn);
					break;
				case 89:
					method_17(gSPacketIn);
					break;
				case 90:
					method_23(gSPacketIn);
					break;
				case 91:
					method_14(gSPacketIn);
					break;
				case 92:
					method_4(gSPacketIn);
					break;
				case 93:
					method_3(gSPacketIn);
					break;
				default:
					Console.WriteLine("??????????LoginServerConnector: " + (eFightPackageType)code);
					break;
				case 0:
					HandleRSAKey(gSPacketIn);
					break;
				}
			}
			catch (Exception exception)
			{
				GameServer.log.Error("AsynProcessPacket", exception);
			}
		}

		private void method_3(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.CreateRandomEnterModeItem();
		}

		private void method_4(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddEnterModePoint(gspacketIn_0.Parameter1);
		}

		private void method_5(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.SendMessage(gspacketIn_0.ReadString());
		}

		public void HandleFindConsortiaAlly(GSPacketIn pkg)
		{
			int state = ConsortiaMgr.FindConsortiaAlly(pkg.ReadInt(), pkg.ReadInt());
			SendFindConsortiaAlly(state, pkg.ReadInt());
		}

		private void method_6(GSPacketIn gspacketIn_0)
		{
			GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
			AbstractGame game = playerById.CurrentRoom.Game;
			playerById?.OnKillingLiving(game, gspacketIn_0.ReadInt(), gspacketIn_0.ClientID, gspacketIn_0.ReadBoolean(), gspacketIn_0.ReadInt());
		}

		private void method_7(GSPacketIn gspacketIn_0)
		{
			GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
			AbstractGame game = playerById.CurrentRoom.Game;
			playerById?.OnMissionOver(game, gspacketIn_0.ReadBoolean(), gspacketIn_0.ReadInt(), gspacketIn_0.ReadInt());
		}

		private void method_8(GSPacketIn gspacketIn_0)
		{
			GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
			Dictionary<int, Player> dictionary = new Dictionary<int, Player>();
			int consortiaWin = gspacketIn_0.ReadInt();
			int consortiaLose = gspacketIn_0.ReadInt();
			int num = gspacketIn_0.ReadInt();
			for (int i = 0; i < num; i++)
			{
				GamePlayer playerById2 = WorldMgr.GetPlayerById(gspacketIn_0.ReadInt());
				if (playerById2 != null)
				{
					Player value = new Player(playerById2, 0, null, 0, playerById2.PlayerCharacter.hp);
					dictionary.Add(i, value);
				}
			}
			eRoomType roomType = (eRoomType)gspacketIn_0.ReadByte();
			eGameType gameClass = (eGameType)gspacketIn_0.ReadByte();
			int totalKillHealth = gspacketIn_0.ReadInt();
			playerById?.ConsortiaFight(consortiaWin, consortiaLose, dictionary, roomType, gameClass, totalKillHealth, num);
		}

		private void method_9(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.SendConsortiaFight(gspacketIn_0.ReadInt(), gspacketIn_0.ReadInt(), gspacketIn_0.ReadString());
		}

		private void method_10(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveGold(gspacketIn_0.ReadInt());
		}

		private void method_11(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveMoney(gspacketIn_0.ReadInt());
		}

		private void method_12(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveOffer(gspacketIn_0.ReadInt());
		}

		private void method_13(GSPacketIn gspacketIn_0)
		{
			GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
			if (playerById != null)
			{
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(gspacketIn_0.ReadInt());
				eBageType bagType = (eBageType)gspacketIn_0.ReadByte();
				if (ıtemTemplateInfo != null)
				{
					int count = gspacketIn_0.ReadInt();
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, count, 118);
					ıtemInfo.Count = count;
					ıtemInfo.ValidDate = gspacketIn_0.ReadInt();
					ıtemInfo.IsBinds = gspacketIn_0.ReadBoolean();
					ıtemInfo.IsUsed = gspacketIn_0.ReadBoolean();
					playerById.AddTemplate(ıtemInfo, bagType, ıtemInfo.Count, eGameView.BatleTypeGet);
				}
			}
		}

		private void method_14(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddBoatScore(gspacketIn_0.Parameter1);
		}

		private void method_15(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddGP(gspacketIn_0.Parameter1);
		}

		private void method_16(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddMoney(gspacketIn_0.Parameter1);
		}

		private void method_17(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddActiveMoney(gspacketIn_0.Parameter1);
		}

		private void method_18(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddGiftToken(gspacketIn_0.Parameter1);
		}

		private void method_19(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveHealstone();
		}

		private void method_20(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddMedal(gspacketIn_0.Parameter1);
		}

		private void method_21(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddLeagueMoney(gspacketIn_0.Parameter1);
		}

		private void method_22(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddPrestige(gspacketIn_0.ReadBoolean(), (eRoomType)gspacketIn_0.Parameter1);
		}

		private void method_23(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RingstationResult(gspacketIn_0.ReadBoolean());
		}

		private void method_24(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.UpdateRestCount();
		}

		private void method_25(GSPacketIn gspacketIn_0)
		{
			GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
			if (playerById != null)
			{
				bool isWin = gspacketIn_0.ReadBoolean();
				playerById.FootballTakeOut(isWin);
			}
		}

		private void method_26(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveGP(gspacketIn_0.Parameter1);
		}

		private void method_27(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddGold(gspacketIn_0.Parameter1);
		}

		private void method_28(GSPacketIn gspacketIn_0)
		{
			GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
			if (playerById != null)
			{
				int num = gspacketIn_0.ReadInt();
				bool bool_ = playerById.UsePropItem(null, gspacketIn_0.Parameter1, gspacketIn_0.Parameter2, num, gspacketIn_0.ReadBoolean());
				method_29(playerById.CurrentRoom.Game.Id, playerById.GamePlayerId, num, bool_);
			}
		}

		private void method_29(int int_1, int int_2, int int_3, bool bool_4)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(36, int_1);
			gSPacketIn.Parameter1 = int_2;
			gSPacketIn.Parameter2 = int_3;
			gSPacketIn.WriteBoolean(bool_4);
			SendTCP(gSPacketIn);
		}

		public void SendPlayerDisconnet(int gameId, int playerId, int roomid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(83, gameId);
			gSPacketIn.Parameter1 = playerId;
			SendTCP(gSPacketIn);
		}

		public void SendKitOffPlayer(int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(4);
			gSPacketIn.WriteInt(playerid);
			SendTCP(gSPacketIn);
		}

		private void method_30(GSPacketIn gspacketIn_0)
		{
			GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
			if (playerById != null && playerById.CurrentRoom != null && playerById.CurrentRoom.Game != null)
			{
				playerById.OnGameOver(playerById.CurrentRoom.Game, gspacketIn_0.ReadBoolean(), gspacketIn_0.ReadInt());
			}
		}

		private void method_31(GSPacketIn gspacketIn_0)
		{
			WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.Disconnect();
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

		public FightServerConnector(BattleServer server, string ip, int port, string key)
			: base(ip, port, autoReconnect: true, new byte[8192], new byte[8192])
		{
			battleServer_0 = server;
			string_0 = key;
			base.Strict = true;
		}

		public void SendAddRoom(BaseRoom room)
		{
			bool flag = false;
			if (room.GameType == eGameType.BattleGame || room.GameType == eGameType.RingStation || room.RoomType == eRoomType.Entertainment || room.RoomType == eRoomType.EntertainmentPK)
			{
				flag = true;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(64);
			gSPacketIn.WriteInt(room.RoomId);
			gSPacketIn.WriteInt(room.PickUpNpcId);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteBoolean(room.StartWithNpc);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteInt((int)room.RoomType);
			gSPacketIn.WriteInt((int)room.GameType);
			gSPacketIn.WriteInt(room.GuildId);
			List<GamePlayer> players = room.GetPlayers();
			gSPacketIn.WriteInt(players.Count);
			foreach (GamePlayer item in players)
			{
				gSPacketIn.WriteInt(item.ZoneId);
				gSPacketIn.WriteString(item.ZoneName);
				gSPacketIn.WriteInt(item.PlayerCharacter.ID);
				gSPacketIn.WriteString(item.PlayerCharacter.NickName);
				gSPacketIn.WriteBoolean(item.PlayerCharacter.Sex);
				gSPacketIn.WriteByte(item.PlayerCharacter.typeVIP);
				gSPacketIn.WriteInt(item.PlayerCharacter.VIPLevel);
				gSPacketIn.WriteInt(item.PlayerCharacter.Hide);
				gSPacketIn.WriteString(item.PlayerCharacter.Style);
				gSPacketIn.WriteString(item.CreateFightFootballStyle(1));
				gSPacketIn.WriteString(item.CreateFightFootballStyle(2));
				gSPacketIn.WriteString(item.PlayerCharacter.Colors);
				gSPacketIn.WriteString(item.PlayerCharacter.Skin);
				gSPacketIn.WriteInt(item.PlayerCharacter.Offer);
				gSPacketIn.WriteInt(item.PlayerCharacter.GP);
				gSPacketIn.WriteInt(item.PlayerCharacter.Grade);
				gSPacketIn.WriteInt(item.PlayerCharacter.Repute);
				gSPacketIn.WriteInt(item.PlayerCharacter.ConsortiaID);
				gSPacketIn.WriteString(item.PlayerCharacter.ConsortiaName);
				gSPacketIn.WriteInt(item.PlayerCharacter.ConsortiaLevel);
				gSPacketIn.WriteInt(item.PlayerCharacter.ConsortiaRepute);
				gSPacketIn.WriteInt(item.PlayerCharacter.badgeID);
				gSPacketIn.WriteString(item.PlayerCharacter.WeaklessGuildProgressStr);
				gSPacketIn.WriteString(item.PlayerCharacter.Honor);
				if (room.GameType == eGameType.BattleGame)
				{
					gSPacketIn.WriteInt(item.BattleData.Attack);
					gSPacketIn.WriteInt(item.BattleData.Defend);
					gSPacketIn.WriteInt(item.BattleData.Agility);
					gSPacketIn.WriteInt(item.BattleData.Lucky);
					gSPacketIn.WriteInt(item.BattleData.Blood);
				}
				else
				{
					gSPacketIn.WriteInt(item.PlayerCharacter.Attack);
					gSPacketIn.WriteInt(item.PlayerCharacter.Defence);
					gSPacketIn.WriteInt(item.PlayerCharacter.Agility);
					gSPacketIn.WriteInt(item.PlayerCharacter.Luck);
					gSPacketIn.WriteInt(item.PlayerCharacter.hp);
				}
				gSPacketIn.WriteInt(item.PlayerCharacter.FightPower);
				gSPacketIn.WriteBoolean(item.PlayerCharacter.IsMarried);
				if (item.PlayerCharacter.IsMarried)
				{
					gSPacketIn.WriteInt(item.PlayerCharacter.SpouseID);
					gSPacketIn.WriteString(item.PlayerCharacter.SpouseName);
				}
				if (room.GameType == eGameType.BattleGame)
				{
					gSPacketIn.WriteDouble(item.BattleData.Damage);
					gSPacketIn.WriteDouble(item.BattleData.Guard);
					gSPacketIn.WriteDouble(item.BattleData.BaseAgility);
					gSPacketIn.WriteDouble(item.BattleData.Blood);
				}
				else
				{
					gSPacketIn.WriteDouble(item.BaseAttack);
					gSPacketIn.WriteDouble(item.BaseDefence);
					gSPacketIn.WriteDouble(item.GetBaseAgility());
					gSPacketIn.WriteDouble(item.GetBaseBlood());
				}
				gSPacketIn.WriteInt(item.MainWeapon.TemplateID);
				gSPacketIn.WriteInt(item.MainWeapon.StrengthenLevel);
				if (item.MainWeapon.GoldEquip == null)
				{
					gSPacketIn.WriteInt(0);
				}
				else
				{
					gSPacketIn.WriteInt(item.MainWeapon.GoldEquip.TemplateID);
					gSPacketIn.WriteDateTime(item.MainWeapon.goldBeginTime);
					gSPacketIn.WriteInt(item.MainWeapon.goldValidDate);
				}
				gSPacketIn.WriteBoolean(item.CanUseProp);
				if (item.SecondWeapon != null && room.GameType != eGameType.BattleGame)
				{
					gSPacketIn.WriteInt(item.SecondWeapon.TemplateID);
					gSPacketIn.WriteInt(item.SecondWeapon.StrengthenLevel);
				}
				else
				{
					gSPacketIn.WriteInt(0);
					gSPacketIn.WriteInt(0);
				}
				if (item.Healstone != null && room.GameType != eGameType.BattleGame)
				{
					gSPacketIn.WriteInt(item.Healstone.TemplateID);
					gSPacketIn.WriteInt(item.Healstone.Count);
				}
				else
				{
					gSPacketIn.WriteInt(0);
					gSPacketIn.WriteInt(0);
				}
				gSPacketIn.WriteDouble((double)RateMgr.GetRate(eRateType.Experience_Rate) * Class12.pUjigatxrH(item.PlayerCharacter.AntiAddiction) * ((item.double_0 == 0.0) ? 1.0 : item.double_0));
				gSPacketIn.WriteDouble(Class12.pUjigatxrH(item.PlayerCharacter.AntiAddiction) * ((item.OfferAddPlus == 0.0) ? 1.0 : item.OfferAddPlus));
				gSPacketIn.WriteDouble(RateMgr.GetRate(eRateType.Experience_Rate));
				gSPacketIn.WriteInt(GameServer.Instance.Configuration.ServerID);
				gSPacketIn.WriteBoolean(item.DragonBoatOpen());
				gSPacketIn.WriteInt(item.DragonBoatAddExpPlus());
				gSPacketIn.WriteString(item.TcpEndPoint());
				gSPacketIn.WriteInt(item.BattleData.MatchInfo.restCount);
				gSPacketIn.WriteInt(item.BattleData.MatchInfo.maxCount);
				bool val = false;
				if (flag)
				{
					gSPacketIn.WriteBoolean(val);
				}
				else
				{
					val = item.Pet != null;
					gSPacketIn.WriteBoolean(val);
					if (val)
					{
						gSPacketIn.WriteInt(item.Pet.Place);
						gSPacketIn.WriteInt(item.Pet.TemplateID);
						gSPacketIn.WriteInt(item.Pet.ID);
						gSPacketIn.WriteString(item.Pet.Name);
						gSPacketIn.WriteInt(item.Pet.UserID);
						gSPacketIn.WriteInt(item.Pet.Level);
						gSPacketIn.WriteString(item.Pet.Skill);
						gSPacketIn.WriteString(item.Pet.SkillEquip);
					}
				}
				if (flag)
				{
					gSPacketIn.WriteInt(0);
				}
				else
				{
					List<AbstractBuffer> allBufferByTemplate = item.BufferList.GetAllBufferByTemplate();
					gSPacketIn.WriteInt(allBufferByTemplate.Count);
					foreach (AbstractBuffer item2 in allBufferByTemplate)
					{
						BufferInfo ınfo = item2.Info;
						gSPacketIn.WriteInt(ınfo.Type);
						gSPacketIn.WriteBoolean(ınfo.IsExist);
						gSPacketIn.WriteDateTime(ınfo.BeginDate);
						gSPacketIn.WriteInt(ınfo.ValidDate);
						gSPacketIn.WriteInt(ınfo.Value);
						gSPacketIn.WriteInt(ınfo.ValidCount);
						gSPacketIn.WriteInt(ınfo.TemplateID);
					}
				}
				if (flag)
				{
					gSPacketIn.WriteInt(0);
				}
				else
				{
					gSPacketIn.WriteInt(item.EquipEffect.Count);
					foreach (ItemInfo item3 in item.EquipEffect)
					{
						gSPacketIn.WriteInt(item3.TemplateID);
						gSPacketIn.WriteInt(item3.Hole1);
					}
				}
				if (flag)
				{
					gSPacketIn.WriteInt(0);
				}
				else
				{
					gSPacketIn.WriteInt(item.FightBuffs.Count);
					foreach (BufferInfo fightBuff in item.FightBuffs)
					{
						gSPacketIn.WriteInt(fightBuff.Type);
						gSPacketIn.WriteInt(fightBuff.Value);
					}
				}
				gSPacketIn.WriteInt(item.Horse.curUsedSkill.Count);
				foreach (int value in item.Horse.curUsedSkill.Values)
				{
					gSPacketIn.WriteInt(value);
				}
				gSPacketIn.WriteInt(item.BatleConfig.MagicHouse);
				gSPacketIn.WriteInt(item.BatleConfig.PetFormReduceDamage);
			}
			SendTCP(gSPacketIn);
		}

		private void method_32(GSPacketIn gspacketIn_0)
		{
			int roomtype = gspacketIn_0.ReadInt();
			int gametype = gspacketIn_0.ReadInt();
			int npcId = gspacketIn_0.ReadInt();
			GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.Parameter1);
			if (playerById == null)
			{
				RingStationMgr.CreateBaseAutoBot(roomtype, gametype, npcId);
			}
			else
			{
				RingStationMgr.CreateAutoBot(playerById, roomtype, gametype, npcId);
			}
		}

		public void SendRemoveRoom(BaseRoom room)
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
			battleServer_0.RemoveRoomImp(packet.ClientID);
		}

		protected void HandleStartGame(GSPacketIn pkg)
		{
			ProxyGame game = new ProxyGame(pkg.Parameter2, this, (eRoomType)pkg.ReadInt(), (eGameType)pkg.ReadInt(), pkg.ReadInt());
			battleServer_0.StartGame(pkg.Parameter1, game);
		}

		protected void HandleStopGame(GSPacketIn pkg)
		{
			int parameter = pkg.Parameter1;
			int parameter2 = pkg.Parameter2;
			battleServer_0.StopGame(parameter, parameter2);
		}

		protected void HandleSendToRoom(GSPacketIn pkg)
		{
			int clientID = pkg.ClientID;
			GSPacketIn pkg2 = pkg.ReadPacket();
			battleServer_0.SendToRoom(clientID, pkg2, pkg.Parameter1, pkg.Parameter2);
		}

		protected void HandleSendToPlayer(GSPacketIn pkg)
		{
			int clientID = pkg.ClientID;
			try
			{
				GSPacketIn pkg2 = pkg.ReadPacket();
				battleServer_0.SendToUser(clientID, pkg2);
			}
			catch (Exception exception)
			{
				ilog_2.Error($"pkg len:{pkg.Length}", exception);
				ilog_2.Error(Marshal.ToHexDump("pkg content:", pkg.Buffer, 0, pkg.Length));
			}
		}

		private void method_33(GSPacketIn gspacketIn_0)
		{
			battleServer_0.UpdatePlayerGameId(gspacketIn_0.Parameter1, gspacketIn_0.Parameter2);
		}

		public void SendChangeGameType(BaseRoom room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(72);
			gSPacketIn.Parameter1 = room.RoomId;
			GSPacketIn gSPacketIn2 = gSPacketIn;
			gSPacketIn2.WriteInt((int)room.GameType);
			SendTCP(gSPacketIn2);
		}

		public void SendChatMessage(string msg, GamePlayer player, bool team)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(19, player.CurrentRoom.Game.Id);
			gSPacketIn.WriteInt(player.GamePlayerId);
			gSPacketIn.WriteBoolean(team);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
		}

		public void SendFightNotice(GamePlayer player, int GameId)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(3, GameId);
			gSPacketIn.Parameter1 = player.GamePlayerId;
			SendTCP(gSPacketIn);
		}

		public void SendFindConsortiaAlly(int state, int gameid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(77, gameid);
			gSPacketIn.WriteInt(state);
			gSPacketIn.WriteInt((int)RateMgr.GetRate(eRateType.Riches_Rate));
			SendTCP(gSPacketIn);
		}

		static FightServerConnector()
		{
			ilog_2 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
