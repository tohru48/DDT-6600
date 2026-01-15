using System;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Object;
using Game.Server.Achievements;
using Game.Server.ActiveSystem;
using Game.Server.AvatarCollection;
using Game.Server.BombKing;
using Game.Server.Buffer;
using Game.Server.BuffHorseRace;
using Game.Server.CollectionTask;
using Game.Server.DragonBoat;
using Game.Server.Farm;
using Game.Server.GameRoom;
using Game.Server.GameUtils;
using Game.Server.GypsyShop;
using Game.Server.Horse;
using Game.Server.MagicHouse;
using Game.Server.MagicStone;
using Game.Server.MagpieBridge;
using Game.Server.Managers;
using Game.Server.NewHall;
using Game.Server.Packets;
using Game.Server.Pet;
using Game.Server.Quests;
using Game.Server.RingStation;
using Game.Server.Rooms;
using Game.Server.SceneMarryRooms;
using Game.Server.Statics;
using Game.Server.WorshipTheMoon;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameObjects
{
	public class GamePlayer : IGamePlayer
	{
		public delegate void PlayerEventHandle(GamePlayer player);

		public delegate void PlayerItemPropertyEventHandle(int templateID);

		public delegate void PlayerGameOverEventHandle(AbstractGame game, bool isWin, int gainXp);

		public delegate void PlayerMissionOverEventHandle(AbstractGame game, int missionId, bool isWin);

		public delegate void PlayerMissionFullOverEventHandle(AbstractGame game, int missionId, bool isWin, int turnNum);

		public delegate void PlayerMissionTurnOverEventHandle(AbstractGame game, int missionId, int turnNum);

		public delegate void PlayerQuestOneKeyFinishEventHandle(QuestConditionInfo condition);

		public delegate void PlayerItemStrengthenEventHandle(int categoryID, int level);

		public delegate void PlayerShopEventHandle(int money, int gold, int offer, int gifttoken, int medal, string payGoods);

		public delegate void PlayerAdoptPetEventHandle();

		public delegate void PlayerNewGearEventHandle(int CategoryID);

		public delegate void PlayerCropPrimaryEventHandle();

		public delegate void PlayerSeedFoodPetEventHandle();

		public delegate void PlayerUserToemGemstoneEventHandle(int type);

		public delegate void PlayerCollectionTaskEventHandle(int type);

		public delegate void PlayerUpLevelPetEventHandle();

		public delegate void PlayerItemInsertEventHandle();

		public delegate void PlayerItemFusionEventHandle(int fusionType);

		public delegate void PlayerItemMeltEventHandle(int categoryID);

		public delegate void PlayerGameKillEventHandel(AbstractGame game, int type, int id, bool isLiving, int demage);

		public delegate void PlayerOwnConsortiaEventHandle();

		public delegate void PlayerItemComposeEventHandle(int composeType);

		public delegate void PlayerAchievementFinish(AchievementDataInfo info);

		public delegate void PlayerFightAddOffer(int offer);

		public delegate void PlayerFightOneBloodIsWin(eRoomType roomType);

		public delegate void PlayerVIPUpgrade(int level, int exp);

		public delegate void PlayerHotSpingExpAdd(int minutes, int exp);

		public delegate void PlayerGoldCollection(int value);

		public delegate void PlayerGiftTokenCollection(int value);

		public delegate void PlayerPropertisChange(PlayerInfo player);

		public delegate void PlayerQuestFinish(QuestDataInfo data, QuestInfo info);

		public delegate void PlayerUseBugle(int value);

		public delegate void GameKillDropEventHandel(AbstractGame game, int type, int npcId, bool playResult);

		private static readonly ILog ilog_0;

		private ePlayerState ePlayerState_0;

		protected BaseGame m_game;

		private int int_0;

		protected GameClient m_client;

		protected Player m_players;

		private PlayerInfo playerInfo_0;

		private string string_0;

		private int int_1;

		public int FightPower;

		private bool bool_0;

		private bool bool_1;

		private long long_0;

		private char[] char_0;

		public long PingStart;

		private bool bool_2;

		private List<BufferInfo> list_0;

		private UsersPetinfo usersPetinfo_0;

		private PlayerEquipInventory playerEquipInventory_0;

		private PlayerAvataInventory playerAvataInventory_0;

		private PlayerInventory playerInventory_0;

		private PlayerInventory playerInventory_1;

		private PlayerInventory playerInventory_2;

		private PlayerMagicHouse playerMagicHouse_0;

		private PlayerInventory playerInventory_3;

		private PlayerInventory playerInventory_4;

		private PlayerInventory playerInventory_5;

		private PlayerInventory playerInventory_6;

		private PlayerInventory playerInventory_7;

		private PlayerInventory playerInventory_8;

		private PlayerInventory playerInventory_9;

		private PlayerInventory playerInventory_10;

		private PlayerBeadInventory playerBeadInventory_0;

		private PlayerMagicStoneInventory playerMagicStoneInventory_0;

		private CardInventory cardInventory_0;

		private PlayerFarm playerFarm_0;

		private PetInventory petInventory_0;

		private PlayerTreasure playerTreasure_0;

		private PlayerProperty playerProperty_0;

		private PlayerRank playerRank_0;

		private PlayerDice playerDice_0;

		private PlayerBattle playerBattle_0;

		private PlayerExtra playerExtra_0;

		private PlayerHorse playerHorse_0;

		private PlayerActives playerActives_0;

		private AchievementInventory achievementInventory_0;

		private QuestInventory questInventory_0;

		private BufferList bufferList_0;

		private PlayerEventHandle playerEventHandle_0;

		private UserLabyrinthInfo userLabyrinthInfo_0;

		private List<UserGemStone> list_1;

		private List<ItemInfo> list_2;

		private int int_2;

		public readonly int[] EquipPlace;

		public double double_0;

		public double OfferAddPlus;

		public double GuildRichAddPlus;

		public DateTime LastChatTime;

		public DateTime LastFigUpTime;

		public DateTime LastDrillUpTime;

		public DateTime LastOpenPack;

		public DateTime LastOpenGrowthPackage;

		public DateTime LastOpenChristmasPackage;

		public DateTime LastOpenCard;

		public DateTime LastAttachMail;

		public DateTime LastEnterWorldBoss;

		public DateTime WaitingProcessor;

		public bool KickProtect;

		public RingstationBattleFieldInfo DareFlag;

		public RingstationBattleFieldInfo SuccessFlag;

		private double double_1;

		private double double_2;

		private ItemInfo itemInfo_0;

		private BatleConfigInfo batleConfigInfo_0;

		private ItemInfo itemInfo_1;

		private ItemInfo itemInfo_2;

		public bool isUpdateEnterModePoint;

		public readonly string[] labyrinthGolds;

		private List<int> list_3;

		private Dictionary<int, int> dictionary_0;

		protected GameRoomLogicProcessor m_gameroomProcessor;

		private GameRoomProcessor gameRoomProcessor_0;

		protected AvatarCollectionLogicProcessor m_avatarCollectionProcessor;

		private AvatarCollectionProcessor avatarCollectionProcessor_0;

		protected MagicStoneLogicProcessor m_magicStoneProcessor;

		private MagicStoneProcessor magicStoneProcessor_0;

		protected NewHallLogicProcessor m_newHallProcessor;

		private NewHallProcessor newHallProcessor_0;

		protected CollectionTaskLogicProcessor m_collectionTaskProcessor;

		private CollectionTaskProcessor collectionTaskProcessor_0;

		protected HorseLogicProcessor m_horseProcessor;

		private HorseProcessor horseProcessor_0;

		protected RingStationLogicProcessor m_ringStationProcessor;

		private RingStationProcessor ringStationProcessor_0;

		protected FarmLogicProcessor m_farmProcessor;

		private FarmProcessor farmProcessor_0;

		protected PetLogicProcessor m_petProcessor;

		private PetProcessor petProcessor_0;

		protected BombKingLogicProcessor m_bombKingProcessor;

		private BombKingProcessor bombKingProcessor_0;

		protected MagicHouseLogicProcessor m_magicHouseProcessor;

		private MagicHouseProcessor magicHouseProcessor_0;

		protected DragonBoatLogicProcessor m_dragonBoatProcessor;

		private DragonBoatProcessor dragonBoatProcessor_0;

		protected ActiveSystemLogicProcessor m_activeSystemProcessor;

		private ActiveSystemProcessor activeSystemProcessor_0;

		protected WorshipTheMoonLogicProcessor m_worshipTheMoonProcessor;

		private WorshipTheMoonProcessor worshipTheMoonProcessor_0;

		protected MagpieBridgeLogicProcessor m_magpieBridgeProcessor;

		private MagpieBridgeProcessor magpieBridgeProcessor_0;

		protected GypsyShopLogicProcessor m_gypsyShopProcessor;

		private GypsyShopProcessor gypsyShopProcessor_0;

		private BaseRoom baseRoom_0;

		private BaseHorseRaceRoom baseHorseRaceRoom_0;

		public UserHorseRaceInfo CurrentHorseRaceInfo;

		public int CurrentRoomIndex;

		public int CurrentRoomTeam;

		public int WorldBossMap;

		private bool bool_3;

		public byte States;

		public bool isPowerFullUsed;

		public int winningStreak;

		public Dictionary<int, CardsTakeOutInfo> Card;

		public CardsTakeOutInfo[] CardsTakeOut;

		public int canTakeOut;

		public int takeoutCount;

		public int PosX;

		public int PosY;

		public int CollectionTaskPosX;

		public int CollectionTaskPosY;

		public int X;

		public int Y;

		public int MarryMap;

		private BaseSevenDoubleRoom baseSevenDoubleRoom_0;

		private MarryRoom marryRoom_0;

		public int HotMap;

		private static char[] char_1;

		private Dictionary<string, object> dictionary_1;

		private PlayerEventHandle playerEventHandle_1;

		private PlayerItemPropertyEventHandle playerItemPropertyEventHandle_0;

		private PlayerGameOverEventHandle playerGameOverEventHandle_0;

		private PlayerMissionOverEventHandle playerMissionOverEventHandle_0;

		private PlayerMissionFullOverEventHandle playerMissionFullOverEventHandle_0;

		private PlayerMissionTurnOverEventHandle playerMissionTurnOverEventHandle_0;

		private PlayerQuestOneKeyFinishEventHandle playerQuestOneKeyFinishEventHandle_0;

		private PlayerItemStrengthenEventHandle playerItemStrengthenEventHandle_0;

		private PlayerShopEventHandle playerShopEventHandle_0;

		private PlayerAdoptPetEventHandle playerAdoptPetEventHandle_0;

		private PlayerNewGearEventHandle playerNewGearEventHandle_0;

		private PlayerCropPrimaryEventHandle playerCropPrimaryEventHandle_0;

		private PlayerSeedFoodPetEventHandle playerSeedFoodPetEventHandle_0;

		private PlayerUserToemGemstoneEventHandle playerUserToemGemstoneEventHandle_0;

		private PlayerCollectionTaskEventHandle playerCollectionTaskEventHandle_0;

		private PlayerUpLevelPetEventHandle playerUpLevelPetEventHandle_0;

		private PlayerItemInsertEventHandle playerItemInsertEventHandle_0;

		private PlayerItemFusionEventHandle playerItemFusionEventHandle_0;

		private PlayerItemMeltEventHandle playerItemMeltEventHandle_0;

		private PlayerGameKillEventHandel playerGameKillEventHandel_0;

		private PlayerOwnConsortiaEventHandle playerOwnConsortiaEventHandle_0;

		private PlayerItemComposeEventHandle playerItemComposeEventHandle_0;

		private PlayerAchievementFinish playerAchievementFinish_0;

		private PlayerFightAddOffer MlcxAudlJc;

		private PlayerFightOneBloodIsWin playerFightOneBloodIsWin_0;

		private PlayerVIPUpgrade ceKxNurgYN;

		private PlayerHotSpingExpAdd playerHotSpingExpAdd_0;

		private PlayerGoldCollection playerGoldCollection_0;

		private PlayerGiftTokenCollection playerGiftTokenCollection_0;

		private PlayerEventHandle playerEventHandle_2;

		private PlayerPropertisChange playerPropertisChange_0;

		private PlayerQuestFinish playerQuestFinish_0;

		private PlayerUseBugle playerUseBugle_0;

		private GameKillDropEventHandel gameKillDropEventHandel_0;

		public int ZoneId => GameServer.Instance.Configuration.AreaId;

		public string ZoneName => GameServer.Instance.Configuration.AreaName;

		public ePlayerState PlayerState
		{
			get
			{
				return ePlayerState_0;
			}
			set
			{
				ePlayerState_0 = value;
			}
		}

		public BaseGame game
		{
			get
			{
				return m_game;
			}
			set
			{
				m_game = value;
			}
		}

		public int Immunity
		{
			get
			{
				return int_1;
			}
			set
			{
				int_1 = value;
			}
		}

		public int PlayerId => int_0;

		public string Account => string_0;

		public PlayerInfo PlayerCharacter => playerInfo_0;

		public UserMatchInfo MatchInfo => playerBattle_0.MatchInfo;

		public GameClient Client => m_client;

		public Player Players => m_players;

		public bool IsActive => m_client.IsConnected;

		public IPacketLib Out => m_client.Out;

		public bool IsMinor
		{
			get
			{
				return bool_0;
			}
			set
			{
				bool_0 = value;
			}
		}

		public bool Boolean_0
		{
			get
			{
				return bool_1;
			}
			set
			{
				bool_1 = value;
			}
		}

		public long PingTime
		{
			get
			{
				return long_0;
			}
			set
			{
				long_0 = value;
				GSPacketIn pkg = Out.SendNetWork(this, long_0);
				if (baseRoom_0 != null)
				{
					baseRoom_0.SendToAll(pkg, this);
				}
			}
		}

		public bool ShowPP
		{
			get
			{
				return bool_2;
			}
			set
			{
				bool_2 = value;
			}
		}

		public List<BufferInfo> FightBuffs
		{
			get
			{
				return list_0;
			}
			set
			{
				list_0 = value;
			}
		}

		public UsersPetinfo Pet => usersPetinfo_0;

		public int[] HorseSkillEquip => playerHorse_0.GetHorseSkillEquip;

		public PlayerHorse Horse => playerHorse_0;

		public PlayerMagicStoneInventory MagicStoneBag => playerMagicStoneInventory_0;

		public PlayerExtra Extra => playerExtra_0;

		public PlayerBattle BattleData => playerBattle_0;

		public PlayerActives Actives => playerActives_0;

		public PlayerDice Dice => playerDice_0;

		public PlayerProperty PlayerProp => playerProperty_0;

		public PlayerRank Rank => playerRank_0;

		public PlayerTreasure Treasure => playerTreasure_0;

		public PetInventory PetBag => petInventory_0;

		public PlayerFarm Farm => playerFarm_0;

		public PlayerEquipInventory EquipBag => playerEquipInventory_0;

		public PlayerAvataInventory AvatarBag => playerAvataInventory_0;

		public PlayerInventory PropBag => playerInventory_0;

		public PlayerInventory FightBag => playerInventory_1;

		public PlayerInventory TempBag => playerInventory_4;

		public PlayerInventory ConsortiaBag => playerInventory_2;

		public PlayerMagicHouse MagicHouse => playerMagicHouse_0;

		public PlayerInventory StoreBag => playerInventory_3;

		public PlayerInventory PetEquipBag => playerInventory_10;

		public PlayerInventory CaddyBag => playerInventory_5;

		public PlayerInventory FarmBag => playerInventory_6;

		public PlayerInventory Vegetable => playerInventory_7;

		public PlayerInventory Food => playerInventory_8;

		public PlayerInventory PetEgg => playerInventory_9;

		public PlayerBeadInventory BeadBag => playerBeadInventory_0;

		public CardInventory CardBag => cardInventory_0;

		public AchievementInventory AchievementInventory => achievementInventory_0;

		public QuestInventory QuestInventory => questInventory_0;

		public BufferList BufferList => bufferList_0;

		public UserLabyrinthInfo Labyrinth
		{
			get
			{
				return userLabyrinthInfo_0;
			}
			set
			{
				userLabyrinthInfo_0 = value;
			}
		}

		public List<UserGemStone> GemStone
		{
			get
			{
				return list_1;
			}
			set
			{
				list_1 = value;
			}
		}

		public List<ItemInfo> EquipEffect
		{
			get
			{
				return list_2;
			}
			set
			{
				list_2 = value;
			}
		}

		public bool CanUseProp { get; set; }

		public bool IsCrossZone { get; set; }

		public int Level
		{
			get
			{
				return playerInfo_0.Grade;
			}
			set
			{
				if (value != playerInfo_0.Grade)
				{
					playerInfo_0.Grade = value;
					OnLevelUp(value);
					OnPropertiesChanged();
				}
			}
		}

		public double BaseAttack
		{
			get
			{
				return double_1;
			}
			set
			{
				double_1 = value;
			}
		}

		public double BaseDefence
		{
			get
			{
				return double_2;
			}
			set
			{
				double_2 = value;
			}
		}

		public int LevelPlusBlood => LevelMgr.LevelPlusBlood(playerInfo_0.Grade);

		public ItemInfo MainWeapon => itemInfo_0;

		public BatleConfigInfo BatleConfig => batleConfigInfo_0;

		public ItemInfo Healstone
		{
			get
			{
				if (itemInfo_1 == null)
				{
					return null;
				}
				return itemInfo_1;
			}
		}

		public ItemInfo SecondWeapon
		{
			get
			{
				if (itemInfo_2 == null)
				{
					return null;
				}
				return itemInfo_2;
			}
		}

		public string ProcessLabyrinthAward { get; set; }

		public List<int> ViFarms => list_3;

		public Dictionary<int, int> Friends => dictionary_0;

		public GameRoomProcessor GameRoom => gameRoomProcessor_0;

		public AvatarCollectionProcessor AvatarCollection => avatarCollectionProcessor_0;

		public MagicStoneProcessor MagicStoneHandler => magicStoneProcessor_0;

		public NewHallProcessor NewHallHandler => newHallProcessor_0;

		public CollectionTaskProcessor CollectionTaskHandler => collectionTaskProcessor_0;

		public HorseProcessor HorseHandler => horseProcessor_0;

		public RingStationProcessor RingStationHandler => ringStationProcessor_0;

		public FarmProcessor FarmHandler => farmProcessor_0;

		public PetProcessor PetHandler => petProcessor_0;

		public BombKingProcessor BombKingHandler => bombKingProcessor_0;

		public MagicHouseProcessor MagicHouseHandler => magicHouseProcessor_0;

		public DragonBoatProcessor DragonBoatHandler => dragonBoatProcessor_0;

		public ActiveSystemProcessor ActiveSystemHandler => activeSystemProcessor_0;

		public WorshipTheMoonProcessor WorshipTheMoonHandler => worshipTheMoonProcessor_0;

		public MagpieBridgeProcessor MagpieBridgeHandler => magpieBridgeProcessor_0;

		public GypsyShopProcessor GypsyShopHandler => gypsyShopProcessor_0;

		public BaseRoom CurrentRoom
		{
			get
			{
				return baseRoom_0;
			}
			set
			{
				BaseRoom baseRoom = Interlocked.Exchange(ref baseRoom_0, value);
				if (baseRoom != null)
				{
					RoomMgr.ExitRoom(baseRoom, this);
				}
			}
		}

		public BaseHorseRaceRoom CurrentHorseRaceRoom
		{
			get
			{
				return baseHorseRaceRoom_0;
			}
			set
			{
				BaseHorseRaceRoom baseHorseRaceRoom = Interlocked.Exchange(ref baseHorseRaceRoom_0, value);
				if (baseHorseRaceRoom != null)
				{
					RoomMgr.ExitHorseRaceRoom(baseHorseRaceRoom, this);
				}
			}
		}

		public int GamePlayerId { get; set; }

		public long WorldbossBood { get; set; }

		public long AllWorldDameBoss { get; set; }

		public bool HideAllFriend
		{
			get
			{
				return bool_3;
			}
			set
			{
				bool_3 = value;
			}
		}

		public BaseSevenDoubleRoom CurrentSevenDoubleRoom
		{
			get
			{
				return baseSevenDoubleRoom_0;
			}
			set
			{
				baseSevenDoubleRoom_0 = value;
			}
		}

		public MarryRoom CurrentMarryRoom
		{
			get
			{
				return marryRoom_0;
			}
			set
			{
				marryRoom_0 = value;
			}
		}

		public bool IsInMarryRoom => marryRoom_0 != null;

		public int ServerID { get; set; }

		public Dictionary<string, object> TempProperties => dictionary_1;

		public event PlayerEventHandle UseBuffer
		{
			add
			{
				PlayerEventHandle playerEventHandle = playerEventHandle_0;
				PlayerEventHandle playerEventHandle2;
				do
				{
					playerEventHandle2 = playerEventHandle;
					PlayerEventHandle value2 = (PlayerEventHandle)Delegate.Combine(playerEventHandle2, value);
					playerEventHandle = Interlocked.CompareExchange(ref playerEventHandle_0, value2, playerEventHandle2);
				}
				while (playerEventHandle != playerEventHandle2);
			}
			remove
			{
				PlayerEventHandle playerEventHandle = playerEventHandle_0;
				PlayerEventHandle playerEventHandle2;
				do
				{
					playerEventHandle2 = playerEventHandle;
					PlayerEventHandle value2 = (PlayerEventHandle)Delegate.Remove(playerEventHandle2, value);
					playerEventHandle = Interlocked.CompareExchange(ref playerEventHandle_0, value2, playerEventHandle2);
				}
				while (playerEventHandle != playerEventHandle2);
			}
		}

		public event PlayerEventHandle LevelUp
		{
			add
			{
				PlayerEventHandle playerEventHandle = playerEventHandle_1;
				PlayerEventHandle playerEventHandle2;
				do
				{
					playerEventHandle2 = playerEventHandle;
					PlayerEventHandle value2 = (PlayerEventHandle)Delegate.Combine(playerEventHandle2, value);
					playerEventHandle = Interlocked.CompareExchange(ref playerEventHandle_1, value2, playerEventHandle2);
				}
				while (playerEventHandle != playerEventHandle2);
			}
			remove
			{
				PlayerEventHandle playerEventHandle = playerEventHandle_1;
				PlayerEventHandle playerEventHandle2;
				do
				{
					playerEventHandle2 = playerEventHandle;
					PlayerEventHandle value2 = (PlayerEventHandle)Delegate.Remove(playerEventHandle2, value);
					playerEventHandle = Interlocked.CompareExchange(ref playerEventHandle_1, value2, playerEventHandle2);
				}
				while (playerEventHandle != playerEventHandle2);
			}
		}

		public event PlayerItemPropertyEventHandle AfterUsingItem
		{
			add
			{
				PlayerItemPropertyEventHandle playerItemPropertyEventHandle = playerItemPropertyEventHandle_0;
				PlayerItemPropertyEventHandle playerItemPropertyEventHandle2;
				do
				{
					playerItemPropertyEventHandle2 = playerItemPropertyEventHandle;
					PlayerItemPropertyEventHandle value2 = (PlayerItemPropertyEventHandle)Delegate.Combine(playerItemPropertyEventHandle2, value);
					playerItemPropertyEventHandle = Interlocked.CompareExchange(ref playerItemPropertyEventHandle_0, value2, playerItemPropertyEventHandle2);
				}
				while (playerItemPropertyEventHandle != playerItemPropertyEventHandle2);
			}
			remove
			{
				PlayerItemPropertyEventHandle playerItemPropertyEventHandle = playerItemPropertyEventHandle_0;
				PlayerItemPropertyEventHandle playerItemPropertyEventHandle2;
				do
				{
					playerItemPropertyEventHandle2 = playerItemPropertyEventHandle;
					PlayerItemPropertyEventHandle value2 = (PlayerItemPropertyEventHandle)Delegate.Remove(playerItemPropertyEventHandle2, value);
					playerItemPropertyEventHandle = Interlocked.CompareExchange(ref playerItemPropertyEventHandle_0, value2, playerItemPropertyEventHandle2);
				}
				while (playerItemPropertyEventHandle != playerItemPropertyEventHandle2);
			}
		}

		public event PlayerGameOverEventHandle GameOver
		{
			add
			{
				PlayerGameOverEventHandle playerGameOverEventHandle = playerGameOverEventHandle_0;
				PlayerGameOverEventHandle playerGameOverEventHandle2;
				do
				{
					playerGameOverEventHandle2 = playerGameOverEventHandle;
					PlayerGameOverEventHandle value2 = (PlayerGameOverEventHandle)Delegate.Combine(playerGameOverEventHandle2, value);
					playerGameOverEventHandle = Interlocked.CompareExchange(ref playerGameOverEventHandle_0, value2, playerGameOverEventHandle2);
				}
				while (playerGameOverEventHandle != playerGameOverEventHandle2);
			}
			remove
			{
				PlayerGameOverEventHandle playerGameOverEventHandle = playerGameOverEventHandle_0;
				PlayerGameOverEventHandle playerGameOverEventHandle2;
				do
				{
					playerGameOverEventHandle2 = playerGameOverEventHandle;
					PlayerGameOverEventHandle value2 = (PlayerGameOverEventHandle)Delegate.Remove(playerGameOverEventHandle2, value);
					playerGameOverEventHandle = Interlocked.CompareExchange(ref playerGameOverEventHandle_0, value2, playerGameOverEventHandle2);
				}
				while (playerGameOverEventHandle != playerGameOverEventHandle2);
			}
		}

		public event PlayerMissionOverEventHandle MissionOver
		{
			add
			{
				PlayerMissionOverEventHandle playerMissionOverEventHandle = playerMissionOverEventHandle_0;
				PlayerMissionOverEventHandle playerMissionOverEventHandle2;
				do
				{
					playerMissionOverEventHandle2 = playerMissionOverEventHandle;
					PlayerMissionOverEventHandle value2 = (PlayerMissionOverEventHandle)Delegate.Combine(playerMissionOverEventHandle2, value);
					playerMissionOverEventHandle = Interlocked.CompareExchange(ref playerMissionOverEventHandle_0, value2, playerMissionOverEventHandle2);
				}
				while (playerMissionOverEventHandle != playerMissionOverEventHandle2);
			}
			remove
			{
				PlayerMissionOverEventHandle playerMissionOverEventHandle = playerMissionOverEventHandle_0;
				PlayerMissionOverEventHandle playerMissionOverEventHandle2;
				do
				{
					playerMissionOverEventHandle2 = playerMissionOverEventHandle;
					PlayerMissionOverEventHandle value2 = (PlayerMissionOverEventHandle)Delegate.Remove(playerMissionOverEventHandle2, value);
					playerMissionOverEventHandle = Interlocked.CompareExchange(ref playerMissionOverEventHandle_0, value2, playerMissionOverEventHandle2);
				}
				while (playerMissionOverEventHandle != playerMissionOverEventHandle2);
			}
		}

		public event PlayerMissionFullOverEventHandle MissionFullOver
		{
			add
			{
				PlayerMissionFullOverEventHandle playerMissionFullOverEventHandle = playerMissionFullOverEventHandle_0;
				PlayerMissionFullOverEventHandle playerMissionFullOverEventHandle2;
				do
				{
					playerMissionFullOverEventHandle2 = playerMissionFullOverEventHandle;
					PlayerMissionFullOverEventHandle value2 = (PlayerMissionFullOverEventHandle)Delegate.Combine(playerMissionFullOverEventHandle2, value);
					playerMissionFullOverEventHandle = Interlocked.CompareExchange(ref playerMissionFullOverEventHandle_0, value2, playerMissionFullOverEventHandle2);
				}
				while (playerMissionFullOverEventHandle != playerMissionFullOverEventHandle2);
			}
			remove
			{
				PlayerMissionFullOverEventHandle playerMissionFullOverEventHandle = playerMissionFullOverEventHandle_0;
				PlayerMissionFullOverEventHandle playerMissionFullOverEventHandle2;
				do
				{
					playerMissionFullOverEventHandle2 = playerMissionFullOverEventHandle;
					PlayerMissionFullOverEventHandle value2 = (PlayerMissionFullOverEventHandle)Delegate.Remove(playerMissionFullOverEventHandle2, value);
					playerMissionFullOverEventHandle = Interlocked.CompareExchange(ref playerMissionFullOverEventHandle_0, value2, playerMissionFullOverEventHandle2);
				}
				while (playerMissionFullOverEventHandle != playerMissionFullOverEventHandle2);
			}
		}

		public event PlayerMissionTurnOverEventHandle MissionTurnOver
		{
			add
			{
				PlayerMissionTurnOverEventHandle playerMissionTurnOverEventHandle = playerMissionTurnOverEventHandle_0;
				PlayerMissionTurnOverEventHandle playerMissionTurnOverEventHandle2;
				do
				{
					playerMissionTurnOverEventHandle2 = playerMissionTurnOverEventHandle;
					PlayerMissionTurnOverEventHandle value2 = (PlayerMissionTurnOverEventHandle)Delegate.Combine(playerMissionTurnOverEventHandle2, value);
					playerMissionTurnOverEventHandle = Interlocked.CompareExchange(ref playerMissionTurnOverEventHandle_0, value2, playerMissionTurnOverEventHandle2);
				}
				while (playerMissionTurnOverEventHandle != playerMissionTurnOverEventHandle2);
			}
			remove
			{
				PlayerMissionTurnOverEventHandle playerMissionTurnOverEventHandle = playerMissionTurnOverEventHandle_0;
				PlayerMissionTurnOverEventHandle playerMissionTurnOverEventHandle2;
				do
				{
					playerMissionTurnOverEventHandle2 = playerMissionTurnOverEventHandle;
					PlayerMissionTurnOverEventHandle value2 = (PlayerMissionTurnOverEventHandle)Delegate.Remove(playerMissionTurnOverEventHandle2, value);
					playerMissionTurnOverEventHandle = Interlocked.CompareExchange(ref playerMissionTurnOverEventHandle_0, value2, playerMissionTurnOverEventHandle2);
				}
				while (playerMissionTurnOverEventHandle != playerMissionTurnOverEventHandle2);
			}
		}

		public event PlayerQuestOneKeyFinishEventHandle QuestOneKeyFinish
		{
			add
			{
				PlayerQuestOneKeyFinishEventHandle playerQuestOneKeyFinishEventHandle = playerQuestOneKeyFinishEventHandle_0;
				PlayerQuestOneKeyFinishEventHandle playerQuestOneKeyFinishEventHandle2;
				do
				{
					playerQuestOneKeyFinishEventHandle2 = playerQuestOneKeyFinishEventHandle;
					PlayerQuestOneKeyFinishEventHandle value2 = (PlayerQuestOneKeyFinishEventHandle)Delegate.Combine(playerQuestOneKeyFinishEventHandle2, value);
					playerQuestOneKeyFinishEventHandle = Interlocked.CompareExchange(ref playerQuestOneKeyFinishEventHandle_0, value2, playerQuestOneKeyFinishEventHandle2);
				}
				while (playerQuestOneKeyFinishEventHandle != playerQuestOneKeyFinishEventHandle2);
			}
			remove
			{
				PlayerQuestOneKeyFinishEventHandle playerQuestOneKeyFinishEventHandle = playerQuestOneKeyFinishEventHandle_0;
				PlayerQuestOneKeyFinishEventHandle playerQuestOneKeyFinishEventHandle2;
				do
				{
					playerQuestOneKeyFinishEventHandle2 = playerQuestOneKeyFinishEventHandle;
					PlayerQuestOneKeyFinishEventHandle value2 = (PlayerQuestOneKeyFinishEventHandle)Delegate.Remove(playerQuestOneKeyFinishEventHandle2, value);
					playerQuestOneKeyFinishEventHandle = Interlocked.CompareExchange(ref playerQuestOneKeyFinishEventHandle_0, value2, playerQuestOneKeyFinishEventHandle2);
				}
				while (playerQuestOneKeyFinishEventHandle != playerQuestOneKeyFinishEventHandle2);
			}
		}

		public event PlayerItemStrengthenEventHandle ItemStrengthen
		{
			add
			{
				PlayerItemStrengthenEventHandle playerItemStrengthenEventHandle = playerItemStrengthenEventHandle_0;
				PlayerItemStrengthenEventHandle playerItemStrengthenEventHandle2;
				do
				{
					playerItemStrengthenEventHandle2 = playerItemStrengthenEventHandle;
					PlayerItemStrengthenEventHandle value2 = (PlayerItemStrengthenEventHandle)Delegate.Combine(playerItemStrengthenEventHandle2, value);
					playerItemStrengthenEventHandle = Interlocked.CompareExchange(ref playerItemStrengthenEventHandle_0, value2, playerItemStrengthenEventHandle2);
				}
				while (playerItemStrengthenEventHandle != playerItemStrengthenEventHandle2);
			}
			remove
			{
				PlayerItemStrengthenEventHandle playerItemStrengthenEventHandle = playerItemStrengthenEventHandle_0;
				PlayerItemStrengthenEventHandle playerItemStrengthenEventHandle2;
				do
				{
					playerItemStrengthenEventHandle2 = playerItemStrengthenEventHandle;
					PlayerItemStrengthenEventHandle value2 = (PlayerItemStrengthenEventHandle)Delegate.Remove(playerItemStrengthenEventHandle2, value);
					playerItemStrengthenEventHandle = Interlocked.CompareExchange(ref playerItemStrengthenEventHandle_0, value2, playerItemStrengthenEventHandle2);
				}
				while (playerItemStrengthenEventHandle != playerItemStrengthenEventHandle2);
			}
		}

		public event PlayerShopEventHandle Paid
		{
			add
			{
				PlayerShopEventHandle playerShopEventHandle = playerShopEventHandle_0;
				PlayerShopEventHandle playerShopEventHandle2;
				do
				{
					playerShopEventHandle2 = playerShopEventHandle;
					PlayerShopEventHandle value2 = (PlayerShopEventHandle)Delegate.Combine(playerShopEventHandle2, value);
					playerShopEventHandle = Interlocked.CompareExchange(ref playerShopEventHandle_0, value2, playerShopEventHandle2);
				}
				while (playerShopEventHandle != playerShopEventHandle2);
			}
			remove
			{
				PlayerShopEventHandle playerShopEventHandle = playerShopEventHandle_0;
				PlayerShopEventHandle playerShopEventHandle2;
				do
				{
					playerShopEventHandle2 = playerShopEventHandle;
					PlayerShopEventHandle value2 = (PlayerShopEventHandle)Delegate.Remove(playerShopEventHandle2, value);
					playerShopEventHandle = Interlocked.CompareExchange(ref playerShopEventHandle_0, value2, playerShopEventHandle2);
				}
				while (playerShopEventHandle != playerShopEventHandle2);
			}
		}

		public event PlayerAdoptPetEventHandle AdoptPetEvent
		{
			add
			{
				PlayerAdoptPetEventHandle playerAdoptPetEventHandle = playerAdoptPetEventHandle_0;
				PlayerAdoptPetEventHandle playerAdoptPetEventHandle2;
				do
				{
					playerAdoptPetEventHandle2 = playerAdoptPetEventHandle;
					PlayerAdoptPetEventHandle value2 = (PlayerAdoptPetEventHandle)Delegate.Combine(playerAdoptPetEventHandle2, value);
					playerAdoptPetEventHandle = Interlocked.CompareExchange(ref playerAdoptPetEventHandle_0, value2, playerAdoptPetEventHandle2);
				}
				while (playerAdoptPetEventHandle != playerAdoptPetEventHandle2);
			}
			remove
			{
				PlayerAdoptPetEventHandle playerAdoptPetEventHandle = playerAdoptPetEventHandle_0;
				PlayerAdoptPetEventHandle playerAdoptPetEventHandle2;
				do
				{
					playerAdoptPetEventHandle2 = playerAdoptPetEventHandle;
					PlayerAdoptPetEventHandle value2 = (PlayerAdoptPetEventHandle)Delegate.Remove(playerAdoptPetEventHandle2, value);
					playerAdoptPetEventHandle = Interlocked.CompareExchange(ref playerAdoptPetEventHandle_0, value2, playerAdoptPetEventHandle2);
				}
				while (playerAdoptPetEventHandle != playerAdoptPetEventHandle2);
			}
		}

		public event PlayerNewGearEventHandle NewGearEvent
		{
			add
			{
				PlayerNewGearEventHandle playerNewGearEventHandle = playerNewGearEventHandle_0;
				PlayerNewGearEventHandle playerNewGearEventHandle2;
				do
				{
					playerNewGearEventHandle2 = playerNewGearEventHandle;
					PlayerNewGearEventHandle value2 = (PlayerNewGearEventHandle)Delegate.Combine(playerNewGearEventHandle2, value);
					playerNewGearEventHandle = Interlocked.CompareExchange(ref playerNewGearEventHandle_0, value2, playerNewGearEventHandle2);
				}
				while (playerNewGearEventHandle != playerNewGearEventHandle2);
			}
			remove
			{
				PlayerNewGearEventHandle playerNewGearEventHandle = playerNewGearEventHandle_0;
				PlayerNewGearEventHandle playerNewGearEventHandle2;
				do
				{
					playerNewGearEventHandle2 = playerNewGearEventHandle;
					PlayerNewGearEventHandle value2 = (PlayerNewGearEventHandle)Delegate.Remove(playerNewGearEventHandle2, value);
					playerNewGearEventHandle = Interlocked.CompareExchange(ref playerNewGearEventHandle_0, value2, playerNewGearEventHandle2);
				}
				while (playerNewGearEventHandle != playerNewGearEventHandle2);
			}
		}

		public event PlayerCropPrimaryEventHandle CropPrimaryEvent
		{
			add
			{
				PlayerCropPrimaryEventHandle playerCropPrimaryEventHandle = playerCropPrimaryEventHandle_0;
				PlayerCropPrimaryEventHandle playerCropPrimaryEventHandle2;
				do
				{
					playerCropPrimaryEventHandle2 = playerCropPrimaryEventHandle;
					PlayerCropPrimaryEventHandle value2 = (PlayerCropPrimaryEventHandle)Delegate.Combine(playerCropPrimaryEventHandle2, value);
					playerCropPrimaryEventHandle = Interlocked.CompareExchange(ref playerCropPrimaryEventHandle_0, value2, playerCropPrimaryEventHandle2);
				}
				while (playerCropPrimaryEventHandle != playerCropPrimaryEventHandle2);
			}
			remove
			{
				PlayerCropPrimaryEventHandle playerCropPrimaryEventHandle = playerCropPrimaryEventHandle_0;
				PlayerCropPrimaryEventHandle playerCropPrimaryEventHandle2;
				do
				{
					playerCropPrimaryEventHandle2 = playerCropPrimaryEventHandle;
					PlayerCropPrimaryEventHandle value2 = (PlayerCropPrimaryEventHandle)Delegate.Remove(playerCropPrimaryEventHandle2, value);
					playerCropPrimaryEventHandle = Interlocked.CompareExchange(ref playerCropPrimaryEventHandle_0, value2, playerCropPrimaryEventHandle2);
				}
				while (playerCropPrimaryEventHandle != playerCropPrimaryEventHandle2);
			}
		}

		public event PlayerSeedFoodPetEventHandle SeedFoodPetEvent
		{
			add
			{
				PlayerSeedFoodPetEventHandle playerSeedFoodPetEventHandle = playerSeedFoodPetEventHandle_0;
				PlayerSeedFoodPetEventHandle playerSeedFoodPetEventHandle2;
				do
				{
					playerSeedFoodPetEventHandle2 = playerSeedFoodPetEventHandle;
					PlayerSeedFoodPetEventHandle value2 = (PlayerSeedFoodPetEventHandle)Delegate.Combine(playerSeedFoodPetEventHandle2, value);
					playerSeedFoodPetEventHandle = Interlocked.CompareExchange(ref playerSeedFoodPetEventHandle_0, value2, playerSeedFoodPetEventHandle2);
				}
				while (playerSeedFoodPetEventHandle != playerSeedFoodPetEventHandle2);
			}
			remove
			{
				PlayerSeedFoodPetEventHandle playerSeedFoodPetEventHandle = playerSeedFoodPetEventHandle_0;
				PlayerSeedFoodPetEventHandle playerSeedFoodPetEventHandle2;
				do
				{
					playerSeedFoodPetEventHandle2 = playerSeedFoodPetEventHandle;
					PlayerSeedFoodPetEventHandle value2 = (PlayerSeedFoodPetEventHandle)Delegate.Remove(playerSeedFoodPetEventHandle2, value);
					playerSeedFoodPetEventHandle = Interlocked.CompareExchange(ref playerSeedFoodPetEventHandle_0, value2, playerSeedFoodPetEventHandle2);
				}
				while (playerSeedFoodPetEventHandle != playerSeedFoodPetEventHandle2);
			}
		}

		public event PlayerUserToemGemstoneEventHandle UserToemGemstonetEvent
		{
			add
			{
				PlayerUserToemGemstoneEventHandle playerUserToemGemstoneEventHandle = playerUserToemGemstoneEventHandle_0;
				PlayerUserToemGemstoneEventHandle playerUserToemGemstoneEventHandle2;
				do
				{
					playerUserToemGemstoneEventHandle2 = playerUserToemGemstoneEventHandle;
					PlayerUserToemGemstoneEventHandle value2 = (PlayerUserToemGemstoneEventHandle)Delegate.Combine(playerUserToemGemstoneEventHandle2, value);
					playerUserToemGemstoneEventHandle = Interlocked.CompareExchange(ref playerUserToemGemstoneEventHandle_0, value2, playerUserToemGemstoneEventHandle2);
				}
				while (playerUserToemGemstoneEventHandle != playerUserToemGemstoneEventHandle2);
			}
			remove
			{
				PlayerUserToemGemstoneEventHandle playerUserToemGemstoneEventHandle = playerUserToemGemstoneEventHandle_0;
				PlayerUserToemGemstoneEventHandle playerUserToemGemstoneEventHandle2;
				do
				{
					playerUserToemGemstoneEventHandle2 = playerUserToemGemstoneEventHandle;
					PlayerUserToemGemstoneEventHandle value2 = (PlayerUserToemGemstoneEventHandle)Delegate.Remove(playerUserToemGemstoneEventHandle2, value);
					playerUserToemGemstoneEventHandle = Interlocked.CompareExchange(ref playerUserToemGemstoneEventHandle_0, value2, playerUserToemGemstoneEventHandle2);
				}
				while (playerUserToemGemstoneEventHandle != playerUserToemGemstoneEventHandle2);
			}
		}

		public event PlayerCollectionTaskEventHandle CollectionTaskEvent
		{
			add
			{
				PlayerCollectionTaskEventHandle playerCollectionTaskEventHandle = playerCollectionTaskEventHandle_0;
				PlayerCollectionTaskEventHandle playerCollectionTaskEventHandle2;
				do
				{
					playerCollectionTaskEventHandle2 = playerCollectionTaskEventHandle;
					PlayerCollectionTaskEventHandle value2 = (PlayerCollectionTaskEventHandle)Delegate.Combine(playerCollectionTaskEventHandle2, value);
					playerCollectionTaskEventHandle = Interlocked.CompareExchange(ref playerCollectionTaskEventHandle_0, value2, playerCollectionTaskEventHandle2);
				}
				while (playerCollectionTaskEventHandle != playerCollectionTaskEventHandle2);
			}
			remove
			{
				PlayerCollectionTaskEventHandle playerCollectionTaskEventHandle = playerCollectionTaskEventHandle_0;
				PlayerCollectionTaskEventHandle playerCollectionTaskEventHandle2;
				do
				{
					playerCollectionTaskEventHandle2 = playerCollectionTaskEventHandle;
					PlayerCollectionTaskEventHandle value2 = (PlayerCollectionTaskEventHandle)Delegate.Remove(playerCollectionTaskEventHandle2, value);
					playerCollectionTaskEventHandle = Interlocked.CompareExchange(ref playerCollectionTaskEventHandle_0, value2, playerCollectionTaskEventHandle2);
				}
				while (playerCollectionTaskEventHandle != playerCollectionTaskEventHandle2);
			}
		}

		public event PlayerUpLevelPetEventHandle UpLevelPetEvent
		{
			add
			{
				PlayerUpLevelPetEventHandle playerUpLevelPetEventHandle = playerUpLevelPetEventHandle_0;
				PlayerUpLevelPetEventHandle playerUpLevelPetEventHandle2;
				do
				{
					playerUpLevelPetEventHandle2 = playerUpLevelPetEventHandle;
					PlayerUpLevelPetEventHandle value2 = (PlayerUpLevelPetEventHandle)Delegate.Combine(playerUpLevelPetEventHandle2, value);
					playerUpLevelPetEventHandle = Interlocked.CompareExchange(ref playerUpLevelPetEventHandle_0, value2, playerUpLevelPetEventHandle2);
				}
				while (playerUpLevelPetEventHandle != playerUpLevelPetEventHandle2);
			}
			remove
			{
				PlayerUpLevelPetEventHandle playerUpLevelPetEventHandle = playerUpLevelPetEventHandle_0;
				PlayerUpLevelPetEventHandle playerUpLevelPetEventHandle2;
				do
				{
					playerUpLevelPetEventHandle2 = playerUpLevelPetEventHandle;
					PlayerUpLevelPetEventHandle value2 = (PlayerUpLevelPetEventHandle)Delegate.Remove(playerUpLevelPetEventHandle2, value);
					playerUpLevelPetEventHandle = Interlocked.CompareExchange(ref playerUpLevelPetEventHandle_0, value2, playerUpLevelPetEventHandle2);
				}
				while (playerUpLevelPetEventHandle != playerUpLevelPetEventHandle2);
			}
		}

		public event PlayerItemInsertEventHandle ItemInsert
		{
			add
			{
				PlayerItemInsertEventHandle playerItemInsertEventHandle = playerItemInsertEventHandle_0;
				PlayerItemInsertEventHandle playerItemInsertEventHandle2;
				do
				{
					playerItemInsertEventHandle2 = playerItemInsertEventHandle;
					PlayerItemInsertEventHandle value2 = (PlayerItemInsertEventHandle)Delegate.Combine(playerItemInsertEventHandle2, value);
					playerItemInsertEventHandle = Interlocked.CompareExchange(ref playerItemInsertEventHandle_0, value2, playerItemInsertEventHandle2);
				}
				while (playerItemInsertEventHandle != playerItemInsertEventHandle2);
			}
			remove
			{
				PlayerItemInsertEventHandle playerItemInsertEventHandle = playerItemInsertEventHandle_0;
				PlayerItemInsertEventHandle playerItemInsertEventHandle2;
				do
				{
					playerItemInsertEventHandle2 = playerItemInsertEventHandle;
					PlayerItemInsertEventHandle value2 = (PlayerItemInsertEventHandle)Delegate.Remove(playerItemInsertEventHandle2, value);
					playerItemInsertEventHandle = Interlocked.CompareExchange(ref playerItemInsertEventHandle_0, value2, playerItemInsertEventHandle2);
				}
				while (playerItemInsertEventHandle != playerItemInsertEventHandle2);
			}
		}

		public event PlayerItemFusionEventHandle ItemFusion
		{
			add
			{
				PlayerItemFusionEventHandle playerItemFusionEventHandle = playerItemFusionEventHandle_0;
				PlayerItemFusionEventHandle playerItemFusionEventHandle2;
				do
				{
					playerItemFusionEventHandle2 = playerItemFusionEventHandle;
					PlayerItemFusionEventHandle value2 = (PlayerItemFusionEventHandle)Delegate.Combine(playerItemFusionEventHandle2, value);
					playerItemFusionEventHandle = Interlocked.CompareExchange(ref playerItemFusionEventHandle_0, value2, playerItemFusionEventHandle2);
				}
				while (playerItemFusionEventHandle != playerItemFusionEventHandle2);
			}
			remove
			{
				PlayerItemFusionEventHandle playerItemFusionEventHandle = playerItemFusionEventHandle_0;
				PlayerItemFusionEventHandle playerItemFusionEventHandle2;
				do
				{
					playerItemFusionEventHandle2 = playerItemFusionEventHandle;
					PlayerItemFusionEventHandle value2 = (PlayerItemFusionEventHandle)Delegate.Remove(playerItemFusionEventHandle2, value);
					playerItemFusionEventHandle = Interlocked.CompareExchange(ref playerItemFusionEventHandle_0, value2, playerItemFusionEventHandle2);
				}
				while (playerItemFusionEventHandle != playerItemFusionEventHandle2);
			}
		}

		public event PlayerItemMeltEventHandle ItemMelt
		{
			add
			{
				PlayerItemMeltEventHandle playerItemMeltEventHandle = playerItemMeltEventHandle_0;
				PlayerItemMeltEventHandle playerItemMeltEventHandle2;
				do
				{
					playerItemMeltEventHandle2 = playerItemMeltEventHandle;
					PlayerItemMeltEventHandle value2 = (PlayerItemMeltEventHandle)Delegate.Combine(playerItemMeltEventHandle2, value);
					playerItemMeltEventHandle = Interlocked.CompareExchange(ref playerItemMeltEventHandle_0, value2, playerItemMeltEventHandle2);
				}
				while (playerItemMeltEventHandle != playerItemMeltEventHandle2);
			}
			remove
			{
				PlayerItemMeltEventHandle playerItemMeltEventHandle = playerItemMeltEventHandle_0;
				PlayerItemMeltEventHandle playerItemMeltEventHandle2;
				do
				{
					playerItemMeltEventHandle2 = playerItemMeltEventHandle;
					PlayerItemMeltEventHandle value2 = (PlayerItemMeltEventHandle)Delegate.Remove(playerItemMeltEventHandle2, value);
					playerItemMeltEventHandle = Interlocked.CompareExchange(ref playerItemMeltEventHandle_0, value2, playerItemMeltEventHandle2);
				}
				while (playerItemMeltEventHandle != playerItemMeltEventHandle2);
			}
		}

		public event PlayerGameKillEventHandel AfterKillingLiving
		{
			add
			{
				PlayerGameKillEventHandel playerGameKillEventHandel = playerGameKillEventHandel_0;
				PlayerGameKillEventHandel playerGameKillEventHandel2;
				do
				{
					playerGameKillEventHandel2 = playerGameKillEventHandel;
					PlayerGameKillEventHandel value2 = (PlayerGameKillEventHandel)Delegate.Combine(playerGameKillEventHandel2, value);
					playerGameKillEventHandel = Interlocked.CompareExchange(ref playerGameKillEventHandel_0, value2, playerGameKillEventHandel2);
				}
				while (playerGameKillEventHandel != playerGameKillEventHandel2);
			}
			remove
			{
				PlayerGameKillEventHandel playerGameKillEventHandel = playerGameKillEventHandel_0;
				PlayerGameKillEventHandel playerGameKillEventHandel2;
				do
				{
					playerGameKillEventHandel2 = playerGameKillEventHandel;
					PlayerGameKillEventHandel value2 = (PlayerGameKillEventHandel)Delegate.Remove(playerGameKillEventHandel2, value);
					playerGameKillEventHandel = Interlocked.CompareExchange(ref playerGameKillEventHandel_0, value2, playerGameKillEventHandel2);
				}
				while (playerGameKillEventHandel != playerGameKillEventHandel2);
			}
		}

		public event PlayerOwnConsortiaEventHandle GuildChanged
		{
			add
			{
				PlayerOwnConsortiaEventHandle playerOwnConsortiaEventHandle = playerOwnConsortiaEventHandle_0;
				PlayerOwnConsortiaEventHandle playerOwnConsortiaEventHandle2;
				do
				{
					playerOwnConsortiaEventHandle2 = playerOwnConsortiaEventHandle;
					PlayerOwnConsortiaEventHandle value2 = (PlayerOwnConsortiaEventHandle)Delegate.Combine(playerOwnConsortiaEventHandle2, value);
					playerOwnConsortiaEventHandle = Interlocked.CompareExchange(ref playerOwnConsortiaEventHandle_0, value2, playerOwnConsortiaEventHandle2);
				}
				while (playerOwnConsortiaEventHandle != playerOwnConsortiaEventHandle2);
			}
			remove
			{
				PlayerOwnConsortiaEventHandle playerOwnConsortiaEventHandle = playerOwnConsortiaEventHandle_0;
				PlayerOwnConsortiaEventHandle playerOwnConsortiaEventHandle2;
				do
				{
					playerOwnConsortiaEventHandle2 = playerOwnConsortiaEventHandle;
					PlayerOwnConsortiaEventHandle value2 = (PlayerOwnConsortiaEventHandle)Delegate.Remove(playerOwnConsortiaEventHandle2, value);
					playerOwnConsortiaEventHandle = Interlocked.CompareExchange(ref playerOwnConsortiaEventHandle_0, value2, playerOwnConsortiaEventHandle2);
				}
				while (playerOwnConsortiaEventHandle != playerOwnConsortiaEventHandle2);
			}
		}

		public event PlayerItemComposeEventHandle ItemCompose
		{
			add
			{
				PlayerItemComposeEventHandle playerItemComposeEventHandle = playerItemComposeEventHandle_0;
				PlayerItemComposeEventHandle playerItemComposeEventHandle2;
				do
				{
					playerItemComposeEventHandle2 = playerItemComposeEventHandle;
					PlayerItemComposeEventHandle value2 = (PlayerItemComposeEventHandle)Delegate.Combine(playerItemComposeEventHandle2, value);
					playerItemComposeEventHandle = Interlocked.CompareExchange(ref playerItemComposeEventHandle_0, value2, playerItemComposeEventHandle2);
				}
				while (playerItemComposeEventHandle != playerItemComposeEventHandle2);
			}
			remove
			{
				PlayerItemComposeEventHandle playerItemComposeEventHandle = playerItemComposeEventHandle_0;
				PlayerItemComposeEventHandle playerItemComposeEventHandle2;
				do
				{
					playerItemComposeEventHandle2 = playerItemComposeEventHandle;
					PlayerItemComposeEventHandle value2 = (PlayerItemComposeEventHandle)Delegate.Remove(playerItemComposeEventHandle2, value);
					playerItemComposeEventHandle = Interlocked.CompareExchange(ref playerItemComposeEventHandle_0, value2, playerItemComposeEventHandle2);
				}
				while (playerItemComposeEventHandle != playerItemComposeEventHandle2);
			}
		}

		public event PlayerAchievementFinish AchievementFinishEvent
		{
			add
			{
				PlayerAchievementFinish playerAchievementFinish = playerAchievementFinish_0;
				PlayerAchievementFinish playerAchievementFinish2;
				do
				{
					playerAchievementFinish2 = playerAchievementFinish;
					PlayerAchievementFinish value2 = (PlayerAchievementFinish)Delegate.Combine(playerAchievementFinish2, value);
					playerAchievementFinish = Interlocked.CompareExchange(ref playerAchievementFinish_0, value2, playerAchievementFinish2);
				}
				while (playerAchievementFinish != playerAchievementFinish2);
			}
			remove
			{
				PlayerAchievementFinish playerAchievementFinish = playerAchievementFinish_0;
				PlayerAchievementFinish playerAchievementFinish2;
				do
				{
					playerAchievementFinish2 = playerAchievementFinish;
					PlayerAchievementFinish value2 = (PlayerAchievementFinish)Delegate.Remove(playerAchievementFinish2, value);
					playerAchievementFinish = Interlocked.CompareExchange(ref playerAchievementFinish_0, value2, playerAchievementFinish2);
				}
				while (playerAchievementFinish != playerAchievementFinish2);
			}
		}

		public event PlayerFightAddOffer FightAddOfferEvent
		{
			add
			{
				PlayerFightAddOffer playerFightAddOffer = MlcxAudlJc;
				PlayerFightAddOffer playerFightAddOffer2;
				do
				{
					playerFightAddOffer2 = playerFightAddOffer;
					PlayerFightAddOffer value2 = (PlayerFightAddOffer)Delegate.Combine(playerFightAddOffer2, value);
					playerFightAddOffer = Interlocked.CompareExchange(ref MlcxAudlJc, value2, playerFightAddOffer2);
				}
				while (playerFightAddOffer != playerFightAddOffer2);
			}
			remove
			{
				PlayerFightAddOffer playerFightAddOffer = MlcxAudlJc;
				PlayerFightAddOffer playerFightAddOffer2;
				do
				{
					playerFightAddOffer2 = playerFightAddOffer;
					PlayerFightAddOffer value2 = (PlayerFightAddOffer)Delegate.Remove(playerFightAddOffer2, value);
					playerFightAddOffer = Interlocked.CompareExchange(ref MlcxAudlJc, value2, playerFightAddOffer2);
				}
				while (playerFightAddOffer != playerFightAddOffer2);
			}
		}

		public event PlayerFightOneBloodIsWin FightOneBloodIsWin
		{
			add
			{
				PlayerFightOneBloodIsWin playerFightOneBloodIsWin = playerFightOneBloodIsWin_0;
				PlayerFightOneBloodIsWin playerFightOneBloodIsWin2;
				do
				{
					playerFightOneBloodIsWin2 = playerFightOneBloodIsWin;
					PlayerFightOneBloodIsWin value2 = (PlayerFightOneBloodIsWin)Delegate.Combine(playerFightOneBloodIsWin2, value);
					playerFightOneBloodIsWin = Interlocked.CompareExchange(ref playerFightOneBloodIsWin_0, value2, playerFightOneBloodIsWin2);
				}
				while (playerFightOneBloodIsWin != playerFightOneBloodIsWin2);
			}
			remove
			{
				PlayerFightOneBloodIsWin playerFightOneBloodIsWin = playerFightOneBloodIsWin_0;
				PlayerFightOneBloodIsWin playerFightOneBloodIsWin2;
				do
				{
					playerFightOneBloodIsWin2 = playerFightOneBloodIsWin;
					PlayerFightOneBloodIsWin value2 = (PlayerFightOneBloodIsWin)Delegate.Remove(playerFightOneBloodIsWin2, value);
					playerFightOneBloodIsWin = Interlocked.CompareExchange(ref playerFightOneBloodIsWin_0, value2, playerFightOneBloodIsWin2);
				}
				while (playerFightOneBloodIsWin != playerFightOneBloodIsWin2);
			}
		}

		public event PlayerVIPUpgrade Event_0
		{
			add
			{
				PlayerVIPUpgrade playerVIPUpgrade = ceKxNurgYN;
				PlayerVIPUpgrade playerVIPUpgrade2;
				do
				{
					playerVIPUpgrade2 = playerVIPUpgrade;
					PlayerVIPUpgrade value2 = (PlayerVIPUpgrade)Delegate.Combine(playerVIPUpgrade2, value);
					playerVIPUpgrade = Interlocked.CompareExchange(ref ceKxNurgYN, value2, playerVIPUpgrade2);
				}
				while (playerVIPUpgrade != playerVIPUpgrade2);
			}
			remove
			{
				PlayerVIPUpgrade playerVIPUpgrade = ceKxNurgYN;
				PlayerVIPUpgrade playerVIPUpgrade2;
				do
				{
					playerVIPUpgrade2 = playerVIPUpgrade;
					PlayerVIPUpgrade value2 = (PlayerVIPUpgrade)Delegate.Remove(playerVIPUpgrade2, value);
					playerVIPUpgrade = Interlocked.CompareExchange(ref ceKxNurgYN, value2, playerVIPUpgrade2);
				}
				while (playerVIPUpgrade != playerVIPUpgrade2);
			}
		}

		public event PlayerHotSpingExpAdd HotSpingExpAdd
		{
			add
			{
				PlayerHotSpingExpAdd playerHotSpingExpAdd = playerHotSpingExpAdd_0;
				PlayerHotSpingExpAdd playerHotSpingExpAdd2;
				do
				{
					playerHotSpingExpAdd2 = playerHotSpingExpAdd;
					PlayerHotSpingExpAdd value2 = (PlayerHotSpingExpAdd)Delegate.Combine(playerHotSpingExpAdd2, value);
					playerHotSpingExpAdd = Interlocked.CompareExchange(ref playerHotSpingExpAdd_0, value2, playerHotSpingExpAdd2);
				}
				while (playerHotSpingExpAdd != playerHotSpingExpAdd2);
			}
			remove
			{
				PlayerHotSpingExpAdd playerHotSpingExpAdd = playerHotSpingExpAdd_0;
				PlayerHotSpingExpAdd playerHotSpingExpAdd2;
				do
				{
					playerHotSpingExpAdd2 = playerHotSpingExpAdd;
					PlayerHotSpingExpAdd value2 = (PlayerHotSpingExpAdd)Delegate.Remove(playerHotSpingExpAdd2, value);
					playerHotSpingExpAdd = Interlocked.CompareExchange(ref playerHotSpingExpAdd_0, value2, playerHotSpingExpAdd2);
				}
				while (playerHotSpingExpAdd != playerHotSpingExpAdd2);
			}
		}

		public event PlayerGoldCollection GoldCollect
		{
			add
			{
				PlayerGoldCollection playerGoldCollection = playerGoldCollection_0;
				PlayerGoldCollection playerGoldCollection2;
				do
				{
					playerGoldCollection2 = playerGoldCollection;
					PlayerGoldCollection value2 = (PlayerGoldCollection)Delegate.Combine(playerGoldCollection2, value);
					playerGoldCollection = Interlocked.CompareExchange(ref playerGoldCollection_0, value2, playerGoldCollection2);
				}
				while (playerGoldCollection != playerGoldCollection2);
			}
			remove
			{
				PlayerGoldCollection playerGoldCollection = playerGoldCollection_0;
				PlayerGoldCollection playerGoldCollection2;
				do
				{
					playerGoldCollection2 = playerGoldCollection;
					PlayerGoldCollection value2 = (PlayerGoldCollection)Delegate.Remove(playerGoldCollection2, value);
					playerGoldCollection = Interlocked.CompareExchange(ref playerGoldCollection_0, value2, playerGoldCollection2);
				}
				while (playerGoldCollection != playerGoldCollection2);
			}
		}

		public event PlayerGiftTokenCollection GiftTokenCollect
		{
			add
			{
				PlayerGiftTokenCollection playerGiftTokenCollection = playerGiftTokenCollection_0;
				PlayerGiftTokenCollection playerGiftTokenCollection2;
				do
				{
					playerGiftTokenCollection2 = playerGiftTokenCollection;
					PlayerGiftTokenCollection value2 = (PlayerGiftTokenCollection)Delegate.Combine(playerGiftTokenCollection2, value);
					playerGiftTokenCollection = Interlocked.CompareExchange(ref playerGiftTokenCollection_0, value2, playerGiftTokenCollection2);
				}
				while (playerGiftTokenCollection != playerGiftTokenCollection2);
			}
			remove
			{
				PlayerGiftTokenCollection playerGiftTokenCollection = playerGiftTokenCollection_0;
				PlayerGiftTokenCollection playerGiftTokenCollection2;
				do
				{
					playerGiftTokenCollection2 = playerGiftTokenCollection;
					PlayerGiftTokenCollection value2 = (PlayerGiftTokenCollection)Delegate.Remove(playerGiftTokenCollection2, value);
					playerGiftTokenCollection = Interlocked.CompareExchange(ref playerGiftTokenCollection_0, value2, playerGiftTokenCollection2);
				}
				while (playerGiftTokenCollection != playerGiftTokenCollection2);
			}
		}

		public event PlayerEventHandle PingTimeOnline
		{
			add
			{
				PlayerEventHandle playerEventHandle = playerEventHandle_2;
				PlayerEventHandle playerEventHandle2;
				do
				{
					playerEventHandle2 = playerEventHandle;
					PlayerEventHandle value2 = (PlayerEventHandle)Delegate.Combine(playerEventHandle2, value);
					playerEventHandle = Interlocked.CompareExchange(ref playerEventHandle_2, value2, playerEventHandle2);
				}
				while (playerEventHandle != playerEventHandle2);
			}
			remove
			{
				PlayerEventHandle playerEventHandle = playerEventHandle_2;
				PlayerEventHandle playerEventHandle2;
				do
				{
					playerEventHandle2 = playerEventHandle;
					PlayerEventHandle value2 = (PlayerEventHandle)Delegate.Remove(playerEventHandle2, value);
					playerEventHandle = Interlocked.CompareExchange(ref playerEventHandle_2, value2, playerEventHandle2);
				}
				while (playerEventHandle != playerEventHandle2);
			}
		}

		public event PlayerPropertisChange PropertisChange
		{
			add
			{
				PlayerPropertisChange playerPropertisChange = playerPropertisChange_0;
				PlayerPropertisChange playerPropertisChange2;
				do
				{
					playerPropertisChange2 = playerPropertisChange;
					PlayerPropertisChange value2 = (PlayerPropertisChange)Delegate.Combine(playerPropertisChange2, value);
					playerPropertisChange = Interlocked.CompareExchange(ref playerPropertisChange_0, value2, playerPropertisChange2);
				}
				while (playerPropertisChange != playerPropertisChange2);
			}
			remove
			{
				PlayerPropertisChange playerPropertisChange = playerPropertisChange_0;
				PlayerPropertisChange playerPropertisChange2;
				do
				{
					playerPropertisChange2 = playerPropertisChange;
					PlayerPropertisChange value2 = (PlayerPropertisChange)Delegate.Remove(playerPropertisChange2, value);
					playerPropertisChange = Interlocked.CompareExchange(ref playerPropertisChange_0, value2, playerPropertisChange2);
				}
				while (playerPropertisChange != playerPropertisChange2);
			}
		}

		public event PlayerQuestFinish QuestFinishEvent
		{
			add
			{
				PlayerQuestFinish playerQuestFinish = playerQuestFinish_0;
				PlayerQuestFinish playerQuestFinish2;
				do
				{
					playerQuestFinish2 = playerQuestFinish;
					PlayerQuestFinish value2 = (PlayerQuestFinish)Delegate.Combine(playerQuestFinish2, value);
					playerQuestFinish = Interlocked.CompareExchange(ref playerQuestFinish_0, value2, playerQuestFinish2);
				}
				while (playerQuestFinish != playerQuestFinish2);
			}
			remove
			{
				PlayerQuestFinish playerQuestFinish = playerQuestFinish_0;
				PlayerQuestFinish playerQuestFinish2;
				do
				{
					playerQuestFinish2 = playerQuestFinish;
					PlayerQuestFinish value2 = (PlayerQuestFinish)Delegate.Remove(playerQuestFinish2, value);
					playerQuestFinish = Interlocked.CompareExchange(ref playerQuestFinish_0, value2, playerQuestFinish2);
				}
				while (playerQuestFinish != playerQuestFinish2);
			}
		}

		public event PlayerUseBugle UseBugle
		{
			add
			{
				PlayerUseBugle playerUseBugle = playerUseBugle_0;
				PlayerUseBugle playerUseBugle2;
				do
				{
					playerUseBugle2 = playerUseBugle;
					PlayerUseBugle value2 = (PlayerUseBugle)Delegate.Combine(playerUseBugle2, value);
					playerUseBugle = Interlocked.CompareExchange(ref playerUseBugle_0, value2, playerUseBugle2);
				}
				while (playerUseBugle != playerUseBugle2);
			}
			remove
			{
				PlayerUseBugle playerUseBugle = playerUseBugle_0;
				PlayerUseBugle playerUseBugle2;
				do
				{
					playerUseBugle2 = playerUseBugle;
					PlayerUseBugle value2 = (PlayerUseBugle)Delegate.Remove(playerUseBugle2, value);
					playerUseBugle = Interlocked.CompareExchange(ref playerUseBugle_0, value2, playerUseBugle2);
				}
				while (playerUseBugle != playerUseBugle2);
			}
		}

		public event GameKillDropEventHandel GameKillDrop
		{
			add
			{
				GameKillDropEventHandel gameKillDropEventHandel = gameKillDropEventHandel_0;
				GameKillDropEventHandel gameKillDropEventHandel2;
				do
				{
					gameKillDropEventHandel2 = gameKillDropEventHandel;
					GameKillDropEventHandel value2 = (GameKillDropEventHandel)Delegate.Combine(gameKillDropEventHandel2, value);
					gameKillDropEventHandel = Interlocked.CompareExchange(ref gameKillDropEventHandel_0, value2, gameKillDropEventHandel2);
				}
				while (gameKillDropEventHandel != gameKillDropEventHandel2);
			}
			remove
			{
				GameKillDropEventHandel gameKillDropEventHandel = gameKillDropEventHandel_0;
				GameKillDropEventHandel gameKillDropEventHandel2;
				do
				{
					gameKillDropEventHandel2 = gameKillDropEventHandel;
					GameKillDropEventHandel value2 = (GameKillDropEventHandel)Delegate.Remove(gameKillDropEventHandel2, value);
					gameKillDropEventHandel = Interlocked.CompareExchange(ref gameKillDropEventHandel_0, value2, gameKillDropEventHandel2);
				}
				while (gameKillDropEventHandel != gameKillDropEventHandel2);
			}
		}

		public GamePlayer(int playerId, string account, GameClient client, PlayerInfo info)
		{
			int_1 = 255;
			EquipPlace = new int[15]
			{
				1, 2, 3, 4, 5, 6, 11, 13, 14, 15,
				16, 17, 18, 19, 20
			};
			OfferAddPlus = 1.0;
			GuildRichAddPlus = 1.0;
			labyrinthGolds = new string[40]
			{
				"0|0", "2|2", "0|0", "2|2", "0|0", "2|3", "0|0", "3|3", "0|0", "3|4",
				"0|0", "3|4", "0|0", "4|5", "0|0", "4|5", "0|0", "4|6", "0|0", "5|6",
				"0|0", "5|7", "0|0", "5|7", "0|0", "6|8", "0|0", "6|8", "0|0", "6|10",
				"0|0", "8|10", "0|0", "8|11", "0|0", "8|11", "0|0", "10|12", "0|0", "10|12"
			};
			m_gameroomProcessor = new GameRoomLogicProcessor();
			m_avatarCollectionProcessor = new AvatarCollectionLogicProcessor();
			m_magicStoneProcessor = new MagicStoneLogicProcessor();
			m_newHallProcessor = new NewHallLogicProcessor();
			m_collectionTaskProcessor = new CollectionTaskLogicProcessor();
			m_horseProcessor = new HorseLogicProcessor();
			m_ringStationProcessor = new RingStationLogicProcessor();
			m_farmProcessor = new FarmLogicProcessor();
			m_petProcessor = new PetLogicProcessor();
			m_bombKingProcessor = new BombKingLogicProcessor();
			m_magicHouseProcessor = new MagicHouseLogicProcessor();
			m_dragonBoatProcessor = new DragonBoatLogicProcessor();
			m_activeSystemProcessor = new ActiveSystemLogicProcessor();
			m_worshipTheMoonProcessor = new WorshipTheMoonLogicProcessor();
			m_magpieBridgeProcessor = new MagpieBridgeLogicProcessor();
			m_gypsyShopProcessor = new GypsyShopLogicProcessor();
			Card = new Dictionary<int, CardsTakeOutInfo>();
			CardsTakeOut = new CardsTakeOutInfo[9];
			dictionary_1 = new Dictionary<string, object>();
			int_0 = playerId;
			string_0 = account;
			m_client = client;
			playerInfo_0 = info;
			playerEquipInventory_0 = new PlayerEquipInventory(this);
			playerBeadInventory_0 = new PlayerBeadInventory(this);
			playerAvataInventory_0 = new PlayerAvataInventory(this);
			playerMagicStoneInventory_0 = new PlayerMagicStoneInventory(this);
			playerInventory_0 = new PlayerInventory(this, saveTodb: true, 49, 1, 0, autoStack: true);
			playerInventory_2 = new PlayerInventory(this, saveTodb: true, 100, 11, 0, autoStack: true);
			playerMagicHouse_0 = new PlayerMagicHouse(this);
			playerInventory_3 = new PlayerInventory(this, saveTodb: true, 20, 12, 0, autoStack: true);
			playerInventory_1 = new PlayerInventory(this, saveTodb: false, 3, 3, 0, autoStack: false);
			playerInventory_4 = new PlayerInventory(this, saveTodb: false, 100, 4, 0, autoStack: true);
			playerInventory_5 = new PlayerInventory(this, saveTodb: false, 30, 5, 0, autoStack: true);
			playerInventory_6 = new PlayerInventory(this, saveTodb: true, 30, 13, 0, autoStack: true);
			playerInventory_7 = new PlayerInventory(this, saveTodb: true, 30, 14, 0, autoStack: true);
			playerInventory_8 = new PlayerInventory(this, saveTodb: true, 30, 34, 0, autoStack: true);
			playerInventory_9 = new PlayerInventory(this, saveTodb: true, 30, 35, 0, autoStack: true);
			playerInventory_10 = new PlayerInventory(this, saveTodb: true, 30, 5012, 0, autoStack: true);
			cardInventory_0 = new CardInventory(this, saveTodb: true, 100, 0);
			playerFarm_0 = new PlayerFarm(this, saveTodb: true, 30, 0);
			petInventory_0 = new PetInventory(this, saveTodb: true, 10, 8, 0);
			playerTreasure_0 = new PlayerTreasure(this, saveTodb: true);
			playerRank_0 = new PlayerRank(this, saveTodb: true);
			playerProperty_0 = new PlayerProperty(this);
			playerDice_0 = new PlayerDice(this, saveTodb: true);
			playerBattle_0 = new PlayerBattle(this, saveTodb: true);
			playerActives_0 = new PlayerActives(this, saveTodb: true);
			playerExtra_0 = new PlayerExtra(this, saveTodb: true);
			playerHorse_0 = new PlayerHorse(this, saveTodb: true);
			batleConfigInfo_0 = new BatleConfigInfo();
			questInventory_0 = new QuestInventory(this);
			achievementInventory_0 = new AchievementInventory(this);
			bufferList_0 = new BufferList(this);
			list_0 = new List<BufferInfo>();
			list_2 = new List<ItemInfo>();
			list_1 = new List<UserGemStone>();
			userLabyrinthInfo_0 = null;
			double_0 = 1.0;
			X = 646;
			Y = 1241;
			PosX = 1560;
			PosY = 500;
			MarryMap = 0;
			LastChatTime = DateTime.Today;
			LastFigUpTime = DateTime.Today;
			LastDrillUpTime = DateTime.Today;
			LastOpenPack = DateTime.Today;
			LastOpenGrowthPackage = DateTime.Now;
			LastOpenChristmasPackage = DateTime.Now;
			WaitingProcessor = DateTime.Now;
			bool_2 = false;
			bool_3 = true;
		}

		public PlayerInventory GetInventory(eBageType bageType)
		{
			return bageType switch
			{
				eBageType.EquipBag => playerEquipInventory_0, 
				eBageType.PropBag => playerInventory_0, 
				eBageType.FightBag => playerInventory_1, 
				eBageType.TempBag => playerInventory_4, 
				eBageType.CaddyBag => playerInventory_5, 
				eBageType.Consortia => playerInventory_2, 
				eBageType.Store => playerInventory_3, 
				eBageType.FarmBag => playerInventory_6, 
				eBageType.Vegetable => playerInventory_7, 
				eBageType.BeadBag => playerBeadInventory_0, 
				eBageType.Food => playerInventory_8, 
				eBageType.PetEgg => playerInventory_9, 
				eBageType.MagicStoneBag => playerMagicStoneInventory_0, 
				eBageType.MagicHouseBag => playerMagicHouse_0, 
				_ => throw new NotSupportedException($"Did not support this type bag: {bageType} PlayerID: {PlayerCharacter.ID} Nickname: {PlayerCharacter.NickName}"), 
			};
		}

		public string GetInventoryName(eBageType bageType)
		{
			return bageType switch
			{
				eBageType.EquipBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.Equip"), 
				eBageType.PropBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.Prop"), 
				eBageType.FightBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.FightBag"), 
				eBageType.FarmBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.FarmBag"), 
				eBageType.BeadBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.BeadBag"), 
				_ => bageType.ToString(), 
			};
		}

		public PlayerInventory GetItemInventory(ItemTemplateInfo template)
		{
			return GetInventory(template.BagType);
		}

		public ItemInfo GetItemAt(eBageType bagType, int place)
		{
			return GetInventory(bagType)?.GetItemAt(place);
		}

		public ItemInfo GetItemByTemplateID(int templateID)
		{
			ItemInfo ıtemByTemplateID = EquipBag.GetItemByTemplateID(EquipBag.BeginSlot, templateID);
			if (ıtemByTemplateID != null)
			{
				return ıtemByTemplateID;
			}
			ıtemByTemplateID = PropBag.GetItemByTemplateID(0, templateID);
			if (ıtemByTemplateID != null)
			{
				return ıtemByTemplateID;
			}
			ıtemByTemplateID = ConsortiaBag.GetItemByTemplateID(0, templateID);
			if (ıtemByTemplateID != null)
			{
				return ıtemByTemplateID;
			}
			return null;
		}

		public int GetHalloweenCardCount()
		{
			if (playerActives_0 == null)
			{
				return 0;
			}
			if (!Actives.IsHalloweenOpen())
			{
				return 0;
			}
			return GetItemCount(Actives.halloweenCard);
		}

		public int GetItemCount(int templateId)
		{
			int num = playerInventory_0.GetItemCount(templateId) + playerEquipInventory_0.GetItemCount(templateId) + playerInventory_2.GetItemCount(templateId);
			if (templateId == Actives.halloweenCard)
			{
				GameServer.Instance.LoginServer.SendHalloweenRank(PlayerId, playerInfo_0.NickName, num, playerInfo_0.typeVIP);
			}
			return num;
		}

		public bool AddItem(ItemInfo item)
		{
			AbstractInventory ıtemInventory = GetItemInventory(item.Template);
			if (item.isDress())
			{
				return playerAvataInventory_0.AddItem(item, playerAvataInventory_0.BeginSlot);
			}
			return ıtemInventory.AddItem(item, ıtemInventory.BeginSlot);
		}

		public bool StackItemToAnother(ItemInfo item)
		{
			AbstractInventory ıtemInventory = GetItemInventory(item.Template);
			if (item.isDress())
			{
				return playerAvataInventory_0.StackItemToAnother(item);
			}
			return ıtemInventory.StackItemToAnother(item);
		}

		public void UpdateItem(ItemInfo item)
		{
			if (item.BagType == 0)
			{
				if (item.Place < playerEquipInventory_0.Capalility)
				{
					playerEquipInventory_0.UpdateItem(item);
				}
				else
				{
					playerAvataInventory_0.UpdateItem(item);
				}
			}
			if (item.BagType == 1)
			{
				playerInventory_0.UpdateItem(item);
			}
			if (item.BagType == 12)
			{
				playerInventory_3.UpdateItem(item);
			}
		}

		public bool RemoveItem(ItemInfo item)
		{
			if (item.BagType == playerInventory_6.BagType)
			{
				return playerInventory_6.RemoveItem(item);
			}
			if (item.BagType == playerInventory_0.BagType)
			{
				return playerInventory_0.RemoveItem(item);
			}
			if (item.BagType == playerBeadInventory_0.BagType)
			{
				return playerBeadInventory_0.RemoveItem(item);
			}
			if (item.BagType == playerInventory_1.BagType)
			{
				return playerInventory_1.RemoveItem(item);
			}
			if (item.isDress())
			{
				return playerAvataInventory_0.RemoveItem(item);
			}
			return playerEquipInventory_0.RemoveItem(item);
		}

		public void ClearFightBuffOneMatch()
		{
			List<BufferInfo> list = new List<BufferInfo>();
			foreach (BufferInfo fightBuff in FightBuffs)
			{
				if (fightBuff != null && fightBuff.Type >= 400 && fightBuff.Type <= 406)
				{
					list.Add(fightBuff);
				}
			}
			foreach (BufferInfo item in list)
			{
				FightBuffs.Remove(item);
			}
			list.Clear();
		}

		public void UpdateFightBuff(BufferInfo info)
		{
			int num = -1;
			for (int i = 0; i < FightBuffs.Count; i++)
			{
				if (info != null && info.Type == FightBuffs[i].Type)
				{
					FightBuffs[i] = info;
					num = info.Type;
				}
			}
			if (num == -1)
			{
				FightBuffs.Add(info);
			}
		}

		public void UpdatePvpResult(string type, int value, bool option)
		{
		}

		public void UpdatePveResult(string type, int value, bool option)
		{
			int num = 0;
			string text = "";
			switch (type)
			{
			case "cryotboss":
				if (option)
				{
					Actives.UpdateStar(value);
				}
				break;
			case "qx":
				if (!option)
				{
					Actives.QXDropId = value;
					if (value == 70011)
					{
						Actives.method_6();
					}
				}
				break;
			case "yearmonter":
				Actives.Info.DamageNum = value;
				Actives.CreateYearMonterBoxState();
				break;
			case "consortiaboss":
			{
				int num2 = value / 800;
				num = value / 1200;
				text = LanguageMgr.GetTranslation("GamePlayer.Msg21", num2, num);
				AddRichesOffer(num2);
				ConsortiaBossMgr.UpdateBlood(PlayerCharacter.ConsortiaID, value);
				ConsortiaBossMgr.UpdateRank(PlayerCharacter.ConsortiaID, value, num2, num, PlayerCharacter.NickName, PlayerCharacter.ID);
				break;
			}
			case "worldboss":
			{
				int num2 = value / 400;
				num = value / 1200;
				text = LanguageMgr.GetTranslation("GamePlayer.Msg20", num2, num);
				AddDamageScores(num2);
				RoomMgr.WorldBossRoom.UpdateRank(num2, num, PlayerCharacter.NickName);
				RoomMgr.WorldBossRoom.ReduceBlood(value);
				if (option)
				{
					RoomMgr.WorldBossRoom.FightOver();
				}
				break;
			}
			}
			AddHonor(num);
			if (!string.IsNullOrEmpty(text))
			{
				SendMessage(text);
			}
		}

		public void SendItemNotice(ItemInfo info, int typeGet, string Name)
		{
			if (info == null)
			{
				return;
			}
			int num;
			switch (typeGet)
			{
			case 0:
			case 1:
				num = 2;
				break;
			case 2:
			case 3:
			case 4:
				num = 1;
				break;
			default:
				num = 3;
				break;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(14);
			gSPacketIn.WriteString(PlayerCharacter.NickName);
			gSPacketIn.WriteInt(typeGet);
			gSPacketIn.WriteInt(info.TemplateID);
			gSPacketIn.WriteBoolean(info.IsBinds);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteInt(info.Count);
			if (num == 3)
			{
				gSPacketIn.WriteString(Name);
			}
			if (info.IsTips)
			{
				GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				GamePlayer[] array = allPlayers;
				foreach (GamePlayer gamePlayer in array)
				{
					gamePlayer.Out.SendTCP(gSPacketIn);
				}
			}
		}

		public bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count, eGameView gameView, string Name)
		{
			if (cloneItem == null)
			{
				return false;
			}
			SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
			if (ShopMgr.FindSpecialItemInfo(cloneItem, ref specialValue))
			{
				DirectAddValue(specialValue);
				return true;
			}
			List<ItemInfo> list = new List<ItemInfo>();
			cloneItem.Count = count;
			if (!StackItemToAnother(cloneItem) && !AddItem(cloneItem))
			{
				list.Add(cloneItem);
			}
			BagFullSendToMail(list);
			if (Name != "no")
			{
				SendItemNotice(cloneItem, (int)gameView, Name);
			}
			return true;
		}

		public bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count, eGameView gameView)
		{
			if (eBageType.FightBag == bagType)
			{
				return FightBag.AddItem(cloneItem);
			}
			if (eGameView.dungeonTypeGet == gameView)
			{
				return AddTemplate(cloneItem, bagType, count, gameView, "pve");
			}
			return AddTemplate(cloneItem, bagType, count, gameView, "no");
		}

		public bool AddTemplate(ItemInfo cloneItem)
		{
			return AddTemplate(cloneItem, cloneItem.Template.BagType, cloneItem.Count, eGameView.OtherTypeGet);
		}

		public bool AddTemplate(ItemInfo cloneItem, string name)
		{
			return AddTemplate(cloneItem, (eBageType)cloneItem.BagType, cloneItem.Count, eGameView.OtherTypeGet, name);
		}

		public bool AddTemplate(List<ItemInfo> infos, int count)
		{
			if (infos != null)
			{
				List<ItemInfo> list = new List<ItemInfo>();
				foreach (ItemInfo info in infos)
				{
					info.IsBinds = true;
					info.Count = count;
					if (!StackItemToAnother(info) && !AddItem(info))
					{
						list.Add(info);
					}
				}
				BagFullSendToMail(list);
				return true;
			}
			return false;
		}

		public bool AddTemplate(List<ItemInfo> infos)
		{
			if (infos != null && infos.Count > 0)
			{
				List<ItemInfo> list = new List<ItemInfo>();
				foreach (ItemInfo info in infos)
				{
					info.IsBinds = true;
					if (!StackItemToAnother(info) && !AddItem(info))
					{
						list.Add(info);
					}
				}
				BagFullSendToMail(list);
				return true;
			}
			return false;
		}

		public void BagFullSendToMail(List<ItemInfo> infos)
		{
			if (infos.Count <= 0)
			{
				return;
			}
			if (GameProperties.BagMailEnable)
			{
				WorldMgr.AddItemToMailBag(playerInfo_0.ID, infos);
				SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg18"));
				return;
			}
			bool flag = false;
			using (new PlayerBussiness())
			{
				flag = SendItemsToMail(infos, "", LanguageMgr.GetTranslation("GamePlayer.Msg19"), eMailType.BuyItem);
			}
			if (flag)
			{
				Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
			}
		}

		public bool FindEmptySlot(eBageType bagType)
		{
			PlayerInventory ınventory = GetInventory(bagType);
			ınventory.FindFirstEmptySlot();
			return ınventory.FindFirstEmptySlot() > 0;
		}

		public bool RemoveTemplate(int templateId, int count)
		{
			int ıtemCount = playerEquipInventory_0.GetItemCount(templateId);
			int ıtemCount2 = playerInventory_0.GetItemCount(templateId);
			int ıtemCount3 = playerInventory_2.GetItemCount(templateId);
			int ıtemCount4 = playerMagicHouse_0.GetItemCount(templateId);
			int num = ıtemCount + ıtemCount2 + ıtemCount3;
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(templateId);
			if (ıtemTemplateInfo != null && num >= count)
			{
				if (ıtemCount > 0 && count > 0 && RemoveTempate(eBageType.EquipBag, ıtemTemplateInfo, (ıtemCount > count) ? count : ıtemCount))
				{
					count = ((count >= ıtemCount) ? (count - ıtemCount) : 0);
				}
				if (ıtemCount2 > 0 && count > 0 && RemoveTempate(eBageType.PropBag, ıtemTemplateInfo, (ıtemCount2 > count) ? count : ıtemCount2))
				{
					count = ((count >= ıtemCount2) ? (count - ıtemCount2) : 0);
				}
				if (ıtemCount3 > 0 && count > 0 && RemoveTempate(eBageType.Consortia, ıtemTemplateInfo, (ıtemCount3 > count) ? count : ıtemCount3))
				{
					count = ((count >= ıtemCount3) ? (count - ıtemCount3) : 0);
				}
				if (ıtemCount4 > 0 && count > 0 && RemoveTempate(eBageType.MagicHouseBag, ıtemTemplateInfo, (ıtemCount4 > count) ? count : ıtemCount4))
				{
					count = ((count >= ıtemCount4) ? (count - ıtemCount4) : 0);
				}
				if (count == 0)
				{
					return true;
				}
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error($"Item Remover Error：PlayerId {int_0} Remover TemplateId{templateId} Is Not Zero!");
				}
			}
			return false;
		}

		public bool RemoveTempate(eBageType bagType, ItemTemplateInfo template, int count)
		{
			return GetInventory(bagType)?.RemoveTemplate(template.TemplateID, count) ?? false;
		}

		public bool RemoveTemplate(ItemTemplateInfo template, int count)
		{
			return GetItemInventory(template)?.RemoveTemplate(template.TemplateID, count) ?? false;
		}

		public bool ClearTempBag()
		{
			TempBag.ClearBag();
			return true;
		}

		public bool ClearFightBag()
		{
			FightBag.ClearBag();
			return true;
		}

		public void ClearCaddyBag()
		{
			List<ItemInfo> list = new List<ItemInfo>();
			for (int i = 0; i < CaddyBag.Capalility; i++)
			{
				ItemInfo ıtemAt = CaddyBag.GetItemAt(i);
				if (ıtemAt != null)
				{
					ItemInfo ıtemInfo = ItemInfo.CloneFromTemplate(ıtemAt.Template, ıtemAt);
					ıtemInfo.Count = 1;
					list.Add(ıtemInfo);
				}
			}
			CaddyBag.ClearBag();
			AddTemplate(list);
		}

		public void ClearStoreBag()
		{
			List<ItemInfo> list = new List<ItemInfo>();
			for (int i = 0; i < StoreBag.Capalility; i++)
			{
				ItemInfo ıtemAt = StoreBag.GetItemAt(i);
				if (ıtemAt != null)
				{
					ItemInfo ıtemInfo = ItemInfo.CloneFromTemplate(ıtemAt.Template, ıtemAt);
					ıtemInfo.Count = ıtemAt.Count;
					list.Add(ıtemInfo);
				}
			}
			StoreBag.ClearBag();
			AddTemplate(list);
		}

		public bool IsConsortia()
		{
			ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(PlayerCharacter.ConsortiaID);
			return consortiaInfo != null;
		}

		public void OnUseBuffer()
		{
			if (playerEventHandle_0 != null)
			{
				playerEventHandle_0(this);
			}
		}

		public void AddBeadEffect(ItemInfo item)
		{
			list_2.Add(item);
		}

		public void BeginAllChanges()
		{
			BeginChanges();
			bufferList_0.BeginChanges();
			playerEquipInventory_0.BeginChanges();
			playerInventory_0.BeginChanges();
			playerBeadInventory_0.BeginChanges();
			playerInventory_6.BeginChanges();
			playerInventory_7.BeginChanges();
			cardInventory_0.BeginChanges();
		}

		public void CommitAllChanges()
		{
			CommitChanges();
			bufferList_0.CommitChanges();
			playerEquipInventory_0.CommitChanges();
			playerInventory_0.CommitChanges();
			playerBeadInventory_0.BeginChanges();
			playerInventory_6.CommitChanges();
			playerInventory_7.CommitChanges();
			cardInventory_0.CommitChanges();
		}

		public void BeginChanges()
		{
			Interlocked.Increment(ref int_2);
		}

		public void CommitChanges()
		{
			Interlocked.Decrement(ref int_2);
			OnPropertiesChanged();
		}

		protected void OnPropertiesChanged()
		{
			if (int_2 <= 0)
			{
				if (int_2 < 0)
				{
					ilog_0.Error("Player changed count < 0");
					Thread.VolatileWrite(ref int_2, 0);
				}
				UpdateProperties();
			}
		}

		public void UpdateBadgeId(int Id)
		{
			playerInfo_0.badgeID = Id;
		}

		public void UpdateTimeBox(int receiebox, int receieGrade, int needGetBoxTime)
		{
			playerInfo_0.receiebox = receiebox;
			playerInfo_0.receieGrade = receieGrade;
			playerInfo_0.needGetBoxTime = needGetBoxTime;
		}

		public string GetFightFootballStyle(int team)
		{
			if (team == 1)
			{
				return CreateFightFootballStyle(team);
			}
			return CreateFightFootballStyle(team);
		}

		public string CreateFightFootballStyle(int team)
		{
			ItemInfo ıtemAt = playerEquipInventory_0.GetItemAt(0);
			string text = ((ıtemAt == null) ? "" : (ıtemAt.TemplateID + "|" + ıtemAt.Template.Pic));
			string text2 = text;
			string text3 = text;
			for (int i = 0; i < EquipPlace.Length; i++)
			{
				text2 += ",";
				text3 += ",";
				if (EquipPlace[i] == 11)
				{
					if (PlayerCharacter.Sex)
					{
						ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(13573);
						object obj = text2;
						text2 = string.Concat(obj, ıtemTemplateInfo.TemplateID, "|", ıtemTemplateInfo.Pic);
						ıtemTemplateInfo = ItemMgr.FindItemTemplate(13572);
						object obj2 = text3;
						text3 = string.Concat(obj2, ıtemTemplateInfo.TemplateID, "|", ıtemTemplateInfo.Pic);
					}
					else
					{
						ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(13575);
						object obj3 = text2;
						text2 = string.Concat(obj3, ıtemTemplateInfo.TemplateID, "|", ıtemTemplateInfo.Pic);
						ıtemTemplateInfo = ItemMgr.FindItemTemplate(13574);
						object obj4 = text3;
						text3 = string.Concat(obj4, ıtemTemplateInfo.TemplateID, "|", ıtemTemplateInfo.Pic);
					}
				}
				else if (EquipPlace[i] == 6)
				{
					ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(70396);
					string text4 = ıtemTemplateInfo.TemplateID + "|" + ıtemTemplateInfo.Pic;
					text2 += text4;
					text3 += text4;
				}
				else
				{
					ıtemAt = playerEquipInventory_0.GetItemAt(EquipPlace[i]);
					if (ıtemAt != null)
					{
						string text5 = ıtemAt.TemplateID + "|" + ıtemAt.Pic;
						text2 += text5;
						text3 += text5;
					}
				}
			}
			if (team == 1)
			{
				return text2;
			}
			return text3;
		}

		public void RemoveFightFootballStyle()
		{
			ItemInfo ıtemAt = playerEquipInventory_0.GetItemAt(0);
			string text = ((ıtemAt == null) ? "" : (ıtemAt.TemplateID + "|" + ıtemAt.Template.Pic));
			for (int i = 0; i < EquipPlace.Length; i++)
			{
				text += ",";
				ıtemAt = playerEquipInventory_0.GetItemAt(EquipPlace[i]);
				if (ıtemAt != null)
				{
					object obj = text;
					text = string.Concat(obj, ıtemAt.TemplateID, "|", ıtemAt.Pic);
				}
			}
			if (!string.IsNullOrEmpty(text))
			{
				PlayerCharacter.Style = text;
			}
			OnPropertiesChanged();
		}

		public void UpdateProperties()
		{
			Out.SendUpdatePrivateInfo(playerInfo_0);
			GSPacketIn pkg = Out.SendUpdatePublicPlayer(playerInfo_0, playerBattle_0.MatchInfo);
			if (baseRoom_0 != null)
			{
				baseRoom_0.SendToAll(pkg, this);
			}
		}

		public int DragonBoatAddExpPlus()
		{
			return DragonBoatMgr.AddExpPlus();
		}

		public bool DragonBoatOpen()
		{
			return DragonBoatMgr.IsContinuous();
		}

		public string TcpEndPoint()
		{
			return Client.TcpEndpoint.Split(':')[0];
		}

		public int AddGold(int value)
		{
			if (value > 0)
			{
				playerInfo_0.Gold += value;
				if (playerInfo_0.Gold <= int.MinValue)
				{
					playerInfo_0.Gold = int.MaxValue;
					SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg4"));
				}
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveGold(int value)
		{
			if (value > 0 && value <= playerInfo_0.Gold)
			{
				playerInfo_0.Gold -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddMoney(int value)
		{
			if (value > 0)
			{
				playerInfo_0.Money += value;
				if (playerInfo_0.Money <= int.MinValue)
				{
					playerInfo_0.Money = int.MaxValue;
					SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg5"));
				}
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddHonor(int value)
		{
			if (value > 0)
			{
				playerInfo_0.myHonor += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddAchievementPoint(int value)
		{
			if (value > 0)
			{
				playerInfo_0.AchievementPoint += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveHonor(int value)
		{
			if (value > 0)
			{
				playerInfo_0.myHonor -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddSummerScore(int value)
		{
			if (value > 0)
			{
				Extra.Info.SummerScore += value;
				return value;
			}
			return 0;
		}

		public int AddTotem(int value)
		{
			if (value > 0)
			{
				playerInfo_0.totemId += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddMaxHonor(int value)
		{
			if (value > 0)
			{
				playerInfo_0.MaxBuyHonor += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddBoatScore(int value)
		{
			if (value > 0)
			{
				Actives.Info.useableScore += value;
				Actives.Info.totalScore += value;
				return value;
			}
			return 0;
		}

		public int RemoveMoney(int value)
		{
			if (value > 0 && value <= playerInfo_0.Money)
			{
				playerInfo_0.Money -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public bool RemoveMissionEnergy(int value)
		{
			if (value > 0 && value <= Extra.Info.MissionEnergy)
			{
				Extra.Info.MissionEnergy -= value;
				Out.SendMissionEnergy(Extra.Info);
				SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg6", value));
				return true;
			}
			return false;
		}

		public bool MissionEnergyEmpty(int value)
		{
			return value <= Extra.Info.MissionEnergy;
		}

		public int AddMissionEnergy(int value)
		{
			if (value > 0)
			{
				Extra.Info.MissionEnergy += value;
				Out.SendMissionEnergy(Extra.Info);
				return value;
			}
			return 0;
		}

		public int AddScoreMagicstone(int value)
		{
			if (value > 0)
			{
				playerExtra_0.Info.ScoreMagicstone += value;
				if (playerExtra_0.Info.ScoreMagicstone <= int.MinValue)
				{
					playerExtra_0.Info.ScoreMagicstone = int.MaxValue;
					SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg7"));
				}
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveScoreMagicstone(int value)
		{
			if (value > 0 && value <= playerExtra_0.Info.ScoreMagicstone)
			{
				playerExtra_0.Info.ScoreMagicstone -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public bool ActiveMoneyEnable(int value)
		{
			if (!GameProperties.IsActiveMoney)
			{
				return MoneyDirect(value);
			}
			if (value < 1)
			{
				return false;
			}
			if (Actives.Info.ActiveMoney >= value)
			{
				RemoveActiveMoney(value);
				RemoveMoney(value);
				return true;
			}
			SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg8", Actives.Info.ActiveMoney));
			return false;
		}

		public int AddActiveMoney(int value)
		{
			if (value > 0 && GameProperties.IsActiveMoney)
			{
				Actives.Info.ActiveMoney += value;
				if (Actives.Info.ActiveMoney <= int.MinValue)
				{
					Actives.Info.ActiveMoney = int.MaxValue;
					SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg9"));
				}
				else
				{
					SendHideMessage(LanguageMgr.GetTranslation("GamePlayer.Msg1", value, Actives.Info.ActiveMoney));
				}
				return value;
			}
			return 0;
		}

		public int RemoveActiveMoney(int value)
		{
			if (value > 0 && value <= Actives.Info.ActiveMoney)
			{
				Actives.Info.ActiveMoney -= value;
				SendHideMessage(LanguageMgr.GetTranslation("GamePlayer.Msg2", value, Actives.Info.ActiveMoney));
				return value;
			}
			return 0;
		}

		public int AddLeagueMoney(int value)
		{
			if (value > 0)
			{
				playerInfo_0.LeagueMoney += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveLeagueMoney(int value)
		{
			if (value > 0 && value <= playerInfo_0.LeagueMoney)
			{
				playerInfo_0.LeagueMoney -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddHardCurrency(int value)
		{
			if (value > 0)
			{
				playerInfo_0.hardCurrency += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveHardCurrency(int value)
		{
			if (value > 0 && value <= playerInfo_0.hardCurrency)
			{
				playerInfo_0.hardCurrency -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public void AddPrestige(bool isWin, eRoomType roomType)
		{
			if (roomType == eRoomType.RingStation)
			{
				UserRingStationInfo singleRingStationInfos = RingStationMgr.GetSingleRingStationInfos(PlayerCharacter.ID);
				if (singleRingStationInfos != null)
				{
					int num = RingStationMgr.ConfigInfo.AwardBattleByRank(singleRingStationInfos.Rank, isWin);
					string translation = LanguageMgr.GetTranslation("Ringstasion.BattleLost", num);
					if (isWin)
					{
						num = RingStationMgr.ConfigInfo.AwardBattleByRank(singleRingStationInfos.Rank, isWin);
						translation = LanguageMgr.GetTranslation("Ringstasion.BattleWin", num);
					}
					AddLeagueMoney(num);
					SendMessage(translation);
				}
			}
			if (roomType == eRoomType.BattleRoom)
			{
				BattleData.AddPrestige(isWin);
			}
		}

		public void RingstationResult(bool isWin)
		{
			if (DareFlag != null)
			{
				DareFlag.SuccessFlag = isWin;
			}
			if (SuccessFlag != null)
			{
				SuccessFlag.SuccessFlag = !isWin;
			}
			RingStationMgr.UpdateRingBattleFields(DareFlag, SuccessFlag);
		}

		public void UpdateHonor(string honor)
		{
			UserRankInfo rank = Rank.GetRank(honor);
			if (rank != null)
			{
				PlayerCharacter.honorId = rank.NewTitleID;
				PlayerCharacter.Honor = honor;
				EquipBag.UpdatePlayerProperties();
			}
		}

		public void UpdateRestCount()
		{
			BattleData.Update();
		}

		public void RemoveFistGetPet()
		{
			playerInfo_0.IsFistGetPet = false;
			playerInfo_0.LastRefreshPet = DateTime.Now.AddDays(-1.0);
		}

		public void RemoveLastRefreshPet()
		{
			playerInfo_0.LastRefreshPet = DateTime.Now;
		}

		public void UpdateAnswerSite(int id)
		{
			if (PlayerCharacter.AnswerSite < id)
			{
				PlayerCharacter.AnswerSite = id;
			}
			UpdateWeaklessGuildProgress();
			Out.SendWeaklessGuildProgress(PlayerCharacter);
		}

		public void UpdateWeaklessGuildProgress()
		{
			if (PlayerCharacter.weaklessGuildProgress == null)
			{
				PlayerCharacter.weaklessGuildProgress = Base64.decodeToByteArray(PlayerCharacter.WeaklessGuildProgressStr);
			}
			PlayerCharacter.CheckLevelFunction();
			if (PlayerCharacter.Grade == 1)
			{
				PlayerCharacter.openFunction(Step.POP_MOVE);
			}
			if (PlayerCharacter.IsOldPlayer)
			{
				PlayerCharacter.openFunction(Step.OLD_PLAYER);
			}
			PlayerCharacter.WeaklessGuildProgressStr = Base64.encodeByteArray(PlayerCharacter.weaklessGuildProgress);
		}

		public bool canUpLv(int exp, int _curLv)
		{
			List<int> list = GameProperties.VIPExp();
			return (exp >= list[0] && _curLv == 0) || (exp >= list[1] && _curLv == 1) || (exp >= list[2] && _curLv == 2) || (exp >= list[3] && _curLv == 3) || (exp >= list[4] && _curLv == 4) || (exp >= list[5] && _curLv == 5) || (exp >= list[6] && _curLv == 6) || (exp >= list[7] && _curLv == 7) || (exp >= list[8] && _curLv == 8) || (exp >= list[9] && _curLv == 9) || (exp >= list[10] && _curLv == 10) || (exp >= list[11] && _curLv == 11);
		}

		public void AddExpVip(int value)
		{
			List<int> list = GameProperties.VIPExp();
			if (value >= 100)
			{
				playerInfo_0.VIPExp += value / 100;
			}
			int num = 0;
			if (num >= list.Count)
			{
				return;
			}
			int vIPExp = playerInfo_0.VIPExp;
			int vIPLevel = playerInfo_0.VIPLevel;
			if (vIPLevel == 12)
			{
				playerInfo_0.VIPExp = list[11];
				return;
			}
			if (playerInfo_0.method_0())
			{
				Out.imethod_2(PlayerCharacter);
			}
			if (vIPLevel < 12 && canUpLv(vIPExp, vIPLevel))
			{
				playerInfo_0.VIPLevel++;
			}
		}

		public int AddCardSoul(int value)
		{
			if (value > 0)
			{
				playerInfo_0.CardSoul += value;
				if (playerInfo_0.CardSoul <= int.MinValue)
				{
					playerInfo_0.CardSoul = int.MaxValue;
					SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg10"));
				}
				return value;
			}
			return 0;
		}

		public int RemoveCardSoul(int value)
		{
			if (value > 0 && value <= playerInfo_0.CardSoul)
			{
				playerInfo_0.CardSoul -= value;
				return value;
			}
			return 0;
		}

		public int AddScore(int value)
		{
			if (value > 0)
			{
				playerInfo_0.Score += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveScore(int value)
		{
			if (value > 0 && value <= playerInfo_0.Score)
			{
				playerInfo_0.Score -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddDamageScores(int value)
		{
			if (value > 0)
			{
				playerInfo_0.damageScores += value;
				if (playerInfo_0.damageScores <= int.MinValue)
				{
					playerInfo_0.damageScores = int.MaxValue;
					SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg11"));
				}
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveDamageScores(int value)
		{
			if (value > 0 && value <= playerInfo_0.damageScores)
			{
				playerInfo_0.damageScores -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddPetScore(int value)
		{
			if (value > 0)
			{
				playerInfo_0.petScore += value;
				if (playerInfo_0.petScore <= int.MinValue)
				{
					playerInfo_0.petScore = int.MaxValue;
					SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg12"));
				}
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemovePetScore(int value)
		{
			if (value > 0 && value <= playerInfo_0.petScore)
			{
				playerInfo_0.petScore -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddmyHonor(int value)
		{
			if (value > 0)
			{
				playerInfo_0.myHonor += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemovemyHonor(int value)
		{
			if (value > 0 && value <= playerInfo_0.myHonor)
			{
				playerInfo_0.myHonor -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddMedal(int value)
		{
			if (value > 0)
			{
				playerInfo_0.medal += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveMedal(int value)
		{
			if (value > 0 && value <= playerInfo_0.medal)
			{
				playerInfo_0.medal -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddOffer(int value)
		{
			return AddOffer(value, IsRate: true);
		}

		public int AddOffer(int value, bool IsRate)
		{
			if (value > 0)
			{
				if (Class12.smethod_1())
				{
					value = (int)((double)value * Class12.pUjigatxrH(PlayerCharacter.AntiAddiction));
				}
				if (IsRate)
				{
					value *= (((int)OfferAddPlus == 0) ? 1 : ((int)OfferAddPlus));
				}
				playerInfo_0.Offer += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveOffer(int value)
		{
			if (value > 0)
			{
				if (value >= playerInfo_0.Offer)
				{
					value = playerInfo_0.Offer;
				}
				playerInfo_0.Offer -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int RemoveGiftToken(int value)
		{
			if (value > 0 && value <= playerInfo_0.DDTMoney)
			{
				playerInfo_0.DDTMoney -= value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public void CreateRandomEnterModeItem()
		{
			if (FightBag.GetItems().Count > 0)
			{
				return;
			}
			List<ItemInfo> list = WorldMgr.CreateRandomPropItem();
			foreach (ItemInfo item in list)
			{
				item.Count = 1;
				FightBag.AddItem(item);
			}
		}

		public int AddEnterModePoint(int value)
		{
			if (value > 0)
			{
				Actives.Info.EntertamentPoint += value;
				WorldMgr.ChatEntertamentModeUpdatePoint(playerInfo_0, value);
				return value;
			}
			return 0;
		}

		public bool CanUseBuffGp()
		{
			return GameProperties.NewbieEnable || Level >= GameProperties.BeginLevel;
		}

		public int AddGP(int gp)
		{
			if (gp >= 0)
			{
				if (CanUseBuffGp())
				{
					if (Class12.smethod_1())
					{
						gp = (int)((double)gp * Class12.pUjigatxrH(PlayerCharacter.AntiAddiction));
					}
					gp = (int)((float)gp * RateMgr.GetRate(eRateType.Experience_Rate));
					if (double_0 > 0.0)
					{
						gp = (int)((double)gp * double_0);
					}
				}
				playerInfo_0.GP += gp;
				if (playerInfo_0.GP < 1)
				{
					playerInfo_0.GP = 1;
				}
				Level = LevelMgr.GetLevel(playerInfo_0.GP);
				int maxLevel = LevelMgr.MaxLevel;
				LevelInfo levelInfo = LevelMgr.FindLevel(maxLevel);
				if (Level == maxLevel && levelInfo != null)
				{
					playerInfo_0.GP = levelInfo.GP;
					int num = gp / 100;
					if (num > 0)
					{
						AddOffer(num);
						SendHideMessage(LanguageMgr.GetTranslation("GamePlayer.Msg3", num));
					}
				}
				UpdateFightPower();
				OnPropertiesChanged();
				return gp;
			}
			return 0;
		}

		public void UpdateLevel()
		{
			Level = LevelMgr.GetLevel(playerInfo_0.GP);
			int maxLevel = LevelMgr.MaxLevel;
			LevelInfo levelInfo = LevelMgr.FindLevel(maxLevel);
			if (Level == maxLevel && levelInfo != null)
			{
				playerInfo_0.GP = levelInfo.GP;
			}
		}

		public int RemoveGP(int gp)
		{
			if (gp > 0)
			{
				playerInfo_0.GP -= gp;
				if (playerInfo_0.GP < 1)
				{
					playerInfo_0.GP = 1;
				}
				int level = LevelMgr.GetLevel(playerInfo_0.GP);
				if (Level > level)
				{
					playerInfo_0.GP += gp;
				}
				UpdateLevel();
				return gp;
			}
			return 0;
		}

		public int AddRobRiches(int value)
		{
			if (value > 0)
			{
				if (Class12.smethod_1())
				{
					value = (int)((double)value * Class12.pUjigatxrH(PlayerCharacter.AntiAddiction));
				}
				playerInfo_0.RichesRob += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddRichesOffer(int value)
		{
			if (value > 0)
			{
				playerInfo_0.RichesOffer += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public int AddGiftToken(int value)
		{
			if (value > 0)
			{
				playerInfo_0.DDTMoney += value;
				OnPropertiesChanged();
				return value;
			}
			return 0;
		}

		public bool CanEquip(ItemTemplateInfo item)
		{
			bool flag = true;
			string message = "";
			if (!item.CanEquip)
			{
				flag = false;
				message = LanguageMgr.GetTranslation("Game.Server.GameObjects.NoEquip");
			}
			else if (item.NeedSex != 0 && item.NeedSex != (playerInfo_0.Sex ? 1 : 2))
			{
				flag = false;
				message = LanguageMgr.GetTranslation("Game.Server.GameObjects.CanEquip");
			}
			else if (playerInfo_0.Grade < item.NeedLevel)
			{
				flag = false;
				message = LanguageMgr.GetTranslation("Game.Server.GameObjects.CanLevel");
			}
			if (!flag)
			{
				Out.SendMessage(eMessageType.ERROR, message);
			}
			return flag;
		}

		public void UpdateBaseProperties(int attack, int defence, int agility, int lucky, int hp, int mgatt, int mgdef)
		{
			if (attack != playerInfo_0.Attack || defence != playerInfo_0.Defence || agility != playerInfo_0.Agility || lucky != playerInfo_0.Luck || hp != playerInfo_0.hp || mgatt != playerInfo_0.MagicDefence || mgdef != playerInfo_0.MagicAttack)
			{
				playerInfo_0.Attack = attack;
				playerInfo_0.Defence = defence;
				playerInfo_0.Agility = agility;
				playerInfo_0.Luck = lucky;
				playerInfo_0.MagicAttack = mgatt;
				playerInfo_0.MagicDefence = mgdef;
				playerInfo_0.hp = hp;
				OnPropertiesChanged();
			}
		}

		public void UpdateStyle(string style, string color, string skin)
		{
			if (style != playerInfo_0.Style || color != playerInfo_0.Colors || skin != playerInfo_0.Skin)
			{
				playerInfo_0.Style = style;
				playerInfo_0.Colors = color;
				playerInfo_0.Skin = skin;
				OnPropertiesChanged();
			}
		}

		public void UpdateFightPower()
		{
			FightPower = 0;
			int hp = PlayerCharacter.hp;
			int attack = PlayerCharacter.Attack;
			attack += PlayerCharacter.Defence;
			attack += PlayerCharacter.Agility;
			attack += PlayerCharacter.Luck;
			attack += PlayerCharacter.MagicAttack;
			attack += PlayerCharacter.MagicDefence;
			double_1 = GetBaseAttack();
			double_2 = GetBaseDefence();
			FightPower += (int)((double)(attack + 1000) * (BaseAttack * BaseAttack * BaseAttack + 3.5 * BaseDefence * BaseDefence * BaseDefence) / 100000000.0 + (double)hp * 0.95);
			if (itemInfo_2 != null)
			{
				FightPower += (int)((double)itemInfo_2.Template.Property7 * Math.Pow(1.1, itemInfo_2.StrengthenLevel));
			}
			PlayerCharacter.FightPower = FightPower;
		}

		public void UpdateHide(int hide)
		{
			if (hide != playerInfo_0.Hide)
			{
				playerInfo_0.Hide = hide;
				OnPropertiesChanged();
			}
		}

		public void UpdateWeapon(ItemInfo item)
		{
			if (item != null && item != itemInfo_0)
			{
				itemInfo_0 = item;
				OnPropertiesChanged();
			}
		}

		public void UpdateBatleConfig(string type, int value)
		{
			switch (type)
			{
			case "MagicHouse":
				batleConfigInfo_0.MagicHouse = value;
				break;
			case "PetFormReduceDamage":
				batleConfigInfo_0.PetFormReduceDamage = value;
				break;
			case "CatchInsect":
				batleConfigInfo_0.CakeStatus = value == 1;
				break;
			}
		}

		public void UpdatePet(UsersPetinfo pet)
		{
			usersPetinfo_0 = pet;
		}

		public void UpdateHealstone(ItemInfo item)
		{
			if (item != null)
			{
				itemInfo_1 = item;
			}
		}

		public void UpdateReduceDame(ItemInfo item)
		{
			if (item != null && item.Template != null)
			{
				PlayerCharacter.ReduceDamePlus = item.Template.Property1;
			}
		}

		public bool RemoveHealstone()
		{
			ItemInfo ıtemAt = playerEquipInventory_0.GetItemAt(18);
			return ıtemAt != null && ıtemAt.Count > 0 && playerEquipInventory_0.RemoveCountFromStack(ıtemAt, 1);
		}

		public void UpdateSecondWeapon(ItemInfo item)
		{
			if (item != itemInfo_2)
			{
				itemInfo_2 = item;
				OnPropertiesChanged();
			}
		}

		public void HideEquip(int categoryID, bool hide)
		{
			if (categoryID >= 0 && categoryID < 10)
			{
				method_0(categoryID, (!hide) ? 1 : 2);
			}
		}

		public bool IsLimitCount(int count)
		{
			if (!GameProperties.IsLimitCount)
			{
				return false;
			}
			if (count > GameProperties.LimitCount)
			{
				SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg13", GameProperties.LimitCount));
				return true;
			}
			return false;
		}

		public bool IsLimitMoney(int count)
		{
			if (!GameProperties.IsLimitMoney)
			{
				return false;
			}
			if (count > GameProperties.LimitMoney)
			{
				SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg14", GameProperties.LimitMoney));
				return true;
			}
			return false;
		}

		public bool IsLimitAuction()
		{
			if (!GameProperties.IsLimitAuction)
			{
				return false;
			}
			if (Extra.Info.FreeAddAutionCount >= GameProperties.LimitAuction)
			{
				SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg15", GameProperties.LimitAuction));
				return true;
			}
			Extra.Info.FreeAddAutionCount++;
			return false;
		}

		public bool IsLimitMail()
		{
			if (!GameProperties.IsLimitMail)
			{
				return false;
			}
			if (Extra.Info.FreeSendMailCount >= GameProperties.LimitMail)
			{
				SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg16", GameProperties.LimitMail));
				return true;
			}
			Extra.Info.FreeSendMailCount++;
			return false;
		}

		public void ApertureEquip(int level)
		{
			method_0(0, (level < 5) ? 1 : ((level < 7) ? 2 : 3));
		}

		private void method_0(int int_5, int int_6)
		{
			UpdateHide((int)((double)playerInfo_0.Hide + Math.Pow(10.0, int_5) * (double)(int_6 - playerInfo_0.Hide / (int)Math.Pow(10.0, int_5) % 10)));
		}

		public void LogAddMoney(AddMoneyType masterType, AddMoneyType sonType, int userId, int moneys, int SpareMoney)
		{
		}

		public bool Login()
		{
			if (WorldMgr.AddPlayer(playerInfo_0.ID, this))
			{
				bool result;
				try
				{
					if (!LoadFromDatabase())
					{
						WorldMgr.RemovePlayer(playerInfo_0.ID);
						return false;
					}
					Out.SendLoginSuccess();
					Out.SendUpdatePublicPlayer(PlayerCharacter, BattleData.MatchInfo);
					Out.SendWeaklessGuildProgress(PlayerCharacter);
					Out.SendNecklaceStrength(PlayerCharacter);
					Out.SendMissionEnergy(Extra.Info);
					Out.SendUpdateOneKeyFinish(PlayerCharacter);
					Out.SendDateTime();
					Out.SendDailyAward(PlayerCharacter);
					if (!bool_2)
					{
						playerProperty_0.ViewCurrent();
						bool_2 = true;
					}
					if (PlayerCharacter.MountsType != 0)
					{
						Out.SendchangeHorse(PlayerCharacter.MountsType);
					}
					int ıD = PlayerCharacter.ID;
					Out.SendActivityList(ıD);
					Out.imethod_2(PlayerCharacter);
					Out.SendKingBlessMain(Extra);
					Out.SendDeedMain(Extra);
					SendPkgLimitGrate();
					if (GameProperties.IsPromotePackageOpen)
					{
						Out.SendGrowthPackageIsOpen(ıD);
						Out.SendGrowthPackageOpen(ıD, Actives.Info.AvailTime);
					}
					Out.SendUpdateAreaInfo();
					LoadMarryMessage();
					Actives.SendEvent();
					Dice.SendDiceActiveOpen();
					AvatarBag.UpdateInfo();
					BeadBag.SendPlayerDrill();
					Horse.UpdateHorsePacket();
					MagicHouse.Init();
					Rank.UpdateRank();
					Farm.LoadFarmLand();
					method_1();
					GameServer.Instance.LoginServer.SendGetLightriddleInfo(ıD);
					ePlayerState_0 = ePlayerState.Online;
					result = true;
				}
				catch (Exception exception)
				{
					ilog_0.Error("Error Login!", exception);
					return false;
				}
				return result;
			}
			return false;
		}

		public void SendPkgLimitGrate()
		{
			int ıD = PlayerCharacter.ID;
			if (PlayerCharacter.Grade >= 20)
			{
				if (RoomMgr.WorldBossRoom.worldOpen)
				{
					Out.SendOpenWorldBoss(X, Y);
				}
				if (ActiveSystemMgr.IsLeagueOpen)
				{
					Out.SendLeagueNotice(ıD, BattleData.MatchInfo.restCount, BattleData.maxCount, 1);
				}
				else
				{
					Out.SendLeagueNotice(ıD, BattleData.MatchInfo.restCount, BattleData.maxCount, 2);
				}
				if (ActiveSystemMgr.IsFightFootballTime)
				{
					Out.SendFightFootballTimeOpenClose(ıD, result: true);
				}
			}
			if (PlayerCharacter.Grade >= 30)
			{
				Out.SendPlayerFigSpiritinit(ıD, GemStone);
			}
			if (PlayerCharacter.Grade >= 15)
			{
				if (ActiveSystemMgr.IsBattleGoundOpen)
				{
					Out.SendBattleGoundOpen(ıD);
				}
				if (DragonBoatMgr.IsDragonBoatOpen())
				{
					Out.SendDragonBoat(PlayerCharacter);
				}
				if (ActiveSystemMgr.LanternriddlesOpen)
				{
					Out.SendLanternriddlesOpen(ıD, isOpen: true);
				}
			}
			if (PlayerCharacter.Grade >= 10 && Actives.IsChristmasOpen())
			{
				Out.SendOpenOrCloseChristmas(Actives.Christmas.lastPacks, Actives.IsChristmasOpen());
			}
			if (PlayerCharacter.Grade >= 13 && Actives.IsPyramidOpen())
			{
				Out.SendPyramidOpenClose(Actives.PyramidConfig);
			}
			if (Actives.IsYearMonsterOpen())
			{
				Out.SendCatchBeastOpen(ıD, isOpen: true);
			}
			Out.SendOpenEntertainmentMode();
			Out.SendUesedFinishTime(PlayerCharacter.uesedFinishTime);
			if (PlayerCharacter.Grade >= 15)
			{
				Out.SendOpenWorshipTheMoon(Actives.IsWorshipTheMoonOpen());
			}
		}

		public void SendUpdatePublicPlayer()
		{
			Out.SendUpdatePublicPlayer(PlayerCharacter, BattleData.MatchInfo);
		}

		public void LoadMarryMessage()
		{
			Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			MarryApplyInfo[] playerMarryApply = playerBussiness.GetPlayerMarryApply(PlayerCharacter.ID);
			if (playerMarryApply == null)
			{
				return;
			}
			MarryApplyInfo[] array = playerMarryApply;
			foreach (MarryApplyInfo marryApplyInfo in array)
			{
				switch (marryApplyInfo.ApplyType)
				{
				case 1:
					Out.SendPlayerMarryApply(this, marryApplyInfo.ApplyUserID, marryApplyInfo.ApplyUserName, marryApplyInfo.LoveProclamation, marryApplyInfo.ID);
					break;
				case 2:
					Out.SendMarryApplyReply(this, marryApplyInfo.ApplyUserID, marryApplyInfo.ApplyUserName, marryApplyInfo.ApplyResult, isApplicant: true, marryApplyInfo.ID);
					if (!marryApplyInfo.ApplyResult)
					{
						Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
					}
					break;
				case 3:
					Out.SendPlayerDivorceApply(this, result: true, isProposer: false);
					break;
				}
			}
		}

		public void ChargeToUser()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			int money = 0;
			string title = "Thông báo nạp thẻ.";
			if (!playerBussiness.ChargeToUser(playerInfo_0.UserName, ref money, playerInfo_0.NickName))
			{
				return;
			}
			bool flag = false;
			if (GameProperties.IsDDTMoneyActive)
			{
				AddGiftToken(money);
				string content = $"Bạn vừa chuyển thành công {money} Xu khóa";
				if (money > 0)
				{
					flag = SendMailToUser(playerBussiness, content, title, eMailType.Default);
				}
			}
			else
			{
				AddMoney(money);
			}
			if (flag)
			{
				Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
			}
		}

		public bool LoadFromDatabase()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(playerInfo_0.ID);
			if (userSingleByUserID == null)
			{
				Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.Forbid"));
				Client.Disconnect();
				return false;
			}
			playerInfo_0 = userSingleByUserID;
			playerInfo_0.Texp = playerBussiness.GetUserTexpInfoSingle(playerInfo_0.ID);
			playerInfo_0.PveEpicPermission = "1-2-3-4-5-6-7-8-9-10-11-12-13";
			playerInfo_0.ZoneID = ZoneId;
			playerInfo_0.ZoneName = ZoneName;
			if (userSingleByUserID.Grade >= 20)
			{
				LoadGemStone(playerBussiness);
			}
			playerBattle_0.LoadFromDatabase();
			ChargeToUser();
			int[] updatedSlots = new int[3] { 0, 1, 2 };
			Out.SendUpdateInventorySlot(FightBag, updatedSlots);
			UpdateWeaklessGuildProgress();
			UpdateItemForUser(1);
			UpdateLevel();
			UpdatePet(petInventory_0.GetPetIsEquip());
			char_0 = (string.IsNullOrEmpty(playerInfo_0.PvePermission) ? InitPvePermission() : playerInfo_0.PvePermission.ToCharArray());
			LoadPvePermission();
			dictionary_0 = new Dictionary<int, int>();
			dictionary_0 = playerBussiness.GetFriendsIDAll(playerInfo_0.ID);
			list_3 = new List<int>();
			playerInfo_0.State = 1;
			ClearStoreBag();
			ClearCaddyBag();
			Reset(saveToDb: true);
			return true;
		}

		public void Reset(bool saveToDb)
		{
			ChecVipkExpireDay();
			if (playerInfo_0.Texp.IsValidadteTexp())
			{
				playerInfo_0.Texp.texpCount = 0;
			}
			if (playerInfo_0.IsValidadteTimeBox())
			{
				playerInfo_0.TimeBox = DateTime.Now;
				playerInfo_0.receiebox = 0;
				playerInfo_0.MaxBuyHonor = 0;
				playerInfo_0.GetSoulCount = 30;
				playerInfo_0.uesedFinishTime = 10000;
				playerInfo_0.horseRaceCanRaceTime = GameProperties.HorseGameEachDayMaxCount;
				playerFarm_0.ResetFarmProp();
				playerBattle_0.Reset();
				playerActives_0.ResetActive();
				playerExtra_0.ResetUsersExtra();
				playerDice_0.Reset();
				playerMagicHouse_0.Reset();
				AccumulativeUpdate();
				CompleteAllBuriedQuest();
			}
			if (saveToDb)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					playerBussiness.UpdatePlayer(playerInfo_0);
				}
			}
		}

		public void AccumulativeUpdate()
		{
			if (playerInfo_0.accumulativeLoginDays <= 7)
			{
				if (playerInfo_0.accumulativeLoginDays == 0)
				{
					playerInfo_0.accumulativeLoginDays = 1;
				}
				else
				{
					playerInfo_0.accumulativeLoginDays++;
				}
			}
		}

		public void CompleteAllBuriedQuest()
		{
			QuestInfo[] allBuriedQuest = QuestMgr.GetAllBuriedQuest();
			QuestInfo[] array = allBuriedQuest;
			foreach (QuestInfo questInfo in array)
			{
				if (questInfo == null)
				{
					continue;
				}
				List<QuestConditionInfo> questCondiction = QuestMgr.GetQuestCondiction(questInfo);
				foreach (QuestConditionInfo item in questCondiction)
				{
					OnQuestOneKeyFinishEvent(item);
				}
			}
		}

		public void SendConsortiaBossOpenClose(int type)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(129, PlayerCharacter.ID);
			gSPacketIn.WriteByte(31);
			gSPacketIn.WriteByte((byte)type);
			SendTCP(gSPacketIn);
		}

		public void SendConsortiaBossInfo(ConsortiaInfo info)
		{
			RankingPersonInfo rankingPersonInfo = null;
			List<RankingPersonInfo> list = new List<RankingPersonInfo>();
			foreach (RankingPersonInfo value in info.RankList.Values)
			{
				if (value.Name == PlayerCharacter.NickName)
				{
					rankingPersonInfo = value;
				}
				else
				{
					list.Add(value);
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129, PlayerCharacter.ID);
			gSPacketIn.WriteByte(30);
			gSPacketIn.WriteByte((byte)info.bossState);
			gSPacketIn.WriteBoolean(rankingPersonInfo != null);
			if (rankingPersonInfo != null)
			{
				gSPacketIn.WriteInt(rankingPersonInfo.ID);
				gSPacketIn.WriteInt(rankingPersonInfo.TotalDamage);
				gSPacketIn.WriteInt(rankingPersonInfo.Honor);
				gSPacketIn.WriteInt(rankingPersonInfo.Damage);
			}
			gSPacketIn.WriteByte((byte)list.Count);
			foreach (RankingPersonInfo item in list)
			{
				gSPacketIn.WriteString(item.Name);
				gSPacketIn.WriteInt(item.ID);
				gSPacketIn.WriteInt(item.TotalDamage);
				gSPacketIn.WriteInt(item.Honor);
				gSPacketIn.WriteInt(item.Damage);
			}
			gSPacketIn.WriteByte((byte)info.extendAvailableNum);
			gSPacketIn.WriteDateTime(info.endTime);
			gSPacketIn.WriteInt(info.callBossLevel);
			SendTCP(gSPacketIn);
		}

		public GSPacketIn UpdateGoodsCount()
		{
			return Out.SendUpdateGoodsCount(PlayerCharacter, null, null);
		}

		public void LoadGemStone(PlayerBussiness db)
		{
			list_1 = db.GetSingleGemStones(playerInfo_0.ID);
			if (list_1.Count == 0)
			{
				List<int> list = new List<int>();
				list.Add(11);
				list.Add(5);
				list.Add(2);
				list.Add(3);
				list.Add(13);
				List<int> list2 = list;
				List<int> list3 = new List<int>();
				list3.Add(100002);
				list3.Add(100003);
				list3.Add(100001);
				list3.Add(100004);
				list3.Add(100005);
				List<int> list4 = list3;
				for (int i = 0; i < list2.Count; i++)
				{
					UserGemStone userGemStone = new UserGemStone();
					userGemStone.ID = 0;
					userGemStone.UserID = playerInfo_0.ID;
					userGemStone.FigSpiritId = list4[i];
					userGemStone.FigSpiritIdValue = "0,0,0|0,0,1|0,0,2";
					userGemStone.EquipPlace = list2[i];
					list_1.Add(userGemStone);
					db.AddUserGemStone(userGemStone);
				}
			}
		}

		public UserGemStone GetGemStone(int place)
		{
			foreach (UserGemStone item in list_1)
			{
				if (place == item.EquipPlace)
				{
					return item;
				}
			}
			return null;
		}

		public void UpdateGemStone(int place, UserGemStone gem)
		{
			for (int i = 0; i < list_1.Count; i++)
			{
				if (place == list_1[i].EquipPlace)
				{
					list_1[i] = gem;
					break;
				}
			}
		}

		public void UpdateItemForUser(object state)
		{
			playerHorse_0.LoadFromDatabase();
			playerBeadInventory_0.LoadFromDatabase();
			playerMagicStoneInventory_0.LoadFromDatabase();
			playerMagicHouse_0.LoadFromDatabase();
			playerInventory_6.LoadFromDatabase();
			playerInventory_10.LoadFromDatabase();
			petInventory_0.LoadFromDatabase();
			cardInventory_0.LoadFromDatabase();
			playerAvataInventory_0.LoadUserAvatarFromDatabase();
			playerRank_0.LoadFromDatabase();
			playerEquipInventory_0.LoadFromDatabase();
			playerInventory_0.LoadFromDatabase();
			playerInventory_3.LoadFromDatabase();
			playerInventory_2.LoadFromDatabase();
			questInventory_0.LoadFromDatabase(playerInfo_0.ID);
			achievementInventory_0.LoadFromDatabase(playerInfo_0.ID);
			bufferList_0.LoadFromDatabase(playerInfo_0.ID);
			playerTreasure_0.LoadFromDatabase();
			playerDice_0.LoadFromDatabase();
			playerActives_0.LoadFromDatabase();
			playerExtra_0.LoadFromDatabase();
		}

		public void ChecVipkExpireDay()
		{
			if (playerInfo_0.method_0())
			{
				playerInfo_0.CanTakeVipReward = false;
			}
			else if (playerInfo_0.IsLastVIPPackTime())
			{
				playerInfo_0.CanTakeVipReward = true;
			}
			else
			{
				playerInfo_0.CanTakeVipReward = false;
			}
		}

		public void LastVIPPackTime()
		{
			playerInfo_0.LastVIPPackTime = DateTime.Now;
			playerInfo_0.CanTakeVipReward = false;
		}

		public void OpenVIP(DateTime ExpireDayOut, int time)
		{
			if (playerInfo_0.typeVIP == 0)
			{
				Extra.CreateSaveLifeBuff();
			}
			int vIPLevel = playerInfo_0.VIPLevel;
			if (vIPLevel < 6 && time == 180)
			{
				playerInfo_0.typeVIP = 1;
				playerInfo_0.VIPLevel = 6;
				playerInfo_0.VIPExp = 3300;
				playerInfo_0.VIPExpireDay = ExpireDayOut;
				playerInfo_0.DateTime_0 = DateTime.Now;
				playerInfo_0.VIPNextLevelDaysNeeded = 0;
				playerInfo_0.CanTakeVipReward = true;
			}
			else if (vIPLevel < 4 && time == 90)
			{
				playerInfo_0.typeVIP = 1;
				playerInfo_0.VIPLevel = 4;
				playerInfo_0.VIPExp = 600;
				playerInfo_0.VIPExpireDay = ExpireDayOut;
				playerInfo_0.DateTime_0 = DateTime.Now;
				playerInfo_0.VIPNextLevelDaysNeeded = 0;
				playerInfo_0.CanTakeVipReward = true;
			}
			else
			{
				playerInfo_0.typeVIP = 1;
				playerInfo_0.VIPLevel = 1;
				playerInfo_0.VIPExp = 0;
				playerInfo_0.VIPExpireDay = ExpireDayOut;
				playerInfo_0.DateTime_0 = DateTime.Now;
				playerInfo_0.VIPNextLevelDaysNeeded = 0;
				playerInfo_0.CanTakeVipReward = true;
			}
		}

		public void ContinousVIP(DateTime ExpireDayOut, int time)
		{
			int vIPLevel = playerInfo_0.VIPLevel;
			if (vIPLevel < 6 && time == 180)
			{
				playerInfo_0.VIPLevel = 6;
				playerInfo_0.VIPExp = 3300;
				playerInfo_0.VIPExpireDay = ExpireDayOut;
			}
			else if (vIPLevel < 4 && time == 90)
			{
				playerInfo_0.VIPLevel = 4;
				playerInfo_0.VIPExp = 600;
				playerInfo_0.VIPExpireDay = ExpireDayOut;
			}
			else
			{
				playerInfo_0.VIPExpireDay = ExpireDayOut;
			}
		}

		public UserLabyrinthInfo LoadLabyrinth()
		{
			if (userLabyrinthInfo_0 == null)
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				userLabyrinthInfo_0 = playerBussiness.GetSingleLabyrinth(playerInfo_0.ID);
				if (userLabyrinthInfo_0 == null)
				{
					userLabyrinthInfo_0 = new UserLabyrinthInfo();
					userLabyrinthInfo_0.UserID = playerInfo_0.ID;
					userLabyrinthInfo_0.myProgress = 0;
					userLabyrinthInfo_0.myRanking = 0;
					userLabyrinthInfo_0.completeChallenge = true;
					userLabyrinthInfo_0.isDoubleAward = false;
					userLabyrinthInfo_0.currentFloor = 1;
					userLabyrinthInfo_0.accumulateExp = 0;
					userLabyrinthInfo_0.remainTime = 0;
					userLabyrinthInfo_0.currentRemainTime = 0;
					userLabyrinthInfo_0.cleanOutAllTime = 0;
					userLabyrinthInfo_0.cleanOutGold = 50;
					userLabyrinthInfo_0.tryAgainComplete = true;
					userLabyrinthInfo_0.isInGame = false;
					userLabyrinthInfo_0.isCleanOut = false;
					userLabyrinthInfo_0.serverMultiplyingPower = false;
					userLabyrinthInfo_0.LastDate = DateTime.Now;
					userLabyrinthInfo_0.ProcessAward = InitProcessAward();
					playerBussiness.AddUserLabyrinth(userLabyrinthInfo_0);
				}
				else
				{
					ProcessLabyrinthAward = userLabyrinthInfo_0.ProcessAward;
				}
			}
			return Labyrinth;
		}

		public string InitProcessAward()
		{
			string[] array = new string[99];
			for (int i = 0; i < array.Length; i++)
			{
				array[i] = i.ToString();
			}
			ProcessLabyrinthAward = string.Join("-", array);
			return ProcessLabyrinthAward;
		}

		public string CompleteGetAward(int floor)
		{
			string[] array = new string[floor];
			for (int i = 0; i < floor; i++)
			{
				array[i] = "i";
			}
			string[] array2 = userLabyrinthInfo_0.ProcessAward.Split('-');
			string text = string.Join("-", array);
			for (int j = floor; j < array2.Length; j++)
			{
				text = text + "-" + array2[j];
			}
			return text;
		}

		public bool isDoubleAward()
		{
			return userLabyrinthInfo_0 != null && userLabyrinthInfo_0.isDoubleAward;
		}

		public void OutLabyrinth(bool isWin)
		{
			if (!isWin && userLabyrinthInfo_0 != null && userLabyrinthInfo_0.currentFloor > 1)
			{
				SendLabyrinthTryAgain();
			}
			ResetLabyrinth();
		}

		public void ResetLabyrinth()
		{
			if (userLabyrinthInfo_0 != null)
			{
				userLabyrinthInfo_0.isInGame = false;
				userLabyrinthInfo_0.completeChallenge = false;
				userLabyrinthInfo_0.ProcessAward = InitProcessAward();
			}
		}

		public void CalculatorClearnOutLabyrinth()
		{
			if (userLabyrinthInfo_0 != null)
			{
				int num = 0;
				for (int i = userLabyrinthInfo_0.currentFloor; i <= userLabyrinthInfo_0.myProgress; i++)
				{
					num += 2;
				}
				num *= 60;
				userLabyrinthInfo_0.remainTime = num;
				userLabyrinthInfo_0.currentRemainTime = num;
				userLabyrinthInfo_0.cleanOutAllTime = num;
			}
		}

		public int[] CreateExps()
		{
			int[] array = new int[40];
			int num = 660;
			for (int i = 0; i < array.Length; i++)
			{
				array[i] = num;
				num += 690;
			}
			return array;
		}

		public void UpdateLabyrinth(int floor, int m_missionInfoId, bool bigAward)
		{
			int[] array = CreateExps();
			int num = ((floor - 1 > array.Length) ? (array.Length - 1) : (floor - 1));
			num = ((num >= 0) ? num : 0);
			int num2 = array[num];
			string text = labyrinthGolds[num];
			int num3 = int.Parse(text.Split('|')[0]);
			int num4 = int.Parse(text.Split('|')[1]);
			if (userLabyrinthInfo_0 != null)
			{
				floor++;
				ProcessLabyrinthAward = CompleteGetAward(floor);
				userLabyrinthInfo_0.ProcessAward = ProcessLabyrinthAward;
				ItemInfo ıtemByTemplateID = PropBag.GetItemByTemplateID(0, 11916);
				if (ıtemByTemplateID == null || !RemoveTemplate(11916, 1))
				{
					userLabyrinthInfo_0.isDoubleAward = false;
				}
				if (userLabyrinthInfo_0.isDoubleAward)
				{
					num2 *= 2;
					num3 *= 2;
					num4 *= 2;
				}
				if (floor > userLabyrinthInfo_0.myProgress)
				{
					userLabyrinthInfo_0.myProgress = floor;
				}
				if (floor > userLabyrinthInfo_0.currentFloor)
				{
					userLabyrinthInfo_0.currentFloor = floor;
				}
				userLabyrinthInfo_0.accumulateExp += num2;
				string text2 = LanguageMgr.GetTranslation("UpdateLabyrinth.Exp", num2);
				AddGP(num2);
				if (bigAward)
				{
					List<ItemInfo> list = CopyDrop(2, 40002);
					if (list != null)
					{
						foreach (ItemInfo item in list)
						{
							item.IsBinds = true;
							AddTemplate(item, item.Template.BagType, num3, eGameView.dungeonTypeGet);
							text2 += $", {item.Template.Name} x{num3}";
						}
					}
					AddHardCurrency(num4);
					text2 = text2 + LanguageMgr.GetTranslation("UpdateLabyrinth.GoldLaby") + num4;
				}
				SendHideMessage(text2);
			}
			Out.SendLabyrinthUpdataInfo(userLabyrinthInfo_0.UserID, userLabyrinthInfo_0);
		}

		public List<ItemInfo> CopyDrop(int SessionId, int m_missionInfoId)
		{
			List<ItemInfo> info = null;
			DropInventory.CopyDrop(m_missionInfoId, SessionId, ref info);
			return info;
		}

		public bool MoneyDirect(int value)
		{
			if (GameProperties.IsDDTMoneyActive)
			{
				return MoneyDirect(MoneyType.DDTMoney, value);
			}
			return MoneyDirect(MoneyType.Money, value);
		}

		public bool MoneyDirect(MoneyType type, int value)
		{
			if (value >= 0)
			{
				if (type == MoneyType.Money)
				{
					if (PlayerCharacter.Money >= value)
					{
						RemoveMoney(value);
						return true;
					}
					SendInsufficientMoney(0);
				}
				else
				{
					if (PlayerCharacter.DDTMoney >= value)
					{
						RemoveGiftToken(value);
						return true;
					}
					SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg17"));
				}
				return false;
			}
			return false;
		}

		public bool SaveIntoDatabase()
		{
			try
			{
				if (playerInfo_0.IsDirty)
				{
					using PlayerBussiness playerBussiness = new PlayerBussiness();
					playerBussiness.UpdatePlayer(playerInfo_0);
					if (userLabyrinthInfo_0 != null)
					{
						playerBussiness.UpdateLabyrinthInfo(userLabyrinthInfo_0);
					}
					foreach (UserGemStone item in list_1)
					{
						playerBussiness.UpdateGemStoneInfo(item);
					}
				}
				EquipBag.SaveToDatabase();
				AvatarBag.SaveToDatabase();
				PropBag.SaveToDatabase();
				ConsortiaBag.SaveToDatabase();
				MagicHouse.SaveToDatabase();
				BeadBag.SaveToDatabase();
				MagicStoneBag.SaveToDatabase();
				FarmBag.SaveToDatabase();
				PetEquipBag.SaveToDatabase();
				PetBag.SaveToDatabase(saveAdopt: true);
				CardBag.SaveToDatabase();
				AvatarBag.SaveUserAvatarToDatabase();
				StoreBag.SaveToDatabase();
				Farm.SaveToDatabase();
				Treasure.SaveToDatabase();
				Rank.SaveToDatabase();
				QuestInventory.SaveToDatabase();
				AchievementInventory.SaveToDatabase();
				BufferList.SaveToDatabase();
				BattleData.SaveToDatabase();
				Actives.SaveToDatabase();
				Dice.SaveToDatabase();
				Extra.SaveToDatabase();
				Horse.SaveToDatabase();
				return true;
			}
			catch (Exception exception)
			{
				ilog_0.Error("Error saving player " + playerInfo_0.NickName + "!", exception);
				return false;
			}
		}

		public bool SaveNewItemToDatabase()
		{
			try
			{
				EquipBag.SaveNewItemToDatabase();
				PropBag.SaveNewItemToDatabase();
				BeadBag.SaveNewItemToDatabase();
				AvatarBag.SaveNewItemToDatabase();
				ConsortiaBag.SaveNewItemToDatabase();
				MagicHouse.SaveNewItemToDatabase();
				MagicStoneBag.SaveNewItemToDatabase();
				return true;
			}
			catch (Exception exception)
			{
				ilog_0.Error("Error saving Save Bag Into Database " + playerInfo_0.NickName + "!", exception);
				return false;
			}
		}

		public virtual bool Quit()
		{
			try
			{
				try
				{
					if (CurrentRoom != null)
					{
						CurrentRoom.RemovePlayerUnsafe(this);
						CurrentRoom = null;
					}
					else
					{
						RoomMgr.WaitingRoom.RemovePlayer(this);
					}
					if (CurrentMarryRoom != null)
					{
						CurrentMarryRoom.RemovePlayer(this);
						CurrentMarryRoom = null;
					}
					if (baseSevenDoubleRoom_0 != null)
					{
						CurrentSevenDoubleRoom.RemovePlayer(this);
						CurrentSevenDoubleRoom = null;
					}
					RoomMgr.WorldBossRoom.RemovePlayer(this);
					RoomMgr.ChristmasRoom.SetMonterDie(PlayerCharacter.ID);
					RoomMgr.ChristmasRoom.RemovePlayer(this);
					RoomMgr.ConsBatRoom.RemovePlayer(this);
					RoomMgr.CampBattleRoom.RemovePlayer(this);
					WorldMgr.NewHallRooms.RemovePlayer(PlayerId);
					WorldMgr.CollectionTaskRooms.RemovePlayer(PlayerId);
					Actives.StopChristmasTimer();
					Actives.StopLabyrinthTimer();
					Actives.StopLightriddleTimer();
				}
				catch (Exception exception)
				{
					ilog_0.Error("Player exit Game Error!", exception);
				}
				playerInfo_0.State = 0;
				SaveIntoDatabase();
			}
			catch (Exception exception2)
			{
				ilog_0.Error("Player exit Error!!!", exception2);
			}
			finally
			{
				WorldMgr.RemovePlayer(playerInfo_0.ID);
			}
			return true;
		}

		public void ViFarmsAdd(int playerID)
		{
			if (!list_3.Contains(playerID))
			{
				list_3.Add(playerID);
			}
		}

		public void ViFarmsRemove(int playerID)
		{
			if (list_3.Contains(playerID))
			{
				list_3.Remove(playerID);
			}
		}

		public void FriendsAdd(int playerID, int relation)
		{
			if (!dictionary_0.ContainsKey(playerID))
			{
				dictionary_0.Add(playerID, relation);
			}
			else
			{
				dictionary_0[playerID] = relation;
			}
		}

		public void FriendsRemove(int playerID)
		{
			if (dictionary_0.ContainsKey(playerID))
			{
				dictionary_0.Remove(playerID);
			}
		}

		public bool IsBlackFriend(int playerID)
		{
			return dictionary_0 == null || (dictionary_0.ContainsKey(playerID) && dictionary_0[playerID] == 1);
		}

		public void ClearConsortia()
		{
			PlayerCharacter.ClearConsortia();
			OnPropertiesChanged();
			QuestInventory.ClearConsortiaQuest();
			string translation = LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.Sender");
			string translation2 = LanguageMgr.GetTranslation("Game.Server.GameUtils.Title");
			ConsortiaBag.SendAllItemsToMail(translation, translation2, eMailType.StoreCanel);
		}

		private void method_1()
		{
			gameRoomProcessor_0 = new GameRoomProcessor(m_gameroomProcessor);
			activeSystemProcessor_0 = new ActiveSystemProcessor(m_activeSystemProcessor);
			avatarCollectionProcessor_0 = new AvatarCollectionProcessor(m_avatarCollectionProcessor);
			magicStoneProcessor_0 = new MagicStoneProcessor(m_magicStoneProcessor);
			newHallProcessor_0 = new NewHallProcessor(m_newHallProcessor);
			collectionTaskProcessor_0 = new CollectionTaskProcessor(m_collectionTaskProcessor);
			horseProcessor_0 = new HorseProcessor(m_horseProcessor);
			ringStationProcessor_0 = new RingStationProcessor(m_ringStationProcessor);
			farmProcessor_0 = new FarmProcessor(m_farmProcessor);
			petProcessor_0 = new PetProcessor(m_petProcessor);
			bombKingProcessor_0 = new BombKingProcessor(m_bombKingProcessor);
			magicHouseProcessor_0 = new MagicHouseProcessor(m_magicHouseProcessor);
			dragonBoatProcessor_0 = new DragonBoatProcessor(m_dragonBoatProcessor);
			worshipTheMoonProcessor_0 = new WorshipTheMoonProcessor(m_worshipTheMoonProcessor);
			magpieBridgeProcessor_0 = new MagpieBridgeProcessor(m_magpieBridgeProcessor);
			gypsyShopProcessor_0 = new GypsyShopProcessor(m_gypsyShopProcessor);
		}

		public int AddHorseRaceTimes(int value)
		{
			if (value > 0)
			{
				playerInfo_0.horseRaceCanRaceTime += value;
				Out.SendUpdateCountHorseRace(playerInfo_0.horseRaceCanRaceTime);
				return value;
			}
			return 0;
		}

		public int RemoveHorseRaceTimes(int value)
		{
			if (value > 0)
			{
				playerInfo_0.horseRaceCanRaceTime -= value;
				Out.SendUpdateCountHorseRace(playerInfo_0.horseRaceCanRaceTime);
				return value;
			}
			return 0;
		}

		public void AddRuneProperty(ItemInfo item, ref double defence, ref double attack)
		{
			RuneTemplateInfo runeTemplateInfo = RuneMgr.FindRuneByTemplateID(item.TemplateID);
			if (runeTemplateInfo == null)
			{
				return;
			}
			string[] array = runeTemplateInfo.Attribute1.Split('|');
			string[] array2 = runeTemplateInfo.Attribute2.Split('|');
			int num = 0;
			int num2 = 0;
			if (item.Hole1 > runeTemplateInfo.BaseLevel)
			{
				if (array.Length > 1)
				{
					num = 1;
				}
				if (array2.Length > 1)
				{
					num2 = 1;
				}
			}
			int num3 = Convert.ToInt32(array[num]);
			Convert.ToInt32(array2[num2]);
			switch (runeTemplateInfo.Type1)
			{
			case 35:
				attack += num3;
				break;
			case 36:
				defence += num3;
				break;
			}
		}

		public double getHertAddition(double para1, double para2)
		{
			double a = para1 * Math.Pow(1.1, para2) - para1;
			return Math.Round(a);
		}

		public List<ItemInfo> GetAllEquipItems()
		{
			List<ItemInfo> list = new List<ItemInfo>();
			for (int i = 0; i < playerEquipInventory_0.BeginSlot; i++)
			{
				ItemInfo ıtemAt = playerEquipInventory_0.GetItemAt(i);
				if (ıtemAt != null)
				{
					list.Add(ıtemAt);
				}
			}
			return list;
		}

		public List<ItemInfo> GetStrengthenItems()
		{
			int[] array = new int[3] { 0, 5, 6 };
			List<ItemInfo> list = new List<ItemInfo>();
			for (int i = 0; i < array.Length; i++)
			{
				ItemInfo ıtemAt = playerEquipInventory_0.GetItemAt(array[i]);
				if (ıtemAt != null)
				{
					list.Add(ıtemAt);
				}
			}
			return list;
		}

		public double GetBaseAttack()
		{
			double num = 0.0;
			double defence = 0.0;
			double attack = 0.0;
			double num2 = 0.0;
			double avatarDame = 0.0;
			double num3 = 0.0;
			double num4 = 0.0;
			UserRankInfo rank = Rank.GetRank(PlayerCharacter.Honor);
			if (rank != null)
			{
				num += (double)rank.Damage;
			}
			List<ItemInfo> allEquipItems = GetAllEquipItems();
			foreach (ItemInfo item in allEquipItems)
			{
				SubActiveConditionInfo subActiveInfo = SubActiveMgr.GetSubActiveInfo(item);
				if (subActiveInfo != null)
				{
					num += (double)subActiveInfo.GetValue("6");
				}
			}
			PlayerProp.totalDamage = (int)num;
			for (int i = 0; i < 31; i++)
			{
				ItemInfo ıtemAt = playerBeadInventory_0.GetItemAt(i);
				if (ıtemAt != null)
				{
					AddRuneProperty(ıtemAt, ref defence, ref attack);
				}
			}
			AvatarBag.AddBasePropAvatarColection(ref defence, ref avatarDame);
			if (Horse.Info.curUseHorse > 0)
			{
				int curLevel = Horse.Info.curLevel;
				MountTemplateInfo mountTemplate = MountMgr.GetMountTemplate(curLevel);
				num3 += (double)mountTemplate.AddDamage;
			}
			MountDrawDataInfo[] getPicCherishs = Horse.GetPicCherishs;
			MountDrawDataInfo[] array = getPicCherishs;
			foreach (MountDrawDataInfo mountDrawDataInfo in array)
			{
				MountDrawTemplateInfo mountDrawTemplateInfo = MountMgr.FindMountDrawInfo(mountDrawDataInfo.ID);
				if (mountDrawTemplateInfo != null)
				{
					num4 += (double)mountDrawTemplateInfo.AddHurt;
				}
			}
			PlayerProp.UpadateBaseProp(isSelf: true, "Damage", "Bead", attack);
			PlayerProp.UpadateBaseProp(isSelf: true, "Damage", "Suit", num2);
			PlayerProp.UpadateBaseProp(isSelf: true, "Damage", "Avatar", avatarDame);
			PlayerProp.UpadateBaseProp(isSelf: true, "Damage", "Horse", num3);
			PlayerProp.UpadateBaseProp(isSelf: true, "Damage", "HorsePicCherish", num4);
			List<UsersCardInfo> cards = cardInventory_0.GetCards(0, 5);
			foreach (UsersCardInfo item2 in cards)
			{
				if (item2.CardID != 0)
				{
					CardTemplateInfo cardTemplateInfo = CardMgr.FindCardTemplate(item2.TemplateID, item2.CardType);
					if (cardTemplateInfo != null)
					{
						num += (double)cardTemplateInfo.AddDamage;
					}
					num += (double)item2.Damage;
				}
			}
			num += (double)TotemMgr.GetTotemProp(playerInfo_0.totemId, "dam");
			ItemInfo ıtemAt2 = playerEquipInventory_0.GetItemAt(6);
			if (ıtemAt2 != null)
			{
				double num5 = ıtemAt2.Template.Property7;
				int num6 = (ıtemAt2.IsGold ? 1 : 0);
				double para = ıtemAt2.StrengthenLevel + num6;
				num += getHertAddition(num5, para) + num5;
			}
			return (int)(num + attack + num2 + avatarDame + num3 + num4);
		}

		public double GetBaseDefence()
		{
			double num = 0.0;
			double defence = 0.0;
			double num2 = 0.0;
			double attack = 0.0;
			double avatarGuard = 0.0;
			double num3 = 0.0;
			double num4 = 0.0;
			double num5 = 0.0;
			UserRankInfo rank = Rank.GetRank(PlayerCharacter.Honor);
			if (rank != null)
			{
				num += (double)rank.Guard;
			}
			List<ItemInfo> allEquipItems = GetAllEquipItems();
			foreach (ItemInfo item in allEquipItems)
			{
				SubActiveConditionInfo subActiveInfo = SubActiveMgr.GetSubActiveInfo(item);
				if (subActiveInfo != null)
				{
					num += (double)subActiveInfo.GetValue("7");
				}
			}
			PlayerProp.totalArmor = (int)num;
			for (int i = 0; i < 31; i++)
			{
				ItemInfo ıtemAt = playerBeadInventory_0.GetItemAt(i);
				if (ıtemAt != null)
				{
					AddRuneProperty(ıtemAt, ref defence, ref attack);
				}
			}
			AvatarBag.AddBasePropAvatarColection(ref avatarGuard, ref attack);
			if (Horse.Info.curUseHorse > 0)
			{
				int curLevel = Horse.Info.curLevel;
				MountTemplateInfo mountTemplate = MountMgr.GetMountTemplate(curLevel);
				num3 += (double)mountTemplate.AddDamage;
			}
			MountDrawDataInfo[] getPicCherishs = Horse.GetPicCherishs;
			MountDrawDataInfo[] array = getPicCherishs;
			foreach (MountDrawDataInfo mountDrawDataInfo in array)
			{
				MountDrawTemplateInfo mountDrawTemplateInfo = MountMgr.FindMountDrawInfo(mountDrawDataInfo.ID);
				if (mountDrawTemplateInfo != null)
				{
					num4 += (double)mountDrawTemplateInfo.AddGuard;
				}
			}
			EatPetsInfo eatPets = PetBag.EatPets;
			if (eatPets != null)
			{
				PetMoePropertyInfo petMoePropertyInfo = PetMoePropertyMgr.FindPetMoeProperty(eatPets.hatLevel);
				if (petMoePropertyInfo != null)
				{
					num5 += (double)petMoePropertyInfo.Guard;
				}
			}
			PlayerProp.UpadateBaseProp(isSelf: true, "Armor", "Bead", defence);
			PlayerProp.UpadateBaseProp(isSelf: true, "Armor", "Suit", num2);
			PlayerProp.UpadateBaseProp(isSelf: true, "Armor", "Avatar", avatarGuard);
			PlayerProp.UpadateBaseProp(isSelf: true, "Armor", "Horse", num3);
			PlayerProp.UpadateBaseProp(isSelf: true, "Armor", "HorsePicCherish", num4);
			PlayerProp.UpadateBaseProp(isSelf: true, "Armor", "Pet", num5);
			List<UsersCardInfo> cards = cardInventory_0.GetCards(0, 5);
			foreach (UsersCardInfo item2 in cards)
			{
				if (item2.CardID > 0)
				{
					CardTemplateInfo cardTemplateInfo = CardMgr.FindCardTemplate(item2.TemplateID, item2.CardType);
					if (cardTemplateInfo != null)
					{
						num += (double)cardTemplateInfo.AddGuard;
					}
					num += (double)item2.Guard;
				}
			}
			num += (double)TotemMgr.GetTotemProp(playerInfo_0.totemId, "gua");
			ItemInfo ıtemAt2 = playerEquipInventory_0.GetItemAt(0);
			if (ıtemAt2 != null)
			{
				double num6 = ıtemAt2.Template.Property7;
				int num7 = (ıtemAt2.IsGold ? 1 : 0);
				double para = ıtemAt2.StrengthenLevel + num7;
				num += getHertAddition(num6, para) + num6;
			}
			ItemInfo ıtemAt3 = playerEquipInventory_0.GetItemAt(4);
			if (ıtemAt3 != null)
			{
				double num6 = ıtemAt3.Template.Property7;
				int num8 = (ıtemAt3.IsGold ? 1 : 0);
				double para2 = ıtemAt3.StrengthenLevel + num8;
				num += getHertAddition(num6, para2) + num6;
			}
			return (int)(num + defence + num2 + avatarGuard + num3 + num4);
		}

		public double GetBaseAgility()
		{
			return 1.0 - (double)playerInfo_0.Agility * 0.001;
		}

		public double GetBaseBlood()
		{
			ItemInfo ıtemAt = EquipBag.GetItemAt(12);
			if (ıtemAt == null)
			{
				return 1.0;
			}
			return (100.0 + (double)ıtemAt.Template.Property1 + (double)PlayerCharacter.necklaceExpAdd) / 100.0;
		}

		public double GetGoldBlood()
		{
			ItemInfo ıtemAt = EquipBag.GetItemAt(0);
			ItemInfo ıtemAt2 = EquipBag.GetItemAt(4);
			double num = 1.0;
			if (ıtemAt != null)
			{
				GoldEquipTemplateInfo goldEquipTemplateInfo = GoldEquipMgr.FindGoldEquipByTemplate(-1);
				if (ıtemAt.IsGold)
				{
					num += (double)goldEquipTemplateInfo.Boold;
				}
			}
			if (ıtemAt2 != null)
			{
				GoldEquipTemplateInfo goldEquipTemplateInfo = GoldEquipMgr.FindGoldEquipByTemplate(-1);
				if (ıtemAt2.IsGold)
				{
					num += (double)goldEquipTemplateInfo.Boold;
				}
			}
			return num;
		}

		public bool RemoveAt(eBageType bagType, int place)
		{
			PlayerInventory ınventory = GetInventory(bagType);
			if (ınventory == null)
			{
				return false;
			}
			if (place >= ınventory.Capalility)
			{
				return AvatarBag.RemoveItemAt(place);
			}
			return ınventory.RemoveItemAt(place);
		}

		public void UpdateBarrier(int barrier, string pic)
		{
			if (CurrentRoom != null)
			{
				CurrentRoom.Pic = pic;
				CurrentRoom.barrierNum = barrier;
				CurrentRoom.currentFloor = barrier;
			}
		}

		public bool DeletePropItem(int place)
		{
			FightBag.RemoveItemAt(place);
			return true;
		}

		public bool UseKingBlessHelpStraw(eRoomType roomType)
		{
			if (roomType == eRoomType.Lanbyrinth || roomType == eRoomType.Dungeon)
			{
				if (Extra.UseKingBless(4))
				{
					return true;
				}
				if (BufferList.UserSaveLifeBuff())
				{
					return true;
				}
			}
			return false;
		}

		public bool UsePropItem(AbstractGame game, int bag, int place, int templateId, bool isLiving)
		{
			if (bag == 1)
			{
				ItemTemplateInfo ıtemTemplateInfo = PropItemMgr.FindFightingProp(templateId);
				if (isLiving && ıtemTemplateInfo != null)
				{
					OnUsingItem(ıtemTemplateInfo.TemplateID);
					if (place == -1 && CanUseProp)
					{
						return true;
					}
					ItemInfo ıtemAt = GetItemAt(eBageType.PropBag, place);
					if (ıtemAt != null && ıtemAt.IsValidItem() && ıtemAt.Count >= 0)
					{
						ıtemAt.Count--;
						UpdateItem(ıtemAt);
						return true;
					}
				}
			}
			else
			{
				ItemInfo ıtemAt2 = GetItemAt(eBageType.FightBag, place);
				if (ıtemAt2 != null && ıtemAt2.TemplateID == templateId)
				{
					if (IsSpecialPropItem(templateId))
					{
						if (templateId == 10615 || templateId == 10616)
						{
							ıtemAt2 = GetItemAt(eBageType.PropBag, place);
							if (ıtemAt2 != null)
							{
								RemoveTemplate(templateId, 1);
							}
						}
						return true;
					}
					OnUsingItem(ıtemAt2.TemplateID);
					return RemoveAt(eBageType.FightBag, place);
				}
			}
			return false;
		}

		public bool IsSpecialPropItem(int templateID)
		{
			switch (templateID)
			{
			case 10467:
			case 10468:
			case 10469:
			case 10471:
				return true;
			case 10615:
			case 10616:
				return true;
			default:
				return false;
			}
		}

		public bool ClearPropItem()
		{
			FightBag.ClearBag();
			return true;
		}

		public void Disconnect()
		{
			m_client.Disconnect();
		}

		public void SendTCP(GSPacketIn pkg)
		{
			if (m_client.IsConnected)
			{
				m_client.SendTCP(pkg);
			}
		}

		public void ClearFootballCard()
		{
			for (int i = 0; i < CardsTakeOut.Length; i++)
			{
				CardsTakeOut[i] = null;
			}
		}

		public void TakeFootballCard(CardsTakeOutInfo card)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			for (int i = 0; i < CardsTakeOut.Length; i++)
			{
				if (card.place == i)
				{
					CardsTakeOut[i] = card;
					CardsTakeOut[i].IsTake = true;
					ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(card.templateID);
					if (ıtemTemplateInfo != null)
					{
						list.Add(ItemInfo.CreateFromTemplate(ıtemTemplateInfo, card.count, 110));
					}
					takeoutCount--;
					break;
				}
			}
			if (list.Count <= 0)
			{
				return;
			}
			foreach (ItemInfo item in list)
			{
				AddTemplate(list);
			}
		}

		public void ShowAllFootballCard()
		{
			for (int i = 0; i < CardsTakeOut.Length; i++)
			{
				if (CardsTakeOut[i] == null)
				{
					CardsTakeOut[i] = Card[i];
					if (takeoutCount > 0)
					{
						TakeFootballCard(Card[i]);
					}
				}
			}
		}

		public void FootballTakeOut(bool isWin)
		{
			if (isWin)
			{
				canTakeOut = 2;
				takeoutCount = 2;
			}
			else
			{
				canTakeOut = 1;
				takeoutCount = 1;
			}
		}

		public void ResetRoom(bool isWin, bool nextMission)
		{
			if (CurrentRoom != null)
			{
				if (CurrentRoom.RoomType == eRoomType.Cryptboss)
				{
					RoomMgr.ExitRoom(CurrentRoom, this);
				}
				if (CurrentRoom.RoomType == eRoomType.ActivityDungeon)
				{
					Actives.method_6();
				}
				if (CurrentRoom.RoomType == eRoomType.FarmBoss)
				{
					Farm.SendFarmPoultryAward(isWin);
				}
			}
		}

		public void DirectAddValue(SpecialItemBoxInfo values)
		{
			if (values.Money > 0)
			{
				SendMessage(values.Money + LanguageMgr.GetTranslation("OpenUpArkHandler.Money"));
				AddMoney(values.Money);
			}
			if (values.Gold != 0)
			{
				SendMessage(values.Gold + LanguageMgr.GetTranslation("OpenUpArkHandler.Gold"));
				AddGold(values.Gold);
			}
			if (values.DDTMoney != 0)
			{
				SendMessage(values.DDTMoney + LanguageMgr.GetTranslation("OpenUpArkHandler.GiftToken"));
				AddGiftToken(values.DDTMoney);
			}
			if (values.Medal != 0)
			{
				SendMessage(values.Medal + LanguageMgr.GetTranslation("OpenUpArkHandler.Medal"));
				AddMedal(values.Medal);
			}
			if (values.Exp != 0)
			{
				if (Level == LevelMgr.MaxLevel)
				{
					int num = values.Exp / 100;
					if (num > 0)
					{
						AddOffer(num);
						SendMessage(eMessageType.notAgain, LanguageMgr.GetTranslation("OpenUpArkHandler.MaxExp", num));
					}
				}
				else
				{
					AddGP(values.Exp);
					SendMessage(values.Exp + LanguageMgr.GetTranslation("OpenUpArkHandler.Exp"));
				}
			}
			if (values.Honor != 0)
			{
				SendMessage(values.Honor + LanguageMgr.GetTranslation("OpenUpArkHandler.honor"));
				AddHonor(values.Honor);
			}
			if (values.HardCurrency != 0)
			{
				SendMessage(values.HardCurrency + LanguageMgr.GetTranslation("OpenUpArkHandler.hardCurrency"));
				AddHardCurrency(values.HardCurrency);
			}
			if (values.LeagueMoney != 0)
			{
				SendMessage(values.LeagueMoney + LanguageMgr.GetTranslation("OpenUpArkHandler.leagueMoney"));
				AddLeagueMoney(values.LeagueMoney);
			}
			if (values.UseableScore != 0)
			{
				SendMessage(values.UseableScore + LanguageMgr.GetTranslation("OpenUpArkHandler.useableScore"));
				Actives.Info.useableScore += values.UseableScore;
			}
			if (values.Prestge != 0)
			{
				SendMessage(values.Prestge + LanguageMgr.GetTranslation("OpenUpArkHandler.prestge"));
				MatchInfo.addDayPrestge += values.Prestge;
				MatchInfo.totalPrestige += values.Prestge;
			}
			if (values.LoveScore != 0)
			{
				SendMessage(values.LoveScore + LanguageMgr.GetTranslation("OpenUpArkHandler.LoveScore"));
				Farm.AddLoveScore(values.LoveScore);
			}
			if (values.MagicstoneScore != 0)
			{
				SendMessage(values.MagicstoneScore + LanguageMgr.GetTranslation("OpenUpArkHandler.MagicstoneScore"));
				Extra.Info.ScoreMagicstone += values.MagicstoneScore;
			}
			if (values.SummerScore != 0)
			{
				SendMessage(values.MagicstoneScore + LanguageMgr.GetTranslation("OpenUpArkHandler.SummerScore"));
				Extra.Info.SummerScore += values.SummerScore;
			}
		}

		public void DirectRemoveValue(SpecialItemBoxInfo values)
		{
			if (values.Money > 0)
			{
				RemoveMoney(values.Money);
			}
			if (values.Gold != 0)
			{
				RemoveGold(values.Gold);
			}
			if (values.DDTMoney != 0)
			{
				RemoveGiftToken(values.DDTMoney);
			}
			if (values.Medal != 0)
			{
				RemoveMedal(values.Medal);
			}
			if (values.Exp != 0)
			{
				RemoveGP(values.Exp);
			}
			if (values.Honor != 0)
			{
				RemoveHonor(values.Honor);
			}
			if (values.HardCurrency != 0)
			{
				RemoveHardCurrency(values.HardCurrency);
			}
			if (values.LeagueMoney != 0)
			{
				RemoveLeagueMoney(values.LeagueMoney);
			}
			if (values.UseableScore != 0)
			{
				Actives.Info.useableScore -= values.UseableScore;
			}
			if (values.PetScore != 0)
			{
				RemovePetScore(values.PetScore);
			}
			if (values.DamageScore != 0)
			{
				RemoveDamageScores(values.DamageScore);
			}
			if (values.Prestge != 0)
			{
				MatchInfo.addDayPrestge -= values.Prestge;
				MatchInfo.totalPrestige -= values.Prestge;
			}
			if (values.LoveScore != 0)
			{
				Farm.RemoveLoveScore(values.LoveScore);
			}
			if (values.MagicstoneScore != 0)
			{
				Extra.Info.ScoreMagicstone -= values.MagicstoneScore;
			}
			if (values.SummerScore != 0)
			{
				Extra.Info.SummerScore -= values.SummerScore;
			}
		}

		public void LoadMarryProp()
		{
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			MarryProp marryProp = playerBussiness.GetMarryProp(PlayerCharacter.ID);
			PlayerCharacter.IsMarried = marryProp.IsMarried;
			PlayerCharacter.SpouseID = marryProp.SpouseID;
			PlayerCharacter.SpouseName = marryProp.SpouseName;
			PlayerCharacter.IsCreatedMarryRoom = marryProp.IsCreatedMarryRoom;
			PlayerCharacter.SelfMarryRoomID = marryProp.SelfMarryRoomID;
			PlayerCharacter.IsGotRing = marryProp.IsGotRing;
			Out.SendMarryProp(this, marryProp);
		}

		public override string ToString()
		{
			return $"Id:{PlayerId} nickname:{PlayerCharacter.NickName} room:{CurrentRoom} ";
		}

		public int ConsortiaFight(int consortiaWin, int consortiaLose, Dictionary<int, Player> players, eRoomType roomType, eGameType gameClass, int totalKillHealth, int count)
		{
			return ConsortiaMgr.ConsortiaFight(consortiaWin, consortiaLose, players, roomType, gameClass, totalKillHealth, count);
		}

		public void SendConsortiaFight(int consortiaID, int riches, string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(158);
			gSPacketIn.WriteInt(consortiaID);
			gSPacketIn.WriteInt(riches);
			gSPacketIn.WriteString(msg);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
		}

		public void LoadPvePermission()
		{
			PveInfo[] pveInfo = PveInfoMgr.GetPveInfo();
			PveInfo[] array = pveInfo;
			foreach (PveInfo pveInfo2 in array)
			{
				if (playerInfo_0.Grade > pveInfo2.LevelLimits)
				{
					bool flag;
					if (flag = SetPvePermission(pveInfo2.ID, eHardLevel.Easy))
					{
						flag = SetPvePermission(pveInfo2.ID, eHardLevel.Normal);
					}
					if (flag)
					{
						flag = SetPvePermission(pveInfo2.ID, eHardLevel.Hard);
					}
				}
			}
		}

		public char[] InitPvePermission()
		{
			char[] array = new char[50];
			for (int i = 0; i < array.Length; i++)
			{
				array[i] = '1';
			}
			return array;
		}

		public string ConverterPvePermission(char[] chArray)
		{
			string text = "";
			for (int i = 0; i < chArray.Length; i++)
			{
				text += chArray[i];
			}
			return text;
		}

		public bool SetPvePermission(int copyId, eHardLevel hardLevel)
		{
			if (hardLevel == eHardLevel.Epic)
			{
				return true;
			}
			if (copyId <= char_0.Length && copyId > 0 && hardLevel != eHardLevel.Terror && char_0[copyId - 1] == char_1[(int)hardLevel])
			{
				char_0[copyId - 1] = char_1[(int)(hardLevel + 1)];
				playerInfo_0.PvePermission = ConverterPvePermission(char_0);
				OnPropertiesChanged();
				return true;
			}
			return true;
		}

		public bool IsPvePermission(int copyId, eHardLevel hardLevel)
		{
			if (copyId > char_0.Length || copyId <= 0)
			{
				return true;
			}
			if (hardLevel == eHardLevel.Epic)
			{
				return IsPveEpicPermission(copyId);
			}
			return char_0[copyId - 1] >= char_1[(int)hardLevel];
		}

		public bool IsPveEpicPermission(int copyId)
		{
			string pveEpicPermission = playerInfo_0.PveEpicPermission;
			bool result = false;
			if (pveEpicPermission.Length > 0)
			{
				string[] array = pveEpicPermission.Split('-');
				string[] array2 = array;
				foreach (string text in array2)
				{
					if (text == copyId.ToString())
					{
						result = true;
						break;
					}
				}
			}
			return result;
		}

		public void SendInsufficientMoney(int type)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(88, PlayerId);
			gSPacketIn.WriteByte((byte)type);
			gSPacketIn.WriteBoolean(val: false);
			SendTCP(gSPacketIn);
		}

		public void SendMessage(string msg)
		{
			SendMessage(eMessageType.Normal, msg);
		}

		public void SendMessage(eMessageType type, string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(3);
			gSPacketIn.WriteInt((int)type);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
		}

		public void SendPrivateChat(int receiverID, string receiver, string sender, string msg, bool isAutoReply)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(37, PlayerCharacter.ID);
			gSPacketIn.WriteInt(receiverID);
			gSPacketIn.WriteString(receiver);
			gSPacketIn.WriteString(sender);
			gSPacketIn.WriteString(msg);
			gSPacketIn.WriteBoolean(isAutoReply);
			SendTCP(gSPacketIn);
		}

		public void SendAreaPrivateChat(string sender, string zoneName, string msg, int zoneID)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(107, PlayerCharacter.ID);
			gSPacketIn.WriteString(zoneName);
			gSPacketIn.WriteString(sender);
			gSPacketIn.WriteString(msg);
			gSPacketIn.WriteInt(zoneID);
			SendTCP(gSPacketIn);
		}

		public void SendHideMessage(string msg)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(3);
			gSPacketIn.WriteInt(3);
			gSPacketIn.WriteString(msg);
			SendTCP(gSPacketIn);
		}

		public int LabyrinthTryAgainMoney()
		{
			for (int i = 0; i < Labyrinth.myProgress; i += 2)
			{
				if (Labyrinth.currentFloor == i)
				{
					return GameProperties.WarriorFamRaidPriceBig;
				}
			}
			return GameProperties.WarriorFamRaidPriceSmall;
		}

		public void SendLabyrinthTryAgain()
		{
			GSPacketIn gSPacketIn = new GSPacketIn(131, PlayerId);
			gSPacketIn.WriteByte(9);
			gSPacketIn.WriteInt(LabyrinthTryAgainMoney());
			SendTCP(gSPacketIn);
		}

		public bool SendMoneyMailToUser(PlayerBussiness pb, string content, string title, int money, eMailType type)
		{
			MailInfo mailInfo = new MailInfo();
			mailInfo.Content = content;
			mailInfo.Title = title;
			mailInfo.Gold = 0;
			mailInfo.IsExist = true;
			mailInfo.Money = money;
			mailInfo.GiftToken = 0;
			mailInfo.Receiver = PlayerCharacter.NickName;
			mailInfo.ReceiverID = PlayerCharacter.ID;
			mailInfo.Sender = PlayerCharacter.NickName;
			mailInfo.SenderID = PlayerCharacter.ID;
			mailInfo.Type = (int)type;
			MailInfo mailInfo2 = mailInfo;
			mailInfo2.Annex1 = "";
			mailInfo2.String_0 = "";
			return pb.SendMail(mailInfo2);
		}

		public bool SendItemsToMail(List<ItemInfo> items, string content, string title, eMailType type)
		{
			using PlayerBussiness pb = new PlayerBussiness();
			List<ItemInfo> list = new List<ItemInfo>();
			foreach (ItemInfo item in items)
			{
				if (item.Template.MaxCount == 1)
				{
					for (int i = 0; i < item.Count; i++)
					{
						ItemInfo ıtemInfo = ItemInfo.CloneFromTemplate(item.Template, item);
						ıtemInfo.Count = 1;
						list.Add(ıtemInfo);
					}
				}
				else
				{
					list.Add(item);
				}
			}
			return SendItemsToMail(list, content, title, type, pb);
		}

		public bool SendItemsToMail(List<ItemInfo> items, string content, string title, eMailType type, PlayerBussiness pb)
		{
			bool result = true;
			for (int i = 0; i < items.Count; i += 5)
			{
				MailInfo mailInfo = new MailInfo();
				mailInfo.Title = ((title != null) ? title : LanguageMgr.GetTranslation("Game.Server.GameUtils.Title"));
				mailInfo.Gold = 0;
				mailInfo.IsExist = true;
				mailInfo.Money = 0;
				mailInfo.Receiver = PlayerCharacter.NickName;
				mailInfo.ReceiverID = PlayerId;
				mailInfo.Sender = PlayerCharacter.NickName;
				mailInfo.SenderID = PlayerId;
				mailInfo.Type = (int)type;
				mailInfo.GiftToken = 0;
				MailInfo mailInfo2 = mailInfo;
				List<ItemInfo> list = new List<ItemInfo>();
				StringBuilder stringBuilder = new StringBuilder();
				StringBuilder stringBuilder2 = new StringBuilder();
				stringBuilder.Append(LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.AnnexRemark"));
				content = ((content != null) ? LanguageMgr.GetTranslation(content) : "");
				int num = i;
				if (items.Count > num)
				{
					ItemInfo ıtemInfo = items[num];
					if (ıtemInfo.ItemID == 0)
					{
						pb.AddGoods(ıtemInfo);
					}
					else
					{
						list.Add(ıtemInfo);
					}
					mailInfo2.Title = ıtemInfo.Template.Name;
					mailInfo2.Annex1 = ıtemInfo.ItemID.ToString();
					mailInfo2.String_0 = ıtemInfo.Template.Name;
					stringBuilder.Append("1、" + mailInfo2.String_0 + "x" + ıtemInfo.Count + ";");
					stringBuilder2.Append("1、" + mailInfo2.String_0 + "x" + ıtemInfo.Count + ";");
				}
				num = i + 1;
				if (items.Count > num)
				{
					ItemInfo ıtemInfo = items[num];
					if (ıtemInfo.ItemID == 0)
					{
						pb.AddGoods(ıtemInfo);
					}
					else
					{
						list.Add(ıtemInfo);
					}
					mailInfo2.Annex2 = ıtemInfo.ItemID.ToString();
					mailInfo2.String_1 = ıtemInfo.Template.Name;
					stringBuilder.Append("2、" + mailInfo2.String_1 + "x" + ıtemInfo.Count + ";");
					stringBuilder2.Append("2、" + mailInfo2.String_1 + "x" + ıtemInfo.Count + ";");
				}
				num = i + 2;
				if (items.Count > num)
				{
					ItemInfo ıtemInfo = items[num];
					if (ıtemInfo.ItemID == 0)
					{
						pb.AddGoods(ıtemInfo);
					}
					else
					{
						list.Add(ıtemInfo);
					}
					mailInfo2.Annex3 = ıtemInfo.ItemID.ToString();
					mailInfo2.String_2 = ıtemInfo.Template.Name;
					stringBuilder.Append("3、" + mailInfo2.String_2 + "x" + ıtemInfo.Count + ";");
					stringBuilder2.Append("3、" + mailInfo2.String_2 + "x" + ıtemInfo.Count + ";");
				}
				num = i + 3;
				if (items.Count > num)
				{
					ItemInfo ıtemInfo = items[num];
					if (ıtemInfo.ItemID == 0)
					{
						pb.AddGoods(ıtemInfo);
					}
					else
					{
						list.Add(ıtemInfo);
					}
					mailInfo2.Annex4 = ıtemInfo.ItemID.ToString();
					mailInfo2.String_3 = ıtemInfo.Template.Name;
					stringBuilder.Append("4、" + mailInfo2.String_3 + "x" + ıtemInfo.Count + ";");
					stringBuilder2.Append("4、" + mailInfo2.String_3 + "x" + ıtemInfo.Count + ";");
				}
				num = i + 4;
				if (items.Count > num)
				{
					ItemInfo ıtemInfo = items[num];
					if (ıtemInfo.ItemID == 0)
					{
						pb.AddGoods(ıtemInfo);
					}
					else
					{
						list.Add(ıtemInfo);
					}
					mailInfo2.Annex5 = ıtemInfo.ItemID.ToString();
					mailInfo2.String_4 = ıtemInfo.Template.Name;
					stringBuilder.Append("5、" + mailInfo2.String_4 + "x" + ıtemInfo.Count + ";");
					stringBuilder2.Append("5、" + mailInfo2.String_4 + "x" + ıtemInfo.Count + ";");
				}
				mailInfo2.AnnexRemark = stringBuilder.ToString();
				if (content == null && stringBuilder2.ToString() == null)
				{
					mailInfo2.Content = LanguageMgr.GetTranslation("Game.Server.GameUtils.Content");
				}
				else if (content != "")
				{
					mailInfo2.Content = content;
				}
				else
				{
					mailInfo2.Content = stringBuilder2.ToString();
				}
				if (pb.SendMail(mailInfo2))
				{
					foreach (ItemInfo item in list)
					{
						TakeOutItem(item);
					}
				}
				else
				{
					result = false;
				}
			}
			return result;
		}

		public bool SendItemToMail(int templateID, string content, string title)
		{
			ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(templateID);
			if (ıtemTemplateInfo == null)
			{
				return false;
			}
			if (content == "")
			{
				content = ıtemTemplateInfo.Name + "x1";
			}
			ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, 1, 104);
			ıtemInfo.IsBinds = true;
			return SendItemToMail(ıtemInfo, content, title, eMailType.Active);
		}

		public bool SendItemToMail(ItemInfo item, string content, string title, eMailType type)
		{
			using PlayerBussiness pb = new PlayerBussiness();
			return SendItemToMail(item, pb, content, title, type);
		}

		public bool SendItemToMail(ItemInfo item, PlayerBussiness pb, string content, string title, eMailType type)
		{
			MailInfo mailInfo = new MailInfo();
			mailInfo.Content = ((content != null) ? content : LanguageMgr.GetTranslation("Game.Server.GameUtils.Content"));
			mailInfo.Title = ((title != null) ? title : LanguageMgr.GetTranslation("Game.Server.GameUtils.Title"));
			mailInfo.Gold = 0;
			mailInfo.IsExist = true;
			mailInfo.Money = 0;
			mailInfo.GiftToken = 0;
			mailInfo.Receiver = PlayerCharacter.NickName;
			mailInfo.ReceiverID = PlayerCharacter.ID;
			mailInfo.Sender = PlayerCharacter.NickName;
			mailInfo.SenderID = PlayerCharacter.ID;
			mailInfo.Type = (int)type;
			MailInfo mailInfo2 = mailInfo;
			if (item.ItemID == 0)
			{
				pb.AddGoods(item);
			}
			mailInfo2.Annex1 = item.ItemID.ToString();
			mailInfo2.String_0 = item.Template.Name;
			if (pb.SendMail(mailInfo2))
			{
				TakeOutItem(item);
				return true;
			}
			return false;
		}

		public bool SendMailToUser(PlayerBussiness pb, string content, string title, eMailType type)
		{
			MailInfo mailInfo = new MailInfo();
			mailInfo.Content = content;
			mailInfo.Title = title;
			mailInfo.Gold = 0;
			mailInfo.IsExist = true;
			mailInfo.Money = 0;
			mailInfo.GiftToken = 0;
			mailInfo.Receiver = PlayerCharacter.NickName;
			mailInfo.ReceiverID = PlayerCharacter.ID;
			mailInfo.Sender = PlayerCharacter.NickName;
			mailInfo.SenderID = PlayerCharacter.ID;
			mailInfo.Type = (int)type;
			MailInfo mailInfo2 = mailInfo;
			mailInfo2.Annex1 = "";
			mailInfo2.String_0 = "";
			return pb.SendMail(mailInfo2);
		}

		public bool TakeOutItem(ItemInfo item)
		{
			if (item.BagType == playerInventory_0.BagType)
			{
				return playerInventory_0.TakeOutItem(item);
			}
			if (item.BagType == playerInventory_1.BagType)
			{
				return playerInventory_1.TakeOutItem(item);
			}
			if (item.BagType == playerInventory_2.BagType)
			{
				return playerInventory_2.TakeOutItem(item);
			}
			if (item.BagType == playerBeadInventory_0.BagType)
			{
				return playerBeadInventory_0.TakeOutItem(item);
			}
			return playerEquipInventory_0.TakeOutItem(item);
		}

		public bool RemoveCountFromStack(ItemInfo item, int count)
		{
			if (item.BagType == playerInventory_0.BagType)
			{
				return playerInventory_0.RemoveCountFromStack(item, count);
			}
			if (item.BagType == playerInventory_2.BagType)
			{
				return playerInventory_2.RemoveCountFromStack(item, count);
			}
			if (item.BagType == playerBeadInventory_0.BagType)
			{
				return playerBeadInventory_0.RemoveCountFromStack(item, count);
			}
			return playerEquipInventory_0.RemoveCountFromStack(item, count);
		}

		public int isInLimitTimes()
		{
			int num = 10000;
			if (!PlayerCharacter.method_0())
			{
				num += int.Parse(GameProperties.VIPQuestFinishDirect.Split('|')[PlayerCharacter.VIPLevel - 1]);
			}
			return num - PlayerCharacter.uesedFinishTime;
		}

		public void AddGift(eGiftType type)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			bool testActive = GameProperties.TestActive;
			switch (type)
			{
			case eGiftType.MONEY:
				if (testActive)
				{
					AddMoney(GameProperties.FreeMoney);
				}
				break;
			case eGiftType.SMALL_EXP:
			{
				string[] array = GameProperties.FreeExp.Split('|');
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(Convert.ToInt32(array[0]));
				if (ıtemTemplateInfo != null)
				{
					list.Add(ItemInfo.CreateFromTemplate(ıtemTemplateInfo, Convert.ToInt32(array[1]), 102));
				}
				break;
			}
			case eGiftType.BIG_EXP:
			{
				string[] array = GameProperties.BigExp.Split('|');
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(Convert.ToInt32(array[0]));
				if (ıtemTemplateInfo != null && testActive)
				{
					list.Add(ItemInfo.CreateFromTemplate(ıtemTemplateInfo, Convert.ToInt32(array[1]), 102));
				}
				break;
			}
			case eGiftType.PET_EXP:
			{
				string[] array = GameProperties.PetExp.Split('|');
				ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(Convert.ToInt32(array[0]));
				if (ıtemTemplateInfo != null && testActive)
				{
					list.Add(ItemInfo.CreateFromTemplate(ıtemTemplateInfo, Convert.ToInt32(array[1]), 102));
				}
				break;
			}
			case eGiftType.NEWBIE:
				if (!GameProperties.NewbieEnable && playerInfo_0.Grade < GameProperties.BeginLevel)
				{
					LevelInfo levelInfo = LevelMgr.FindLevel(GameProperties.BeginLevel);
					if (levelInfo != null)
					{
						AddGP(levelInfo.GP);
					}
					SendMessage(LanguageMgr.GetTranslation("AddGift.RemoveNewbie"));
				}
				break;
			}
			foreach (ItemInfo item in list)
			{
				item.IsBinds = true;
				AddTemplate(item, item.Template.BagType, item.Count, eGameView.dungeonTypeGet);
			}
		}

		public void OnLevelUp(int grade)
		{
			if (playerEventHandle_1 != null)
			{
				playerEventHandle_1(this);
			}
		}

		public void OnUsingItem(int templateID)
		{
			if (playerItemPropertyEventHandle_0 != null)
			{
				playerItemPropertyEventHandle_0(templateID);
			}
		}

		public void OnGameOver(AbstractGame game, bool isWin, int gainXp)
		{
			if (game.RoomType == eRoomType.Match)
			{
				if (isWin)
				{
					playerInfo_0.Win++;
				}
				playerInfo_0.Total++;
			}
			if (playerGameOverEventHandle_0 != null)
			{
				playerGameOverEventHandle_0(game, isWin, gainXp);
			}
		}

		public void OnMissionOver(AbstractGame game, bool isWin, int missionId, int turnNum)
		{
			if (playerMissionOverEventHandle_0 != null)
			{
				playerMissionOverEventHandle_0(game, missionId, isWin);
			}
			if (playerMissionFullOverEventHandle_0 != null)
			{
				playerMissionFullOverEventHandle_0(game, missionId, isWin, turnNum);
			}
			if (playerMissionTurnOverEventHandle_0 != null && isWin)
			{
				playerMissionTurnOverEventHandle_0(game, missionId, turnNum);
			}
		}

		public void OnQuestOneKeyFinishEvent(QuestConditionInfo condition)
		{
			if (playerQuestOneKeyFinishEventHandle_0 != null)
			{
				playerQuestOneKeyFinishEventHandle_0(condition);
			}
		}

		public void OnItemStrengthen(int categoryID, int level)
		{
			if (playerItemStrengthenEventHandle_0 != null)
			{
				playerItemStrengthenEventHandle_0(categoryID, level);
			}
		}

		public void OnPaid(int money, int gold, int offer, int gifttoken, int medal, string payGoods)
		{
			if (playerShopEventHandle_0 != null)
			{
				playerShopEventHandle_0(money, gold, offer, gifttoken, medal, payGoods);
			}
		}

		public void OnAdoptPetEvent()
		{
			if (playerAdoptPetEventHandle_0 != null)
			{
				playerAdoptPetEventHandle_0();
			}
		}

		public void OnNewGearEvent(int CategoryID)
		{
			if (playerNewGearEventHandle_0 != null)
			{
				playerNewGearEventHandle_0(CategoryID);
			}
		}

		public void OnCropPrimaryEvent()
		{
			if (playerCropPrimaryEventHandle_0 != null)
			{
				playerCropPrimaryEventHandle_0();
			}
		}

		public void OnSeedFoodPetEvent()
		{
			if (playerSeedFoodPetEventHandle_0 != null)
			{
				playerSeedFoodPetEventHandle_0();
			}
		}

		public void OnUserToemGemstoneEvent(int type)
		{
			if (playerUserToemGemstoneEventHandle_0 != null)
			{
				playerUserToemGemstoneEventHandle_0(type);
			}
		}

		public void OnCollectionTaskEvent(int type)
		{
			if (playerCollectionTaskEventHandle_0 != null)
			{
				playerCollectionTaskEventHandle_0(type);
			}
		}

		public void OnUpLevelPetEvent()
		{
			if (playerUpLevelPetEventHandle_0 != null)
			{
				playerUpLevelPetEventHandle_0();
			}
		}

		public void OnItemInsert()
		{
			if (playerItemInsertEventHandle_0 != null)
			{
				playerItemInsertEventHandle_0();
			}
		}

		public void OnItemFusion(int fusionType)
		{
			if (playerItemFusionEventHandle_0 != null)
			{
				playerItemFusionEventHandle_0(fusionType);
			}
		}

		public void OnItemMelt(int categoryID)
		{
			if (playerItemMeltEventHandle_0 != null)
			{
				playerItemMeltEventHandle_0(categoryID);
			}
		}

		public void OnKillingLiving(AbstractGame game, int type, int id, bool isLiving, int damage)
		{
			if (playerGameKillEventHandel_0 != null)
			{
				playerGameKillEventHandel_0(game, type, id, isLiving, damage);
			}
			if (gameKillDropEventHandel_0 != null && !isLiving)
			{
				gameKillDropEventHandel_0(game, type, id, isLiving);
			}
		}

		public void OnGuildChanged()
		{
			if (playerOwnConsortiaEventHandle_0 != null)
			{
				playerOwnConsortiaEventHandle_0();
			}
		}

		public void OnItemCompose(int composeType)
		{
			if (playerItemComposeEventHandle_0 != null)
			{
				playerItemComposeEventHandle_0(composeType);
			}
		}

		public void OnAchievementFinish(AchievementDataInfo info)
		{
			if (playerAchievementFinish_0 != null)
			{
				playerAchievementFinish_0(info);
			}
		}

		public void OnFightAddOffer(int offer)
		{
			if (MlcxAudlJc != null)
			{
				MlcxAudlJc(offer);
			}
		}

		public void OnFightOneBloodIsWin(eRoomType roomType)
		{
			if (playerFightOneBloodIsWin_0 != null)
			{
				playerFightOneBloodIsWin_0(roomType);
			}
		}

		public void OnVIPUpgrade(int level, int exp)
		{
			if (ceKxNurgYN != null)
			{
				ceKxNurgYN(level, exp);
			}
		}

		public void OnHotSpingExpAdd(int minutes, int exp)
		{
			if (playerHotSpingExpAdd_0 != null)
			{
				playerHotSpingExpAdd_0(minutes, exp);
			}
		}

		public void OnGoldCollect(int value)
		{
			if (playerGoldCollection_0 != null)
			{
				playerGoldCollection_0(value);
			}
		}

		public void OnGiftTokenCollect(int value)
		{
			if (playerGiftTokenCollection_0 != null)
			{
				playerGiftTokenCollection_0(value);
			}
		}

		public void OnPingTimeOnline()
		{
			if (playerEventHandle_2 != null)
			{
				playerEventHandle_2(this);
			}
		}

		public void OnPropertisChange()
		{
			if (playerPropertisChange_0 != null)
			{
				playerPropertisChange_0(PlayerCharacter);
			}
		}

		public void OnQuestFinish(QuestDataInfo data, QuestInfo info)
		{
			if (playerQuestFinish_0 != null)
			{
				playerQuestFinish_0(data, info);
			}
		}

		public void OnUseBugle(int value)
		{
			if (playerUseBugle_0 != null)
			{
				playerUseBugle_0(value);
			}
		}

		static GamePlayer()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			char_1 = new char[4] { '1', '3', '7', 'F' };
		}
	}
}
