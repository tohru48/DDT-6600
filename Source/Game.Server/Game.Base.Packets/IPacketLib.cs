using System.Collections.Generic;
using Game.Server.Achievements;
using Game.Server.Buffer;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Game.Server.Packets;
using Game.Server.Quests;
using Game.Server.Rooms;
using Game.Server.SceneMarryRooms;
using SqlDataProvider.Data;

namespace Game.Base.Packets
{
	public interface IPacketLib
	{
		void SendOpenOrCloseChristmas(int lastPacks, bool isOpen);

		GSPacketIn SendUpdateOneKeyFinish(PlayerInfo player);

		GSPacketIn SendNecklaceStrength(PlayerInfo player);

		GSPacketIn SendMissionEnergy(UsersExtraInfo extra);

		void SendPlayerCardEquip(PlayerInfo player, List<UsersCardInfo> cards);

		GSPacketIn SendUpdateGoodsCount(PlayerInfo player, ShopItemInfo[] BagList, ShopItemInfo[] ConsoList);

		GSPacketIn SendUserRanks(int Id, List<UserRankInfo> ranks);

		GSPacketIn SendUpdateAchievements(GamePlayer player, BaseAchievement[] infos);

		GSPacketIn SendAchievementDatas(GamePlayer player, BaseAchievement[] infos);

		GSPacketIn SendDiceActiveClose(int ID);

		GSPacketIn SendDiceReceiveData(PlayerDice Dice);

		GSPacketIn SendDiceReceiveResult(PlayerDice Dice);

		GSPacketIn SendDiceActiveOpen(PlayerDice Dice);

		GSPacketIn SendGrowthPackageIsOpen(int ID);

		GSPacketIn SendGrowthPackageOpen(int ID, int isBuy);

		GSPacketIn SendGrowthPackageUpadte(int ID, int isBuy);

		GSPacketIn SendChickenBoxOpen(int ID, int flushPrice, int[] openCardPrice, int[] eagleEyePrice);

		GSPacketIn SendKingBlessMain(PlayerExtra Extra);

		GSPacketIn SendKingBlessUpdateBuffData(int UserID, int data, int value);

		GSPacketIn SendDeedMain(PlayerExtra Extra);

		GSPacketIn SendDeedUpdateBuffData(int UserID, int data, int value);

		GSPacketIn SendRuneOpenPackage(GamePlayer player, int rand);

		GSPacketIn SendPlayerDrill(int ID, Dictionary<int, UserDrillInfo> drills);

		GSPacketIn SendLuckStoneEnable(int ID);

		GSPacketIn SendActivityList(int ID);

		void SendExpBlessedData(int PlayerId);

		GSPacketIn SendFindBackIncome(int ID);

		void SendWeaklessGuildProgress(PlayerInfo player);

		GSPacketIn SendCampBattleOpenClose(int ID, bool result);

		GSPacketIn SendSevenDoubleOpenClose(int ID, bool result);

		GSPacketIn SendConsortiaBattleOpenClose(int ID, bool result);

		GSPacketIn SendFightFootballTimeOpenClose(int ID, bool result);

		GSPacketIn SendGetBoxTime(int ID, int receiebox, bool result);

		GSPacketIn SendBattleGoundOpen(int ID);

		GSPacketIn SendBattleGoundOver(int ID);

		GSPacketIn SendConsortiaCreate(string name1, bool result, int id, string name2, string msg, int dutyLevel, string DutyName, int dutyRight, int playerid);

		GSPacketIn SendConsortiaRichesOffer(int money, bool result, string msg, int playerid);

		GSPacketIn SendConsortiaInvite(string username, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaInvitePass(int id, bool result, int consortiaid, string consortianame, string msg, int playerid);

		GSPacketIn sendConsortiaInviteDel(int id, bool result, string msg, int playerid);

		GSPacketIn SendConsortiaLevelUp(byte type, byte level, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaTryIn(int id, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaTryInPass(int id, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaTryInDel(int id, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaUpdateDescription(string description, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaEquipConstrol(bool result, List<int> Riches, int playerid);

		GSPacketIn SendConsortiaMemberGrade(int id, bool update, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaOut(int id, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaChangeChairman(string nick, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaUpdatePlacard(string description, bool result, string msg, int playerid);

		GSPacketIn sendConsortiaApplyStatusOut(bool state, bool result, int playerid);

		GSPacketIn sendBuyBadge(int BadgeID, int ValidDate, bool result, string BadgeBuyTime, int playerid);

		GSPacketIn SendFarmPoultryLevel(int PlayerID, UserFarmInfo farm, int nextLevel);

		GSPacketIn SendHelperSwitchField(PlayerInfo Player, UserFarmInfo farm);

		GSPacketIn SendFarmLandInfo(PlayerFarm farm);

		GSPacketIn SendEnterFarm(PlayerInfo Player, UserFarmInfo farm, UserFieldInfo[] fields);

		GSPacketIn SendSeeding(PlayerInfo Player, UserFieldInfo field);

		GSPacketIn SendKillCropField(PlayerInfo Player, UserFieldInfo field);

		GSPacketIn SendtoGather(PlayerInfo Player, UserFieldInfo field);

		GSPacketIn SenddoMature(PlayerFarm farm);

		GSPacketIn SendPayFields(GamePlayer Player, List<int> fieldIds);

		void SendPetGuildOptionChange();

		void SendOpenWorldBoss(int pX, int pY);

		void SendLittleGameActived();

		void SendTCP(GSPacketIn packet);

		void SendLoginSuccess();

		void SendCheckCode();

		void SendNotEnoughEnergyBuy(bool MustBuy);

		void SendUpdateCountHorseRace(int count);

		void SendUpdateAreaInfo();

		void SendLoginFailed(string msg);

		void SendKitoff(string msg);

		void SendEditionError(string msg);

		GSPacketIn SendGameMissionStart();

		GSPacketIn SendGameMissionPrepare();

		GSPacketIn SendRefreshPet(GamePlayer player, UsersPetinfo[] pets, ItemInfo[] items, bool refreshBtn);

		void SendDateTime();

		void SendOpenEntertainmentMode();

		void SendOpenWorshipTheMoon(bool open);

		void SendUesedFinishTime(int uesedFinishTime);

		void SendchangeHorse(int curIndex);

		void SendPicCherishInfo(int playerId, MountDrawDataInfo[] draws);

		void SendHorseInitAllData(MountDataInfo info, MountSkillDataInfo[] skills);

		void SendUpHorse(bool isHasLevelUp, int grade, int exp);

		GSPacketIn SendDailyAward(PlayerInfo player);

		void SendPingTime(GamePlayer player);

		void SendUpdatePrivateInfo(PlayerInfo info);

		void SendDragonBoat(PlayerInfo info);

		void SendLeagueNotice(int id, int restCount, int maxCount, byte type);

		void SendPyramidOpenClose(PyramidConfigInfo info);

		void SendGuildMemberWeekOpenClose(PyramidConfigInfo info);

		void SendSuperWinnerOpen(int playerID, bool isOpen);

		void SendCatchBeastOpen(int playerID, bool isOpen);

		void SendLanternriddlesOpen(int playerID, bool isOpen);

		void SendTreasureHunting(PyramidConfigInfo info);

		void imethod_0(int UserID);

		void imethod_1(int UserID, GClass1 QQTips);

		GSPacketIn SendLuckStarOpen(int ID);

		GSPacketIn SendUpdatePlayerProperty(PlayerInfo info, PlayerProperty prop);

		GSPacketIn SendUpdatePublicPlayer(PlayerInfo info, UserMatchInfo matchInfo);

		GSPacketIn SendNetWork(GamePlayer player, long delay);

		GSPacketIn SendUserEquip(PlayerInfo info, List<ItemInfo> items, List<UserGemStone> UserGemStone, List<ItemInfo> beadItems, List<ItemInfo> magicStone);

		GSPacketIn SendMessage(eMessageType type, string message);

		GSPacketIn SendGetPlayerCard(int playerId);

		GSPacketIn SendPlayerCardReset(PlayerInfo player, List<int> points);

		void SendPlayerCardSlot(PlayerInfo info, List<UsersCardInfo> cardslots);

		GSPacketIn SendPlayerCardSlot(PlayerInfo player, UsersCardInfo card);

		GSPacketIn SendPlayerCardSoul(PlayerInfo player, bool isSoul, int soul);

		GSPacketIn SendGetCard(PlayerInfo info, UsersCardInfo card);

		void SendPlayerCardInfo(CardInventory bag, int[] updatedSlots);

		GSPacketIn SendPetInfo(int id, int zoneId, UsersPetinfo[] pets);

		GSPacketIn SendUpdateUserPet(PetInventory bag, int[] slots);

		GSPacketIn SendEatPetsInfo(EatPetsInfo info);

		GSPacketIn sendOneOnOneTalk(int receiverID, bool isAutoReply, string SenderNickName, string msg, int playerid);

		void SendWaitingRoom(bool result);

		GSPacketIn SendUpdateRoomList(List<BaseRoom> room);

		GSPacketIn SendSceneAddPlayer(GamePlayer player);

		GSPacketIn SendSceneRemovePlayer(GamePlayer player);

		GSPacketIn SendOpenHoleComplete(GamePlayer player, int type, bool result);

		GSPacketIn SendRoomCreate(BaseRoom room);

		GSPacketIn SendSingleRoomCreate(BaseRoom room);

		GSPacketIn SendRoomLoginResult(bool result);

		GSPacketIn SendRoomPlayerAdd(GamePlayer player);

		GSPacketIn SendRoomPlayerRemove(GamePlayer player);

		GSPacketIn SendRoomUpdatePlayerStates(byte[] states);

		GSPacketIn SendRoomUpdatePlacesStates(int[] states);

		GSPacketIn SendRoomPlayerChangedTeam(GamePlayer player);

		GSPacketIn SendRoomPairUpStart(BaseRoom room);

		GSPacketIn SendRoomPairUpCancel(BaseRoom room);

		GSPacketIn SendEquipChange(GamePlayer player, int place, int goodsID, string style);

		GSPacketIn SendGameRoomSetupChange(BaseRoom room);

		GSPacketIn SendSetDressModelArr(int playerId, Dictionary<int, List<ItemInfo>> dresses);

		GSPacketIn SendCurentDressModel(int playerId, int current);

		GSPacketIn SendAvatarColectionAllInfo(PlayerAvataInventory DressBag);

		GSPacketIn SendFusionPreview(GamePlayer player, Dictionary<int, double> previewItemList, bool isBind, int MinValid);

		GSPacketIn SendFusionResult(GamePlayer player, bool result);

		GSPacketIn SendRefineryPreview(GamePlayer player, int templateid, bool isbind, ItemInfo item);

		void SendUpdateInventorySlot(PlayerInventory bag, int[] updatedSlots);

		GSPacketIn SendAddFriend(PlayerInfo user, int relation, bool state);

		GSPacketIn SendFriendRemove(int FriendID);

		GSPacketIn SendFriendState(int playerID, int state, byte typeVip, int viplevel);

		GSPacketIn SendUpdateAllData(PlayerInfo player);

		GSPacketIn SendGetSpree(PlayerInfo player);

		GSPacketIn SendUpdateUpCount(PlayerInfo player);

		GSPacketIn SendPlayerRefreshTotem(PlayerInfo player);

		GSPacketIn SendLabyrinthUpdataInfo(int ID, UserLabyrinthInfo laby);

		GSPacketIn SendTrusteeshipStart(int ID);

		GSPacketIn SendPlayerFigSpiritinit(int ID, List<UserGemStone> gems);

		GSPacketIn SendPlayerFigSpiritUp(int ID, UserGemStone gem, bool isUp, bool isMaxLevel, bool isFall, int num, int dir);

		GSPacketIn SendUpdateBuffer(GamePlayer player, BufferInfo[] infos);

		GSPacketIn SendBufferList(GamePlayer player, List<AbstractBuffer> infos);

		GSPacketIn SendUpdateConsotiaBuffer(GamePlayer player, Dictionary<int, BufferInfo> bufflist);

		GSPacketIn SendUpdateQuests(GamePlayer player, byte[] states, BaseQuest[] quests);

		GSPacketIn SendMailResponse(int playerID, eMailRespose type);

		GSPacketIn SendAuctionRefresh(AuctionInfo info, int auctionID, bool isExist, ItemInfo item);

		GSPacketIn SendIDNumberCheck(bool result);

		GSPacketIn SendConsortiaMail(bool result, int playerid);

		GSPacketIn SendAASState(bool result);

		GSPacketIn SendAASInfoSet(bool result);

		GSPacketIn SendAASControl(bool result, bool bool_0, bool IsMinor);

		GSPacketIn imethod_2(PlayerInfo Player);

		GSPacketIn SendMarryInfoRefresh(MarryInfo info, int ID, bool isExist);

		GSPacketIn SendMarryRoomInfo(GamePlayer player, MarryRoom room);

		GSPacketIn SendPlayerEnterMarryRoom(GamePlayer player);

		GSPacketIn SendPlayerMarryStatus(GamePlayer player, int userID, bool isMarried);

		GSPacketIn SendPlayerMarryApply(GamePlayer player, int userID, string userName, string loveProclamation, int ID);

		GSPacketIn SendPlayerDivorceApply(GamePlayer player, bool result, bool isProposer);

		GSPacketIn SendMarryApplyReply(GamePlayer player, int UserID, string UserName, bool result, bool isApplicant, int ID);

		GSPacketIn SendPlayerLeaveMarryRoom(GamePlayer player);

		GSPacketIn SendMarryRoomLogin(GamePlayer player, bool result);

		GSPacketIn SendMarryRoomInfoToPlayer(GamePlayer player, bool state, MarryRoomInfo info);

		GSPacketIn SendMarryInfo(GamePlayer player, MarryInfo info);

		GSPacketIn SendContinuation(GamePlayer player, MarryRoomInfo info);

		GSPacketIn SendContinuation(GamePlayer player, HotSpringRoomInfo hotSpringRoomInfo);

		GSPacketIn SendMarryProp(GamePlayer player, MarryProp info);

		GSPacketIn SendRoomType(GamePlayer player, BaseRoom game);
	}
}
