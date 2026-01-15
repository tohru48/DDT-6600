// Decompiled with JetBrains decompiler
// Type: Fighting.Server.GameObjects.ProxyPlayer
// Assembly: Fighting.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 73143BA9-1DDF-481C-AA0E-6BDD7564C4BE
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\fight\Fighting.Server.dll

using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

#nullable disable
namespace Fighting.Server.GameObjects
{
  public class ProxyPlayer : IGamePlayer
  {
    private ServerClient serverClient_0;
    private PlayerInfo playerInfo_0;
    private UserMatchInfo userMatchInfo_0;
    private ItemInfo lXblLoBye;
    private ItemInfo itemInfo_0;
    private ItemInfo itemInfo_1;
    private UsersPetinfo usersPetinfo_0;
    private bool bool_0;
    private int int_0;
    private double double_0;
    private double double_1;
    public double m_antiAddictionRate;
    public List<BufferInfo> Buffers;
    public int m_serverid;
    public string RedFightFootballStyle;
    public string BlueFightFootballStyle;
    private int[] int_1;
    private string string_0;
    private bool bool_1;
    private int int_2;
    private bool bool_2;
    private int int_3;
    private string string_1;
    private List<BufferInfo> list_0;
    private BatleConfigInfo batleConfigInfo_0;
    private double double_2;
    private double double_3;
    private double double_4;
    private double double_5;
    private List<ItemInfo> list_1;

    public int ServerID
    {
      get => this.m_serverid;
      set => this.m_serverid = value;
    }

    public int[] HorseSkillEquip => this.int_1;

    public int GamePlayerId
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this.serverClient_0.SendGamePlayerId((IGamePlayer) this);
      }
    }

    public bool IsCrossZone
    {
      get => this.bool_2;
      set => this.bool_2 = value;
    }

    public int ZoneId => this.int_3;

    public string ZoneName => this.string_1;

    public PlayerInfo PlayerCharacter => this.playerInfo_0;

    public List<BufferInfo> FightBuffs => this.list_0;

    public UserMatchInfo MatchInfo => this.userMatchInfo_0;

    public ItemInfo MainWeapon => this.lXblLoBye;

    public ItemInfo SecondWeapon => this.itemInfo_0;

    public ItemInfo Healstone => this.itemInfo_1;

    public UsersPetinfo Pet => this.usersPetinfo_0;

    public BatleConfigInfo BatleConfig => this.batleConfigInfo_0;

    public long WorldbossBood => 0;

    public long AllWorldDameBoss => 0;

    public double BaseAttack => this.double_3;

    public double BaseDefence => this.double_4;

    public string ProcessLabyrinthAward { get; set; }

    public bool CanUseProp
    {
      get => this.bool_0;
      set => this.bool_0 = value;
    }

    public List<ItemInfo> EquipEffect => this.list_1;

    public ProxyPlayer(
      ServerClient client,
      PlayerInfo character,
      UserMatchInfo matchInfo,
      ProxyPlayerInfo proxyPlayer,
      UsersPetinfo pet,
      List<BufferInfo> infos,
      List<ItemInfo> euipEffects,
      List<BufferInfo> fightBuffs,
      List<int> horseSkill,
      BatleConfigInfo batleConfig)
    {
      this.serverClient_0 = client;
      this.playerInfo_0 = character;
      this.userMatchInfo_0 = matchInfo;
      this.usersPetinfo_0 = pet;
      this.m_serverid = proxyPlayer.ServerId;
      this.double_3 = proxyPlayer.BaseAttack;
      this.double_4 = proxyPlayer.BaseDefence;
      this.double_2 = proxyPlayer.BaseAgility;
      this.double_5 = proxyPlayer.BaseBlood;
      this.lXblLoBye = proxyPlayer.GetItemTemplateInfo();
      this.itemInfo_0 = proxyPlayer.GetItemInfo();
      this.itemInfo_1 = proxyPlayer.GetHealstone();
      this.double_0 = proxyPlayer.Double_0;
      this.int_3 = proxyPlayer.ZoneId;
      this.string_1 = proxyPlayer.ZoneName;
      this.double_1 = proxyPlayer.OfferAddPlus;
      this.m_antiAddictionRate = proxyPlayer.AntiAddictionRate;
      this.list_1 = euipEffects;
      this.Buffers = infos;
      this.list_0 = fightBuffs;
      this.RedFightFootballStyle = proxyPlayer.RedFootballStyle;
      this.BlueFightFootballStyle = proxyPlayer.BlueFootballStyle;
      this.int_1 = horseSkill.ToArray();
      this.string_0 = proxyPlayer.TcpEndPoint;
      this.int_2 = proxyPlayer.DragonBoatAddExpPlus;
      this.bool_1 = proxyPlayer.DragonBoatOpen;
      this.bool_2 = false;
      this.batleConfigInfo_0 = batleConfig;
    }

    public int AddSummerScore(int value) => value;

    public double GetBaseAgility() => this.double_2;

    public bool UseKingBlessHelpStraw(eRoomType roomType) => false;

    public bool RemoveMissionEnergy(int value) => false;

    public bool MissionEnergyEmpty(int value) => false;

    public void CreateRandomEnterModeItem()
    {
    }

    public int AddEnterModePoint(int value) => 0;

    public void ClearFightBuffOneMatch()
    {
    }

    public string GetFightFootballStyle(int team)
    {
      return team == 1 ? this.RedFightFootballStyle : this.BlueFightFootballStyle;
    }

    public void UpdatePveResult(string type, int value, bool isWin)
    {
    }

    public double GetBaseBlood() => this.double_5;

    public void UpdateBarrier(int barrier, string pic)
    {
    }

    public int DragonBoatAddExpPlus() => this.int_2;

    public bool DragonBoatOpen() => this.bool_1;

    public string TcpEndPoint() => this.string_0;

    public int AddBoatScore(int score) => score;

    public void FootballTakeOut(bool isWin)
    {
      this.serverClient_0.SendFootballTakeOut(this.PlayerCharacter.ID, isWin);
    }

    public int AddGP(int gp)
    {
      if (gp > 0)
        this.serverClient_0.SendPlayerAddGP(this.PlayerCharacter.ID, gp);
      return (int) (this.double_0 * (double) gp);
    }

    public int RemoveGP(int gp)
    {
      this.serverClient_0.SendPlayerRemoveGP(this.PlayerCharacter.ID, gp);
      return gp;
    }

    public int AddGold(int value)
    {
      if (value > 0)
        this.serverClient_0.SendPlayerAddGold(this.PlayerCharacter.ID, value);
      return value;
    }

    public int AddHonor(int value) => value;

    public int AddDamageScores(int value) => value;

    public int RemoveGold(int value)
    {
      this.serverClient_0.SendPlayerRemoveGold(this.playerInfo_0.ID, value);
      return 0;
    }

    public bool ClearPropItem() => true;

    public void ResetRoom(bool isWin, bool nextMission)
    {
    }

    public int AddMoney(int value)
    {
      if (value > 0)
        this.serverClient_0.SendPlayerAddMoney(this.playerInfo_0.ID, value);
      return value;
    }

    public int AddActiveMoney(int value)
    {
      if (value > 0)
        this.serverClient_0.SendPlayerAddActiveMoney(this.playerInfo_0.ID, value);
      return value;
    }

    public int RemoveMoney(int value)
    {
      this.serverClient_0.SendPlayerRemoveMoney(this.playerInfo_0.ID, value);
      return 0;
    }

    public int AddGiftToken(int value)
    {
      if (value > 0)
        this.serverClient_0.SendPlayerAddGiftToken(this.playerInfo_0.ID, value);
      return value;
    }

    public bool RemoveHealstone()
    {
      this.serverClient_0.SendPlayerRemoveHealstone(this.playerInfo_0.ID);
      return false;
    }

    public int AddMedal(int value)
    {
      if (value > 0)
        this.serverClient_0.SendPlayerAddMedal(this.playerInfo_0.ID, value);
      return value;
    }

    public int AddLeagueMoney(int value)
    {
      if (value > 0)
        this.serverClient_0.SendPlayerAddLeagueMoney(this.playerInfo_0.ID, value);
      return value;
    }

    public void AddPrestige(bool isWin, eRoomType roomType)
    {
      this.serverClient_0.SendPlayerAddPrestige(this.playerInfo_0.ID, isWin, roomType);
    }

    public void RingstationResult(bool isWin)
    {
      this.serverClient_0.SendRingstationResult(this.playerInfo_0.ID, isWin);
    }

    public void UpdateRestCount() => this.serverClient_0.SendUpdateRestCount(this.playerInfo_0.ID);

    public int RemoveGiftToken(int value) => 0;

    public int RemoveMedal(int value) => 0;

    public int AddHardCurrency(int value) => 0;

    public bool isDoubleAward() => false;

    public void UpdateLabyrinth(int currentFloor, int m_missionInfoId, bool bigAward)
    {
    }

    public void OutLabyrinth()
    {
    }

    public int AddOffer(int baseoffer)
    {
      return baseoffer < 0 ? baseoffer : (int) ((double) baseoffer * this.double_1 * this.m_antiAddictionRate);
    }

    public int RemoveOffer(int value)
    {
      this.serverClient_0.SendPlayerRemoveOffer(this.playerInfo_0.ID, value);
      return value;
    }

    public void LogAddMoney(
      AddMoneyType masterType,
      AddMoneyType sonType,
      int userId,
      int moneys,
      int SpareMoney)
    {
    }

    public bool UsePropItem(AbstractGame game, int bag, int place, int templateId, bool isLiving)
    {
      this.serverClient_0.SendPlayerUsePropInGame(this.PlayerCharacter.ID, bag, place, templateId, isLiving);
      game.Pause(500);
      return false;
    }

    public void OnGameOver(AbstractGame game, bool isWin, int gainXp)
    {
      this.serverClient_0.SendPlayerOnGameOver(this.PlayerCharacter.ID, game.Id, isWin, gainXp);
    }

    public void Disconnect() => this.serverClient_0.SendDisconnectPlayer(this.playerInfo_0.ID);

    public void SendTCP(GSPacketIn pkg)
    {
      this.serverClient_0.SendPacketToPlayer(this.playerInfo_0.ID, pkg);
    }

    public void OnKillingLiving(AbstractGame game, int type, int id, bool isLiving, int demage)
    {
      this.serverClient_0.SendPlayerOnKillingLiving(this.playerInfo_0.ID, game, type, id, isLiving, demage);
    }

    public void OnMissionOver(AbstractGame game, bool isWin, int MissionID, int turnNum)
    {
      this.serverClient_0.SendPlayerOnMissionOver(this.playerInfo_0.ID, game, isWin, MissionID, turnNum);
    }

    public int ConsortiaFight(
      int consortiaWin,
      int consortiaLose,
      Dictionary<int, Player> players,
      eRoomType roomType,
      eGameType gameClass,
      int totalKillHealth,
      int count)
    {
      this.serverClient_0.SendPlayerConsortiaFight(this.playerInfo_0.ID, consortiaWin, consortiaLose, players, roomType, gameClass, totalKillHealth);
      return 0;
    }

    public void SendConsortiaFight(int consortiaID, int riches, string msg)
    {
      this.serverClient_0.SendPlayerSendConsortiaFight(this.playerInfo_0.ID, consortiaID, riches, msg);
    }

    public bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count, eGameView typeGet)
    {
      this.serverClient_0.SendPlayerAddTemplate(this.playerInfo_0.ID, cloneItem, bagType, count);
      return true;
    }

    public void OutLabyrinth(bool isWin)
    {
    }

    public void SendMessage(string msg)
    {
      GSPacketIn pkg = new GSPacketIn((short) 3);
      pkg.WriteInt(0);
      pkg.WriteString(msg);
      this.SendTCP(pkg);
    }

    public void SendHideMessage(string msg)
    {
      GSPacketIn pkg = new GSPacketIn((short) 3);
      pkg.WriteInt(3);
      pkg.WriteString(msg);
      this.SendTCP(pkg);
    }

    public bool IsPvePermission(int missionId, eHardLevel hardLevel) => true;

    public bool SetPvePermission(int missionId, eHardLevel hardLevel) => true;

    public void SendInsufficientMoney(int type)
    {
    }

    public bool ClearTempBag() => true;

    public bool ClearFightBag() => true;
  }
}
