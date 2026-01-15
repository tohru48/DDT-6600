// Decompiled with JetBrains decompiler
// Type: Game.Logic.IGamePlayer
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Base.Packets;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

#nullable disable
namespace Game.Logic
{
  public interface IGamePlayer
  {
    int ZoneId { get; }

    string ZoneName { get; }

    PlayerInfo PlayerCharacter { get; }

    UserMatchInfo MatchInfo { get; }

    BatleConfigInfo BatleConfig { get; }

    ItemInfo MainWeapon { get; }

    ItemInfo SecondWeapon { get; }

    ItemInfo Healstone { get; }

    string ProcessLabyrinthAward { get; set; }

    UsersPetinfo Pet { get; }

    int[] HorseSkillEquip { get; }

    bool CanUseProp { get; set; }

    bool IsCrossZone { get; set; }

    int GamePlayerId { get; set; }

    long WorldbossBood { get; }

    long AllWorldDameBoss { get; }

    int ServerID { get; set; }

    List<ItemInfo> EquipEffect { get; }

    List<BufferInfo> FightBuffs { get; }

    double BaseAttack { get; }

    double BaseDefence { get; }

    int AddSummerScore(int value);

    bool RemoveHealstone();

    int DragonBoatAddExpPlus();

    bool DragonBoatOpen();

    string TcpEndPoint();

    bool isDoubleAward();

    void ClearFightBuffOneMatch();

    bool ClearPropItem();

    double GetBaseBlood();

    void UpdateBarrier(int barrier, string pic);

    void FootballTakeOut(bool isWin);

    int AddGP(int gp);

    int RemoveGP(int gp);

    bool UseKingBlessHelpStraw(eRoomType roomType);

    bool RemoveMissionEnergy(int value);

    int AddGold(int value);

    int RemoveGold(int value);

    bool MissionEnergyEmpty(int value);

    int AddMoney(int value);

    int AddActiveMoney(int value);

    int RemoveMoney(int value);

    string GetFightFootballStyle(int team);

    int AddGiftToken(int value);

    int RemoveGiftToken(int value);

    int AddHardCurrency(int value);

    int AddMedal(int value);

    int RemoveMedal(int value);

    int AddHonor(int value);

    int AddBoatScore(int value);

    int AddDamageScores(int value);

    int AddLeagueMoney(int value);

    void AddPrestige(bool isWin, eRoomType roomType);

    void RingstationResult(bool isWin);

    int AddOffer(int value);

    int AddEnterModePoint(int value);

    int RemoveOffer(int value);

    bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count, eGameView gameView);

    void UpdatePveResult(string type, int value, bool isWin);

    bool ClearTempBag();

    bool ClearFightBag();

    void ResetRoom(bool isWin, bool nextMission);

    bool UsePropItem(AbstractGame game, int bag, int place, int templateId, bool isLiving);

    void OnKillingLiving(AbstractGame game, int type, int id, bool isLiving, int demage);

    void OnGameOver(AbstractGame game, bool isWin, int gainXp);

    void OnMissionOver(AbstractGame game, bool isWin, int MissionID, int TurnNum);

    int ConsortiaFight(
      int consortiaWin,
      int consortiaLose,
      Dictionary<int, Player> players,
      eRoomType roomType,
      eGameType gameClass,
      int totalKillHealth,
      int count);

    void SendConsortiaFight(int consortiaID, int riches, string msg);

    void CreateRandomEnterModeItem();

    bool SetPvePermission(int missionId, eHardLevel hardLevel);

    bool IsPvePermission(int missionId, eHardLevel hardLevel);

    void Disconnect();

    void UpdateRestCount();

    void SendInsufficientMoney(int type);

    void UpdateLabyrinth(int currentFloor, int m_missionInfoId, bool bigAward);

    void OutLabyrinth(bool isWin);

    void SendMessage(string msg);

    void SendHideMessage(string msg);

    void SendTCP(GSPacketIn pkg);

    void LogAddMoney(
      AddMoneyType masterType,
      AddMoneyType sonType,
      int userId,
      int moneys,
      int SpareMoney);
  }
}
