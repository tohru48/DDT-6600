using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using Game.Server;
using Game.Server.Achievements;
using Game.Server.Buffer;
using Game.Server.DragonBoat;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.Quests;
using Game.Server.Rooms;
using Game.Server.SceneMarryRooms;
using log4net;
using SqlDataProvider.Data;

namespace Game.Base.Packets
{
	[PacketLib(1)]
	public class AbstractPacketLib : IPacketLib
	{
		private static readonly ILog ilog_0;

		protected readonly GameClient m_gameClient;

		public AbstractPacketLib(GameClient client)
		{
			m_gameClient = client;
		}

		public GSPacketIn SendFarmPoultryLevel(int PlayerID, UserFarmInfo farm, int nextLevel)
		{
			GSPacketIn result = new GSPacketIn(81, PlayerID);
			GSPacketIn gSPacketIn = new GSPacketIn(81);
			gSPacketIn.WriteByte(21);
			gSPacketIn.WriteInt(farm.FarmID);
			gSPacketIn.WriteInt(farm.TreeLevel);
			gSPacketIn.WriteInt(farm.MonsterExp);
			gSPacketIn.WriteInt(nextLevel);
			gSPacketIn.WriteByte((byte)farm.PoultryState);
			gSPacketIn.WriteDateTime(farm.CountDownTime);
			SendTCP(gSPacketIn);
			return result;
		}

		public GSPacketIn SendEnterFarm(PlayerInfo Player, UserFarmInfo farm, UserFieldInfo[] fields)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(81, Player.ID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(farm.FarmID);
			gSPacketIn.WriteBoolean(farm.isFarmHelper);
			gSPacketIn.WriteInt(farm.isAutoId);
			gSPacketIn.WriteDateTime(farm.AutoPayTime);
			gSPacketIn.WriteInt(farm.AutoValidDate);
			gSPacketIn.WriteInt(farm.GainFieldId);
			gSPacketIn.WriteInt(farm.KillCropId);
			gSPacketIn.WriteInt(fields.Length);
			foreach (UserFieldInfo userFieldInfo in fields)
			{
				gSPacketIn.WriteInt(userFieldInfo.FieldID);
				gSPacketIn.WriteInt(userFieldInfo.SeedID);
				gSPacketIn.WriteDateTime(userFieldInfo.PayTime);
				gSPacketIn.WriteDateTime(userFieldInfo.PlantTime);
				gSPacketIn.WriteInt(userFieldInfo.GainCount);
				gSPacketIn.WriteInt(userFieldInfo.FieldValidDate);
				gSPacketIn.WriteInt(userFieldInfo.AccelerateTime);
			}
			if (farm.FarmID == Player.ID)
			{
				gSPacketIn.WriteInt(GameProperties.FastGrowNeedMoney);
				gSPacketIn.WriteString(farm.PayFieldMoney);
				gSPacketIn.WriteString(farm.PayAutoMoney);
				gSPacketIn.WriteDateTime(farm.AutoPayTime);
				gSPacketIn.WriteInt(farm.AutoValidDate);
				gSPacketIn.WriteInt(Player.VIPLevel);
				gSPacketIn.WriteInt(farm.buyExpRemainNum);
			}
			else
			{
				gSPacketIn.WriteBoolean(farm.isArrange);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendFarmLandInfo(PlayerFarm farm)
		{
			UserFieldInfo[] fields = farm.GetFields();
			GSPacketIn gSPacketIn = new GSPacketIn(81, farm.CurrentFarm.FarmID);
			gSPacketIn.WriteByte(17);
			gSPacketIn.WriteInt(fields.Length);
			UserFieldInfo[] array = fields;
			foreach (UserFieldInfo userFieldInfo in array)
			{
				gSPacketIn.WriteInt(userFieldInfo.FieldID);
				gSPacketIn.WriteInt(userFieldInfo.SeedID);
				gSPacketIn.WriteDateTime(userFieldInfo.PlantTime);
				gSPacketIn.WriteInt(userFieldInfo.GainCount);
				gSPacketIn.WriteInt(userFieldInfo.AccelerateTime);
			}
			gSPacketIn.WriteBoolean(farm.midAutumnFlag);
			gSPacketIn.WriteBoolean(farm.CurrentFarm.isFarmHelper);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendHelperSwitchField(PlayerInfo Player, UserFarmInfo farm)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(81, Player.ID);
			gSPacketIn.WriteByte(9);
			gSPacketIn.WriteBoolean(farm.isFarmHelper);
			gSPacketIn.WriteInt(farm.isAutoId);
			gSPacketIn.WriteDateTime(farm.AutoPayTime);
			gSPacketIn.WriteInt(farm.AutoValidDate);
			gSPacketIn.WriteInt(farm.GainFieldId);
			gSPacketIn.WriteInt(farm.KillCropId);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendSeeding(PlayerInfo Player, UserFieldInfo field)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(81, Player.ID);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(field.FieldID);
			gSPacketIn.WriteInt(field.SeedID);
			gSPacketIn.WriteDateTime(field.PlantTime);
			gSPacketIn.WriteDateTime(field.PayTime);
			gSPacketIn.WriteInt(field.GainCount);
			gSPacketIn.WriteInt(field.FieldValidDate);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPayFields(GamePlayer Player, List<int> fieldIds)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(81, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(6);
			gSPacketIn.WriteInt(Player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(fieldIds.Count);
			foreach (int fieldId in fieldIds)
			{
				UserFieldInfo fieldAt = Player.Farm.GetFieldAt(fieldId);
				gSPacketIn.WriteInt(fieldAt.FieldID);
				gSPacketIn.WriteInt(fieldAt.SeedID);
				gSPacketIn.WriteDateTime(fieldAt.PayTime);
				gSPacketIn.WriteDateTime(fieldAt.PlantTime);
				gSPacketIn.WriteInt(fieldAt.GainCount);
				gSPacketIn.WriteInt(fieldAt.FieldValidDate);
				gSPacketIn.WriteInt(fieldAt.AccelerateTime);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendKillCropField(PlayerInfo Player, UserFieldInfo field)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(81, Player.ID);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteInt(field.FieldID);
			gSPacketIn.WriteInt(field.SeedID);
			gSPacketIn.WriteInt(field.AccelerateTime);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendCompose(GamePlayer Player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(81, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(5);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SenddoMature(PlayerFarm farm)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(81, farm.Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(farm.CurrentFields.Length);
			UserFieldInfo[] currentFields = farm.CurrentFields;
			foreach (UserFieldInfo userFieldInfo in currentFields)
			{
				if (userFieldInfo != null)
				{
					gSPacketIn.WriteBoolean(val: true);
					gSPacketIn.WriteInt(userFieldInfo.FieldID);
					gSPacketIn.WriteInt(userFieldInfo.GainCount);
					gSPacketIn.WriteInt(userFieldInfo.AccelerateTime);
				}
				else
				{
					gSPacketIn.WriteBoolean(val: false);
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendtoGather(PlayerInfo Player, UserFieldInfo field)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(81, Player.ID);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteInt(field.FieldID);
			gSPacketIn.WriteInt(field.SeedID);
			gSPacketIn.WriteDateTime(field.PlantTime);
			gSPacketIn.WriteInt(field.GainCount);
			gSPacketIn.WriteInt(field.AccelerateTime);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendPetGuildOptionChange()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(158);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteInt(8);
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendNewPacket(GamePlayer Player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(102, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(0);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendOpenWorldBoss(int pX, int pY)
		{
			BaseWorldBossRoom worldBossRoom = RoomMgr.WorldBossRoom;
			GSPacketIn gSPacketIn = new GSPacketIn(102);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteString(worldBossRoom.bossResourceId);
			gSPacketIn.WriteInt(worldBossRoom.Int32_0);
			gSPacketIn.WriteString("Thần thú");
			gSPacketIn.WriteString(worldBossRoom.name);
			gSPacketIn.WriteLong(worldBossRoom.MaxBlood);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt((pX == 0) ? worldBossRoom.playerDefaultPosX : pX);
			gSPacketIn.WriteInt((pY == 0) ? worldBossRoom.playerDefaultPosY : pY);
			gSPacketIn.WriteDateTime(worldBossRoom.begin_time);
			gSPacketIn.WriteDateTime(worldBossRoom.end_time);
			gSPacketIn.WriteInt(worldBossRoom.fight_time);
			gSPacketIn.WriteBoolean(worldBossRoom.fightOver);
			gSPacketIn.WriteBoolean(worldBossRoom.roomClose);
			gSPacketIn.WriteInt(worldBossRoom.ticketID);
			gSPacketIn.WriteInt(worldBossRoom.need_ticket_count);
			gSPacketIn.WriteInt(worldBossRoom.timeCD);
			gSPacketIn.WriteInt(worldBossRoom.reviveMoney);
			gSPacketIn.WriteInt(worldBossRoom.reFightMoney);
			gSPacketIn.WriteInt(worldBossRoom.addInjureBuffMoney);
			gSPacketIn.WriteInt(worldBossRoom.addInjureValue);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteBoolean(val: false);
			SendTCP(gSPacketIn);
		}

		public void SendOpenOrCloseChristmas(int lastPacks, bool isOpen)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145);
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteBoolean(isOpen);
			if (isOpen)
			{
				DateTime date = DateTime.Parse(GameProperties.ChristmasBeginDate);
				DateTime date2 = DateTime.Parse(GameProperties.ChristmasEndDate);
				gSPacketIn.WriteDateTime(date);
				gSPacketIn.WriteDateTime(date2);
				string[] array = GameProperties.ChristmasGifts.Split('|');
				gSPacketIn.WriteInt(array.Length);
				for (int i = 0; i < array.Length; i++)
				{
					string[] array2 = array[i].Split(',');
					gSPacketIn.WriteInt(int.Parse(array2[0]));
					gSPacketIn.WriteInt(int.Parse(array2[1]));
				}
				gSPacketIn.WriteInt(lastPacks);
				gSPacketIn.WriteInt(GameProperties.ChristmasBuildSnowmanDoubleMoney);
			}
			SendTCP(gSPacketIn);
		}

		public void SendLittleGameActived()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(80);
			gSPacketIn.WriteBoolean(val: true);
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendContinuation(GamePlayer player, HotSpringRoomInfo hotSpringRoomInfo)
		{
			throw new NotImplementedException();
		}

		public GSPacketIn imethod_2(PlayerInfo Player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(92, Player.ID);
			gSPacketIn.WriteByte(Player.typeVIP);
			gSPacketIn.WriteInt(Player.VIPLevel);
			gSPacketIn.WriteInt(Player.VIPExp);
			gSPacketIn.WriteDateTime(Player.VIPExpireDay);
			gSPacketIn.WriteDateTime(Player.LastVIPPackTime);
			gSPacketIn.WriteInt(Player.VIPNextLevelDaysNeeded);
			gSPacketIn.WriteBoolean(Player.CanTakeVipReward);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendCampBattleOpenClose(int ID, bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(146, ID);
			gSPacketIn.WriteByte(10);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteDateTime(DateTime.Now.AddMinutes(90.0));
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendSevenDoubleOpenClose(int ID, bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(148, ID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteBoolean(result);
			if (result)
			{
				gSPacketIn.WriteBoolean(val: false);
				gSPacketIn.WriteInt(3);
				gSPacketIn.WriteInt(33);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(3);
				for (int i = 0; i < 3; i++)
				{
					gSPacketIn.WriteInt(i);
					gSPacketIn.WriteInt(3000);
					gSPacketIn.WriteInt(3 * i);
					gSPacketIn.WriteInt(1);
					gSPacketIn.WriteInt(100100);
					gSPacketIn.WriteInt(10 * i);
				}
				gSPacketIn.WriteInt(11);
				gSPacketIn.WriteInt(22);
				gSPacketIn.WriteInt(33);
				gSPacketIn.WriteInt(5);
				for (int j = 0; j < 5; j++)
				{
					gSPacketIn.WriteInt(j);
				}
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(44);
				gSPacketIn.WriteString("10:20|11:10");
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendConsortiaBattleOpenClose(int ID, bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(153, ID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteBoolean(result);
			if (result)
			{
				gSPacketIn.WriteDateTime(DateTime.Now);
				gSPacketIn.WriteDateTime(DateTime.Now.AddMinutes(90.0));
				gSPacketIn.WriteBoolean(result);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendFightFootballTimeOpenClose(int ID, bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(151, ID);
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendGetBoxTime(int ID, int receiebox, bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(53, ID);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteInt(receiebox);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public static IPacketLib CreatePacketLibForVersion(int rawVersion, GameClient client)
		{
			Type[] derivedClasses = ScriptMgr.GetDerivedClasses(typeof(IPacketLib));
			foreach (Type type in derivedClasses)
			{
				object[] customAttributes = type.GetCustomAttributes(typeof(PacketLibAttribute), inherit: false);
				for (int j = 0; j < customAttributes.Length; j++)
				{
					PacketLibAttribute packetLibAttribute = (PacketLibAttribute)customAttributes[j];
					if (packetLibAttribute.RawVersion != rawVersion)
					{
						continue;
					}
					try
					{
						return (IPacketLib)Activator.CreateInstance(type, client);
					}
					catch (Exception exception)
					{
						if (ilog_0.IsErrorEnabled)
						{
							ilog_0.Error("error creating packetlib (" + type.FullName + ") for raw version " + rawVersion, exception);
						}
					}
				}
			}
			return null;
		}

		public void SendTCP(GSPacketIn packet)
		{
			m_gameClient.SendTCP(packet);
		}

		public void SendWeaklessGuildProgress(PlayerInfo player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(15, player.ID);
			gSPacketIn.WriteInt(player.weaklessGuildProgress.Length);
			for (int i = 0; i < player.weaklessGuildProgress.Length; i++)
			{
				gSPacketIn.WriteByte(player.weaklessGuildProgress[i]);
			}
			SendTCP(gSPacketIn);
		}

		public void SendLoginFailed(string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(1);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
		}

		public void SendLoginSuccess()
		{
			if (m_gameClient.Player != null)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(1, m_gameClient.Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(0);
				gSPacketIn.WriteInt(m_gameClient.Player.ZoneId);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Attack);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Defence);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Agility);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Luck);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.GP);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Repute);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Gold);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Money);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.DDTMoney);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Score);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Hide);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.FightPower);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteString("");
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteString("");
				gSPacketIn.WriteDateTime(DateTime.Now.AddDays(50.0));
				gSPacketIn.WriteByte(m_gameClient.Player.PlayerCharacter.typeVIP);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.VIPLevel);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.VIPExp);
				gSPacketIn.WriteDateTime(m_gameClient.Player.PlayerCharacter.VIPExpireDay);
				gSPacketIn.WriteDateTime(m_gameClient.Player.PlayerCharacter.LastDate);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.VIPNextLevelDaysNeeded);
				gSPacketIn.WriteDateTime(DateTime.Now);
				gSPacketIn.WriteBoolean(m_gameClient.Player.PlayerCharacter.CanTakeVipReward);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.OptionOnOff);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.AchievementPoint);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.Honor);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.honorId);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.OnlineTime);
				gSPacketIn.WriteBoolean(m_gameClient.Player.PlayerCharacter.Sex);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.Style + "&" + m_gameClient.Player.PlayerCharacter.Colors);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.Skin);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.ConsortiaID);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.ConsortiaName);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.badgeID);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.DutyLevel);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.DutyName);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Right);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.ChairmanName);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.ConsortiaHonor);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.ConsortiaRiches);
				gSPacketIn.WriteBoolean(m_gameClient.Player.PlayerCharacter.HasBagPassword);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.PasswordQuest1);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.PasswordQuest2);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.FailedPasswordAttemptCount);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.UserName);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Nimbus);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.PvePermission);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.FightLabPermission);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.AnswerSite);
				gSPacketIn.WriteDateTime(m_gameClient.Player.PlayerCharacter.LastSpaDate);
				gSPacketIn.WriteDateTime(DateTime.Now);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Offer);
				gSPacketIn.WriteInt(m_gameClient.Player.BattleData.MatchInfo.dailyScore);
				gSPacketIn.WriteInt(m_gameClient.Player.BattleData.MatchInfo.dailyWinCount);
				gSPacketIn.WriteInt(m_gameClient.Player.BattleData.MatchInfo.dailyGameCount);
				gSPacketIn.WriteBoolean(m_gameClient.Player.BattleData.MatchInfo.DailyLeagueFirst);
				gSPacketIn.WriteInt(m_gameClient.Player.BattleData.MatchInfo.DailyLeagueLastScore);
				gSPacketIn.WriteInt(m_gameClient.Player.BattleData.MatchInfo.weeklyScore);
				gSPacketIn.WriteInt(m_gameClient.Player.BattleData.MatchInfo.weeklyGameCount);
				gSPacketIn.WriteInt(m_gameClient.Player.BattleData.MatchInfo.weeklyRanking);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.spdTexpExp);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.attTexpExp);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.defTexpExp);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.hpTexpExp);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.lukTexpExp);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.texpTaskCount);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.texpCount);
				gSPacketIn.WriteDateTime(m_gameClient.Player.PlayerCharacter.Texp.texpTaskDate);
				gSPacketIn.WriteBoolean(m_gameClient.Player.PlayerCharacter.isOldPlayerHasValidEquitAtLogin);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.badLuckNumber);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.luckyNum);
				gSPacketIn.WriteDateTime(m_gameClient.Player.PlayerCharacter.lastLuckyNumDate);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.lastLuckNum);
				gSPacketIn.WriteBoolean(m_gameClient.Player.PlayerCharacter.IsOldPlayer);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.CardSoul);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.GetSoulCount);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.uesedFinishTime);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.totemId);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.necklaceExp);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.accumulativeLoginDays);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.accumulativeAwardDays);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.isFirstDivorce);
				gSPacketIn.WriteString(m_gameClient.Player.PlayerCharacter.PveEpicPermission);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.MountsType);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.PetsID);
				gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.horseRaceCanRaceTime);
				SendTCP(gSPacketIn);
			}
		}

		public void method_0(byte[] m, byte[] e)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(7);
			gSPacketIn.Write(m);
			gSPacketIn.Write(e);
			SendTCP(gSPacketIn);
		}

		public void SendUpdateCountHorseRace(int count)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(282);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(count);
			SendTCP(gSPacketIn);
		}

		public void SendNotEnoughEnergyBuy(bool MustBuy)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(20);
			gSPacketIn.WriteBoolean(MustBuy);
			SendTCP(gSPacketIn);
		}

		public void SendUpdateAreaInfo()
		{
			AreaConfigInfo[] allAreaConfig = WorldMgr.GetAllAreaConfig();
			GSPacketIn gSPacketIn = new GSPacketIn(210);
			gSPacketIn.WriteInt(allAreaConfig.Length);
			AreaConfigInfo[] array = allAreaConfig;
			foreach (AreaConfigInfo areaConfigInfo in array)
			{
				gSPacketIn.WriteInt(areaConfigInfo.AreaID);
				gSPacketIn.WriteString(areaConfigInfo.AreaName);
			}
			SendTCP(gSPacketIn);
		}

		public void SendCheckCode()
		{
			if (m_gameClient.Player != null && m_gameClient.Player.PlayerCharacter.CheckCount >= GameProperties.CHECK_MAX_FAILED_COUNT)
			{
				if (m_gameClient.Player.PlayerCharacter.CheckError == 0)
				{
					m_gameClient.Player.PlayerCharacter.CheckCount += 10000;
				}
				GSPacketIn gSPacketIn = new GSPacketIn(200, m_gameClient.Player.PlayerCharacter.ID, 10240);
				if (m_gameClient.Player.PlayerCharacter.CheckError < 1)
				{
					gSPacketIn.WriteByte(0);
				}
				else
				{
					gSPacketIn.WriteByte(2);
				}
				gSPacketIn.WriteBoolean(val: true);
				m_gameClient.Player.PlayerCharacter.CheckCode = CheckCode.GenerateCheckCode();
				gSPacketIn.Write(CheckCode.CreateImage(m_gameClient.Player.PlayerCharacter.CheckCode));
				SendTCP(gSPacketIn);
			}
		}

		public void SendKitoff(string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(2);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
		}

		public void SendEditionError(string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(12);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
		}

		public void SendWaitingRoom(bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(16);
			gSPacketIn.WriteByte((byte)(result ? 1u : 0u));
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendCollectInfor(int id, byte state)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(32, id);
			gSPacketIn.WriteByte(state);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public virtual GSPacketIn SendMessage(eMessageType type, string message)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(3);
			gSPacketIn.WriteInt((int)type);
			gSPacketIn.WriteString(message);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendReady()
		{
			GSPacketIn packet = new GSPacketIn(0);
			SendTCP(packet);
		}

		public void SendUpdatePrivateInfo(PlayerInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(38, info.ID);
			gSPacketIn.WriteInt(info.Money);
			gSPacketIn.WriteInt(info.DDTMoney);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(info.Score);
			gSPacketIn.WriteInt(info.Gold);
			gSPacketIn.WriteInt(info.badLuckNumber);
			gSPacketIn.WriteInt(info.damageScores);
			gSPacketIn.WriteInt(info.petScore);
			gSPacketIn.WriteInt(info.myHonor);
			gSPacketIn.WriteInt(info.hardCurrency);
			SendTCP(gSPacketIn);
		}

		public void SendLeagueNotice(int id, int restCount, int maxCount, byte type)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(42, id);
			gSPacketIn.WriteByte(type);
			if (type == 1)
			{
				gSPacketIn.WriteInt(restCount);
				gSPacketIn.WriteInt(maxCount);
			}
			else
			{
				gSPacketIn.WriteInt(restCount);
			}
			SendTCP(gSPacketIn);
		}

		public void SendDragonBoat(PlayerInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(100, info.ID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(DragonBoatMgr.periodType());
			gSPacketIn.WriteInt(DragonBoatMgr.boatCompleteExp());
			SendTCP(gSPacketIn);
		}

		public void SendSuperWinnerOpen(int playerID, bool isOpen)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, playerID);
			gSPacketIn.WriteByte(48);
			gSPacketIn.WriteBoolean(isOpen);
			SendTCP(gSPacketIn);
		}

		public void SendCatchBeastOpen(int playerID, bool isOpen)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, playerID);
			gSPacketIn.WriteByte(32);
			gSPacketIn.WriteBoolean(isOpen);
			SendTCP(gSPacketIn);
		}

		public void SendLanternriddlesOpen(int playerID, bool isOpen)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, playerID);
			gSPacketIn.WriteByte(37);
			gSPacketIn.WriteBoolean(isOpen);
			SendTCP(gSPacketIn);
		}

		public void SendGuildMemberWeekOpenClose(PyramidConfigInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, info.UserID);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteBoolean(info.isOpen);
			gSPacketIn.WriteString(info.beginTime.ToString());
			gSPacketIn.WriteString(info.endTime.ToString());
			SendTCP(gSPacketIn);
		}

		public void imethod_1(int UserID, GClass1 QQTips)
		{
			if (QQTips != null)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(99, UserID);
				gSPacketIn.WriteString(QQTips.title);
				gSPacketIn.WriteString(QQTips.content);
				gSPacketIn.WriteInt(QQTips.maxLevel);
				gSPacketIn.WriteInt(QQTips.minLevel);
				gSPacketIn.WriteInt(QQTips.outInType);
				if (QQTips.outInType == 0)
				{
					gSPacketIn.WriteInt(QQTips.moduleType);
					gSPacketIn.WriteInt(QQTips.inItemID);
				}
				else
				{
					gSPacketIn.WriteString(QQTips.url);
				}
				SendTCP(gSPacketIn);
			}
		}

		public void imethod_0(int UserID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(360, UserID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(60);
			SendTCP(gSPacketIn);
		}

		public void SendTreasureHunting(PyramidConfigInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(110, info.UserID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteDateTime(DateTime.Now.AddDays(1.0));
			gSPacketIn.WriteInt(10000);
			SendTCP(gSPacketIn);
			SendMysteriousActivity(info);
		}

		public void SendMysteriousActivity(PyramidConfigInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(110, info.UserID);
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(2);
			gSPacketIn.WriteInt(3);
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteDateTime(DateTime.Now.AddDays(1.0));
			SendTCP(gSPacketIn);
		}

		public void SendPyramidOpenClose(PyramidConfigInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, info.UserID);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteBoolean(info.isOpen);
			gSPacketIn.WriteBoolean(info.isScoreExchange);
			gSPacketIn.WriteDateTime(info.beginTime);
			gSPacketIn.WriteDateTime(info.endTime);
			gSPacketIn.WriteInt(info.freeCount);
			gSPacketIn.WriteInt(info.turnCardPrice);
			gSPacketIn.WriteInt(info.revivePrice.Length);
			for (int i = 0; i < info.revivePrice.Length; i++)
			{
				gSPacketIn.WriteInt(info.revivePrice[i]);
			}
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendUpdatePlayerProperty(PlayerInfo info, PlayerProperty PlayerProp)
		{
			string[] array = new string[4] { "Attack", "Defence", "Agility", "Luck" };
			GSPacketIn gSPacketIn = new GSPacketIn(164, info.ID);
			gSPacketIn.WriteInt(info.ID);
			gSPacketIn.WriteInt(info.ZoneID);
			string[] array2 = array;
			foreach (string key in array2)
			{
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(PlayerProp.Current["Texp"][key]);
				gSPacketIn.WriteInt(PlayerProp.Current["Card"][key]);
				gSPacketIn.WriteInt(PlayerProp.Current["Pet"][key]);
				gSPacketIn.WriteInt(PlayerProp.Current["Suit"][key]);
				gSPacketIn.WriteInt(PlayerProp.Current["Gem"][key]);
				gSPacketIn.WriteInt(PlayerProp.Current["Bead"][key]);
				gSPacketIn.WriteInt(PlayerProp.Current["Avatar"][key]);
				gSPacketIn.WriteInt(PlayerProp.Current["MagicStone"][key]);
			}
			gSPacketIn.WriteInt(PlayerProp.Current["MagicAttack"]["MagicStone"]);
			gSPacketIn.WriteInt(PlayerProp.Current["MagicAttack"]["Horse"]);
			gSPacketIn.WriteInt(PlayerProp.Current["MagicAttack"]["HorsePicCherish"]);
			gSPacketIn.WriteInt(PlayerProp.Current["MagicAttack"]["Enchant"]);
			gSPacketIn.WriteInt(PlayerProp.Current["MagicAttack"]["Suit"]);
			gSPacketIn.WriteInt(PlayerProp.Current["MagicDefence"]["MagicStone"]);
			gSPacketIn.WriteInt(PlayerProp.Current["MagicDefence"]["Horse"]);
			gSPacketIn.WriteInt(PlayerProp.Current["MagicDefence"]["HorsePicCherish"]);
			gSPacketIn.WriteInt(PlayerProp.Current["MagicDefence"]["Enchant"]);
			gSPacketIn.WriteInt(PlayerProp.Current["MagicDefence"]["Suit"]);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(PlayerProp.Current["Texp"]["HP"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Pet"]["HP"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Bead"]["HP"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Suit"]["HP"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Gem"]["HP"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Avatar"]["HP"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Horse"]["HP"]);
			gSPacketIn.WriteInt(PlayerProp.Current["HorsePicCherish"]["HP"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Damage"]["Suit"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Armor"]["Suit"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Damage"]["Bead"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Damage"]["Avatar"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Damage"]["Horse"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Damage"]["HorsePicCherish"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Armor"]["Bead"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Armor"]["Avatar"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Armor"]["Horse"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Armor"]["HorsePicCherish"]);
			gSPacketIn.WriteInt(PlayerProp.Current["Armor"]["Pet"]);
			gSPacketIn.WriteInt(PlayerProp.totalDamage);
			gSPacketIn.WriteInt(PlayerProp.totalArmor);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUpdatePublicPlayer(PlayerInfo info, UserMatchInfo matchInfo)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(67, info.ID);
			gSPacketIn.WriteInt(info.GP);
			gSPacketIn.WriteInt(info.Offer);
			gSPacketIn.WriteInt(info.RichesOffer);
			gSPacketIn.WriteInt(info.RichesRob);
			gSPacketIn.WriteInt(info.Win);
			gSPacketIn.WriteInt(info.Total);
			gSPacketIn.WriteInt(info.Escape);
			gSPacketIn.WriteInt(info.Attack);
			gSPacketIn.WriteInt(info.Defence);
			gSPacketIn.WriteInt(info.Agility);
			gSPacketIn.WriteInt(info.Luck);
			gSPacketIn.WriteInt(info.MagicAttack);
			gSPacketIn.WriteInt(info.MagicDefence);
			gSPacketIn.WriteInt(info.hp);
			gSPacketIn.WriteInt(info.Hide);
			gSPacketIn.WriteString(info.Style);
			gSPacketIn.WriteString(info.Colors);
			gSPacketIn.WriteString(info.Skin);
			gSPacketIn.WriteBoolean(info.IsShowConsortia);
			gSPacketIn.WriteInt(info.ConsortiaID);
			gSPacketIn.WriteString(info.ConsortiaName);
			gSPacketIn.WriteInt(info.badgeID);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(info.Nimbus);
			gSPacketIn.WriteString(info.PvePermission);
			gSPacketIn.WriteString(info.FightLabPermission);
			gSPacketIn.WriteInt(info.FightPower);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString("");
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString("");
			gSPacketIn.WriteInt(info.AchievementPoint);
			gSPacketIn.WriteString(info.Honor);
			gSPacketIn.WriteInt(info.honorId);
			gSPacketIn.WriteDateTime(info.LastSpaDate);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteInt(info.Offer);
			gSPacketIn.WriteInt(matchInfo.dailyScore);
			gSPacketIn.WriteInt(matchInfo.dailyWinCount);
			gSPacketIn.WriteInt(matchInfo.dailyGameCount);
			gSPacketIn.WriteInt(matchInfo.weeklyScore);
			gSPacketIn.WriteInt(matchInfo.weeklyGameCount);
			gSPacketIn.WriteInt(info.LeagueMoney);
			gSPacketIn.WriteInt(info.Texp.spdTexpExp);
			gSPacketIn.WriteInt(info.Texp.attTexpExp);
			gSPacketIn.WriteInt(info.Texp.defTexpExp);
			gSPacketIn.WriteInt(info.Texp.hpTexpExp);
			gSPacketIn.WriteInt(info.Texp.lukTexpExp);
			gSPacketIn.WriteInt(info.Texp.texpTaskCount);
			gSPacketIn.WriteInt(info.Texp.texpCount);
			gSPacketIn.WriteDateTime(info.Texp.texpTaskDate);
			gSPacketIn.WriteInt(10);
			for (int i = 1; i <= 10; i++)
			{
				gSPacketIn.WriteInt(i);
				gSPacketIn.WriteByte(10);
			}
			gSPacketIn.WriteString(info.PveEpicPermission);
			gSPacketIn.WriteInt(info.evolutionGrade);
			gSPacketIn.WriteInt(info.evolutionExp);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendPingTime(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(4);
			player.PingStart = DateTime.Now.Ticks;
			gSPacketIn.WriteInt(player.PlayerCharacter.AntiAddiction);
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendNetWork(GamePlayer player, long delay)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(6, player.PlayerId);
			gSPacketIn.WriteInt((int)delay / 1000 / 10);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUserEquip(PlayerInfo player, List<ItemInfo> items, List<UserGemStone> UserGemStone, List<ItemInfo> beadItems, List<ItemInfo> magicStones)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(74, player.ID);
			gSPacketIn.WriteInt(player.ID);
			gSPacketIn.WriteInt(player.ZoneID);
			gSPacketIn.WriteString(player.NickName);
			gSPacketIn.WriteInt(player.Agility);
			gSPacketIn.WriteInt(player.Attack);
			gSPacketIn.WriteString(player.Colors);
			gSPacketIn.WriteString(player.Skin);
			gSPacketIn.WriteInt(player.Defence);
			gSPacketIn.WriteInt(player.GP);
			gSPacketIn.WriteInt(player.Grade);
			gSPacketIn.WriteInt(player.Luck);
			gSPacketIn.WriteInt(player.hp);
			gSPacketIn.WriteInt(player.Hide);
			gSPacketIn.WriteInt(player.Repute);
			gSPacketIn.WriteBoolean(player.Sex);
			gSPacketIn.WriteString(player.Style);
			gSPacketIn.WriteInt(player.Offer);
			gSPacketIn.WriteByte(player.typeVIP);
			gSPacketIn.WriteInt(player.VIPLevel);
			gSPacketIn.WriteBoolean(player.isOpenKingBless);
			gSPacketIn.WriteInt(player.Win);
			gSPacketIn.WriteInt(player.Total);
			gSPacketIn.WriteInt(player.Escape);
			gSPacketIn.WriteInt(player.ConsortiaID);
			gSPacketIn.WriteString(player.ConsortiaName);
			gSPacketIn.WriteInt(player.badgeID);
			gSPacketIn.WriteInt(player.RichesOffer);
			gSPacketIn.WriteInt(player.RichesRob);
			gSPacketIn.WriteBoolean(player.IsMarried);
			gSPacketIn.WriteInt(player.SpouseID);
			gSPacketIn.WriteString(player.SpouseName);
			gSPacketIn.WriteString(player.DutyName);
			gSPacketIn.WriteInt(player.Nimbus);
			gSPacketIn.WriteInt(player.FightPower);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString("");
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString("");
			gSPacketIn.WriteInt(player.AchievementPoint);
			gSPacketIn.WriteString(player.Honor);
			gSPacketIn.WriteDateTime(DateTime.Now.AddDays(-2.0));
			gSPacketIn.WriteInt(player.Texp.spdTexpExp);
			gSPacketIn.WriteInt(player.Texp.attTexpExp);
			gSPacketIn.WriteInt(player.Texp.defTexpExp);
			gSPacketIn.WriteInt(player.Texp.hpTexpExp);
			gSPacketIn.WriteInt(player.Texp.lukTexpExp);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(player.totemId);
			gSPacketIn.WriteInt(player.necklaceExp);
			gSPacketIn.WriteInt(player.MountLv);
			gSPacketIn.WriteInt(items.Count);
			foreach (ItemInfo item in items)
			{
				gSPacketIn.WriteByte((byte)item.BagType);
				gSPacketIn.WriteInt(item.UserID);
				gSPacketIn.WriteInt(item.ItemID);
				gSPacketIn.WriteInt(item.Count);
				gSPacketIn.WriteInt(item.Place);
				gSPacketIn.WriteInt(item.TemplateID);
				gSPacketIn.WriteInt(item.AttackCompose);
				gSPacketIn.WriteInt(item.DefendCompose);
				gSPacketIn.WriteInt(item.AgilityCompose);
				gSPacketIn.WriteInt(item.LuckCompose);
				gSPacketIn.WriteInt(item.StrengthenLevel);
				gSPacketIn.WriteBoolean(item.IsBinds);
				gSPacketIn.WriteBoolean(item.IsJudge);
				gSPacketIn.WriteDateTime(item.BeginDate);
				gSPacketIn.WriteInt(item.ValidDate);
				gSPacketIn.WriteString(item.Color);
				gSPacketIn.WriteString(item.Skin);
				gSPacketIn.WriteBoolean(item.IsUsed);
				gSPacketIn.WriteInt(item.Hole1);
				gSPacketIn.WriteInt(item.Hole2);
				gSPacketIn.WriteInt(item.Hole3);
				gSPacketIn.WriteInt(item.Hole4);
				gSPacketIn.WriteInt(item.Hole5);
				gSPacketIn.WriteInt(item.Hole6);
				gSPacketIn.WriteString(item.Pic);
				gSPacketIn.WriteInt(item.RefineryLevel);
				gSPacketIn.WriteDateTime(DateTime.Now);
				gSPacketIn.WriteByte((byte)item.Int32_0);
				gSPacketIn.WriteInt(item.Hole5Exp);
				gSPacketIn.WriteByte((byte)item.Int32_1);
				gSPacketIn.WriteInt(item.Hole6Exp);
				gSPacketIn.WriteBoolean(item.IsGold);
				if (item.IsGold)
				{
					gSPacketIn.WriteInt(item.goldValidDate);
					gSPacketIn.WriteDateTime(item.goldBeginTime);
				}
				gSPacketIn.WriteString(item.latentEnergyCurStr);
				gSPacketIn.WriteString(item.latentEnergyNewStr);
				gSPacketIn.WriteDateTime(item.latentEnergyEndTime);
				gSPacketIn.WriteInt(item.MagicLevel);
			}
			gSPacketIn.WriteInt(beadItems.Count);
			foreach (ItemInfo beadItem in beadItems)
			{
				gSPacketIn.WriteByte((byte)beadItem.BagType);
				gSPacketIn.WriteInt(beadItem.UserID);
				gSPacketIn.WriteInt(beadItem.ItemID);
				gSPacketIn.WriteInt(beadItem.Count);
				gSPacketIn.WriteInt(beadItem.Place);
				gSPacketIn.WriteInt(beadItem.TemplateID);
				gSPacketIn.WriteInt(beadItem.AttackCompose);
				gSPacketIn.WriteInt(beadItem.DefendCompose);
				gSPacketIn.WriteInt(beadItem.AgilityCompose);
				gSPacketIn.WriteInt(beadItem.LuckCompose);
				gSPacketIn.WriteInt(beadItem.StrengthenLevel);
				gSPacketIn.WriteBoolean(beadItem.IsBinds);
				gSPacketIn.WriteBoolean(beadItem.IsJudge);
				gSPacketIn.WriteDateTime(beadItem.BeginDate);
				gSPacketIn.WriteInt(beadItem.ValidDate);
				gSPacketIn.WriteString(beadItem.Color);
				gSPacketIn.WriteString(beadItem.Skin);
				gSPacketIn.WriteBoolean(beadItem.IsUsed);
				gSPacketIn.WriteInt(beadItem.Hole1);
				gSPacketIn.WriteInt(beadItem.Hole2);
				gSPacketIn.WriteInt(beadItem.Hole3);
				gSPacketIn.WriteInt(beadItem.Hole4);
				gSPacketIn.WriteInt(beadItem.Hole5);
				gSPacketIn.WriteInt(beadItem.Hole6);
				gSPacketIn.WriteString(beadItem.Pic);
				gSPacketIn.WriteInt(beadItem.RefineryLevel);
				gSPacketIn.WriteDateTime(DateTime.Now);
				gSPacketIn.WriteByte((byte)beadItem.Int32_0);
				gSPacketIn.WriteInt(beadItem.Hole5Exp);
				gSPacketIn.WriteByte((byte)beadItem.Int32_1);
				gSPacketIn.WriteInt(beadItem.Hole6Exp);
				gSPacketIn.WriteBoolean(beadItem.IsGold);
			}
			gSPacketIn.WriteInt(UserGemStone.Count);
			for (int i = 0; i < UserGemStone.Count; i++)
			{
				gSPacketIn.WriteInt(UserGemStone[i].FigSpiritId);
				gSPacketIn.WriteString(UserGemStone[i].FigSpiritIdValue);
				gSPacketIn.WriteInt(UserGemStone[i].EquipPlace);
			}
			gSPacketIn.WriteInt(player.evolutionGrade);
			gSPacketIn.WriteInt(player.evolutionExp);
			gSPacketIn.WriteInt(player.MagicAttack);
			gSPacketIn.WriteInt(player.MagicDefence);
			gSPacketIn.WriteInt(magicStones.Count);
			foreach (ItemInfo magicStone in magicStones)
			{
				gSPacketIn.WriteInt(magicStone.Place);
				gSPacketIn.WriteInt(magicStone.TemplateID);
				gSPacketIn.WriteInt(magicStone.StrengthenLevel);
				gSPacketIn.WriteInt(magicStone.AttackCompose);
				gSPacketIn.WriteInt(magicStone.DefendCompose);
				gSPacketIn.WriteInt(magicStone.AgilityCompose);
				gSPacketIn.WriteInt(magicStone.LuckCompose);
				gSPacketIn.WriteInt(magicStone.MagicAttack);
				gSPacketIn.WriteInt(magicStone.MagicDefence);
			}
			gSPacketIn.WriteInt(player.MountsType);
			gSPacketIn.Compress();
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendOpenWorshipTheMoon(bool open)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(281);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteBoolean(open);
			SendTCP(gSPacketIn);
		}

		public void SendOpenEntertainmentMode()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145);
			gSPacketIn.WriteByte(71);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteDateTime(DateTime.Now.AddDays(7.0));
			SendTCP(gSPacketIn);
		}

		public void SendUesedFinishTime(int uesedFinishTime)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(86);
			gSPacketIn.WriteInt(uesedFinishTime);
			SendTCP(gSPacketIn);
		}

		public void SendDateTime()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(5);
			gSPacketIn.WriteDateTime(DateTime.Now);
			SendTCP(gSPacketIn);
		}

		public void SendchangeHorse(int curIndex)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(260);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(curIndex);
			SendTCP(gSPacketIn);
		}

		public void SendPicCherishInfo(int playerId, MountDrawDataInfo[] draws)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(260, playerId);
			gSPacketIn.WriteByte(8);
			gSPacketIn.WriteInt(draws.Length);
			foreach (MountDrawDataInfo mountDrawDataInfo in draws)
			{
				gSPacketIn.WriteInt(mountDrawDataInfo.ID);
				gSPacketIn.WriteInt(mountDrawDataInfo.Active);
			}
			SendTCP(gSPacketIn);
		}

		public void SendHorseInitAllData(MountDataInfo info, MountSkillDataInfo[] skills)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(260, info.UserID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(info.curUseHorse);
			gSPacketIn.WriteInt(info.curLevel);
			gSPacketIn.WriteInt(info.curExp);
			gSPacketIn.WriteInt(skills.Length);
			foreach (MountSkillDataInfo mountSkillDataInfo in skills)
			{
				gSPacketIn.WriteInt(mountSkillDataInfo.SKillID);
				gSPacketIn.WriteInt(mountSkillDataInfo.Exp);
				gSPacketIn.WriteInt(mountSkillDataInfo.IsUse);
			}
			SendTCP(gSPacketIn);
		}

		public void SendUpHorse(bool isHasLevelUp, int grade, int exp)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(260);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteBoolean(isHasLevelUp);
			gSPacketIn.WriteInt(grade);
			gSPacketIn.WriteInt(exp);
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendDailyAward(PlayerInfo player)
		{
			bool val = false;
			if (DateTime.Now.Date != player.LastAward.Date)
			{
				val = true;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(13, player.ID);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteInt(0);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUpdateGoodsCount(PlayerInfo player, ShopItemInfo[] BagList, ShopItemInfo[] ConsoList)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(168, player.ID);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(player.ConsortiaID);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUpdateRoomList(List<BaseRoom> roomlist)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(9);
			gSPacketIn.WriteInt(roomlist.Count);
			int num = ((roomlist.Count < 8) ? roomlist.Count : 8);
			gSPacketIn.WriteInt(num);
			for (int i = 0; i < num; i++)
			{
				BaseRoom baseRoom = roomlist[i];
				gSPacketIn.WriteInt(baseRoom.RoomId);
				gSPacketIn.WriteByte((byte)baseRoom.RoomType);
				gSPacketIn.WriteByte(baseRoom.TimeMode);
				gSPacketIn.WriteByte((byte)baseRoom.PlayerCount);
				gSPacketIn.WriteByte((byte)baseRoom.viewerCnt);
				gSPacketIn.WriteByte((byte)baseRoom.maxViewerCnt);
				gSPacketIn.WriteByte((byte)baseRoom.PlacesCount);
				gSPacketIn.WriteBoolean(!string.IsNullOrEmpty(baseRoom.Password));
				gSPacketIn.WriteInt(baseRoom.MapId);
				gSPacketIn.WriteBoolean(baseRoom.IsPlaying);
				gSPacketIn.WriteString(baseRoom.Name);
				gSPacketIn.WriteByte((byte)baseRoom.GameType);
				gSPacketIn.WriteByte((byte)baseRoom.HardLevel);
				gSPacketIn.WriteInt(baseRoom.LevelLimits);
				gSPacketIn.WriteBoolean(baseRoom.isOpenBoss);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendSceneAddPlayer(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(18, player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(player.PlayerCharacter.Grade);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.Sex);
			gSPacketIn.WriteString(player.PlayerCharacter.NickName);
			gSPacketIn.WriteByte(player.PlayerCharacter.typeVIP);
			gSPacketIn.WriteInt(player.PlayerCharacter.VIPLevel);
			gSPacketIn.WriteString(player.PlayerCharacter.ConsortiaName);
			gSPacketIn.WriteInt(player.PlayerCharacter.Offer);
			gSPacketIn.WriteInt(player.PlayerCharacter.Win);
			gSPacketIn.WriteInt(player.PlayerCharacter.Total);
			gSPacketIn.WriteInt(player.PlayerCharacter.Escape);
			gSPacketIn.WriteInt(player.PlayerCharacter.ConsortiaID);
			gSPacketIn.WriteInt(player.PlayerCharacter.Repute);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.IsMarried);
			if (player.PlayerCharacter.IsMarried)
			{
				gSPacketIn.WriteInt(player.PlayerCharacter.SpouseID);
				gSPacketIn.WriteString(player.PlayerCharacter.SpouseName);
			}
			gSPacketIn.WriteString(player.PlayerCharacter.UserName);
			gSPacketIn.WriteInt(player.PlayerCharacter.FightPower);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.IsOldPlayer);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendSceneRemovePlayer(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(21, player.PlayerCharacter.ID);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendGameMissionStart()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(82);
			gSPacketIn.WriteBoolean(val: true);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendGameMissionPrepare()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(116);
			gSPacketIn.WriteBoolean(val: true);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomPlayerAdd(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94, player.PlayerId);
			gSPacketIn.WriteByte(4);
			bool val = false;
			if (player.CurrentRoom.Game != null)
			{
				val = true;
			}
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteByte((byte)player.CurrentRoomIndex);
			gSPacketIn.WriteByte((byte)player.CurrentRoomTeam);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteInt(player.PlayerCharacter.Grade);
			gSPacketIn.WriteInt(player.PlayerCharacter.Offer);
			gSPacketIn.WriteInt(player.PlayerCharacter.Hide);
			gSPacketIn.WriteInt(player.PlayerCharacter.Repute);
			gSPacketIn.WriteInt((int)player.PingTime / 1000 / 10);
			gSPacketIn.WriteInt(player.ZoneId);
			gSPacketIn.WriteInt(player.Actives.Info.activityTanabataNum);
			gSPacketIn.WriteInt(player.PlayerCharacter.ID);
			gSPacketIn.WriteString(player.PlayerCharacter.NickName);
			gSPacketIn.WriteByte(player.PlayerCharacter.typeVIP);
			gSPacketIn.WriteInt(player.PlayerCharacter.VIPLevel);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.Sex);
			gSPacketIn.WriteString(player.PlayerCharacter.Style);
			gSPacketIn.WriteString(player.PlayerCharacter.Colors);
			gSPacketIn.WriteString(player.PlayerCharacter.Skin);
			gSPacketIn.WriteInt((player.MainWeapon == null) ? 7008 : player.MainWeapon.TemplateID);
			if (player.SecondWeapon == null)
			{
				gSPacketIn.WriteInt(0);
			}
			else
			{
				gSPacketIn.WriteInt(player.SecondWeapon.TemplateID);
			}
			gSPacketIn.WriteInt(player.PlayerCharacter.ConsortiaID);
			gSPacketIn.WriteString(player.PlayerCharacter.ConsortiaName);
			gSPacketIn.WriteInt(player.PlayerCharacter.badgeID);
			gSPacketIn.WriteInt(player.PlayerCharacter.Win);
			gSPacketIn.WriteInt(player.PlayerCharacter.Total);
			gSPacketIn.WriteInt(player.PlayerCharacter.Escape);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.IsMarried);
			if (player.PlayerCharacter.IsMarried)
			{
				gSPacketIn.WriteInt(player.PlayerCharacter.SpouseID);
				gSPacketIn.WriteString(player.PlayerCharacter.SpouseName);
			}
			gSPacketIn.WriteString(player.PlayerCharacter.UserName);
			gSPacketIn.WriteInt(player.PlayerCharacter.Nimbus);
			gSPacketIn.WriteInt(player.PlayerCharacter.FightPower);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString("Master");
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString("HonorOfMaster");
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.IsOldPlayer);
			if (player.Pet == null)
			{
				gSPacketIn.WriteInt(0);
			}
			else
			{
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(player.Pet.Place);
				gSPacketIn.WriteInt(player.Pet.TemplateID);
				gSPacketIn.WriteInt(player.Pet.ID);
				gSPacketIn.WriteString(player.Pet.Name);
				gSPacketIn.WriteInt(player.PlayerCharacter.ID);
				gSPacketIn.WriteInt(player.Pet.Level);
				List<string> skillEquip = player.Pet.GetSkillEquip();
				gSPacketIn.WriteInt(skillEquip.Count);
				foreach (string item in skillEquip)
				{
					gSPacketIn.WriteInt(int.Parse(item.Split(',')[1]));
					gSPacketIn.WriteInt(int.Parse(item.Split(',')[0]));
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomPlayerRemove(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94, player.PlayerId);
			gSPacketIn.WriteByte(5);
			gSPacketIn.Parameter1 = player.PlayerId;
			gSPacketIn.WriteInt(player.ZoneId);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomUpdatePlayerStates(byte[] states)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(15);
			for (int i = 0; i < states.Length; i++)
			{
				gSPacketIn.WriteByte(states[i]);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomUpdatePlacesStates(int[] states)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(10);
			for (int i = 0; i < states.Length; i++)
			{
				gSPacketIn.WriteInt(states[i]);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomPlayerChangedTeam(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94, player.PlayerId);
			gSPacketIn.WriteByte(6);
			gSPacketIn.WriteByte((byte)player.CurrentRoomTeam);
			gSPacketIn.WriteByte((byte)player.CurrentRoomIndex);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomCreate(BaseRoom room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteInt(room.RoomId);
			gSPacketIn.WriteByte((byte)room.RoomType);
			gSPacketIn.WriteByte((byte)room.HardLevel);
			gSPacketIn.WriteByte(room.TimeMode);
			gSPacketIn.WriteByte((byte)room.PlayerCount);
			gSPacketIn.WriteByte((byte)room.viewerCnt);
			gSPacketIn.WriteByte((byte)room.PlacesCount);
			gSPacketIn.WriteBoolean(!string.IsNullOrEmpty(room.Password));
			gSPacketIn.WriteInt(room.MapId);
			gSPacketIn.WriteBoolean(room.IsPlaying);
			gSPacketIn.WriteString(room.Name);
			gSPacketIn.WriteByte((byte)room.GameType);
			gSPacketIn.WriteInt(room.LevelLimits);
			gSPacketIn.WriteBoolean(room.isCrosszone);
			gSPacketIn.WriteBoolean(room.isWithinLeageTime);
			gSPacketIn.WriteBoolean(room.isOpenBoss);
			gSPacketIn.WriteString(room.Pic);
			gSPacketIn.WriteBoolean(val: false);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendSingleRoomCreate(BaseRoom room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(18);
			gSPacketIn.WriteInt(room.RoomId);
			gSPacketIn.WriteByte((byte)room.RoomType);
			gSPacketIn.WriteBoolean(room.IsPlaying);
			gSPacketIn.WriteByte((byte)room.GameType);
			gSPacketIn.WriteInt(room.MapId);
			gSPacketIn.WriteBoolean(room.isCrosszone);
			gSPacketIn.WriteInt(room.ZoneId);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteByte((byte)room.HardLevel);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomLoginResult(bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomPairUpStart(BaseRoom room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(13);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomType(GamePlayer player, BaseRoom game)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(12);
			gSPacketIn.WriteByte((byte)game.GameStyle);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRoomPairUpCancel(BaseRoom room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(11);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendEquipChange(GamePlayer player, int place, int goodsID, string style)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(66, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte((byte)place);
			gSPacketIn.WriteInt(goodsID);
			gSPacketIn.WriteString(style);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendGameRoomSetupChange(BaseRoom room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(94);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteBoolean(room.isOpenBoss);
			if (room.isOpenBoss)
			{
				gSPacketIn.WriteString(room.Pic);
			}
			gSPacketIn.WriteInt(room.MapId);
			gSPacketIn.WriteByte((byte)room.RoomType);
			gSPacketIn.WriteString((room.Password == null) ? "" : room.Password);
			gSPacketIn.WriteString((room.Name == null) ? "GunnyII" : room.Name);
			gSPacketIn.WriteByte(room.TimeMode);
			gSPacketIn.WriteByte((byte)room.HardLevel);
			gSPacketIn.WriteInt(room.LevelLimits);
			gSPacketIn.WriteBoolean(room.isCrosszone);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendSetDressModelArr(int playerId, Dictionary<int, List<ItemInfo>> dresses)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(237, playerId);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(dresses.Count);
			foreach (int key in dresses.Keys)
			{
				List<ItemInfo> list = dresses[key];
				gSPacketIn.WriteInt(key);
				gSPacketIn.WriteInt(dresses[key].Count);
				foreach (ItemInfo item in list)
				{
					gSPacketIn.WriteInt(item.ItemID);
					gSPacketIn.WriteInt(item.TemplateID);
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendCurentDressModel(int playerId, int current)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(237, playerId);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(current);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendAvatarColectionAllInfo(PlayerAvataInventory DressBag)
		{
			Dictionary<int, UserAvatarColectionInfo> dictionary = DressBag.CombineUnitDic();
			Dictionary<int, Dictionary<int, ItemInfo>> dictionary2 = DressBag.CombineItemDic();
			GSPacketIn gSPacketIn = new GSPacketIn(402, DressBag.Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(5);
			gSPacketIn.WriteInt(dictionary.Count);
			foreach (int key in dictionary.Keys)
			{
				gSPacketIn.WriteInt(key);
				gSPacketIn.WriteInt(dictionary[key].Sex);
				gSPacketIn.WriteInt(dictionary2[key].Count);
				foreach (ItemInfo value in dictionary2[key].Values)
				{
					gSPacketIn.WriteInt(value.TemplateID);
				}
				gSPacketIn.WriteDateTime(dictionary[key].endTime);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendFusionPreview(GamePlayer player, Dictionary<int, double> previewItemList, bool isbind, int MinValid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(76, player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(previewItemList.Count);
			foreach (KeyValuePair<int, double> previewItem in previewItemList)
			{
				gSPacketIn.WriteInt(previewItem.Key);
				gSPacketIn.WriteInt(MinValid);
				int num = (int)previewItem.Value;
				gSPacketIn.WriteInt((num > 100) ? 100 : ((num >= 0) ? num : 0));
			}
			gSPacketIn.WriteBoolean(isbind);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendFusionResult(GamePlayer player, bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(78, player.PlayerCharacter.ID);
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendOpenHoleComplete(GamePlayer player, int type, bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(217, player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(type);
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRuneOpenPackage(GamePlayer player, int rand)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(121, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(rand);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRefineryPreview(GamePlayer player, int templateid, bool isbind, ItemInfo item)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(111, player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(templateid);
			gSPacketIn.WriteInt(item.ValidDate);
			gSPacketIn.WriteBoolean(isbind);
			gSPacketIn.WriteInt(item.AgilityCompose);
			gSPacketIn.WriteInt(item.AttackCompose);
			gSPacketIn.WriteInt(item.DefendCompose);
			gSPacketIn.WriteInt(item.LuckCompose);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendUpdateInventorySlot(PlayerInventory bag, int[] updatedSlots)
		{
			if (m_gameClient.Player == null)
			{
				return;
			}
			int val = updatedSlots.Length;
			GSPacketIn gSPacketIn = new GSPacketIn(64, m_gameClient.Player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(bag.BagType);
			gSPacketIn.WriteInt(val);
			foreach (int num in updatedSlots)
			{
				gSPacketIn.WriteInt(num);
				ItemInfo ıtemAt = bag.GetItemAt(num);
				if (ıtemAt == null)
				{
					gSPacketIn.WriteBoolean(val: false);
					continue;
				}
				gSPacketIn.WriteBoolean(val: true);
				gSPacketIn.WriteInt(ıtemAt.UserID);
				gSPacketIn.WriteInt(ıtemAt.ItemID);
				gSPacketIn.WriteInt(ıtemAt.Count);
				gSPacketIn.WriteInt(ıtemAt.Place);
				gSPacketIn.WriteInt(ıtemAt.TemplateID);
				gSPacketIn.WriteInt(ıtemAt.AttackCompose);
				gSPacketIn.WriteInt(ıtemAt.DefendCompose);
				gSPacketIn.WriteInt(ıtemAt.AgilityCompose);
				gSPacketIn.WriteInt(ıtemAt.LuckCompose);
				gSPacketIn.WriteInt(ıtemAt.StrengthenLevel);
				gSPacketIn.WriteInt(ıtemAt.StrengthenExp);
				gSPacketIn.WriteBoolean(ıtemAt.IsBinds);
				gSPacketIn.WriteBoolean(ıtemAt.IsJudge);
				gSPacketIn.WriteDateTime(ıtemAt.BeginDate);
				gSPacketIn.WriteInt(ıtemAt.ValidDate);
				gSPacketIn.WriteString((ıtemAt.Color == null) ? "" : ıtemAt.Color);
				gSPacketIn.WriteString((ıtemAt.Skin == null) ? "" : ıtemAt.Skin);
				gSPacketIn.WriteBoolean(ıtemAt.IsUsed);
				gSPacketIn.WriteInt(ıtemAt.Hole1);
				gSPacketIn.WriteInt(ıtemAt.Hole2);
				gSPacketIn.WriteInt(ıtemAt.Hole3);
				gSPacketIn.WriteInt(ıtemAt.Hole4);
				gSPacketIn.WriteInt(ıtemAt.Hole5);
				gSPacketIn.WriteInt(ıtemAt.Hole6);
				gSPacketIn.WriteString(ıtemAt.Pic);
				gSPacketIn.WriteInt(ıtemAt.RefineryLevel);
				gSPacketIn.WriteDateTime(DateTime.Now);
				gSPacketIn.WriteInt(ıtemAt.StrengthenTimes);
				gSPacketIn.WriteByte((byte)ıtemAt.Int32_0);
				gSPacketIn.WriteInt(ıtemAt.Hole5Exp);
				gSPacketIn.WriteByte((byte)ıtemAt.Int32_1);
				gSPacketIn.WriteInt(ıtemAt.Hole6Exp);
				gSPacketIn.WriteBoolean(ıtemAt.IsGold);
				if (ıtemAt.IsGold)
				{
					gSPacketIn.WriteInt(ıtemAt.goldValidDate);
					gSPacketIn.WriteDateTime(ıtemAt.goldBeginTime);
				}
				gSPacketIn.WriteString(ıtemAt.latentEnergyCurStr);
				gSPacketIn.WriteString(ıtemAt.latentEnergyCurStr);
				gSPacketIn.WriteDateTime(ıtemAt.latentEnergyEndTime);
				if (Equip.isMagicStone(ıtemAt.Template.CategoryID))
				{
					gSPacketIn.WriteInt(ıtemAt.MagicAttack);
					gSPacketIn.WriteInt(ıtemAt.MagicDefence);
				}
				else
				{
					gSPacketIn.WriteInt(0);
					gSPacketIn.WriteInt(0);
				}
				gSPacketIn.WriteBoolean(ıtemAt.goodsLock);
				gSPacketIn.WriteInt(ıtemAt.MagicExp);
				gSPacketIn.WriteInt(ıtemAt.MagicLevel);
			}
			SendTCP(gSPacketIn);
		}

		public void SendPlayerCardEquip(PlayerInfo player, List<UsersCardInfo> cards)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(216, player.ID);
			gSPacketIn.WriteInt(player.ID);
			gSPacketIn.WriteInt(player.ZoneID);
			gSPacketIn.WriteInt(cards.Count);
			foreach (UsersCardInfo card in cards)
			{
				gSPacketIn.WriteInt(card.Place);
				if (card.TemplateID == 0)
				{
					gSPacketIn.WriteBoolean(val: false);
					continue;
				}
				gSPacketIn.WriteBoolean(val: true);
				gSPacketIn.WriteInt(card.CardID);
				gSPacketIn.WriteInt(card.CardType);
				gSPacketIn.WriteInt(card.UserID);
				gSPacketIn.WriteInt(card.Place);
				gSPacketIn.WriteInt(card.TemplateID);
				gSPacketIn.WriteBoolean(card.isFirstGet);
				gSPacketIn.WriteInt(card.Attack);
				gSPacketIn.WriteInt(card.Defence);
				gSPacketIn.WriteInt(card.Agility);
				gSPacketIn.WriteInt(card.Luck);
				gSPacketIn.WriteInt(card.Damage);
				gSPacketIn.WriteInt(card.Guard);
			}
			SendTCP(gSPacketIn);
		}

		public void SendPlayerCardInfo(CardInventory bag, int[] updatedSlots)
		{
			if (m_gameClient.Player == null)
			{
				return;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(216, m_gameClient.Player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(m_gameClient.Player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(m_gameClient.Player.ZoneId);
			gSPacketIn.WriteInt(updatedSlots.Length);
			foreach (int num in updatedSlots)
			{
				gSPacketIn.WriteInt(num);
				UsersCardInfo ıtemAt = bag.GetItemAt(num);
				if (ıtemAt == null)
				{
					gSPacketIn.WriteBoolean(val: false);
					continue;
				}
				gSPacketIn.WriteBoolean(val: true);
				gSPacketIn.WriteInt(ıtemAt.CardID);
				gSPacketIn.WriteInt(ıtemAt.CardType);
				gSPacketIn.WriteInt(ıtemAt.UserID);
				gSPacketIn.WriteInt(ıtemAt.Place);
				gSPacketIn.WriteInt(ıtemAt.TemplateID);
				gSPacketIn.WriteBoolean(ıtemAt.isFirstGet);
				gSPacketIn.WriteInt(ıtemAt.Attack);
				gSPacketIn.WriteInt(ıtemAt.Defence);
				gSPacketIn.WriteInt(ıtemAt.Agility);
				gSPacketIn.WriteInt(ıtemAt.Luck);
				gSPacketIn.WriteInt(ıtemAt.Damage);
				gSPacketIn.WriteInt(ıtemAt.Guard);
			}
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendGetCard(PlayerInfo player, UsersCardInfo card)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(216, player.ID);
			gSPacketIn.WriteInt(player.ID);
			gSPacketIn.WriteInt(player.ZoneID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(card.Place);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteInt(card.CardID);
			gSPacketIn.WriteInt(card.CardType);
			gSPacketIn.WriteInt(card.UserID);
			gSPacketIn.WriteInt(card.Place);
			gSPacketIn.WriteInt(card.TemplateID);
			gSPacketIn.WriteBoolean(card.isFirstGet);
			gSPacketIn.WriteInt(card.Attack);
			gSPacketIn.WriteInt(card.Defence);
			gSPacketIn.WriteInt(card.Agility);
			gSPacketIn.WriteInt(card.Luck);
			gSPacketIn.WriteInt(card.Damage);
			gSPacketIn.WriteInt(card.Guard);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendPlayerCardSlot(PlayerInfo player, List<UsersCardInfo> cardslots)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(170, player.ID);
			gSPacketIn.WriteInt(player.ID);
			gSPacketIn.WriteInt(player.ZoneID);
			gSPacketIn.WriteInt(player.CardSoul);
			gSPacketIn.WriteInt(cardslots.Count);
			foreach (UsersCardInfo cardslot in cardslots)
			{
				gSPacketIn.WriteInt(cardslot.Place);
				gSPacketIn.WriteInt(cardslot.Type);
				gSPacketIn.WriteInt(cardslot.Level);
				gSPacketIn.WriteInt(cardslot.CardGP);
			}
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendGetPlayerCard(int playerId)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(18, playerId);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerCardSlot(PlayerInfo player, UsersCardInfo card)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(170, player.ID);
			gSPacketIn.WriteInt(player.ID);
			gSPacketIn.WriteInt(player.ZoneID);
			gSPacketIn.WriteInt(player.CardSoul);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(card.Place);
			gSPacketIn.WriteInt(card.Type);
			gSPacketIn.WriteInt(card.Level);
			gSPacketIn.WriteInt(card.CardGP);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerCardReset(PlayerInfo player, List<int> points)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(196, player.ID);
			gSPacketIn.WriteInt(points.Count);
			foreach (int point in points)
			{
				gSPacketIn.WriteInt(point);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerCardSoul(PlayerInfo player, bool isSoul, int soul)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(208, player.ID);
			gSPacketIn.WriteBoolean(isSoul);
			if (isSoul)
			{
				gSPacketIn.WriteInt(soul);
				gSPacketIn.WriteInt(player.GetSoulCount);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendEatPetsInfo(EatPetsInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(68, m_gameClient.Player.PlayerId);
			gSPacketIn.WriteByte(33);
			gSPacketIn.WriteInt(info.weaponExp);
			gSPacketIn.WriteInt(info.weaponLevel);
			gSPacketIn.WriteInt(info.clothesExp);
			gSPacketIn.WriteInt(info.clothesLevel);
			gSPacketIn.WriteInt(info.hatExp);
			gSPacketIn.WriteInt(info.hatLevel);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUpdateUserPet(PetInventory bag, int[] slots)
		{
			if (m_gameClient.Player == null)
			{
				return null;
			}
			int ıD = m_gameClient.Player.PlayerCharacter.ID;
			GSPacketIn gSPacketIn = new GSPacketIn(68, m_gameClient.Player.PlayerId);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(m_gameClient.Player.PlayerId);
			gSPacketIn.WriteInt(m_gameClient.Player.ZoneId);
			gSPacketIn.WriteInt(slots.Length);
			foreach (int num in slots)
			{
				gSPacketIn.WriteInt(num);
				UsersPetinfo petAt = bag.GetPetAt(num);
				if (petAt == null)
				{
					gSPacketIn.WriteBoolean(val: false);
					continue;
				}
				gSPacketIn.WriteBoolean(val: true);
				gSPacketIn.WriteInt(petAt.ID);
				gSPacketIn.WriteInt(petAt.TemplateID);
				gSPacketIn.WriteString(petAt.Name);
				gSPacketIn.WriteInt(petAt.UserID);
				gSPacketIn.WriteInt(petAt.TotalAttack);
				gSPacketIn.WriteInt(petAt.TotalDefence);
				gSPacketIn.WriteInt(petAt.TotalLuck);
				gSPacketIn.WriteInt(petAt.TotalAgility);
				gSPacketIn.WriteInt(petAt.TotalBlood);
				gSPacketIn.WriteInt(petAt.TotalDamage);
				gSPacketIn.WriteInt(petAt.TotalGuard);
				gSPacketIn.WriteInt(petAt.AttackGrow);
				gSPacketIn.WriteInt(petAt.DefenceGrow);
				gSPacketIn.WriteInt(petAt.LuckGrow);
				gSPacketIn.WriteInt(petAt.AgilityGrow);
				gSPacketIn.WriteInt(petAt.BloodGrow);
				gSPacketIn.WriteInt(petAt.DamageGrow);
				gSPacketIn.WriteInt(petAt.GuardGrow);
				gSPacketIn.WriteInt(petAt.Level);
				gSPacketIn.WriteInt(petAt.GP);
				gSPacketIn.WriteInt(petAt.MaxGP);
				gSPacketIn.WriteInt(petAt.Hunger);
				gSPacketIn.WriteInt(petAt.PetHappyStar);
				gSPacketIn.WriteInt(petAt.MP);
				List<string> skill = petAt.GetSkill();
				List<string> skillEquip = petAt.GetSkillEquip();
				gSPacketIn.WriteInt(skill.Count);
				foreach (string item in skill)
				{
					gSPacketIn.WriteInt(int.Parse(item.Split(',')[0]));
					gSPacketIn.WriteInt(int.Parse(item.Split(',')[1]));
				}
				gSPacketIn.WriteInt(skillEquip.Count);
				foreach (string item2 in skillEquip)
				{
					gSPacketIn.WriteInt(int.Parse(item2.Split(',')[1]));
					gSPacketIn.WriteInt(int.Parse(item2.Split(',')[0]));
				}
				gSPacketIn.WriteBoolean(petAt.IsEquip);
				gSPacketIn.WriteInt(petAt.PetEquip.Count);
				for (int j = 0; j < petAt.PetEquip.Count; j++)
				{
					gSPacketIn.WriteInt(petAt.PetEquip[j].eqType());
					gSPacketIn.WriteInt(petAt.PetEquip[j].TemplateID);
					gSPacketIn.WriteDateTime(petAt.PetEquip[j].BeginDate);
					gSPacketIn.WriteInt(petAt.PetEquip[j].ValidDate);
				}
				gSPacketIn.WriteInt(petAt.currentStarExp);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPetInfo(int id, int zoneId, UsersPetinfo[] pets)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(68, id);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteInt(zoneId);
			gSPacketIn.WriteInt(pets.Length);
			foreach (UsersPetinfo usersPetinfo in pets)
			{
				gSPacketIn.WriteInt(usersPetinfo.Place);
				gSPacketIn.WriteBoolean(val: true);
				gSPacketIn.WriteInt(usersPetinfo.ID);
				gSPacketIn.WriteInt(usersPetinfo.TemplateID);
				gSPacketIn.WriteString(usersPetinfo.Name);
				gSPacketIn.WriteInt(usersPetinfo.UserID);
				gSPacketIn.WriteInt(usersPetinfo.TotalAttack);
				gSPacketIn.WriteInt(usersPetinfo.TotalDefence);
				gSPacketIn.WriteInt(usersPetinfo.TotalLuck);
				gSPacketIn.WriteInt(usersPetinfo.TotalAgility);
				gSPacketIn.WriteInt(usersPetinfo.TotalBlood);
				gSPacketIn.WriteInt(usersPetinfo.TotalDamage);
				gSPacketIn.WriteInt(usersPetinfo.TotalGuard);
				gSPacketIn.WriteInt(usersPetinfo.AttackGrow);
				gSPacketIn.WriteInt(usersPetinfo.DefenceGrow);
				gSPacketIn.WriteInt(usersPetinfo.LuckGrow);
				gSPacketIn.WriteInt(usersPetinfo.AgilityGrow);
				gSPacketIn.WriteInt(usersPetinfo.BloodGrow);
				gSPacketIn.WriteInt(usersPetinfo.DamageGrow);
				gSPacketIn.WriteInt(usersPetinfo.GuardGrow);
				gSPacketIn.WriteInt(usersPetinfo.Level);
				gSPacketIn.WriteInt(usersPetinfo.GP);
				gSPacketIn.WriteInt(usersPetinfo.MaxGP);
				gSPacketIn.WriteInt(usersPetinfo.Hunger);
				gSPacketIn.WriteInt(usersPetinfo.PetHappyStar);
				gSPacketIn.WriteInt(usersPetinfo.MP);
				List<string> skill = usersPetinfo.GetSkill();
				List<string> skillEquip = usersPetinfo.GetSkillEquip();
				gSPacketIn.WriteInt(skill.Count);
				foreach (string item in skill)
				{
					gSPacketIn.WriteInt(int.Parse(item.Split(',')[0]));
					gSPacketIn.WriteInt(int.Parse(item.Split(',')[1]));
				}
				gSPacketIn.WriteInt(skillEquip.Count);
				foreach (string item2 in skillEquip)
				{
					gSPacketIn.WriteInt(int.Parse(item2.Split(',')[1]));
					gSPacketIn.WriteInt(int.Parse(item2.Split(',')[0]));
				}
				gSPacketIn.WriteBoolean(usersPetinfo.IsEquip);
				gSPacketIn.WriteInt(usersPetinfo.PetEquip.Count);
				for (int j = 0; j < usersPetinfo.PetEquip.Count; j++)
				{
					gSPacketIn.WriteInt(usersPetinfo.PetEquip[j].eqType());
					gSPacketIn.WriteInt(usersPetinfo.PetEquip[j].TemplateID);
					gSPacketIn.WriteDateTime(usersPetinfo.PetEquip[j].BeginDate);
					gSPacketIn.WriteInt(usersPetinfo.PetEquip[j].ValidDate);
				}
				gSPacketIn.WriteInt(usersPetinfo.currentStarExp);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendRefreshPet(GamePlayer player, UsersPetinfo[] pets, ItemInfo[] items, bool refreshBtn)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(68, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(5);
			int val = 10;
			int val2 = 10;
			int val3 = 100;
			if (!player.PlayerCharacter.IsFistGetPet)
			{
				gSPacketIn.WriteBoolean(refreshBtn);
				gSPacketIn.WriteInt(pets.Length);
				foreach (UsersPetinfo usersPetinfo in pets)
				{
					gSPacketIn.WriteInt(usersPetinfo.Place);
					gSPacketIn.WriteInt(usersPetinfo.TemplateID);
					gSPacketIn.WriteString(usersPetinfo.Name);
					gSPacketIn.WriteInt(usersPetinfo.Attack);
					gSPacketIn.WriteInt(usersPetinfo.Defence);
					gSPacketIn.WriteInt(usersPetinfo.Luck);
					gSPacketIn.WriteInt(usersPetinfo.Agility);
					gSPacketIn.WriteInt(usersPetinfo.Blood);
					gSPacketIn.WriteInt(usersPetinfo.Damage);
					gSPacketIn.WriteInt(usersPetinfo.Guard);
					gSPacketIn.WriteInt(usersPetinfo.AttackGrow);
					gSPacketIn.WriteInt(usersPetinfo.DefenceGrow);
					gSPacketIn.WriteInt(usersPetinfo.LuckGrow);
					gSPacketIn.WriteInt(usersPetinfo.AgilityGrow);
					gSPacketIn.WriteInt(usersPetinfo.BloodGrow);
					gSPacketIn.WriteInt(usersPetinfo.DamageGrow);
					gSPacketIn.WriteInt(usersPetinfo.GuardGrow);
					gSPacketIn.WriteInt(usersPetinfo.Level);
					gSPacketIn.WriteInt(usersPetinfo.GP);
					gSPacketIn.WriteInt(usersPetinfo.MaxGP);
					gSPacketIn.WriteInt(usersPetinfo.Hunger);
					gSPacketIn.WriteInt(usersPetinfo.MP);
					List<string> skill = usersPetinfo.GetSkill();
					gSPacketIn.WriteInt(skill.Count);
					foreach (string item in skill)
					{
						gSPacketIn.WriteInt(int.Parse(item.Split(',')[0]));
						gSPacketIn.WriteInt(int.Parse(item.Split(',')[1]));
					}
					gSPacketIn.WriteInt(val);
					gSPacketIn.WriteInt(val2);
					gSPacketIn.WriteInt(val3);
				}
				gSPacketIn.WriteInt(0);
			}
			else
			{
				gSPacketIn.WriteBoolean(refreshBtn);
				gSPacketIn.WriteInt(pets.Length);
				foreach (UsersPetinfo usersPetinfo2 in pets)
				{
					gSPacketIn.WriteInt(usersPetinfo2.Place);
					gSPacketIn.WriteInt(usersPetinfo2.TemplateID);
					gSPacketIn.WriteString(usersPetinfo2.Name);
					gSPacketIn.WriteInt(usersPetinfo2.Attack);
					gSPacketIn.WriteInt(usersPetinfo2.Defence);
					gSPacketIn.WriteInt(usersPetinfo2.Luck);
					gSPacketIn.WriteInt(usersPetinfo2.Agility);
					gSPacketIn.WriteInt(usersPetinfo2.Blood);
					gSPacketIn.WriteInt(usersPetinfo2.Damage);
					gSPacketIn.WriteInt(usersPetinfo2.Guard);
					gSPacketIn.WriteInt(usersPetinfo2.AttackGrow);
					gSPacketIn.WriteInt(usersPetinfo2.DefenceGrow);
					gSPacketIn.WriteInt(usersPetinfo2.LuckGrow);
					gSPacketIn.WriteInt(usersPetinfo2.AgilityGrow);
					gSPacketIn.WriteInt(usersPetinfo2.BloodGrow);
					gSPacketIn.WriteInt(usersPetinfo2.DamageGrow);
					gSPacketIn.WriteInt(usersPetinfo2.GuardGrow);
					gSPacketIn.WriteInt(usersPetinfo2.Level);
					gSPacketIn.WriteInt(usersPetinfo2.GP);
					gSPacketIn.WriteInt(usersPetinfo2.MaxGP);
					gSPacketIn.WriteInt(usersPetinfo2.Hunger);
					gSPacketIn.WriteInt(usersPetinfo2.MP);
					List<string> skill2 = usersPetinfo2.GetSkill();
					gSPacketIn.WriteInt(skill2.Count);
					foreach (string item2 in skill2)
					{
						gSPacketIn.WriteInt(int.Parse(item2.Split(',')[0]));
						gSPacketIn.WriteInt(int.Parse(item2.Split(',')[1]));
					}
					gSPacketIn.WriteInt(val);
					gSPacketIn.WriteInt(val2);
					gSPacketIn.WriteInt(val3);
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendAddFriend(PlayerInfo user, int relation, bool state)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(160, user.ID);
			gSPacketIn.WriteByte(160);
			gSPacketIn.WriteBoolean(state);
			gSPacketIn.WriteInt(user.ID);
			gSPacketIn.WriteString(user.NickName);
			gSPacketIn.WriteByte(user.typeVIP);
			gSPacketIn.WriteInt(user.VIPLevel);
			gSPacketIn.WriteBoolean(user.Sex);
			gSPacketIn.WriteString(user.Style);
			gSPacketIn.WriteString(user.Colors);
			gSPacketIn.WriteString(user.Skin);
			gSPacketIn.WriteInt((user.State == 1) ? 1 : 0);
			gSPacketIn.WriteInt(user.Grade);
			gSPacketIn.WriteInt(user.Hide);
			gSPacketIn.WriteString(user.ConsortiaName);
			gSPacketIn.WriteInt(user.Total);
			gSPacketIn.WriteInt(user.Escape);
			gSPacketIn.WriteInt(user.Win);
			gSPacketIn.WriteInt(user.Offer);
			gSPacketIn.WriteInt(user.Repute);
			gSPacketIn.WriteInt(relation);
			gSPacketIn.WriteString(user.UserName);
			gSPacketIn.WriteInt(user.Nimbus);
			gSPacketIn.WriteInt(user.FightPower);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString("");
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteString("");
			gSPacketIn.WriteInt(user.AchievementPoint);
			gSPacketIn.WriteString(user.Honor);
			gSPacketIn.WriteBoolean(user.IsMarried);
			gSPacketIn.WriteBoolean(user.IsOldPlayer);
			gSPacketIn.WriteDateTime(user.LastDate);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendFriendRemove(int FriendID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(160, FriendID);
			gSPacketIn.WriteByte(161);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendFriendState(int playerID, int state, byte typeVip, int viplevel)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(160, playerID);
			gSPacketIn.WriteByte(165);
			gSPacketIn.WriteInt(state);
			gSPacketIn.WriteByte(typeVip);
			gSPacketIn.WriteInt(viplevel);
			gSPacketIn.WriteBoolean(val: true);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUpdateAllData(PlayerInfo player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(142, player.ID);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteDateTime(DateTime.Now.AddDays(7.0));
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendGetSpree(PlayerInfo player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(157, player.ID);
			gSPacketIn.WriteBoolean(val: true);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUpdateUpCount(PlayerInfo player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(96, player.ID);
			gSPacketIn.WriteInt(player.MaxBuyHonor);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerRefreshTotem(PlayerInfo player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(136, player.ID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(player.myHonor);
			gSPacketIn.WriteInt(player.totemId);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendLabyrinthUpdataInfo(int ID, UserLabyrinthInfo laby)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(131, ID);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(laby.myProgress);
			gSPacketIn.WriteInt(laby.currentFloor);
			gSPacketIn.WriteBoolean(laby.completeChallenge);
			gSPacketIn.WriteInt(laby.remainTime);
			gSPacketIn.WriteInt(laby.accumulateExp);
			gSPacketIn.WriteInt(laby.cleanOutAllTime);
			gSPacketIn.WriteInt(laby.cleanOutGold);
			gSPacketIn.WriteInt(laby.myRanking);
			gSPacketIn.WriteBoolean(laby.isDoubleAward);
			gSPacketIn.WriteBoolean(laby.isInGame);
			gSPacketIn.WriteBoolean(laby.isCleanOut);
			gSPacketIn.WriteBoolean(laby.serverMultiplyingPower);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerFigSpiritinit(int ID, List<UserGemStone> gems)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(209, ID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteInt(gems.Count);
			foreach (UserGemStone gem in gems)
			{
				gSPacketIn.WriteInt(gem.UserID);
				gSPacketIn.WriteInt(gem.FigSpiritId);
				gSPacketIn.WriteString(gem.FigSpiritIdValue);
				gSPacketIn.WriteInt(gem.EquipPlace);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerFigSpiritUp(int ID, UserGemStone gem, bool isUp, bool isMaxLevel, bool isFall, int num, int dir)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(209, ID);
			gSPacketIn.WriteByte(2);
			string[] array = gem.FigSpiritIdValue.Split('|');
			gSPacketIn.WriteBoolean(isUp);
			gSPacketIn.WriteBoolean(isMaxLevel);
			gSPacketIn.WriteBoolean(isFall);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteInt(array.Length);
			foreach (string text in array)
			{
				gSPacketIn.WriteInt(gem.FigSpiritId);
				gSPacketIn.WriteInt(Convert.ToInt32(text.Split(',')[0]));
				gSPacketIn.WriteInt(Convert.ToInt32(text.Split(',')[1]));
				gSPacketIn.WriteInt(Convert.ToInt32(text.Split(',')[2]));
			}
			gSPacketIn.WriteInt(gem.EquipPlace);
			gSPacketIn.WriteInt(dir);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendTrusteeshipStart(int ID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(140, ID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			for (int i = 0; i < 0; i++)
			{
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteDateTime(DateTime.Now);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendKingBlessMain(PlayerExtra Extra)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(142, Extra.Info.UserID);
			gSPacketIn.WriteInt(Extra.Info.KingBlessIndex);
			gSPacketIn.WriteDateTime(Extra.Info.KingBlessEnddate);
			if (Extra.Info.KingBlessIndex > 0)
			{
				gSPacketIn.WriteInt(Extra.KingBlessInfo.Count);
				foreach (int key in Extra.KingBlessInfo.Keys)
				{
					gSPacketIn.WriteInt(key);
					gSPacketIn.WriteInt(Extra.KingBlessInfo[key]);
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendKingBlessUpdateBuffData(int UserID, int data, int value)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(143, UserID);
			gSPacketIn.WriteInt(data);
			gSPacketIn.WriteInt(value);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendDeedMain(PlayerExtra Extra)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(2272, Extra.Info.UserID);
			gSPacketIn.WriteInt(Extra.Info.DeedIndex);
			gSPacketIn.WriteDateTime(Extra.Info.DeedEnddate);
			if (Extra.Info.KingBlessIndex > 0)
			{
				gSPacketIn.WriteInt(Extra.DeedInfo.Count);
				foreach (int key in Extra.DeedInfo.Keys)
				{
					gSPacketIn.WriteInt(key);
					gSPacketIn.WriteInt(Extra.DeedInfo[key]);
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendDeedUpdateBuffData(int UserID, int data, int value)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(2273, UserID);
			gSPacketIn.WriteInt(data);
			gSPacketIn.WriteInt(value);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendGrowthPackageIsOpen(int ID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(84, ID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(3);
			gSPacketIn.WriteBoolean(GameProperties.IsPromotePackageOpen);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendGrowthPackageOpen(int ID, int isBuy)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(84, ID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(isBuy);
			for (int i = 0; i < 9; i++)
			{
				if (i < isBuy)
				{
					gSPacketIn.WriteInt(1);
				}
				else
				{
					gSPacketIn.WriteInt(0);
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendGrowthPackageUpadte(int ID, int isBuy)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(84, ID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(2);
			gSPacketIn.WriteInt(isBuy);
			for (int i = 0; i < 9; i++)
			{
				if (i < isBuy)
				{
					gSPacketIn.WriteInt(1);
				}
				else
				{
					gSPacketIn.WriteInt(0);
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendDiceActiveClose(int ID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(134, ID);
			gSPacketIn.WriteByte(2);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendDiceReceiveData(PlayerDice Dice)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(134, Dice.Data.UserID);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteBoolean(Dice.Data.UserFirstCell);
			gSPacketIn.WriteInt(Dice.Data.CurrentPosition);
			gSPacketIn.WriteInt(Dice.Data.LuckIntegralLevel);
			gSPacketIn.WriteInt(Dice.Data.LuckIntegral);
			gSPacketIn.WriteInt(Dice.Data.FreeCount);
			gSPacketIn.WriteInt(Dice.RewardItem.Count);
			for (int i = 0; i < Dice.RewardItem.Count; i++)
			{
				gSPacketIn.WriteInt(Dice.RewardItem[i].TemplateID);
				gSPacketIn.WriteInt(i);
				gSPacketIn.WriteInt(Dice.RewardItem[i].StrengthenLevel);
				gSPacketIn.WriteInt(Dice.RewardItem[i].Count);
				gSPacketIn.WriteInt(Dice.RewardItem[i].ValidDate);
				gSPacketIn.WriteBoolean(Dice.RewardItem[i].IsBinds);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendDiceReceiveResult(PlayerDice Dice)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(134, Dice.Data.UserID);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(Dice.Data.CurrentPosition);
			gSPacketIn.WriteInt(Dice.result);
			gSPacketIn.WriteInt(Dice.Data.LuckIntegral);
			gSPacketIn.WriteInt(Dice.Data.Level);
			gSPacketIn.WriteInt(Dice.Data.FreeCount);
			gSPacketIn.WriteString(Dice.RewardName);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendDiceActiveOpen(PlayerDice Dice)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(134, Dice.Data.UserID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(Dice.Data.FreeCount);
			gSPacketIn.WriteInt(Dice.refreshPrice);
			gSPacketIn.WriteInt(Dice.commonDicePrice);
			gSPacketIn.WriteInt(Dice.doubleDicePrice);
			gSPacketIn.WriteInt(Dice.bigDicePrice);
			gSPacketIn.WriteInt(Dice.smallDicePrice);
			gSPacketIn.WriteInt(Dice.MAX_LEVEL);
			for (int i = 0; i < Dice.MAX_LEVEL; i++)
			{
				List<DiceLevelAwardInfo> list = Dice.LevelAward[i];
				gSPacketIn.WriteInt(Dice.IntegralPoint[i]);
				gSPacketIn.WriteInt(list.Count);
				for (int j = 0; j < list.Count; j++)
				{
					gSPacketIn.WriteInt(list[j].TemplateID);
					gSPacketIn.WriteInt(list[j].Count);
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendChickenBoxOpen(int ID, int flushPrice, int[] openCardPrice, int[] eagleEyePrice)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(87, ID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(openCardPrice.Length);
			for (int num = openCardPrice.Length; num > 0; num--)
			{
				gSPacketIn.WriteInt(openCardPrice[num - 1]);
			}
			gSPacketIn.WriteInt(eagleEyePrice.Length);
			for (int num2 = eagleEyePrice.Length; num2 > 0; num2--)
			{
				gSPacketIn.WriteInt(eagleEyePrice[num2 - 1]);
			}
			gSPacketIn.WriteInt(flushPrice);
			gSPacketIn.WriteDateTime(DateTime.Parse(GameProperties.NewChickenEndTime));
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendLuckStarOpen(int ID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(87, ID);
			gSPacketIn.WriteInt(25);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendLuckStoneEnable(int ID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(165, ID);
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteBoolean(val: false);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendBattleGoundOpen(int ID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(132, ID);
			gSPacketIn.WriteByte(1);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendBattleGoundOver(int ID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(132, ID);
			gSPacketIn.WriteByte(2);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendActivityList(int ID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(155, ID);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(1);
			for (int i = 0; i < 1; i++)
			{
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(1);
			}
			gSPacketIn.WriteInt(0);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(6);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteString("");
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public void SendExpBlessedData(int PlayerId)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(155, PlayerId);
			gSPacketIn.WriteByte(8);
			gSPacketIn.WriteInt(0);
			SendTCP(gSPacketIn);
		}

		public GSPacketIn SendFindBackIncome(int ID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(147, ID);
			gSPacketIn.WriteInt(6);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteBoolean(val: false);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerDrill(int ID, Dictionary<int, UserDrillInfo> drills)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(121, ID);
			gSPacketIn.WriteByte(6);
			gSPacketIn.WriteInt(ID);
			gSPacketIn.WriteInt(drills[0].HoleExp);
			gSPacketIn.WriteInt(drills[1].HoleExp);
			gSPacketIn.WriteInt(drills[2].HoleExp);
			gSPacketIn.WriteInt(drills[3].HoleExp);
			gSPacketIn.WriteInt(drills[4].HoleExp);
			gSPacketIn.WriteInt(drills[5].HoleExp);
			gSPacketIn.WriteInt(drills[0].HoleLv);
			gSPacketIn.WriteInt(drills[1].HoleLv);
			gSPacketIn.WriteInt(drills[2].HoleLv);
			gSPacketIn.WriteInt(drills[3].HoleLv);
			gSPacketIn.WriteInt(drills[4].HoleLv);
			gSPacketIn.WriteInt(drills[5].HoleLv);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUserRanks(int Id, List<UserRankInfo> ranks)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(34, Id);
			gSPacketIn.WriteInt(ranks.Count);
			foreach (UserRankInfo rank in ranks)
			{
				gSPacketIn.WriteInt(rank.NewTitleID);
				gSPacketIn.WriteString(rank.Name);
				gSPacketIn.WriteDateTime(rank.BeginDate);
				gSPacketIn.WriteDateTime(rank.EndDate);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUpdateAchievements(GamePlayer player, BaseAchievement[] infos)
		{
			if (player != null && infos != null)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(228, player.PlayerCharacter.ID);
				gSPacketIn.WriteInt(infos.Length);
				foreach (BaseAchievement baseAchievement in infos)
				{
					gSPacketIn.WriteInt(baseAchievement.Data.AchievementID);
					gSPacketIn.WriteInt(1);
				}
				SendTCP(gSPacketIn);
				return gSPacketIn;
			}
			return null;
		}

		public GSPacketIn SendAchievementDatas(GamePlayer player, BaseAchievement[] infos)
		{
			if (player != null && infos != null)
			{
				int year = DateTime.Now.Year;
				int month = DateTime.Now.Month;
				int day = DateTime.Now.Day;
				GSPacketIn gSPacketIn = new GSPacketIn(231, player.PlayerCharacter.ID);
				gSPacketIn.WriteInt(infos.Length);
				foreach (BaseAchievement baseAchievement in infos)
				{
					gSPacketIn.WriteInt(baseAchievement.Data.AchievementID);
					gSPacketIn.WriteInt(year);
					gSPacketIn.WriteInt(month);
					gSPacketIn.WriteInt(day);
				}
				SendTCP(gSPacketIn);
				return gSPacketIn;
			}
			return null;
		}

		public GSPacketIn SendUpdateQuests(GamePlayer player, byte[] states, BaseQuest[] infos)
		{
			if (player != null && states != null && infos != null)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(178, player.PlayerCharacter.ID);
				gSPacketIn.WriteInt(infos.Length);
				foreach (BaseQuest baseQuest in infos)
				{
					gSPacketIn.WriteInt(baseQuest.Data.QuestID);
					gSPacketIn.WriteBoolean(baseQuest.Data.IsComplete);
					gSPacketIn.WriteInt(baseQuest.Data.Condition1);
					gSPacketIn.WriteInt(baseQuest.Data.Condition2);
					gSPacketIn.WriteInt(baseQuest.Data.Condition3);
					gSPacketIn.WriteInt(baseQuest.Data.Condition4);
					gSPacketIn.WriteDateTime(baseQuest.Data.CompletedDate);
					gSPacketIn.WriteInt(baseQuest.Data.RepeatFinish);
					gSPacketIn.WriteInt(baseQuest.Data.RandDobule);
					gSPacketIn.WriteBoolean(baseQuest.Data.IsExist);
					gSPacketIn.WriteInt(baseQuest.Data.QuestLevel);
					int[] array = new int[4]
					{
						baseQuest.Data.Condition5,
						baseQuest.Data.Condition6,
						baseQuest.Data.Condition7,
						baseQuest.Data.Condition8
					};
					gSPacketIn.WriteInt(array.Length);
					for (int j = 0; j < array.Length; j++)
					{
						gSPacketIn.WriteInt(j + 4);
						gSPacketIn.WriteInt(array[j]);
					}
					gSPacketIn.WriteBoolean(baseQuest.Info.IsAccept);
				}
				gSPacketIn.Write(states);
				SendTCP(gSPacketIn);
				return gSPacketIn;
			}
			return null;
		}

		public GSPacketIn SendUpdateBuffer(GamePlayer player, BufferInfo[] infos)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(185, player.PlayerId);
			gSPacketIn.WriteInt(infos.Length);
			foreach (BufferInfo bufferInfo in infos)
			{
				gSPacketIn.WriteInt(bufferInfo.Type);
				gSPacketIn.WriteBoolean(bufferInfo.IsExist);
				gSPacketIn.WriteDateTime(bufferInfo.BeginDate);
				gSPacketIn.WriteInt(bufferInfo.ValidDate);
				gSPacketIn.WriteInt(bufferInfo.Value);
				gSPacketIn.WriteInt(bufferInfo.ValidCount);
				gSPacketIn.WriteInt(bufferInfo.TemplateID);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUpdateConsotiaBuffer(GamePlayer player, Dictionary<int, BufferInfo> bufflist)
		{
			List<ConsortiaBufferTempInfo> allConsortiaBuff = ConsortiaExtraMgr.GetAllConsortiaBuff();
			GSPacketIn gSPacketIn = new GSPacketIn(129, player.PlayerId);
			gSPacketIn.WriteByte(26);
			gSPacketIn.WriteInt(allConsortiaBuff.Count);
			foreach (ConsortiaBufferTempInfo item in allConsortiaBuff)
			{
				if (bufflist.ContainsKey(item.id))
				{
					BufferInfo bufferInfo = bufflist[item.id];
					gSPacketIn.WriteInt(bufferInfo.TemplateID);
					gSPacketIn.WriteBoolean(val: true);
					gSPacketIn.WriteDateTime(bufferInfo.BeginDate);
					gSPacketIn.WriteInt(bufferInfo.ValidDate / 24 / 60);
				}
				else
				{
					gSPacketIn.WriteInt(item.id);
					gSPacketIn.WriteBoolean(val: false);
					gSPacketIn.WriteDateTime(DateTime.Now);
					gSPacketIn.WriteInt(0);
				}
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendBufferList(GamePlayer player, List<AbstractBuffer> infos)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(186, player.PlayerId);
			gSPacketIn.WriteInt(infos.Count);
			foreach (AbstractBuffer info in infos)
			{
				BufferInfo ınfo = info.Info;
				gSPacketIn.WriteInt(ınfo.Type);
				gSPacketIn.WriteBoolean(ınfo.IsExist);
				gSPacketIn.WriteDateTime(ınfo.BeginDate);
				gSPacketIn.WriteInt(ınfo.ValidDate);
				gSPacketIn.WriteInt(ınfo.Value);
				gSPacketIn.WriteInt(ınfo.ValidCount);
				gSPacketIn.WriteInt(ınfo.TemplateID);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendMailResponse(int playerID, eMailRespose type)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(117);
			gSPacketIn.WriteInt(playerID);
			gSPacketIn.WriteInt((int)type);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendAuctionRefresh(AuctionInfo info, int auctionID, bool isExist, ItemInfo item)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(195);
			gSPacketIn.WriteInt(auctionID);
			gSPacketIn.WriteBoolean(isExist);
			if (isExist)
			{
				gSPacketIn.WriteInt(info.AuctioneerID);
				gSPacketIn.WriteString(info.AuctioneerName);
				gSPacketIn.WriteDateTime(info.BeginDate);
				gSPacketIn.WriteInt(info.BuyerID);
				gSPacketIn.WriteString(info.BuyerName);
				gSPacketIn.WriteInt(info.ItemID);
				gSPacketIn.WriteInt(info.Mouthful);
				gSPacketIn.WriteInt(info.PayType);
				gSPacketIn.WriteInt(info.Price);
				gSPacketIn.WriteInt(info.Rise);
				gSPacketIn.WriteInt(info.ValidDate);
				gSPacketIn.WriteBoolean(item != null);
				if (item != null)
				{
					gSPacketIn.WriteInt(item.Count);
					gSPacketIn.WriteInt(item.TemplateID);
					gSPacketIn.WriteInt(item.AttackCompose);
					gSPacketIn.WriteInt(item.DefendCompose);
					gSPacketIn.WriteInt(item.AgilityCompose);
					gSPacketIn.WriteInt(item.LuckCompose);
					gSPacketIn.WriteInt(item.StrengthenLevel);
					gSPacketIn.WriteBoolean(item.IsBinds);
					gSPacketIn.WriteBoolean(item.IsJudge);
					gSPacketIn.WriteDateTime(item.BeginDate);
					gSPacketIn.WriteInt(item.ValidDate);
					gSPacketIn.WriteString(item.Color);
					gSPacketIn.WriteString(item.Skin);
					gSPacketIn.WriteBoolean(item.IsUsed);
					gSPacketIn.WriteInt(item.Hole1);
					gSPacketIn.WriteInt(item.Hole2);
					gSPacketIn.WriteInt(item.Hole3);
					gSPacketIn.WriteInt(item.Hole4);
					gSPacketIn.WriteInt(item.Hole5);
					gSPacketIn.WriteInt(item.Hole6);
					gSPacketIn.WriteString(item.Pic);
					gSPacketIn.WriteInt(item.RefineryLevel);
					gSPacketIn.WriteDateTime(DateTime.Now);
					gSPacketIn.WriteByte((byte)item.Int32_0);
					gSPacketIn.WriteInt(item.Hole5Exp);
					gSPacketIn.WriteByte((byte)item.Int32_1);
					gSPacketIn.WriteInt(item.Hole6Exp);
				}
			}
			gSPacketIn.Compress();
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendAASState(bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(224);
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendIDNumberCheck(bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(226);
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendAASInfoSet(bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(224);
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendAASControl(bool result, bool bool_0, bool IsMinor)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(227);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteBoolean(val: true);
			gSPacketIn.WriteBoolean(IsMinor);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendMarryRoomInfo(GamePlayer player, MarryRoom room)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(241, player.PlayerCharacter.ID);
			bool flag = room != null;
			gSPacketIn.WriteBoolean(flag);
			if (flag)
			{
				gSPacketIn.WriteInt(room.Info.ID);
				gSPacketIn.WriteBoolean(room.Info.IsHymeneal);
				gSPacketIn.WriteString(room.Info.Name);
				gSPacketIn.WriteBoolean(!(room.Info.Pwd == ""));
				gSPacketIn.WriteInt(room.Info.MapIndex);
				gSPacketIn.WriteInt(room.Info.AvailTime);
				gSPacketIn.WriteInt(room.Count);
				gSPacketIn.WriteInt(room.Info.PlayerID);
				gSPacketIn.WriteString(room.Info.PlayerName);
				gSPacketIn.WriteInt(room.Info.GroomID);
				gSPacketIn.WriteString(room.Info.GroomName);
				gSPacketIn.WriteInt(room.Info.BrideID);
				gSPacketIn.WriteString(room.Info.BrideName);
				gSPacketIn.WriteDateTime(room.Info.BeginTime);
				gSPacketIn.WriteByte((byte)room.RoomState);
				gSPacketIn.WriteString(room.Info.RoomIntroduction);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendMarryRoomLogin(GamePlayer player, bool result)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(242, player.PlayerCharacter.ID);
			gSPacketIn.WriteBoolean(result);
			if (result)
			{
				gSPacketIn.WriteInt(player.CurrentMarryRoom.Info.ID);
				gSPacketIn.WriteString(player.CurrentMarryRoom.Info.Name);
				gSPacketIn.WriteInt(player.CurrentMarryRoom.Info.MapIndex);
				gSPacketIn.WriteInt(player.CurrentMarryRoom.Info.AvailTime);
				gSPacketIn.WriteInt(player.CurrentMarryRoom.Count);
				gSPacketIn.WriteInt(player.CurrentMarryRoom.Info.PlayerID);
				gSPacketIn.WriteString(player.CurrentMarryRoom.Info.PlayerName);
				gSPacketIn.WriteInt(player.CurrentMarryRoom.Info.GroomID);
				gSPacketIn.WriteString(player.CurrentMarryRoom.Info.GroomName);
				gSPacketIn.WriteInt(player.CurrentMarryRoom.Info.BrideID);
				gSPacketIn.WriteString(player.CurrentMarryRoom.Info.BrideName);
				gSPacketIn.WriteDateTime(player.CurrentMarryRoom.Info.BeginTime);
				gSPacketIn.WriteBoolean(player.CurrentMarryRoom.Info.IsHymeneal);
				gSPacketIn.WriteByte((byte)player.CurrentMarryRoom.RoomState);
				gSPacketIn.WriteString(player.CurrentMarryRoom.Info.RoomIntroduction);
				gSPacketIn.WriteBoolean(player.CurrentMarryRoom.Info.GuestInvite);
				gSPacketIn.WriteInt(player.MarryMap);
				gSPacketIn.WriteBoolean(player.CurrentMarryRoom.Info.IsGunsaluteUsed);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerEnterMarryRoom(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(243, player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(player.PlayerCharacter.Grade);
			gSPacketIn.WriteInt(player.PlayerCharacter.Hide);
			gSPacketIn.WriteInt(player.PlayerCharacter.Repute);
			gSPacketIn.WriteInt(player.PlayerCharacter.ID);
			gSPacketIn.WriteString(player.PlayerCharacter.NickName);
			gSPacketIn.WriteByte(player.PlayerCharacter.typeVIP);
			gSPacketIn.WriteInt(player.PlayerCharacter.VIPLevel);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.Sex);
			gSPacketIn.WriteString(player.PlayerCharacter.Style);
			gSPacketIn.WriteString(player.PlayerCharacter.Colors);
			gSPacketIn.WriteString(player.PlayerCharacter.Skin);
			gSPacketIn.WriteInt(player.X);
			gSPacketIn.WriteInt(player.Y);
			gSPacketIn.WriteInt(player.PlayerCharacter.FightPower);
			gSPacketIn.WriteInt(player.PlayerCharacter.Win);
			gSPacketIn.WriteInt(player.PlayerCharacter.Total);
			gSPacketIn.WriteInt(player.PlayerCharacter.Offer);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.IsOldPlayer);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendMarryInfoRefresh(MarryInfo info, int ID, bool isExist)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(239);
			gSPacketIn.WriteInt(ID);
			gSPacketIn.WriteBoolean(isExist);
			if (isExist)
			{
				gSPacketIn.WriteInt(info.UserID);
				gSPacketIn.WriteBoolean(info.IsPublishEquip);
				gSPacketIn.WriteString(info.Introduction);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerMarryStatus(GamePlayer player, int userID, bool isMarried)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(246, player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(userID);
			gSPacketIn.WriteBoolean(isMarried);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerMarryApply(GamePlayer player, int userID, string userName, string loveProclamation, int id)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(247, player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(userID);
			gSPacketIn.WriteString(userName);
			gSPacketIn.WriteString(loveProclamation);
			gSPacketIn.WriteInt(id);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerDivorceApply(GamePlayer player, bool result, bool isProposer)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(248, player.PlayerCharacter.ID);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteBoolean(isProposer);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendMarryApplyReply(GamePlayer player, int UserID, string UserName, bool result, bool isApplicant, int id)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(250, player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(UserID);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(UserName);
			gSPacketIn.WriteBoolean(isApplicant);
			gSPacketIn.WriteInt(id);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendPlayerLeaveMarryRoom(GamePlayer player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(244, player.PlayerCharacter.ID);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendMarryRoomInfoToPlayer(GamePlayer player, bool state, MarryRoomInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(252, player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(info.ID);
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
			return gSPacketIn;
		}

		public GSPacketIn SendMarryInfo(GamePlayer player, MarryInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(235, player.PlayerCharacter.ID);
			gSPacketIn.WriteString(info.Introduction);
			gSPacketIn.WriteBoolean(info.IsPublishEquip);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendContinuation(GamePlayer player, MarryRoomInfo info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(249, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(info.AvailTime);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendMarryProp(GamePlayer player, MarryProp info)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(234, player.PlayerCharacter.ID);
			gSPacketIn.WriteBoolean(info.IsMarried);
			gSPacketIn.WriteInt(info.SpouseID);
			gSPacketIn.WriteString(info.SpouseName);
			gSPacketIn.WriteBoolean(info.IsCreatedMarryRoom);
			gSPacketIn.WriteInt(info.SelfMarryRoomID);
			gSPacketIn.WriteBoolean(info.IsGotRing);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendConsortiaCreate(string name1, bool result, int id, string name2, string msg, int dutyLevel, string DutyName, int dutyRight, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(1);
			gSPacketIn.WriteString(name1);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteString(name2);
			gSPacketIn.WriteString(msg);
			gSPacketIn.WriteInt(dutyLevel);
			gSPacketIn.WriteString((DutyName == null) ? "" : DutyName);
			gSPacketIn.WriteInt(dutyRight);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendConsortiaRichesOffer(int money, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(6);
			gSPacketIn.WriteInt(money);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendConsortiaInvite(string username, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(11);
			gSPacketIn.WriteString(username);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaInvitePass(int id, bool result, int consortiaid, string consortianame, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(12);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaInviteDel(int id, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(13);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendConsortiaLevelUp(byte type, byte level, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(21);
			gSPacketIn.WriteByte(type);
			gSPacketIn.WriteByte(level);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaTryIn(int id, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaTryInPass(int id, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(4);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaTryInDel(int id, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(5);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaUpdateDescription(string description, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(14);
			gSPacketIn.WriteString(description);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaEquipConstrol(bool result, List<int> Riches, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(24);
			gSPacketIn.WriteBoolean(result);
			for (int i = 0; i < Riches.Count; i++)
			{
				gSPacketIn.WriteInt(Riches[i]);
			}
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendConsortiaMemberGrade(int id, bool update, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(18);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteBoolean(update);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaOut(int id, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(id);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaChangeChairman(string nick, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(14);
			gSPacketIn.WriteString(nick);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaUpdatePlacard(string description, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(15);
			gSPacketIn.WriteString(description);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendConsortiaApplyStatusOut(bool state, bool result, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteBoolean(result);
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendBuyBadge(int BadgeID, int ValidDate, bool result, string BadgeBuyTime, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(28);
			gSPacketIn.WriteInt(BadgeID);
			gSPacketIn.WriteInt(BadgeID);
			gSPacketIn.WriteInt(ValidDate);
			gSPacketIn.WriteDateTime(Convert.ToDateTime(BadgeBuyTime));
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendConsortia(int money, bool result, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(6);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendConsortiaMail(bool result, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, playerid);
			gSPacketIn.WriteByte(29);
			gSPacketIn.WriteBoolean(result);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn sendOneOnOneTalk(int receiverID, bool isAutoReply, string SenderNickName, string msg, int playerid)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(160, playerid);
			gSPacketIn.WriteByte(51);
			gSPacketIn.WriteInt(receiverID);
			gSPacketIn.WriteString(SenderNickName);
			gSPacketIn.WriteDateTime(DateTime.Now);
			gSPacketIn.WriteString(msg);
			gSPacketIn.WriteBoolean(isAutoReply);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendNecklaceStrength(PlayerInfo player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(95, player.ID);
			gSPacketIn.WriteInt(player.necklaceExp);
			gSPacketIn.WriteInt(player.necklaceExpAdd);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendMissionEnergy(UsersExtraInfo extra)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(105, extra.UserID);
			gSPacketIn.WriteInt(extra.MissionEnergy);
			gSPacketIn.WriteInt(extra.buyEnergyCount);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		public GSPacketIn SendUpdateOneKeyFinish(PlayerInfo player)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(86, player.ID);
			gSPacketIn.WriteInt(10000);
			SendTCP(gSPacketIn);
			return gSPacketIn;
		}

		static AbstractPacketLib()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
